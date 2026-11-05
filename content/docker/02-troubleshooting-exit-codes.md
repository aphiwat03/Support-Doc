---
slug: docker-troubleshooting-exit-codes
title: ถอดรหัส Exit Codes และการแก้ปัญหา Container ดับ (OOMKilled 137)
summary: เข้าใจความหมายของ Exit Code 0, 1, 137 (OOMKilled), 143, วิธีตรวจสอบคำสั่ง dmesg และแนวทางแก้ปัญหา CrashLoop
read_time_minutes: 8
difficulty: intermediate
display_order: 2
---

# ถอดรหัส Exit Codes และการแก้ปัญหา Container ดับ (OOMKilled 137)

เมื่อตรวจพบว่า Container หยุดทำงานและขึ้นสถานะ `Exited (...)` รหัสตัวเลขที่อยู่ในวงเล็บคือ **Exit Code** ที่ระบบปฏิบัติการหรือโปรแกรมส่งออกมาก่อนดับลง การเข้าใจตัวเลขเหล่านี้จะช่วยบอกสาเหตุของปัญหาได้ทันทีโดยไม่ต้องคาดเดา

---

## 1. ตาราง Exit Codes ยอดฮิตใน Docker

| Exit Code | สัญญาณ (Signal) | ความหมาย | สาเหตุที่พบบ่อยในงาน Support |
|---|---|---|---|
| **0** | - | จบการทำงานปกติ (Success) | คำสั่งหลักทำงานเสร็จสิ้นสมบูรณ์ (เช่น Batch Script หรือ Database Migration ทำงานเสร็จ) |
| **1** | SIGHUP / Error | ข้อผิดพลาดในระดับ Application | โค้ดมี Uncaught Exception, Syntax Error, หรือขาด Environment Variable ที่จำเป็น |
| **137** | **SIGKILL (128 + 9)** | **ถูกระบบสั่งฆ่าทันที** | **OOMKilled (Out of Memory)**: คอนเทนเนอร์ใช้ RAM เกินโควตาที่กำหนด หรือโดน `docker kill` |
| **139** | SIGSEGV (128 + 11) | Segmentation Fault | โปรแกรมพยายามเข้าถึงหน่วยความจำที่ไม่อนุญาต (มักพบบนภาษา C/C++ หรือ Binary พัง) |
| **143** | **SIGTERM (128 + 15)** | **หยุดการทำงานอย่างสุภาพ** | ได้รับคำสั่งสั่งปิดปกติ เช่น มีคนสั่ง `docker stop` หรือระบบทำการ Deploy เวอร์ชันใหม่ |

---

## 2. เจาะลึกวิกฤต Exit Code 137: OOMKilled (Out of Memory)

เมื่อรัน `docker ps -a` แล้วพบ:
```
CONTAINER ID   IMAGE      STATUS
a1b2c3d4e5f6   my-app     Exited (137) 3 minutes ago
```

### ขั้นตอนยืนยันว่าโดน OOMKilled จริงหรือไม่:

#### วิธีที่ 1: ตรวจสอบผ่าน `docker inspect`
```bash
docker inspect my-app --format 'OOMKilled: {{.State.OOMKilled}}, ExitCode: {{.State.ExitCode}}'
# ผลลัพธ์: OOMKilled: true, ExitCode: 137
```
- หาก `OOMKilled: true` แปลว่าคอนเทนเนอร์ถูก Linux Kernel OOM Killer บังคับปิดเนื่องจากใช้ RAM เกินขีดจำกัด (`--memory`) ที่ตั้งไว้

#### วิธีที่ 2: ตรวจสอบ Kernel Message ด้วย `dmesg`
```bash
sudo dmesg -T | grep -i -E 'oom[-_]killer|out of memory'
# ผลลัพธ์: [Wed Nov 4 10:15:30 2026] Out of memory: Kill process 12450 (node) score 950 or sacrifice child
```

---

## 3. ปัญหา Container Restart วนลูป (Crash Loop)

หากสถานะขึ้นว่า `Restarting (1) 10 seconds ago` สาเหตุหลักมักเกิดจาก:
1. **ขาด Environment Variable**: เช่น ไม่ได้ใส่ค่า `DATABASE_URL` หรือ `SECRET_KEY` ทำให้โปรแกรม Crash ทันทีตอน Start
2. **การพึ่งพาเซอร์วิสอื่น (Race Condition)**: แอปพยายามเชื่อมต่อ Database ทันทีที่สตาร์ท แต่ Database Container ยังบูตไม่เสร็จ
3. **พอร์ตชนกันบน Host**: พอร์ตที่พยายามผูกถูกแอปพลิเคชันอื่นใช้งานอยู่แล้ว

> ⚠️ **คำแนะนำการแก้ไข (Remediation)**:
> 1. ตรวจสอบ Log ก่อน Container ดับด้วย `docker logs <container> --tail 50`
> 2. หากเกิด OOMKilled ให้ปรึกษาทีม Dev เพื่อเพิ่ม Memory Limit หรือตรวจหา Memory Leak ในโค้ด
