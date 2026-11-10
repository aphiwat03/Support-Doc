---
slug: network-layer1-2-problems
title: ถอดรหัสปัญหา Layer 1 และ Layer 2 หน้างาน (L1/L2 Troubleshooting & Storms)
summary: อาการและวิธีแก้ปัญหา Duplex Mismatch (Half vs Full), การอ่านเคาน์เตอร์ CRC/Input Errors, ปัญหา Port Flapping, Loop ในสวิตช์และ Broadcast Storm (STP), รวมถึงการรวมสายด้วย LACP (Port-Channel)
read_time_minutes: 11
difficulty: intermediate
display_order: 9
---

# ถอดรหัสปัญหา Layer 1 และ Layer 2 หน้างาน

ปัญหาเครือข่ายที่ชวนปวดหัวที่สุดไม่ใช่เรื่อง Routing หรือ Firewall แต่คือปัญหา **สัญญาณติดๆ ดับๆ ความเร็วตกฮวบ หรือระบบสวิตช์ค้างทั้งตึก** อาการเหล่านี้กว่า 80% เกิดจากความผิดปกติใน **Layer 1 (Physical)** และ **Layer 2 (Data Link)** ซึ่งช่างเทคนิคและวิศวกร Support ต้องสังเกตอาการและชี้จุดตายให้ขาด

---

## 1. วิกฤต Duplex Mismatch (Half-Duplex vs Full-Duplex)

หนึ่งในปัญหาคลาสสิกที่ทำให้เครือข่ายใช้งานได้แต่ *"ช้าเหมือนเต่าคลาน"* (ส่งไฟล์ไม่กี่ MB แต่ใช้เวลาเป็นชั่วโมง) คือ **Duplex Mismatch**:

- **Full-Duplex**: ส่งและรับข้อมูลได้พร้อมกันในเวลาเดียวกัน (โทรศัพท์สองทาง)
- **Half-Duplex**: ส่งหรือรับได้ทีละฝั่งเท่านั้น หากส่งพร้อมกันจะเกิดการชนกันของสัญญาณ (**Collision**) เหมือนวิทยุสื่อสาร วอ.

### อาการเกิดขึ้นได้อย่างไร?
ตามมาตรฐาน Ethernet มีระบบ **Auto-Negotiation (เจรจาความเร็วและ Duplex อัตโนมัติ)**:
- หากฝั่งหนึ่งตั้งค่าเป็น `Auto` แต่อีกฝั่งหนึ่งถูกแอดมิน **Hardcode (Force)** ให้เป็น `1000Mbps Full-Duplex`
- ฝั่งที่เป็น Auto จะไม่สามารถตรวจจับ Duplex ของอีกฝั่งได้ ตามมาตรฐานมันจะ Fallback ลงไปเป็น **Half-Duplex ทันทีเพื่อความปลอดภัย!**
- **ผลลัพธ์ที่ตามมา**:
  - ฝั่ง Full-Duplex ส่งข้อมูลเมื่อไหร่ก็ได้ เพราะไม่คิดว่าจะมีการชนกัน
  - ฝั่ง Half-Duplex คิดว่ามีการชนกันของสัญญาณ จึงส่งสัญญาณ Jamming และสั่งหยุดส่ง ทำให้เกิด **Late Collisions** และ Packet Loss มหาศาลเมื่อมี Traffic เยอะ!

```text
! อาการในคำสั่ง show interfaces:
Switch# show interfaces Gi0/1
  Full-duplex, 100Mb/s, media type is 10/100/1000BaseTX
  ...
  15200 late collision, 420 deferred
```

> **กฎเหล็กเรื่อง Duplex**: หากจะตั้ง ให้ตั้งเป็น **Auto/Auto ทั้งสองฝั่ง** หรือหากจำเป็นต้องฟิกซ์ ให้ **Hardcode Speed และ Duplex ให้ตรงกันทั้งสองฝั่ง 100%** ห้ามตั้ง Auto ฝั่งหนึ่งและ Force อีกฝั่งหนึ่งเด็ดขาด

---

## 2. ปัญหา Port Flapping (พอร์ตติดๆ ดับๆ)

**Port Flapping** คืออาการที่พอร์ตสวิตช์ขึ้นสถานะ **UP** แล้วสลับเป็น **DOWN** วนลูปต่อเนื่องหลายสิบครั้งต่อนาที:

```text
%LINK-3-UPDOWN: Interface GigabitEthernet0/5, changed state to up
%LINEPROTO-5-UPDOWN: Line protocol on Interface GigabitEthernet0/5, changed state to up
%LINK-3-UPDOWN: Interface GigabitEthernet0/5, changed state to down
%LINEPROTO-5-UPDOWN: Line protocol on Interface GigabitEthernet0/5, changed state to down
```

### ผลกระทบ:
- เครื่องเซิร์ฟเวอร์หลุดการเชื่อมต่อเป็นระยะ
- ทำให้โปรโตคอล Spanning Tree (STP) และ Routing ทำการคำนวณใหม่ (Topology Change Notification - TCN) ตลอดเวลา ส่งผลให้สวิตช์ตัวอื่นในเครือข่าย CPU พุ่งสูง 100%!

### สาเหตุและวิธีตรวจสอบ:
1. **สายสัญญาณหลวมหรือหักใน**: ลองขยับหัว RJ45 หรือเปลี่ยนสาย Patch Cord เส้นใหม่
2. **แสงไฟเบอร์อ่อน (Low Optical Power)**: หัวไฟเบอร์สกปรก หรือสายไฟเบอร์ถูกงอเกินรัศมีโค้งงอ (Bend Radius) ให้ใช้คำสั่ง `show interfaces transceiver detail` ดูค่า **Rx Optical Power (dBm)** หากต่ำกว่า -18 dBm แสงจะเริ่มขาดช่วง
3. **โมดูล SFP ชำรุดหรือร้อนเกินไป**: ลองสลับเปลี่ยนหัว SFP ตัวใหม่

---

## 3. มหาภัยพิบัติ Switching Loop และ Broadcast Storm

ในระบบ Ethernet เฟรม Layer 2 **ไม่มีฟิลด์ TTL (Time-to-Live)** เหมือนกับ IP Packet ใน Layer 3:
- หากใครสักคนเผลอเสียบสาย LAN จากพอร์ตหนึ่งของสวิตช์ วนกลับเข้าไปอีกพอร์ตหนึ่งของสวิตช์เดียวกัน หรือเชื่อมสวิตช์สองตัวเข้าด้วยกันด้วยสายคู่โดยไม่ได้ทำ Link Aggregation
- เมื่อมีเฟรม Broadcast (เช่น ARP Request หรือ DHCP Discover) ส่งเข้ามา สวิตช์จะส่งกระจายออกทุกพอร์ต (Flooding) วนกลับมาหาตัวมันเอง และส่งกระจายซ้ำทวีคูณเป็นล้านๆ เฟรมต่อวินาที!
- อาการนี้เรียกว่า **Broadcast Storm (พายุบรอดคาสต์)**:
  - ไฟสถานะทุกพอร์ตบนสวิตช์จะ **กะพริบถี่พร้อมกันจนเกือบเป็นไฟค้าง**
  - CPU สวิตช์พุ่งแตะ 100% จนหยุดตอบสนอง
  - ระบบเครือข่ายของทั้งออฟฟิศหรือ Data Center จะล่มสนิททันที

![แผนภาพการเกิด Switching Loop และการป้องกันด้วย Spanning Tree Protocol](/images/network/stp-loop-broadcast-storm.png)

### ฮีโร่ผู้พิทักษ์: Spanning Tree Protocol (STP / RSTP - 802.1w)
STP ทำหน้าที่ตรวจจับ Loop ในสวิตช์ โดยจะส่งแพ็กเก็ตพิเศษที่ชื่อว่า **BPDU (Bridge Protocol Data Unit)**:
- หากพบว่ามีเส้นทางสำรองที่ทำให้เกิด Loop สวิตช์จะสั่งให้พอร์ตหนึ่งเข้าสู่สถานะ **Blocking (หรือ Discarding)** เพื่อตัดวงจรไม่ให้เกิด Loop
- หากสายเส้นหลักขาด STP จะปลดบล็อกพอร์ตสำรองกลับมาเป็น **Forwarding** อัตโนมัติ (RSTP ใช้เวลาเพียง 1-2 วินาที)

#### ฟีเจอร์ความปลอดภัย STP ที่ต้องรู้จัก:
- **PortFast**: เปิดใช้กับพอร์ตที่ต่อเครื่องลูกข่าย/เซิร์ฟเวอร์เท่านั้น เพื่อให้พอร์ตเปลี่ยนเป็น Forwarding ทันทีโดยไม่ต้องรอตรวจ STP 30 วินาที
- **BPDU Guard**: หากเปิด PortFast ต้องเปิด BPDU Guard ควบคู่เสมอ หากมีใครแอบเอาสวิตช์ตัวอื่นมาเสียบเข้าพอร์ตนี้ พอร์ตจะสั่งตัดไฟและเข้าสู่สถานะ `err-disabled` ทันทีเพื่อป้องกัน Loop!

```text
! คอนฟิก PortFast และ BPDU Guard บนพอร์ตที่ต่อเซิร์ฟเวอร์
Switch(config-if)# spanning-tree portfast
Switch(config-if)# spanning-tree bpduguard enable
```

---

## 4. รวมสายเพิ่มความเร็วและป้องกัน Loop ด้วย LACP (Link Aggregation)

หากเราต้องการต่อสาย 2 หรือ 4 เส้นระหว่าง Server กับ Switch เพื่อเพิ่ม Bandwidth จาก 1Gbps เป็น 2Gbps หรือทำ Redundancy สำรองสาย หากเสียบสายตรงๆ STP จะบล็อกสายเส้นที่สองทิ้ง!

**ทางแก้**: ต้องรวมพอร์ตทางกายภาพหลายพอร์ต ให้ทำหน้าที่เสมือนเป็นพอร์ตตรรกะพอร์ตเดียว เรียกว่า **Port-Channel (หรือ NIC Teaming / Bonding)** โดยใช้โปรโตคอลมาตรฐาน **LACP (Link Aggregation Control Protocol - IEEE 802.3ad)**

```text
! รวมพอร์ต Gi0/1 และ Gi0/2 เข้าสู่ Port-Channel 1 ด้วย LACP
Switch(config)# interface range GigabitEthernet0/1 - 2
Switch(config-if-range)# channel-group 1 mode active
Switch(config-if-range)# exit

! ตรวจสอบสถานะการรวมสาย LACP
Switch# show etherchannel summary
Group  Port-channel  Protocol    Ports
------+-------------+-----------+-----------------------------------------------
1      Po1(SU)         LACP      Gi0/1(P)    Gi0/2(P)
```
- **`SU`**: **S**witch, **U**p in use (ทำงานสมบูรณ์)
- **`P`**: Bundled in **P**ort-channel (พอร์ตรวมสายสำเร็จ)
- หากขึ้นสถานะ **`D` (Down)** หรือ **`I` (Individual)** แสดงว่าการตั้งค่าของพอร์ตทั้งสองฝั่งไม่ตรงกัน (เช่น Speed, Duplex, หรือ VLAN ต่างกัน)
