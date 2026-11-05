---
slug: web-curl-api-testing
title: การใช้คำสั่ง curl ทดสอบ REST API และวัด Response Time
summary: คู่มือ curl ฉบับเจาะลึก flags สำคัญ (-i, -v, -H, -d, -k), การจำลอง Host Header และการจับเวลา Latency Breakdown ด้วย -w
read_time_minutes: 8
difficulty: beginner
display_order: 2
---

# การใช้คำสั่ง curl ทดสอบ REST API และวัด Response Time

บน Linux Production Server เราไม่มีโปรแกรมอย่าง Postman หรือเว็บเบราว์เซอร์ให้คลิก เครื่องมือหลักที่วิศวกร Support และ DevOps ทั่วโลกต้องใช้เพื่อตรวจสอบความพร้อมของ API คือ **`curl`**

---

## 1. Flags พื้นฐานที่ต้องจำให้ขึ้นใจ

| Flag | ความหมาย | ตัวอย่างการใช้งาน |
|---|---|---|
| `-I` (ใหญ่) | ส่งคำขอแบบ **HEAD** เพื่อดูเฉพาะ Header ไม่เอา Body | `curl -I https://api.example.com` |
| `-i` (เล็ก) | แสดงทั้ง **HTTP Response Headers และ Body** | `curl -i https://api.example.com/health` |
| `-v` | **Verbose Mode**: แสดงทุกขั้นตอนตั้งแต่ DNS, TCP Handshake, SSL Cert ไปจนถึง Headers | `curl -v https://api.example.com` |
| `-X` | ระบุ HTTP Method (`GET`, `POST`, `PUT`, `DELETE`) | `curl -X POST https://api.example.com/users` |
| `-H` | ใส่ Custom Request Header (เช่น Token, Content-Type) | `-H "Authorization: Bearer token123"` |
| `-d` | ส่งข้อมูล Data Payload (JSON Body) | `-d '{"name": "John", "role": "admin"}'` |
| `-k` / `--insecure` | **ข้ามการตรวจสอบใบรับรอง SSL/TLS** (ใช้ทดสอบ Self-signed cert) | `curl -k https://internal-dev:8443` |
| `-s` | **Silent Mode**: ซ่อน Progress bar และ Error message | `curl -s https://api.example.com` |

---

## 2. สูตรคำสั่งยิง REST API แบบสมบูรณ์

### 1) การยิง POST Request พร้อม JSON Payload และ Bearer Token
```bash
curl -i -X POST https://api.example.com/v1/orders \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer eyJhbGciOi..." \
  -d '{
    "customer_id": 105,
    "amount": 2500.00,
    "currency": "THB"
  }'
```

### 2) เทคนิค Support: บังคับยิงตรงไปยัง IP หลังบ้านโดยไม่ผ่าน Cloudflare / WAF
บางครั้งเราต้องการทดสอบว่าปัญหาอยู่ที่ WAF หรืออยู่ที่เครื่อง Web Server หลังบ้าน โดยยังคงรักษา Host Header ไว้:
```bash
# ส่งคำขอไปที่ IP 10.0.1.20 โดยตรง แต่จำลอง Host เป็น api.company.com
curl -v -H "Host: api.company.com" http://10.0.1.20/health

# หรือใช้แฟล็ก --resolve (รองรับทั้ง HTTPS และ SNI)
curl -v --resolve api.company.com:443:10.0.1.20 https://api.company.com/health
```

---

## 3. การจับเวลา Latency Breakdown ด้วย `curl -w`

เมื่อผู้ใช้บอกว่า API ช้า เราสามารถใช้ `curl -w` เพื่อผ่าดูว่าช้าที่ขั้นตอนไหน (DNS, Handshake, SSL หรือ Backend คิดนาน):

```bash
curl -w "\
DNS Lookup Time:   %{time_namelookup} s\n\
TCP Connect Time: %{time_connect} s\n\
TLS Handshake:    %{time_appconnect} s\n\
Time to First Byte: %{time_starttransfer} s\n\
Total Time:        %{time_total} s\n\
HTTP Code:         %{http_code}\n" \
  -o /dev/null -s https://api.example.com/orders
```

### การวิเคราะห์ผลลัพธ์:
- ถ้า `time_namelookup` สูง (> 0.5s): แสดงว่า **DNS Server มีปัญหา**
- ถ้า `time_connect` สูง: แสดงว่า **เครือข่ายมี Latency สูง หรือเครื่องเซิร์ฟเวอร์อยู่ไกล**
- ถ้า `time_appconnect` สูง: แสดงว่า **SSL Negotiation ช้า**
- ถ้า `time_starttransfer` (TTFB) สูง แต่เวลาข้างบนต่ำหมด: แสดงว่า **Backend ประมวลผลช้าเอง (Slow Query / Heavy CPU)**

> ⚠️ **คำเตือนความปลอดภัย (Warning)**:
> หลีกเลี่ยงการใช้ `-k` (`--insecure`) ในสคริปต์อัตโนมัติบนระบบ Production เพราะเป็นการปิดการตรวจสอบ SSL/TLS ซึ่งเปิดช่องโหว่ต่อการถูกดักฟังข้อมูลแบบ Man-in-the-Middle (MitM)
