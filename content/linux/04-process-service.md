---
slug: linux-process-service
title: การจัดการ Process และ systemd Service (ps, top, kill, systemctl, journalctl)
summary: วิธีตรวจสอบสถานะโปรเซสและบริการ systemd การแยกแยะ SIGTERM กับ SIGKILL และขั้นตอนวิเคราะห์เมื่อ Service ล่ม (failed)
read_time_minutes: 10
difficulty: intermediate
display_order: 4
---

# การจัดการ Process และ systemd Service

เมื่อเกิดเหตุการณ์ **"เว็บเข้าไม่ได้"** หรือ **"ระบบประมวลผลค้าง"** สิ่งแรกที่ทีม **Application Support และ NOC Tier 1** ต้องตรวจสอบคือ โปรเซสของแอปพลิเคชันยังทำงานอยู่หรือไม่ และบริการ (Service) อยู่ในสถานะปกติหรือขึ้น `failed` การอ่านสถานะของ `systemd` และการจัดการโปรเซสอย่างถูกวิธีจะช่วยให้แยกแยะสาเหตุและกู้คืนบริการตามคู่มือปฏิบัติงาน (Runbook) ได้อย่างปลอดภัย

---

## 1. แนวคิดและโครงสร้างพื้นฐาน

### 1.1 Process, PID และความต่างระหว่าง Process กับ Service
- **Process (โปรเซส)**: โปรแกรมที่กำลังถูกโหลดขึ้นมาทำงานในหน่วยความจำ มีหมายเลขประจำตัวไม่ซ้ำกันเรียกว่า **PID (Process ID)** และมีโปรเซสแม่เรียกว่า **PPID (Parent PID)**
- **Service (Daemon)**: โปรเซสที่ทำงานอยู่เบื้องหลังอย่างต่อเนื่อง (เช่น เว็บเซิร์ฟเวอร์ หรือฐานข้อมูล) ซึ่งถูกควบคุมดูแลโดยระบบจัดการบริการอย่าง **systemd** (ดูแลทั้งการสั่งเริ่มทำงานตอนเปิดเครื่อง และการสั่ง Restart อัตโนมัติเมื่อโปรเซสล่ม)

### 1.2 สถานะของ Process (คอลัมน์ `STAT` ใน `ps aux`)
| รหัสสถานะ | ความหมาย | สิ่งที่ Support ต้องสังเกต |
|---|---|---|
| `R` (Running) | กำลังประมวลผลบน CPU หรืออยู่ในคิวพร้อมรัน | ปกติ (หากกิน CPU 100% ต่อเนื่องอาจเกิด Infinite loop) |
| `S` (Sleeping) | รอเหตุการณ์บางอย่าง เช่น รอรับ Request จากผู้ใช้ | ปกติสำหรับ Service ที่เปิดรอรับงาน |
| `D` (Uninterruptible Sleep) | รอการอ่านเขียนดิสก์หรือเครือข่าย (I/O) และยังไม่รับสัญญาณใดๆ | หากค้างสถานะ `D` นานผิดปกติ มักเกิดจาก Disk I/O ค้าง หรือ NFS หลุด |
| `Z` (Zombie / Defunct) | โปรเซสทำงานจบแล้ว แต่โปรเซสแม่ยังไม่อ่านค่าสถานะจบงาน (`exit status`) | กินแค่เลข PID ไม่กิน CPU/RAM แต่ถ้ามีจำนวนมากสะท้อนว่าโค้ดของโปรเซสแม่มีบั๊ก |

### 1.3 สัญญาณการสั่งหยุดโปรเซส: `SIGTERM` เทียบกับ `SIGKILL`
- **`SIGTERM` (Signal 15 — ค่าเริ่มต้นของคำสั่ง `kill <PID>`)**: เป็นการขอให้โปรเซสปิดตัวเองอย่างสุภาพ โปรแกรมจะมีเวลาบันทึกข้อมูลที่ค้าง ปิดการเชื่อมต่อฐานข้อมูล และลบไฟล์ชั่วคราวก่อนจบการทำงาน
- **`SIGKILL` (Signal 9 — `kill -9 <PID>`)**: เป็นการสั่งให้ Kernel ตัดการทำงานของโปรเซสทันทีโดยไม่ให้โอกาสโปรแกรมเคลียร์งาน ใช้เฉพาะกรณีที่ส่ง `SIGTERM` ไปแล้วโปรเซสค้างไม่ยอมปิดตามเวลาที่กำหนด

> **Support Tip**: ชื่อบริการพื้นฐานบางตัวอาจต่างกันตามตระกูล Linux เช่น Web Server Apache บน **Ubuntu/Debian** ใช้ชื่อบริการว่า `apache2` แต่บน **RHEL/Rocky Linux** ใช้ชื่อว่า `httpd` ส่วนบริการ SSH บน Ubuntu มักใช้ `ssh` (หรือ `sshd`) ขณะที่ RHEL ใช้ `sshd`

---

## 2. ตารางสรุป / คำสั่งที่ใช้งานจริง

| หมวดหมู่ | คำสั่ง | หน้าที่หลักในงาน Support |
|---|---|---|
| **ดูรายการโปรเซส** | `ps aux` | แสดงโปรเซสทั้งหมดของทุกผู้ใช้ พร้อม `%CPU`, `%MEM`, `STAT` และคำสั่งที่รัน |
| **ติดตามโปรเซสสด** | `top` หรือ `htop` | ดูการใช้ CPU/RAM รายโปรเซสแบบเรียลไทม์ (กด `P` เรียงตาม CPU, กด `M` เรียงตาม RAM, กด `q` ออก) |
| **ส่งสัญญาณปิดโปรเซส** | `kill <PID>`, `kill -9 <PID>`, `pkill <name>` | ปิดโปรเซสอย่างสุภาพ (`kill`), บังคับปิดทันที (`kill -9`), หรือส่งสัญญาณตามชื่อโปรเซส (`pkill`) |
| **ตรวจสถานะบริการ** | `systemctl status <service>` | ดูสถานะปัจจุบัน (`active (running)` หรือ `failed`), เลข Main PID และ Log บรรทัดล่าสุด |
| **ตรวจบริการที่ล่มทั้งหมด** | `systemctl list-units --failed` | แสดงรายชื่อบริการทั้งหมดในเครื่องที่อยู่ในสถานะ `failed` |
| **เช็กสถานะสั้นๆ** | `systemctl is-active <service>` | คืนค่าสั้นๆ ว่า `active` หรือ `inactive`/`failed` |
| **สั่งงานบริการ** | `systemctl start\|stop\|restart <service>` | เริ่ม หยุด หรือรีสตาร์ทบริการ (ต้องมีสิทธิ์ `sudo` และทำตาม Runbook เท่านั้น) |
| **ตั้งค่ารันตอนบูต** | `systemctl enable <service>` | ตั้งให้บริการเริ่มทำงานอัตโนมัติเมื่อเปิดเครื่อง |
| **อ่าน Log ของบริการ** | `journalctl -u <service> -n 100 -f` | ดู Log ของบริการย้อนหลัง 100 บรรทัด (`-n 100`) และติดตามแบบสด (`-f`) หรือระบุเวลาด้วย `--since` |

### ตัวอย่างการตรวจสอบเมื่อบริการขึ้นสถานะ `failed` (ตัวอย่างประกอบ)

```bash
$ systemctl list-units --failed
  UNIT                LOAD   ACTIVE SUB    DESCRIPTION
● order-api.service   loaded failed failed Order Processing API Service

$ systemctl status order-api.service
× order-api.service - Order Processing API Service
     Loaded: loaded (/etc/systemd/system/order-api.service; enabled; preset: enabled)
     Active: failed (Result: exit-code) since Tue 2026-11-03 14:20:11 +07; 1min 15s ago
   Duration: 2.104s
    Process: 18420 ExecStart=/usr/bin/node /opt/order-api/server.js (code=exited, status=1/FAILURE)
   Main PID: 18420 (code=exited, status=1/FAILURE)

Nov 03 14:20:11 app-prod-01 node[18420]: Error: listen EADDRINUSE: address already in use :::8080
Nov 03 14:20:11 app-prod-01 systemd[1]: order-api.service: Main process exited, code=exited, status=1/FAILURE
Nov 03 14:20:11 app-prod-01 systemd[1]: order-api.service: Failed with result 'exit-code'.

$ journalctl -u order-api.service --since "15 minutes ago" -n 50 --no-pager
```

> ⚠️ **คำเตือนสำคัญ**: ห้ามเริ่มต้นแก้ปัญหาโปรเซสค้างด้วยคำสั่ง `kill -9` (`SIGKILL`) ทันที โดยเฉพาะกับโปรเซสฐานข้อมูล (เช่น `postgres`, `mysqld`) หรือโปรเซสที่กำลังเขียนไฟล์ธุรกรรมการเงิน เพราะจะทำให้ข้อมูลเขียนลงดิสก์ไม่ครบและเกิดไฟล์ฐานข้อมูลเสียหาย (Data Corruption) ควรใช้ `systemctl stop` หรือ `kill <PID>` (SIGTERM) ก่อนเสมอ

---

## 3. กรณีศึกษาและวิธีแก้ปัญหาหน้างาน (Troubleshooting)

| อาการที่พบ | สาเหตุที่เป็นไปได้ | วิธีตรวจสอบ / ขั้นตอนทำต่อ | ข้อมูลที่ต้องเก็บก่อน Escalate |
|---|---|---|---|
| บริการอยู่ในสถานะ `Active: failed (Result: exit-code)` | 1. ไฟล์คอนฟิกผิดพลาด<br>2. พอร์ตถูกโปรเซสอื่นแย่งใช้งาน (`EADDRINUSE`)<br>3. เชื่อมต่อฐานข้อมูลปลายทางไม่ได้ตอนเริ่มทำงาน | 1. รัน `systemctl status <service>` ดู `Main PID` และ Exit code<br>2. รัน `journalctl -u <service> -n 100 --no-pager` เพื่ออ่านข้อความ Error เต็ม | ผลลัพธ์ `systemctl status` และข้อความ Error จาก `journalctl -u <service>` ช่วงเวลาที่ล่ม |
| บริการขึ้น `Active: failed (Result: oom-kill)` หรือ `(Result: signal)` พร้อม `status=9/KILL` | เครื่องมีหน่วยความจำ (RAM) ไม่พอ ทำให้ Linux Kernel สั่ง OOM Killer มาบังคับปิดโปรเซส | 1. รัน `systemctl status <service>`<br>2. รัน `free -h` ดูหน่วยความจำปัจจุบัน | ผลลัพธ์ `systemctl status`, `free -h` และเวลาที่โปรเซสถูกตัดการทำงาน |
| พบโปรเซสขึ้น `<defunct>` และสถานะ `Z` (Zombie) ใน `ps aux` | โปรเซสลูกจบการทำงานแล้ว แต่โปรเซสแม่ (PPID) ยังไม่รับทราบสถานะการจบงาน | 1. รัน `ps -ef` หรือ `ps aux` เพื่อดูเลข PID และหาว่าใครคือโปรเซสแม่ (PPID)<br>2. Zombie ฆ่าด้วย `kill -9` ไม่ตายเพราะมันจบการทำงานไปแล้ว ต้องจัดการที่โปรเซสแม่ตาม Runbook | รายชื่อโปรเซส `Z`, เลข PID/PPID จาก `ps -ef` และจำนวน Zombie ที่พบ |
| โปรเซสแอปพลิเคชันค้าง ไม่ตอบสนอง HTTP Request และต้องรีสตาร์ทตาม Runbook | เกิด Deadlock หรือเธรดเต็มในแอปพลิเคชัน | 1. ลองสั่ง `sudo systemctl restart <service>` หรือส่ง `kill <PID>` (SIGTERM) ก่อน<br>2. รอ 10–30 วินาที หากโปรเซสเดิมยังไม่ปิดและ Runbook อนุญาต จึงใช้ `kill -9 <PID>` | เลข PID, `%CPU`/`%MEM` จาก `ps aux` ก่อนสั่งรีสตาร์ท และ Log ช่วงที่ค้าง |

---

## สรุป
- ใช้ `systemctl list-units --failed` และ `systemctl status <service>` เพื่อตรวจสุขภาพของบริการอย่างรวดเร็ว
- เมื่อบริการล่ม ให้เปิดอ่านสาเหตุจาก `journalctl -u <service> -n 100` เสมอ ไม่เดาสุ่มหรือรีสตาร์ทซ้ำโดยไม่ดู Log
- เข้าใจความต่างระหว่าง `kill` (`SIGTERM` = ปิดอย่างสุภาพ) กับ `kill -9` (`SIGKILL` = บังคับตัดทันที)
- โปรเซสสถานะ `Z` (Zombie) คือโปรเซสที่จบไปแล้วแต่โปรเซสแม่ยังไม่อ่านสถานะ ไม่สามารถลบด้วย `kill -9` ที่ตัวลูกโดยตรงได้

## อ้างอิง
- คู่มือในระบบ: `man ps`, `man top`, `man kill`, `man signal`, `man systemctl`, `man journalctl`
- เอกสารทางการ systemd: https://www.freedesktop.org/wiki/Software/systemd/
