---
slug: linux-health-check
title: เช็กสถานะ Service, Port และ Endpoint (systemctl, ss, nc, curl)
summary: ชุดคำสั่งตรวจสอบเบื้องต้นตามลำดับ ตั้งแต่ Service รันอยู่ไหม Port เปิดฟังไหม ต่อ Port ปลายทางได้ไหม จนถึง Endpoint ตอบ HTTP ปกติไหม พร้อมวิธีแปลผลและข้อมูลที่ต้องเก็บก่อน Escalate
read_time_minutes: 10
difficulty: intermediate
display_order: 10
---

# เช็กสถานะ Service, Port และ Endpoint

เมื่อมีคนแจ้งว่า "ระบบเข้าไม่ได้" งานแรกของ **Application Support และ NOC Tier 1** คือบอกให้ได้ว่าปัญหาอยู่ชั้นไหน บทนี้ใช้หลักตรวจจากล่างขึ้นบน แล้วหยุดที่ชั้นแรกที่ผิดปกติ

| ลำดับ | คำถามที่ต้องตอบ | เครื่องมือหลัก |
|---|---|---|
| 1 | Service รันอยู่ไหม | `systemctl is-active`, `systemctl status` |
| 2 | Process เปิดฟัง Port ที่ถูกต้องไหม | `ss -tulpn`, `lsof -i` |
| 3 | เครื่องอื่นต่อ Port นี้ได้ไหม | `nc -zv`, `bash /dev/tcp` |
| 4 | Endpoint ตอบ HTTP ปกติไหม | `curl -I`, `curl -w` |

---

## 1. แนวคิดและโครงสร้างพื้นฐาน

### 1.1 "Service รันอยู่" ไม่ได้แปลว่า "ใช้งานได้"
- Service อาจขึ้น `active (running)` แต่ฟัง Port ผิดหรือไม่ฟังเลย
- Port อาจเปิดฟังอยู่ แต่เครื่องอื่นต่อไม่ได้เพราะ Firewall
- ต่อ Port ได้ แต่แอปตอบ `500` หรือ `502` ก็ยังใช้งานไม่ได้

จึงต้องตรวจทีละชั้น ไม่ใช่ดูแค่ชั้นเดียว

### 1.2 อ่านค่า Address ที่ `ss` แสดง
| Local Address | ความหมาย |
|---|---|
| `0.0.0.0:8080` หรือ `*:8080` | ฟังทุก Interface (IPv4) เครื่องอื่นต่อเข้ามาได้ถ้า Firewall ไม่บล็อก |
| `[::]:8080` | ฟังทุก Interface (IPv6) |
| `127.0.0.1:8080` | ฟังเฉพาะในเครื่องตัวเอง เครื่องอื่นต่อเข้ามาไม่ได้ |
| `10.20.1.50:8080` | ฟังเฉพาะ IP นั้น |

### 1.3 Error จาก curl และ nc แยกปัญหาได้อย่างไร
| อาการ | ความหมายโดยทั่วไป |
|---|---|
| `Connection refused` (curl exit 7) | ถึงเครื่องปลายทางแล้ว แต่ไม่มีโปรแกรมฟัง Port นั้น |
| `Connection timed out` / `Operation timed out` (curl exit 28) | ไม่มีคำตอบกลับ มักเป็น Firewall, Security Group หรือ Routing |
| `Could not resolve host` (curl exit 6) | ปัญหา DNS ยังไม่ถึงขั้นต่อ Port |
| `SSL certificate problem` (curl exit 60) | ใบรับรองหมดอายุ ไม่ตรงชื่อโดเมน หรือไม่น่าเชื่อถือ |
| HTTP `502` / `503` / `504` | เว็บเซิร์ฟเวอร์หน้าบ้านทำงาน แต่ Backend ล่ม ไม่พร้อม หรือตอบช้า |

---

## 2. ตารางสรุป / คำสั่งที่ใช้งานจริง

### 2.1 ชั้น Service (systemd)
| คำสั่ง | ใช้ทำอะไร |
|---|---|
| `systemctl is-active <service>` | ตอบสั้นๆ ว่า `active`, `inactive` หรือ `failed` เหมาะกับสคริปต์ |
| `systemctl is-enabled <service>` | ตรวจว่าตั้งให้เริ่มตอนบูตหรือไม่ (`enabled`/`disabled`) |
| `systemctl status <service>` | ดูสถานะละเอียด Main PID และ Log ท้ายๆ |
| `systemctl list-units --failed` | ดูทุก Service ที่ล้มเหลวในเครื่อง |
| `journalctl -u <service> -n 50 --no-pager` | อ่าน Log ล่าสุดของ Service |

### 2.2 ชั้น Port ในเครื่อง
| คำสั่ง | ใช้ทำอะไร |
|---|---|
| `ss -tulpn` | แสดง Port ที่ฟังอยู่ทั้งหมด (TCP/UDP, Listening, Process, ตัวเลข) ต้องใช้ `sudo` ถึงจะเห็นชื่อ Process ของผู้ใช้อื่น |
| `ss -ltnp 'sport = :8080'` | กรองเฉพาะ Port 8080 |
| `ss -tn state established '( sport = :443 )'` | ดูการเชื่อมต่อที่กำลังใช้งานอยู่ที่ Port 443 |
| `sudo lsof -i :8080` | ดูว่า Process ไหนใช้ Port 8080 อยู่ (ตรวจกรณี Port ชน) |

### 2.3 ชั้นเครือข่ายไปยังปลายทาง
| คำสั่ง | ใช้ทำอะไร |
|---|---|
| `nc -zv 10.20.1.50 5432` | ลองต่อ TCP Port โดยไม่ส่งข้อมูล (`-z` สแกนเฉยๆ, `-v` แสดงผล) |
| `timeout 3 bash -c '</dev/tcp/10.20.1.50/5432' && echo open` | ทางเลือกเมื่อไม่มี `nc` ใช้ bash ต่อ Port โดยตรง |
| `ping -c 3 <host>` | ตรวจว่า IP ถึงกันไหม (บางเครือข่ายปิด ICMP ดังนั้นไม่ตอบ ping ไม่ได้แปลว่า Port ปิด) |

### 2.4 ชั้น Application (curl)
| คำสั่ง | ใช้ทำอะไร |
|---|---|
| `curl -I https://host/health` | ขอเฉพาะ Header ดู Status Code |
| `curl -sS -o /dev/null -w "%{http_code} %{time_total}s\n" URL` | พิมพ์เฉพาะ Status Code กับเวลาที่ใช้ |
| `curl -v URL` | ดูขั้นตอนทั้งหมด (DNS, TCP, TLS, Request, Response) |
| `curl --connect-timeout 5 --max-time 10 URL` | กำหนดเวลาสูงสุด กันคำสั่งค้าง |
| `curl --resolve host:443:10.20.1.50 https://host/` | ทดสอบ IP ปลายทางเฉพาะตัวโดยไม่แก้ DNS |

### ตัวอย่างการไล่ตรวจตามลำดับ (ตัวอย่างประกอบ)

```bash
# 1) Service รันอยู่ไหม
$ systemctl is-active order-api
active

# 2) ฟัง Port ถูกต้องไหม
$ sudo ss -ltnp 'sport = :8080'
State   Recv-Q  Send-Q  Local Address:Port  Peer Address:Port  Process
LISTEN  0       511         127.0.0.1:8080       0.0.0.0:*      users:(("node",pid=18420,fd=19))

# 3) ต่อจากเครื่องอื่นได้ไหม (รันจากเครื่อง app-02)
$ nc -zv 10.20.1.50 8080
nc: connect to 10.20.1.50 port 8080 (tcp) failed: Connection refused

# 4) Endpoint ตอบอย่างไร (รันในเครื่องเดียวกัน)
$ curl -sS -o /dev/null -w "%{http_code} %{time_total}s\n" http://127.0.0.1:8080/health
200 0.012s
```

จากตัวอย่างนี้ Service รันและตอบ `200` ภายในเครื่อง แต่ `ss` แสดง `127.0.0.1:8080` แปลว่าแอปฟังเฉพาะในเครื่อง เครื่องอื่นจึงต่อไม่ได้ ให้ส่งต่อทีมที่ดูแลแอป ไม่ใช่ทีม Network

> ⚠️ **คำเตือน**: อย่าใช้ `curl -k` (ข้ามการตรวจใบรับรอง) เพื่อสรุปว่าระบบปกติ ใช้ได้เฉพาะเพื่อแยกว่าปัญหาอยู่ที่ใบรับรองหรือไม่ และต้องระบุใน Ticket เสมอ ห้ามใส่ Token หรือรหัสผ่านจริงในคำสั่งที่จะคัดลอกไปแปะ Ticket

> **Support Tip**: ถ้าใช้ `curl -w "%{http_code}"` ใน crontab ต้อง Escape เป็น `\%{http_code}` เพราะเครื่องหมาย `%` ใน crontab มีความหมายพิเศษ หรือย้ายคำสั่งไปไว้ในไฟล์สคริปต์

> **Support Tip**: เครื่องมือบางตัวไม่มีติดมากับทุกเครื่อง (`nc`, `lsof`, `telnet`) ถ้าไม่มีให้ใช้ `ss` และ `bash /dev/tcp` แทน และห้ามติดตั้งโปรแกรมบน Production เองโดยไม่ได้รับอนุญาต

---

## 3. กรณีศึกษาและวิธีแก้ปัญหาหน้างาน (Troubleshooting)

| อาการ | สาเหตุที่เป็นไปได้ | วิธีตรวจ / ทำต่อ | ข้อมูลที่ต้องเก็บก่อน Escalate |
|---|---|---|---|
| `systemctl is-active` ได้ `failed` | Config ผิด, Port ชน, ต่อ DB ไม่ได้ตอนสตาร์ท | `systemctl status <svc>` แล้ว `journalctl -u <svc> -n 100 --no-pager` | ผล `status` และบรรทัด Error จาก `journalctl` พร้อมเวลา |
| Service `active` แต่ `ss` ไม่เห็น Port | แอปยังสตาร์ทไม่เสร็จ, ฟังคนละ Port, หรือดู `ss` โดยไม่ใช้ `sudo` | ลอง `sudo ss -ltnp` ตรวจ Port ใน Config ตามเอกสาร | ผล `ss -tulpn` และ Port ที่คาดว่าจะเปิด |
| สตาร์ท Service แล้วขึ้น `Address already in use` | มี Process อื่นใช้ Port นั้นอยู่ | `sudo lsof -i :<port>` หรือ `sudo ss -ltnp 'sport = :<port>'` เพื่อหา PID | ชื่อและ PID ของ Process ที่ถือ Port อยู่ (ไม่ kill เองถ้าไม่ได้อยู่ใน Runbook) |
| `Connection refused` จากเครื่องอื่น แต่ในเครื่องเดียวกันต่อได้ | แอปฟังที่ `127.0.0.1` ไม่ใช่ `0.0.0.0` หรือ Firewall ในเครื่องปฏิเสธ | ดู Local Address ใน `ss` | ผล `ss -ltnp` และผล `nc -zv` จากเครื่องต้นทาง |
| `Connection timed out` | Firewall, Security Group, Route ผิด หรือเครื่องปลายทางดับ | ลอง `ping`, `traceroute -n` (ถ้ามี) และทดสอบจากอีกเครื่องในเครือข่ายเดียวกันเพื่อเทียบ | IP ต้นทาง/ปลายทาง, Port, ผลคำสั่ง และเวลาที่ทดสอบ |
| `curl` ได้ `502` / `504` | Backend ล่มหรือตอบช้า เว็บหน้าบ้านต่อ Backend ไม่ได้ | เช็ก Service และ Port ของ Backend และ `error.log` ของ Nginx | Response Header, บรรทัด `upstream` ใน `error.log`, สถานะ Backend |
| `curl` ได้ `SSL certificate problem` | ใบรับรองหมดอายุหรือไม่ตรงโดเมน | `curl -vI https://host` แล้วดูบรรทัด `expire date`, `subject` และ `issuer` | ข้อความ Error เต็ม วันหมดอายุที่เห็น และชื่อโดเมนที่ทดสอบ |

---

## สรุป
- ตรวจจากล่างขึ้นบน: Service → Port ที่ฟัง → ต่อจากภายนอก → HTTP Response แล้วหยุดที่ชั้นแรกที่ผิดปกติ
- ดู Local Address ใน `ss` เสมอ `127.0.0.1` คือรับเฉพาะในเครื่อง ไม่ใช่ปัญหา Network
- แยก Error ให้ได้: `refused` = ไม่มีโปรแกรมฟัง, `timed out` = ถูกบล็อกหรือไม่มีเส้นทาง, `502/504` = ปัญหาฝั่ง Backend
- ใช้ `curl -w` กับ `--max-time` เพื่อได้ตัวเลขที่เทียบกันได้และไม่ค้าง แล้วแนบผลทั้งหมดใน Ticket

## อ้างอิง
- `man ss`, `man systemctl`, `man curl`, `man nc`, `man lsof`
- curl Exit Codes: https://curl.se/docs/manpage.html
