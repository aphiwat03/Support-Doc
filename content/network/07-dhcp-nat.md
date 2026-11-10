---
slug: network-dhcp-nat
title: ระบบแจกไอพี DHCP และการแปลงแอดเดรส NAT/PAT (DHCP & Network Address Translation)
summary: ขั้นตอนการขอ IP (DORA Process), อายุสัญญา Lease Time, ข้อผิดพลาด APIPA (169.254.x.x), กลไก DHCP Relay, และความแตกต่างของ Static NAT, Dynamic NAT และ PAT (NAT Overload)
read_time_minutes: 10
difficulty: intermediate
display_order: 7
---

# ระบบแจกไอพี DHCP และการแปลงแอดเดรส NAT/PAT

ในงาน Support ปัญหาเครือข่ายกว่า 40% ที่ผู้ใช้ทั่วไปหรือเซิร์ฟเวอร์เปิดใหม่ต่อเน็ตไม่ได้ เกิดจากสองเรื่องนี้: **ขอไอพีไม่ได้ (DHCP Failure)** หรือ **วิ่งออกสู่อินเทอร์เน็ตไม่ได้ (NAT Failure)** การเข้าใจกลไกและขั้นตอนเบื้องหลังจะช่วยให้คุณวิเคราะห์ปัญหาได้ในเวลาไม่กี่นาที

---

## 1. การทำงานของ DHCP และขั้นตอน 4 สเต็ป: DORA Process

**DHCP (Dynamic Host Configuration Protocol)** ทำงานบนโปรโตคอล **UDP พอร์ต 67 (Server) และ 68 (Client)** ทำหน้าที่จ่าย IP Address, Subnet Mask, Default Gateway และ DNS Server ให้เครื่องลูกข่ายโดยอัตโนมัติ

เมื่อเครื่องคอมพิวเตอร์หรือเซิร์ฟเวอร์เปิดเครื่องขึ้นมา จะขอ IP ตามลำดับ **D-O-R-A**:

![แผนภาพขั้นตอนการขอไอพีด้วย DHCP แบบ DORA Process](/images/network/dhcp-dora-flow.png)

1. **Discover (Broadcast)**: เครื่องลูกข่ายยังไม่มี IP จึงส่งเฟรม Broadcast ออกไปทั้งเครือข่าย  
   - Source IP: `0.0.0.0` | Destination IP: `255.255.255.255`  
   - ใจความ: *"มี DHCP Server อยู่ในวงนี้ไหม? ฉันต้องการ IP Address"*
2. **Offer (Unicast หรือ Broadcast)**: DHCP Server ได้รับ จึงตอบกลับพร้อมเสนอไอพีที่ว่างอยู่  
   - ใจความ: *"ฉันคือ DHCP Server เสนอให้ใช้ IP 192.168.1.50 นะ"*
3. **Request (Broadcast)**: เครื่องลูกข่ายตอบรับเพื่อยืนยันขอใช้ไอพีนั้น  
   - ใจความ: *"ตกลง ฉันขอรับ IP 192.168.1.50 จาก DHCP Server ตัวนี้นะ"* (ส่งแบบ Broadcast เพื่อให้ DHCP Server ตัวอื่นที่ส่ง Offer มาทราบว่าเครื่องเลือกข้อเสนอของใคร)
4. **Acknowledge / ACK (Unicast หรือ Broadcast)**: DHCP Server ยืนยันสัญญาสุดท้าย  
   - ใจความ: *"บันทึกข้อมูลแล้ว คุณสามารถใช้ IP 192.168.1.50 ได้เป็นเวลา 24 ชั่วโมง (Lease Time)"*

---

## 2. ปัญหาคลาสสิกของ DHCP ที่ต้องจำให้ขึ้นใจ

### 1) ได้ไอพีแปลกประหลาด: 169.254.x.x (APIPA)
หากเปิดเครื่องแล้วรันคำสั่ง `ip addr` หรือ `ipconfig` แล้วพบว่าได้ไอพีขึ้นต้นด้วย **`169.254.x.x`**:
- นี่คือ **APIPA (Automatic Private IP Addressing)**
- **ความหมายทันที**: เครื่องของคุณ **ไม่ได้รับสัญญาณตอบกลับจาก DHCP Server** (DHCP ขอไม่สำเร็จ) ระบบปฏิบัติการจึงสุ่มไอพีนี้มาให้เพื่อใช้สื่อสารเฉพาะกิจในเครื่องข้างเคียง
- **สาเหตุที่เป็นไปได้**:
  - สายแลนเสียบผิด VLAN หรือพอร์ตสวิตช์ไม่ได้ต่อกับ DHCP
  - DHCP Server ล่ม หรือ **DHCP Pool เต็ม** (ไม่มีไอพีว่างเหลือแจก)
  - มี Firewall บล็อก UDP พอร์ต 67/68

### 2) DHCP Relay Agent (ip helper-address)
DHCP Discover ส่งแบบ **Broadcast** ซึ่งเราเตอร์จะไม่ยอมให้ Broadcast วิ่งข้ามวง (ข้าม Subnet):
- หากเครื่องลูกข่ายอยู่ VLAN 10 แต่เครื่อง DHCP Server อยู่ใน Server Farm VLAN 100 ➔ ลูกข่ายจะขอไอพีไม่ได้
- **ทางแก้**: ต้องคอนฟิกฟังก์ชัน **DHCP Relay (บน Cisco คือคำสั่ง `ip helper-address <IP_DHCP_Server>`)** ไว้ที่ Interface Gateway ของเราเตอร์ เพื่อให้เราเตอร์แปลง Broadcast นั้นเป็น Unicast ส่งตรงไปยัง DHCP Server ข้ามวงได้

```text
! ตัวอย่างการตั้งค่า DHCP Relay บน Cisco Router / L3 Switch
Router(config)# interface vlan 10
Router(config-if)# ip address 192.168.10.1 255.255.255.0
Router(config-if)# ip helper-address 10.0.0.100
Router(config-if)# exit
```

---

## 3. ทำความรู้จัก NAT (Network Address Translation)

IPv4 มีจำนวนจำกัดเพียงประมาณ 4.3 พันล้านหมายเลข ไม่เพียงพอกับอุปกรณ์ทั่วโลก จึงต้องแบ่งเป็น **Private IP** (เช่น `192.168.x.x`, `10.x.x.x`, `172.16-31.x.x`) และ **Public IP** (ไอพีจริงบนอินเทอร์เน็ต)

**NAT** คือกระบวนการที่ทำหน้าที่ **แปลง Private IP เป็น Public IP** เมื่อข้อมูลจะวิ่งออกสู่อินเทอร์เน็ต และแปลงกลับเมื่อข้อมูลตอบกลับมา

![แผนภาพเปรียบเทียบการทำงานของ NAT และ PAT ในการแปลงแอดเดรส](/images/network/nat-pat-diagram.png)

### ประเภทของ NAT 3 รูปแบบ:

| ประเภท NAT | หลักการทำงาน | กรณีใช้งานจริง |
|---|---|---|
| **Static NAT (1-to-1)** | แมปปิ้ง 1 Private IP คู่กับ 1 Public IP แบบถาวร | เซิร์ฟเวอร์ในศูนย์ข้อมูลที่ต้องการให้ภายนอกยิงเข้ามาหาได้ เช่น Web Server หรือ Mail Server |
| **Dynamic NAT (Pool-to-Pool)** | มีกลุ่ม Public IP (Pool) ว่างอยู่ ใครต่อออกเน็ตก่อนก็ยืมไปใช้ เมื่อเลิกใช้ก็คืน Pool | ไม่ค่อยนิยมแล้วในปัจจุบัน |
| **PAT / NAT Overload (Many-to-One)** | อุปกรณ์นับร้อยนับพันเครื่องในบ้านหรือองค์กร **ใช้ Public IP จริงเพียงเบอร์เดียวพร้อมกันได้** โดยอาศัยการจำแนกด้วย **Port Number (เช่น พอร์ต 50001, 50002)** | ใช้งานในบ้าน สำนักงาน ออฟฟิศ และ Cloud VPC (NAT Gateway) |

---

## 4. กลไกของ PAT (Port Address Translation / NAT Overload)

ทำไมมือถือ คอมพิวเตอร์ และสมาร์ตทีวีในบ้าน 20 เครื่อง ออกอินเทอร์เน็ตผ่านเราเตอร์ตัวเดียวที่มี Public IP เดียวได้พร้อมกัน?

1. เครื่องลูกข่าย A (`192.168.1.10:52134`) ส่งคำขอเปิดเว็บ `8.8.8.8:443`
2. เราเตอร์ (NAT Gateway) ทำการแปลง Source:
   - แปลง IP ต้นทางจาก `192.168.1.10` ➔ เป็น Public IP `203.0.113.5`
   - สุ่ม Port ภายนอกขึ้นมา เช่น `61001`
   - จดลง **NAT Translation Table**: `192.168.1.10:52134 <--> 203.0.113.5:61001`
3. เว็บปลายทางตอบกลับมาหา `203.0.113.5:61001`
4. เราเตอร์เปิดตารางดู พบว่าพอร์ต `61001` เป็นของเครื่อง A จึงแปลงปลายทางกลับเป็น `192.168.1.10:52134` แล้วส่งต่อไปยังเครื่อง A ได้อย่างถูกต้อง

```bash
# ตรวจสอบ Public IP ที่เครื่องของคุณออกเน็ต ณ ปัจจุบัน
curl -s ifconfig.me
# หรือ
curl -s api.ipify.org

# ดูรายละเอียดตาราง NAT บนเราเตอร์ Cisco
Router# show ip nat translations
Pro Inside global      Inside local       Outside local      Outside global
tcp 203.0.113.5:61001  192.168.1.10:52134 8.8.8.8:443        8.8.8.8:443
```

---

## 5. สรุป Checklist วิเคราะห์ปัญหา DHCP และ NAT

| อาการที่ตรวจพบ | ข้อวินิจฉัย | แนวทางแก้ไข |
|---|---|---|
| เครื่องได้ไอพี `169.254.x.x` | ขอ DHCP ไม่สำเร็จ | ตรวจสอบสายแลน, ตรวจสอบสถานะ DHCP Service, ตรวจสอบว่า IP Pool เต็มหรือไม่ |
| ได้ไอพีปกติ ปิง Default Gateway ติด แต่เปิดเว็บไม่ได้และปิง `8.8.8.8` ไม่ติด | NAT หรือ Routing ขาออกมีปัญหา | ตรวจสอบคอนฟิก NAT บน Router / Firewall ว่ามีการเปิด Overload ให้ Subnet นี้หรือไม่ |
| ปิง `8.8.8.8` ติด แต่เปิดเว็บไม่ได้ | ไม่เกี่ยวกับ NAT เป็นปัญหาที่ DNS | ตรวจสอบไฟล์ `/etc/resolv.conf` ว่าระบุ Nameserver ถูกต้องหรือไม่ |
| เครื่องจากภายนอกเข้า Web Server ภายในไม่ได้ | ไม่ได้ทำ Port Forwarding หรือ Static NAT | คอนฟิก Static NAT หรือ Port Forwarding จาก Public IP พอร์ต 80/443 ไปยัง Private IP ของเซิร์ฟเวอร์ |
