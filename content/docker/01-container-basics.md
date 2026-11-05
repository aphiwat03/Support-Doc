---
slug: docker-container-basics
title: คำสั่ง Docker พื้นฐานและการจัดการ Container ในงาน Support
summary: จัดการ Container ประจำวันด้วย docker ps, logs, exec, inspect, stats, การทำความเข้าใจ Port Mapping และวิธี Jump เข้าไปตรวจสอบ
read_time_minutes: 8
difficulty: beginner
display_order: 1
---

# คำสั่ง Docker พื้นฐานและการจัดการ Container ในงาน Support

ในระบบ Cloud Native ปัจจุบัน แอปพลิเคชันเกือบทั้งหมดถูกบรรจุอยู่ใน **Docker Container** เมื่อเกิดปัญหา แอปดับ หรือส่งข้อมูลไม่ผ่าน ทีม Support จำเป็นต้องใช้คำสั่ง Docker ตรวจสอบสถานะและดู Log ได้อย่างคล่องแคล่ว

---

## 1. คำสั่งตรวจสอบสถานะ Container

### 1) ตรวจสอบรายการ Container ด้วย `docker ps`
```bash
# แสดงเฉพาะ Container ที่กำลังรันอยู่ (Running)
docker ps

# แสดง Container ทั้งหมด รวมทั้งตัวที่หยุดทำงาน (Exited / Crashed)
docker ps -a
```

### สถานะที่ต้องจับตาในคอลัมน์ STATUS:
- `Up 2 hours`: กำลังทำงานปกติ
- `Up 3 hours (healthy)`: ทำงานปกติและ Healthcheck ผ่าน
- `Restarting (1) 5 seconds ago`: **สัญญาณอันตราย!** Container กำลังติด Crash Loop (แอปพังแล้ว Docker พยายามสตาร์ทใหม่ซ้ำๆ)
- `Exited (137) 10 minutes ago`: Container ดับลง โดยมี Exit Code กำกับ

---

## 2. การตรวจสอบ Log ด้วย `docker logs`

เมื่อ Container ดับ หรือแอปพลิเคชันทำงานผิดปกติ ให้เปิดดู Standard Output (stdout/stderr):

```bash
# ดู Log 100 บรรทัดล่าสุด
docker logs --tail 100 app_backend

# ดู Log แบบ Real-time (Streaming) คล้าย tail -f
docker logs -f --tail 50 app_backend

# ดู Log พร้อมระบุ Timestamp
docker logs -t --tail 50 app_backend
```

---

## 3. การเข้าไปตรวจสอบภายใน Container ด้วย `docker exec`

หากต้องการเข้าไปทดสอบ ping, curl หรือตรวจไฟล์คอนฟิกภายใน Container:

```bash
# เปิด Interactive Shell เข้าไปยัง Container
docker exec -it app_backend sh

# หาก Container มี bash ติดตั้งอยู่
docker exec -it app_backend bash
```
- เมื่อเข้าไปแล้ว ให้ทดสอบเชื่อมต่อ Database หรือดู Environment Variables ด้วยคำสั่ง `env`
- ออกจาก Container ด้วยการพิมพ์ `exit`

---

## 4. ตรวจสอบคอนฟิกเชิงลึกด้วย `docker inspect`

คำสั่ง `docker inspect` คืนค่า JSON ละเอียดเกี่ยวกับ Container:

```bash
# ดูข้อมูลทั้งหมดของ Container
docker inspect app_backend

# ดึงเฉพาะ IP Address ของ Container
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' app_backend

# ตรวจสอบสถานะ Healthcheck
docker inspect -f '{{json .State.Health.Status}}' app_backend
```

---

## 5. ตรวจสอบการใช้ทรัพยากรด้วย `docker stats`

```bash
# แสดง CPU %, Memory %, Network I/O ของทุก Container แบบสดๆ
docker stats
```
- หากพบคอลัมน์ `MEM USAGE / LIMIT` ใกล้ถึง 100% บ่งชี้ว่า Container เสี่ยงต่อการโดนระบบสั่งฆ่าเนื่องจากหน่วยความจำเต็ม (OOMKilled)

> ⚠️ **ข้อควรระวัง (Warning)**:
> หลีกเลี่ยงการแก้ไขไฟล์โค้ดหรือคอนฟิกภายใน Container โดยตรงด้วย `docker exec` เพราะ Container ถูกออกแบบให้เป็น **Stateless (Ephemeral)** หาก Container ถูก Restart ข้อมูลที่แก้ไขจะสูญหายทันที
