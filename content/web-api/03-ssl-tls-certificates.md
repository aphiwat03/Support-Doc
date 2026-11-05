---
slug: web-ssl-tls-certificates
title: การตรวจสอบใบรับรอง SSL/TLS และการแก้ปัญหา Certificate หมดอายุ
summary: เจาะลึก Chain of Trust, สาเหตุ Error ยอดนิยม (Expired, Self-signed, Domain Mismatch) และคำสั่ง openssl s_client ตรวจสอบใบรับรอง
read_time_minutes: 8
difficulty: intermediate
display_order: 3
---

# การตรวจสอบใบรับรอง SSL/TLS และการแก้ปัญหา Certificate หมดอายุ

หนึ่งในฝันร้ายของทีม Support คือตอนเช้าตื่นมาพบว่า **"ผู้ใช้งานทั้งประเทศเข้าเว็บไม่ได้ เบราว์เซอร์ขึ้นเตือน Your connection is not private (NET::ERR_CERT_DATE_INVALID)"** เพราะใบรับรอง SSL/TLS หมดอายุ การตรวจสอบวันหมดอายุและความสมบูรณ์ของใบรับรองจึงเป็นทักษะสำคัญ

---

## 1. ห่วงโซ่ความเชื่อถือ (Chain of Trust)

ใบรับรอง SSL/TLS ไม่ได้ออกโดยลอยๆ แต่มีการรับรองเป็นทอดๆ:

```
[Root CA] (เช่น DigiCert, Let's Encrypt - ฝังอยู่ใน OS/Browser)
   │
   ▼
[Intermediate CA] (ผู้ออกใบรับรองระดับกลาง)
   │
   ▼
[Server / Leaf Certificate] (ใบรับรองของโดเมนเรา เช่น api.example.com)
```

หากเซิร์ฟเวอร์ส่งใบรับรองเฉพาะ Leaf Cert แต่ลืมส่ง **Intermediate CA Bundle** เบราว์เซอร์บางตัว (โดยเฉพาะบน Mobile หรือ Java Client) จะแจ้งเตือนว่า Certificate ไม่ปลอดภัยทันที

---

## 2. ข้อผิดพลาด SSL/TLS ที่พบบ่อยที่สุด

| ข้อความ Error | สาเหตุ | วิธีแก้ไข |
|---|---|---|
| `certificate has expired` | ใบรับรองหมดอายุแล้ว (Cert มีอายุ 90 วัน หรือ 1 ปี) | ต่ออายุ Cert (เช่น รัน `certbot renew` หรือสั่งซื้อ Cert ใหม่) |
| `self signed certificate` | ใบรับรองสร้างขึ้นเองโดยไม่มี CA ที่เบราว์เซอร์เชื่อถือรับรอง | อนุญาตให้ใช้เฉพาะบน Dev/UAT หรือนำ Root CA ไป Install ลงในเครื่อง Client |
| `subject name matches target host name` | โดเมนที่เรียกไม่ตรงกับ Common Name (CN) หรือ Subject Alternative Name (SAN) ใน Cert | ตรวจสอบว่าเรียกผ่านโดเมนถูกต้อง ไม่ใช่เรียกผ่าน IP ตรงๆ หรือต้องออก Wildcard Cert |
| `unable to get local issuer certificate` | ขาด Intermediate Certificate ใน Web Server | รวมไฟล์ Full Chain (`fullchain.pem`) ใส่ในคอนฟิกของ Nginx/Apache |

---

## 3. คำสั่งตรวจสอบ SSL/TLS บนเซิร์ฟเวอร์ด้วย `openssl`

### 1) ตรวจสอบ Certificate ปลายทางผ่านพอร์ต 443 ด้วย `s_client`
```bash
# ตรวจสอบวันหมดอายุและรายละเอียดใบรับรองของโดเมน
openssl s_client -connect api.example.com:443 -servername api.example.com < /dev/null | openssl x509 -noout -dates -subject -issuer
```
- `-servername`: ระบุ Server Name Indication (SNI) จำเป็นมากหากเซิร์ฟเวอร์นั้นมีหลายเว็บอยู่บน IP เดียวกัน

### ผลลัพธ์ที่ได้:
```
notBefore=Jan 15 00:00:00 2026 GMT
notAfter=Apr 15 23:59:59 2026 GMT
subject=CN = api.example.com
issuer=C = US, O = Let's Encrypt, CN = R3
```
- ตรวจดูบรรทัด `notAfter` เพื่อดูวันหมดอายุ หากวันหมดอายุเหลือน้อยกว่า 14 วัน ต้องรีบแจ้งทีม DevOps ทันที

### 2) ตรวจสอบไฟล์ `.crt` หรือ `.pem` ที่อยู่บนเครื่อง
```bash
openssl x509 -in /etc/ssl/certs/mycert.crt -noout -enddate
```

> ⚠️ **ข้อควรระวัง (Warning)**:
> เมื่อเปลี่ยนไฟล์ SSL Certificate บนเซิร์ฟเวอร์เสร็จแล้ว ต้องสั่ง **Reload Web Server เสมอ** (เช่น `sudo systemctl reload nginx`) มิฉะนั้น Nginx จะยังคงใช้ Certificate เก่าที่อยู่ในหน่วยความจำ
