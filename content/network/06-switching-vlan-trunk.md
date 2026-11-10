---
slug: network-switching-vlan-trunk
title: การทำงานของ Switch, ARP, VLAN และ Trunk 802.1Q (Switching & VLANs)
summary: กลไก MAC Address Table, Address Resolution Protocol (ARP), การแบ่งกลุ่ม Network ด้วย VLAN, โหมดพอร์ต Access vs Trunk, Native VLAN และ Inter-VLAN Routing
read_time_minutes: 10
difficulty: intermediate
display_order: 6
---

# การทำงานของ Switch, ARP, VLAN และ Trunk 802.1Q

ในเครือข่ายระดับองค์กรและศูนย์ข้อมูล (Data Center) อุปกรณ์ที่มีจำนวนพอร์ตมากที่สุดคือ **Network Switch** ทำหน้าที่เชื่อมโยงเครื่องเซิร์ฟเวอร์ พีซี และเราเตอร์เข้าด้วยกัน การเข้าใจว่าสวิตช์เรียนรู้เส้นทางอย่างไร และทำไมต้องแบ่ง **VLAN** เป็นความรู้ภาคบังคับที่ผู้ดูแลระบบทุกคนต้องเข้าใจอย่างถ่องแท้

---

## 1. กลไกการทำงานของ Switch: MAC Address Table

สวิตช์ Layer 2 ไม่สนใจ IP Address แต่มันส่งต่อข้อมูลด้วย **MAC Address (48-bit Physical Address)** ผ่านตารางจับคู่ที่เรียกว่า **MAC Address Table (หรือ CAM Table)**:

### กระบวนการ 3 ขั้นตอนของ Switch:
1. **Learning (เรียนรู้)**: เมื่อมี Frame วิ่งเข้ามาที่พอร์ตใดพอร์ตหนึ่ง สวิตช์จะดู **Source MAC Address** ใน Frame ทันที แล้วจดบันทึกลงตารางว่า *"MAC Address นี้ ต่ออยู่กับพอร์ตไหน (และอยู่ใน VLAN อะไร)"*
2. **Forwarding (ส่งต่อแบบเจาะจง)**: หากสวิตช์รู้จัก **Destination MAC Address** อยู่แล้วในตาราง มันจะส่ง Frame นั้นออกไปที่พอร์ตปลายทางเพียงพอร์ตเดียว (Unicast)
3. **Flooding (ส่งกระจายทุกพอร์ต)**: หาก Destination MAC Address ยังไม่อยู่ในตาราง (Unknown Unicast) หรือเป็น Broadcast (`FF:FF:FF:FF:FF:FF`) สวิตช์จะส่ง Frame นั้นออกไป **ทุกพอร์ตที่อยู่ใน VLAN เดียวกัน** (ยกเว้นพอร์ตที่รับเข้ามา)

```bash
# ตรวจสอบ MAC Address Table บน Cisco Switch
Switch# show mac address-table
          Mac Address Table
-------------------------------------------
Vlan    Mac Address       Type        Ports
----    -----------       --------    -----
  10    5254.0012.3456    DYNAMIC     Gi0/1
  10    5254.00ab.cdef    DYNAMIC     Gi0/2
  20    5254.0099.8877    DYNAMIC     Gi0/5
```

---

## 2. ARP (Address Resolution Protocol): ตัวเชื่อม IP กับ MAC

เนื่องจากแอปพลิเคชันต้องการส่งข้อมูลไปยัง IP Address (Layer 3) แต่การ์ดแลนในระบบ Ethernet ส่งข้อมูลด้วย MAC Address (Layer 2) จึงต้องมีโปรโตคอล **ARP** ทำหน้าที่ถามหาว่า: *"IP นี้ คือ MAC Address อะไร?"*

### ขั้นตอนการทำงานของ ARP:
1. เครื่อง A (192.168.1.10) ต้องการส่งข้อมูลหาเครื่อง B (192.168.1.20) แต่ยังไม่รู้ MAC Address ของ B
2. เครื่อง A ส่ง **ARP Request (Broadcast)** กระจายทั่วทั้งเครือข่าย: *"ใครถือ IP 192.168.1.20 ช่วยบอก MAC Address ให้ 192.168.1.10 ทราบที"*
3. ทุกเครื่องในวงได้รับ แต่เฉพาะเครื่อง B ที่ถือ IP นั้น จะตอบกลับเป็น **ARP Reply (Unicast)**: *"ฉันเอง 192.168.1.20 MAC ของฉันคือ 00:1a:2b:3c:4d:5e"*
4. เครื่อง A จดบันทึกคู่นี้ไว้ใน **ARP Cache** ของตนเอง เพื่อไม่ต้องถามใหม่อีกในระยะเวลาหนึ่ง

```bash
# บนเซิร์ฟเวอร์ Linux ดูตาราง ARP Cache
ip neigh show
# หรือคำสั่งดั้งเดิม
arp -an

# ลบ ARP Cache ในกรณีที่เปลี่ยนการ์ดแลนหรือไอพีแล้วข้อมูลค้าง
ip neigh flush all
```

---

## 3. ทำไมต้องแบ่ง VLAN (Virtual Local Area Network)?

หากไม่มี VLAN ทุกเครื่องที่เสียบสายเข้าสวิตช์จะอยู่ใน **Broadcast Domain เดียวกัน**:
- หากมีเครื่องใดติดไวรัสหรือส่ง Broadcast มหาศาล ทุกเครื่องในองค์กรจะต้องรับฟัง ส่งผลให้เครือข่ายอืด (Network Congestion)
- ขาดความปลอดภัย ฝ่ายบุคคล การเงิน และเซิร์ฟเวอร์ฐานข้อมูลสามารถดักฟังแพ็กเก็ตของกันและกันได้

**VLAN** คือการตัดแบ่งสวิตช์ตัวจริง 1 ตัว ให้ทำหน้าที่เสมือนมีสวิตช์เสมือนหลายตัวแยกขาดจากกัน:
- **เครื่องที่อยู่ต่าง VLAN กัน จะไม่สามารถคุยกันได้โดยตรงที่ Layer 2** (แม้จะเสียบสวิตช์ตัวเดียวกัน)
- หากต้องการให้ต่าง VLAN คุยกัน ต้องส่งผ่าน **Router หรือ Layer 3 Switch (เรียกว่า Inter-VLAN Routing)**

![การเชื่อมต่อระหว่าง Switch ด้วยพอร์ต Access และ Trunk 802.1Q](/images/network/vlan-access-trunk.png)

---

## 4. โหมดของพอร์ต Switch: Access Port vs Trunk Port

เมื่อคอนฟิกพอร์ตบนสวิตช์ จะต้องระบุว่าพอร์ตนั้นทำหน้าที่เป็น **Access** หรือ **Trunk**:

| คุณสมบัติ | Access Port | Trunk Port (Tagging) |
|---|---|---|
| **อุปกรณ์ที่นำมาเชื่อมต่อ** | เครื่องลูกข่าย, เซิร์ฟเวอร์ทั่วไป, พรินเตอร์, กล้องวงจรปิด | สวิตช์เชื่อมกับสวิตช์ (Switch-to-Switch), สวิตช์เชื่อม Router, เซิร์ฟเวอร์ VMware ESXi |
| **จำนวน VLAN ที่รองรับ** | **VLAN เดียวเท่านั้น** (เช่น รับเฉพาะ VLAN 10) | **หลาย VLAN พร้อมกัน** (เช่น อนุญาต VLAN 10, 20, 30 วิ่งผ่านสายเส้นเดียว) |
| **การใส่ Tag (802.1Q)** | **Untagged**: Frame ที่ส่งเข้าคอมพิวเตอร์จะเป็นเฟรมปกติ ไม่มี VLAN Tag แปะหัว | **Tagged**: สวิตช์จะแปะ **VLAN Tag (802.1Q Header ขนาด 4 bytes)** เพื่อระบุว่าเฟรมนี้เป็นของ VLAN ใด |

### แนวคิด Native VLAN บน Trunk Port:
พอร์ต Trunk จะยอมให้มี **VLAN พิเศษ 1 อันที่ไม่ต้องแปะ Tag (Untagged)** เรียกว่า **Native VLAN** (ค่าเริ่มต้นมักเป็น VLAN 1) หากมีเฟรมธรรมดาที่ไม่มี Tag วิ่งเข้ามาที่พอร์ต Trunk สวิตช์จะโยนเฟรมนั้นเข้าสู่ Native VLAN ทันที

> **Security Warning**: ในการใช้งานจริง แนะนำให้เปลี่ยน Native VLAN จากค่าเริ่มต้น (VLAN 1) ไปเป็น VLAN อื่นที่ไม่ได้ใช้งาน (เช่น VLAN 999) เพื่อป้องกันการโจมตีประเภท **VLAN Hopping Attack**

---

## 5. การตั้งค่าบน Cisco CLI เบื้องต้น

```text
! กำหนดพอร์ต Gi0/1 เป็น Access Port สำหรับเครื่องฝ่ายบัญชี (VLAN 10)
Switch(config)# interface GigabitEthernet0/1
Switch(config-if)# description Accounting-PC-01
Switch(config-if)# switchport mode access
Switch(config-if)# switchport access vlan 10
Switch(config-if)# exit

! กำหนดพอร์ต Gi0/24 เป็น Trunk Port เชื่อมต่อไปยัง Core Switch
Switch(config)# interface GigabitEthernet0/24
Switch(config-if)# description Uplink-to-CoreSwitch
Switch(config-if)# switchport mode trunk
Switch(config-if)# switchport trunk allowed vlan 10,20,30
Switch(config-if)# exit
```

---

## 6. สรุป Checklist แก้ปัญหาเมื่อเครื่องคุยกันไม่ได้ในระบบ Switch/VLAN

1. **เช็ก Access VLAN**: พอร์ตของเครื่องทั้งสองฝั่งตั้งค่า VLAN ตรงกันหรือไม่ (`show mac address-table` หรือ `show vlan brief`)
2. **เช็ก Trunk Allowed VLAN**: พอร์ต Trunk ระหว่างสวิตช์มีการ `allowed` VLAN นั้นให้วิ่งผ่านหรือไม่? (ปัญหาคลาสสิก: สร้าง VLAN ที่ Access Switch แล้ว แต่ลืม allow ใน Trunk Uplink)
3. **เช็ก Default Gateway**: หากเครื่องอยู่คนละ VLAN (เช่น เครื่อง A อยู่ VLAN 10 เครื่อง B อยู่ VLAN 20) เครื่องต้องชี้ Default Gateway ไปที่ IP ของ Router/L3 Switch ไม่อย่างนั้นจะไม่สามารถส่งข้ามวงได้
