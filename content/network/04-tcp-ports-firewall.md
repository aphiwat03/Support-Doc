---
slug: network-tcp-ports-firewall
title: TCP Handshake, สถานะพอร์ต และความต่าง Connection Refused vs Timed Out
summary: เข้าใจกลไก TCP 3-Way Handshake, สถานะพอร์ต, ถอดรหัสข้อผิดพลาด Connection Refused vs Timed Out และวิธีใช้ ss, nc, ufw
read_time_minutes: 9
difficulty: intermediate
display_order: 4
---

# TCP Handshake, สถานะพอร์ต และความต่าง Connection Refused vs Timed Out

นี่คือหนึ่งในหัวข้อสัมภาษณ์ยอดฮิตที่สุดของสาย Application Support และ DevOps: เมื่อผู้ใช้แจ้งว่า **"ต่อ Database ไม่ได้"** หรือ **"เรียก API ไม่ติด"** ข้อความ Error ที่แสดงบอกสาเหตุของปัญหาได้อย่างแม่นยำหากเราเข้าใจกลไกของ TCP

---

## 1. กลไก TCP 3-Way Handshake

ก่อนที่ Client และ Server จะรับส่งข้อมูลกันได้ จะต้องสร้าง Connection ผ่าน 3 ขั้นตอน:

```
Client                             Server (Port ในสถานะ LISTEN)
  |                                  |
  | -------- SYN (ขอนัดหมาย) ------> |  Client ส่ง SYN
  |                                  |
  | <--- SYN-ACK (รับทราบและตกลง) -- |  Server ตอบรับ SYN-ACK
  |                                  |
  | -------- ACK (ยืนยันพร้อมเริ่ม) -> |  Client ส่ง ACK
  |                                  |
[ESTABLISHED]                      [ESTABLISHED]
```

- **FIN / ACK**: การปิดการเชื่อมต่อแบบปกติอย่างสุภาพ (Graceful Shutdown)
- **RST (Reset)**: การตัดการเชื่อมต่อแบบกะทันหัน หรือปฏิเสธไม่รับคุย

---

## 2. สถานะ TCP ที่พบบ่อยใน `ss -tan`

| สถานะ | ความหมาย | จุดสังเกตในงาน Support |
|---|---|---|
| **LISTEN** | เซิร์ฟเวอร์กำลังเปิดพอร์ตรอรับการเชื่อมต่อ | ถ้าไม่มีสถานะนี้ แสดงว่า Service ดับ |
| **ESTABLISHED** | การเชื่อมต่อสำเร็จและกำลังรับส่งข้อมูล | ปกติ |
| **TIME_WAIT** | ฝั่ง Client/Server ปิดการเชื่อมต่อแล้ว และรอเคลียร์แพ็กเก็ตตกค้าง | ถ้าค้างหลายหมื่นอาจทำให้ Ephemeral Port เต็ม |
| **CLOSE_WAIT** | เซิร์ฟเวอร์ได้รับ FIN จาก Client แล้ว แต่แอปพลิเคชันยังไม่ยอมสั่งปิด Socket | ปัญหา Application Leak (แอปเขียนโค้ดไม่ปิด Connection) |

---

## 3. มหากาพย์: Connection Refused vs Connection Timed Out

| ข้อความ Error | กลไกเครือข่ายที่เกิดขึ้น | สาเหตุที่พบบ่อยที่สุด |
|---|---|---|
| **Connection Refused** | Packet เดินทางไปถึงเครื่องปลายทางได้ แต่ Kernel ของปลายทางตอบกลับด้วย **TCP RST** ทันที | 1. **Service ปลายทางดับ** (ไม่มีใครเปิด Port รออยู่)<br>2. Service เปิดอยู่แต่ผูก (Bind) ผิด IP เช่น ผูก `127.0.0.1` ทำให้เครื่องภายนอกเข้าไม่ได้<br>3. Firewall ปลายทางตั้งกฎเป็น **REJECT** |
| **Connection Timed Out** | Client ส่ง SYN ออกไปแล้ว แต่ไม่มีการตอบสนองใดๆ กลับมาเลยจนหมดเวลา (Timeout) | 1. **Network Firewall / Cloud Security Group บล็อก** (ตั้งกฎเป็น **DROP** ทิ้งเงียบๆ)<br>2. IP ปลายทางไม่มีอยู่จริง หรือเครื่องดับสนิท<br>3. Routing ผิดพลาดทำให้ Packet หายไประหว่างทาง |

> ⚠️ **สรุปหัวใจสำคัญ (Crucial Rule)**:
> - ถ้าเจอ **Refused** = ปัญหาอยู่ที่ **OS / Service ในเครื่องปลายทาง** (พอร์ตไม่เปิด, Service ล่ม)
> - ถ้าเจอ **Timed Out** = ปัญหาอยู่ที่ **ทางเดินเครือข่าย หรือ Firewall / Security Group**

---

## 4. คำสั่งตรวจสอบและวินิจฉัยพอร์ต

### 1) ตรวจสอบพอร์ตที่กำลัง LISTEN ในเครื่องตนเองด้วย `ss`
```bash
# -t (TCP), -u (UDP), -l (Listening), -p (Process), -n (Numeric)
sudo ss -tulpn

# กรองเฉพาะพอร์ต 5432 (Postgres) หรือ 80 (HTTP)
sudo ss -tulpn | grep -E ':(5432|80)\b'
```
- หากเห็น Local Address เป็น `127.0.0.1:5432` แสดงว่ารองรับเฉพาะ Localhost
- หากเห็น `0.0.0.0:5432` หรือ `*:5432` แสดงว่ารองรับทุก Interface พร้อมให้ภายนอกเชื่อมต่อ

### 2) ตรวจสอบว่าพอร์ตปลายทางเปิดอยู่หรือไม่ด้วย `nc` (Netcat)
```bash
# ทดสอบเชื่อมต่อ TCP ไปยัง db-server พอร์ต 5432 (Timeout 3 วินาที)
nc -zvw 3 db-server 5432

# ผลลัพธ์เมื่อสำเร็จ: Connection to db-server 5432 port [tcp/*] succeeded!
# ผลลัพธ์เมื่อ Refused: connect to db-server port 5432 (tcp) failed: Connection refused
```

### 3) ตรวจสอบ Firewall ภายในเครื่องด้วย `ufw`
```bash
# ตรวจสถานะ Firewall บน Ubuntu
sudo ufw status verbose

# อนุญาตพอร์ต 80 จากทุกที่
sudo ufw allow 80/tcp

# อนุญาตพอร์ต 5432 เฉพาะจาก IP 10.0.1.50
sudo ufw allow from 10.0.1.50 to any port 5432 proto tcp
```
