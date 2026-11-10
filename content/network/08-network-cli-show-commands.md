---
slug: network-cli-show-commands
title: คำสั่งสำรวจและตรวจสอบเครือข่าย Cisco/Network CLI (Show Commands & Diagnostics)
summary: การเชื่อมต่อผ่าน Console Cable, โครงสร้าง User EXEC vs Privileged EXEC, สูตรคำสั่ง show ยอดฮิต: show ip int brief, show interfaces, show vlan brief, show mac address-table และ show ip route
read_time_minutes: 10
difficulty: intermediate
display_order: 8
---

# คำสั่งสำรวจและตรวจสอบเครือข่าย Cisco/Network CLI

ไม่ว่าคุณจะดูแลอุปกรณ์ **Cisco, Juniper, Huawei, Aruba หรือ MikroTik** แม้ไวยากรณ์จะต่างกันเล็กน้อย แต่แนวคิดการจัดการผ่าน **Command Line Interface (CLI)** ล้วนมีโครงสร้างแบบเดียวกัน ในฐานะ Junior Network หรือ Support ประจำศูนย์ข้อมูล การรู้วิธีเข้า Console และใช้คำสั่งกลุ่ม `show` คือกุญแจสำคัญในการวินิจฉัยปัญหาโดยไม่สร้างความเสี่ยงให้เครือข่ายล่ม

---

## 1. วิธีเชื่อมต่อและการเข้าสู่ CLI (Console Access)

เมื่อสวิตช์หรือเราเตอร์เครื่องใหม่ยังไม่ได้ตั้ง IP หรือระบบเครือข่ายล่มจนไม่สามารถรีโมตผ่าน SSH ได้ คุณจะต้องต่อสายเข้าเครื่องโดยตรง:

1. **สาย Console**: สายสีฟ้า RJ45-to-DB9 (หรือสายยุคใหม่เป็น USB-C / USB Type-A to RJ45) เสียบเข้าที่พอร์ต **Console** ด้านหน้าหรือหลังอุปกรณ์
2. **โปรแกรม Terminal Emulator**: บนคอมพิวเตอร์ของคุณ เปิดโปรแกรมเช่น **PuTTY, Tera Term หรือ SecureCRT**
3. **พารามิเตอร์การเชื่อมต่อ (Serial Settings)**:
   - **Baud Rate (Speed)**: `9600` (ค่ามาตรฐานสากล)
   - **Data Bits**: `8`
   - **Parity**: `None`
   - **Stop Bits**: `1`
   - **Flow Control**: `None`

---

## 2. ลำดับโหมดของ Cisco IOS CLI (Command Modes)

Cisco แบ่งระดับการทำงานเพื่อความปลอดภัยออกเป็น 3 โหมดหลัก:

```text
Switch>             <-- 1. User EXEC Mode (ดูข้อมูลทั่วไปได้อย่างจำกัด ไม่สามารถแก้คอนฟิก)
Switch> enable      <-- พิมพ์คำสั่ง enable และใส่รหัสผ่าน เพื่อยกระดับสิทธิ์
Switch#             <-- 2. Privileged EXEC Mode (ดูข้อมูลเชิงลึกได้ทุกอย่าง รันคำสั่ง show ได้ครบ)
Switch# configure terminal
Switch(config)#     <-- 3. Global Configuration Mode (แก้ไขการตั้งค่าของสวิตช์/เราเตอร์)
```

> **กฎเหล็กของงาน Support & NOC**: เมื่อได้รับมอบหมายให้ตรวจสอบปัญหา ให้ทำงานใน **Privileged EXEC Mode (`#`)** เท่านั้น ห้ามเข้าสู่ `configure terminal` หากไม่ได้รับอนุมัติใน Change Request เพราะการพิมพ์คำสั่งผิดในโหมด config อาจทำให้พอร์ตดับหรือเน็ตเวิร์กล่มทั้งระบบ

---

## 3. มหาคัมภีร์คำสั่ง Show ที่ต้องใช้เป็นประจำ

![ตัวอย่างผลลัพธ์คำสั่ง show ip interface brief บน Cisco Switch](/images/network/cisco-show-ip-int-brief.png)

### 1) ตรวจสอบสถานะพอร์ตและ IP อย่างรวดเร็ว: `show ip interface brief`
คำสั่งอันดับ 1 ที่วิศวกรทุกคนต้องพิมพ์เป็นคำสั่งแรก:

```text
Switch# show ip interface brief
Interface              IP-Address      OK? Method Status                Protocol
GigabitEthernet0/1     unassigned      YES unset  up                    up      
GigabitEthernet0/2     unassigned      YES unset  up                    down    
GigabitEthernet0/3     unassigned      YES unset  down                  down    
GigabitEthernet0/4     unassigned      YES unset  administratively down down    
Vlan1                  192.168.1.2     YES NVRAM  up                    up      
```

#### ถอดรหัสคอลัมน์ `Status` และ `Protocol`:
- **Status (Layer 1 - Physical)**: สายสัญญาณเสียบอยู่ไหม? มีสัญญาณไฟฟ้า/แสงเข้ามาไหม?
- **Protocol (Layer 2 - Data Link)**: คุยกันรู้เรื่องไหม? มีการรับส่ง Keepalive หรือ Clock สัญญาณถูกต้องหรือไม่?

| Status | Protocol | ความหมายเชิงลึก | สาเหตุและวิธีแก้ |
|---|---|---|---|
| **up** | **up** | พอร์ตทำงานสมบูรณ์ 100% | พร้อมใช้งานปกติ |
| **up** | **down** | มีสัญญาณทางกายภาพ (L1 ผ่าน) แต่ L2 คุยไม่ผ่าน | มีปัญหาเรื่อง Encapsulation, Duplex Mismatch หรือพอร์ตอีกฝั่งไม่ได้เปิด Protocol |
| **down** | **down** | ไม่มีสัญญาณทั้ง L1 และ L2 | สายแลนหลุด, หัวไฟเบอร์สลับ Tx/Rx, ปลายทางปิดเครื่อง, หรือพอร์ตเสีย |
| **administratively down** | **down** | พอร์ตถูกสั่งปิดใช้งานด้วยคำสั่ง `shutdown` | แอดมินจงใจปิดไว้ หากต้องการเปิดต้องสั่ง `no shutdown` |

---

### 2) ตรวจสอบรายละเอียดทางกายภาพและ Error Counters: `show interfaces <port>`
เมื่อพบว่าความเร็วเครือข่ายตกหรือสัญญาณติดๆ ดับๆ ให้เจาะลึกที่พอร์ตนั้น:

```text
Switch# show interfaces GigabitEthernet0/1
GigabitEthernet0/1 is up, line protocol is up 
  Hardware is Gigabit Ethernet, address is 5254.0012.3456
  Description: Link to DB-Server-01
  MTU 1500 bytes, BW 1000000 Kbit/sec, DLY 10 usec, 
     Full-duplex, 1000Mb/s, media type is 10/100/1000BaseTX
  Input flow-control is off, output flow-control is unsupported
  5 minute input rate 125000 bits/sec, 142 packets/sec
  5 minute output rate 280000 bits/sec, 210 packets/sec
     12894523 packets input, 891238475 bytes, 0 no buffer
     Received 24 broadcasts (0 multicasts)
     0 runts, 0 giants, 0 throttles
     15842 input errors, 15840 CRC, 0 frame, 0 overrun, 2 ignored
     0 watchdog, 0 multicast, 0 pause input
     0 output errors, 0 collisions, 2 interface resets
```

- **CRC Errors**: หากตัวเลขนี้เพิ่มขึ้นเรื่อยๆ แสดงว่า **สายสัญญาณมีสัญญาณรบกวน** หัวสายไม่แน่น หรือสายยาวเกินมาตรฐาน
- **Collisions / Late Collisions**: หากพบค่านี้ในระบบ Switch แสดงว่าเกิด **Duplex Mismatch** (ฝั่งหนึ่งเป็น Full-duplex อีกฝั่งเป็น Half-duplex)

---

### 3) ตรวจสอบการจัดสรร VLAN: `show vlan brief`

```text
Switch# show vlan brief
VLAN Name                             Status    Ports
---- -------------------------------- --------- -------------------------------
1    default                          active    Gi0/5, Gi0/6, Gi0/7, Gi0/8
10   Management                       active    Gi0/1, Gi0/2
20   App-Servers                      active    Gi0/3, Gi0/4
30   Database                         active    
```
- ใช้เช็กทันทีว่า พอร์ตของเครื่องที่กำลังมีปัญหา ถูก assign ให้อยู่ใน VLAN ที่ถูกต้องแล้วหรือไม่
- พอร์ตที่ทำเป็น **Trunk จะไม่ปรากฏในตารางนี้** (เพราะ Trunk ส่งได้หลาย VLAN ให้ใช้คำสั่ง `show interfaces trunk` แทน)

---

### 4) ตรวจสอบพอร์ต Trunk: `show interfaces trunk`

```text
Switch# show interfaces trunk
Port        Mode             Encapsulation  Status        Native vlan
Gi0/24      on               802.1q         trunking      1

Port        Vlans allowed on trunk
Gi0/24      10,20,30

Port        Vlans in spanning tree forwarding state and not pruned
Gi0/24      10,20,30
```
- ดูว่าพอร์ต Uplink กำลังทำงานเป็น Trunk จริงหรือไม่ (`trunking`)
- ดูค่า **Native VLAN** ว่าตรงกับสวิตช์ฝั่งตรงข้ามหรือไม่ (หากไม่ตรงจะเกิด Native VLAN Mismatch Error)
- ดูว่า VLAN ของเราได้รับอนุญาต (`allowed`) ให้ผ่านสาย Trunk เส้นนี้หรือไม่

---

### 5) ตรวจสอบเส้นทางเครือข่ายบน Router: `show ip route`

```text
Router# show ip route
Gateway of last resort is 203.0.113.1 to network 0.0.0.0

S*    0.0.0.0/0 [1/0] via 203.0.113.1
C     192.168.10.0/24 is directly connected, GigabitEthernet0/1
C     192.168.20.0/24 is directly connected, GigabitEthernet0/2
O     10.50.0.0/16 [110/2] via 192.168.10.254, 01:45:12, GigabitEthernet0/1
```
- **`C` (Connected)**: เครือข่ายที่ต่ออยู่กับขาเราเตอร์โดยตรง
- **`S*` (Static Default Route)**: เส้นทาง `0.0.0.0/0` ที่ชี้ไปยัง Gateway สำหรับส่งข้อมูลออกนอกเครือข่าย
- **`O` (OSPF)**: เส้นทางที่เรียนรู้มาผ่าน Dynamic Routing Protocol

---

## 4. สรุปเคล็ดลับการใช้งาน CLI อย่างมือโปร

1. **ใช้ปุ่ม `Tab` เพื่อเติมคำอัตโนมัติ**: เช่น พิมพ์ `sh ip int br` แล้วกด Tab ระบบจะเติมเต็มให้อัตโนมัติ
2. **ใช้เครื่องหมาย `?` เมื่อจำคำสั่งไม่ได้**: เช่น พิมพ์ `show interfaces ?` เพื่อดูตัวเลือกทั้งหมด
3. **การกรองผลลัพธ์ด้วย Pipe (`|`)**: บน Cisco สามารถใช้ pipe เพื่อตัดคำเหมือนบน Linux ได้:
   - `show ip interface brief | include up` ➔ ดูเฉพาะพอร์ตที่ UP
   - `show running-config | section interface` ➔ ดูเฉพาะท่อนคอนฟิก Interface
   - `show interfaces | include CRC` ➔ หาพอร์ตที่มีค่า CRC error ทันที
