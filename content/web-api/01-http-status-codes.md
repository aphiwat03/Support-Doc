---
slug: web-http-status-codes
title: ผ่าโครงสร้าง HTTP Status Codes สำหรับวิเคราะห์ปัญหา Web & API
summary: สรุปรหัสสถานะ 2xx, 3xx, 4xx, 5xx และเจาะลึกความต่าง 502 Bad Gateway vs 504 Gateway Timeout พร้อมแผนผัง Reverse Proxy
read_time_minutes: 8
difficulty: beginner
display_order: 1
---

# ผ่าโครงสร้าง HTTP Status Codes สำหรับวิเคราะห์ปัญหา Web & API

เมื่อผู้ใช้งานรายงานว่า **"เข้าเว็บไม่ได้ เกิด Error หน้าขาว"** สิ่งแรกที่ทีม Support ต้องถามหาคือ **HTTP Status Code** เพราะรหัสตัวเลข 3 หลักนี้บอกได้ทันทีว่าปัญหาเกิดที่ฝั่ง Client, Reverse Proxy หรือ Backend Service ภายใน

---

## 1. หมวดหมู่ HTTP Status Code

| กลุ่มรหัส | ประเภท | ความหมายในงาน Support |
|---|---|---|
| **2xx** | Success | คำขอสำเร็จ (เช่น `200 OK`, `201 Created`, `204 No Content`) |
| **3xx** | Redirection | เปลี่ยนเส้นทาง (เช่น `301 Moved Permanently`, `302 Found`, `304 Not Modified`) |
| **4xx** | Client Error | **ความผิดพลาดจากฝั่งผู้เรียก** (ส่งข้อมูลผิด, ไม่ได้ล็อกอิน, ไม่มีสิทธิ์) |
| **5xx** | Server Error | **ความผิดพลาดจากฝั่งระบบ/เซิร์ฟเวอร์** (แอปแครช, ดาต้าเบสล่ม, คอนฟิก Proxy ผิด) |

---

## 2. รหัส 4xx ยอดฮิตที่ต้องแยกแยะให้ขาด

### 401 Unauthorized vs 403 Forbidden
- **401 Unauthorized (จริงๆ คือ Unauthenticated)**: ไม่พบข้อมูลยืนยันตัวตน (ยังไม่ได้ใส่ Token หรือ Token หมดอายุ)
- **403 Forbidden**: ระบบรู้จักตัวตนแล้วว่าคุณคือใคร แต่ **"ไม่มีสิทธิ์ (No Permission)"** ในการเข้าถึงหน้านี้ เช่น พนักงานทั่วไปพยายามเปิดหน้า `/admin`

### รหัส 4xx อื่นๆ:
- **400 Bad Request**: Payload JSON ส่งมาผิด Format หรือขาด Required Field
- **404 Not Found**: Endpoint หรือ URL นั้นไม่มีอยู่จริง
- **405 Method Not Allowed**: เช่น Endpoint รับเฉพาะ `POST` แต่ Client ส่ง `GET` มา
- **429 Too Many Requests**: โดน Rate Limiting บล็อกเนื่องจากยิง Request ถี่เกินโควตา

---

## 3. มหากาพย์ 5xx: สถาปัตยกรรม Reverse Proxy และสาเหตุของปัญหา

ในระบบ Production ทันสมัย สถาปัตยกรรมมักเป็นดังนี้:

```
[Client]  ---- HTTP ---->  [Reverse Proxy: Nginx / ALB]  ---- Upstream ---->  [Backend App: Node / Java]
```

### 1) 500 Internal Server Error
- **ที่มา**: เกิดขึ้นภายในโค้ดของ **Backend App** โดยตรง (เช่น Uncaught Exception, NullPointerException, โค้ดเขียนบัก)
- **วิธีสืบค้น**: ไปเปิด Application Log ของ Backend ดู Stack Trace

### 2) 502 Bad Gateway
- **ที่มา**: เกิดขึ้นที่ตัว **Reverse Proxy (Nginx)**
- **กลไก**: Nginx พยายามส่งต่อไปยัง Upstream Backend (เช่น `localhost:4000`) แต่ Backend **ปิดอยู่, แครชดับ, หรือส่ง TCP RST ปฏิเสธการเชื่อมต่อ (Connection Refused)**
- **วิธีสืบค้น**: ตรวจสอบว่า Backend Service ยังรันอยู่หรือไม่ (`systemctl status` หรือ `docker ps`) และเช็ก Nginx Error Log (`/var/log/nginx/error.log`)

### 3) 504 Gateway Timeout
- **ที่มา**: เกิดขึ้นที่ตัว **Reverse Proxy (Nginx)**
- **กลไก**: Nginx เชื่อมต่อ Backend สำเร็จแล้ว แต่ Backend **ประมวลผลนานเกินไปจนเกินเวลา timeout** (เช่น `proxy_read_timeout 60s`)
- **สาเหตุยอดนิยม**: Backend ติด Slow Query ใน Database, External API ภายนอกไม่ตอบกลับ, หรือ CPU Server พุ่ง 100% จนประมวลผลไม่ทัน

### 4) 503 Service Unavailable
- **ที่มา**: เซิร์ฟเวอร์ไม่พร้อมให้บริการชั่วคราว มักพบเมื่อเปิด **Maintenance Mode**, Server กำลัง Reboot หรือ Connection Queue เต็มจนรองรับผู้ใช้เพิ่มไม่ได้

---

## 4. ตารางสรุปเปรียบเทียบ 502 vs 504

| ประเด็น | 502 Bad Gateway | 504 Gateway Timeout |
|---|---|---|
| **อาการของ Backend** | **ตายสนิท / พอร์ตไม่เปิด / เชื่อมต่อไม่ติด** | **ยังรันอยู่ แต่ประมวลผลนานจน Timeout** |
| **TCP Layer** | Connection Refused / Invalid Response | Connection Established แต่ค้างรอ Response |
| **สาเหตุหลัก** | Service แครช, Out of Memory, พอร์ตผิด | Slow Query, Database Lock, Deadlock, External API ช้า |
| **จุดตรวจแรก** | `systemctl status <service>`, `docker logs` | ดู Query ค้างใน DB, ตรวจ CPU/RAM ของ Backend |
