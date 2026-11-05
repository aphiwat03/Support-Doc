---
slug: network-dns-resolution
title: การทำงานของระบบ DNS และเทคนิคการสืบค้น (dig, nslookup)
summary: ลำดับการ Resolve โดเมน, ไฟล์ /etc/hosts vs /etc/resolv.conf, ประเภท Record ยอดนิยม และการใช้ dig เจาะหาปัญหา
read_time_minutes: 8
difficulty: beginner
display_order: 2
---

# การทำงานของระบบ DNS และเทคนิคการสืบค้น (dig, nslookup)

คำกล่าวคลาสสิกของชาว Sysadmin และ Support คือ **"It's always DNS"** เพราะเกือบทุก Application ต้องเชื่อมต่อ API หรือ Database ผ่าน Domain Name หาก DNS ล่มหรือ Resolve ไม่ตรง IP ระบบจะหยุดชะงักทันที

---

## 1. ลำดับการ Resolve โดเมนของระบบปฏิบัติการ Linux

เมื่อ Application รันคำสั่งเชื่อมต่อไปยัง `api.example.com` ระบบปฏิบัติการจะตรวจสอบตามลำดับดังนี้:

1. **ตรวจสอบไฟล์ Local Hosts (`/etc/hosts`)**:
   - หากมีการผูก IP ไว้ในไฟล์นี้ ระบบจะใช้ IP นี้ทันทีโดยไม่ถาม DNS ภายนอก
   - มักใช้จำลอง IP หรือแก้ปัญหาเฉพาะหน้าในระบบทดสอบ
2. **ตรวจสอบ Local DNS Cache**:
   - ตรวจดูใน Cache ของเครื่อง (เช่น `systemd-resolved` หรือ `dnsmasq`)
3. **ส่งคำขอไปยัง DNS Nameserver ใน `/etc/resolv.conf`**:
   - ส่ง Query ไปยัง DNS Server ภายนอก (เช่น Internal DNS ขององค์กร หรือ Public DNS เช่น `8.8.8.8`, `1.1.1.1`)

---

## 2. ประเภท DNS Records ที่พบบ่อยในงาน Support

| ประเภท Record | หน้าที่หลัก | ตัวอย่างข้อมูล |
|---|---|---|
| **A Record** | แปลงชื่อโดเมนเป็น **IPv4 Address** | `api.example.com -> 203.0.113.10` |
| **AAAA Record** | แปลงชื่อโดเมนเป็น **IPv6 Address** | `api.example.com -> 2001:db8::1` |
| **CNAME** | Canonical Name (ชื่อแทน / Alias ไปยังอีกโดเมนหนึ่ง) | `www.example.com -> web-lb.aws.com` |
| **MX Record** | Mail Exchanger (บอกเซิร์ฟเวอร์ที่รับอีเมลของโดเมนนั้น) | `example.com -> mail.google.com (priority 10)` |
| **TXT Record** | ข้อความกำกับ (มักใช้ยืนยันกรรมสิทธิ์โดเมน, SPF, DKIM) | `"v=spf1 include:_spf.google.com ~all"` |
| **PTR Record** | Reverse DNS (แปลง IP ย้อนกลับเป็นชื่อโดเมน) | `203.0.113.10 -> mail.example.com` |

---

## 3. คำสั่งสืบค้น DNS: `dig` vs `nslookup`

### 1) การใช้ `dig` (Domain Information Groper)
`dig` เป็นเครื่องมือมาตรฐานสูงสุดที่แม่นยำและให้ข้อมูลครบถ้วน:

```bash
# ตรวจสอบ A record ทั่วไป
dig api.example.com

# แสดงเฉพาะคำตอบสั้นๆ (เหมาะสำหรับดู IP เร็วๆ)
dig api.example.com +short

# บังคับถาม DNS Server เจาะจง (เพื่อดูว่าเซิร์ฟเวอร์หลักอัปเดตหรือยัง)
dig @8.8.8.8 api.example.com +short

# ตรวจสอบ Record ชนิดอื่น เช่น MX หรือ TXT
dig example.com MX +short
dig example.com TXT +short

# ตรวจสอบ Reverse DNS (หาชื่อโดเมนจาก IP)
dig -x 8.8.8.8 +short
```

### 2) การใช้ `nslookup`
```bash
nslookup api.example.com
nslookup api.example.com 8.8.8.8
```

---

## 4. ปัญหาคลาสสิก: DNS TTL และ Propagation Delay

เมื่อทีม DevOps แก้ไข IP ใน DNS Zone แล้ว แต่เซิร์ฟเวอร์บางเครื่องยังคงยิงไปที่ IP เก่า สาเหตุมักเกิดจาก **TTL (Time-To-Live)**:
- DNS Resolver จะจำค่า IP ไว้ตามเวลา TTL ที่กำหนด (เช่น 300 วินาที หรือ 86400 วินาที = 24 ชม.)
- ตราบใดที่ TTL ยังไม่หมดอายุ Resolver จะไม่ไปดึงค่าใหม่

> ⚠️ **ข้อควรระวัง (Warning)**:
> หากต้องการแก้ปัญหาด่วนระหว่างรอ DNS Propagate สามารถใส่ค่าชั่วคราวใน `/etc/hosts` ของเซิร์ฟเวอร์ได้โดยตรง แต่ต้องอย่าลืมลบออกเมื่อ DNS ทั่วโลกอัปเดตเรียบร้อยแล้ว
