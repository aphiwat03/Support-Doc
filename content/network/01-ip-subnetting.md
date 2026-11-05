---
slug: network-ip-subnetting
title: ทำความเข้าใจ IP, Subnet Mask และ CIDR สำหรับงาน Support
summary: เจาะลึกโครงสร้าง IPv4, การแบ่ง Private vs Public IP, คำนวณ CIDR (/24, /28, /30) และการตั้งค่า Network Interface
read_time_minutes: 8
difficulty: beginner
display_order: 1
---

# ทำความเข้าใจ IP, Subnet Mask และ CIDR สำหรับงาน Support

ในฐานะ Application Support หรือ NOC (Network Operations Center) หน้าที่หลักคือการตรวจสอบว่าเครื่องแม่ข่ายหรืออุปกรณ์ปลายทางเชื่อมต่อเครือข่ายถูกต้องหรือไม่ หากตั้งค่า IP หรือ Subnet ผิดพลาด เซิร์ฟเวอร์จะไม่สามารถติดต่อ Gateway หรือออกอินเทอร์เน็ตได้เลย

---

## 1. โครงสร้าง IPv4 และ Subnet Mask

IPv4 ประกอบด้วยตัวเลข 32 บิต แบ่งออกเป็น 4 ชุด (Octet) คั่นด้วยจุด แต่ละชุดมีค่าตั้งแต่ 0 ถึง 255 (เช่น `192.168.1.50`)

### หน้าที่ของ Subnet Mask
Subnet Mask มีหน้าที่บอกว่าส่วนไหนของ IP คือ **Network ID** (เครือข่ายไหน) และส่วนไหนคือ **Host ID** (เครื่องไหนในเครือข่าย):
- ถ้าเครื่องสองเครื่องอยู่ใน Network ID เดียวกัน สามารถสื่อสารกันได้โดยตรงผ่าน Layer 2 (Switch)
- ถ้าอยู่คนละ Network ID ต้องส่ง Packet ผ่าน **Default Gateway (Router)** เสมอ

---

## 2. Private IP Address vs Public IP Address

ตามมาตรฐาน RFC 1918 ช่วง IP ต่อไปนี้ถูกสงวนไว้ใช้งานภายในองค์กร (ห้ามวิ่งบน Public Internet):

| Class | ช่วง Private IP | Subnet เริ่มต้น | การใช้งานทั่วไป |
|---|---|---|---|
| **Class A** | `10.0.0.0` - `10.255.255.255` | `/8` (255.0.0.0) | องค์กรขนาดใหญ่, Cloud VPC, Datacenter |
| **Class B** | `172.16.0.0` - `172.31.255.255` | `/12` (255.240.0.0) | องค์กรขนาดกลาง, Docker Bridge Network (`172.17.x.x`) |
| **Class C** | `192.168.0.0` - `192.168.255.255` | `/16` (255.255.0.0) | Home Router, ออฟฟิศสาขา, Lab |

> ⚠️ **ข้อควรระวัง (Warning)**:
> หากเซิร์ฟเวอร์แจ้งว่าได้รับ IP ขึ้นต้นด้วย `169.254.x.x` (APIPA - Automatic Private IP Addressing) แสดงว่าเครื่องไม่ได้รับ IP จาก DHCP Server หรือเชื่อมต่อสาย LAN มีปัญหา

---

## 3. การคำนวณ CIDR ที่พบบ่อยในงาน Support

ตัวเลข `/XX` หลัง IP คือจำนวนบิตที่ใช้เป็น Network ID โดยสูตรคำนวณจำนวน Host คือ $2^{(32 - \text{Prefix})} - 2$ (ต้องหัก Network IP และ Broadcast IP ออก 2 ค่าเสมอ):

| CIDR | Subnet Mask | จำนวน IP ทั้งหมด | Usable Hosts | การใช้งานจริง |
|---|---|---|---|---|
| **/24** | `255.255.255.0` | 256 | **254** | วง LAN ออฟฟิศ, Subnet ทั่วไป |
| **/28** | `255.255.255.240` | 16 | **14** | Subnet ย่อยใน Cloud / DMZ ขนาดเล็ก |
| **/29** | `255.255.255.248` | 8 | **6** | IP Public Block สำหรับ Load Balancer / Firewall |
| **/30** | `255.255.255.252` | 4 | **2** | Point-to-Point Link ระหว่าง Router 2 ตัว |
| **/32** | `255.255.255.255` | 1 | **1** | Host IP เดี่ยว (ใช้ใน Firewall Rule หรือ Loopback) |

---

## 4. คำสั่งตรวจสอบ IP บน Linux

### 1) ตรวจสอบ IP และ Interface ด้วย `ip addr`
```bash
# แสดง IP และ Interface ทั้งหมด
ip addr show

# แสดงเฉพาะ Interface ที่สนใจ (เช่น eth0)
ip addr show eth0
```

### 2) ตรวจสอบ Default Gateway ด้วย `ip route`
```bash
ip route show
# ผลลัพธ์: default via 192.168.1.1 dev eth0 proto dhcp metric 100
```
- ถ้าไม่มีบรรทัด `default via ...` เครื่องจะไม่สามารถออกไปยังภายนอกหรืออินเทอร์เน็ตได้

---

## 5. Checklist ลำดับการตรวจสอบ Network ขั้นพื้นฐาน
1. **Interface UP หรือไม่**: ดูสถานะใน `ip link show` (ต้องเป็น `state UP`)
2. **มี IP Address ถูกต้องหรือไม่**: ดูว่าได้ IP วงที่ถูกต้อง ไม่ใช่ `169.254.x.x`
3. **มี Default Gateway หรือไม่**: ตรวจสอบด้วย `ip route show`
4. **Ping Gateway เจอหรือไม่**: `ping -c 3 <Gateway_IP>`
