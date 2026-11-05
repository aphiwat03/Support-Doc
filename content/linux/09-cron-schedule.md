---
slug: linux-cron-schedule
title: การตรวจสอบงานตั้งเวลาด้วย Cron และ Crontab (crontab -l, /etc/cron.d, Cron Log)
summary: โครงสร้างเวลา 5 ฟิลด์ของ Crontab ความต่างของบริการ cron บน Ubuntu กับ RHEL และวิธีไล่ปัญหาเมื่อ Batch Job ไม่ทำงานตามเวลา
read_time_minutes: 9
difficulty: intermediate
display_order: 9
---

# การตรวจสอบงานตั้งเวลาด้วย Cron (Scheduled Jobs)

ในระบบองค์กร งานประมวลผลรอบดึก (Batch Job) เช่น การสรุปรายงานประจำวัน การตัดยอดเงิน หรือการสำรองข้อมูล มักถูกตั้งเวลาไว้ด้วยบริการ **Cron** ปัญหาที่ทีม **Application Support และ NOC Tier 1** พบบ่อยคือ *"สคริปต์รันด้วยมือผ่านปกติ แต่พอตั้งเวลาใน Cron แล้วไม่ทำงานหรือได้ผลลัพธ์ไม่ครบ"* การอ่านตาราง Crontab และตรวจสอบ Log ของ Cron จึงเป็นทักษะสำคัญในการวิเคราะห์สาเหตุเบื้องต้น

---

## 1. แนวคิดและโครงสร้างพื้นฐาน

### 1.1 โครงสร้างเวลา 5 ฟิลด์ของ Crontab
บรรทัดตั้งเวลาใน Crontab ประกอบด้วยตัวเลขเวลา 5 ฟิลด์คั่นด้วยช่องว่าง ตามด้วยคำสั่งที่ต้องการรัน:

```text
*  *  *  *  *   /path/to/command
│  │  │  │  └── วันในสัปดาห์ (Day of Week: 0 - 7 โดย 0 และ 7 คือวันอาทิตย์)
│  │  │  └───── เดือน (Month: 1 - 12)
│  │  └──────── วันที่ในเดือน (Day of Month: 1 - 31)
│  └─────────── ชั่วโมง (Hour: 0 - 23 แบบ 24 ชั่วโมง)
└────────────── นาที (Minute: 0 - 59)
```

| สัญลักษณ์ / คำย่อ | ความหมาย | ตัวอย่าง | คำอธิบาย |
|---|---|---|---|
| `*` | ทุกๆ ค่าของฟิลด์นั้น | `* * * * *` | รันทุกๆ 1 นาที |
| `,` (Comma) | ระบุหลายค่าแยกกัน | `0 8,20 * * *` | รันเวลา 08:00 น. และ 20:00 น. ของทุกวัน |
| `-` (Dash) | ช่วงต่อเนื่อง | `0 9 * * 1-5` | รันเวลา 09:00 น. เฉพาะวันจันทร์ถึงศุกร์ |
| `/` (Step) | หารลงตัว / ทุกๆ ระยะ | `*/15 * * * *` | รันทุกๆ 15 นาที (นาทีที่ 0, 15, 30, 45) |
| `@reboot` | รัน 1 ครั้งหลังเครื่องบูตเสร็จ | `@reboot /opt/app/start.sh` | ใช้สั่งรันสคริปต์เมื่อเปิดเครื่องใหม่ |
| `@daily` (หรือ `@midnight`) | รันวันละครั้งตอนเที่ยงคืน | `@daily /opt/app/cleanup.sh` | เทียบเท่ากับ `0 0 * * *` |

### 1.2 ความต่างระหว่าง User Crontab กับ `/etc/cron.d/` และ `systemd timer`
1. **User Crontab (`crontab -l` / `crontab -e`)**: ตารางงานประจำตัวของผู้ใช้คนนั้นๆ มี **5 ฟิลด์เวลา** ตามด้วยคำสั่งทันที (ไม่ต้องระบุชื่อผู้ใช้ในบรรทัด)
2. **System Crontab (`/etc/crontab` และไฟล์ใน `/etc/cron.d/`)**: ตารางงานระดับระบบ จะมี **ฟิลด์ชื่อผู้ใช้ (User)** แทรกเพิ่มเข้ามาเป็นคอลัมน์ที่ 6 ก่อนตัวคำสั่ง เช่น `30 2 * * * appuser /opt/app/backup.sh`
3. **`systemd timer`**: กลไกตั้งเวลาสมัยใหม่ของ `systemd` (ไฟล์นามสกุล `.timer` คู่กับ `.service`) ซึ่งบางระบบนำมาใช้แทน Cron สามารถตรวจสอบรายการทั้งหมดได้ด้วยคำสั่ง `systemctl list-timers`

### 1.3 ชื่อบริการและตำแหน่ง Log ของ Cron แยกตามตระกูล Linux
| รายการ | Ubuntu / Debian | RHEL / Rocky / AlmaLinux |
|---|---|---|
| **ชื่อบริการ systemd** | `cron` (`systemctl status cron`) | `crond` (`systemctl status crond`) |
| **ไฟล์บันทึก Log ของ Cron** | `/var/log/syslog` (กรองด้วย `grep CRON /var/log/syslog`) | `/var/log/cron` |

---

## 2. ตารางสรุป / คำสั่งที่ใช้งานจริง

| คำสั่ง | ตัวอย่างการใช้งาน | หน้าที่หลักในงาน Support |
|---|---|---|
| `crontab -l` | `crontab -l` หรือ `sudo crontab -u appuser -l` | แสดงรายการงานตั้งเวลาของผู้ใช้ปัจจุบัน หรือระบุชื่อผู้ใช้ด้วย `-u` |
| `crontab -e` | `crontab -e` | เปิดแก้ไขตาราง Crontab (ระดับ Tier 1 ใช้ `crontab -l` เพื่ออ่านตรวจสอบเท่านั้น) |
| `ls -la /etc/cron*` | `ls -la /etc/cron.d/ /etc/cron.daily/` | ตรวจสอบว่ามีงานตั้งเวลาถูกวางไว้ในโฟลเดอร์ระดับระบบหรือไม่ |
| `systemctl status` | `systemctl status cron` (Ubuntu) / `systemctl status crond` (RHEL) | ตรวจว่าบริการ Cron Daemon กำลังทำงาน (`active (running)`) อยู่หรือไม่ |
| `grep CRON` / อ่าน Log | `grep CRON /var/log/syslog \| tail -n 30` (Ubuntu)<br>`sudo tail -n 30 /var/log/cron` (RHEL) | ตรวจสอบว่าถึงเวลาแล้ว Cron ได้สั่งปลุกคำสั่งนั้นขึ้นมาทำงานจริงหรือไม่ |
| `systemctl list-timers` | `systemctl list-timers --all` | ดูตารางเวลาของ `systemd timer` ทั้งหมด (กรณีไม่ได้ตั้งใน Crontab) |

### ตัวอย่างการตรวจสอบตาราง Crontab และ Log การทำงาน (ตัวอย่างประกอบ)

```bash
# 1. ดูรายการ Crontab ของผู้ใช้ appuser
$ sudo crontab -u appuser -l
# m h  dom mon dow   command
0 2 * * * /usr/bin/python3 /opt/app/daily_settlement.py >> /var/log/app/settlement.log 2>&1
*/10 * * * * /opt/app/check_queue.sh >> /var/log/app/queue.log 2>&1

# 2. ตรวจสอบว่า Cron สั่งรันงานตอน 02:00 น. จริงหรือไม่ (ตัวอย่างบน Ubuntu)
$ grep "CRON" /var/log/syslog | grep "daily_settlement"
Nov  3 02:00:01 app-prod-01 CRON[28410]: (appuser) CMD (/usr/bin/python3 /opt/app/daily_settlement.py >> /var/log/app/settlement.log 2>&1)

# 3. เปิดอ่านไฟล์ Log ของตัวสคริปต์ที่ Redirect เอาไว้
$ tail -n 10 /var/log/app/settlement.log
2026-11-03 02:00:02 INFO Starting daily settlement batch...
2026-11-03 02:01:45 INFO Processed 14,250 transactions successfully.
```

> ⚠️ **คำเตือนสำคัญ**: ห้ามรันคำสั่ง `crontab -r` เด็ดขาด! เพราะ `-r` (Remove) คือการลบตาราง Crontab ทั้งหมดของผู้ใช้นั้นทิ้งทันทีโดยไม่ถามยืนยัน (และปุ่ม `r` บนคีย์บอร์ดอยู่ติดกับปุ่ม `e` ของ `crontab -e`) ในงานตรวจสอบของ Tier 1 ให้ใช้เฉพาะ `crontab -l` เท่านั้น

> **Support Tip**: Log ของ Cron (`/var/log/cron` หรือ `/var/log/syslog`) บอกเพียงว่า **"Cron ได้สั่งรันคำสั่งนั้นแล้วหรือยัง"** แต่ไม่ได้บอกผลลัพธ์หรือ Error ข้างในสคริปต์ ดังนั้นในบรรทัด Crontab ที่ดีจึงต้องต่อท้ายด้วย `>> /path/to/job.log 2>&1` เสมอเพื่อเก็บทั้งผลรันปกติและข้อความ Error ลงไฟล์

---

## 3. กรณีศึกษาและวิธีแก้ปัญหาหน้างาน (Troubleshooting)

| อาการที่พบ | สาเหตุที่เป็นไปได้ | วิธีตรวจสอบ / ขั้นตอนทำต่อ | ข้อมูลที่ต้องเก็บก่อน Escalate |
|---|---|---|---|
| สคริปต์รันด้วยมือผ่านปกติ แต่พอรันผ่าน Cron แล้วไม่ทำงาน หรือฟ้อง `command not found` ใน Log | สภาพแวดล้อมของ Cron มีค่าตัวแปร `PATH` จำกัดมาก (มักมีแค่ `/usr/bin:/bin`) ทำให้หาคำสั่งอย่าง `node`, `python3` หรือ `docker` ที่อยู่ใน `/usr/local/bin` ไม่เจอ | 1. ดูบรรทัดงานด้วย `crontab -l`<br>2. ตรวจไฟล์ Log ของสคริปต์ว่าฟ้อง `command not found` ที่บรรทัดไหน (ต้องแก้โดยระบุ Absolute Path เต็มของคำสั่ง เช่น `/usr/local/bin/node`) | บรรทัดจาก `crontab -l`, พาธเต็มของคำสั่ง (`which <cmd>`) และข้อความ Error จากไฟล์ Log |
| ถึงเวลาที่ตั้งไว้แล้ว แต่ไม่มีบันทึกการรันใน Log ของ Cron เลย | 1. บริการ `cron` / `crond` หยุดทำงาน<br>2. เวลา/Timezone ของเครื่องไม่ตรงกับเวลาที่คิดไว้<br>3. เขียนไวยากรณ์ใน `/etc/cron.d/` ผิด (เช่น ลืมใส่ชื่อ user หรือสิทธิ์ไฟล์ไม่ใช่ `644`) | 1. เช็ก `systemctl status cron` (หรือ `crond`)<br>2. เช็ก `timedatectl` ดูเวลาเครื่อง<br>3. ดู Log ของบริการ Cron ว่าฟ้อง Syntax/Permission error หรือไม่ | สถานะบริการ `cron`/`crond`, เวลาเครื่องจาก `timedatectl` และเนื้อหาไฟล์ Crontab |
| คำสั่งใน Crontab ที่มีเครื่องหมาย `%` (เช่น `date +%Y%m%d`) ทำงานผิดพลาดเมื่อรันผ่าน Cron | ใน Crontab เครื่องหมาย `%` ที่ไม่ใส่ `\` นำหน้าจะถูกตีความเป็น **การขึ้นบรรทัดใหม่ (Newline)** | ตรวจดูบรรทัดใน `crontab -l` ว่ามีการใช้ `%` โดยไม่ได้ใส่ Backslash (`\%`) หรือไม่ | บรรทัด Crontab ที่พบเครื่องหมาย `%` เพื่อแจ้งให้ทีมแก้ไขเป็น `\%` หรือย้ายเข้าไฟล์สคริปต์ `.sh` |
| เห็นใน `/var/log/cron` ว่า `CMD (...)` ถูกรันแล้ว แต่ไม่รู้ว่าทำไมงานข้างในล้มเหลว | บรรทัด Crontab ไม่ได้ทำ Redirection (`>> ... 2>&1`) ไว้ ทำให้ข้อความ Error หายไป (หรือถูกส่งเข้า local mail ของเครื่อง) | 1. ตรวจ `crontab -l` ว่าส่ง Output ไปที่ไฟล์ไหน<br>2. หากไม่ได้ส่งลงไฟล์ อาจลองเช็ก `/var/mail/<user>` ถ้ามีบริการเมลภายในเครื่อง | บรรทัดจาก `crontab -l` และหลักฐานจาก Log ของ Cron ที่ยืนยันว่าปลุกงานแล้วแต่ไม่มีไฟล์ Log รองรับ |

---

## สรุป
- อ่านฟิลด์เวลา 5 ตำแหน่งของ Crontab ให้แม่นยำ: **นาที (0-59) | ชั่วโมง (0-23) | วันที่ (1-31) | เดือน (1-12) | วันในสัปดาห์ (0-7)**
- จำความต่างของ OS: Ubuntu ใช้บริการชื่อ `cron` และดู Log ใน `/var/log/syslog` ส่วน RHEL ใช้ชื่อ `crond` และดู Log ใน `/var/log/cron`
- สาเหตุอันดับ 1 ที่รันมือผ่านแต่รันใน Cron พัง คือไม่ได้ระบุ **Absolute Path** ของคำสั่งและไฟล์ หรือไม่ได้ Escape เครื่องหมาย `\%`
- ใช้ `crontab -l` ในการตรวจสอบเสมอ และระวังห้ามพิมพ์ `crontab -r` เด็ดขาด

## อ้างอิง
- คู่มือในระบบ: `man crontab`, `man 5 crontab`, `man cron`, `man systemd.timer`
- เอกสาร Ubuntu CronHowto และ Red Hat Configuring Periodic Tasks
