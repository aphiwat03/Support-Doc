---
slug: linux-log-reading
title: การอ่านและวิเคราะห์ System & Application Log (journalctl, dmesg, zgrep, logrotate)
summary: ตำแหน่งไฟล์ Log มาตรฐานบน Ubuntu/Debian และ RHEL การค้นหา Log ตามช่วงเวลา การอ่านไฟล์ที่ถูก Rotate (.gz) และข้อควรระวังเรื่อง Timezone
read_time_minutes: 10
difficulty: intermediate
display_order: 6
---

# การอ่านและวิเคราะห์ System & Application Log

หัวใจสำคัญที่สุดของงาน **Application Support และ NOC Tier 1** คือการเปลี่ยนอาการเสียที่ผู้ใช้แจ้ง (เช่น "ทำรายการไม่สำเร็จตอน 10:15 น.") ให้กลายเป็นหลักฐานทางเทคนิคจากไฟล์ Log เพื่อระบุสาเหตุเบื้องต้นและส่งต่อข้อมูลที่ครบถ้วนให้ทีม Tier 2 / นักพัฒนาได้อย่างตรงจุด

---

## 1. แนวคิดและโครงสร้างพื้นฐาน

### 1.1 ตำแหน่งไฟล์ Log สำคัญแยกตามตระกูล Linux
ไฟล์ Log มาตรฐานจะอยู่ที่ `/var/log/` แต่ชื่อไฟล์หลักของระบบจะต่างกันระหว่างสาย **Ubuntu/Debian** และสาย **RHEL/Rocky Linux** ดังนี้:

| ประเภทข้อมูล Log | Ubuntu / Debian | RHEL / Rocky / AlmaLinux | สิ่งที่ตรวจสอบได้จากไฟล์นี้ |
|---|---|---|---|
| **System Log ทั่วไป** | `/var/log/syslog` | `/var/log/messages` | เหตุการณ์ทั่วไปของระบบ บริการสตาร์ท/หยุด และ Cron (บน Ubuntu) |
| **Authentication / SSH** | `/var/log/auth.log` | `/var/log/secure` | ประวัติการล็อกอิน SSH สำเร็จ/ล้มเหลว และการใช้คำสั่ง `sudo` |
| **Kernel Ring Buffer** | `/var/log/kern.log` หรือ `dmesg` | `dmesg` | ปัญหาระดับ Kernel, ฮาร์ดแวร์, ดิสก์ I/O Error และ **OOM Killer** |
| **Web Server (Nginx)** | `/var/log/nginx/access.log`, `error.log` | `/var/log/nginx/access.log`, `error.log` | ประวัติ HTTP Request (`access.log`) และข้อผิดพลาดของเว็บ (`error.log`) |
| **Web Server (Apache)** | `/var/log/apache2/` | `/var/log/httpd/` | แยกชื่อโฟลเดอร์ตามชื่อบริการของแต่ละค่าย |

### 1.2 ระดับความรุนแรงของ Log (Log Severity Levels)
- **`DEBUG`**: ข้อมูลละเอียดสำหรับการดีบักของนักพัฒนา
- **`INFO`**: เหตุการณ์การทำงานปกติ (เช่น เริ่มบริการสำเร็จ, ผู้ใช้ล็อกอิน)
- **`WARN` / `WARNING`**: เหตุการณ์ผิดปกติที่ระบบยังทำงานต่อได้ แต่ควรเฝ้าระวัง (เช่น พื้นที่ดิสก์เริ่มเหลือน้อย, ตอบสนองช้ากว่าปกติ)
- **`ERROR` / `ERR`**: เกิดข้อผิดพลาดในการทำรายการนั้นๆ (เช่น เชื่อมต่อฐานข้อมูลล้มเหลว, HTTP 500)
- **`FATAL` / `CRITICAL` / `EMERG`**: ข้อผิดพลาดร้ายแรงจนบริการหรือระบบไม่สามารถทำงานต่อได้

### 1.3 แนวคิดของ `logrotate` และไฟล์ `.gz`
เพื่อไม่ให้ไฟล์ Log โตจนดิสก์เต็ม ระบบ Linux จึงมีบริการ **`logrotate`** คอยตัดไฟล์ Log เก่าตามรอบเวลา (เช่น รายวันหรือรายสัปดาห์) เปลี่ยนชื่อต่อท้ายด้วยวันที่หรือตัวเลข และบีบอัดเป็นไฟล์ `.gz` เช่น:
- `access.log` (ไฟล์ปัจจุบันที่กำลังเขียนอยู่)
- `access.log.1` หรือ `access.log-20261103` (ไฟล์ที่เพิ่งตัดรอบล่าสุด บางระบบยังไม่บีบอัดในรอบแรก)
- `access.log.2.gz`, `access.log.3.gz` (ไฟล์เก่าที่ถูกบีบอัดแล้ว — ต้องใช้ `zgrep`, `zcat`, `zless` ในการอ่านโดยไม่ต้องแตกไฟล์ออกมาก่อน)

---

## 2. ตารางสรุป / คำสั่งที่ใช้งานจริง

| คำสั่ง | ตัวอย่างการใช้งาน | หน้าที่หลักในงาน Support |
|---|---|---|
| `journalctl --since --until` | `journalctl -u nginx --since "2026-11-03 10:00:00" --until "2026-11-03 10:30:00"` | กรอง Log ของบริการเฉพาะช่วงเวลาที่เกิด Incident |
| `journalctl -p err` | `journalctl -p err -b` | ดูเฉพาะ Log ระดับ Error ขึ้นไป (`err`, `crit`, `alert`, `emerg`) ในรอบการบูตปัจจุบัน (`-b`) |
| `dmesg -T` | `dmesg -T \| grep -iE "oom\|kill\|error"` | ดูข้อความจาก Kernel พร้อมแปลงเวลาเป็นวันที่อ่านง่าย (`-T`) |
| `zgrep` | `zgrep -i "timeout" /var/log/nginx/error.log*.gz` | ค้นหาข้อความภายในไฟล์ Log ที่ถูกบีบอัด (`.gz`) ได้ทันทีโดยไม่ต้องแตกไฟล์ |
| `zless` / `zcat` | `zless /var/log/syslog.2.gz` | เปิดอ่านไฟล์ `.gz` ทีละหน้าเหมือนคำสั่ง `less` |
| `timedatectl` หรือ `date` | `timedatectl` | ตรวจสอบเวลาปัจจุบันและ **Timezone** ของเครื่องเซิร์ฟเวอร์ (เช่น `UTC` เทียบกับ `+07`) |

### ตัวอย่างการไล่หา Error ตามช่วงเวลาและตรวจ Timezone (ตัวอย่างประกอบ)

```bash
# 1. ตรวจสอบเวลาและ Timezone ของเซิร์ฟเวอร์ก่อนเทียบกับเวลาที่ลูกค้าแจ้งเสมอ!
$ timedatectl
               Local time: Tue 2026-11-03 10:25:00 UTC
           Universal time: Tue 2026-11-03 10:25:00 UTC
                 RTC time: Tue 2026-11-03 10:25:00
                Time zone: Etc/UTC (UTC, +0000)

# (ลูกค้าแจ้งว่าเกิดปัญหาเวลา 17:15 น. ตามเวลาไทย GMT+7 -> จึงต้องค้นหาเวลา 10:15 UTC ใน Log)
$ journalctl -u checkout-api --since "2026-11-03 10:10:00" --until "2026-11-03 10:20:00" -p err --no-pager
Nov 03 10:15:12 app-prod-01 checkout-api[4120]: [ERROR] tx_id=994812 PaymentGatewayTimeout: Read timed out after 30000ms
Nov 03 10:15:12 app-prod-01 checkout-api[4120]: [ERROR] tx_id=994812 Failed to complete order #ORD-2026-8812

# 2. ค้นหาเหตุการณ์ย้อนหลังจากไฟล์ที่ถูก logrotate บีบอัดเป็น .gz ไปแล้ว
$ zgrep "ORD-2026-8812" /var/log/checkout/*.gz
/var/log/checkout/app.log-20261103.gz:2026-11-03T10:15:12Z ERROR [tx_id=994812] Order ORD-2026-8812 failed
```

> ⚠️ **คำเตือนสำคัญ**: ห้ามใช้ `gunzip` แตกไฟล์ `.gz` ขนาดใหญ่ลงใน `/var/log` โดยตรง เพราะจะทำให้พื้นที่ดิสก์ `/var` เต็มทันที และทำให้ไฟล์ต้นฉบับ `.gz` เปลี่ยนสภาพ ให้ใช้ `zgrep` หรือ `zless` ซึ่งอ่านข้อมูลแบบสตรีมในหน่วยความจำโดยไม่สร้างไฟล์ใหม่บนดิสก์

> **Support Tip**: เซิร์ฟเวอร์บนระบบ Cloud จำนวนมากตั้งค่า Timezone ของเครื่องหรือของไฟล์ Log เป็น **UTC (`+00:00` หรือลงท้ายด้วยตัว `Z`)** ซึ่งช้ากว่าเวลาประเทศไทย (`Asia/Bangkok`, `+07:00`) อยู่ **7 ชั่วโมง** ก่อนค้นหา Log ต้องรัน `date` หรือ `timedatectl` เช็กก่อนเสมอ

---

## 3. กรณีศึกษาและวิธีแก้ปัญหาหน้างาน (Troubleshooting)

| อาการที่พบ | สาเหตุที่เป็นไปได้ | วิธีตรวจสอบ / ขั้นตอนทำต่อ | ข้อมูลที่ต้องเก็บก่อน Escalate |
|---|---|---|---|
| ลูกค้าแจ้งว่าเกิด Error ตอน 14:30 น. (เวลาไทย) แต่ค้นหาคำว่า `14:30` ใน Log แล้วไม่พบอะไรเลย | เวลาในเซิร์ฟเวอร์หรือในไฟล์ Log บันทึกเป็นเวลา **UTC** (`14:30` ไทย = `07:30` UTC) | 1. รัน `date` หรือ `timedatectl` ดู Timezone เครื่อง<br>2. ลองค้นหาที่เวลา `07:30` แทน | บรรทัด Log ที่พบพร้อมระบุใน Ticket ให้ชัดเจนว่าเวลาใน Log เป็น UTC หรือ GMT+7 |
| เหตุการณ์เกิดขึ้นเมื่อวาน พอเปิดไฟล์ `app.log` ปัจจุบันกลับมีเฉพาะข้อมูลตั้งแต่เช้ามืดวันนี้ | ไฟล์ Log เมื่อวานถูก `logrotate` ตัดรอบและบีบอัดเป็นไฟล์ `.gz` ไปแล้ว | 1. รัน `ls -la /var/log/app/` เพื่อดูไฟล์ที่ถูก rotate<br>2. ใช้ `zgrep "คำค้น" /var/log/app/app.log*.gz` | ชื่อไฟล์ที่ค้นพบ, Timestamp และบรรทัด Error เต็มจาก `zgrep` |
| ผู้ใช้แจ้งว่า SSH เข้าเครื่องไม่ได้ หรือบัญชีถูกล็อก | พิมพ์รหัสผ่านผิดเกินกำหนด หรือใช้กุญแจ SSH ผิด | บน Ubuntu รัน `sudo tail -n 50 /var/log/auth.log` ส่วนบน RHEL รัน `sudo tail -n 50 /var/log/secure` | บรรทัดจาก `auth.log` หรือ `secure` ที่ระบุชื่อผู้ใช้และ IP ต้นทางที่ล็อกอินไม่ผ่าน |
| โปรเซสฐานข้อมูลหรือแอปขนาดใหญ่ดับไปเองโดยไม่มี Error ใน Log ของตัวแอปเลย | ถูก Kernel OOM Killer สั่งตัดการทำงานกะทันหัน (`SIGKILL`) ทำให้แอปไม่มีโอกาสเขียน Log ของตัวเอง | รัน `dmesg -T \| grep -iE "oom\|killed process"` หรือ `journalctl -k -p err` เพื่อดูบันทึกของ Kernel | ข้อความ `Out of memory: Killed process ...` จาก `dmesg -T` พร้อมขนาดหน่วยความจำที่ระบุ |

---

## สรุป
- แยกตำแหน่งไฟล์ Log ตามตระกูล OS ให้แม่น: Ubuntu ใช้ `/var/log/syslog` และ `/var/log/auth.log` ส่วน RHEL ใช้ `/var/log/messages` และ `/var/log/secure`
- ตรวจสอบ Timezone ด้วย `date` หรือ `timedatectl` ทุกครั้งก่อนเทียบเวลาที่ผู้ใช้แจ้งกับเวลาใน Log (ระวัง UTC ช้ากว่าไทย 7 ชั่วโมง)
- ใช้ `journalctl -u <service> --since ... --until ... -p err` เพื่อจำกัดวงค้นหาเฉพาะช่วงเวลาและระดับ Error
- ใช้ `zgrep` และ `zless` สำหรับอ่านไฟล์ Log เก่าที่ถูก `logrotate` บีบอัดเป็น `.gz` โดยไม่ต้องแตกไฟล์ลงดิสก์

## อ้างอิง
- คู่มือในระบบ: `man journalctl`, `man dmesg`, `man zgrep`, `man zless`, `man logrotate`, `man timedatectl`
- เอกสาร systemd journal: https://www.freedesktop.org/software/systemd/man/journalctl.html
