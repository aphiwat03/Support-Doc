---
slug: network-osi-layered-troubleshooting
title: โมเดล OSI/TCP-IP และการวิเคราะห์ปัญหาเครือข่ายทีละชั้น (OSI & Layered Troubleshooting)
summary: เจาะลึก OSI 7 Layers เทียบ TCP/IP 4 Layers, บทบาทของอุปกรณ์และโปรโตคอลในแต่ละชั้น, และกระบวนการคิดแบบ Bottom-Up จากสายสัญญาณจนถึงหน้าแอปพลิเคชัน
read_time_minutes: 10
difficulty: beginner
display_order: 5
---

# โมเดล OSI/TCP-IP และการวิเคราะห์ปัญหาเครือข่ายทีละชั้น

สำหรับวิศวกรหรือเจ้าหน้าที่ **Network Engineer**, **NOC (Network Operations Center)** และ **Technical Support** กรอบความคิดที่มีค่าที่สุดในการแก้ปัญหาคือ **OSI 7 Layers Model** เพราะเมื่อระบบล่มหรือเครื่องเซิร์ฟเวอร์ต่อเครือข่ายไม่ได้ หากไม่มีกรอบความคิด คุณจะสับสนและทดสอบมั่ว แต่ถ้าใช้หลักการแยกชั้น (Layered Approach) คุณจะตัดสาเหตุที่เป็นไปไม่ได้ออกทีละขั้นและเจอปัญหาได้อย่างรวดเร็ว

---

## 1. การเปรียบเทียบ OSI 7 Layers และ TCP/IP Model

โมเดล OSI (Open Systems Interconnection) ถูกออกแบบเป็นมาตรฐานทฤษฎี 7 ชั้น ขณะที่การทำงานจริงของอินเทอร์เน็ตใช้สถาปัตยกรรม **TCP/IP Model (4 หรือ 5 ชั้น)** โดยทั้งสองแบบเทียบเคียงกันได้ดังนี้:

![ตารางเปรียบเทียบ OSI 7 ชั้นเทียบกับ TCP/IP Model พร้อมอุปกรณ์และโปรโตคอล](/images/network/osi-vs-tcpip-layers.png)

| Layer OSI | ชื่อชั้น (OSI Layer) | หน้าที่หลัก | Protocol / เทคโนโลยี | อุปกรณ์ที่ทำงานในชั้นนี้ | หน่วยข้อมูล (PDU) |
|---|---|---|---|---|---|
| **Layer 7** | **Application** | ติดต่อกับผู้ใช้และซอฟต์แวร์แอปพลิเคชัน | HTTP, HTTPS, DNS, SSH, DHCP, SMTP, FTP | Web Browser, Nginx, App Server | Data |
| **Layer 6** | **Presentation** | จัดรูปแบบ เข้ารหัส บีบอัดข้อมูล | TLS/SSL, ASCII, JPEG, JSON | - | Data |
| **Layer 5** | **Session** | จัดการ เปิด ปิด เซสชันการสื่อสาร | RPC, NetBIOS, TLS Session | - | Data |
| **Layer 4** | **Transport** | ขนส่งข้อมูลแบบ Port-to-Port รับประกันการส่ง (TCP) หรือเน้นความเร็ว (UDP) | **TCP, UDP** (พอร์ต 80, 443, 22, 53) | Firewall (Stateful), Load Balancer L4 | **Segment** (TCP) / Datagram (UDP) |
| **Layer 3** | **Network** | การระบุที่อยู่ตรรกะ (Logical Addressing) และค้นหาเส้นทางข้ามเครือข่าย | **IPv4, IPv6, ICMP**, OSPF, BGP, ARP | **Router**, L3 Switch | **Packet** |
| **Layer 2** | **Data Link** | การส่งข้อมูลบนเครือข่ายท้องถิ่น (LAN) อ้างอิง Physical Address | **Ethernet, MAC Address, VLAN (802.1Q)** | **Switch (L2)**, NIC (Network Card) | **Frame** |
| **Layer 1** | **Physical** | การส่งสัญญาณบิตไฟฟ้า แสง หรือคลื่นวิทยุผ่านสื่อกลาง | Copper RJ45 (Cat6), Fiber Optic, SFP | สายสัญญาณ, Patch Panel, Hub, Transceiver | **Bits** |

> **สูตรจำชื่อ 7 ชั้นจากบนลงล่าง**: **A**ll **P**eople **S**eem **T**o **N**eed **D**ata **P**rocessing  
> **สูตรจำชื่อ 7 ชั้นจากล่างขึ้นบน**: **P**lease **D**o **N**ot **T**hrow **S**ausage **P**izza **A**way

---

## 2. วิธีคิดในการแก้ปัญหาแบบทีละชั้น (Layered Troubleshooting Methodologies)

เมื่อลูกค้าหรือระบบ Monitor ร้องเตือนว่า *"เข้าเว็บไม่ได้"* หรือ *"เซิร์ฟเวอร์ A ต่อฐานข้อมูล B ไม่ได้"* ช่างเทคนิคจะเลือกวิธีการวิเคราะห์ 3 รูปแบบหลัก:

### 1) วิธีล่างขึ้นบน: Bottom-Up Approach (แนะนำมากที่สุดสำหรับปัญหาฮาร์ดแวร์/เครือข่ายใหม่)
เริ่มตรวจจาก Layer 1 ขึ้นไป Layer 7:
1. **L1 (Physical)**: ไฟพอร์ต Link ติดไหม? สายหลุดไหม? ขั้วไฟเบอร์สลับไหม?
2. **L2 (Data Link)**: ได้รับ MAC Address ไหม? อยู่ใน VLAN ถูกต้องไหม? พอร์ต Switch เป็น Up/Up หรือไม่?
3. **L3 (Network)**: เครื่องได้รับ IP Address ไหม? Gateway ถูกไหม? `ping` หา Gateway ติดไหม?
4. **L4 (Transport)**: พอร์ตปลายทางเปิดฟังอยู่ไหม (`nc -zv`, `ss -tan`)? ติด Firewall ภายในหรือนอกไหม?
5. **L7 (Application)**: เว็บเซอร์วิส (Nginx/Node) ตอบกลับ HTTP 200 หรือ Error 500/502?

### 2) วิธีบนลงล่าง: Top-Down Approach (เหมาะสำหรับผู้ใช้ทั่วไปแจ้งปัญหาแอป)
เริ่มจากดูหน้า UI หรือ Application Layer ก่อน เช่น ทดสอบเปิดผ่านเบราว์เซอร์ หากเจอ `HTTP 404` แสดงว่าเครือข่ายปกติ ปัญหาอยู่ที่แอปพลิเคชัน แต่ถ้าเจอ `DNS_PROBE_FINISHED_NXDOMAIN` หรือ `Connection Timed Out` จึงค่อยไล่ลงไปหา DNS (L7), Firewall (L4) หรือ Network (L3)

### 3) วิธีแบ่งครึ่ง: Divide-and-Conquer (วิธีที่เร็วที่สุดสำหรับผู้มีประสบการณ์)
เริ่มทดสอบที่ **Layer 3 หรือ Layer 4 ทันที** ด้วยคำสั่ง `ping` หรือ `curl`:
- ถ้า `ping` เจอ Gateway และปลายทางได้ ➔ ตัดปัญหา Layer 1, 2, 3 ทิ้งได้ทันที 100%! ไปโฟกัสที่ Layer 4 (Port/Firewall) หรือ Layer 7 (App)
- ถ้า `ping` ไม่ติดตั้งแต่ Default Gateway ➔ รู้ทันทีว่าปัญหาอยู่ที่ Layer 1-3 ในระดับ Local Network แน่นอน ไม่ต้องเสียเวลาไปเช็กการตั้งค่าแอปพลิเคชัน

---

## 3. Checklist การใช้คำสั่งตรวจเช็กไล่ทีละชั้นบน Linux

เมื่อต้องแก้ไขปัญหาเครือข่ายบนเซิร์ฟเวอร์ ให้จำลำดับขั้นตอนคำสั่งต่อไปนี้:

```bash
# -------------------------------------------------------------
# ขั้นที่ 1: ตรวจสอบ Layer 1 & 2 (Link State & Interface)
# -------------------------------------------------------------
# ตรวจสอบว่า Interface มีสายเสียบและมีไฟ Link ติดหรือไม่ (State UP)
ip link show eth0
# ตรวจสอบความเร็วและการเชื่อมต่อทางกายภาพด้วย ethtool
ethtool eth0 | grep -E "Speed|Duplex|Link detected"

# -------------------------------------------------------------
# ขั้นที่ 2: ตรวจสอบ Layer 3 (IP, Subnet, Route & Gateway)
# -------------------------------------------------------------
# ดู IP Address ที่เครื่องได้รับ
ip -4 addr show eth0

# ดู Default Gateway
ip route show

# ปิงทดสอบ Gateway ท้องถิ่น (ถ้าไม่ติด ปัญหาอยู่ที่สาย/Switch/VLAN/IP ชน)
ping -c 3 192.168.1.1

# ปิงทดสอบ Public IP ภายนอก (เช่น 8.8.8.8 ถ้าติด แสดงว่าออกเน็ตได้ ปัญหาไม่ใช่ Routing)
ping -c 3 8.8.8.8

# -------------------------------------------------------------
# ขั้นที่ 3: ตรวจสอบ Layer 7 (DNS Resolution)
# -------------------------------------------------------------
# ทดสอบแปลงชื่อโฮสต์เป็นไอพี (ถ้า 8.8.8.8 ปิงติด แต่ปิง google.com ไม่ได้ แสดงว่าเป็นที่ DNS)
dig google.com +short

# -------------------------------------------------------------
# ขั้นที่ 4: ตรวจสอบ Layer 4 (Port & Firewall)
# -------------------------------------------------------------
# ทดสอบเชื่อมต่อไปยังพอร์ตปลายทาง (เช่น พอร์ต 443 หรือ 5432)
nc -zvw3 api.example.com 443

# ตรวจสอบพอร์ตที่เปิด Listening อยู่ในเครื่องตัวเอง
ss -tulpn
```

---

## 4. สรุปความผิดพลาดคลาสสิกแยกตามชั้น (Error Mapping)

| ปัญหาที่พบ | ชั้น OSI ที่รับผิดชอบ | สาเหตุที่เป็นไปได้ |
|---|---|---|
| ไฟ Link ดับ / สายไม่แน่น / Transceiver ร้อนจัด | **Layer 1** | สาย LAN ขาดใน, หัวไฟเบอร์สกปรก, เสียบผิดพอร์ต |
| ค่า CRC Error พุ่งสูง / Duplex Mismatch / เครื่องไม่เห็น MAC ของ Gateway | **Layer 2** | สายมีสัญญาณรบกวน, Switch ตั้งค่า VLAN ผิด, พอร์ตโดน STP บล็อก |
| `Destination Host Unreachable` / ไอพีชนกัน (IP Conflict) | **Layer 3** | Default Gateway ผิด, ตั้ง Subnet Mask ไม่ตรงวง, ตาราง Routing หาย |
| `Connection Refused` / `Connection Timed Out` | **Layer 4** | พอร์ตปลายทางไม่ได้เปิดรัน Service, ติด Security Group / iptables / Firewall |
| `SSL Certificate Expired` / `Handshake Failure` | **Layer 6** | ใบรับรองหมดอายุ, Cipher Suite ไม่ตรงกัน |
| `HTTP 502 Bad Gateway` / `DNS NXDOMAIN` | **Layer 7** | แอปพลิเคชันหลังบ้านล่ม (Node/PHP ตาย), ตั้งค่า DNS ผิด |
