--
-- PostgreSQL database dump
--


-- Dumped from database version 16.15
-- Dumped by pg_dump version 16.15

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', 'public', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Clean existing rows before inserting full dump data
TRUNCATE TABLE
  public.study_activity,
  public.lesson_progress,
  public.bookmarks,
  public.quiz_session_answers,
  public.quiz_sessions,
  public.flashcards,
  public.choices,
  public.questions,
  public.lessons,
  public.topics
RESTART IDENTITY CASCADE;


--
-- Data for Name: bookmarks; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: topics; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.topics VALUES (10, 'datacenter', 'Data Center & Hardware Ops', 'สายสัญญาณ Fiber/Copper, ฮาร์ดแวร์เซิร์ฟเวอร์, iDRAC/iLO, SAN Zoning, ระบบไฟ UPS/ATS, Hot/Cold Aisle และเทคนิคสัมภาษณ์ DC', 'Server', 'from-orange-500 to-amber-600', 7, true, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.topics VALUES (5, 'docker', 'Docker & Containers', 'Docker Command, Container Lifecycle, Log, Networking และการแก้ปัญหา Container ล่ม', 'Container', 'from-sky-500 to-blue-600', 5, true, '2026-11-03 09:22:14.247234+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.topics VALUES (1, 'linux', 'Linux Administration', 'คำสั่งพื้นฐาน, การจัดการสิทธิ์ไฟล์, Process, Service systemctl และการวิเคราะห์ Log', 'Terminal', 'from-amber-500 to-orange-600', 1, true, '2026-11-03 09:22:14.247234+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.topics VALUES (3, 'sql', 'SQL & Database Essentials', 'PostgreSQL Query, JOIN, Aggregations, Index, Performance และการตรวจสอบปัญหา DB', 'Database', 'from-emerald-500 to-teal-600', 3, true, '2026-11-03 09:22:14.247234+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.topics VALUES (4, 'web-api', 'Web & HTTP/API', 'HTTP Status Codes, Headers, REST API, curl, SSL/TLS Handshake และ Web Server', 'Globe', 'from-purple-500 to-indigo-600', 4, true, '2026-11-03 09:22:14.247234+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.topics VALUES (6, 'troubleshooting', 'Incident & Troubleshooting', 'ขั้นตอนวิเคราะห์ Root Cause, กรอบมาตรฐาน ITIL/SLA, Windows AD & GPO, อีเมล M365, Network Printer/SMB และแผนสำรองข้อมูล 3-2-1/DR', 'Wrench', 'from-rose-500 to-pink-600', 6, true, '2026-11-03 09:22:14.247234+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.topics VALUES (2, 'network', 'Network', 'สถาปัตยกรรมเครือข่าย, Network Design, TCP/IP, IP/Subnet, DNS, Routing, Switching, VLAN, NAT และเครื่องมือวิเคราะห์', 'Network', 'from-blue-500 to-cyan-600', 2, true, '2026-11-03 09:22:14.247234+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.topics VALUES (11, 'tools', 'Tools', 'เครื่องมือจำลองเครือข่ายและวิเคราะห์ระบบ: Cisco Packet Tracer, GNS3, Wireshark, Nmap, MobaXterm, iPerf3 สำหรับงาน Network & SysAdmin', 'Wrench', 'from-teal-500 to-cyan-600', 8, true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');


--
-- Data for Name: lessons; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.lessons VALUES ('cf0d4598-1c64-4a7f-b8c9-d6a18307a0f9', 5, 'docker-container-basics', 'คำสั่ง Docker พื้นฐานและการจัดการ Container ในงาน Support', 'จัดการ Container ประจำวันด้วย docker ps, logs, exec, inspect, stats, การทำความเข้าใจ Port Mapping และวิธี Jump เข้าไปตรวจสอบ', '
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
docker inspect -f ''{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'' app_backend

# ตรวจสอบสถานะ Healthcheck
docker inspect -f ''{{json .State.Health.Status}}'' app_backend
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
', 8, 'beginner', 1, true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.lessons VALUES ('13d2405e-0e29-4bf2-9f78-03f4f29d3aef', 5, 'docker-troubleshooting-exit-codes', 'ถอดรหัส Exit Codes และการแก้ปัญหา Container ดับ (OOMKilled 137)', 'เข้าใจความหมายของ Exit Code 0, 1, 137 (OOMKilled), 143, วิธีตรวจสอบคำสั่ง dmesg และแนวทางแก้ปัญหา CrashLoop', '
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
docker inspect my-app --format ''OOMKilled: {{.State.OOMKilled}}, ExitCode: {{.State.ExitCode}}''
# ผลลัพธ์: OOMKilled: true, ExitCode: 137
```
- หาก `OOMKilled: true` แปลว่าคอนเทนเนอร์ถูก Linux Kernel OOM Killer บังคับปิดเนื่องจากใช้ RAM เกินขีดจำกัด (`--memory`) ที่ตั้งไว้

#### วิธีที่ 2: ตรวจสอบ Kernel Message ด้วย `dmesg`
```bash
sudo dmesg -T | grep -i -E ''oom[-_]killer|out of memory''
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
', 8, 'intermediate', 2, true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.lessons VALUES ('d610df66-7525-44ca-9e83-02b4749afe01', 10, 'dc-cabling-and-fiber', 'ระบบสายสัญญาณ ไฟเบอร์ออปติก และ Transceiver (Cabling, Fiber & Optics)', 'ความแตกต่างของสาย Single-mode vs Multi-mode, หัวแปลงสัญญาณ SFP/QSFP (SR/LR), การสลับขั้วสายไฟเบอร์ Tx/Rx, รัศมีการโค้งงอ และการเข้าหัวสายแลนมาตรฐาน T568B', '
# ระบบสายสัญญาณ ไฟเบอร์ออปติก และ Transceiver ใน Data Center

ไม่ว่าคุณจะทำงานในบริษัท **Colocation** (เช่น Equinix, NTT, STT GDC) หรือดูแลตู้เซิร์ฟเวอร์ของบริษัท **Hosting** ทักษะพื้นฐานที่ถูกใช้งานทุกวันและถูกถามในการสัมภาษณ์เสมอคือเรื่อง **สายสัญญาณ (Cabling)** ทั้งฝั่งใยแก้วนำแสง (Fiber Optic) และสายทองแดง (Copper UTP)

---

## 1. สายไฟเบอร์ออปติก: Single-Mode (SMF) vs Multi-Mode (MMF)

สายไฟเบอร์ออปติกส่งข้อมูลด้วยแสงผ่านแกนกลางแก้ว (Core) แบ่งออกเป็น 2 ตระกูลหลักที่ช่าง Data Center ต้องแยกให้ออกทันทีจาก **สีของสาย (Jacket Color)** และรหัสมาตรฐาน:

![เปรียบเทียบสายไฟเบอร์ Single-mode (OS2 สีเหลือง) กับ Multi-mode (OM3/OM4 สีฟ้า Aqua)](/images/datacenter/fiber-smf-vs-mmf.png)

| คุณสมบัติ | Single-Mode Fiber (SMF) | Multi-Mode Fiber (MMF) |
|---|---|---|
| **รหัสมาตรฐาน** | **OS1 / OS2** | **OM1 / OM2 / OM3 / OM4 / OM5** |
| **สีปลอกสายมาตรฐาน** | **สีเหลือง (Yellow)** | **สีฟ้าอมเขียว (Aqua)** สำหรับ OM3/OM4, **สีส้ม (Orange)** สำหรับ OM1/OM2, **สีเขียวตอง (Lime Green)** สำหรับ OM5 |
| **ขนาดแกนกลาง (Core)** | เล็กมาก **9 µm** (ไมครอน) — แสงวิ่งเป็นเส้นตรงเส้นเดียว | ใหญ่กว่า **50 µm** (หรือ 62.5 µm ในรุ่นเก่า) — แสงสะท้อนหลายมุม |
| **แหล่งกำเนิดแสง** | Laser (ความยาวคลื่น **1310 nm** หรือ **1550 nm**) | LED / VCSEL (ความยาวคลื่น **850 nm**) |
| **ระยะทางใช้งาน** | **ระยะไกล** (ตั้งแต่ 2 กม., 10 กม. ไปจนถึง 40–80 กม. ระหว่างอาคารหรือข้ามศูนย์ข้อมูล) | **ระยะใกล้ภายในห้อง Data Hall** (ประมาณ 100–400 เมตร ขึ้นกับความเร็ว) |
| **คู่หัว Transceiver** | คู่กับรหัส **LR** (Long Reach), **ER**, **ZR** | คู่กับรหัส **SR** (Short Reach) |

> **Support Tip**: ห้ามนำสาย **Single-mode (สีเหลือง)** ไปเสียบเข้ากับหัวโมดูล **SR (850nm)** หรือเอาสาย **Multi-mode (สีฟ้า)** ไปเสียบโมดูล **LR (1310nm)** เพราะขนาดแกนแสงและความยาวคลื่นไม่ตรงกัน จะทำให้สัญญาณดรอปหรือลิงก์ไม่ขึ้น

---

## 2. ชนิดของหัว Transceiver (SFP / SFP+ / QSFP) และรหัส SR vs LR

โมดูลแปลงสัญญาณแสงเป็นไฟฟ้าที่เสียบเข้าพอร์ตของ Switch หรือการ์ดเครือข่าย (NIC) มีชื่อเรียกตามขนาดและความเร็วดังนี้:

![ชนิดของหัว Transceiver SFP, SFP+, QSFP28 และหัวสายไฟเบอร์แบบ LC Duplex](/images/datacenter/sfp-qsfp-transceivers.png)

### มาตรฐานฟอร์มแฟกเตอร์และความเร็ว
- **SFP (Small Form-factor Pluggable)**: ความเร็ว **1 Gbps**
- **SFP+ (Enhanced SFP)**: ขนาดเท่า SFP เดิม แต่รองรับความเร็ว **10 Gbps** (พบเยอะที่สุดในเซิร์ฟเวอร์ทั่วไป)
- **SFP28**: ขนาดเท่า SFP+ แต่รองรับความเร็ว **25 Gbps**
- **QSFP+ (Quad SFP+)**: มี 4 ช่องสัญญาณรวมกัน รองรับความเร็ว **40 Gbps** ($4 \times 10\text{G}$)
- **QSFP28**: มี 4 ช่องสัญญาณ รองรับความเร็ว **100 Gbps** ($4 \times 25\text{G}$)

### รหัสระยะทางยอดนิยม
- **SR (Short Reach)**: ใช้แสง `850 nm` คู่กับสาย **Multi-mode (OM3/OM4)** ระยะทางไม่เกิน 300–400 เมตร
- **LR (Long Reach)**: ใช้แสง `1310 nm` คู่กับสาย **Single-mode (OS2)** ระยะทางสูงสุดประมาณ 10 กิโลเมตร
- **DAC (Direct Attach Copper)**: สายทองแดงที่มีหัว SFP+/QSFP ติดตายตัวมาจากโรงงาน ใช้เสียบเชื่อมระหว่างเซิร์ฟเวอร์กับ Top-of-Rack (ToR) Switch ในตู้เดียวกัน (ระยะสั้น 1–5 เมตร ราคาประหยัดและกินไฟน้อย)

---

## 3. การสลับขั้วสายไฟเบอร์ (Rolling Fiber: Tx / Rx)

สายไฟเบอร์แบบ Duplex (2 เส้นคู่กัน มีหัวเสียบแบบ **LC connector**) จะประกอบด้วย:
- **Tx (Transmit)**: ขาส่งแสงออก (มักมีแสงสีแดงหรืออินฟราเรดพุ่งออกมา)
- **Rx (Receive)**: ขารับแสงเข้า

หลักการเชื่อมต่อที่ถูกต้องคือ **Tx ของฝั่ง A ต้องวิ่งไปเข้า Rx ของฝั่ง B** และ **Rx ของฝั่ง A ต้องรับมาจาก Tx ของฝั่ง B** (ไขว้กันแบบ Crossover)

![แผนภาพการสลับขั้วสายไฟเบอร์ Tx เข้า Rx (Rolling Fiber)](/images/datacenter/fiber-tx-rx-roll.png)

### อาการเมื่อเสียบสายผิดขั้ว (Tx ชน Tx / Rx ชน Rx)
เมื่อเสียบสายไฟเบอร์ผ่าน Patch Panel หลายทอด แล้วพบว่า **ไฟสถานะพอร์ตบน Switch ไม่ติด (Link Down)** ทั้งที่โมดูลทั้งสองฝั่งทำงานปกติ:
1. สาเหตุอันดับหนึ่งคือ **ขั้วสายไม่ได้ไขว้กัน (Polarity Mismatch)** คือ Tx วิ่งไปชน Tx
2. **วิธีแก้ (Rolling the Fiber)**: ถอดหัวสาย LC ฝั่งหนึ่งออกมา แล้ว **แกะคลิปล็อกสลับตำแหน่งหัวสายคู่ซ้าย-ขวา (สลับขา A กับขา B)** จากนั้นเสียบกลับเข้าไปใหม่ หากไฟ Link กระพริบขึ้นมา แปลว่าแก้ถูกจุดทันที!

> ⚠️ **คำเตือนความปลอดภัยทางสายตา**: ห้ามใช้ตาเปล่าส่องดูปลายสายไฟเบอร์ออปติกโดยตรงเด็ดขาด! แสงเลเซอร์ของโมดูล Single-mode (`1310nm`/`1550nm`) เป็นแสงอินฟราเรดที่ตาคนมองไม่เห็นแต่สามารถทำลายจอประสาทตาได้อย่างถาวร ให้ใช้ **Optical Power Meter** หรือใช้กล้องมือถือส่องตรวจแสงของหัว Multi-mode เท่านั้น

---

## 4. รัศมีการโค้งงอ (Bend Radius) และการทำความสะอาดหัวสาย

1. **Bend Radius (รัศมีการโค้งงอต่ำสุด)**:
   - แกนในของสายไฟเบอร์ทำจากแก้ว หากพับสายหักศอก รัดสายด้วยเคเบิลไทร์แน่นเกินไป หรือดึงสายตึงเกินรัศมีโค้งงอ (ปกติไม่ควรโค้งแคบกว่าวงกลมเส้นผ่านศูนย์กลาง 3–5 ซม.) แสงจะรั่วออกนอกแกนกลาง (Micro/Macro-bending loss) ทำให้ค่าสัญญาณตก (High Attenuation / dB loss) หรือแกนแก้วหักในทันที
   - ในตู้แร็คจึงนิยมใช้ **เทปตีนตุ๊กแก (Velcro Strap)** แทนการรัดด้วยพลาสติกเคเบิลไทร์
2. **การทำความสะอาดหัวไฟเบอร์ (Inspect & Clean)**:
   - ฝุ่นขนาดเพียงไมครอนเดียวที่ปลายหัวフェอร์รูล (Ferrule) สามารถบังลำแสงและทำให้เกิด **CRC Error** หรือลิงก์หลุดๆ ติดๆ (Flapping) ได้
   - ก่อนเสียบสายไฟเบอร์เข้า Transceiver หรือ Patch Panel ทุกครั้ง ต้องใช้ **ปากกาทำความสะอาดหัวไฟเบอร์ (One-Click Fiber Cleaner)** กดทำความสะอาดปลายหัว LC/SC เสมอ

---

## 5. สายทองแดง (Copper UTP) และการเข้าหัว RJ45 มาตรฐาน T568B

สำหรับพอร์ตจัดการระยะไกล (OOB Management เช่น iDRAC/iLO) หรือการเชื่อมต่อความเร็ว 1G/10GBASE-T จะใช้สายทองแดงตีเกลียว (Twisted Pair: Cat5e, Cat6, Cat6A) เข้าหัว **RJ45**

ในการสัมภาษณ์งานช่างเทคนิค Data Center มักถูกถามการเรียงสีสายมาตรฐาน **T568B** (ซึ่งเป็นมาตรฐานหลักที่ใช้ในองค์กรเกือบทั้งหมด):

![ผังการเรียงสีสายแลนมาตรฐาน T568B ทั้ง 8 พิน](/images/datacenter/rj45-t568b-pinout.png)

### ลำดับสีสายมาตรฐาน T568B (เรียงจากพิน 1 ซ้ายมือ ไปถึงพิน 8 ขวามือ เมื่อหันด้านเขี้ยวล็อกลงล่าง)
1. **ขาว-ส้ม** (White/Orange) — `Tx+`
2. **ส้ม** (Orange) — `Tx-`
3. **ขาว-เขียว** (White/Green) — `Rx+`
4. **น้ำเงิน** (Blue)
5. **ขาว-น้ำเงิน** (White/Blue)
6. **เขียว** (Green) — `Rx-`
7. **ขาว-น้ำตาล** (White/Brown)
8. **น้ำตาล** (Brown)

> **Support Tip**: สำหรับความเร็ว **1 Gbps (1000BASE-T)** และ **10 Gbps (10GBASE-T)** จะใช้สายทองแดงครบทั้ง **8 เส้น (4 คู่สาย)** หากเข้าหัวไม่แน่นหรือสายขาดไปเพียง 1 เส้น ความเร็วของพอร์ตจะตกลงมาเหลือแค่ **100 Mbps** (เพราะ 100Mbps ใช้แค่พิน `1, 2, 3, 6`) นี่คือจุดสังเกตสำคัญเวลาเจอปัญหาเครือข่ายช้าผิดปกติ
', 9, 'beginner', 1, true, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.lessons VALUES ('a64393d6-d903-4f53-958f-99df97e3d586', 10, 'dc-server-hardware-oob', 'ฮาร์ดแวร์เซิร์ฟเวอร์ การเข้าตู้แร็ค และระบบจัดการระยะไกล (Server Hardware & OOB)', 'โครงสร้างชิ้นส่วนเซิร์ฟเวอร์ (CPU, DIMM, HBA, Riser, CMOS), มาตรฐานตู้ Rack 42U, การตั้งค่า BIOS/BMC และการใช้ iDRAC, iLO, IPMI, Redfish', '
# ฮาร์ดแวร์เซิร์ฟเวอร์ การเข้าตู้แร็ค และระบบจัดการระยะไกล (OOB)

งานหลักของวิศวกรและช่างเทคนิคประจำศูนย์ข้อมูล (Data Center Operations) คือการติดตั้ง ซ่อมบำรุง อัปเกรดชิ้นส่วนฮาร์ดแวร์ และตรวจสอบอาการเสียผ่านระบบจัดการระยะไกลโดยไม่กระทบต่อเสถียรภาพของระบบ

---

## 1. กายวิภาคและชิ้นส่วนภายในเครื่อง Rack Server

เมื่อเปิดฝาเครื่องเซิร์ฟเวอร์ระดับองค์กร (เช่น Dell PowerEdge, HPE ProLiant, Lenovo ThinkSystem, Supermicro) คุณจะพบชิ้นส่วนสำคัญที่ออกแบบมาเพื่อการทำงานต่อเนื่อง 24/7 ดังนี้:

![โครงสร้างชิ้นส่วนภายในเครื่อง Rack Server ระดับองค์กร](/images/datacenter/server-internals-anatomy.png)

### ชิ้นส่วนสำคัญที่ต้องรู้จักและถอดประกอบได้
1. **CPU (Processor) & Heatsink**:
   - เซิร์ฟเวอร์มักมี 1 หรือ 2 ซ็อกเก็ต (Dual-Socket: `CPU1`, `CPU2`)
   - ก่อนถอดเปลี่ยน CPU ต้องทาซิลิโคนระบายความร้อน (Thermal Paste) ในปริมาณที่เหมาะสม และขันน็อต Heatsink ตามลำดับทแยงมุม (Torque sequence) ที่ระบุบนซ็อกเก็ตเพื่อให้น้ำหนักกดทับหน้าสัมผัสเท่ากันทุกพิน
2. **RAM / DIMM (ECC Memory)**:
   - เซิร์ฟเวอร์ใช้แรมแบบ **ECC (Error-Correcting Code)** เช่น RDIMM หรือ LRDIMM ซึ่งสามารถตรวจจับและแก้ไขบิตข้อมูลที่เพี้ยนเองได้ ป้องกันเครื่องจอฟ้าหรือ Kernel Panic
   - **กฎการเสียบแรม (DIMM Population Rules)**: ห้ามเสียบแรมมั่วช่องเด็ดขาด! ต้องเรียงตามคู่มือบนฝาเครื่องเสมอ (เช่น เริ่มจากช่องสีขาว `A1, B1, A2, B2...` เพื่อให้ทำงานแบบ Multi-Channel เต็มประสิทธิภาพ หากเสียบผิดลำดับ เครื่องอาจไม่บูตหรือร้องเตือน Memory Configuration Error)
3. **Riser Card (การ์ดแปลงสล็อตแนวตั้งเป็นแนวนอน)**:
   - เนื่องจากตัวเครื่องเซิร์ฟเวอร์แบบ 1U หรือ 2U มีความสูงจำกัด จึงไม่สามารถเสียบการ์ด PCIe แนวตั้งตรงๆ ได้ ต้องเสียบการ์ดลงบน **Riser Card** เพื่อวางการ์ดในแนวนอนขนานกับเมนบอร์ด
4. **HBA Card (Host Bus Adapter) & RAID Controller**:
   - **HBA Card**: การ์ดเชื่อมต่อระบบจัดเก็บข้อมูลภายนอก เช่น **Fibre Channel HBA** (มีพอร์ตไฟเบอร์เชื่อมเข้า SAN Switch) หรือ **SAS HBA**
   - **RAID Controller (เช่น Dell PERC, HPE Smart Array)**: การ์ดควบคุมฮาร์ดดิสก์ด้านหน้าเครื่องเพื่อรวมดิสก์เป็น RAID 1, RAID 5, RAID 6 หรือ RAID 10 พร้อมแบตเตอรี่สำรองแคช (BBU / Supercap)
5. **พัดลมระบายความร้อนแบบถอดเปลี่ยนได้ทันที (Hot-Swap Fan Modules)**:
   - เรียงเป็นแถวกลางเครื่อง (Fan Wall) หากพัดลมตัวใดเสีย 1 ตัว พัดลมที่เหลือจะเร่งรอบขึ้นสูงสุด (เสียงดังมาก) และเราสามารถดึงสลักสีส้ม/ม่วงเพื่อเปลี่ยนตัวใหม่ได้ทันทีโดยไม่ต้องปิดเครื่อง
6. **ถ่านเซิร์ฟเวอร์ (CMOS Battery - CR2032)**:
   - เก็บค่าเวลา (RTC) และการตั้งค่า BIOS เบื้องต้น หากถ่านหมดหรือต้องการเคลียร์ค่า BIOS ที่ค้าง (NVRAM Clear) จะใช้วิธีถอดปลั๊กไฟ ถอดถ่าน CMOS หรือสลับจัมเปอร์ `NVRAM_CLR` บนเมนบอร์ด

> ⚠️ **ความปลอดภัยด้านไฟฟ้าสถิต (ESD Protection)**: ก่อนสัมผัสเมนบอร์ด แรม หรือการ์ดใดๆ ต้องสวม **สายรัดข้อมือป้องกันไฟฟ้าสถิต (ESD Wrist Strap)** แล้วหนีบสายกราวด์เข้ากับโครงโลหะของตู้แร็คเสมอ และจับการ์ดหรือแรมที่ขอบแผ่นปริ้นท์เท่านั้น ห้ามนิ้วแตะพินทองเหลืองโดยตรง

---

## 2. การนำเครื่องเข้าตู้แร็ค (Racking & Stacking)

มาตรฐานความสูงของตู้และอุปกรณ์ใน Data Center วัดเป็นหน่วย **U (Rack Unit)**:
- **1U** = **1.75 นิ้ว** (ประมาณ 4.445 เซนติเมตร)
- ตู้แร็คมาตรฐานใน Data Center มักมีความสูง **42U** หรือ **48U** และกว้าง 19 นิ้ว

![มาตรฐานตู้แร็ค 42U รางสไลด์และการจัดวางอุปกรณ์](/images/datacenter/rack-units-racking.png)

### หลักการติดตั้งเครื่องเข้าตู้แร็คอย่างปลอดภัย
1. **วางของหนักไว้ด้านล่างสุดเสมอ (Bottom-Heavy Rule)**:
   - อุปกรณ์ที่มีน้ำหนักมากที่สุด เช่น ตู้แบตเตอรี่ **UPS**, ตู้ **Storage Disk Array (JBOD/SAN)** หรือเซิร์ฟเวอร์ขนาด 4U ต้องติดตั้งไว้ที่ระยะ U ล่างสุดของตู้ เพื่อลดจุดศูนย์ถ่วง ป้องกันตู้แร็คคว่ำขณะดึงเครื่องออกมาซ่อม
2. **การติด Cage Nuts และรางสไลด์ (Sliding Rails)**:
   - อ่านตัวเลข U ที่เสาหน้าซ้าย-ขวา และเสาหลังซ้าย-ขวาให้ตรงกันเป๊ะ (ระวังใส่เหลื่อมรูจนเครื่องเอียง)
   - ใช้เครื่องมือใส่ **Cage Nut** เข้าจากด้านในของเสาสี่เหลี่ยม
   - เมื่อยกเซิร์ฟเวอร์เข้าสวมราง หากเครื่องหนักเกิน 20 กิโลกรัม ต้องใช้คนยกช่วยกันอย่างน้อย 2 คน หรือใช้รถยกเซิร์ฟเวอร์ (**Server Lift**)
3. **การจัดสายด้านหลัง (Cable Management)**:
   - แยกสายไฟ (Power Cords) ไว้ฝั่งหนึ่งของเสาตู้ และสายสัญญาณ (Fiber/UTP) ไว้อีกฝั่งหนึ่ง เพื่อลดสัญญาณรบกวนและให้ถอดเปลี่ยน PSU ได้ง่าย
   - หากใช้แขนจัดสาย (**CMA - Cable Management Arm**) ต้องตรวจสอบว่าสายมีความยาวเผื่อให้ดึงเซิร์ฟเวอร์สไลด์ออกมาข้างหน้าได้สุดรางโดยสายไม่หลุด แต่ต้องระวังไม่ให้แขน CMA ไปบังทางระบายลมร้อนหลังเครื่อง

---

## 3. ระบบจัดการเซิร์ฟเวอร์ระยะไกล (Out-of-Band Management: iDRAC / iLO / IPMI / Redfish)

ในเซิร์ฟเวอร์ระดับองค์กรจะมีชิปคอมพิวเตอร์ขนาดเล็กแยกอิสระอยู่บนเมนบอร์ด เรียกว่า **BMC (Baseboard Management Controller)** ซึ่งทำงานทันทีที่มีการเสียบสายไฟเข้าเครื่อง แม้ว่าเครื่องเซิร์ฟเวอร์นั้นจะยังไม่ได้เปิดสวิตช์ หรือระบบปฏิบัติการ (Linux/Windows) จะค้างสนิทไปแล้วก็ตาม!

![หน้าจอจัดการระยะไกลผ่าน iDRAC / iLO และการตรวจสอบสถานะฮาร์ดแวร์](/images/datacenter/idrac-ilo-oob-console.png)

### ชื่อเรียกตามยี่ห้อเซิร์ฟเวอร์
- **Dell**: **iDRAC** (Integrated Dell Remote Access Controller)
- **HPE (HP)**: **iLO** (Integrated Lights-Out)
- **Supermicro / ทั่วไป**: **IPMI** (Intelligent Platform Management Interface)
- **มาตรฐานยุคใหม่ (RESTful API)**: **Redfish** (ใช้สั่งการผ่าน HTTPS/JSON แทน IPMI แบบเก่า)

### งานที่ใช้ iDRAC / iLO / IPMI ในชีวิตจริงของทีม Support & DC
1. **เช็กว่าชิ้นส่วนไหนเสียจาก System Event Log (SEL)**:
   - เมื่อไฟหน้าเครื่องเปลี่ยนจากสีเขียว/ฟ้า เป็น **สีส้มกระพริบ (Amber Blinking)** แทนที่จะเดาสุ่ม เราสามารถล็อกอินเข้าหน้าเว็บ iDRAC/iLO เพื่ออ่านบันทึกฮาร์ดแวร์ได้ทันที เช่น:
     - `"Correctable memory error rate exceeded for DIMM_A2"` → รู้ทันทีว่าต้องเปลี่ยนแรมช่อง `A2`
     - `"Drive 0 in Bay 3 is in Predictive Failure state"` → เตรียมดิสก์ลูกใหม่ไป Hot-swap ที่ช่อง 3
2. **เปิดหน้าจอเสมือน (Virtual Console / HTML5 KVM)**:
   - ดูหน้าจอบูต BIOS, แก้ไข GRUB, หรือดูหน้าจอ Kernel Panic เหมือนเอาสายจอและคีย์บอร์ดไปเสียบหน้าตู้จริง
3. **Mount ไฟล์ติดตั้ง OS ระยะไกล (Virtual Media)**:
   - แนบไฟล์ `.iso` ของ Ubuntu หรือ Windows Server จากเครื่องคอมพิวเตอร์ของเราเข้าเป็นไดรฟ์จำลองให้เซิร์ฟเวอร์บูตติดตั้ง OS ใหม่ได้จากระยะไกล
4. **สั่งเปิด/ปิด/รีเซ็ตไฟเลี้ยงเครื่องด้วยคำสั่ง `ipmitool`**:
   ```bash
   # เช็กสถานะไฟเลี้ยงของเครื่องระยะไกล
   ipmitool -I lanplus -H 10.100.1.50 -U admin -P SecretPass chassis power status

   # สั่งบังคับรีบูตเครื่องที่ค้างสนิท (Hard Reset)
   ipmitool -I lanplus -H 10.100.1.50 -U admin -P SecretPass chassis power reset

   # อ่านรายการแจ้งเตือนฮาร์ดแวร์ (System Event Log)
   ipmitool -I lanplus -H 10.100.1.50 -U admin -P SecretPass sel elist

   # สั่งเปิดไฟกระพริบสีฟ้า (UID LED / Chassis Identify) เพื่อช่วยช่างหน้าตู้หาเครื่องให้เจอ
   ipmitool -I lanplus -H 10.100.1.50 -U admin -P SecretPass chassis identify 60
   ```

> **Support Tip**: ฟีเจอร์ **UID LED (Unit Identification Light - ไฟสีฟ้าหน้าและหลังเครื่อง)** สำคัญมากในห้อง Data Center ที่มีเซิร์ฟเวอร์หน้าตาเหมือนกันเรียงกันเป็นพันเครื่อง ก่อนลงไปถอดสายหรือเปลี่ยนอะไหล่ ให้สั่งเปิดไฟ UID สีฟ้าผ่าน iDRAC/iLO หรือกดปุ่มหน้าเครื่องก่อนเดินไปหลังตู้เสมอ เพื่อป้องกันการถอดสายผิดเครื่อง!
', 10, 'intermediate', 2, true, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.lessons VALUES ('a8d18af7-6692-4b1b-86b5-88a0d4fb8f9b', 10, 'dc-network-boot-san-blade', 'เครือข่าย OOB, กระบวนการ PXE Boot, ระบบ SAN Zoning และ Blade Server', 'การแยกวงแลน Out-of-Band (OOB), ขั้นตอนการบูตผ่านเครือข่าย PXE (DHCP + TFTP), พื้นฐาน SAN Fibre Channel & Zoning, Blade Server (Cisco UCS / HPE) และ Hypervisor', '
# เครือข่าย OOB, กระบวนการ PXE Boot, ระบบ SAN Zoning และ Blade Server

นอกจากการประกอบฮาร์ดแวร์แล้ว วิศวกรปฏิบัติการ Data Center ต้องเข้าใจว่าเซิร์ฟเวอร์เครื่องเปล่าที่เพิ่งแกะกล่องเข้าตู้แร็ค เชื่อมต่อกับเครือข่ายจัดการระยะไกล โหลดระบบปฏิบัติการอัตโนมัติ และมองเห็นพื้นที่จัดเก็บข้อมูลส่วนกลาง (SAN Storage) ได้อย่างไร

---

## 1. เครือข่าย Out-of-Band (OOB Management Network)

ในสถาปัตยกรรม Data Center มาตรฐาน เครือข่ายจะถูกแยกออกเป็น 2 วงที่แยกจากกันอย่างเด็ดขาด:

![แผนผังการแยกวงเครือข่าย Production (In-Band) และ Out-of-Band (OOB Management)](/images/datacenter/oob-management-topology.png)

1. **In-Band (Production Network)**:
   - พอร์ตไฟเบอร์ความเร็วสูง (10G / 25G / 100G) บนการ์ด NIC ที่เชื่อมต่อเข้ากับ Top-of-Rack Switch สำหรับรับส่งทราฟฟิกของแอปพลิเคชันและผู้ใช้งานจริง
2. **Out-of-Band (OOB Management Network)**:
   - พอร์ตสายแลนทองแดง RJ45 ความเร็ว 1Gbps ที่เขียนว่า `iDRAC`, `iLO`, หรือ `IPMI Mgmt` หลังเครื่องเซิร์ฟเวอร์ รวมกับพอร์ต Console ของ Switch/Router
   - เชื่อมต่อเข้ากับ **Management Switch แยกต่างหาก** และเข้าถึงได้เฉพาะวิศวกรที่ต่อ **VPN / Bastion Jump Host** เท่านั้น
   - **ทำไมต้องแยกวง OOB?** เพราะหากวันใดเกิดเหตุการณ์ตั้งค่า Firewall ผิดพลาดบน OS หรือ Production Switch ล่มจน SSH เข้าเซิร์ฟเวอร์ไม่ได้ วิศวกรยังสามารถเข้าทางวง OOB เพื่อเปิดหน้าจอ Console เข้าไปแก้ไขและกู้คืนระบบได้เสมอ

### การตั้งค่าและตรวจเช็ก OOB เบื้องต้น
- ตั้งค่า IP ของ BMC (iDRAC/iLO) ได้ 2 วิธี: ตั้งผ่านหน้าจอ **BIOS Setup (F2 / F9)** ตอนบูตเครื่อง หรือตั้งค่าให้รับ IP จาก **DHCP (พร้อมผูก MAC Reservation)**
- หากปิง IP ของ iDRAC/iLO ไม่เจอ ให้ตรวจ:
  1. โหมดพอร์ตใน BIOS ตั้งเป็น **Dedicated NIC** (ใช้พอร์ตแยกเฉพาะ) หรือ **Shared LOM** (แชร์พอร์ตเดียวกับการ์ดแลนหลัก)
  2. ไฟสถานะ Link/Act ที่พอร์ต RJ45 หลังเครื่องติดหรือไม่
  3. ค่า Subnet Mask, Default Gateway และ VLAN บนพอร์ต Management Switch ตรงกับวง OOB หรือไม่

---

## 2. กระบวนการบูตของระบบ และ PXE Boot (Preboot Execution Environment)

ในบริษัท Hosting หรือ Cloud ที่มีเซิร์ฟเวอร์หลายพันเครื่อง เราจะไม่เดินถือแฟลชไดรฟ์ไปเสียบลง Linux/Windows ทีละเครื่อง แต่จะใช้การบูตติดตั้งผ่านสายแลนที่เรียกว่า **PXE Boot (อ่านว่า "พิกซี่บูต")**

![ลำดับการทำงานของ PXE Boot ผ่าน DHCP และ TFTP Server](/images/datacenter/pxe-boot-sequence.png)

### ลำดับขั้นตอนการบูตของเครื่องเซิร์ฟเวอร์ตั้งแต่กดปุ่ม Power
1. **Power-On & BMC Initialization**: จ่ายไฟเข้าเมนบอร์ด ชิป BMC ตื่นขึ้นมาตรวจเซนเซอร์ไฟและพัดลม
2. **POST (Power-On Self-Test)**: BIOS/UEFI ตรวจสอบ CPU, นับจำนวน RAM (DIMM), และสแกนหาการ์ด PCIe / HBA / RAID
3. **Boot Device Selection**: BIOS/UEFI มองหาอุปกรณ์บูตตามลำดับที่ตั้งไว้ (เช่น Disk ในเครื่อง หรือ Network PXE)
4. **ขั้นตอน PXE Boot (กรณีบูตผ่านเครือข่ายเพื่อลง OS ใหม่)**:
   - **ขั้นที่ 4.1 (DHCP Discover / Offer)**: การ์ดแลนส่งแพ็กเก็ต广播 (Broadcast) ขอ IP Address จาก DHCP Server
   - **ขั้นที่ 4.2 (DHCP Options 66 & 67)**: DHCP Server ตอบกลับพร้อมมอบ IP Address และแจ้งข้อมูลสำคัญ 2 ค่า คือ **Option 66 (Next-Server / IP ของ TFTP Server)** และ **Option 67 (Boot Filename เช่น `pxelinux.0` หรือ `grubx64.efi`)**
   - **ขั้นที่ 4.3 (TFTP Download)**: การ์ดแลนเชื่อมต่อไปยัง **TFTP Server** (ใช้พอร์ต `UDP 69`) เพื่อดาวน์โหลดไฟล์ Bootloader, Linux Kernel (`vmlinuz`), และ `initrd` ลงมาไว้ใน RAM
   - **ขั้นที่ 4.4 (Automated Installer)**: บูตเข้าสู่ตัวติดตั้งอัตโนมัติ (เช่น Kickstart สำหรับ RHEL/CentOS, Preseed/Cloud-init สำหรับ Ubuntu, หรือ WDS สำหรับ Windows) ดึงไฟล์ระบบปฏิบัติการผ่าน HTTP/NFS จนติดตั้งเสร็จสมบูรณ์
5. **OS Bootloader & Init**: เมื่อมี OS ในดิสก์แล้ว ครั้งต่อไปเครื่องจะบูตเข้า **GRUB2** → โหลด **Linux Kernel** → สตาร์ทโปรเซสหมายเลข 1 คือ **`systemd` (PID 1)** เพื่อเปิดบริการต่างๆ จนขึ้นหน้า Login

---

## 3. พื้นฐานระบบ SAN (Storage Area Network) และการทำ Zoning

ในระบบองค์กรขนาดใหญ่ พื้นที่เก็บข้อมูลสำคัญจะไม่วางไว้แค่ในฮาร์ดดิสก์หน้าเครื่องเซิร์ฟเวอร์ (DAS - Direct Attached Storage) แต่จะเชื่อมต่อผ่านเครือข่ายความเร็วสูงเฉพาะทางที่เรียกว่า **SAN (Storage Area Network)**

![สถาปัตยกรรม Fibre Channel SAN (Fabric A/B) และการทำ WWN Zoning](/images/datacenter/san-fabric-zoning.png)

### คำศัพท์สำคัญของระบบ Fibre Channel SAN ที่ต้องรู้
- **Initiator (ฝั่งผู้ขอใช้ดิสก์)**: คือการ์ด **HBA (Host Bus Adapter)** ที่เสียบอยู่ในเครื่องเซิร์ฟเวอร์
- **Target (ฝั่งผู้ให้บริการดิสก์)**: คือพอร์ตของตู้ **Storage Array** (เช่น NetApp, Dell EMC PowerStore, Pure Storage, Hitachi)
- **WWNN / WWPN (World Wide Node/Port Name)**:
  - เปรียบเสมือน **MAC Address ของโลก Fibre Channel** เป็นตัวเลขฐานสิบหกขนาด 64-bit (เช่น `50:06:0b:00:00:c2:62:01`) ที่ระบุตัวตนของพอร์ต HBA และพอร์ต Storage
- **LUN (Logical Unit Number)**:
  - ก้อนพื้นที่ดิสก์เสมือนที่แบ่งมาจากตู้ Storage Array แล้วส่งมาให้เซิร์ฟเวอร์มองเห็นเหมือนเป็นฮาร์ดดิสก์ลูกหนึ่ง (เช่น `/dev/sdb`)
- **SAN Zoning (การแบ่งโซนบน SAN Switch)**:
  - ทำบน Fibre Channel Switch (เช่น Brocade หรือ Cisco MDS) เพื่อกำหนดสิทธิ์ว่า **พอร์ต HBA ของเซิร์ฟเวอร์เครื่องไหน (Initiator WWPN) มีสิทธิ์มองเห็นพอร์ตของตู้ Storage ตัวไหน (Target WWPN)**
  - กฎมาตรฐานคือ **Single-Initiator Zoning** (1 โซน มีเซิร์ฟเวอร์ 1 พอร์ต จับคู่กับ Storage) เพื่อป้องกันไม่ให้เซิร์ฟเวอร์อื่นมองเห็นหรือเผลอเขียนข้อมูลทับ LUN ของกันและกัน
- **Multipathing (Fabric A & Fabric B)**:
  - เซิร์ฟเวอร์แต่ละเครื่องจะมีพอร์ต HBA 2 พอร์ต แยกต่อเข้า **SAN Switch A** และ **SAN Switch B** หากสวิตช์ตัวใดตัวหนึ่งดับ เซิร์ฟเวอร์ยังอ่านเขียนข้อมูลผ่านอีกเส้นทางได้ต่อเนื่องโดยไม่ล่ม (`multipathd`)

---

## 4. ระบบเบลดเซิร์ฟเวอร์ (Blade Server: Cisco UCS & HPE BladeSystem)

นอกจากเซิร์ฟเวอร์แบบกล่อง 1U/2U (Rack Server) แล้ว ใน Data Center ยังมีเซิร์ฟเวอร์แบบ **Blade Server** ที่นำแผ่นเซิร์ฟเวอร์หลายๆ ใบเสียบรวมกันในโครงตู้เดียว (**Blade Chassis** ขนาด 6U หรือ 10U):

![โครงสร้างตู้ Blade Server Chassis (Cisco UCS / HPE ProLiant Blade)](/images/datacenter/cisco-ucs-hp-blade.png)

- **ข้อดีของ Blade Server**: ใช้ภาคจ่ายไฟ (PSU), พัดลมระบายความร้อน, และโมดูลสวิตช์ด้านหลังร่วมกันทั้งตู้ ช่วยลดจำนวนสายไฟและสายแลนที่ต้องเดินหลังตู้ลงได้มหาศาล
- **Cisco UCS (Unified Computing System)**:
  - มีจุดเด่นคือ **Fabric Interconnect (FI)** และระบบ **Service Profile** ซึ่งเก็บค่าตัวตนของเซิร์ฟเวอร์ (MAC Address, WWPN, การตั้งค่า BIOS, ลำดับการบูต) ไว้เป็นโปรไฟล์ซอฟต์แวร์ หากใบ Blade ใบไหนเมนบอร์ดพัง ช่างสามารถเสียบใบ Blade เปล่าใบใหม่เข้าไป แล้วโยน Service Profile เดิมใส่ เครื่องจะกลับมาทำงานพร้อม MAC และ WWPN เดิมทันทีภายในไม่กี่นาที
- **HPE ProLiant c-Class / HPE Synergy**:
  - ใช้โมดูลจัดการกลางที่เรียกว่า **Onboard Administrator (OA)** หรือ **HPE OneView** ในการควบคุมไฟ พัดลม และ Virtual Connect ทั้ง Chassis

---

## 5. ความรู้พื้นฐานเรื่อง Hypervisor และ Container สำหรับช่าง Data Center

แม้ช่าง Data Center จะดูแลฮาร์ดแวร์เป็นหลัก แต่ในชีวิตจริงเครื่องเซิร์ฟเวอร์เกือบทุกเครื่องทำหน้าที่เป็นโฮสต์รันระบบจำลองเสมือน:

| เทคโนโลยี | ตัวอย่างซอฟต์แวร์ | บทบาทที่เกี่ยวข้องกับงาน Data Center Operations |
|---|---|---|
| **Type-1 Hypervisor (Bare-Metal)** | **VMware ESXi**, **KVM (Proxmox / OpenStack)**, **Citrix XenServer**, **Microsoft Hyper-V** | ติดตั้งลงบนฮาร์ดแวร์เซิร์ฟเวอร์โดยตรงเพื่อแบ่งทรัพยากรเป็นหลาย **VM (Virtual Machine)** ก่อนที่ช่าง DC จะปิดเครื่องโฮสต์เพื่อเปลี่ยนแรมหรือเมนบอร์ด ต้องประสานให้ทีมระบบสั่งเข้า **Maintenance Mode** เพื่อย้าย VM หนีไปยังโฮสต์อื่นก่อนเสมอ (เช่น **VMware vMotion** หรือ **Live Migration**) |
| **Containers** | **Docker**, **containerd**, **Kubernetes (K8s) Worker Nodes** | รันแอปพลิเคชันแบบแยกส่วนโดยแชร์ Linux Kernel เดียวกัน หากโฮสต์ที่เป็น K8s Node ต้องซ่อมฮาร์ดแวร์ ทีมระบบจะสั่ง `kubectl drain <node>` เพื่อย้าย Pod ออกจากเครื่องก่อนให้ช่าง DC ปิดเครื่อง |
', 10, 'intermediate', 3, true, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.lessons VALUES ('92409c70-8fd7-4575-b8c5-22e661376a62', 10, 'dc-power-cooling-facilities', 'ระบบไฟฟ้า 1/3 เฟส, UPS/ATS, การจัดการลมร้อน-ลมเย็น และระบบดับเพลิง DC', 'ความแตกต่างของไฟ 1 เฟส vs 3 เฟส, การทำงานของ UPS และ ATS, ระบบไฟคู่ A/B Feed, ลำดับการเปิด-ปิดไฟตู้แร็ค, Hot/Cold Aisle และสารดับเพลิงสะอาด FM-200 / Novec 1230', '
# ระบบไฟฟ้า (Power), การระบายความร้อน (Cooling) และระบบดับเพลิงใน Data Center

หัวใจสูงสุดของ Data Center คือ **ความพร้อมใช้งานอย่างต่อเนื่อง (Uptime & Availability)** แม้ไฟฟ้าจากการไฟฟ้านครหลวง/ภูมิภาคจะดับ หรือเครื่องปรับอากาศเสียตัวหนึ่ง เซิร์ฟเวอร์ภายในศูนย์ข้อมูลจะต้องไม่ดับตาม นี่คือความรู้ด้านระบบประกอบอาคาร (Facilities: Power & Mechanical) ที่ผู้สัมภาษณ์มักถามเสมอ

---

## 1. ระบบไฟฟ้า 1 เฟส vs 3 เฟส และแรงดันไฟฟ้าใน Data Center

ในการคำนวณโหลดไฟของตู้แร็ค เราใช้สูตรพื้นฐานทางไฟฟ้าคือ:

$$\text{Power (Watts)} = \text{Voltage (V)} \times \text{Current (Amps)}$$

(สำหรับไฟฟ้ากระแสสลับ 3 เฟสที่คำนึงถึง Power Factor จะคำนวณจาก $P = \sqrt{3} \times V \times I \times \text{PF}$)

### ตารางเปรียบเทียบระบบไฟ 1 เฟส (Single-Phase) และ 3 เฟส (Three-Phase)

| คุณสมบัติ | ระบบไฟ 1 เฟส (Single-Phase) | ระบบไฟ 3 เฟส (Three-Phase) |
|---|---|---|
| **โครงสร้างสายไฟ** | 3 เส้น: **Line (L) 1 เส้น** + Neutral (N) + Ground (G) | 4 หรือ 5 เส้น: **Line 3 เส้น (L1, L2, L3)** + Neutral (N) + Ground (G) |
| **แรงดันไฟฟ้าที่พบบ่อย** | **110V–120V** (อเมริกา/ญี่ปุ่น) หรือ **220V–240V** (ไทย/ยุโรป/เอเชีย) | **208V** (อเมริกา) หรือ **380V / 400V / 415V** (ไทย/สากล) และ **480V** ในระดับหม้อแปลงหลักของอาคาร |
| **การใช้งานใน Data Center** | เข้าสู่ภาคจ่ายไฟ (PSU) ของเซิร์ฟเวอร์แต่ละเครื่อง (ส่วนใหญ่รับไฟ `200V–240V AC` ผ่านหัวปลั๊กมาตรฐาน **IEC C13/C14** หรือ **C19/C20**) | จ่ายไฟจากตู้ MDB/PDU หลักเข้าสู่ **Rack PDU (รางปลั๊กไฟอัจฉริยะประจำตู้แร็ค)** เพื่อให้รองรับโหลดไฟสูงระดับ 11kW – 22kW ต่อตู้ และต้องบาลานซ์โหลดทั้ง 3 เฟส (`L1, L2, L3`) ให้ใกล้เคียงกัน |

---

## 2. สายโซ่ระบบไฟฟ้าสำรอง: Utility → Generator → ATS → UPS → A/B PDU

ทำไมเมื่อไฟดับ เซิร์ฟเวอร์ใน Data Center ถึงไม่ดับแม้แต่วินาทีเดียว? เพราะมีสถาปัตยกรรมสำรองไฟหลายชั้นดังนี้:

![ผังระบบไฟฟ้าสำรองใน Data Center: Utility, Generator, ATS, UPS และ A/B Power Feed](/images/datacenter/dc-power-chain-ups-ats.png)

1. **UPS (Uninterruptible Power Supply)**:
   - ทำหน้าที่ **จ่ายไฟสำรองจากแบตเตอรี่ทันทีแบบไร้รอยต่อ (0 มิลลิวินาที)** เมื่อไฟจากการไฟฟ้า (Utility Grid) ตกหรือดับ พร้อมกรองกระแสไฟให้เรียบสม่ำเสมอ (Online Double-Conversion)
   - แบตเตอรี่ของ UPS ใน Data Center ไม่ได้มีไว้รันเซิร์ฟเวอร์ทั้งวัน แต่มีไว้ **ประคองไฟเป็นเวลา 5–15 นาที** เพื่อให้เครื่องปั่นไฟดีเซลสตาร์ทติดและรับช่วงต่อได้ทัน
2. **Generator (เครื่องปั่นไฟดีเซลสำรอง)**:
   - เมื่อไฟหลักดับเกินไม่กี่วินาที เครื่องปั่นไฟขนาดใหญ่จะสตาร์ทอัตโนมัติและเดินเครื่องจนกว่ากระแสไฟจะนิ่ง (ใช้เวลาประมาณ 10–30 วินาที) จากนั้นสามารถจ่ายไฟเลี้ยงทั้งศูนย์ข้อมูลได้นานหลายวันตราบใดที่มีน้ำมันเชื้อเพลิง
3. **ATS (Automatic Transfer Switch)**:
   - สวิตช์สลับแหล่งจ่ายไฟอัตโนมัติ ทำหน้าที่ตรวจจับเมื่อไฟจากการไฟฟ้าดับ แล้วสั่งสตาร์ท Generator พอไฟจาก Generator นิ่งปุ๊บ **ATS จะสลับแหล่งจ่ายไฟจาก Grid ไปยัง Generator อัตโนมัติ** และสลับกลับเมื่อไฟการไฟฟ้ากลับมาปกติ
   - *(ในตู้แร็คบางแห่งที่มีอุปกรณ์ที่มีสายไฟเส้นเดียว เช่น Switch รุ่นเล็ก จะใช้ **Rack ATS** เสียบรับไฟจากทั้งฝั่ง A และฝั่ง B เพื่อแปลงออกเป็นสายเดียวเลี้ยงอุปกรณ์นั้น)*
4. **ระบบจ่ายไฟคู่ (Dual Power Feed: A-Feed & B-Feed)**:
   - เซิร์ฟเวอร์ทุกเครื่องจะมี **PSU 2 ลูก (PSU 1 และ PSU 2)**
   - **กฎเหล็ก**: ห้ามเสียบสายไฟทั้ง 2 เส้นของเซิร์ฟเวอร์เข้าที่รางปลั๊ก PDU ตัวเดียวกันเด็ดขาด! ต้องเสียบ **PSU 1 เข้ากับ PDU ฝั่ง A (A-Feed)** และเสียบ **PSU 2 เข้ากับ PDU ฝั่ง B (B-Feed)** ซึ่งรับไฟมาจาก UPS และเบรกเกอร์คนละชุดกัน
   - **กฎการใช้โหลดไม่เกิน 40%–45% ต่อฝั่ง**: บนรางปลั๊ก PDU แต่ละฝั่ง (A และ B) เราจะใช้กระแสไฟไม่เกิน **40%–45% ของพิกัดเบรกเกอร์** เท่านั้น เพราะหากวันใดไฟฝั่ง B ดับทั้งเส้น โหลดทั้งหมด 100% ของตู้จะเทไปอยู่ที่ฝั่ง A ทันที ($45\% + 45\% = 90\%$) เบรกเกอร์ฝั่ง A จะได้ไม่ทริปตัดไฟตามไป!

---

## 3. ลำดับการเปิดและปิดไฟของตู้แร็ค (Rack Power-Up & Power-Down Sequence)

คำถามสัมภาษณ์ยอดฮิต: *"หากจำเป็นต้องปิดระบบทั้งตู้แร็คเพื่อบำรุงรักษาใหญ่ (Planned Maintenance) และเปิดกลับมาใหม่ คุณจะเรียงลำดับปิดและเปิดอะไรก่อน-หลัง?"*

### ลำดับการปิดระบบ (Power-Down Sequence)
1. **ขั้นที่ 1: ปิด Application & Compute Servers ก่อน** — สั่ง Shutdown ระบบปฏิบัติการของเซิร์ฟเวอร์และ VM ทั้งหมดอย่างถูกวิธี เพื่อให้หยุดเขียนข้อมูลลงดิสก์
2. **ขั้นที่ 2: ปิดตู้ Storage (SAN / NAS / Disk Array)** — เมื่อแน่ใจว่าไม่มีเซิร์ฟเวอร์ใดอ่าน-เขียนข้อมูลแล้ว จึงสั่งปิดตู้ Storage เพื่อป้องกันข้อมูลเสียหาย (Data Corruption)
3. **ขั้นที่ 3: ปิดอุปกรณ์ Network Switches / Routers หลังสุด** — ปิดสวิตช์เป็นลำดับสุดท้าย แล้วจึงสับเบรกเกอร์ของ PDU

### ลำดับการเปิดระบบ (Power-Up Sequence — ย้อนกลับ!)
1. **ขั้นที่ 1: เปิดอุปกรณ์ Network Switches & SAN Switches ก่อน** — รอให้สวิตช์บูตเสร็จและพอร์ตทั้งหมดพร้อมเชื่อมต่อ
2. **ขั้นที่ 2: เปิดตู้ Storage (SAN / NAS / Disk Array)** — รอให้ดิสก์ทั้งหมดหมุนขึ้นและพร้อมให้บริการ LUN
3. **ขั้นที่ 3: ค่อยทยอยเปิด Compute Servers ทีละกลุ่ม (Staggered Power-On)** — เมื่อเซิร์ฟเวอร์บูตขึ้นมาจะสามารถต่อเครือข่ายและมองเห็นก้อน Storage ได้ทันที นอกจากนี้การทยอยเปิดเซิร์ฟเวอร์ทีละชุดยังช่วยป้องกัน **กระแสไฟกระชากตอนสตาร์ท (Inrush Current)** ไม่ให้สูงเกินจนเบรกเกอร์ตู้ทริป!

---

## 4. การจัดการทิศทางลมร้อน-ลมเย็น (Hot Aisle / Cold Aisle Containment)

เซิร์ฟเวอร์ทุกเครื่องถูกออกแบบทิศทางพัดลมเป็นมาตรฐานเดียวกันคือ **"ดูดลมเย็นเข้าทางด้านหน้าเครื่อง (Front Intake) และเป่าลมร้อนออกทางด้านหลังเครื่อง (Rear Exhaust)"**

![การจัดวางตู้แร็คแบบ Hot Aisle / Cold Aisle Containment](/images/datacenter/hot-cold-aisle-containment.png)

- **Cold Aisle (ช่องทางเดินลมเย็น)**:
  - จัดวางตู้แร็คสองแถวให้ **หันด้านหน้าเข้าหากัน** โดยพื้นยก (Raised Floor) ในช่องทางเดินนี้จะเป็นแผ่นพื้นเจาะรู (Perforated Tiles) ให้ลมเย็นจากเครื่องปรับอากาศ **CRAC / CRAH** เป่าขึ้นมาเข้าหน้าเครื่องเซิร์ฟเวอร์โดยตรง
- **Hot Aisle (ช่องทางเดินลมร้อน)**:
  - ด้านหลังของตู้แร็คสองแถวจะหันชนกัน ลมร้อนที่เป่าออกจากท้ายเซิร์ฟเวอร์จะรวมกันอยู่ในช่องนี้และถูกดูดกลับขึ้นเพดานไปเข้าเครื่องทำความเย็น โดยไม่ปะปนกับลมเย็น
- **ความสำคัญของแผ่นปิดช่องว่าง (Blanking Panels)**:
  - หากในตู้แร็คมีช่อง U ที่ว่างอยู่ (ไม่ได้ใส่เครื่อง) ต้องติดแผ่นพลาสติกทึบที่เรียกว่า **Blanking Panel** ปิดไว้เสมอ เพื่อป้องกันไม่ให้ลมร้อนจากด้านหลังตู้ไหลวนย้อนกลับมาเข้าหน้าเครื่องเซิร์ฟเวอร์ตัวข้างๆ (Hot Air Recirculation)

---

## 5. ระบบดับเพลิงใน Data Center (Clean Agent Fire Suppression)

ในห้องเซิร์ฟเวอร์ **ห้ามใช้น้ำเปล่าหรือถังดับเพลิงชนิดผงเคมีแห้ง** ฉีดใส่ตู้เซิร์ฟเวอร์ เพราะจะทำให้แผงวงจรอิเล็กทรอนิกส์ทั้งหมดพังเสียหายถาวร

![ระบบตรวจจับควันความไวสูง VESDA และถังสารสะอาดดับเพลิง FM-200 / Novec 1230](/images/datacenter/dc-fire-suppression.png)

1. **ระบบตรวจจับควันความไวสูง (VESDA - Very Early Smoke Detection Apparatus)**:
   - ใช้ท่อดูดอากาศในห้องไปตรวจวัดอนุภาคควันด้วยเลเซอร์ตลอดเวลา สามารถแจ้งเตือนตั้งแต่สายไฟเริ่มร้อนจนมีกลิ่นไหม้จางๆ ก่อนที่จะเกิดเปลวไฟจริง
2. **สารสะอาดดับเพลิง (Clean Agent Gas: FM-200 / Novec 1230 / Inergen)**:
   - เมื่อระบบยืนยันเหตุเพลิงไหม้ (Cross-zone detection) และนับถอยหลัง 30–60 วินาทีให้คนออกจากห้อง ระบบจะฉีดแก๊สสารสะอาด เช่น **FM-200 (HFC-227ea)** หรือ **3M Novec 1230** ออกมาดูดซับความร้อนและตัดปฏิกิริยาการเผาไหม้จนไฟดับทันที
   - **จุดเด่น**: ไม่นำไฟฟ้า ไม่ทิ้งคราบสกปรก และเซิร์ฟเวอร์ยังสามารถทำงานต่อไปได้โดยไม่เสียหาย
   - บริเวณประตูทางออกจะมีปุ่มสีเหลือง **Emergency Abort / Hold Button** สำหรับกดหน่วงเวลาปล่อยแก๊สหากเจ้าหน้าที่ตรวจสอบแล้วพบว่าเป็นสัญญาณเตือนผิดพลาด (False Alarm)
', 9, 'intermediate', 4, true, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.lessons VALUES ('d8929572-6865-40b4-bf65-a32bfcdb15a5', 2, 'network-ip-subnetting', 'ทำความเข้าใจ IP, Subnet Mask และ CIDR สำหรับงาน Support', 'เจาะลึกโครงสร้าง IPv4, การแบ่ง Private vs Public IP, คำนวณ CIDR (/24, /28, /30) และการตั้งค่า Network Interface', '
# ทำความเข้าใจ IP, Subnet Mask และ CIDR สำหรับงาน Support

ในฐานะ Application Support หรือ NOC (Network Operations Center) หน้าที่หลักคือการตรวจสอบว่าเครื่องแม่ข่ายหรืออุปกรณ์ปลายทางเชื่อมต่อเครือข่ายถูกต้องหรือไม่ หากตั้งค่า IP หรือ Subnet ผิดพลาด เซิร์ฟเวอร์จะไม่สามารถติดต่อ Gateway หรือออกอินเทอร์เน็ตได้เลย

---

## 1. โครงสร้าง IPv4 และ Subnet Mask

IPv4 ประกอบด้วยตัวเลข 32 บิต แบ่งออกเป็น 4 ชุด (Octet) คั่นด้วยจุด แต่ละชุดมีค่าตั้งแต่ 0 ถึง 255 (เช่น `192.168.1.50`)

### หน้าที่ของ Subnet Mask
Subnet Mask มีหน้าที่บอกว่าส่วนไหนของ IP คือ **Network ID** (เครือข่ายไหน) และส่วนไหนคือ **Host ID** (เครื่องไหนในเครือข่าย):
- ถ้าเครื่องสองเครื่องอยู่ใน Network ID เดียวกัน สามารถสื่อสารกันได้โดยตรงผ่าน Layer 2 (Switch)
- ถ้าอยู่คนละ Network ID ต้องส่ง Packet ผ่าน **Default Gateway (Router)** เสมอ

---

## 2. Private IP Address vs Public IP Address

ตามมาตรฐาน RFC 1918 ช่วง IP ต่อไปนี้ถูกสงวนไว้ใช้งานภายในองค์กร (ห้ามวิ่งบน Public Internet):

| Class | ช่วง Private IP | Subnet เริ่มต้น | การใช้งานทั่วไป |
|---|---|---|---|
| **Class A** | `10.0.0.0` - `10.255.255.255` | `/8` (255.0.0.0) | องค์กรขนาดใหญ่, Cloud VPC, Datacenter |
| **Class B** | `172.16.0.0` - `172.31.255.255` | `/12` (255.240.0.0) | องค์กรขนาดกลาง, Docker Bridge Network (`172.17.x.x`) |
| **Class C** | `192.168.0.0` - `192.168.255.255` | `/16` (255.255.0.0) | Home Router, ออฟฟิศสาขา, Lab |

> ⚠️ **ข้อควรระวัง (Warning)**:
> หากเซิร์ฟเวอร์แจ้งว่าได้รับ IP ขึ้นต้นด้วย `169.254.x.x` (APIPA - Automatic Private IP Addressing) แสดงว่าเครื่องไม่ได้รับ IP จาก DHCP Server หรือเชื่อมต่อสาย LAN มีปัญหา

---

## 3. การคำนวณ CIDR ที่พบบ่อยในงาน Support

ตัวเลข `/XX` หลัง IP คือจำนวนบิตที่ใช้เป็น Network ID โดยสูตรคำนวณจำนวน Host คือ $2^{(32 - \text{Prefix})} - 2$ (ต้องหัก Network IP และ Broadcast IP ออก 2 ค่าเสมอ):

| CIDR | Subnet Mask | จำนวน IP ทั้งหมด | Usable Hosts | การใช้งานจริง |
|---|---|---|---|---|
| **/24** | `255.255.255.0` | 256 | **254** | วง LAN ออฟฟิศ, Subnet ทั่วไป |
| **/28** | `255.255.255.240` | 16 | **14** | Subnet ย่อยใน Cloud / DMZ ขนาดเล็ก |
| **/29** | `255.255.255.248` | 8 | **6** | IP Public Block สำหรับ Load Balancer / Firewall |
| **/30** | `255.255.255.252` | 4 | **2** | Point-to-Point Link ระหว่าง Router 2 ตัว |
| **/32** | `255.255.255.255` | 1 | **1** | Host IP เดี่ยว (ใช้ใน Firewall Rule หรือ Loopback) |

---

## 4. คำสั่งตรวจสอบ IP บน Linux

### 1) ตรวจสอบ IP และ Interface ด้วย `ip addr`
```bash
# แสดง IP และ Interface ทั้งหมด
ip addr show

# แสดงเฉพาะ Interface ที่สนใจ (เช่น eth0)
ip addr show eth0
```

### 2) ตรวจสอบ Default Gateway ด้วย `ip route`
```bash
ip route show
# ผลลัพธ์: default via 192.168.1.1 dev eth0 proto dhcp metric 100
```
- ถ้าไม่มีบรรทัด `default via ...` เครื่องจะไม่สามารถออกไปยังภายนอกหรืออินเทอร์เน็ตได้

---

## 5. Checklist ลำดับการตรวจสอบ Network ขั้นพื้นฐาน
1. **Interface UP หรือไม่**: ดูสถานะใน `ip link show` (ต้องเป็น `state UP`)
2. **มี IP Address ถูกต้องหรือไม่**: ดูว่าได้ IP วงที่ถูกต้อง ไม่ใช่ `169.254.x.x`
3. **มี Default Gateway หรือไม่**: ตรวจสอบด้วย `ip route show`
4. **Ping Gateway เจอหรือไม่**: `ping -c 3 <Gateway_IP>`
', 8, 'beginner', 1, true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.lessons VALUES ('04cb05e0-09ef-4ee4-8cf5-1ed7d502bbfe', 2, 'network-dns-resolution', 'การทำงานของระบบ DNS และเทคนิคการสืบค้น (dig, nslookup)', 'ลำดับการ Resolve โดเมน, ไฟล์ /etc/hosts vs /etc/resolv.conf, ประเภท Record ยอดนิยม และการใช้ dig เจาะหาปัญหา', '
# การทำงานของระบบ DNS และเทคนิคการสืบค้น (dig, nslookup)

คำกล่าวคลาสสิกของชาว Sysadmin และ Support คือ **"It''s always DNS"** เพราะเกือบทุก Application ต้องเชื่อมต่อ API หรือ Database ผ่าน Domain Name หาก DNS ล่มหรือ Resolve ไม่ตรง IP ระบบจะหยุดชะงักทันที

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
', 8, 'beginner', 2, true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.lessons VALUES ('240e3caf-58b9-4b37-9d41-8d7a2830fe79', 2, 'network-routing-latency', 'วิเคราะห์เส้นทางและ Latency ด้วย ping, traceroute และ mtr', 'เข้าใจโปรโตคอล ICMP, การอ่านผล Packet Loss, วิธีแกะรอยปัญหาเครือข่ายด้วย traceroute และการใช้ mtr แบบมืออาชีพ', '
# วิเคราะห์เส้นทางและ Latency ด้วย ping, traceroute และ mtr

เมื่อผู้ใช้งานรายงานว่า **"ระบบช้ามาก"** หรือ **"เชื่อมต่อหลุดๆ ติดๆ"** ปัญหามักเกิดจาก Latency สูงหรือ Packet Loss ในเส้นทางเครือข่าย เครื่องมือพื้นฐานอย่าง `ping`, `traceroute` และ `mtr` จึงเป็นอาวุธสำคัญของทีม Support

---

## 1. การทดสอบการเชื่อมต่อด้วย `ping` (ICMP)

`ping` ใช้โปรโตคอล **ICMP (Internet Control Message Protocol)** ส่ง Echo Request และรอรับ Echo Reply

```bash
# ส่ง ping 4 ครั้งแล้วสรุปผล
ping -c 4 8.8.8.8

# ผลลัพธ์:
# 4 packets transmitted, 4 received, 0% packet loss, time 3004ms
# rtt min/avg/max/mdev = 12.112/14.540/17.821/2.115 ms
```

### สิ่งที่ต้องวิเคราะห์จากผล `ping`:
1. **Packet Loss (%)**:
   - `0% loss`: คุณภาพการส่งข้อมูลสมบูรณ์
   - `> 0% loss`: ข้อมูลสูญหายระหว่างทาง อาจเกิดจากสายสัญญาณมีปัญหา, อุปกรณ์เน็ตเวิร์ก Overload, หรือคลื่นรบกวน
2. **Round-Trip Time (rtt avg)**:
   - ต่ำกว่า 5 ms: เครือข่าย LAN ภายใน Datacenter เดียวกัน
   - 20-40 ms: เครือข่าย Fiber ในประเทศ
   - 150-300 ms: เครือข่ายข้ามทวีป (เช่น กรุงเทพฯ ไป อเมริกา)
3. **Jitter (`mdev`)**:
   - ความแปรปรวนของเวลาในการเดินทาง หากค่านี้สูง แสดงว่าเน็ตไม่นิ่ง

> ⚠️ **ข้อควรระวัง (Warning)**:
> การที่ `ping` ไม่ตอบกลับ (Request Timed Out) ไม่ได้แปลว่าเซิร์ฟเวอร์ปลายทางล่มเสมอไป เพราะระบบ Firewall หรือ Cloud หลายแห่งตั้งค่าปิดการตอบสนองต่อโปรโตคอล ICMP เพื่อความปลอดภัย

---

## 2. แกะรอยเส้นทางด้วย `traceroute`

`traceroute` ทำงานโดยการส่ง Packet ที่มีค่า **TTL (Time-To-Live)** เริ่มต้นจาก 1, 2, 3... เพื่อให้เราเตอร์แต่ละชุมสายส่ง ICMP Time Exceeded กลับมา ทำให้เราเห็นรายชื่อ Hop ทั้งหมดตลอดเส้นทาง

```bash
# ตรวจสอบเส้นทางไปยังเซิร์ฟเวอร์ปลายทาง
traceroute -n api.example.com
```
- `-n`: แสดงเฉพาะ IP Address โดยไม่ต้องเสียเวลา Resolve DNS ย้อนกลับ ช่วยให้แสดงผลเร็วขึ้นมาก

### การอ่านผล `* * *` ใน traceroute:
- หากพบ `* * *` เฉพาะ Hop กลางทาง แต่ Hop ท้ายสุดตอบกลับปกติ: เราเตอร์กลางทางบล็อก ICMP หรือมี Rate-limit ซึ่งถือเป็น **พฤติกรรมปกติ**
- หากพบ `* * *` ต่อเนื่องไปจนถึงบรรทัดสุดท้าย: เส้นทางขาดตอนที่จุดก่อนหน้านั้น หรือ Firewall ปลายทางบล็อก

---

## 3. มหาเทพแห่งการวิเคราะห์: `mtr` (My Traceroute)

`mtr` รวมจุดเด่นของ `ping` และ `traceroute` เข้าด้วยกัน โดยจะส่ง Ping ไปยังทุก Hop อย่างต่อเนื่องแบบ Real-time:

```bash
# รัน mtr แบบ Interactive
mtr -n 8.8.8.8

# ส่ง 10 รอบแล้วสรุปเป็น Report ส่งให้ทีม Network
mtr -n -c 10 --report 8.8.8.8
```

### ข้อดีของ `mtr --report`:
- แสดง Packet Loss (%) และสถิติ Avg/Best/Worst ของแต่ละ Hop ชัดเจน
- หากเกิด Packet Loss เริ่มต้นที่ Hop 4 และส่งผลให้ Hop 5, 6, 7 มี Loss ตามมาด้วย แสดงว่าปัญหาอยู่ที่ Hop 4 แน่นอน
- หาก Loss เกิดขึ้นเฉพาะ Hop 4 แต่ Hop 5 และปลายทางเป็น 0% Loss แสดงว่า Hop 4 แค่จำกัด ICMP ของตัวมันเอง แต่ส่งผ่านข้อมูลตามปกติ
', 8, 'beginner', 3, true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.lessons VALUES ('3ff8610b-94c3-43a7-8e1f-436f27946647', 2, 'network-tcp-ports-firewall', 'TCP Handshake, สถานะพอร์ต และความต่าง Connection Refused vs Timed Out', 'เข้าใจกลไก TCP 3-Way Handshake, สถานะพอร์ต, ถอดรหัสข้อผิดพลาด Connection Refused vs Timed Out และวิธีใช้ ss, nc, ufw', '
# TCP Handshake, สถานะพอร์ต และความต่าง Connection Refused vs Timed Out

นี่คือหนึ่งในหัวข้อสัมภาษณ์ยอดฮิตที่สุดของสาย Application Support และ DevOps: เมื่อผู้ใช้แจ้งว่า **"ต่อ Database ไม่ได้"** หรือ **"เรียก API ไม่ติด"** ข้อความ Error ที่แสดงบอกสาเหตุของปัญหาได้อย่างแม่นยำหากเราเข้าใจกลไกของ TCP

---

## 1. กลไก TCP 3-Way Handshake

ก่อนที่ Client และ Server จะรับส่งข้อมูลกันได้ จะต้องสร้าง Connection ผ่าน 3 ขั้นตอน:

```
Client                             Server (Port ในสถานะ LISTEN)
  |                                  |
  | -------- SYN (ขอนัดหมาย) ------> |  Client ส่ง SYN
  |                                  |
  | <--- SYN-ACK (รับทราบและตกลง) -- |  Server ตอบรับ SYN-ACK
  |                                  |
  | -------- ACK (ยืนยันพร้อมเริ่ม) -> |  Client ส่ง ACK
  |                                  |
[ESTABLISHED]                      [ESTABLISHED]
```

- **FIN / ACK**: การปิดการเชื่อมต่อแบบปกติอย่างสุภาพ (Graceful Shutdown)
- **RST (Reset)**: การตัดการเชื่อมต่อแบบกะทันหัน หรือปฏิเสธไม่รับคุย

---

## 2. สถานะ TCP ที่พบบ่อยใน `ss -tan`

| สถานะ | ความหมาย | จุดสังเกตในงาน Support |
|---|---|---|
| **LISTEN** | เซิร์ฟเวอร์กำลังเปิดพอร์ตรอรับการเชื่อมต่อ | ถ้าไม่มีสถานะนี้ แสดงว่า Service ดับ |
| **ESTABLISHED** | การเชื่อมต่อสำเร็จและกำลังรับส่งข้อมูล | ปกติ |
| **TIME_WAIT** | ฝั่ง Client/Server ปิดการเชื่อมต่อแล้ว และรอเคลียร์แพ็กเก็ตตกค้าง | ถ้าค้างหลายหมื่นอาจทำให้ Ephemeral Port เต็ม |
| **CLOSE_WAIT** | เซิร์ฟเวอร์ได้รับ FIN จาก Client แล้ว แต่แอปพลิเคชันยังไม่ยอมสั่งปิด Socket | ปัญหา Application Leak (แอปเขียนโค้ดไม่ปิด Connection) |

---

## 3. มหากาพย์: Connection Refused vs Connection Timed Out

| ข้อความ Error | กลไกเครือข่ายที่เกิดขึ้น | สาเหตุที่พบบ่อยที่สุด |
|---|---|---|
| **Connection Refused** | Packet เดินทางไปถึงเครื่องปลายทางได้ แต่ Kernel ของปลายทางตอบกลับด้วย **TCP RST** ทันที | 1. **Service ปลายทางดับ** (ไม่มีใครเปิด Port รออยู่)<br>2. Service เปิดอยู่แต่ผูก (Bind) ผิด IP เช่น ผูก `127.0.0.1` ทำให้เครื่องภายนอกเข้าไม่ได้<br>3. Firewall ปลายทางตั้งกฎเป็น **REJECT** |
| **Connection Timed Out** | Client ส่ง SYN ออกไปแล้ว แต่ไม่มีการตอบสนองใดๆ กลับมาเลยจนหมดเวลา (Timeout) | 1. **Network Firewall / Cloud Security Group บล็อก** (ตั้งกฎเป็น **DROP** ทิ้งเงียบๆ)<br>2. IP ปลายทางไม่มีอยู่จริง หรือเครื่องดับสนิท<br>3. Routing ผิดพลาดทำให้ Packet หายไประหว่างทาง |

> ⚠️ **สรุปหัวใจสำคัญ (Crucial Rule)**:
> - ถ้าเจอ **Refused** = ปัญหาอยู่ที่ **OS / Service ในเครื่องปลายทาง** (พอร์ตไม่เปิด, Service ล่ม)
> - ถ้าเจอ **Timed Out** = ปัญหาอยู่ที่ **ทางเดินเครือข่าย หรือ Firewall / Security Group**

---

## 4. คำสั่งตรวจสอบและวินิจฉัยพอร์ต

### 1) ตรวจสอบพอร์ตที่กำลัง LISTEN ในเครื่องตนเองด้วย `ss`
```bash
# -t (TCP), -u (UDP), -l (Listening), -p (Process), -n (Numeric)
sudo ss -tulpn

# กรองเฉพาะพอร์ต 5432 (Postgres) หรือ 80 (HTTP)
sudo ss -tulpn | grep -E '':(5432|80)\b''
```
- หากเห็น Local Address เป็น `127.0.0.1:5432` แสดงว่ารองรับเฉพาะ Localhost
- หากเห็น `0.0.0.0:5432` หรือ `*:5432` แสดงว่ารองรับทุก Interface พร้อมให้ภายนอกเชื่อมต่อ

### 2) ตรวจสอบว่าพอร์ตปลายทางเปิดอยู่หรือไม่ด้วย `nc` (Netcat)
```bash
# ทดสอบเชื่อมต่อ TCP ไปยัง db-server พอร์ต 5432 (Timeout 3 วินาที)
nc -zvw 3 db-server 5432

# ผลลัพธ์เมื่อสำเร็จ: Connection to db-server 5432 port [tcp/*] succeeded!
# ผลลัพธ์เมื่อ Refused: connect to db-server port 5432 (tcp) failed: Connection refused
```

### 3) ตรวจสอบ Firewall ภายในเครื่องด้วย `ufw`
```bash
# ตรวจสถานะ Firewall บน Ubuntu
sudo ufw status verbose

# อนุญาตพอร์ต 80 จากทุกที่
sudo ufw allow 80/tcp

# อนุญาตพอร์ต 5432 เฉพาะจาก IP 10.0.1.50
sudo ufw allow from 10.0.1.50 to any port 5432 proto tcp
```
', 9, 'intermediate', 4, true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.lessons VALUES ('5a3d9602-fb56-4f50-b4fa-c231d799a302', 3, 'sql-queries-joins', 'Master รูปแบบ SQL JOIN และการประยุกต์ใช้งานจริงในงาน Support', 'เข้าใจ INNER JOIN, LEFT JOIN, FULL OUTER JOIN, เทคนิคค้นหาข้อมูลที่ไม่มีคู่ (Anti-join) และการรับมือกับค่า NULL อย่างปลอดภัย', '
# Master รูปแบบ SQL JOIN และการประยุกต์ใช้งานจริงในงาน Support

ในฐานะ Application Support หน้าที่ประจำวันคือการเปิดฐานข้อมูลขึ้นมาสืบค้นว่า **"ทำไมออเดอร์ของลูกค้าหมายเลขนี้ไม่ตัดยอด"** หรือ **"ทำไมข้อมูลผู้ใช้แสดงไม่ครบ"** การดึงข้อมูลที่มีความเกี่ยวข้องกันข้ามตารางจำเป็นต้องใช้ **JOIN** อย่างชำนาญ

---

## 1. ความแตกต่างของประเภท SQL JOIN

```
      INNER JOIN                    LEFT JOIN                 FULL OUTER JOIN
   ┌───────┬───────┐             ┌───────┬───────┐             ┌───────┬───────┐
   │       │█████  │             │███████│█████  │             │███████│███████│
   │   A   │█████ B│             │██ A ██│█████ B│             │██ A ██│██ B ██│
   │       │█████  │             │███████│█████  │             │███████│███████│
   └───────┴───────┘             └───────┴───────┘             └───────┴───────┘
  ตรงกันทั้งสองฝั่ง             เอาฝั่งซ้ายทั้งหมด             เอาข้อมูลทั้งหมด
                            (ถ้าขวาไม่มีจะเป็น NULL)       (ตรงไหนไม่มีคู่เป็น NULL)
```

| ชนิดของ JOIN | พฤติกรรมการดึงข้อมูล | ตัวอย่างการใช้งานในงาน Support |
|---|---|---|
| **INNER JOIN** | คืนเฉพาะแถวที่เงื่อนไขตรงกันทั้ง 2 ฝั่งเท่านั้น | ดูรายการสั่งซื้อเฉพาะที่จ่ายเงินสำเร็จแล้ว |
| **LEFT JOIN** | เอาแถวจากตารางซ้ายทั้งหมด หากตารางขวาไม่มีคู่ ข้อมูลฝั่งขวาจะเป็น `NULL` | ดูรายชื่อผู้ใช้ทั้งหมด พร้อมประวัติการสั่งซื้อ (ผู้ใช้ที่ยังไม่เคยสั่งก็จะยังแสดง) |
| **RIGHT JOIN** | เอาแถวจากตารางขวาทั้งหมด (ในทางปฏิบัติมักสลับตำแหน่งตารางแล้วใช้ LEFT JOIN แทนเพื่อความอ่านง่าย) | - |
| **FULL OUTER JOIN** | เอาข้อมูลของทั้ง 2 ตาราง หากฝั่งใดไม่มีคู่จะเติมด้วย `NULL` | การกระทบยอดบัญชี (Reconciliation) เพื่อหาข้อมูลที่ตกหล่นของทั้ง 2 ระบบ |

---

## 2. ท่าไม้ตาย Anti-Join: ค้นหาข้อมูลที่ตกหล่น (Missing Links)

หนึ่งในเคส Support ที่พบบ่อยที่สุดคือการหาว่า **"มีรายการใดที่ไม่มีข้อมูลผูกโยง"** เช่น หาบัญชีผู้ใช้ที่ยังไม่มีโปรไฟล์ หรือหาคำถามที่ยังไม่มีใครตอบ:

```sql
-- ค้นหาผู้ใช้ที่ยังไม่เคยมีประวัติการสั่งซื้อเลยแม้แต่ออเดอร์เดียว
SELECT 
    u.id AS user_id,
    u.email,
    u.created_at
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE o.id IS NULL;
```
- เทคนิคนี้ใช้ `LEFT JOIN` เพื่อดึงข้อมูลทั้งหมด แล้วกรองด้วย `WHERE o.id IS NULL` เพื่อเลือกเฉพาะแถวที่ไม่มีข้อมูลฝั่งขวา

---

## 3. การจัดการกับค่า `NULL` ด้วย `COALESCE`

ค่า `NULL` ใน SQL ไม่ใช่เลข 0 และไม่ใช่สตริงว่าง แต่คือ **"การไม่มีข้อมูล (Unknown)"** การนำ NULL ไปเปรียบเทียบด้วยเครื่องหมาย `=` เช่น `WHERE phone = NULL` จะได้ผลลัพธ์เป็น False เสมอ ต้องใช้ `IS NULL` หรือ `IS NOT NULL` เท่านั้น

```sql
-- แสดงชื่อผู้ใช้ หากไม่มีนามสกุลให้แทนที่ด้วยสตริงว่าง หรือคำว่า ''N/A''
SELECT 
    id,
    first_name,
    COALESCE(last_name, '''') AS last_name,
    COALESCE(phone, ''N/A'') AS contact_phone
FROM customers;
```
- ฟังก์ชัน `COALESCE(val1, val2, ...)` จะคืนค่าแรกที่ไม่ใช่ NULL

---

## 4. กฎเหล็กความปลอดภัยในการ Query บนฐานข้อมูล Production

> ⚠️ **คำเตือนความปลอดภัย (Warning)**:
> 1. **ห้ามรัน `SELECT *` บนตารางที่มีข้อมูลหลายล้านแถวโดยไม่มี `LIMIT` เด็ดขาด** เพราะจะทำให้ Network I/O และ RAM ของ Database พุ่งสูงจนระบบค้าง
> 2. **รันคำสั่งบน Read Replica เสมอ** หลีกเลี่ยงการยิงคำสั่งวิเคราะห์ข้อมูลหรือดึงรีพอร์ตบน Master Database เพื่อป้องกันไม่ให้ Transaction การเขียนของลูกค้าระบบหลักติด Lock
> 3. **ระวังการ JOIN หลายตารางโดยไม่มี WHERE Condition** อาจเกิดผลคูณแบบ Cartesian Product (Cross Join) จน Database หน่วยความจำล้น
', 8, 'beginner', 1, true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.lessons VALUES ('10413c74-c724-4168-99e9-fc7c279fb980', 3, 'sql-aggregations-grouping', 'วิเคราะห์สถิติและเหตุการณ์ผิดปกติด้วย GROUP BY และ HAVING', 'เข้าใจฟังก์ชัน Aggregate, ความต่างระหว่าง WHERE vs HAVING, การจัดกลุ่มเวลาด้วย DATE_TRUNC และสูตร Query วิเคราะห์ Log', '
# วิเคราะห์สถิติและเหตุการณ์ผิดปกติด้วย GROUP BY และ HAVING

เมื่อเกิด Incident คำถามที่ผู้บริหารหรือทีมผู้พัฒนามักถามทีม Support คือ:
- **"มี Error นี้เกิดขึ้นกี่ครั้งในรอบชั่วโมงที่ผ่านมา?"**
- **"ผู้ใช้คนไหนที่มี Request ผิดปกติเกิน 500 ครั้ง?"**
- **"API Endpoint เส้นไหนตอบช้าหรือพังบ่อยที่สุด?"**

การตอบคำถามเหล่านี้ต้องใช้การรวมกลุ่มและคำนวณข้อมูลด้วย **Aggregate Functions**, **GROUP BY** และ **HAVING**

---

## 1. Aggregate Functions และความต่างของ `COUNT(*)` vs `COUNT(col)`

ฟังก์ชันรวบรวมข้อมูลยอดนิยม:
- `COUNT(*)`: นับจำนวนแถวทั้งหมด (รวมทั้งแถวที่มีค่า NULL)
- `COUNT(column)`: นับเฉพาะแถวที่คอลัมน์นั้น **ไม่เป็น NULL** เท่านั้น
- `SUM(column)`: หาผลรวมตัวเลข
- `AVG(column)`: คำนวณค่าเฉลี่ย
- `MIN(column)` / `MAX(column)`: หาค่าน้อยสุดและมากสุด

```sql
-- นับจำนวน Ticket ทั้งหมด และจำนวน Ticket ที่มีคนกดรับเคสแล้ว (assigned_to ไม่เป็น NULL)
SELECT 
    COUNT(*) AS total_tickets,
    COUNT(assigned_to) AS assigned_tickets
FROM tickets;
```

---

## 2. ลำดับการประมวลผล: `WHERE` vs `HAVING`

ความเข้าใจผิดอันดับหนึ่งของมือใหม่คือการสับสนระหว่าง `WHERE` และ `HAVING`:

| คำสั่ง | ช่วงเวลาทำงาน | เงื่อนไขที่ใช้ได้ |
|---|---|---|
| **WHERE** | กรองแถวก่อนนำไปจัดกลุ่ม (Filter Row-level) | ใช้กับคอลัมน์ทั่วไป ห้ามใช้ฟังก์ชัน Aggregate เช่น `WHERE COUNT(*) > 5` (จะ Syntax Error ทันที) |
| **HAVING** | กรองผลลัพธ์หลังจากรวมกลุ่มแล้ว (Filter Group-level) | ใช้กับ Aggregate Functions เช่น `HAVING COUNT(*) > 100` หรือ `HAVING AVG(duration) > 2000` |

### ลำดับการทำงานของ SQL Engine (Execution Order):
1. `FROM` & `JOIN` (เลือกตาราง)
2. `WHERE` (กรองแถวแรกเริ่ม)
3. `GROUP BY` (จัดกลุ่ม)
4. `HAVING` (กรองผลลัพธ์ของกลุ่ม)
5. `SELECT` (เลือกคอลัมน์ที่จะแสดง)
6. `ORDER BY` (จัดเรียง)
7. `LIMIT` (จำกัดจำนวนแถว)

---

## 3. ตัวอย่างคำสั่งจริงในงาน Application Support

### 1) ค้นหา Error Code ที่เกิดขึ้นบ่อยที่สุดในรอบวันนี้
```sql
SELECT 
    status_code,
    error_message,
    COUNT(*) AS incident_count
FROM application_logs
WHERE created_at >= CURRENT_DATE
GROUP BY status_code, error_message
ORDER BY incident_count DESC
LIMIT 10;
```

### 2) ตรวจสอบพฤติกรรมผิดปกติ: ค้นหา IP ที่ยิง Login Failed เกิน 5 ครั้งในรอบ 15 นาที
```sql
SELECT 
    ip_address,
    COUNT(*) AS failed_attempts
FROM auth_logs
WHERE action = ''LOGIN_FAILED''
  AND created_at >= NOW() - INTERVAL ''15 minutes''
GROUP BY ip_address
HAVING COUNT(*) >= 5
ORDER BY failed_attempts DESC;
```

### 3) การสรุปยอดตามช่วงเวลาด้วย `DATE_TRUNC` ใน PostgreSQL
```sql
-- นับสถิติคำสั่งซื้อแยกตามชั่วโมง
SELECT 
    DATE_TRUNC(''hour'', created_at) AS log_hour,
    COUNT(*) AS order_count
FROM orders
WHERE created_at >= NOW() - INTERVAL ''24 hours''
GROUP BY DATE_TRUNC(''hour'', created_at)
ORDER BY log_hour ASC;
```
', 8, 'intermediate', 2, true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.lessons VALUES ('0ec2fdf6-2627-408b-9791-35963b5fe97e', 3, 'sql-indexes-performance', 'การจูน Index, อ่าน EXPLAIN ANALYZE และจัดการ Slow Query', 'ทำความเข้าใจ B-Tree Index, Sequential Scan vs Index Scan, ถอดรหัส EXPLAIN ANALYZE และคำสั่งปลดล็อกคิวรีที่ค้างด้วย pg_stat_activity', '
# การจูน Index, อ่าน EXPLAIN ANALYZE และจัดการ Slow Query

ปัญหาอันดับ 1 ของระบบฐานข้อมูลในระดับ Production ที่ทำให้เว็บค้างหรือ Database CPU พุ่ง 100% คือ **Slow Query** และ **Lock Contention** การเข้าใจว่า Query Engine ทำงานอย่างไร และรู้จักเครื่องมือตรวจสอบแบบ Real-time จะช่วยกู้วิกฤตระบบล่มได้อย่างรวดเร็ว

---

## 1. Index ทำงานอย่างไร และทำไมถึงสำคัญ?

หากไม่มี Index เมื่อสั่งค้นหาข้อมูล เช่น:
```sql
SELECT * FROM orders WHERE customer_id = 5020;
```
ฐานข้อมูลจะต้องกวาดอ่านข้อมูลทีละบล็อกจากดิสก์ตั้งแต่แถวแรกจนถึงแถวสุดท้าย เรียกว่า **Sequential Scan (Full Table Scan)** ซึ่งถ้าตารางมี 10 ล้านแถว อาจใช้เวลาหลายสิบวินาที

เมื่อสร้าง **B-Tree Index** ระบบจะจัดเก็บโครงสร้างต้นไม้ที่มีการเรียงลำดับ ทำให้ค้นหาแบบ Binary Search ได้ด้วยความเร็วระดับ $O(\log N)$ (ใช้เวลาเพียง 1-2 มิลลิวินาที)

```sql
-- สร้าง Index พื้นฐาน
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- สร้าง Composite Index สำหรับ Query ที่ค้นหา 2 คอลัมน์ร่วมกันบ่อยๆ
CREATE INDEX idx_orders_cust_status ON orders(customer_id, status);
```

> ⚠️ **ข้อควรระวังของ Composite Index**:
> Composite Index `(customer_id, status)` จะทำงานได้ก็ต่อเมื่อ Query มีเงื่อนไขของคอลัมน์แรก (`customer_id`) เสมอ (เรียกว่า Leftmost Prefix Rule) หาก Query ด้วย `WHERE status = ''PAID''` ตัวเดียว Engine จะไม่สามารถใช้ Index ตัวนี้ได้

---

## 2. การอ่านผล `EXPLAIN ANALYZE`

คำสั่ง `EXPLAIN` บอกแผนการทำงาน (Query Plan) ส่วน `EXPLAIN ANALYZE` จะสั่งรันคำสั่งนั้นจริงและจับเวลาอย่างละเอียด:

```sql
EXPLAIN ANALYZE
SELECT * FROM orders WHERE customer_id = 5020;
```

### รูปแบบการ Scan ที่ต้องสังเกต:
1. **Seq Scan on orders**: กวาดอ่านทั้งตารางโดยไม่ใช้ Index หากตารางมีขนาดใหญ่ นี่คือสัญญาณอันตราย
2. **Index Scan using idx_orders_customer_id**: ใช้ Index ค้นหาตำแหน่ง จากนั้นเข้าไปอ่านข้อมูลจริงในตาราง
3. **Index Only Scan**: ดีที่สุด เพราะข้อมูลทุกคอลัมน์ที่ต้องการมีอยู่ใน Index แล้ว ไม่ต้องแตะตารางจริงเลย
4. **Bitmap Heap Scan**: นำผลลัพธ์จาก Index หลายตัวมาทำ AND/OR กันก่อนอ่านตารางจริง

---

## 3. จัดการคิวรีที่ค้างและดึงเครื่องพังด้วย `pg_stat_activity`

เมื่อ Database Server มี CPU สูง 100% หรือ Disk I/O ตัน ให้เปิดดูว่า Process ใดกำลังทำงานอยู่ด้วย System View:

```sql
-- 1. ตรวจสอบ Query ที่กำลังรันอยู่ และรันค้างเกิน 5 วินาที
SELECT 
    pid,
    now() - query_start AS duration,
    usename,
    state,
    query
FROM pg_stat_activity
WHERE state != ''idle''
  AND now() - query_start > INTERVAL ''5 seconds''
ORDER BY duration DESC;
```

### คำสั่งยกเลิก Query อันตราย:
```sql
-- ยกเลิกเฉพาะ Query นั้นอย่างสุภาพ (Graceful cancel)
SELECT pg_cancel_backend(<pid>);

-- หาก Query ยังไม่ยอมหยุด ให้บังคับตัดการเชื่อมต่อของเซสชันนั้นทิ้งทันที (Kill connection)
SELECT pg_terminate_backend(<pid>);
```

---

## 4. ปัญหา Connection Pool เต็ม (Max Connections Reached)
หากผู้ใช้งานพบ Error: `FATAL: remaining connection slots are reserved for non-replication superuser connections`
- สาเหตุ: แอปพลิเคชันเปิด Database Connection ทิ้งไว้โดยไม่ปิด (Connection Leak) หรือตั้งค่า Pool ใน Web Server สูงเกินกว่าที่ PostgreSQL รับไหว
- แนวทางแก้ไขเบื้องต้น: ตรวจสอบ `SELECT count(*) FROM pg_stat_activity;` เทียบกับค่า `SHOW max_connections;` และพิจารณาใช้ Connection Pooler เช่น **PgBouncer**
', 9, 'intermediate', 3, true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.lessons VALUES ('11fc305a-c347-452a-8cbb-f81491cb8cae', 6, 'troubleshooting-incident-triage-methodology', 'ลำดับการ Triage ปัญหาและระเบียบวิธีวิเคราะห์ Incident เชิงระบบ', 'ระดับความรุนแรง Sev 1 - Sev 4, คำถามทองคำ ''What Changed?'', แนวทางวิเคราะห์ Top-Down vs Bottom-Up และการกู้ระบบคืนก่อนหาสาเหตุ', '
# ลำดับการ Triage ปัญหาและระเบียบวิธีวิเคราะห์ Incident เชิงระบบ

เมื่อเกิดเหตุการณ์ระบบขัดข้อง (Incident) ความตื่นตระหนกคือศัตรูอันดับหนึ่งของทีม Support สิ่งที่แบ่งแยกวิศวกรมืออาชีพออกจากมือใหม่คือ **"กระบวนการคิดและลำดับการ Triage ปัญหาอย่างเป็นระบบ (Systematic Troubleshooting)"**

---

## 1. การประเมินระดับความรุนแรง (Severity Matrix)

ตามมาตรฐาน ITIL การจัดระดับความรุนแรงจะช่วยกำหนดว่าใครต้องเข้ามาร่วมแก้ปัญหาและต้องสื่อสารอย่างไร:

| ระดับ Severity | นิยามและผลกระทบ | SLA การตอบกลับ | ตัวอย่างเหตุการณ์ |
|---|---|---|---|
| **Sev 1 (Critical)** | **ระบบหลักล่มทั้งระบบ** กระทบผู้ใช้ทุกคน เกิดความเสียหายทางการเงินทันที | ภายใน 15 นาที | ระบบชำระเงินล่ม, เว็บไซต์หลักไม่สามารถเปิดได้เลย |
| **Sev 2 (High)** | ฟังก์ชันสำคัญใช้งานไม่ได้ ส่งผลกระทบต่อผู้ใช้จำนวนมาก และ **ไม่มีทางเลี่ยง (No Workaround)** | ภายใน 30 นาที | ฟังก์ชันค้นหาสินค้าพัง, ล็อกอินผ่านแอปมือถือไม่ได้ |
| **Sev 3 (Medium)** | ฟังก์ชันย่อยมีปัญหา แต่ยังมีวิธีเลี่ยง (Workaround Available) | ภายใน 2-4 ชั่วโมง | ปุ่มพิมพ์ใบเสร็จ PDF ไม่ทำงานแต่สามารถดูบนเว็บได้ |
| **Sev 4 (Low)** | ปัญหาเล็กน้อย ไม่มีผลต่อการดำเนินธุรกิจ | ภายใน 24 ชั่วโมง | ตัวสะกดผิดบนหน้าเว็บ, สีปุ่มแสดงผลเพี้ยน |

---

## 2. คำถามทองคำ 4 ข้อในการรับแจ้งเหตุ (Triage Assessment)

ก่อนจะเริ่มพิมพ์คำสั่งใดๆ บนเซิร์ฟเวอร์ ให้ถาม 4 คำถามนี้เสมอ:
1. **Who (ใครได้รับผลกระทบ?)**: เป็นผู้ใช้ทุกคน หรือเฉพาะผู้ใช้ที่อยู่สาขาเชียงใหม่ หรือเฉพาะคนที่ใช้เน็ต 3BB?
2. **When (เริ่มเป็นตั้งแต่เมื่อไหร่?)**: เกิดขึ้นทันทีเวลา 10:00 น. หรือค่อยๆ ช้าลงตั้งแต่เมื่อวาน?
3. **Where (พังที่จุดไหน?)**: พังที่หน้าเว็บ, หน้าชำระเงิน, หรือหน้าออกใบกำกับภาษี?
4. **What Changed? (คำถามทองคำ: มีอะไรเปลี่ยนแปลงก่อนหน้านี้หรือไม่?)**: มีการ Deploy โค้ดใหม่, แก้ไข Firewall, อัปเดตแพตช์ OS, หรือเปลี่ยนรหัสผ่าน Database หรือไม่? (90% ของ Incident เกิดจากการเปลี่ยนแปลง!)

---

## 3. ระเบียบวิธีคิด: Top-Down vs Bottom-Up

```
[Top-Down Approach]                 [Bottom-Up Approach]
1. ทดสอบหน้าเว็บ / API              1. ตรวจสอบสาย LAN / Hardware
2. ตรวจสอบ Reverse Proxy (Nginx)   2. ตรวจสอบ IP, Gateway, Ping
3. ตรวจสอบ Backend Application      3. ตรวจสอบ TCP Port, Firewall
4. ตรวจสอบ Database / Storage       4. ตรวจสอบ Service / OS Metrics
5. ตรวจสอบ Network / Hardware       5. ตรวจสอบ Application Layer
```

- **Top-Down**: เหมาะกับ **Application Support** เพราะเริ่มจากอาการที่ผู้ใช้เห็น (เช่น HTTP Status Code) แล้วค่อยไล่ลงไปหาต้นตอ
- **Bottom-Up**: เหมาะกับ **Network & Infrastructure Engineer** เมื่อระบบทั้งออฟฟิศขาดการเชื่อมต่อไปพร้อมกัน

---

## 4. กฎเหล็ก: Restore Service First, Perfect RCA Later!

> ⚠️ **หลักการสำคัญของ Incident Management**:
> เป้าหมายแรกสุดเมื่อเกิด Sev 1 คือ **"ทำให้ระบบกลับมาให้บริการได้เร็วที่สุด (MTTR - Mean Time to Recovery)"** เช่น การ Rollback เวอร์ชันก่อนหน้า, การ Restart เซอร์วิส, หรือเปิดใช้งานโหมด Failover ชั่วคราว
> 
> อย่าเพิ่งเสียเวลาดีบักหาบั๊กในโค้ดแบบละเอียดจนลืมเปิดระบบให้ลูกค้าใช้งาน! การหาสาเหตุที่แท้จริงแบบสมบูรณ์จะทำในขั้นตอน **Problem Management (Post-Incident Review / RCA)** หลังจากระบบกลับมาออนไลน์แล้วเสมอ
', 8, 'beginner', 1, true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.lessons VALUES ('782f94c6-acb3-408b-b091-a093bf7d0c40', 6, 'troubleshooting-root-cause-escalation', 'เทคนิค 5 Whys, การทำ RCA และการส่งต่อเคส (Escalation) อย่างมือโปร', 'เจาะลึกการวิเคราะห์รากเหง้าปัญหาด้วย 5 Whys, โครงสร้างการเขียนบันทึกส่งต่อเคสไปยัง Tier 2/DevOps และการทำ Blameless Post-Mortem', '
# เทคนิค 5 Whys, การทำ RCA และการส่งต่อเคส (Escalation) อย่างมือโปร

เมื่อกู้ระบบกลับมาให้บริการได้แล้ว งานของทีม Support ยังไม่จบ สิ่งสำคัญคือการค้นหาว่า **"อะไรคือต้นเหตุที่แท้จริง และเราจะป้องกันไม่ให้มันเกิดขึ้นซ้ำอีกได้อย่างไร?"** รวมถึงทักษะการส่งต่อเคส (Escalation) ที่มีคุณภาพไปยังทีมพัฒนา

---

## 1. การวิเคราะห์รากเหง้าปัญหาด้วยเทคนิค 5 Whys

**5 Whys** เป็นเทคนิคการถาม "ทำไม" ต่อเนื่องกันเพื่อเจาะทะลุอาการภายนอก (Symptom) ไปถึงต้นตอของระบบ (Root Cause):

### ตัวอย่างเหตุการณ์: เซิร์ฟเวอร์ดับกลางดึก
1. **ทำไมที่ 1: ทำไมหน้าเว็บถึงเข้าไม่ได้?**
   - *คำตอบ*: คอนเทนเนอร์ของ Backend ดับลง (Exit Code 137)
2. **ทำไมที่ 2: ทำไมคอนเทนเนอร์ถึงดับด้วย Exit Code 137?**
   - *คำตอบ*: โดน Linux Kernel OOM Killer สั่งฆ่าเพราะใช้ RAM เกิน 2GB
3. **ทำไมที่ 3: ทำไมจู่ๆ ถึงใช้ RAM เกิน 2GB?**
   - *คำตอบ*: มีฟังก์ชันประมวลผลไฟล์ Excel ขนาด 50MB ค้างอยู่ใน Memory และไม่คืน RAM
4. **ทำไมที่ 4: ทำไมระบบถึงยอมให้ผู้ใช้อัปโหลดไฟล์ขนาดใหญ่ขนาดนั้นได้?**
   - *คำตอบ*: ใน API Endpoint ขาดการตรวจสอบจำกัดขนาดไฟล์ (Missing File Size Validation)
5. **ทำไมที่ 5: ทำไมถึงขาดการตรวจสอบขนาดไฟล์ในโค้ด?**
   - *คำตอบ*: เป็นฟีเจอร์เร่งด่วนที่ไม่มีขั้นตอนทำ Code Review และ Security Checklist ก่อนขึ้น Production

> **ผลลัพธ์ของ RCA**: ไม่ใช่แค่การ Restart คอนเทนเนอร์ (แก้ที่ปลายเหตุ) แต่เป็นการเพิ่มโค้ดตรวจสอบขนาดไฟล์ และกำหนดนโยบายให้ต้องมี Code Review เสมอก่อน Deploy (แก้ที่ต้นเหตุถาวร)

---

## 2. โครงสร้างการส่งต่อเคส (Tier 1 Escalation Checklist)

สิ่งที่ทีม Tier 2, DevOps หรือ Developer เกลียดที่สุดคือ Ticket ที่เขียนมาสั้นๆ ว่า **"ระบบช้า รบกวนดูให้หน่อย"**

### Template การเขียน Escalation Handover ที่มีประสิทธิภาพ:

```markdown
### [Sev 2] ปัญหา: ไม่สามารถสร้างใบเสร็จรับเงินสำหรับคำสั่งซื้อต่างประเทศได้

1. สรุปปัญหา (Issue Summary):
   - ผู้ใช้งานจากสาขาสิงคโปร์กดบันทึกใบเสร็จแล้วขึ้น HTTP 500
   
2. ขอบเขตและผลกระทบ (Scope & Impact):
   - กระทบเฉพาะสาขาต่างประเทศ (สาขาในไทยใช้งานได้ปกติ)
   - เริ่มพบปัญหาตั้งแต่เวลา 14:15 น. (หลังการ Deploy เวอร์ชัน v2.4.1)

3. ข้อมูลทางเทคนิคที่รวบรวมได้ (Technical Evidence):
   - Order ID: ORD-20261104-9842
   - Response: {"code": "ERR_CURRENCY_INVALID", "message": "Currency SGD not mapped"}
   - Application Log snippet:
     [14:15:32] ERROR CurrencyConverter: Unsupported iso code SGD

4. สิ่งที่ Tier 1 ตรวจสอบแล้ว (Troubleshooting Done):
   - ตรวจสอบ Network และ DB Connection: ปกติ (ไม่พบ Slow Query)
   - ตรวจสอบสถานะ Service: Up ปกติ
   - ยืนยันว่าก่อนหน้า 14:00 น. สามารถสร้างออเดอร์ SGD ได้ตามปกติ

5. คำขอหรือขั้นตอนถัดไป (Next Action):
   - ส่งต่อทีม Backend Dev เพื่อตรวจสอบตารางแมปสกุลเงินในเวอร์ชัน v2.4.1
```

---

## 3. วัฒนธรรม Blameless Post-Mortem

- ในองค์กรชั้นนำอย่าง Google, Netflix หรือ AWS เมื่อเกิดระบบล่ม จะไม่มีการหาตัวบุคคลมาลงโทษ
- การชี้ความผิดไปที่บุคคลจะทำให้พนักงานปกปิดความผิดพลาด และกลัวการทดลองสิ่งใหม่
- มุ่งเน้นการปรับปรุง **กระบวนการ (Process)**, **ระบบตรวจสอบ (Automated Testing)** และ **ระบบแจ้งเตือน (Observability)** เพื่อให้ระบบมีความทนทานต่อความผิดพลาดของมนุษย์
', 8, 'intermediate', 2, true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.lessons VALUES ('8cd3f8e6-7571-47ca-bd5b-cd313f6179c6', 4, 'web-http-status-codes', 'ผ่าโครงสร้าง HTTP Status Codes สำหรับวิเคราะห์ปัญหา Web & API', 'สรุปรหัสสถานะ 2xx, 3xx, 4xx, 5xx และเจาะลึกความต่าง 502 Bad Gateway vs 504 Gateway Timeout พร้อมแผนผัง Reverse Proxy', '
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
', 8, 'beginner', 1, true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.lessons VALUES ('cfa14627-c168-4b14-9e7b-15eb4f7e1ead', 4, 'web-curl-api-testing', 'การใช้คำสั่ง curl ทดสอบ REST API และวัด Response Time', 'คู่มือ curl ฉบับเจาะลึก flags สำคัญ (-i, -v, -H, -d, -k), การจำลอง Host Header และการจับเวลา Latency Breakdown ด้วย -w', '
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
| `-d` | ส่งข้อมูล Data Payload (JSON Body) | `-d ''{"name": "John", "role": "admin"}''` |
| `-k` / `--insecure` | **ข้ามการตรวจสอบใบรับรอง SSL/TLS** (ใช้ทดสอบ Self-signed cert) | `curl -k https://internal-dev:8443` |
| `-s` | **Silent Mode**: ซ่อน Progress bar และ Error message | `curl -s https://api.example.com` |

---

## 2. สูตรคำสั่งยิง REST API แบบสมบูรณ์

### 1) การยิง POST Request พร้อม JSON Payload และ Bearer Token
```bash
curl -i -X POST https://api.example.com/v1/orders \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer eyJhbGciOi..." \
  -d ''{
    "customer_id": 105,
    "amount": 2500.00,
    "currency": "THB"
  }''
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
', 8, 'beginner', 2, true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.lessons VALUES ('c1527b50-8bf1-4171-95ce-52bd25ee35f4', 4, 'web-ssl-tls-certificates', 'การตรวจสอบใบรับรอง SSL/TLS และการแก้ปัญหา Certificate หมดอายุ', 'เจาะลึก Chain of Trust, สาเหตุ Error ยอดนิยม (Expired, Self-signed, Domain Mismatch) และคำสั่ง openssl s_client ตรวจสอบใบรับรอง', '
# การตรวจสอบใบรับรอง SSL/TLS และการแก้ปัญหา Certificate หมดอายุ

หนึ่งในฝันร้ายของทีม Support คือตอนเช้าตื่นมาพบว่า **"ผู้ใช้งานทั้งประเทศเข้าเว็บไม่ได้ เบราว์เซอร์ขึ้นเตือน Your connection is not private (NET::ERR_CERT_DATE_INVALID)"** เพราะใบรับรอง SSL/TLS หมดอายุ การตรวจสอบวันหมดอายุและความสมบูรณ์ของใบรับรองจึงเป็นทักษะสำคัญ

---

## 1. ห่วงโซ่ความเชื่อถือ (Chain of Trust)

ใบรับรอง SSL/TLS ไม่ได้ออกโดยลอยๆ แต่มีการรับรองเป็นทอดๆ:

```
[Root CA] (เช่น DigiCert, Let''s Encrypt - ฝังอยู่ใน OS/Browser)
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
issuer=C = US, O = Let''s Encrypt, CN = R3
```
- ตรวจดูบรรทัด `notAfter` เพื่อดูวันหมดอายุ หากวันหมดอายุเหลือน้อยกว่า 14 วัน ต้องรีบแจ้งทีม DevOps ทันที

### 2) ตรวจสอบไฟล์ `.crt` หรือ `.pem` ที่อยู่บนเครื่อง
```bash
openssl x509 -in /etc/ssl/certs/mycert.crt -noout -enddate
```

> ⚠️ **ข้อควรระวัง (Warning)**:
> เมื่อเปลี่ยนไฟล์ SSL Certificate บนเซิร์ฟเวอร์เสร็จแล้ว ต้องสั่ง **Reload Web Server เสมอ** (เช่น `sudo systemctl reload nginx`) มิฉะนั้น Nginx จะยังคงใช้ Certificate เก่าที่อยู่ในหน่วยความจำ
', 8, 'intermediate', 3, true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.lessons VALUES ('6b461aa2-fd34-427d-8b52-fe4455276c56', 2, 'network-osi-layered-troubleshooting', 'โมเดล OSI/TCP-IP และการวิเคราะห์ปัญหาเครือข่ายทีละชั้น (OSI & Layered Troubleshooting)', 'เจาะลึก OSI 7 Layers เทียบ TCP/IP 4 Layers, บทบาทของอุปกรณ์และโปรโตคอลในแต่ละชั้น, และกระบวนการคิดแบบ Bottom-Up จากสายสัญญาณจนถึงหน้าแอปพลิเคชัน', '
# โมเดล OSI/TCP-IP และการวิเคราะห์ปัญหาเครือข่ายทีละชั้น

สำหรับวิศวกรหรือเจ้าหน้าที่ **Network Engineer**, **NOC (Network Operations Center)** และ **Technical Support** กรอบความคิดที่มีค่าที่สุดในการแก้ปัญหาคือ **OSI 7 Layers Model** เพราะเมื่อระบบล่มหรือเครื่องเซิร์ฟเวอร์ต่อเครือข่ายไม่ได้ หากไม่มีกรอบความคิด คุณจะสับสนและทดสอบมั่ว แต่ถ้าใช้หลักการแยกชั้น (Layered Approach) คุณจะตัดสาเหตุที่เป็นไปไม่ได้ออกทีละขั้นและเจอปัญหาได้อย่างรวดเร็ว

---

## 1. การเปรียบเทียบ OSI 7 Layers และ TCP/IP Model

โมเดล OSI (Open Systems Interconnection) ถูกออกแบบเป็นมาตรฐานทฤษฎี 7 ชั้น ขณะที่การทำงานจริงของอินเทอร์เน็ตใช้สถาปัตยกรรม **TCP/IP Model (4 หรือ 5 ชั้น)** โดยทั้งสองแบบเทียบเคียงกันได้ดังนี้:

![ตารางเปรียบเทียบ OSI 7 ชั้นเทียบกับ TCP/IP Model พร้อมอุปกรณ์และโปรโตคอล](/images/network/osi-vs-tcpip-layers.png)

| Layer OSI | ชื่อชั้น (OSI Layer) | หน้าที่หลัก | Protocol / เทคโนโลยี | อุปกรณ์ที่ทำงานในชั้นนี้ | หน่วยข้อมูล (PDU) |
|---|---|---|---|---|---|
| **Layer 7** | **Application** | ติดต่อกับผู้ใช้และซอฟต์แวร์แอปพลิเคชัน | HTTP, HTTPS, DNS, SSH, DHCP, SMTP, FTP | Web Browser, Nginx, App Server | Data |
| **Layer 6** | **Presentation** | จัดรูปแบบ เข้ารหัส บีบอัดข้อมูล | TLS/SSL, ASCII, JPEG, JSON | - | Data |
| **Layer 5** | **Session** | จัดการ เปิด ปิด เซสชันการสื่อสาร | RPC, NetBIOS, TLS Session | - | Data |
| **Layer 4** | **Transport** | ขนส่งข้อมูลแบบ Port-to-Port รับประกันการส่ง (TCP) หรือเน้นความเร็ว (UDP) | **TCP, UDP** (พอร์ต 80, 443, 22, 53) | Firewall (Stateful), Load Balancer L4 | **Segment** (TCP) / Datagram (UDP) |
| **Layer 3** | **Network** | การระบุที่อยู่ตรรกะ (Logical Addressing) และค้นหาเส้นทางข้ามเครือข่าย | **IPv4, IPv6, ICMP**, OSPF, BGP, ARP | **Router**, L3 Switch | **Packet** |
| **Layer 2** | **Data Link** | การส่งข้อมูลบนเครือข่ายท้องถิ่น (LAN) อ้างอิง Physical Address | **Ethernet, MAC Address, VLAN (802.1Q)** | **Switch (L2)**, NIC (Network Card) | **Frame** |
| **Layer 1** | **Physical** | การส่งสัญญาณบิตไฟฟ้า แสง หรือคลื่นวิทยุผ่านสื่อกลาง | Copper RJ45 (Cat6), Fiber Optic, SFP | สายสัญญาณ, Patch Panel, Hub, Transceiver | **Bits** |

> **สูตรจำชื่อ 7 ชั้นจากบนลงล่าง**: **A**ll **P**eople **S**eem **T**o **N**eed **D**ata **P**rocessing  
> **สูตรจำชื่อ 7 ชั้นจากล่างขึ้นบน**: **P**lease **D**o **N**ot **T**hrow **S**ausage **P**izza **A**way

---

## 2. วิธีคิดในการแก้ปัญหาแบบทีละชั้น (Layered Troubleshooting Methodologies)

เมื่อลูกค้าหรือระบบ Monitor ร้องเตือนว่า *"เข้าเว็บไม่ได้"* หรือ *"เซิร์ฟเวอร์ A ต่อฐานข้อมูล B ไม่ได้"* ช่างเทคนิคจะเลือกวิธีการวิเคราะห์ 3 รูปแบบหลัก:

### 1) วิธีล่างขึ้นบน: Bottom-Up Approach (แนะนำมากที่สุดสำหรับปัญหาฮาร์ดแวร์/เครือข่ายใหม่)
เริ่มตรวจจาก Layer 1 ขึ้นไป Layer 7:
1. **L1 (Physical)**: ไฟพอร์ต Link ติดไหม? สายหลุดไหม? ขั้วไฟเบอร์สลับไหม?
2. **L2 (Data Link)**: ได้รับ MAC Address ไหม? อยู่ใน VLAN ถูกต้องไหม? พอร์ต Switch เป็น Up/Up หรือไม่?
3. **L3 (Network)**: เครื่องได้รับ IP Address ไหม? Gateway ถูกไหม? `ping` หา Gateway ติดไหม?
4. **L4 (Transport)**: พอร์ตปลายทางเปิดฟังอยู่ไหม (`nc -zv`, `ss -tan`)? ติด Firewall ภายในหรือนอกไหม?
5. **L7 (Application)**: เว็บเซอร์วิส (Nginx/Node) ตอบกลับ HTTP 200 หรือ Error 500/502?

### 2) วิธีบนลงล่าง: Top-Down Approach (เหมาะสำหรับผู้ใช้ทั่วไปแจ้งปัญหาแอป)
เริ่มจากดูหน้า UI หรือ Application Layer ก่อน เช่น ทดสอบเปิดผ่านเบราว์เซอร์ หากเจอ `HTTP 404` แสดงว่าเครือข่ายปกติ ปัญหาอยู่ที่แอปพลิเคชัน แต่ถ้าเจอ `DNS_PROBE_FINISHED_NXDOMAIN` หรือ `Connection Timed Out` จึงค่อยไล่ลงไปหา DNS (L7), Firewall (L4) หรือ Network (L3)

### 3) วิธีแบ่งครึ่ง: Divide-and-Conquer (วิธีที่เร็วที่สุดสำหรับผู้มีประสบการณ์)
เริ่มทดสอบที่ **Layer 3 หรือ Layer 4 ทันที** ด้วยคำสั่ง `ping` หรือ `curl`:
- ถ้า `ping` เจอ Gateway และปลายทางได้ ➔ ตัดปัญหา Layer 1, 2, 3 ทิ้งได้ทันที 100%! ไปโฟกัสที่ Layer 4 (Port/Firewall) หรือ Layer 7 (App)
- ถ้า `ping` ไม่ติดตั้งแต่ Default Gateway ➔ รู้ทันทีว่าปัญหาอยู่ที่ Layer 1-3 ในระดับ Local Network แน่นอน ไม่ต้องเสียเวลาไปเช็กการตั้งค่าแอปพลิเคชัน

---

## 3. Checklist การใช้คำสั่งตรวจเช็กไล่ทีละชั้นบน Linux

เมื่อต้องแก้ไขปัญหาเครือข่ายบนเซิร์ฟเวอร์ ให้จำลำดับขั้นตอนคำสั่งต่อไปนี้:

```bash
# -------------------------------------------------------------
# ขั้นที่ 1: ตรวจสอบ Layer 1 & 2 (Link State & Interface)
# -------------------------------------------------------------
# ตรวจสอบว่า Interface มีสายเสียบและมีไฟ Link ติดหรือไม่ (State UP)
ip link show eth0
# ตรวจสอบความเร็วและการเชื่อมต่อทางกายภาพด้วย ethtool
ethtool eth0 | grep -E "Speed|Duplex|Link detected"

# -------------------------------------------------------------
# ขั้นที่ 2: ตรวจสอบ Layer 3 (IP, Subnet, Route & Gateway)
# -------------------------------------------------------------
# ดู IP Address ที่เครื่องได้รับ
ip -4 addr show eth0

# ดู Default Gateway
ip route show

# ปิงทดสอบ Gateway ท้องถิ่น (ถ้าไม่ติด ปัญหาอยู่ที่สาย/Switch/VLAN/IP ชน)
ping -c 3 192.168.1.1

# ปิงทดสอบ Public IP ภายนอก (เช่น 8.8.8.8 ถ้าติด แสดงว่าออกเน็ตได้ ปัญหาไม่ใช่ Routing)
ping -c 3 8.8.8.8

# -------------------------------------------------------------
# ขั้นที่ 3: ตรวจสอบ Layer 7 (DNS Resolution)
# -------------------------------------------------------------
# ทดสอบแปลงชื่อโฮสต์เป็นไอพี (ถ้า 8.8.8.8 ปิงติด แต่ปิง google.com ไม่ได้ แสดงว่าเป็นที่ DNS)
dig google.com +short

# -------------------------------------------------------------
# ขั้นที่ 4: ตรวจสอบ Layer 4 (Port & Firewall)
# -------------------------------------------------------------
# ทดสอบเชื่อมต่อไปยังพอร์ตปลายทาง (เช่น พอร์ต 443 หรือ 5432)
nc -zvw3 api.example.com 443

# ตรวจสอบพอร์ตที่เปิด Listening อยู่ในเครื่องตัวเอง
ss -tulpn
```

---

## 4. สรุปความผิดพลาดคลาสสิกแยกตามชั้น (Error Mapping)

| ปัญหาที่พบ | ชั้น OSI ที่รับผิดชอบ | สาเหตุที่เป็นไปได้ |
|---|---|---|
| ไฟ Link ดับ / สายไม่แน่น / Transceiver ร้อนจัด | **Layer 1** | สาย LAN ขาดใน, หัวไฟเบอร์สกปรก, เสียบผิดพอร์ต |
| ค่า CRC Error พุ่งสูง / Duplex Mismatch / เครื่องไม่เห็น MAC ของ Gateway | **Layer 2** | สายมีสัญญาณรบกวน, Switch ตั้งค่า VLAN ผิด, พอร์ตโดน STP บล็อก |
| `Destination Host Unreachable` / ไอพีชนกัน (IP Conflict) | **Layer 3** | Default Gateway ผิด, ตั้ง Subnet Mask ไม่ตรงวง, ตาราง Routing หาย |
| `Connection Refused` / `Connection Timed Out` | **Layer 4** | พอร์ตปลายทางไม่ได้เปิดรัน Service, ติด Security Group / iptables / Firewall |
| `SSL Certificate Expired` / `Handshake Failure` | **Layer 6** | ใบรับรองหมดอายุ, Cipher Suite ไม่ตรงกัน |
| `HTTP 502 Bad Gateway` / `DNS NXDOMAIN` | **Layer 7** | แอปพลิเคชันหลังบ้านล่ม (Node/PHP ตาย), ตั้งค่า DNS ผิด |
', 10, 'beginner', 5, true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.lessons VALUES ('d297f4f2-4aec-41db-b324-a8e4ae10ea05', 2, 'network-switching-vlan-trunk', 'การทำงานของ Switch, ARP, VLAN และ Trunk 802.1Q (Switching & VLANs)', 'กลไก MAC Address Table, Address Resolution Protocol (ARP), การแบ่งกลุ่ม Network ด้วย VLAN, โหมดพอร์ต Access vs Trunk, Native VLAN และ Inter-VLAN Routing', '
# การทำงานของ Switch, ARP, VLAN และ Trunk 802.1Q

ในเครือข่ายระดับองค์กรและศูนย์ข้อมูล (Data Center) อุปกรณ์ที่มีจำนวนพอร์ตมากที่สุดคือ **Network Switch** ทำหน้าที่เชื่อมโยงเครื่องเซิร์ฟเวอร์ พีซี และเราเตอร์เข้าด้วยกัน การเข้าใจว่าสวิตช์เรียนรู้เส้นทางอย่างไร และทำไมต้องแบ่ง **VLAN** เป็นความรู้ภาคบังคับที่ผู้ดูแลระบบทุกคนต้องเข้าใจอย่างถ่องแท้

---

## 1. กลไกการทำงานของ Switch: MAC Address Table

สวิตช์ Layer 2 ไม่สนใจ IP Address แต่มันส่งต่อข้อมูลด้วย **MAC Address (48-bit Physical Address)** ผ่านตารางจับคู่ที่เรียกว่า **MAC Address Table (หรือ CAM Table)**:

### กระบวนการ 3 ขั้นตอนของ Switch:
1. **Learning (เรียนรู้)**: เมื่อมี Frame วิ่งเข้ามาที่พอร์ตใดพอร์ตหนึ่ง สวิตช์จะดู **Source MAC Address** ใน Frame ทันที แล้วจดบันทึกลงตารางว่า *"MAC Address นี้ ต่ออยู่กับพอร์ตไหน (และอยู่ใน VLAN อะไร)"*
2. **Forwarding (ส่งต่อแบบเจาะจง)**: หากสวิตช์รู้จัก **Destination MAC Address** อยู่แล้วในตาราง มันจะส่ง Frame นั้นออกไปที่พอร์ตปลายทางเพียงพอร์ตเดียว (Unicast)
3. **Flooding (ส่งกระจายทุกพอร์ต)**: หาก Destination MAC Address ยังไม่อยู่ในตาราง (Unknown Unicast) หรือเป็น Broadcast (`FF:FF:FF:FF:FF:FF`) สวิตช์จะส่ง Frame นั้นออกไป **ทุกพอร์ตที่อยู่ใน VLAN เดียวกัน** (ยกเว้นพอร์ตที่รับเข้ามา)

```bash
# ตรวจสอบ MAC Address Table บน Cisco Switch
Switch# show mac address-table
          Mac Address Table
-------------------------------------------
Vlan    Mac Address       Type        Ports
----    -----------       --------    -----
  10    5254.0012.3456    DYNAMIC     Gi0/1
  10    5254.00ab.cdef    DYNAMIC     Gi0/2
  20    5254.0099.8877    DYNAMIC     Gi0/5
```

---

## 2. ARP (Address Resolution Protocol): ตัวเชื่อม IP กับ MAC

เนื่องจากแอปพลิเคชันต้องการส่งข้อมูลไปยัง IP Address (Layer 3) แต่การ์ดแลนในระบบ Ethernet ส่งข้อมูลด้วย MAC Address (Layer 2) จึงต้องมีโปรโตคอล **ARP** ทำหน้าที่ถามหาว่า: *"IP นี้ คือ MAC Address อะไร?"*

### ขั้นตอนการทำงานของ ARP:
1. เครื่อง A (192.168.1.10) ต้องการส่งข้อมูลหาเครื่อง B (192.168.1.20) แต่ยังไม่รู้ MAC Address ของ B
2. เครื่อง A ส่ง **ARP Request (Broadcast)** กระจายทั่วทั้งเครือข่าย: *"ใครถือ IP 192.168.1.20 ช่วยบอก MAC Address ให้ 192.168.1.10 ทราบที"*
3. ทุกเครื่องในวงได้รับ แต่เฉพาะเครื่อง B ที่ถือ IP นั้น จะตอบกลับเป็น **ARP Reply (Unicast)**: *"ฉันเอง 192.168.1.20 MAC ของฉันคือ 00:1a:2b:3c:4d:5e"*
4. เครื่อง A จดบันทึกคู่นี้ไว้ใน **ARP Cache** ของตนเอง เพื่อไม่ต้องถามใหม่อีกในระยะเวลาหนึ่ง

```bash
# บนเซิร์ฟเวอร์ Linux ดูตาราง ARP Cache
ip neigh show
# หรือคำสั่งดั้งเดิม
arp -an

# ลบ ARP Cache ในกรณีที่เปลี่ยนการ์ดแลนหรือไอพีแล้วข้อมูลค้าง
ip neigh flush all
```

---

## 3. ทำไมต้องแบ่ง VLAN (Virtual Local Area Network)?

หากไม่มี VLAN ทุกเครื่องที่เสียบสายเข้าสวิตช์จะอยู่ใน **Broadcast Domain เดียวกัน**:
- หากมีเครื่องใดติดไวรัสหรือส่ง Broadcast มหาศาล ทุกเครื่องในองค์กรจะต้องรับฟัง ส่งผลให้เครือข่ายอืด (Network Congestion)
- ขาดความปลอดภัย ฝ่ายบุคคล การเงิน และเซิร์ฟเวอร์ฐานข้อมูลสามารถดักฟังแพ็กเก็ตของกันและกันได้

**VLAN** คือการตัดแบ่งสวิตช์ตัวจริง 1 ตัว ให้ทำหน้าที่เสมือนมีสวิตช์เสมือนหลายตัวแยกขาดจากกัน:
- **เครื่องที่อยู่ต่าง VLAN กัน จะไม่สามารถคุยกันได้โดยตรงที่ Layer 2** (แม้จะเสียบสวิตช์ตัวเดียวกัน)
- หากต้องการให้ต่าง VLAN คุยกัน ต้องส่งผ่าน **Router หรือ Layer 3 Switch (เรียกว่า Inter-VLAN Routing)**

![การเชื่อมต่อระหว่าง Switch ด้วยพอร์ต Access และ Trunk 802.1Q](/images/network/vlan-access-trunk.png)

---

## 4. โหมดของพอร์ต Switch: Access Port vs Trunk Port

เมื่อคอนฟิกพอร์ตบนสวิตช์ จะต้องระบุว่าพอร์ตนั้นทำหน้าที่เป็น **Access** หรือ **Trunk**:

| คุณสมบัติ | Access Port | Trunk Port (Tagging) |
|---|---|---|
| **อุปกรณ์ที่นำมาเชื่อมต่อ** | เครื่องลูกข่าย, เซิร์ฟเวอร์ทั่วไป, พรินเตอร์, กล้องวงจรปิด | สวิตช์เชื่อมกับสวิตช์ (Switch-to-Switch), สวิตช์เชื่อม Router, เซิร์ฟเวอร์ VMware ESXi |
| **จำนวน VLAN ที่รองรับ** | **VLAN เดียวเท่านั้น** (เช่น รับเฉพาะ VLAN 10) | **หลาย VLAN พร้อมกัน** (เช่น อนุญาต VLAN 10, 20, 30 วิ่งผ่านสายเส้นเดียว) |
| **การใส่ Tag (802.1Q)** | **Untagged**: Frame ที่ส่งเข้าคอมพิวเตอร์จะเป็นเฟรมปกติ ไม่มี VLAN Tag แปะหัว | **Tagged**: สวิตช์จะแปะ **VLAN Tag (802.1Q Header ขนาด 4 bytes)** เพื่อระบุว่าเฟรมนี้เป็นของ VLAN ใด |

### แนวคิด Native VLAN บน Trunk Port:
พอร์ต Trunk จะยอมให้มี **VLAN พิเศษ 1 อันที่ไม่ต้องแปะ Tag (Untagged)** เรียกว่า **Native VLAN** (ค่าเริ่มต้นมักเป็น VLAN 1) หากมีเฟรมธรรมดาที่ไม่มี Tag วิ่งเข้ามาที่พอร์ต Trunk สวิตช์จะโยนเฟรมนั้นเข้าสู่ Native VLAN ทันที

> **Security Warning**: ในการใช้งานจริง แนะนำให้เปลี่ยน Native VLAN จากค่าเริ่มต้น (VLAN 1) ไปเป็น VLAN อื่นที่ไม่ได้ใช้งาน (เช่น VLAN 999) เพื่อป้องกันการโจมตีประเภท **VLAN Hopping Attack**

---

## 5. การตั้งค่าบน Cisco CLI เบื้องต้น

```text
! กำหนดพอร์ต Gi0/1 เป็น Access Port สำหรับเครื่องฝ่ายบัญชี (VLAN 10)
Switch(config)# interface GigabitEthernet0/1
Switch(config-if)# description Accounting-PC-01
Switch(config-if)# switchport mode access
Switch(config-if)# switchport access vlan 10
Switch(config-if)# exit

! กำหนดพอร์ต Gi0/24 เป็น Trunk Port เชื่อมต่อไปยัง Core Switch
Switch(config)# interface GigabitEthernet0/24
Switch(config-if)# description Uplink-to-CoreSwitch
Switch(config-if)# switchport mode trunk
Switch(config-if)# switchport trunk allowed vlan 10,20,30
Switch(config-if)# exit
```

---

## 6. สรุป Checklist แก้ปัญหาเมื่อเครื่องคุยกันไม่ได้ในระบบ Switch/VLAN

1. **เช็ก Access VLAN**: พอร์ตของเครื่องทั้งสองฝั่งตั้งค่า VLAN ตรงกันหรือไม่ (`show mac address-table` หรือ `show vlan brief`)
2. **เช็ก Trunk Allowed VLAN**: พอร์ต Trunk ระหว่างสวิตช์มีการ `allowed` VLAN นั้นให้วิ่งผ่านหรือไม่? (ปัญหาคลาสสิก: สร้าง VLAN ที่ Access Switch แล้ว แต่ลืม allow ใน Trunk Uplink)
3. **เช็ก Default Gateway**: หากเครื่องอยู่คนละ VLAN (เช่น เครื่อง A อยู่ VLAN 10 เครื่อง B อยู่ VLAN 20) เครื่องต้องชี้ Default Gateway ไปที่ IP ของ Router/L3 Switch ไม่อย่างนั้นจะไม่สามารถส่งข้ามวงได้
', 10, 'intermediate', 6, true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.lessons VALUES ('11100691-a71e-441a-abe3-ba9a1d4ba021', 2, 'network-dhcp-nat', 'ระบบแจกไอพี DHCP และการแปลงแอดเดรส NAT/PAT (DHCP & Network Address Translation)', 'ขั้นตอนการขอ IP (DORA Process), อายุสัญญา Lease Time, ข้อผิดพลาด APIPA (169.254.x.x), กลไก DHCP Relay, และความแตกต่างของ Static NAT, Dynamic NAT และ PAT (NAT Overload)', '
# ระบบแจกไอพี DHCP และการแปลงแอดเดรส NAT/PAT

ในงาน Support ปัญหาเครือข่ายกว่า 40% ที่ผู้ใช้ทั่วไปหรือเซิร์ฟเวอร์เปิดใหม่ต่อเน็ตไม่ได้ เกิดจากสองเรื่องนี้: **ขอไอพีไม่ได้ (DHCP Failure)** หรือ **วิ่งออกสู่อินเทอร์เน็ตไม่ได้ (NAT Failure)** การเข้าใจกลไกและขั้นตอนเบื้องหลังจะช่วยให้คุณวิเคราะห์ปัญหาได้ในเวลาไม่กี่นาที

---

## 1. การทำงานของ DHCP และขั้นตอน 4 สเต็ป: DORA Process

**DHCP (Dynamic Host Configuration Protocol)** ทำงานบนโปรโตคอล **UDP พอร์ต 67 (Server) และ 68 (Client)** ทำหน้าที่จ่าย IP Address, Subnet Mask, Default Gateway และ DNS Server ให้เครื่องลูกข่ายโดยอัตโนมัติ

เมื่อเครื่องคอมพิวเตอร์หรือเซิร์ฟเวอร์เปิดเครื่องขึ้นมา จะขอ IP ตามลำดับ **D-O-R-A**:

![แผนภาพขั้นตอนการขอไอพีด้วย DHCP แบบ DORA Process](/images/network/dhcp-dora-flow.png)

1. **Discover (Broadcast)**: เครื่องลูกข่ายยังไม่มี IP จึงส่งเฟรม Broadcast ออกไปทั้งเครือข่าย  
   - Source IP: `0.0.0.0` | Destination IP: `255.255.255.255`  
   - ใจความ: *"มี DHCP Server อยู่ในวงนี้ไหม? ฉันต้องการ IP Address"*
2. **Offer (Unicast หรือ Broadcast)**: DHCP Server ได้รับ จึงตอบกลับพร้อมเสนอไอพีที่ว่างอยู่  
   - ใจความ: *"ฉันคือ DHCP Server เสนอให้ใช้ IP 192.168.1.50 นะ"*
3. **Request (Broadcast)**: เครื่องลูกข่ายตอบรับเพื่อยืนยันขอใช้ไอพีนั้น  
   - ใจความ: *"ตกลง ฉันขอรับ IP 192.168.1.50 จาก DHCP Server ตัวนี้นะ"* (ส่งแบบ Broadcast เพื่อให้ DHCP Server ตัวอื่นที่ส่ง Offer มาทราบว่าเครื่องเลือกข้อเสนอของใคร)
4. **Acknowledge / ACK (Unicast หรือ Broadcast)**: DHCP Server ยืนยันสัญญาสุดท้าย  
   - ใจความ: *"บันทึกข้อมูลแล้ว คุณสามารถใช้ IP 192.168.1.50 ได้เป็นเวลา 24 ชั่วโมง (Lease Time)"*

---

## 2. ปัญหาคลาสสิกของ DHCP ที่ต้องจำให้ขึ้นใจ

### 1) ได้ไอพีแปลกประหลาด: 169.254.x.x (APIPA)
หากเปิดเครื่องแล้วรันคำสั่ง `ip addr` หรือ `ipconfig` แล้วพบว่าได้ไอพีขึ้นต้นด้วย **`169.254.x.x`**:
- นี่คือ **APIPA (Automatic Private IP Addressing)**
- **ความหมายทันที**: เครื่องของคุณ **ไม่ได้รับสัญญาณตอบกลับจาก DHCP Server** (DHCP ขอไม่สำเร็จ) ระบบปฏิบัติการจึงสุ่มไอพีนี้มาให้เพื่อใช้สื่อสารเฉพาะกิจในเครื่องข้างเคียง
- **สาเหตุที่เป็นไปได้**:
  - สายแลนเสียบผิด VLAN หรือพอร์ตสวิตช์ไม่ได้ต่อกับ DHCP
  - DHCP Server ล่ม หรือ **DHCP Pool เต็ม** (ไม่มีไอพีว่างเหลือแจก)
  - มี Firewall บล็อก UDP พอร์ต 67/68

### 2) DHCP Relay Agent (ip helper-address)
DHCP Discover ส่งแบบ **Broadcast** ซึ่งเราเตอร์จะไม่ยอมให้ Broadcast วิ่งข้ามวง (ข้าม Subnet):
- หากเครื่องลูกข่ายอยู่ VLAN 10 แต่เครื่อง DHCP Server อยู่ใน Server Farm VLAN 100 ➔ ลูกข่ายจะขอไอพีไม่ได้
- **ทางแก้**: ต้องคอนฟิกฟังก์ชัน **DHCP Relay (บน Cisco คือคำสั่ง `ip helper-address <IP_DHCP_Server>`)** ไว้ที่ Interface Gateway ของเราเตอร์ เพื่อให้เราเตอร์แปลง Broadcast นั้นเป็น Unicast ส่งตรงไปยัง DHCP Server ข้ามวงได้

```text
! ตัวอย่างการตั้งค่า DHCP Relay บน Cisco Router / L3 Switch
Router(config)# interface vlan 10
Router(config-if)# ip address 192.168.10.1 255.255.255.0
Router(config-if)# ip helper-address 10.0.0.100
Router(config-if)# exit
```

---

## 3. ทำความรู้จัก NAT (Network Address Translation)

IPv4 มีจำนวนจำกัดเพียงประมาณ 4.3 พันล้านหมายเลข ไม่เพียงพอกับอุปกรณ์ทั่วโลก จึงต้องแบ่งเป็น **Private IP** (เช่น `192.168.x.x`, `10.x.x.x`, `172.16-31.x.x`) และ **Public IP** (ไอพีจริงบนอินเทอร์เน็ต)

**NAT** คือกระบวนการที่ทำหน้าที่ **แปลง Private IP เป็น Public IP** เมื่อข้อมูลจะวิ่งออกสู่อินเทอร์เน็ต และแปลงกลับเมื่อข้อมูลตอบกลับมา

![แผนภาพเปรียบเทียบการทำงานของ NAT และ PAT ในการแปลงแอดเดรส](/images/network/nat-pat-diagram.png)

### ประเภทของ NAT 3 รูปแบบ:

| ประเภท NAT | หลักการทำงาน | กรณีใช้งานจริง |
|---|---|---|
| **Static NAT (1-to-1)** | แมปปิ้ง 1 Private IP คู่กับ 1 Public IP แบบถาวร | เซิร์ฟเวอร์ในศูนย์ข้อมูลที่ต้องการให้ภายนอกยิงเข้ามาหาได้ เช่น Web Server หรือ Mail Server |
| **Dynamic NAT (Pool-to-Pool)** | มีกลุ่ม Public IP (Pool) ว่างอยู่ ใครต่อออกเน็ตก่อนก็ยืมไปใช้ เมื่อเลิกใช้ก็คืน Pool | ไม่ค่อยนิยมแล้วในปัจจุบัน |
| **PAT / NAT Overload (Many-to-One)** | อุปกรณ์นับร้อยนับพันเครื่องในบ้านหรือองค์กร **ใช้ Public IP จริงเพียงเบอร์เดียวพร้อมกันได้** โดยอาศัยการจำแนกด้วย **Port Number (เช่น พอร์ต 50001, 50002)** | ใช้งานในบ้าน สำนักงาน ออฟฟิศ และ Cloud VPC (NAT Gateway) |

---

## 4. กลไกของ PAT (Port Address Translation / NAT Overload)

ทำไมมือถือ คอมพิวเตอร์ และสมาร์ตทีวีในบ้าน 20 เครื่อง ออกอินเทอร์เน็ตผ่านเราเตอร์ตัวเดียวที่มี Public IP เดียวได้พร้อมกัน?

1. เครื่องลูกข่าย A (`192.168.1.10:52134`) ส่งคำขอเปิดเว็บ `8.8.8.8:443`
2. เราเตอร์ (NAT Gateway) ทำการแปลง Source:
   - แปลง IP ต้นทางจาก `192.168.1.10` ➔ เป็น Public IP `203.0.113.5`
   - สุ่ม Port ภายนอกขึ้นมา เช่น `61001`
   - จดลง **NAT Translation Table**: `192.168.1.10:52134 <--> 203.0.113.5:61001`
3. เว็บปลายทางตอบกลับมาหา `203.0.113.5:61001`
4. เราเตอร์เปิดตารางดู พบว่าพอร์ต `61001` เป็นของเครื่อง A จึงแปลงปลายทางกลับเป็น `192.168.1.10:52134` แล้วส่งต่อไปยังเครื่อง A ได้อย่างถูกต้อง

```bash
# ตรวจสอบ Public IP ที่เครื่องของคุณออกเน็ต ณ ปัจจุบัน
curl -s ifconfig.me
# หรือ
curl -s api.ipify.org

# ดูรายละเอียดตาราง NAT บนเราเตอร์ Cisco
Router# show ip nat translations
Pro Inside global      Inside local       Outside local      Outside global
tcp 203.0.113.5:61001  192.168.1.10:52134 8.8.8.8:443        8.8.8.8:443
```

---

## 5. สรุป Checklist วิเคราะห์ปัญหา DHCP และ NAT

| อาการที่ตรวจพบ | ข้อวินิจฉัย | แนวทางแก้ไข |
|---|---|---|
| เครื่องได้ไอพี `169.254.x.x` | ขอ DHCP ไม่สำเร็จ | ตรวจสอบสายแลน, ตรวจสอบสถานะ DHCP Service, ตรวจสอบว่า IP Pool เต็มหรือไม่ |
| ได้ไอพีปกติ ปิง Default Gateway ติด แต่เปิดเว็บไม่ได้และปิง `8.8.8.8` ไม่ติด | NAT หรือ Routing ขาออกมีปัญหา | ตรวจสอบคอนฟิก NAT บน Router / Firewall ว่ามีการเปิด Overload ให้ Subnet นี้หรือไม่ |
| ปิง `8.8.8.8` ติด แต่เปิดเว็บไม่ได้ | ไม่เกี่ยวกับ NAT เป็นปัญหาที่ DNS | ตรวจสอบไฟล์ `/etc/resolv.conf` ว่าระบุ Nameserver ถูกต้องหรือไม่ |
| เครื่องจากภายนอกเข้า Web Server ภายในไม่ได้ | ไม่ได้ทำ Port Forwarding หรือ Static NAT | คอนฟิก Static NAT หรือ Port Forwarding จาก Public IP พอร์ต 80/443 ไปยัง Private IP ของเซิร์ฟเวอร์ |
', 10, 'intermediate', 7, true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.lessons VALUES ('c349c769-a0a4-4287-a5dd-73daeaa0f3a8', 2, 'network-cli-show-commands', 'คำสั่งสำรวจและตรวจสอบเครือข่าย Cisco/Network CLI (Show Commands & Diagnostics)', 'การเชื่อมต่อผ่าน Console Cable, โครงสร้าง User EXEC vs Privileged EXEC, สูตรคำสั่ง show ยอดฮิต: show ip int brief, show interfaces, show vlan brief, show mac address-table และ show ip route', '
# คำสั่งสำรวจและตรวจสอบเครือข่าย Cisco/Network CLI

ไม่ว่าคุณจะดูแลอุปกรณ์ **Cisco, Juniper, Huawei, Aruba หรือ MikroTik** แม้ไวยากรณ์จะต่างกันเล็กน้อย แต่แนวคิดการจัดการผ่าน **Command Line Interface (CLI)** ล้วนมีโครงสร้างแบบเดียวกัน ในฐานะ Junior Network หรือ Support ประจำศูนย์ข้อมูล การรู้วิธีเข้า Console และใช้คำสั่งกลุ่ม `show` คือกุญแจสำคัญในการวินิจฉัยปัญหาโดยไม่สร้างความเสี่ยงให้เครือข่ายล่ม

---

## 1. วิธีเชื่อมต่อและการเข้าสู่ CLI (Console Access)

เมื่อสวิตช์หรือเราเตอร์เครื่องใหม่ยังไม่ได้ตั้ง IP หรือระบบเครือข่ายล่มจนไม่สามารถรีโมตผ่าน SSH ได้ คุณจะต้องต่อสายเข้าเครื่องโดยตรง:

1. **สาย Console**: สายสีฟ้า RJ45-to-DB9 (หรือสายยุคใหม่เป็น USB-C / USB Type-A to RJ45) เสียบเข้าที่พอร์ต **Console** ด้านหน้าหรือหลังอุปกรณ์
2. **โปรแกรม Terminal Emulator**: บนคอมพิวเตอร์ของคุณ เปิดโปรแกรมเช่น **PuTTY, Tera Term หรือ SecureCRT**
3. **พารามิเตอร์การเชื่อมต่อ (Serial Settings)**:
   - **Baud Rate (Speed)**: `9600` (ค่ามาตรฐานสากล)
   - **Data Bits**: `8`
   - **Parity**: `None`
   - **Stop Bits**: `1`
   - **Flow Control**: `None`

---

## 2. ลำดับโหมดของ Cisco IOS CLI (Command Modes)

Cisco แบ่งระดับการทำงานเพื่อความปลอดภัยออกเป็น 3 โหมดหลัก:

```text
Switch>             <-- 1. User EXEC Mode (ดูข้อมูลทั่วไปได้อย่างจำกัด ไม่สามารถแก้คอนฟิก)
Switch> enable      <-- พิมพ์คำสั่ง enable และใส่รหัสผ่าน เพื่อยกระดับสิทธิ์
Switch#             <-- 2. Privileged EXEC Mode (ดูข้อมูลเชิงลึกได้ทุกอย่าง รันคำสั่ง show ได้ครบ)
Switch# configure terminal
Switch(config)#     <-- 3. Global Configuration Mode (แก้ไขการตั้งค่าของสวิตช์/เราเตอร์)
```

> **กฎเหล็กของงาน Support & NOC**: เมื่อได้รับมอบหมายให้ตรวจสอบปัญหา ให้ทำงานใน **Privileged EXEC Mode (`#`)** เท่านั้น ห้ามเข้าสู่ `configure terminal` หากไม่ได้รับอนุมัติใน Change Request เพราะการพิมพ์คำสั่งผิดในโหมด config อาจทำให้พอร์ตดับหรือเน็ตเวิร์กล่มทั้งระบบ

---

## 3. มหาคัมภีร์คำสั่ง Show ที่ต้องใช้เป็นประจำ

![ตัวอย่างผลลัพธ์คำสั่ง show ip interface brief บน Cisco Switch](/images/network/cisco-show-ip-int-brief.png)

### 1) ตรวจสอบสถานะพอร์ตและ IP อย่างรวดเร็ว: `show ip interface brief`
คำสั่งอันดับ 1 ที่วิศวกรทุกคนต้องพิมพ์เป็นคำสั่งแรก:

```text
Switch# show ip interface brief
Interface              IP-Address      OK? Method Status                Protocol
GigabitEthernet0/1     unassigned      YES unset  up                    up      
GigabitEthernet0/2     unassigned      YES unset  up                    down    
GigabitEthernet0/3     unassigned      YES unset  down                  down    
GigabitEthernet0/4     unassigned      YES unset  administratively down down    
Vlan1                  192.168.1.2     YES NVRAM  up                    up      
```

#### ถอดรหัสคอลัมน์ `Status` และ `Protocol`:
- **Status (Layer 1 - Physical)**: สายสัญญาณเสียบอยู่ไหม? มีสัญญาณไฟฟ้า/แสงเข้ามาไหม?
- **Protocol (Layer 2 - Data Link)**: คุยกันรู้เรื่องไหม? มีการรับส่ง Keepalive หรือ Clock สัญญาณถูกต้องหรือไม่?

| Status | Protocol | ความหมายเชิงลึก | สาเหตุและวิธีแก้ |
|---|---|---|---|
| **up** | **up** | พอร์ตทำงานสมบูรณ์ 100% | พร้อมใช้งานปกติ |
| **up** | **down** | มีสัญญาณทางกายภาพ (L1 ผ่าน) แต่ L2 คุยไม่ผ่าน | มีปัญหาเรื่อง Encapsulation, Duplex Mismatch หรือพอร์ตอีกฝั่งไม่ได้เปิด Protocol |
| **down** | **down** | ไม่มีสัญญาณทั้ง L1 และ L2 | สายแลนหลุด, หัวไฟเบอร์สลับ Tx/Rx, ปลายทางปิดเครื่อง, หรือพอร์ตเสีย |
| **administratively down** | **down** | พอร์ตถูกสั่งปิดใช้งานด้วยคำสั่ง `shutdown` | แอดมินจงใจปิดไว้ หากต้องการเปิดต้องสั่ง `no shutdown` |

---

### 2) ตรวจสอบรายละเอียดทางกายภาพและ Error Counters: `show interfaces <port>`
เมื่อพบว่าความเร็วเครือข่ายตกหรือสัญญาณติดๆ ดับๆ ให้เจาะลึกที่พอร์ตนั้น:

```text
Switch# show interfaces GigabitEthernet0/1
GigabitEthernet0/1 is up, line protocol is up 
  Hardware is Gigabit Ethernet, address is 5254.0012.3456
  Description: Link to DB-Server-01
  MTU 1500 bytes, BW 1000000 Kbit/sec, DLY 10 usec, 
     Full-duplex, 1000Mb/s, media type is 10/100/1000BaseTX
  Input flow-control is off, output flow-control is unsupported
  5 minute input rate 125000 bits/sec, 142 packets/sec
  5 minute output rate 280000 bits/sec, 210 packets/sec
     12894523 packets input, 891238475 bytes, 0 no buffer
     Received 24 broadcasts (0 multicasts)
     0 runts, 0 giants, 0 throttles
     15842 input errors, 15840 CRC, 0 frame, 0 overrun, 2 ignored
     0 watchdog, 0 multicast, 0 pause input
     0 output errors, 0 collisions, 2 interface resets
```

- **CRC Errors**: หากตัวเลขนี้เพิ่มขึ้นเรื่อยๆ แสดงว่า **สายสัญญาณมีสัญญาณรบกวน** หัวสายไม่แน่น หรือสายยาวเกินมาตรฐาน
- **Collisions / Late Collisions**: หากพบค่านี้ในระบบ Switch แสดงว่าเกิด **Duplex Mismatch** (ฝั่งหนึ่งเป็น Full-duplex อีกฝั่งเป็น Half-duplex)

---

### 3) ตรวจสอบการจัดสรร VLAN: `show vlan brief`

```text
Switch# show vlan brief
VLAN Name                             Status    Ports
---- -------------------------------- --------- -------------------------------
1    default                          active    Gi0/5, Gi0/6, Gi0/7, Gi0/8
10   Management                       active    Gi0/1, Gi0/2
20   App-Servers                      active    Gi0/3, Gi0/4
30   Database                         active    
```
- ใช้เช็กทันทีว่า พอร์ตของเครื่องที่กำลังมีปัญหา ถูก assign ให้อยู่ใน VLAN ที่ถูกต้องแล้วหรือไม่
- พอร์ตที่ทำเป็น **Trunk จะไม่ปรากฏในตารางนี้** (เพราะ Trunk ส่งได้หลาย VLAN ให้ใช้คำสั่ง `show interfaces trunk` แทน)

---

### 4) ตรวจสอบพอร์ต Trunk: `show interfaces trunk`

```text
Switch# show interfaces trunk
Port        Mode             Encapsulation  Status        Native vlan
Gi0/24      on               802.1q         trunking      1

Port        Vlans allowed on trunk
Gi0/24      10,20,30

Port        Vlans in spanning tree forwarding state and not pruned
Gi0/24      10,20,30
```
- ดูว่าพอร์ต Uplink กำลังทำงานเป็น Trunk จริงหรือไม่ (`trunking`)
- ดูค่า **Native VLAN** ว่าตรงกับสวิตช์ฝั่งตรงข้ามหรือไม่ (หากไม่ตรงจะเกิด Native VLAN Mismatch Error)
- ดูว่า VLAN ของเราได้รับอนุญาต (`allowed`) ให้ผ่านสาย Trunk เส้นนี้หรือไม่

---

### 5) ตรวจสอบเส้นทางเครือข่ายบน Router: `show ip route`

```text
Router# show ip route
Gateway of last resort is 203.0.113.1 to network 0.0.0.0

S*    0.0.0.0/0 [1/0] via 203.0.113.1
C     192.168.10.0/24 is directly connected, GigabitEthernet0/1
C     192.168.20.0/24 is directly connected, GigabitEthernet0/2
O     10.50.0.0/16 [110/2] via 192.168.10.254, 01:45:12, GigabitEthernet0/1
```
- **`C` (Connected)**: เครือข่ายที่ต่ออยู่กับขาเราเตอร์โดยตรง
- **`S*` (Static Default Route)**: เส้นทาง `0.0.0.0/0` ที่ชี้ไปยัง Gateway สำหรับส่งข้อมูลออกนอกเครือข่าย
- **`O` (OSPF)**: เส้นทางที่เรียนรู้มาผ่าน Dynamic Routing Protocol

---

## 4. สรุปเคล็ดลับการใช้งาน CLI อย่างมือโปร

1. **ใช้ปุ่ม `Tab` เพื่อเติมคำอัตโนมัติ**: เช่น พิมพ์ `sh ip int br` แล้วกด Tab ระบบจะเติมเต็มให้อัตโนมัติ
2. **ใช้เครื่องหมาย `?` เมื่อจำคำสั่งไม่ได้**: เช่น พิมพ์ `show interfaces ?` เพื่อดูตัวเลือกทั้งหมด
3. **การกรองผลลัพธ์ด้วย Pipe (`|`)**: บน Cisco สามารถใช้ pipe เพื่อตัดคำเหมือนบน Linux ได้:
   - `show ip interface brief | include up` ➔ ดูเฉพาะพอร์ตที่ UP
   - `show running-config | section interface` ➔ ดูเฉพาะท่อนคอนฟิก Interface
   - `show interfaces | include CRC` ➔ หาพอร์ตที่มีค่า CRC error ทันที
', 10, 'intermediate', 8, true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.lessons VALUES ('ff620473-be72-44d1-bbee-3112ba85188d', 2, 'network-layer1-2-problems', 'ถอดรหัสปัญหา Layer 1 และ Layer 2 หน้างาน (L1/L2 Troubleshooting & Storms)', 'อาการและวิธีแก้ปัญหา Duplex Mismatch (Half vs Full), การอ่านเคาน์เตอร์ CRC/Input Errors, ปัญหา Port Flapping, Loop ในสวิตช์และ Broadcast Storm (STP), รวมถึงการรวมสายด้วย LACP (Port-Channel)', '
# ถอดรหัสปัญหา Layer 1 และ Layer 2 หน้างาน

ปัญหาเครือข่ายที่ชวนปวดหัวที่สุดไม่ใช่เรื่อง Routing หรือ Firewall แต่คือปัญหา **สัญญาณติดๆ ดับๆ ความเร็วตกฮวบ หรือระบบสวิตช์ค้างทั้งตึก** อาการเหล่านี้กว่า 80% เกิดจากความผิดปกติใน **Layer 1 (Physical)** และ **Layer 2 (Data Link)** ซึ่งช่างเทคนิคและวิศวกร Support ต้องสังเกตอาการและชี้จุดตายให้ขาด

---

## 1. วิกฤต Duplex Mismatch (Half-Duplex vs Full-Duplex)

หนึ่งในปัญหาคลาสสิกที่ทำให้เครือข่ายใช้งานได้แต่ *"ช้าเหมือนเต่าคลาน"* (ส่งไฟล์ไม่กี่ MB แต่ใช้เวลาเป็นชั่วโมง) คือ **Duplex Mismatch**:

- **Full-Duplex**: ส่งและรับข้อมูลได้พร้อมกันในเวลาเดียวกัน (โทรศัพท์สองทาง)
- **Half-Duplex**: ส่งหรือรับได้ทีละฝั่งเท่านั้น หากส่งพร้อมกันจะเกิดการชนกันของสัญญาณ (**Collision**) เหมือนวิทยุสื่อสาร วอ.

### อาการเกิดขึ้นได้อย่างไร?
ตามมาตรฐาน Ethernet มีระบบ **Auto-Negotiation (เจรจาความเร็วและ Duplex อัตโนมัติ)**:
- หากฝั่งหนึ่งตั้งค่าเป็น `Auto` แต่อีกฝั่งหนึ่งถูกแอดมิน **Hardcode (Force)** ให้เป็น `1000Mbps Full-Duplex`
- ฝั่งที่เป็น Auto จะไม่สามารถตรวจจับ Duplex ของอีกฝั่งได้ ตามมาตรฐานมันจะ Fallback ลงไปเป็น **Half-Duplex ทันทีเพื่อความปลอดภัย!**
- **ผลลัพธ์ที่ตามมา**:
  - ฝั่ง Full-Duplex ส่งข้อมูลเมื่อไหร่ก็ได้ เพราะไม่คิดว่าจะมีการชนกัน
  - ฝั่ง Half-Duplex คิดว่ามีการชนกันของสัญญาณ จึงส่งสัญญาณ Jamming และสั่งหยุดส่ง ทำให้เกิด **Late Collisions** และ Packet Loss มหาศาลเมื่อมี Traffic เยอะ!

```text
! อาการในคำสั่ง show interfaces:
Switch# show interfaces Gi0/1
  Full-duplex, 100Mb/s, media type is 10/100/1000BaseTX
  ...
  15200 late collision, 420 deferred
```

> **กฎเหล็กเรื่อง Duplex**: หากจะตั้ง ให้ตั้งเป็น **Auto/Auto ทั้งสองฝั่ง** หรือหากจำเป็นต้องฟิกซ์ ให้ **Hardcode Speed และ Duplex ให้ตรงกันทั้งสองฝั่ง 100%** ห้ามตั้ง Auto ฝั่งหนึ่งและ Force อีกฝั่งหนึ่งเด็ดขาด

---

## 2. ปัญหา Port Flapping (พอร์ตติดๆ ดับๆ)

**Port Flapping** คืออาการที่พอร์ตสวิตช์ขึ้นสถานะ **UP** แล้วสลับเป็น **DOWN** วนลูปต่อเนื่องหลายสิบครั้งต่อนาที:

```text
%LINK-3-UPDOWN: Interface GigabitEthernet0/5, changed state to up
%LINEPROTO-5-UPDOWN: Line protocol on Interface GigabitEthernet0/5, changed state to up
%LINK-3-UPDOWN: Interface GigabitEthernet0/5, changed state to down
%LINEPROTO-5-UPDOWN: Line protocol on Interface GigabitEthernet0/5, changed state to down
```

### ผลกระทบ:
- เครื่องเซิร์ฟเวอร์หลุดการเชื่อมต่อเป็นระยะ
- ทำให้โปรโตคอล Spanning Tree (STP) และ Routing ทำการคำนวณใหม่ (Topology Change Notification - TCN) ตลอดเวลา ส่งผลให้สวิตช์ตัวอื่นในเครือข่าย CPU พุ่งสูง 100%!

### สาเหตุและวิธีตรวจสอบ:
1. **สายสัญญาณหลวมหรือหักใน**: ลองขยับหัว RJ45 หรือเปลี่ยนสาย Patch Cord เส้นใหม่
2. **แสงไฟเบอร์อ่อน (Low Optical Power)**: หัวไฟเบอร์สกปรก หรือสายไฟเบอร์ถูกงอเกินรัศมีโค้งงอ (Bend Radius) ให้ใช้คำสั่ง `show interfaces transceiver detail` ดูค่า **Rx Optical Power (dBm)** หากต่ำกว่า -18 dBm แสงจะเริ่มขาดช่วง
3. **โมดูล SFP ชำรุดหรือร้อนเกินไป**: ลองสลับเปลี่ยนหัว SFP ตัวใหม่

---

## 3. มหาภัยพิบัติ Switching Loop และ Broadcast Storm

ในระบบ Ethernet เฟรม Layer 2 **ไม่มีฟิลด์ TTL (Time-to-Live)** เหมือนกับ IP Packet ใน Layer 3:
- หากใครสักคนเผลอเสียบสาย LAN จากพอร์ตหนึ่งของสวิตช์ วนกลับเข้าไปอีกพอร์ตหนึ่งของสวิตช์เดียวกัน หรือเชื่อมสวิตช์สองตัวเข้าด้วยกันด้วยสายคู่โดยไม่ได้ทำ Link Aggregation
- เมื่อมีเฟรม Broadcast (เช่น ARP Request หรือ DHCP Discover) ส่งเข้ามา สวิตช์จะส่งกระจายออกทุกพอร์ต (Flooding) วนกลับมาหาตัวมันเอง และส่งกระจายซ้ำทวีคูณเป็นล้านๆ เฟรมต่อวินาที!
- อาการนี้เรียกว่า **Broadcast Storm (พายุบรอดคาสต์)**:
  - ไฟสถานะทุกพอร์ตบนสวิตช์จะ **กะพริบถี่พร้อมกันจนเกือบเป็นไฟค้าง**
  - CPU สวิตช์พุ่งแตะ 100% จนหยุดตอบสนอง
  - ระบบเครือข่ายของทั้งออฟฟิศหรือ Data Center จะล่มสนิททันที

![แผนภาพการเกิด Switching Loop และการป้องกันด้วย Spanning Tree Protocol](/images/network/stp-loop-broadcast-storm.png)

### ฮีโร่ผู้พิทักษ์: Spanning Tree Protocol (STP / RSTP - 802.1w)
STP ทำหน้าที่ตรวจจับ Loop ในสวิตช์ โดยจะส่งแพ็กเก็ตพิเศษที่ชื่อว่า **BPDU (Bridge Protocol Data Unit)**:
- หากพบว่ามีเส้นทางสำรองที่ทำให้เกิด Loop สวิตช์จะสั่งให้พอร์ตหนึ่งเข้าสู่สถานะ **Blocking (หรือ Discarding)** เพื่อตัดวงจรไม่ให้เกิด Loop
- หากสายเส้นหลักขาด STP จะปลดบล็อกพอร์ตสำรองกลับมาเป็น **Forwarding** อัตโนมัติ (RSTP ใช้เวลาเพียง 1-2 วินาที)

#### ฟีเจอร์ความปลอดภัย STP ที่ต้องรู้จัก:
- **PortFast**: เปิดใช้กับพอร์ตที่ต่อเครื่องลูกข่าย/เซิร์ฟเวอร์เท่านั้น เพื่อให้พอร์ตเปลี่ยนเป็น Forwarding ทันทีโดยไม่ต้องรอตรวจ STP 30 วินาที
- **BPDU Guard**: หากเปิด PortFast ต้องเปิด BPDU Guard ควบคู่เสมอ หากมีใครแอบเอาสวิตช์ตัวอื่นมาเสียบเข้าพอร์ตนี้ พอร์ตจะสั่งตัดไฟและเข้าสู่สถานะ `err-disabled` ทันทีเพื่อป้องกัน Loop!

```text
! คอนฟิก PortFast และ BPDU Guard บนพอร์ตที่ต่อเซิร์ฟเวอร์
Switch(config-if)# spanning-tree portfast
Switch(config-if)# spanning-tree bpduguard enable
```

---

## 4. รวมสายเพิ่มความเร็วและป้องกัน Loop ด้วย LACP (Link Aggregation)

หากเราต้องการต่อสาย 2 หรือ 4 เส้นระหว่าง Server กับ Switch เพื่อเพิ่ม Bandwidth จาก 1Gbps เป็น 2Gbps หรือทำ Redundancy สำรองสาย หากเสียบสายตรงๆ STP จะบล็อกสายเส้นที่สองทิ้ง!

**ทางแก้**: ต้องรวมพอร์ตทางกายภาพหลายพอร์ต ให้ทำหน้าที่เสมือนเป็นพอร์ตตรรกะพอร์ตเดียว เรียกว่า **Port-Channel (หรือ NIC Teaming / Bonding)** โดยใช้โปรโตคอลมาตรฐาน **LACP (Link Aggregation Control Protocol - IEEE 802.3ad)**

```text
! รวมพอร์ต Gi0/1 และ Gi0/2 เข้าสู่ Port-Channel 1 ด้วย LACP
Switch(config)# interface range GigabitEthernet0/1 - 2
Switch(config-if-range)# channel-group 1 mode active
Switch(config-if-range)# exit

! ตรวจสอบสถานะการรวมสาย LACP
Switch# show etherchannel summary
Group  Port-channel  Protocol    Ports
------+-------------+-----------+-----------------------------------------------
1      Po1(SU)         LACP      Gi0/1(P)    Gi0/2(P)
```
- **`SU`**: **S**witch, **U**p in use (ทำงานสมบูรณ์)
- **`P`**: Bundled in **P**ort-channel (พอร์ตรวมสายสำเร็จ)
- หากขึ้นสถานะ **`D` (Down)** หรือ **`I` (Individual)** แสดงว่าการตั้งค่าของพอร์ตทั้งสองฝั่งไม่ตรงกัน (เช่น Speed, Duplex, หรือ VLAN ต่างกัน)
', 11, 'intermediate', 9, true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.lessons VALUES ('7c93ea29-3948-44d5-a0bb-77f87d3fedcd', 2, 'network-packet-capture-tcpdump', 'การดักจับและวิเคราะห์แพ็กเก็ตด้วย tcpdump และ Wireshark (Packet Capture & Analysis)', 'ธงสำคัญของ tcpdump, การกรองตาม Host, Port, Interface, การจับ TCP Flags (SYN, ACK, RST, FIN), การเซฟไฟล์ .pcap และวิธีเปิดวิเคราะห์ TCP Handshake ใน Wireshark', '
# การดักจับและวิเคราะห์แพ็กเก็ตด้วย tcpdump และ Wireshark

เมื่อคุณไล่ตรวจสอบตามขั้นตอนปกติ (`ping`, `curl`, `ss`, firewall) แล้วยังไม่ทราบสาเหตุ หรือมีข้อโต้แย้งระหว่างทีม (เช่น ทีม Developer บอกว่าเซิร์ฟเวอร์ฐานข้อมูลไม่ตอบ แต่ทีม Database บอกว่าไม่เคยได้รับคำขอเข้ามาเลย) เครื่องมือขั้นสูงสุดที่จะนำความจริงมาตัดสินคือ **การดักจับแพ็กเก็ต (Packet Capture)** เพราะ *"แพ็กเก็ตไม่เคยโกหก (Packets Never Lie)"*

---

## 1. คำสั่ง tcpdump พื้นฐานและ Flags สำคัญ

บนเซิร์ฟเวอร์ Linux ที่ไม่มีหน้าจอ GUI เครื่องมือหลักในการดักจับแพ็กเก็ตคือ **`tcpdump`**:

```bash
# รูปแบบคำสั่งทั่วไป
sudo tcpdump [flags] [filter_expression]
```

### ตารางธงสำคัญ (Essential Flags) ที่ต้องจำ:

| Flag | ความหมาย | ประโยชน์ในการใช้งาน |
|---|---|---|
| **`-i <interface>`** | ระบุ Interface ที่ต้องการดักฟัง | เช่น `-i eth0` หรือ `-i any` (ดักฟังทุกการ์ดแลนในเครื่อง) |
| **`-n`** | **ไม่แปลง IP เป็นชื่อ Hostname** | **สำคัญมาก!** ป้องกันไม่ให้ tcpdump เสียเวลายิงถาม DNS ซึ่งทำให้ผลลัพธ์ช้าและลวงตา |
| **`-nn`** | **ไม่แปลงทั้ง IP และไม่แปลง Port** | แสดงพอร์ตเป็นตัวเลขดิบ เช่น แสดง `80` แทน `http`, แสดง `443` แทน `https` |
| **`-v` / `-vv`** | แสดงรายละเอียดแบบละเอียดยิ่งขึ้น (Verbose) | แสดงค่า TTL, IP ID, และความยาวข้อมูล |
| **`-c <count>`** | กำหนดจำนวนแพ็กเก็ตแล้วหยุดอัตโนมัติ | เช่น `-c 10` ดักจับแค่ 10 แพ็กเก็ตแล้วตัดจบ ป้องกันข้อมูลล้นหน้าจอ |
| **`-w <file.pcap>`** | **บันทึกข้อมูลดิบลงไฟล์ .pcap** | เพื่อดาวน์โหลดไปเปิดดูด้วย Wireshark แบบกราฟิกบนเครื่องส่วนตัว |
| **`-r <file.pcap>`** | อ่านไฟล์ .pcap ย้อนหลัง | ใช้อ่านไฟล์ที่เคยดักจับไว้ |
| **`-X` / `-XX`** | แสดงเนื้อหาข้อมูล Payload เป็น Hex และ ASCII | ใช้แอบดูข้อความที่ส่งมา (เช่น HTTP หรือ SQL Query) |

---

## 2. สูตรการกรองแพ็กเก็ตยอดนิยมในงานจริง (Capture Filters)

หากรัน `tcpdump` ดิบๆ คุณจะถูกถล่มด้วยแพ็กเก็ตเซสชัน SSH ของตัวคุณเองจนหน้าจอเลื่อนค้าง! คุณจึงต้องใส่ Filter เสมอ:

```bash
# 1. กรองเฉพาะพอร์ตที่สนใจ (เช่น พอร์ตฐานข้อมูล 5432 หรือ 3306)
sudo tcpdump -nn -i eth0 port 5432

# 2. กรองเฉพาะการสื่อสารกับ IP เครื่องเป้าหมาย (Host filter)
sudo tcpdump -nn -i eth0 host 10.0.1.50

# 3. ตัดทราฟฟิก SSH ของตนเองทิ้ง และดูเฉพาะไอพีปลายทาง
sudo tcpdump -nn -i eth0 host 10.0.1.50 and not port 22

# 4. ดักจับเฉพาะการเรียกดูเว็บ HTTP/HTTPS จาก Subnet ที่ระบุ
sudo tcpdump -nn -i eth0 net 192.168.10.0/24 and \(port 80 or port 443\)

# 5. ดักจับแพ็กเก็ต ICMP (Ping) เพื่อดูว่าเครื่องได้รับ Request และส่ง Reply หรือไม่
sudo tcpdump -nn -i eth0 icmp
```

---

## 3. ถอดรหัส TCP Flags ในผลลัพธ์ tcpdump

เมื่อดูผลลัพธ์ของ TCP คุณจะเห็นตัวย่อสถานะ Flag ในเครื่องหมายก้ามปู `[...]`:

```text
10:15:30.123456 IP 192.168.1.10.51234 > 10.0.1.50.80: Flags [S], seq 123456789, win 64240, length 0
10:15:30.124567 IP 10.0.1.50.80 > 192.168.1.10.51234: Flags [S.], seq 987654321, ack 123456790, win 65160, length 0
10:15:30.124890 IP 192.168.1.10.51234 > 10.0.1.50.80: Flags [.], ack 987654322, win 64240, length 0
```

- **`[S]` (SYN)**: ร้องขอเปิดการเชื่อมต่อ (สเต็ป 1 ของ 3-way handshake)
- **`[S.]` (SYN-ACK)**: ปลายทางตอบรับและขอจับมือกลับ (สเต็ป 2)
- **`[.]` (ACK)**: ยืนยันการจับมือสำเร็จ (สเต็ป 3 ➔ เชื่อมต่อ ESTABLISHED พร้อมส่งข้อมูล)
- **`[P]` (PUSH)**: มีการส่งข้อมูลแอปพลิเคชันจริง
- **`[F]` (FIN)**: ร้องขอปิดการเชื่อมต่อแบบสุภาพ (Graceful Shutdown)
- **`[R]` (RST / Reset)**: **ตัดการเชื่อมต่อทันที (Connection Refused)** หรือปฏิเสธการคุย

> **Support Insight**: หากคุณเห็น `Flags [S]` ส่งออกไปซ้ำๆ แต่ไม่มี `[S.]` ตอบกลับมาเลย แสดงว่า **ติด Firewall หรือเครื่องปลายทางล่ม** แต่ถ้าเห็น `Flags [R]` สวนกลับมาทันที แสดงว่า **เครื่องปลายทางยังมีชีวิตอยู่ แต่พอร์ตนั้นไม่มี Service มารองรับ (Connection Refused)**

---

## 4. วิเคราะห์ไฟล์ PCAP ด้วย Wireshark

เพื่อความสะดวกในการวิเคราะห์ ให้ดักจับข้อมูลเป็นไฟล์ `.pcap` แล้วดาวน์โหลดมาเปิดบน Wireshark:

```bash
# สั่งดักจับ 100 แพ็กเก็ตที่พอร์ต 443 เซฟลงไฟล์ incident.pcap
sudo tcpdump -nn -i eth0 port 443 -c 100 -w /tmp/incident.pcap

# ดาวน์โหลดออกมาที่เครื่องด้วย scp
scp user@server:/tmp/incident.pcap ./incident.pcap
```

![หน้าจอโปรแกรม Wireshark แสดงการวิเคราะห์ TCP Handshake และแพ็กเก็ต](/images/network/wireshark-tcp-handshake.png)

### ฟิลเตอร์เด็ดใน Wireshark (Display Filters):
- `ip.addr == 10.0.1.50` ➔ ดึงเฉพาะทราฟฟิกของ IP นี้
- `tcp.port == 80 || tcp.port == 443` ➔ กรองเฉพาะทราฟฟิกเว็บ
- `tcp.flags.reset == 1` ➔ **หาแพ็กเก็ตที่ถูกตัดสายทิ้ง (Connection RST)** เพื่อชี้ชัดจุดที่มีปัญหา
- `dns.flags.response == 1 && dns.rcode != 0` ➔ หาปัญหา DNS Error เช่น NXDOMAIN
- **คลิกขวาที่แพ็กเก็ต ➔ Follow ➔ TCP Stream**: Wireshark จะแกะข้อความสนทนาทั้งหมดตั้งแต่ต้นจนจบออกมาให้อ่านเป็นภาษาคนได้อย่างง่ายดาย

---

## 5. ตารางสรุปการจับผิดด้วย Packet Capture

| สิ่งที่เห็นใน tcpdump / Wireshark | การวินิจฉัยเชิงลึก |
|---|---|
| ส่ง `SYN` ออกไปหลายครั้ง มีระยะห่างเพิ่มขึ้น (Retransmission) ไม่มีใครตอบ | ติด Firewall กรองแพ็กเก็ตทิ้ง (Drop) หรือ Default Gateway ชี้ทางผิด |
| ส่ง `SYN` แล้วได้รับ `RST, ACK` กลับมาทันควัน | เครือข่ายปกติ 100% แต่พอร์ตปลายทางไม่มีโปรแกรมรันอยู่ (Service Down) |
| ส่ง `SYN` ได้รับ `SYN-ACK` ส่ง `ACK` กลับ แต่หลังจากส่งข้อมูลไม่มีการตอบกลับ | ปัญหา MTU ข้อมูลขนาดใหญ่ติดปัญหา Packet Fragmentation หรือติด WAF |
| ส่งคำขอ DNS Query แต่ไม่มี DNS Response กลับมา | DNS Server ไอพีผิด หรือพอร์ต UDP 53 ถูกปิดกั้น |
', 11, 'intermediate', 10, true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.lessons VALUES ('75403d93-f9e9-4644-9d96-62d933af29b7', 10, 'dc-storage-raid-smart', 'ระบบจัดเก็บข้อมูลเซิร์ฟเวอร์: RAID, Hot-Swap และ SMART Diagnostics (Storage, RAID & SMART)', 'เปรียบเทียบ RAID 0/1/5/6/10, การคำนวณความจุและจำนวนดิสก์ที่ทนเสียได้, การอ่านไฟสถานะ Hot-Swap Drive Bay, ความต่างของ HBA Mode vs RAID Mode และการตรวจสุขภาพดิสก์ด้วย smartctl', '# ระบบจัดเก็บข้อมูลเซิร์ฟเวอร์: RAID, Hot-Swap และ SMART Diagnostics

ในศูนย์ข้อมูล (Data Center) ชิ้นส่วนที่มีโอกาสเสื่อมสภาพและเสียบ่อยที่สุดในเซิร์ฟเวอร์คือ **ฮาร์ดดิสก์ (HDD/SSD)** เพราะมีการทำงานอ่าน-เขียนตลอด 24 ชั่วโมง ช่างเทคนิคประจำ Data Center จึงต้องเข้าใจหลักการของ **RAID**, วิธีสังเกตไฟหน้าช่องใส่ดิสก์เพื่อถอดเปลี่ยนแบบ **Hot-Swap** โดยไม่ถอดผิดลูก และการใช้คำสั่งตรวจสอบสุขภาพดิสก์

---

## 1. ทำความเข้าใจระดับของ RAID (RAID Levels Comparison)

**RAID (Redundant Array of Independent Disks)** คือการนำดิสก์หลายลูกมารวมกันเป็น Logical Drive เดียว เพื่อเพิ่มความเร็ว (Performance) หรือเพิ่มความทนทานต่อการสูญเสียข้อมูล (Fault Tolerance):

![แผนภาพเปรียบเทียบการเรียงข้อมูลและความทนทานของ RAID 0, 1, 5, 6 และ 10](/images/datacenter/raid-levels-comparison.png)

| ระดับ RAID | กลไกการทำงาน | จำนวนดิสก์ขั้นต่ำ | ความจุที่ใช้งานได้จริง (Usable Capacity) | ทนดิสก์เสียพร้อมกันได้สูงสุด | งานที่เหมาะสมใน Data Center |
|---|---|---|---|---|---|
| **RAID 0** | **Striping** (แบ่งกระจายข้อมูล) | 2 ลูก | **100%** ($N$ ลูก) | **0 ลูก (ห้ามเสียแม้แต่ลูกเดียว!)** | Scratch Disk, แคชชั่วคราวที่ต้องการความเร็วสูงสุดและข้อมูลหายได้ |
| **RAID 1** | **Mirroring** (สำเนาข้อมูลเหมือนกัน 2 ชุด) | 2 ลูก | **50%** ($N / 2$) | **1 ลูก** | ดิสก์สำหรับติดตั้งระบบปฏิบัติการ (OS Boot Drive) ของเซิร์ฟเวอร์ |
| **RAID 5** | **Striping + Single Parity** | 3 ลูก | **$N - 1$ ลูก** | **1 ลูก** | ระบบจัดเก็บไฟล์ทั่วไป (ไม่แนะนำสำหรับดิสก์ความจุสูงเกิน 8TB เพราะใช้เวลา Rebuild นาน) |
| **RAID 6** | **Striping + Dual Parity** | 4 ลูก | **$N - 2$ ลูก** | **2 ลูกพร้อมกัน** | File Server, Backup Storage หรือคลังข้อมูลขนาดใหญ่ |
| **RAID 10 (1+0)** | **Mirror ก่อน แล้วนำมา Stripe** | 4 ลูก (เลขคู่) | **50%** ($N / 2$) | **1 ลูกในแต่ละคู่ Mirror** (สูงสุดครึ่งหนึ่งหากเสียคนละกลุ่ม) | **Database Server (MySQL, PostgreSQL)** ที่ต้องการทั้งความเร็วเขียนสูงและความปลอดภัยสูงสุด |

> **ตัวอย่างการคำนวณความจุ (ออกสอบสัมภาษณ์บ่อยมาก!)**:  
> หากมีดิสก์ขนาดลูกละ **4 TB จำนวน 6 ลูก**:
> - ทำ **RAID 5** จะได้พื้นที่ใช้งานจริง = $(6 - 1) \times 4\text{ TB} = \mathbf{20\text{ TB}}$ (ทนเสียได้ 1 ลูก)
> - ทำ **RAID 6** จะได้พื้นที่ใช้งานจริง = $(6 - 2) \times 4\text{ TB} = \mathbf{16\text{ TB}}$ (ทนเสียได้ 2 ลูก)
> - ทำ **RAID 10** จะได้พื้นที่ใช้งานจริง = $(6 / 2) \times 4\text{ TB} = \mathbf{12\text{ TB}}$ (เร็วและปลอดภัยสูงสุด)

---

## 2. การอ่านไฟสถานะหน้าช่องดิสก์ และการเปลี่ยนแบบ Hot-Swap

เซิร์ฟเวอร์ระดับองค์กรรองรับการถอดเปลี่ยนดิสก์ที่เสียและเสียบลูกใหม่เข้าไปแทนที่ **โดยไม่ต้องปิดเครื่อง (Hot-Swap)** แต่กฎเหล็กคือ **ห้ามดึงดิสก์ผิดลูกเด็ดขาด!** เพราะถ้าดึงลูกที่ยังดีออกมาในขณะที่ RAID กำลัง处于สถานะ **Degraded** ข้อมูลทั้งโวลุ่มจะพังทลายทันที!

![ภาพช่องใส่ดิสก์ Hot-Swap Drive Bay และความหมายของไฟสถานะ LED](/images/datacenter/server-drive-bay-led.png)

### ความหมายของไฟ LED บนถาดดิสก์ (Drive Caddy):
1. **ไฟสีเขียวติดค้างหรือกะพริบ (Solid/Blinking Green)**: ดิสก์ทำงานปกติ (Online / Activity) **ห้ามถอด!**
2. **ไฟสีส้ม/อำพันติดค้าง หรือกะพริบ (Solid/Blinking Amber)**: ดิสก์ลูกนั้นเสีย (**Fault / Failed / Predictive Failure**) ต้องได้รับการเปลี่ยน
3. **ไฟสีเขียวสลับส้มกะพริบช้าๆ**: ดิสก์ลูกใหม่กำลังทำการสร้างข้อมูลกลับคืน (**Rebuilding**) ห้ามถอดหรือรีบูตเครื่องโดยไม่จำเป็นจนกว่าจะเสร็จ
4. **ไฟสีน้ำเงินกะพริบ (Blinking Blue - Locator LED)**: แอดมินสั่งเปิดไฟชี้เป้า (Blink / Locate Drive) จาก iDRAC/iLO เพื่อให้ช่างหน้างานรู้ว่าต้องดึงลูกไหนอย่างแม่นยำ

> **แนวปฏิบัติมาตรฐาน (SOP) ก่อนดึงดิสก์**:  
> ให้ตรวจสอบทั้ง **หมายเลข Slot (เช่น Bay 0, Bay 1)**, **Serial Number ของดิสก์ใน iDRAC/iLO** และสั่งเปิด **Locator LED สีน้ำเงิน** ยืนยันตรงกันทั้ง 3 อย่างก่อนกดสลักดึงดิสก์ออกเสมอ

---

## 3. การ์ดควบคุมดิสก์: RAID Mode vs HBA Mode (IT Mode / Passthrough)

ภายในเซิร์ฟเวอร์จะมีแผ่นการ์ดเชื่อมต่อดิสก์ (เช่น **Dell PERC** หรือ **HPE Smart Array**) ซึ่งตั้งโหมดการทำงานได้ 2 แบบ:

- **Hardware RAID Mode**: ตัวการ์ดเป็นคนรวมดิสก์และคำนวณ Parity เอง (มักมีแบตเตอรี่หรือคาปาซิเตอร์ **BBWC / FBWC** ช่วยจำข้อมูลใน Write Cache เวลาไฟดับ) ระบบปฏิบัติการจะมองเห็นเป็นดิสก์ก้อนเดียว (เช่น `/dev/sda`)
- **HBA Mode (Host Bus Adapter / IT Mode / Passthrough)**: ตัวการ์ดส่งดิสก์ทุกลูกแยกกันให้ระบบปฏิบัติการเห็นโดยตรง (เช่น `/dev/sda, /dev/sdb, /dev/sdc`) นิยมใช้กับระบบ **Software-Defined Storage เช่น ZFS, Ceph, VMware vSAN** ที่ต้องการจัดการดิสก์ด้วยตนเอง

---

## 4. คำสั่งตรวจสอบสถานะ RAID และสุขภาพดิสก์ด้วย SMART บน Linux

```bash
# 1. ดูรายการบล็อกดิสก์และพาร์ทิชันทั้งหมดในเครื่อง
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,MODEL

# 2. ตรวจสอบสถานะ Software RAID (mdadm) บน Linux
cat /proc/mdstat
# ตัวอย่างผลลัพธ์: [UU] = ดิสก์ 2 ลูกปกติครบ, [U_] = ดิสก์เสียไป 1 ลูก (Degraded!)

# 3. ตรวจสอบสุขภาพดิสก์เชิงลึกด้วย S.M.A.R.T. (smartmontools)
sudo smartctl -H /dev/sda
# ผลลัพธ์ปกติ: SMART overall-health self-assessment test result: PASSED

# 4. ดูค่าสถิติความเสื่อมของดิสก์ทั้งหมด (ดูค่า Reallocated_Sector_Ct และ Media_Wearout)
sudo smartctl -a /dev/sda | grep -E "Reallocated|Pending|Uncorrectable|Wear|Temperature"
```

### ค่า SMART อันตรายที่บ่งบอกว่าดิสก์กำลังจะพัง (Predictive Failure):
- **Reallocated_Sector_Ct > 0**: ดิสก์เริ่มมี Bad Sector และต้องย้ายข้อมูลไปใช้พื้นที่สำรอง
- **Current_Pending_Sector > 0**: มีเซกเตอร์ที่อ่านไม่ออก รอการซ่อมแซม
- **Media_Wearout_Indicator / Percentage Used**: ใน SSD หากเข้าใกล้ 100% แสดงว่าเซลล์หน่วยความจำใกล้หมดอายุขัยการเขียน (TBW)
', 11, 'intermediate', 5, true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.lessons VALUES ('c64810d8-bf76-49f4-aadd-3cd45d92d14b', 10, 'dc-hardware-troubleshooting-sel', 'การวินิจฉัยฮาร์ดแวร์เซิร์ฟเวอร์เสีย และอ่าน System Event Log (Hardware Troubleshooting & SEL)', 'การอ่านไฟเตือนหน้าเครื่องและรหัส POST Code, การแยกปัญหา ECC Memory (Single-bit vs Multi-bit Error) ด้วยเทคนิค Swap Test, ปัญหา PSU/Fan และการดึง System Event Log (SEL) ด้วย iDRAC/iLO และ ipmitool', '# การวินิจฉัยฮาร์ดแวร์เซิร์ฟเวอร์เสีย และอ่าน System Event Log (SEL)

เมื่อเซิร์ฟเวอร์เกิดอาการแฮงก์ รีบูตเองกลางดึก หรือเปิดไม่ติด สิ่งที่แยกช่างเทคนิคระดับมืออาชีพออกจากมือใหม่คือ **การอ่านหลักฐานทางฮาร์ดแวร์จาก System Event Log (SEL)** และการทำ **Component Isolation (แยกชิ้นส่วนทดสอบ)** อย่างเป็นระบบแทนการเดาสุ่ม

---

## 1. แผงไฟสถานะหน้าเครื่อง (Front Panel Health LEDs & LCD)

เมื่อเดินตรวจตู้แร็คในห้อง Data Hall (Visual Inspection) เซิร์ฟเวอร์ทุกยี่ห้อจะมีไฟแจ้งสถานะสุขภาพหลัก (System Health Indicator):

![ภาพแผงหน้าปัดไฟสถานะและจอ LCD แจ้งรหัสข้อผิดพลาดของเซิร์ฟเวอร์](/images/datacenter/server-post-led-codes.png)

- **Dell PowerEdge**:
  - **ไฟสีน้ำเงินนิ่ง**: เครื่องทำงานปกติ
  - **ไฟสีส้ม/อำพันกะพริบ (Blinking Amber)** พร้อมข้อความบนจอ LCD ด้านหน้า: มีชิ้นส่วนฮาร์ดแวร์เกิดข้อผิดพลาด เช่น `MEM0702: Correctable memory error rate exceeded for DIMM_A1` หรือ `PS0100: Power Supply 1 Status is off`
- **HPE ProLiant**:
  - **Health LED สีเขียว**: ปกติ
  - **Health LED สีส้มกะพริบ (Degraded)**: มีชิ้นส่วนสำรองเสียไป 1 จุด แต่เครื่องยังรันต่อได้ (เช่น พัดลมเสีย 1 ตัว หรือ PSU ดับ 1 ลูก)
  - **Health LED สีแดงกะพริบ (Critical)**: เกิดวิกฤตที่ทำให้ระบบหยุดทำงานหรือเปิดไม่ติด (เช่น อุณหภูมิเกินพิกัด หรือ RAM แถวหลักพัง)

---

## 2. เจาะลึกปัญหาหน่วยความจำ ECC Memory (CE vs UCE)

เซิร์ฟเวอร์ใช้แรมชนิดพิเศษที่เรียกว่า **ECC RAM (Error-Correcting Code)** ซึ่งสามารถตรวจจับและซ่อมแซมบิตข้อมูลที่เพี้ยนจากรังสีคอสมิกหรือสัญญาณแม่เหล็กไฟฟ้าได้ โดยความผิดพลาดแบ่งเป็น 2 ระดับที่ต้องแยกให้ขาด:

| ประเภทข้อผิดพลาด | ชื่อเต็ม | อาการและผลกระทบ | แนวทางปฏิบัติของช่าง Data Center |
|---|---|---|---|
| **CE** | **Correctable Error (Single-Bit Error)** | บิตข้อมูลเพี้ยน 1 บิต ชิป ECC **ซ่อมแซมให้อัตโนมัติ** เครื่องยังทำงานต่อได้โดยไม่ดับ แต่ถ้าเกิดซ้ำถี่ๆ ระบบจะบันทึกเตือนว่า `Correctable memory error logging disabled` | วางแผนขอ Maintenance Window เพื่อถอดทำความสะอาดหน้าสัมผัส หรือเคลมเปลี่ยนแถว RAM นั้นก่อนที่จะลามเป็น UCE |
| **UCE** | **Uncorrectable Error (Multi-Bit Error)** | บิตข้อมูลเพี้ยนพร้อมกันหลายบิตเกินขีดจำกัดที่ ECC จะซ่อมได้ **เครื่องเซิร์ฟเวอร์จะแฮงก์ (Kernel Panic / จอฟ้า / รีบูตทันที)** เพื่อป้องกันข้อมูลในฐานข้อมูลเสียหาย! | เป็นเหตุฉุกเฉิน (Critical) ต้องเปลี่ยนแถว RAM ที่มีปัญหาออกทันที |

### เทคนิคไม้ตาย: การสลับแถวทดสอบ (Memory Swap Test / Isolation)
เมื่อระบบแจ้งว่าเกิด Memory Error ที่ช่อง **`DIMM_A1`** เราจะรู้ได้อย่างไรว่า **"ตัวการ์ด RAM เสีย"** หรือ **"ช่องเสียบบน Mainboard (DIMM Slot) เสีย"**?

1. ปิดเครื่อง ถอดปลั๊กไฟ และสวมสายรัดข้อมือป้องกันไฟฟ้าสถิต (ESD Wrist Strap)
2. สลับนำ RAM จากช่องที่มีปัญหา (**`DIMM_A1`**) ไปเสียบที่ช่อง **`DIMM_B1`** (และนำของ `DIMM_B1` มาเสียบ `DIMM_A1` แทน)
3. เปิดเครื่องและรันทดสอบ หากข้อความ Error **ย้ายตามไปเกิดที่ช่อง `DIMM_B1`** ➔ ฟันธง 100% ว่า **ตัวการ์ด RAM แถวนั้นเสีย!** (ส่งเคลมเฉพาะตัว RAM)
4. แต่ถ้าข้อความ Error **ยังคงเกิดที่ช่อง `DIMM_A1` เหมือนเดิม** ➔ ฟันธงว่า **ช่องเสียบบน Mainboard หรือขา CPU Socket เสีย!** (ต้องเคลมเปลี่ยน Mainboard)

---

## 3. การอ่าน System Event Log (SEL) ผ่าน iDRAC/iLO และ ipmitool

**System Event Log (SEL)** คือบันทึกเหตุการณ์ระดับฮาร์ดแวร์ที่ถูกจัดเก็บไว้ในชิป **BMC (iDRAC/iLO)** แยกต่างหากจากฮาร์ดดิสก์ ต่อให้เครื่องเซิร์ฟเวอร์แฮงก์ ดิสก์พัง หรือบูตเข้า OS ไม่ได้ คุณก็ยังเปิดอ่าน SEL เพื่อดูสาเหตุการตายของเครื่องได้เสมอ!

![หน้าจอแสดงรายการ System Event Log (SEL) บนระบบจัดการระยะไกล](/images/datacenter/idrac-sel-log.png)

### การดึงข้อมูล SEL และเซนเซอร์ผ่าน CLI ด้วย `ipmitool`:

```bash
# 1. แสดงรายการบันทึกเหตุการณ์ฮาร์ดแวร์ทั้งหมด (System Event Log)
sudo ipmitool sel elist
# ตัวอย่างผลลัพธ์:
#  1 | 11/08/2026 | 02:14:10 | Power Supply #0x51 | Power Supply AC lost | Asserted
#  2 | 11/08/2026 | 03:45:22 | Memory #0x60 | Correctable ECC | Asserted
#  3 | 11/08/2026 | 03:45:25 | Temperature #0x30 | Upper Critical going high | Asserted

# 2. อ่านค่าเซนเซอร์ความร้อน ความเร็วรอบพัดลม (RPM) และแรงดันไฟแบบสดๆ (SDR)
sudo ipmitool sdr list
# ตัวอย่างผลลัพธ์:
# Inlet Temp       | 22 degrees C      | ok
#CPU1 Temp        | 68 degrees C      | ok
# Fan1 RPM         | 7200 RPM          | ok
# PS1 Status       | 0x01              | ok

# 3. ตรวจสอบข้อความแจ้งเตือนจาก Kernel ของ Linux เกี่ยวกับฮาร์ดแวร์ (EDAC / MCE)
sudo dmesg -T | grep -iE "edac|mce|hardware error|thermal"

# 4. ล้างประวัติ SEL หลังจากซ่อมแซมและบันทึกหลักฐานแนบ Ticket เรียบร้อยแล้ว
sudo ipmitool sel clear
```

---

## 4. ปัญหาพัดลม (Fan Failure) และระบบป้องกันความร้อน (Thermal Shutdown)

- เซิร์ฟเวอร์จะมีพัดลมเรียงกัน 6–8 ตัวแบบ **Redundant Hot-Swap**
- หากพัดลมเสียไป 1 ตัว ชิป BMC จะสั่งเร่งความเร็วพัดลมตัวที่เหลือทั้งหมดให้หมุนที่ **100% (เสียงดังสนั่นเหมือนเครื่องบินเจ็ต)** เพื่อชดเชยแรงลม
- หากพัดลมเสียหลายตัวพร้อมกันหรือฝุ่นอุดตันหน้าเครื่องจนอุณหภูมิ CPU ทะลุจุดวิกฤต (มักประมาณ 95–100°C) ระบบจะลดความเร็วสัญญาณนาฬิกา (**Thermal Throttling**) และหากยังร้อนขึ้นอีก BMC จะสั่งตัดไฟปิดเครื่องอัตโนมัติ (**Thermal Shutdown**) เพื่อป้องกันชิป CPU ไหม้
', 11, 'intermediate', 6, true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.lessons VALUES ('a20fa558-7295-4a2a-bbf2-0700729e95e9', 10, 'dc-os-install-firmware', 'การติดตั้ง OS ระยะไกล และการอัปเดต Firmware เซิร์ฟเวอร์อย่างปลอดภัย (OS Provisioning & Firmware Lifecycle)', 'การติดตั้ง OS ผ่าน Virtual Media บน iDRAC/iLO, ระบบอัตโนมัติ PXE + Kickstart/Preseed/Cloud-Init, ลำดับการอัปเดต Firmware (BMC -> BIOS -> NIC/RAID) และแผนป้องกันเครื่อง Brick', '# การติดตั้ง OS ระยะไกล และการอัปเดต Firmware เซิร์ฟเวอร์อย่างปลอดภัย

ในอดีตการลงระบบปฏิบัติการ (OS) หรืออัปเดต BIOS ต้องถือแฟลชไดรฟ์และเข็นรถจอภาพ (Crash Cart) เข้าไปเสียบหน้าตู้แร็คในห้องเซิร์ฟเวอร์ที่หนาวและเสียงดัง แต่ในงาน Data Center ยุคใหม่ กว่า 99% ดำเนินการจากระยะไกลผ่าน **Virtual Media** หรือระบบอัตโนมัติ **Unattended Provisioning**

---

## 1. การติดตั้ง OS ผ่าน Virtual Media (iDRAC / iLO HTML5 Console)

เมื่อต้องติดตั้ง OS ให้เซิร์ฟเวอร์จำนวน 1–5 เครื่อง วิธีที่สะดวกที่สุดคือฟีเจอร์ **Virtual Media**:

1. เปิดเบราว์เซอร์ล็อกอินเข้าหน้าเว็บ **iDRAC (Dell)** หรือ **iLO (HPE)** ผ่านเครือข่าย OOB
2. เปิดหน้าต่าง **Virtual Console (HTML5)**
3. คลิกเมนู **Virtual Media ➔ Connect Virtual Media ➔ Map CD/DVD**
4. เลือกไฟล์อิมเมจ `.iso` (เช่น `Ubuntu-24.04-live-server.iso` หรือ `VMware-ESXi.iso`) จากเครื่องคอมพิวเตอร์ของคุณ หรือชี้ไปยัง HTTP/NFS Share ภายในเครือข่าย
5. คลิกเมนู **Next Boot ➔ Virtual CD/DVD/ISO** แล้วสั่ง **Power Cycle / Reset** เครื่องเซิร์ฟเวอร์
6. เซิร์ฟเวอร์จะมองเห็นไฟล์ ISO นั้นเสมือนว่ามีแผ่นดีวีดีเสียบอยู่หน้าเครื่องจริงๆ และบูตเข้าหน้าติดตั้งทันที!

> **Support Tip**: การ Map ไฟล์ ISO ขนาดใหญ่ (4–8 GB) จากแล็ปท็อปของคุณผ่าน VPN อาจทำให้การติดตั้งช้ามาก แนะนำให้วางไฟล์ ISO ไว้บน **Jump Host หรือ HTTP/Samba Server ที่อยู่ในวง OOB ของ Data Center** แล้วทำการ Mount จากที่นั่น จะติดตั้งเสร็จภายในไม่กี่นาที

---

## 2. การติดตั้งอัตโนมัติจำนวนมาก: PXE + Kickstart / Preseed / Cloud-Init

หากบริษัทสั่งซื้อเซิร์ฟเวอร์เข้ามาใหม่พร้อมกัน 50 เครื่อง การคลิก Next ทีละเครื่องย่อมไม่ทันการณ์และเสี่ยงตั้งค่าผิดพลาด จึงต้องใช้ระบบ **Unattended Installation (ติดตั้งแบบไร้คนเฝ้า)**:

![แผนภาพขั้นตอนการติดตั้งระบบปฏิบัติการอัตโนมัติด้วย PXE Boot และไฟล์คำตอบ Kickstart](/images/datacenter/kickstart-pxe-install-flow.png)

- **RHEL / Rocky Linux / AlmaLinux**: ใช้ไฟล์คำตอบที่เรียกว่า **Kickstart (`ks.cfg`)**
- **Debian / Ubuntu (รุ่นเก่า)**: ใช้ไฟล์ **Preseed (`preseed.cfg`)**
- **Ubuntu Server ยุคใหม่ (20.04+) & Cloud Images**: ใช้ระบบ **Autoinstall (`user-data` ในรูปแบบ YAML ของ Cloud-Init)**
- **Windows Server**: ใช้ **WDS (Windows Deployment Services)** คู่กับไฟล์ **`Unattend.xml`**

### สิ่งที่กำหนดไว้ในไฟล์ Answer File (เช่น `ks.cfg` หรือ `user-data`):
- ภาษา, Timezone (`Asia/Bangkok`), และ NTP Server
- การแบ่งพาร์ทิชันดิสก์และ LVM อัตโนมัติ
- การสร้าง User, รหัสผ่านที่เข้ารหัสแล้ว, และการฝัง **SSH Public Key** ของทีมแอดมิน
- สคริปต์หลังติดตั้งเสร็จ (`%post` script) เช่น สั่งลง Monitoring Agent และตั้งค่า IP อัตโนมัติ

---

## 3. การอัปเดต Firmware เซิร์ฟเวอร์อย่างปลอดภัย (Firmware Lifecycle)

เซิร์ฟเวอร์หนึ่งเครื่องไม่ได้มีแค่ BIOS แต่มีไมโครคอนโทรลเลอร์แยกอยู่ในทุกชิ้นส่วน การอัปเดต Firmware ช่วยแก้บั๊กฮาร์ดแวร์ อุดช่องโหว่ความปลอดภัย และเพิ่มความเสถียร

### ลำดับการอัปเดต Firmware ที่แนะนำ (Recommended Order):
1. **BMC Firmware (iDRAC / iLO)** ➔ อัปเดตเป็นอันดับแรก! (ข้อดี: การอัปเดต iDRAC/iLO เพียงอย่างเดียว **สามารถรีบูตเฉพาะชิป BMC ได้โดยที่ระบบปฏิบัติการหลักของเซิร์ฟเวอร์ไม่ต้องรีบูตและไม่เกิด Downtime!**)
2. **System BIOS / UEFI** ➔ ต้องรีบูตเครื่องเซิร์ฟเวอร์จริงเพื่อเขียนรหัสใหม่ตอน POST
3. **RAID Controller / HBA & Backplane Firmware** ➔ ป้องกันดิสก์หลุดหรือค้าง
4. **Network Card (NIC) & Fiber HBA Firmware** ➔ แก้ปัญหาพอร์ต Flapping หรือเข้ากันไม่ได้กับ Switch
5. **Drive Firmware (HDD / NVMe SSD)** ➔ แก้บั๊กของคอนโทรลเลอร์ในตัวดิสก์

---

## 4. กฎเหล็กความปลอดภัย: ป้องกันเซิร์ฟเวอร์กลายเป็นที่ทับกระดาษ (Bricking Prevention)

1. **ห้ามถอดปลั๊กไฟหรือสั่ง Force Reset ขณะกำลัง Flash BIOS เด็ดขาด!**: หากไฟดับกลางคันขณะที่ชิป ROM กำลังเขียนทับ เครื่องจะเปิดไม่ติดอีกเลย (Bricked) ต้องมั่นใจว่าเครื่องต่อไฟผ่าน UPS ทั้งสองฝั่ง (Dual PSU A/B Feed)
2. **อย่าข้ามรุ่นไกลเกินไป (Stepping Stone Upgrades)**: หาก Firmware ปัจจุบันเก่ามาก (เช่น ห่างกัน 4 ปี) ให้อ่าน **Release Notes** เสมอ บางรุ่นบังคับว่าต้องอัปเดตเป็นเวอร์ชันกลางก่อน จึงจะกระโดดไปเวอร์ชันล่าสุดได้
3. **รู้จักกลไกกู้คืนเมื่อ BIOS พัง (BIOS Recovery)**:
   - เซิร์ฟเวอร์ระดับองค์กรสมัยใหม่มี **Dual BIOS / Redundant ROM (Primary & Backup Bank)**
   - หากอัปเดตแล้วบูตไม่ขึ้น สามารถเข้าไปสั่งสลับกลับไปบูตจาก **Backup ROM** ผ่านหน้าเว็บ iDRAC/iLO หรือสลับพิน **System Maintenance Switch / Recovery Jumper** บนเมนบอร์ดเพื่อกู้ชีพเครื่องกลับมาได้
', 10, 'intermediate', 7, true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.lessons VALUES ('f18ea418-7710-44cb-b1b9-4a5724a2a92b', 1, 'linux-process-service', 'การจัดการ Process และ systemd Service (ps, top, kill, systemctl, journalctl)', 'วิธีตรวจสอบสถานะโปรเซสและบริการ systemd การแยกแยะ SIGTERM กับ SIGKILL และขั้นตอนวิเคราะห์เมื่อ Service ล่ม (failed)', '
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
Nov 03 14:20:11 app-prod-01 systemd[1]: order-api.service: Failed with result ''exit-code''.

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
', 10, 'intermediate', 5, true, '2026-11-03 10:24:40.983748+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.lessons VALUES ('14d01b82-65c5-4700-b72d-d0b9e1d84c75', 10, 'dc-structured-cabling-dcim', 'มาตรฐานการเดินสายสัญญาณ, ป้ายกำกับ และการจัดการสินทรัพย์ DCIM (Structured Cabling, Labeling & DCIM)', 'สถาปัตยกรรมสาย ToR vs EoR, การเชื่อมโยง Patch Panel และ Cross-Connect, มาตรฐานการติด Label สายสัญญาณ, เหตุผลที่ใช้ตีนตุ๊กแกแทนเคเบิลไทร์, การอ่านค่าแสง DOM/DDM และการบริหารคลังด้วย DCIM', '# มาตรฐานการเดินสายสัญญาณ, ป้ายกำกับ และการจัดการสินทรัพย์ DCIM

ในห้อง Data Hall ที่มีตู้แร็คนับร้อยตู้และสายสัญญาณหลายหมื่นเส้น หากเดินสายไร้ระเบียบและไม่มีป้ายกำกับ (Label) ตู้แร็คจะกลายเป็น *"ม่านเส้นก๋วยเตี๋ยว (Spaghetti Cabling)"* ซึ่งขวางทางระบายความร้อนและทำให้การซ่อมบำรุงแทบเป็นไปไม่ได้ มาตรฐาน **Structured Cabling** และระบบ **DCIM** จึงเป็นหัวใจของการทำงานในศูนย์ข้อมูลระดับสากล

---

## 1. สถาปัตยกรรมการวางสวิตช์และเดินสาย: ToR vs EoR

การเชื่อมต่อสายจากเซิร์ฟเวอร์ไปยังสวิตช์ใน Data Center แบ่งออกเป็น 2 รูปแบบหลัก:

| รูปแบบ | ชื่อเต็ม | ลักษณะการติดตั้ง | ข้อดีและข้อสังเกต |
|---|---|---|---|
| **ToR** | **Top-of-Rack** | ติดตั้งสวิตช์ไว้บนสุดของตู้แร็คทุกตู้ เซิร์ฟเวอร์ในตู้เสียบสายสั้นๆ (1–3 เมตร) ขึ้นไปหาสวิตช์บนหัวตู้ตัวเอง แล้วลากสายไฟเบอร์ Uplink เพียงไม่กี่เส้นไปหา Core/Spine Switch | **นิยมที่สุดในยุคปัจจุบัน!** ใช้สายสั้น จัดระเบียบง่าย เพิ่มขยายตู้แร็คใหม่ได้เร็ว แต่ต้องดูแลจำนวนสวิตช์มากขึ้นตามจำนวนตู้ |
| **EoR / MoR** | **End-of-Row / Middle-of-Row** | ไม่มีสวิตช์ประจำตู้ แต่ลากสายจากทุกตู้ไปรวมที่ตู้สวิตช์ขนาดใหญ่ (Chassis Switch) ที่ตั้งอยู่หัวแถวหรือกลางแถว โดยผ่านแผง **Patch Panel** | บริหารจัดการสวิตช์น้อยตัวลง แต่ต้องเดินสายยาวและมีสายจำนวนมากบนรางเหนือตู้ (Overhead Cable Tray) |

---

## 2. การใช้ Patch Panel และ Cross-Connect ใน Colocation

ในศูนย์ข้อมูลแบบ **Colocation (เช่น Equinix, NTT, STT GDC)** ห้ามลากสายยาวจากเซิร์ฟเวอร์ในตู้ของลูกค้า A วิ่งทะลุห้องไปเสียบเข้าตู้ของลูกค้า B หรือตู้ผู้ให้บริการอินเทอร์เน็ต (ISP) โดยตรง!

![แผนภาพการเชื่อมต่อสายสัญญาณผ่าน Patch Panel และห้องชุมสาย Meet-Me Room](/images/datacenter/patch-panel-cross-connect.png)

- ทุกการเชื่อมต่อข้ามตู้หรือเชื่อมกับผู้ให้บริการเครือข่าย ต้องผ่านแผงกระจายสาย (**Patch Panel**) และไปบรรจบกันที่ห้องชุมสายกลางที่เรียกว่า **MMR (Meet-Me Room)**
- สายที่เชื่อมระหว่างโครงข่ายในห้อง MMR เรียกว่า **Cross-Connect (XC)**
- **ข้อดี**: เวลาต้องย้ายพอร์ตหรือเปลี่ยนสาย ช่างเพียงแค่สลับสาย Patch Cord เส้นสั้นๆ ที่หน้าแผง Patch Panel โดยไม่ต้องรื้อสายหลักที่เดินไว้ใต้พื้นหรือบนราง

---

## 3. กฎเหล็กการจัดระเบียบสายและติดป้ายกำกับ (Labeling & Cable Management)

![ตัวอย่างมาตรฐานการติดป้ายกำกับสายสัญญาณทั้งสองปลายและการรัดสายด้วยตีนตุ๊กแก](/images/datacenter/cable-labeling-standard.png)

### 1) มาตรฐานการติด Label สองฝั่ง (Dual-End Labeling)
สายทุกเส้นในตู้แร็ค **ต้องมีป้าย Label ติดที่ปลายสายทั้ง 2 ฝั่งเสมอ** โดยระบุทั้ง **"ต้นทาง (A-End)"** และ **"ปลายทาง (Z-End)"** ในป้ายเดียวกัน:
```text
รูปแบบมาตรฐาน: <Rack>-<RU>-<Device>-<Port>  <--->  <Rack>-<RU>-<Device>-<Port>
ตัวอย่างบนป้าย: R04-U42-SW01-Gi1/0/5  <--->  R04-U15-SRV08-eno1
```
- ประโยชน์: เมื่อคุณจับดูสายที่หลังเครื่องเซิร์ฟเวอร์ คุณจะทราบทันทีว่าปลายอีกฝั่งเสียบอยู่ที่พอร์ตไหนของสวิตช์ตัวใด โดยไม่ต้องออกแรงดึงไล่สาย!

### 2) ทำไมห้ามใช้สายรัดพลาสติก (Zip Tie) แต่ต้องใช้ตีนตุ๊กแก (Velcro Strap)?
- **ห้ามใช้เคเบิลไทร์พลาสติก (Plastic Zip Tie)**: เพราะการดึงรัดแน่นเกินไปจะบีบฉนวนสายทองแดงจนเกลียวคู่ภายในเสียรูป (เกิด Crosstalk) หรือบีบสายไฟเบอร์ออปติกจนเกิด **Micro-bending** ทำให้แสงรั่วไหล และเวลาต้องเพิ่มสายใหม่จะต้องใช้คีมตัดซึ่งเสี่ยงตัดโดนสายข้างเคียงขาด!
- **ต้องใช้สายรัดตีนตุ๊กแก (Velcro / Hook-and-Loop Strap)**: กระจายแรงรัดนุ่มนวล ไม่บีบสายไฟเบอร์ และสามารถแกะออกเพื่อเพิ่มหรือถอดสายซ่อมบำรุงได้ซ้ำตลอดอายุการใช้งาน

---

## 4. การตรวจวัดระดับแสงไฟเบอร์ด้วย DOM / DDM (Optical Power Monitoring)

หัว Transceiver สมัยใหม่มีฟีเจอร์ **DOM (Digital Optical Monitoring)** หรือ **DDM** ที่ช่วยวัดความเข้มแสงขาออก (**Tx Power**) และความเข้มแสงขาเข้า (**Rx Power**) เป็นหน่วย **dBm** ได้แบบเรียลไทม์ผ่าน CLI ของสวิตช์:

```text
Switch# show interfaces TenGigabitEthernet1/0/1 transceiver
ITU Channel not available (Wavelength not available),
Transceiver is internally calibrated.
mA: milliamperes, dBm: decibels (milliwatts), NA or N/A: not applicable.
++ : high alarm, +  : high warning, -  : low warning, -- : low alarm.
------------------------------------------------------------------------
Port       Temp   Voltage  Current   Tx Power  Rx Power
          (Celsius) (Volts)  (mA)      (dBm)     (dBm)
------------------------------------------------------------------------
Te1/0/1    38.5   3.29     6.5       -2.1      -3.4     <-- ปกติ (อยู่ในช่วง -1 ถึง -9 dBm)
Te1/0/2    41.0   3.28     6.8       -2.2      -24.8 -- <-- ผิดปกติ! แสงขาเข้าอ่อนมาก (Low Alarm)
```

- **ค่าปกติของ SFP+ SR/LR ทั่วไป**: มักอยู่ในช่วง **`-1.0 dBm` ถึง `-9.0 dBm`**
- หากค่า **Rx Power ต่ำกว่า `-15 dBm` ถึง `-20 dBm` (หรือขึ้น `-40 dBm` คือไม่มีแสงเลย)**: แสดงว่าหัวไฟเบอร์สกปรก, สายหักงอ, หรือสายขาดระหว่างทาง

---

## 5. ระบบบริหารจัดการสินทรัพย์ศูนย์ข้อมูล: DCIM & NetBox

**DCIM (Data Center Infrastructure Management)** เช่นซอฟต์แวร์โอเพนซอร์สยอดฮิตอย่าง **NetBox** คือฐานข้อมูลกลาง ("Source of Truth") ที่ใช้บันทึกทุกอย่างในศูนย์ข้อมูล:
- ผังตู้แร็ค (**Rack Elevation**): ช่อง U ไหนว่าง ช่อง U ไหนติดตั้งเครื่องอะไร
- ทะเบียนอุปกรณ์ (**Asset Tag / Serial Number / Warranty**): สแกนบาร์โค้ดติดตามตั้งแต่ห้องรับของ (Loading Dock) จนขึ้นตู้แร็ค
- ผังการเชื่อมต่อสายไฟและสายแลนทุกเส้น และการจัดสรร IP Address (**IPAM**)
', 10, 'beginner', 8, true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.lessons VALUES ('4239ddec-0437-4d0e-9b43-7cf2d26d3c23', 10, 'dc-operations-safety', 'กระบวนการปฏิบัติงาน, ความปลอดภัยทางกายภาพ และมาตรฐาน Tier (DC Operations, Safety & Tier Standards)', 'กระบวนการ Change Management (MOP), งาน Remote Hands, การเคลม RMA และการทำลายข้อมูลดิสก์, มาตรฐานความปลอดภัย ESD / Server Lift / LOTO, ระบบ Mantrap และระดับ Tier I-IV กับค่า PUE', '# กระบวนการปฏิบัติงาน, ความปลอดภัยทางกายภาพ และมาตรฐาน Tier

ศูนย์ข้อมูลคือหัวใจของธุรกิจการเงิน โรงพยาบาล และคลาวด์ระดับโลก ความผิดพลาดเพียงครั้งเดียวจากความประมาทของคน (Human Error) อาจสร้างความเสียหายนับสิบล้านบาท ดังนั้นการทำงานใน Data Center จึงถูกควบคุมด้วย **ระเบียบปฏิบัติ (Operations Process)**, **มาตรฐานความปลอดภัย (Safety)** และ **ระดับความพร้อมใช้งาน (Uptime Tier)** อย่างเคร่งครัด

---

## 1. กระบวนการปฏิบัติงานมาตรฐาน: Change Management & MOP

ใน Data Center คุณไม่สามารถเดินเข้าไปถอดสายหรือรีบูตอุปกรณ์สำคัญตามใจชอบได้ ทุกการเปลี่ยนแปลงต้องผ่านกระบวนการ **Change Management**:

1. **Change Request (CR) & Maintenance Window**: ต้องขออนุมัติช่วงเวลาทำงานล่วงหน้า (มักเป็นช่วงดึกที่มีผู้ใช้งานน้อย เช่น 01:00–04:00 น.)
2. **MOP (Method of Procedure)**: เอกสารคู่มือการปฏิบัติงานแบบละเอียดทีละขั้นตอน (Step-by-Step Checklist) ซึ่งต้องระบุครบ 4 ส่วน:
   - **Pre-checks**: ตรวจสอบสถานะระบบก่อนเริ่มงานว่าปกติและมีระบบสำรองพร้อมทำงาน
   - **Execution Steps**: ขั้นตอนการลงมือทำอย่างละเอียด พร้อมระบุชื่อเครื่อง พอร์ต และเวลา
   - **Post-checks / Verification**: วิธีตรวจสอบหลังทำเสร็จว่าระบบกลับมาทำงานสมบูรณ์ 100%
   - **Rollback Plan (แผนถอยกลับ)**: หากทำแล้วเกิดปัญหาและแก้ไม่สำเร็จภายในเวลาที่กำหนด (เช่น เหลือเวลาก่อนหมดช่วง Maintenance 30 นาที) จะต้องย้อนกลับสู่สภาพเดิมอย่างไรให้ปลอดภัยที่สุด

---

## 2. งานบริการ Remote Hands / Smart Hands และการเคลม RMA

### 1) Remote Hands (Smart Hands)
ในบริษัท Colocation ลูกค้าไม่จำเป็นต้องเดินทางมาที่ศูนย์ข้อมูลเอง แต่สามารถเปิด Ticket สั่งให้ช่างประจำศูนย์ข้อมูลช่วยปฏิบัติงานหน้าตู้แร็คแทนได้ เช่น:
- เดินไปถ่ายรูปไฟสถานะหน้าเครื่องเซิร์ฟเวอร์และสวิตช์ (**Visual Inspection**)
- กดปุ่ม Power / รีบูตเครื่อง หรือเสียบสาย Console/KVM Cart ให้ลูกค้ารีโมตเข้ามาแก้ปัญหา
- เปลี่ยนฮาร์ดดิสก์ แรม โมดูล SFP หรือเสียบสาย Patch Cord ตามพอร์ตที่ลูกค้าระบุ

### 2) กระบวนการ RMA (Return Merchandise Authorization) และความปลอดภัยของข้อมูลดิสก์
เมื่อฮาร์ดแวร์อยู่ในประกันและเสีย ช่างจะต้องทำเรื่องเคลมเปลี่ยนอะไหล่กับผู้ผลิต (เช่น Dell, HPE, Cisco) เรียกว่า **RMA**:
> **กฎเหล็กด้าน Data Security (ISO 27001 / PDPA)**:  
> สำหรับ **ฮาร์ดดิสก์หรือ SSD ที่เสีย** ห้ามส่งดิสก์ที่มีข้อมูลความลับของลูกค้าออกไปให้บุคคลภายนอกโดยไม่ทำลายข้อมูลเด็ดขาด!  
> - หากดิสก์ยังพอเขียนได้ ต้องทำการ **Secure Erase / Zero Wipe** ล้างข้อมูลทั้งหมด  
> - หากดิสก์พังจนอ่านเขียนไม่ได้ ต้องเข้าเครื่อง **ล้างสนามแม่เหล็ก (Degausser)** หรือ **เครื่องบดทำลายดิสก์ทางกายภาพ (Physical Shredder / Crusher)** หรือใช้บริการประกันประเภท **Keep Your Hard Drive (KYHD)** ที่ผู้ผลิตส่งดิสก์ลูกใหม่มาให้โดยไม่ต้องส่งลูกเก่าคืน

---

## 3. ความปลอดภัยในการทำงาน (Workplace Safety & ESD)

![ภาพการสวมสายรัดข้อมือป้องกันไฟฟ้าสถิต ESD Wrist Strap และอุปกรณ์ความปลอดภัยในศูนย์ข้อมูล](/images/datacenter/esd-safety-ppe.png)

1. **การป้องกันไฟฟ้าสถิต (ESD - Electrostatic Discharge)**:
   - ร่างกายมนุษย์มีไฟฟ้าสถิตสะสมซึ่งสามารถช็อตชิป RAM, CPU หรือ Mainboard พังได้ทันทีโดยที่เราไม่รู้สึกตัว
   - **ก่อนเปิดฝาเครื่องและจับแผงวงจรทุกครั้ง ต้องสวมสายรัดข้อมือป้องกันไฟฟ้าสถิต (ESD Wrist Strap)** โดยหนีบปลายสายเข้ากับโครงโลหะของตู้แร็คที่ต่อสายดินไว้ และวางอะไหล่บนแผ่นรองหรือถุงป้องกันไฟฟ้าสถิต (**Antistatic Mat / ESD Bag**) เสมอ
2. **การยกของหนักและเครื่องช่วยยก (Ergonomics & Server Lift)**:
   - เซิร์ฟเวอร์ขนาด 2U–4U หรือเครื่องเก็บข้อมูล (Storage Array) อาจมีน้ำหนักสูงถึง **25–60 กิโลกรัม**
   - ห้ามก้มยกด้วยหลังคนเดียวเด็ดขาด! ต้องยกด้วยกำลังขาร่วมกันอย่างน้อย 2 คน (**Team Lift**) หรือใช้รถยกเซิร์ฟเวอร์ไฮดรอลิก (**Server Lift**) เพื่อป้องกันอุบัติเหตุเครื่องหล่นทับหรือกระดูกสันหลังบาดเจ็บ
3. **LOTO (Lockout / Tagout)**:
   - เมื่อมีการซ่อมบำรุงระบบไฟฟ้าหรือเบรกเกอร์ ต้องทำการ **ใส่กุญแจล็อกเบรกเกอร์ (Lockout)** และ **แขวนป้ายเตือนห้ามสับสวิตช์เด็ดขาด (Tagout)** เพื่อป้องกันไม่ให้คนอื่นมาเผลอสับไฟจ่ายเข้ามาขณะช่างกำลังทำงาน

---

## 4. ความปลอดภัยทางกายภาพ (Physical Security) และกฎระเบียบห้อง Data Hall

1. **Mantrap (Airlock Door)**: ประตูนิรภัยสองชั้นที่บังคับให้ประตูด่านแรกต้องปิดล็อกสนิทก่อน ประตูด่านที่สองจึงจะยอมเปิดออก พร้อมระบบสแกนลายนิ้วมือ/ม่านตา เพื่อป้องกันการเดินตามหลังกันเข้ามาโดยไม่สแกนบัตร (**Anti-Tailgating / Piggybacking**)
2. **สิ่งต้องห้ามนำเข้าห้อง Data Hall เด็ดขาด**:
   - **ห้ามนำน้ำดื่ม กาแฟ หรืออาหารเข้ามา** (เสี่ยงหกใส่อุปกรณ์ไฟฟ้าและดึงดูดสัตว์กัดแทะ)
   - **ห้ามนำกล่องกระดาษลูกฟูก (Cardboard Boxes) เข้ามาในห้องเซิร์ฟเวอร์!** ➔ ต้องแกะกล่องกระดาษออกตั้งแต่ห้องรับของ (Staging / Unpacking Room) เพราะกล่องกระดาษปล่อย **ฝุ่นผงเยื่อกระดาษ** เข้าไปอุดตันพัดลมเซิร์ฟเวอร์ และเป็น **เชื้อเพลิงชั้นดีที่ทำให้ไฟลุกลาม**

---

## 5. มาตรฐานระดับศูนย์ข้อมูล (Uptime Tier I–IV) และค่า PUE

### 1) มาตรฐาน Uptime Institute Tier Classification:

| ระดับ Tier | ชื่อเรียก | สถาปัตยกรรมระบบสำรอง (Redundancy) | เวลาหยุดทำงานสูงสุดต่อปี | Uptime SLA |
|---|---|---|---|---|
| **Tier I** | Basic Capacity | **$N$** (ไม่มีระบบสำรอง ปิดซ่อมต้องดับระบบ) | ~28.8 ชั่วโมง/ปี | 99.671% |
| **Tier II** | Redundant Components | **$N+1$** (มีอุปกรณ์สำรองเพิ่ม 1 ตัว แต่ใช้สายส่งเส้นเดียว) | ~22.0 ชั่วโมง/ปี | 99.741% |
| **Tier III** | **Concurrently Maintainable** | **$N+1$ อุปกรณ์ และมีเส้นทางจ่ายไฟ 2 เส้น** (สามารถปิดซ่อมบำรุงได้โดยไม่ต้องดับระบบเลย!) | ~1.6 ชั่วโมง/ปี | **99.982%** |
| **Tier IV** | **Fault Tolerant** | **$2N$ หรือ $2(N+1)$** (แยกอิสระสมบูรณ์ 2 ระบบ ต่อให้อุปกรณ์ระเบิดหรือไฟไหม้ 1 ฝั่ง ระบบอีกฝั่งก็รับช่วงต่อทันทีโดยไม่กระตุก) | ~26 นาที/ปี | **99.995%** |

### 2) ค่าความคุ้มค่าพลังงาน: PUE (Power Usage Effectiveness)
$$\text{PUE} = \frac{\text{Total Facility Power (พลังงานไฟฟ้าทั้งหมดที่ทั้งตึกใช้)}}{\text{IT Equipment Power (พลังงานไฟฟ้าที่เซิร์ฟเวอร์และอุปกรณ์ไอทีใช้จริง)}}$$
- **ค่าอุดมคติคือ `1.0`** (แปลว่าไฟทุกวัตต์ถูกใช้โดยเซิร์ฟเวอร์ 100% ไม่เสียไปกับแอร์หรือความร้อนเลย)
- Data Center ทั่วไปมีค่า PUE ประมาณ **`1.4 – 1.8`** ส่วน Data Center ยุคใหม่ที่ประหยัดพลังงานสูงจะมีค่า PUE ต่ำกว่า **`1.2`**
', 11, 'beginner', 9, true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.lessons VALUES ('20d9ad57-bea5-4819-889f-9ff3841bb039', 6, 'troubleshooting-itil-sla-ticketing', 'กระบวนการทำงาน IT Support มืออาชีพ: ITIL, SLA, การเขียน Ticket และ Escalation (ITIL & SLA Operations)', 'การแยกแยะ Incident vs Service Request vs Problem vs Change ตามกรอบ ITIL, การคำนวณ Response & Resolution SLA, ตาราง Priority Matrix (Impact × Urgency) และสูตรการเขียน Escalation Note ส่งต่อให้ทีม L2/L3', '# กระบวนการทำงาน IT Support มืออาชีพ: ITIL, SLA, การเขียน Ticket และ Escalation

ในองค์กรระดับมาตรฐานสากล ทีม IT Support / Helpdesk / NOC ไม่ได้ทำงานแบบ *"ใครตะโกนดังกว่าทำให้ก่อน"* แต่ทำงานภายใต้กรอบมาตรฐาน **ITSM (IT Service Management)** ที่อ้างอิงจาก **ITIL (Information Technology Infrastructure Library)** เพื่อให้ทุกปัญหาถูกจัดลำดับความสำคัญ วัดผลเวลาได้ และมีประวัติส่งต่อที่ชัดเจน

---

## 1. แยกให้ออก: Incident vs Service Request vs Problem vs Change

ในการรับแจ้งเรื่องผ่านระบบ Ticketing (เช่น Jira Service Management, ServiceNow, Zendesk) สิ่งแรกที่เจ้าหน้าที่ L1 ต้องทำคือ **จัดหมวดหมู่ใบงาน (Categorization)** ให้ถูกต้อง:

![แผนผังเปรียบเทียบ Incident, Service Request, Problem และ Change ตามกรอบ ITIL](/images/troubleshooting/itil-incident-vs-request.png)

| ประเภทใบงาน (ITIL) | นิยามสั้นๆ ที่จำง่าย | ตัวอย่างสถานการณ์จริง | เป้าหมายหลักในการจัดการ |
|---|---|---|---|
| **Incident (อุบัติการณ์/เหตุขัดข้อง)** | **"ของที่เคยใช้ได้ปกติ จู่ๆ ก็พังหรือช้าผิดปกติ"** (Unplanned Interruption) | เข้าเว็บระบบบัญชีไม่ได้, เน็ตหลุดทั้งชั้น, ปริ้นเตอร์ค้าง, เซิร์ฟเวอร์แฮงก์ | **กู้คืนบริการให้กลับมาใช้งานได้เร็วที่สุด (Restore Normal Service ASAP)** แม้จะใช้ Workaround ชั่วคราวก็ตาม |
| **Service Request (คำขอรับบริการ)** | **"ของไม่ได้พัง แต่ผู้ใช้ขอสิ่งใหม่ตามสิทธิ์มาตรฐาน"** | ขอสร้างบัญชีพนักงานใหม่, ขอติดตั้งโปรแกรม Adobe, ขอสิทธิ์เข้าโฟลเดอร์การเงิน, ขอรีเซ็ตรหัสผ่านที่ลืม | ตรวจสอบสิทธิ์การอนุมัติ (Approval) และดำเนินการตามขั้นตอนมาตรฐาน (Standard Fulfillment) |
| **Problem (ต้นตอของปัญหา)** | **"สาเหตุรากเหง้า (Root Cause) ที่ทำให้เกิด Incident ซ้ำๆ"** | สวิตช์ชั้น 3 แฮงก์ทุกวันจันทร์ 9 โมงเช้า (เกิด Incident ซ้ำ 4 ครั้งในเดือนเดียว) | สืบสวนหา **Root Cause (RCA)** และแก้ไขถาวรเพื่อไม่ให้เกิด Incident ซ้ำอีก |
| **Change Request / RFC (การเปลี่ยนแปลง)** | **"การขออนุมัติปรับปรุง อัปเกรด หรือแก้ไขคอนฟิกในระบบจริง"** | ขออัปเกรด Firmware Firewall คืนวันเสาร์, ขอเพิ่มกฎเปิดพอร์ตใหม่, ขอเปลี่ยนฮาร์ดดิสก์เซิร์ฟเวอร์ | ประเมินความเสี่ยง มีแผนย้อนกลับ (**Rollback Plan**) และผ่านการอนุมัติจาก **CAB (Change Advisory Board)** |

---

## 2. Priority Matrix: คำนวณความเร่งด่วนจาก Impact × Urgency

เมื่อเกิด Incident เราห้ามตั้งระดับความรุนแรง (Priority / Severity) ตามอารมณ์ของผู้แจ้ง แต่ต้องคำนวณจาก 2 ปัจจัยเสมอ:
- **Impact (ผลกระทบ)**: กระทบคนจำนวนเท่าใด หรือกระทบระบบสำคัญแค่ไหน? (เช่น *กระทบพนักงาน 1 คน* vs *กระทบทั้งแผนก* vs *ระบบรับชำระเงินลูกค้าล่มทั้งบริษัท*)
- **Urgency (ความเร่งด่วนทางธุรกิจ)**: งานนั้นรอได้หรือไม่ มีทางเลี่ยง (Workaround) หรือไม่? (เช่น *รอพรุ่งนี้ได้* vs *กำลังจะปิดงบการเงินในอีก 30 นาที*)

![ตาราง Priority Matrix คำนวณจาก Impact และ Urgency พร้อมกรอบเวลา SLA](/images/troubleshooting/sla-priority-matrix.png)

| ระดับความสำคัญ | ชื่อเรียก | ลักษณะเหตุการณ์ | ตัวอย่างกรอบเวลา **Response SLA** | ตัวอย่างกรอบเวลา **Resolution SLA** |
|---|---|---|---|---|
| **P1 (Sev-1)** | **Critical** | ระบบหลักล่มทั้งองค์กร ลูกค้าใช้งานไม่ได้ ไม่สามารถทำงานต่อได้ | **ภายใน 15 นาที** | **ภายใน 1–4 ชั่วโมง** |
| **P2 (Sev-2)** | **High** | กระทบทั้งแผนกหรือฟังก์ชันสำคัญใช้งานไม่ได้ แต่ยังมี Workaround บางส่วน | **ภายใน 30 นาที** | **ภายใน 4–8 ชั่วโมง** |
| **P3 (Sev-3)** | **Medium** | กระทบผู้ใช้งานรายบุคคล งานสะดุดแต่ยังพอทำงานอื่นรอได้ | **ภายใน 2 ชั่วโมง** | **ภายใน 1–2 วันทำการ** |
| **P4 (Sev-4)** | **Low** | คำถามทั่วไป ปัญหาจุกจิกที่ไม่กระทบงานหลัก หรือขอคำแนะนำ | **ภายใน 4–8 ชั่วโมง** | **ภายใน 3–5 วันทำการ** |

---

## 3. Response SLA vs Resolution SLA และกลไก Pause SLA

**SLA (Service Level Agreement)** คือข้อตกลงระดับการให้บริการที่ทีม IT สัญญาไว้กับธุรกิจหรือลูกค้า แบ่งเป็น 2 นาฬิกาหลัก:
1. **First Response SLA (เวลาตอบรับเคส)**: นับตั้งแต่ Ticket ถูกสร้าง จนถึงเวลาที่ช่าง IT **รับเรื่องและติดต่อกลับหาผู้แจ้งครั้งแรก** (ไม่ใช่เวลาที่แก้เสร็จ!)
2. **Resolution SLA (เวลาแก้ไขเคสจนลุล่วง)**: นับตั้งแต่ Ticket ถูกสร้าง จนถึงเวลาที่ **ระบบกลับมาใช้งานได้ปกติ (Resolved)**

> **กฎการหยุดเวลาชั่วคราว (SLA Clock Pause / On-Hold / Pending User)**:
> หากช่าง IT ขอข้อมูลเพิ่มเติมจากผู้ใช้งาน หรือนัดหมายขอรีโมทเครื่อง แต่ผู้ใช้งานติดประชุมไม่ตอบกลับ สามารถเปลี่ยนสถานะใบงานเป็น **`Pending Customer / Waiting for User`** เพื่อหยุดเวลานาฬิกา SLA ชั่วคราวได้ (แต่ต้องบันทึกหลักฐานการติดต่อไว้ใน Ticket เสมอ!)

---

## 4. สูตรการเขียน Escalation Note ส่งต่อให้ทีม L2 / L3 อย่างมืออาชีพ

สิ่งที่ทีม L2 (SysAdmin/Network) และ L3 (Dev/Vendor) เกลียดที่สุดคือการโยนเคสมาพร้อมข้อความสั้นๆ ว่า *"ลูกค้าเข้าไม่ได้ครับ รบกวนดูให้หน่อย"* โดยไม่มีข้อมูลอะไรเลย!

ก่อนส่งต่อเคส (**Functional Escalation**) ช่าง L1 ต้องสรุปข้อมูลตามสูตร **5W + Evidence + Tested** ดังนี้:

```text
[Escalation Summary to L2 Network Team]
1. WHO (ผู้ได้รับผลกระทบ): แผนกบัญชี ชั้น 4 จำนวน 18 เครื่อง (VLAN 40)
2. WHAT & WHERE (อาการและระบบปลายทาง): เข้าใช้งานระบบ ERP (https://erp.company.local / 10.20.1.50:443) ไม่ได้ ขึ้น ERR_CONNECTION_TIMED_OUT
3. WHEN (เวลาที่เริ่มเกิดเหตุ): เริ่มเกิดวันนี้ 10/11/2026 เวลา 13:45 น. หลังไฟกระพริบที่ชั้น 4
4. EVIDENCE (หลักฐานที่แนบมา): แนบภาพหน้าจอ Error และผลลัพธ์ ipconfig /all, ping, tracert ใน Ticket แล้ว
5. WHAT HAS BEEN TESTED (สิ่งที่ L1 ตรวจสอบไปแล้ว):
   - เครื่องใน VLAN 40 ได้รับ IP 10.40.1.x และ Ping Default Gateway (10.40.1.1) เจอปกติ
   - ลองเข้า ERP จากชั้น 2 (VLAN 20) เข้าใช้งานได้ปกติ (แปลว่า ERP Server ไม่ได้ล่ม)
   - รัน tracert จาก VLAN 40 ไป 10.20.1.50 พบว่าแพ็กเก็ตไปหยุดอยู่ที่ Core Switch (10.0.0.1)
   - ขอส่งต่อทีม Network ตรวจสอบ Routing / Firewall Rule ระหว่าง VLAN 40 ไปยัง Server Farm ครับ
```
', 10, 'beginner', 3, true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.lessons VALUES ('db3e3c4d-8da3-45fd-99a6-c07212788dff', 6, 'troubleshooting-windows-ad-gpo', 'การจัดการ Windows Domain เบื้องต้น: Active Directory, GPO และแก้ปัญหา Login ในองค์กร (Active Directory & GPO)', 'โครงสร้าง Active Directory (Domain, OU, Users, Computers, Groups), กลไก Kerberos และปัญหาเวลาเพี้ยน, การแก้ Account Lockout, Trust Relationship Failed, Temporary Profile และการอัปเดต GPO ด้วย gpupdate / gpresult', '# การจัดการ Windows Domain เบื้องต้น: Active Directory, GPO และแก้ปัญหา Login ในองค์กร

ในองค์กรที่มีคอมพิวเตอร์ตั้งแต่ 20 เครื่องไปจนถึงหลักหมื่นเครื่อง เราไม่สามารถเดินตั้งรหัสผ่านแยกทีละเครื่อง (Workgroup) ได้ แต่จะใช้ระบบศูนย์กลางของ Microsoft ที่เรียกว่า **Active Directory Domain Services (AD DS)** คู่กับ **Group Policy (GPO)** ซึ่งงานเกินครึ่งของทีม IT Helpdesk / Desktop Support คือการจัดการบัญชีและแก้ปัญหาการล็อกอินเข้า Domain

---

## 1. โครงสร้างหลักของ Active Directory (AD DS)

เมื่อเปิดเครื่องมือ **Active Directory Users and Computers (`dsa.msc`)** คุณจะพบกับออบเจกต์หลัก 4 ชนิดที่ต้องแยกหน้าที่ให้ชัดเจน:

![โครงสร้าง Active Directory OU, Users, Computers และการบังคับใช้ Group Policy (GPO)](/images/troubleshooting/active-directory-ou-gpo.png)

1. **Domain & Domain Controller (DC)**: เซิร์ฟเวอร์ที่ทำหน้าที่ถือฐานข้อมูลบัญชีผู้ใช้ (`ntds.dit`) และตรวจสอบสิทธิ์การล็อกอินของทุกคนในบริษัท
2. **Organizational Unit (OU)**: "โฟลเดอร์เชิงโครงสร้างองค์กร" (เช่น `OU=Accounting`, `OU=Sales`, `OU=Servers`) ใช้สำหรับจัดระเบียบ User/Computer **และเป็นหน่วยหลักที่ใช้ผูกนโยบาย Group Policy (GPO)**
3. **Security Group (กลุ่มสิทธิ์)**: ใช้รวม User ที่มีบทบาทเดียวกัน (เช่น `GRP_Accounting_ReadWrite`) เพื่อนำไปกำหนดสิทธิ์เข้าใช้งาน File Share หรือระบบต่างๆ (**Best Practice: ห้ามให้สิทธิ์โฟลเดอร์แก่ User รายคนโดยตรง แต่ให้เพิ่ม User เข้า Security Group เสมอ!**)
4. **User Account & Computer Account**: บัญชีของพนักงาน และบัญชีประจำตัวเครื่องคอมพิวเตอร์ที่ทำการ **Join Domain** แล้ว

---

## 2. 4 ปัญหาคลาสสิกเมื่อผู้ใช้งาน Login เข้า Windows Domain ไม่ได้

### อาการที่ 1: "Your account has been locked out" (บัญชีถูกล็อก)
- **สาเหตุ**: มีการส่งรหัสผ่านผิดเกินจำนวนครั้งที่นโยบายกำหนด (เช่น ผิดครบ 5 ครั้ง)
- **กับดักหน้างานจริง**: ผู้ใช้ยืนยันว่าพิมพ์รหัสผ่านใหม่ถูกต้องแล้ว แต่พอปลดล็อกให้ไม่ถึง 2 นาทีก็ถูกล็อกซ้ำอีก!
- **ต้นตอที่แท้จริง**: ผู้ใช้เพิ่งเปลี่ยนรหัสผ่านใหม่ แต่อุปกรณ์หรือโปรแกรมอื่นยังจำรหัสผ่านเก่าและพยายามล็อกอินซ้ำอยู่เบื้องหลัง เช่น:
  1. แอปอีเมลหรือ Wi-Fi (`802.1X`) ในโทรศัพท์มือถือ/แท็บเล็ต
  2. รหัสผ่านที่จำค้างไว้ใน **Windows Credential Manager** หรือ **Mapped Network Drive**
  3. เครื่องคอมพิวเตอร์อีกเครื่องที่ล็อกอินค้างไว้ (Disconnected RDP Session)
- **วิธีแก้**: เปิด `dsa.msc` ➔ คลิกขวาที่ชื่อผู้ใช้ ➔ **Properties ➔ แท็บ Account ➔ ติ๊กถูก "Unlock account"** พร้อมให้ผู้ใช้ลบแคชรหัสผ่านเก่าในมือถือและ Credential Manager

### อาการที่ 2: "The trust relationship between this workstation and the primary domain failed"
- **สาเหตุ**: คอมพิวเตอร์ทุกเครื่องที่ Join Domain จะมี "รหัสผ่านของตัวเครื่อง (Machine Account Password)" ที่คุยกับ Domain Controller และเปลี่ยนอัตโนมัติทุก 30 วัน หากเครื่องถูกปิดทิ้งไว้นานหลายเดือน หรือถูกย้อน System Restore/VM Snapshot รหัสผ่านของเครื่องจะไม่ตรงกับที่ DC จำไว้!
- **วิธีแก้โดยไม่ต้องถอดเข้าออก Domain ใหม่**:
  1. ดึงสาย LAN ออกชั่วคราวเพื่อให้ล็อกอินด้วย Cached Credentials เข้าเครื่องได้ หรือล็อกอินด้วยบัญชี **Local Administrator** (`.\Administrator`)
  2. เสียบสาย LAN กลับเข้าไป แล้วเปิด PowerShell (Run as Admin) รันคำสั่งซ่อมช่องทางปลอดภัย:
     ```powershell
     Test-ComputerSecureChannel -Repair -Credential (Get-Credential)
     ```
     *(ใส่ชื่อผู้ใช้และรหัสผ่านของ Domain Admin ก็จะกลับมาล็อกอินได้ทันทีโดยไม่ต้องรีสตาร์ทหลายรอบ!)*

### อาการที่ 3: นาฬิกาเครื่องไม่ตรงเกิน 5 นาที (Kerberos Clock Skew Error)
- **สาเหตุ**: ระบบยืนยันตัวตน **Kerberos** ของ Active Directory ใช้เวลาประทับ (Timestamp) เพื่อป้องกันการดักจับแพ็กเก็ตมาใช้ซ้ำ (Replay Attack) หากเวลาของเครื่องลูกคลาดเคลื่อนจาก Domain Controller **เกิน 5 นาที** จะล็อกอินไม่ผ่านหรือเข้า File Share ไม่ได้ทันที!
- **วิธีแก้**: ซิงก์เวลาเข้ากับ Domain Controller ด้วยคำสั่ง:
  ```powershell
  w32tm /resync /force
  w32tm /query /status
  ```

### อาการที่ 4: ล็อกอินแล้วไฟล์หน้าจอหาย กลายเป็น "Temporary Profile"
- **สาเหตุ**: โปรไฟล์ผู้ใช้ในเครื่องเกิดค้างหรือสิทธิ์เพี้ยน ทำให้ Windows โหลดโฟลเดอร์จริงไม่ได้ จึงสร้างโฟลเดอร์ชั่วคราว (`C:\Users\TEMP`) ให้แทน (หากผู้ใช้เซฟงานไว้แล้วสั่งรีสตาร์ท งานใน TEMP จะหายเกลี้ยง!)
- **วิธีแก้**:
  1. สำรองไฟล์ที่ผู้ใช้เพิ่งสร้างใน `C:\Users\TEMP` ออกมาก่อน
  2. เปิด `regedit` ไปที่ `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList`
  3. มองหาคีย์ SID ของผู้ใช้ที่มีนามสกุล **`.bak`** ต่อท้าย ➔ ลบตัวจำลองที่ไม่มี `.bak` ทิ้ง แล้วเปลี่ยนชื่อตัวที่มี `.bak` ให้กลับมาเป็นชื่อปกติ จากนั้นรีสตาร์ทเครื่อง

---

## 3. การจัดการและตรวจสอบ Group Policy (GPO) ด้วย CLI

![ขั้นตอนการตรวจสอบผลลัพธ์ Group Policy ด้วยคำสั่ง gpresult และแก้ปัญหา Trust Relationship](/images/troubleshooting/windows-domain-troubleshooting.png)

**Group Policy Object (GPO)** ใช้บังคับการตั้งค่าจากศูนย์กลาง เช่น ตั้งหน้าจอ Lock Screen, บล็อกพอร์ต USB, Map Drive อัตโนมัติ, หรือสั่งติดตั้งซอฟต์แวร์ เมื่อแอดมินแก้ GPO บนเซิร์ฟเวอร์แล้ว เครื่องลูกยังไม่รับค่าใหม่ทันที ให้ใช้คำสั่งต่อไปนี้:

```powershell
# 1. บังคับดึงและอัปเดตนโยบาย GPO ล่าสุดจาก Domain Controller ทันที
gpupdate /force

# 2. ตรวจสอบว่าเครื่องนี้และ User คนนี้ได้รับ GPO ตัวไหนมาบ้าง (Resultant Set of Policy)
gpresult /r

# 3. สร้างรายงานสรุป GPO ทั้งหมดออกมาเป็นไฟล์เว็บ HTML เพื่อเปิดดูว่านโยบายข้อไหนชนะ/ถูกบล็อก
gpresult /h C:\temp\gpo-report.html

# 4. ตรวจสอบว่า User ปัจจุบันสังกัดอยู่ OU ไหน และเป็นสมาชิกของ Security Group ใดบ้าง
whoami /fqdn
whoami /groups
```
', 12, 'beginner', 4, true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.lessons VALUES ('b4c768d7-eb4b-47f6-8044-356dd03f07cc', 6, 'troubleshooting-m365-email-auth', 'การดูแลระบบอีเมลองค์กร Microsoft 365 และตรวจสอบ SPF, DKIM, DMARC (M365 & Email Authentication)', 'การเลือกใช้ User Mailbox vs Shared Mailbox vs Distribution List ใน Microsoft 365, กลไกป้องกันอีเมลปลอมแปลง SPF, DKIM, DMARC, การอ่านรหัสตีกลับ NDR (550 5.1.1 / 5.7.1) และการใช้ Message Trace', '# การดูแลระบบอีเมลองค์กร Microsoft 365 และตรวจสอบ SPF, DKIM, DMARC

ระบบอีเมลคือหัวใจของการติดต่อสื่อสารในทุกบริษัท งานของทีม IT Support และ SysAdmin ไม่ได้มีแค่การสร้างอีเมลให้พนักงานใหม่ แต่รวมถึงการเลือกประเภทกล่องจดหมายให้ประหยัดค่า License และการแก้ปัญหา *"ส่งอีเมลหาลูกค้าแล้วตีกลับ (Bounce)"* หรือ *"อีเมลไปตกในถังขยะ (Junk/Spam)"* ด้วยความเข้าใจในระเบียน DNS ทั้ง 4 ตัว: **MX, SPF, DKIM และ DMARC**

---

## 1. ประเภทกล่องจดหมายใน Microsoft 365 (Exchange Online)

คำถามสัมภาษณ์และโจทย์หน้างานยอดฮิต: *"แผนกบัญชีอยากได้อีเมลกลาง `billing@company.com` ให้พนักงาน 4 คนช่วยกันเปิดอ่านและตอบกลับลูกค้า โดยไม่อยากเสียเงินซื้อ License เพิ่ม ต้องสร้างแบบไหน?"*

| ประเภทใน M365 | ต้องใช้ License หรือไม่? | มีกล่องเก็บเมลของตัวเองไหม? | ลักษณะการใช้งานและจุดเด่น |
|---|---|---|---|
| **User Mailbox** | **ต้องมี License** (เช่น M365 Business Basic/Standard) | มี (50–100 GB) | กล่องจดหมายส่วนตัวของพนักงาน 1 คน มีชื่อผู้ใช้และรหัสผ่านล็อกอินโดยตรง |
| **Shared Mailbox** | **ฟรี! ไม่ต้องใช้ License** (ตราบใดที่ขนาดไม่เกิน 50 GB และไม่ได้เปิดล็อกอินตรง) | มี (สูงสุด 50 GB ฟรี) | กล่องจดหมายกลางของแผนก (เช่น `support@`, `hr@`, `billing@`) แอดมินจะกำหนดสิทธิ์ **Full Access** (เปิดอ่าน) และ **Send As / Send on Behalf** ให้พนักงานที่มี User Mailbox อยู่แล้วเข้ามาใช้งานร่วมกัน |
| **Distribution List (DL)** | **ฟรี!** | **ไม่มีกล่องเก็บเมล** | เป็นเพียง "รายชื่อกระจายเมล" เมื่อมีคนส่งเมลมาที่ `all-staff@` ระบบจะสำเนาอีเมลกระจายต่อไปเข้ากล่องส่วนตัวของสมาชิกทุกคนทันที |
| **Microsoft 365 Group** | **ฟรี!** | มี + มี SharePoint/Teams | กลุ่มทำงานร่วมกันยุคใหม่ที่ได้ทั้งกล่องจดหมายกลุ่ม ปฏิทินกลาง และพื้นที่เก็บไฟล์ SharePoint |

> **ข้อควรระวังเมื่อพนักงานลาออก (Offboarding Trick)**:
> ก่อนลบ License ของพนักงานที่ลาออก หากต้องการเก็บประวัติอีเมลเก่าของเขาไว้ให้หัวหน้างานเปิดดู ให้กด **Convert to Shared Mailbox** ก่อน แล้วค่อยถอด License ออก ข้อมูลอีเมลจะยังอยู่ครบโดยไม่ต้องเสียค่าเช่ารายเดือน!

---

## 2. กลไกยืนยันตัวตนอีเมล: MX, SPF, DKIM และ DMARC

ทำไมเวลาเราตั้งเซิร์ฟเวอร์ส่งอีเมลเอง หรือใช้ระบบส่งใบแจ้งหนี้อัตโนมัติ อีเมลถึงชอบถูก Gmail หรือ Outlook ของลูกค้าบล็อก? เพราะโลกอินเทอร์เน็ตใช้ระเบียน DNS 4 ชนิดในการตรวจสอบว่า **"อีเมลฉบับนี้ส่งมาจากเจ้าของโดเมนตัวจริง ไม่ใช่โจรปลอมชื่อส่ง (Email Spoofing)"**:

![แผนภาพการทำงานร่วมกันของ MX, SPF, DKIM และ DMARC ในการยืนยันตัวตนอีเมลองค์กร](/images/troubleshooting/email-spf-dkim-dmarc-flow.png)

| ระเบียน DNS | ประเภท Record | หน้าที่หลัก (เปรียบเทียบให้เห็นภาพ) | ตัวอย่างค่าใน DNS |
|---|---|---|---|
| **MX (Mail Exchanger)** | `MX` | **"ป้ายบอกทางไปตู้จดหมายขารับ"** — บอกโลกภายนอกว่าถ้าจะส่งเมลหาโดเมนเรา ต้องส่งไปที่เซิร์ฟเวอร์ไหน | `company.com MX 10 company-com.mail.protection.outlook.com` |
| **SPF (Sender Policy Framework)** | `TXT` | **"รายชื่อคนส่งของที่ได้รับอนุญาต"** — ระบุรายการ IP หรือผู้ให้บริการที่มีสิทธิ์ส่งอีเมลออกในนามโดเมนเรา | `v=spf1 ip4:203.0.113.5 include:spf.protection.outlook.com -all` |
| **DKIM (DomainKeys Identified Mail)** | `TXT` / `CNAME` | **"ตราประทับครั่งดิจิทัล"** — เซิร์ฟเวอร์ขาออกจะเซ็นลายเซ็นเข้ารหัส (Private Key) แนบไปใน Header ของเมล เพื่อให้ผู้รับเปิดเช็กกับ Public Key บน DNS ว่าอีเมลไม่ถูกแก้ไขกลางทาง | `selector1._domainkey.company.com` |
| **DMARC** | `TXT` (`_dmarc`) | **"คำสั่งลงโทษเมื่อตรวจไม่ผ่าน"** — บอกเซิร์ฟเวอร์ผู้รับว่าหากตรวจ SPF และ DKIM ไม่ผ่าน ให้ทำอย่างไร (`p=none` แค่ส่งรายงาน, `p=quarantine` ย้ายลงถังขยะ Spam, `p=reject` บล็อกทิ้งทันที!) | `v=DMARC1; p=quarantine; rua=mailto:dmarc@company.com` |

### ความแตกต่างของท้ายคำสั่ง SPF:
- **`~all` (SoftFail)**: หากส่งมาจาก IP นอกรายการ ให้รับไว้ก่อนแต่ตีตราว่าน่าสงสัย (มักถูกส่งเข้าโฟลเดอร์ Junk/Spam)
- **`-all` (HardFail)**: หากส่งมาจาก IP นอกรายการ ให้ปฏิเสธหรือบล็อกทิ้งทันที!
- **กฎเหล็กของ SPF**: ใน 1 โดเมน **ห้ามมีระเบียน `v=spf1` หลายบรรทัดเด็ดขาด** (ต้องรวมทุก `include:` ไว้ในบรรทัดเดียวกัน) และห้ามมีการค้นหา DNS ซ้อนกันเกิน **10 DNS Lookups** มิฉะนั้น SPF จะพัง (`PermError`)

---

## 3. การอ่านรหัสอีเมลตีกลับ (NDR / Bounce Codes) และ Message Trace

เมื่อผู้ใช้งานส่งอีเมลไม่ผ่าน ระบบจะส่งจดหมายแจ้งเตือนกลับมาจาก `MAILER-DAEMON` ที่เรียกว่า **NDR (Non-Delivery Report)** ให้ดูที่รหัสตัวเลข 3 หลัก:

![หน้าจอการไล่เส้นทางจดหมายด้วย Message Trace และการอ่านรหัสตีกลับ NDR](/images/troubleshooting/m365-message-trace-ndr.png)

- **รหัสขึ้นต้นด้วย `4xx` (เช่น `451 4.4.1`, `421`) = Temporary Error (ปัญหาชั่วคราว)**:
  - กล่องจดหมายผู้รับเต็มชั่วคราว หรือเซิร์ฟเวอร์ปลายทางกำลังยุ่ง เซิร์ฟเวอร์ของเราจะพยายามส่งซ้ำ (Retry) ให้อัตโนมัติ
- **รหัสขึ้นต้นด้วย `5xx` = Permanent Error (ถูกปฏิเสธถาวร ต้องแก้ไข!)**:
  - **`550 5.1.1 User Unknown / Recipient not found`**: พิมพ์ชื่ออีเมลผู้รับผิด หรือบัญชีผู้รับถูกลบไปแล้ว
  - **`550 5.7.1 Unable to Relay / Service unavailable; Client host blocked`**: เซิร์ฟเวอร์ส่งออกติดบัญชีดำ (Blacklist/RBL) หรือตั้งค่า SPF/DKIM/DMARC ไม่ถูกต้องจนถูกระบบความปลอดภัยปลายทางบล็อก
  - **`552 5.2.2 Mailbox Full`** หรือ **`552 5.3.4 Message size exceeds fixed maximum message size`**: กล่องผู้รับเต็ม หรือแนบไฟล์ขนาดใหญ่เกินขีดจำกัด (โดยทั่วไปอีเมลจำกัดขนาดไฟล์แนบที่ 20–25 MB)

```bash
# คำสั่งตรวจสอบระเบียน MX, SPF และ DMARC ของโดเมนด้วย dig หรือ nslookup
dig company.com MX +short
dig company.com TXT +short
dig _dmarc.company.com TXT +short
```
', 11, 'intermediate', 5, true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.lessons VALUES ('36390028-97e0-4e57-b0db-c9c4f778cb68', 6, 'troubleshooting-printer-peripheral-network', 'การแก้ปัญหา Network Printer, Print Spooler, SMB Share และ VPN ในสำนักงาน (Office IT & Endpoint Troubleshooting)', 'การแก้คิวงานพิมพ์ค้างใน Print Spooler, ความต่างของพอร์ต Standard TCP/IP (9100) vs WSD Port, สิทธิ์การแชร์ไฟล์ SMB (Port 445) ระหว่าง Share vs NTFS Permission และปัญหา VPN Split Tunnel vs Full Tunnel', '# การแก้ปัญหา Network Printer, Print Spooler, SMB Share และ VPN ในสำนักงาน

ในการทำงานจริงของสาย IT Support / System Support ปัญหาที่สร้างความปวดหัวให้ผู้ใช้งานในออฟฟิศมากที่สุดหนีไม่พ้น 3 เรื่องใหญ่: **"ปริ้นเตอร์สั่งพิมพ์ไม่ออก"**, **"เข้าโฟลเดอร์แชร์ของแผนกไม่ได้"**, และ **"ต่อ VPN จากที่บ้านแล้วเน็ตหลุดหรือเข้าเซิร์ฟเวอร์บริษัทไม่ได้"** บทเรียนนี้สรุปวิธีวินิจฉัยและแก้ไขแบบตรงจุด

---

## 1. การแก้ปัญหา Network Printer พิมพ์ไม่ออก / คิวงานพิมพ์ค้าง

![ขั้นตอนการล้างคิวงานพิมพ์ค้างในโฟลเดอร์ Print Spooler และการตั้งค่าพอร์ต TCP/IP 9100](/images/troubleshooting/print-spooler-tcp9100.png)

### ปัญหาที่ 1: สั่งพิมพ์แล้วค้างในคิว (Stuck Print Job) กด Cancel ก็ไม่ยอมหาย!
เมื่อมีเอกสารไฟล์เสียค้างอยู่ในคิวอันดับแรก เอกสารของคนอื่นๆ ที่สั่งตามมาจะถูกกั้นไว้ทั้งหมด การคลิกขวาแล้วกด Cancel ในหน้าต่างปกติมักจะค้างอยู่ที่คำว่า `Deleting...` วิธีแก้ที่เด็ดขาดที่สุดคือการล้าง **Print Spooler** ด้วย Command Prompt (Run as Admin):

```bat
:: 1. สั่งหยุดบริการ Print Spooler ชั่วคราว (เพื่อปลดล็อกไฟล์คิวที่ค้าง)
net stop spooler

:: 2. ลบไฟล์งานพิมพ์ที่ค้างอยู่ทั้งหมดในโฟลเดอร์ PRINTERS ทิ้ง
del /Q /F /S "%systemroot%\System32\Spool\Printers\*.*"

:: 3. สั่งสตาร์ทบริการ Print Spooler กลับมาทำงานตามปกติ
net start spooler
```

### ปัญหาที่ 2: เครื่องพิมพ์ขึ้นสถานะ "Printer Offline" บ่อยครั้งหลังปิดเปิดใหม่
มักเกิดจาก 2 สาเหตุหลักที่ช่าง IT มืออาชีพต้องแก้ให้ขาด:
1. **เครื่องพิมพ์รับ IP แบบ DHCP แล้วเปลี่ยน IP ไปเรื่อยๆ**:
   - **วิธีแก้**: ต้องตั้งค่า **Static IP** ที่ตัวเครื่องพิมพ์ หรือผูก MAC Address ทำ **DHCP Reservation** บนเราเตอร์/เซิร์ฟเวอร์เสมอ!
2. **Windows แอดเครื่องพิมพ์ผ่านพอร์ต `WSD (Web Services for Devices)` อัตโนมัติ**:
   - พอร์ตแบบ WSD ใช้ Multicast ค้นหาเครื่องพิมพ์ ซึ่งหลุดง่ายมากเมื่อข้ามวงแลนหรือเมื่อเครื่องพิมพ์เข้าโหมดประหยัดพลังงาน (Sleep)
   - **วิธีแก้**: เข้าไปที่ **Printer Properties ➔ แท็บ Ports ➔ กด Add Port ➔ เลือก `Standard TCP/IP Port`** แล้วใส่ IP Address ของเครื่องพิมพ์โดยตรง (ทำงานผ่านพอร์ตมาตรฐาน **`TCP 9100` (RAW / JetDirect)** หรือ **`TCP 515` (LPR)**) และแนะนำให้เอาติ๊กถูกหน้า **SNMP Status Enabled** ออกหากเครื่องพิมพ์ขึ้น Offline ลวง

---

## 2. การแก้ปัญหา SMB Network File Share (`\\server\share`)

การแชร์โฟลเดอร์ในเครือข่าย Windows และ NAS ใช้โปรโตคอล **SMB (Server Message Block)** ซึ่งทำงานที่พอร์ต **`TCP 445`**

![การเปรียบเทียบสิทธิ์เข้าถึงไฟล์ระหว่าง Share Permission กับ NTFS Permission และ VPN Split Tunnel](/images/troubleshooting/smb-permissions-vpn-split-tunnel.png)

### กฎเหล็กการคำนวณสิทธิ์: Share Permission vs NTFS Permission
เมื่อแชร์โฟลเดอร์บน Windows Server จะมีด่านตรวจสิทธิ์ 2 ชั้นเสมอ:
1. **Share Permission** (แท็บ Sharing ➔ Advanced Sharing): ตรวจตอนเข้าผ่านเครือข่าย `\\server\share`
2. **NTFS Permission** (แท็บ Security): ตรวจในระดับระบบไฟล์ของฮาร์ดดิสก์

> **กฎการคิดสิทธิ์รวม (Effective Permission Rule)**:
> - **ภายในระดับเดียวกัน (เช่น User อยู่หลาย Group)**: สิทธิ์จะนำมา **รวมกัน (Cumulative)** เช่น อยู่กลุ่ม A ได้ Read + อยู่กลุ่ม B ได้ Write = ได้ทั้ง Read และ Write (ยกเว้นมีสิทธิ์ **Explicit Deny** ซึ่งจะชนะทุกอย่างเสมอ!)
> - **เมื่อเอา Share Permission มาชนกับ NTFS Permission**: สิทธิ์ที่ได้จริงจะยึดตามตัวที่ **"เข้มงวดที่สุด (Most Restrictive Wins)!"**
>   - *ตัวอย่าง*: ตั้ง Share Permission = **Read** แต่ตั้ง NTFS Security = **Full Control** ➔ เมื่อผู้ใช้เข้ามาผ่านเครือข่าย `\\server\share` จะทำได้แค่ **Read (อ่านอย่างเดียว แก้ไขไฟล์ไม่ได้!)**
>   - *Best Practice ของ SysAdmin*: ตั้ง **Share Permission ให้ `Authenticated Users = Change/Full Control`** แล้วไปควบคุมสิทธิ์ละเอียดรายแผนกที่ **NTFS Permission (แท็บ Security)** เพียงจุดเดียว จะไม่สับสน!

### คำสั่งจัดการการเชื่อมต่อโฟลเดอร์แชร์ (`net use`):
```bat
:: แสดงรายการโฟลเดอร์แชร์ที่เครื่องนี้เชื่อมต่อค้างไว้ทั้งหมด
net use

:: ล้างการเชื่อมต่อและรหัสผ่านที่จำค้างไว้ทั้งหมด (แก้ปัญหาขึ้นว่า Multiple connections to a server or shared resource by the same user)
net use * /delete /y

:: ทดสอบว่าพอร์ต SMB (445) ของเซิร์ฟเวอร์เปิดอยู่และไม่ถูก Firewall บล็อกใช่หรือไม่ (รันใน PowerShell)
Test-NetConnection -ComputerName 10.20.1.10 -Port 445
```

---

## 3. การแก้ปัญหา VPN เชื่อมต่อจากที่บ้าน (Full Tunnel vs Split Tunnel)

เมื่อพนักงาน Work from Home ต่อ VPN เข้าออฟฟิศ มักเจอ 2 อาการตรงข้ามกันที่เกิดจากการตั้งค่า Routing ของ VPN:

| รูปแบบ VPN | การทำงานของเส้นทาง (Routing) | อาการปัญหาที่พบบ่อย |
|---|---|---|
| **Full Tunnel VPN** | บังคับให้ทราฟฟิก **ทั้งหมด 100%** (รวมถึงการเข้าเว็บทั่วไปอย่าง YouTube, Google, ประชุม Zoom) วิ่งผ่านอุโมงค์ VPN เข้ามาออกอินเทอร์เน็ตที่สำนักงานใหญ่ | **เน็ตช้าลงมากเมื่อต่อ VPN** หรือหากไฟร์วอลล์ออฟฟิศบล็อกเว็บทั่วไป พนักงานจะเข้าเว็บภายนอกไม่ได้เลยขณะต่อ VPN |
| **Split Tunnel VPN** | ส่งเฉพาะทราฟฟิกที่มุ่งหน้าไปวงแลนภายในบริษัท (เช่น `10.0.0.0/8`) วิ่งเข้าอุโมงค์ VPN ส่วนการเข้าเว็บอินเทอร์เน็ตทั่วไปให้ออกทางเน็ตบ้านของผู้ใช้โดยตรง | ประหยัดแบนด์วิดท์ออฟฟิศ แต่หากลืมประกาศ Route ของเซิร์ฟเวอร์วงใหม่ใน VPN หรือ **Internal DNS ไม่ถูกผลักมาที่เครื่องลูก** ผู้ใช้จะเข้าเซิร์ฟเวอร์ด้วยชื่อโดเมนภายใน (`intranet.company.local`) ไม่ได้ (แต่เข้าด้วย IP ได้!) |
', 11, 'beginner', 6, true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.lessons VALUES ('efdde8b7-94d1-4638-bb7d-cc05c37f6634', 6, 'troubleshooting-backup-321-dr-ransomware', 'กลยุทธ์การสำรองข้อมูล (3-2-1 Backup Rule), RTO vs RPO และการรับมือเหตุการณ์ Ransomware (Backup, DR & Incident Response)', 'กฎเหล็กการสำรองข้อมูล 3-2-1-1-0 (Immutable/Air-gapped), ความต่างของ Full vs Incremental vs Differential Backup, การคำนวณค่า RPO vs RTO และขั้นตอนปฏิบัติการฉุกเฉินเมื่อเครื่องติด Ransomware', '# กลยุทธ์การสำรองข้อมูล (3-2-1 Backup Rule), RTO vs RPO และการรับมือเหตุการณ์ Ransomware

ในโลกของงานดูแลระบบ (SysAdmin / Infrastructure / Security Support) มีคำกล่าวอมตะว่า: ***"คนทำงานไอทีแบ่งออกเป็น 2 ประเภทเท่านั้น คือคนที่เคยข้อมูลหายมาแล้ว กับคนที่กำลังจะข้อมูลหาย!"*** และสิ่งที่แย่กว่าการไม่มี Backup คือ **การคิดไปเองว่ามี Backup แต่พอเกิดเหตุไฟไหม้หรือโดน Ransomware เรียกค่าไถ่ กลับกู้ข้อมูลคืนมาไม่ได้เลย!**

---

## 1. กฎเหล็กการสำรองข้อมูลสากล: 3-2-1 (และยุคใหม่ 3-2-1-1-0)

เพื่อป้องกันไม่ให้เหตุวิบัติจุดเดียว (Single Point of Failure) ทำลายทั้งข้อมูลจริงและข้อมูลสำรองไปพร้อมกัน มาตรฐานอุตสาหกรรมจึงกำหนด **กฎ 3-2-1-1-0** ไว้ดังนี้:

![แผนภาพกฎการสำรองข้อมูล 3-2-1-1-0 และการเปรียบเทียบ Full, Incremental, Differential Backup](/images/troubleshooting/backup-321-rule-types.png)

- **`3` Copies of Data (มีข้อมูลอย่างน้อย 3 ชุด)**:
  - ข้อมูลใช้งานจริงบน Production Server 1 ชุด + ข้อมูลสำรอง (Backup) อีกอย่างน้อย 2 ชุด
- **`2` Different Media (เก็บไว้บนสื่อหรืออุปกรณ์ต่างชนิดกันอย่างน้อย 2 แห่ง)**:
  - เช่น ชุดหนึ่งเก็บในอุปกรณ์ NAS ภายในห้องเซิร์ฟเวอร์ และอีกชุดเก็บในเทปแม่เหล็ก (LTO Tape) หรือ Cloud Object Storage (ป้องกันกรณี NAS พังทั้งตู้)
- **`1` Offsite Copy (เก็บไว้นอกสถานที่อย่างน้อย 1 ชุด)**:
  - เก็บไว้ที่ศูนย์สำรองข้อมูลต่างจังหวัด (DR Site) หรือบน Cloud (ป้องกันกรณีตึกสำนักงานใหญ่เกิดไฟไหม้หรือน้ำท่วม)
- **`1` Immutable or Air-Gapped Copy (มี 1 ชุดที่แก้ไข/ลบไม่ได้ หรือตัดขาดจากเครือข่าย)**:
  - **สำคัญที่สุดในยุค Ransomware!** เพราะมัลแวร์เรียกค่าไถ่ยุคใหม่จะวิ่งไปสั่งลบหรือเข้ารหัสไฟล์ใน NAS ที่ต่อแลนอยู่ด้วย จึงต้องมีสำเนาที่ตั้งค่า **Immutable (WORM — Write Once, Read Many ห้ามลบห้ามแก้ตามเวลาที่ล็อกไว้)** หรือถอดเทป/ดิสก์ออกจากเครือข่าย (**Offline / Air-Gapped**)
- **`0` Errors in Restore Verification (มีข้อผิดพลาดเป็น 0 จากการซ้อมกู้คืนจริง)**:
  - **Backup ที่ไม่เคยทดสอบ Restore จริง = ไม่มี Backup!** ต้องมีตารางซ้อมกู้คืนข้อมูล (Restore Drill) เป็นประจำทุกไตรมาส

---

## 2. เปรียบเทียบรูปแบบการสำรองข้อมูล: Full vs Incremental vs Differential

หากฐานข้อมูลมีขนาด 10 TB เราคงไม่สามารถก๊อปปี้ 10 TB เต็มๆ ทุกชั่วโมงได้ จึงต้องผสมผสานการทำ Backup 3 รูปแบบ:

| รูปแบบ Backup | สิ่งที่ถูกบันทึกในรอบนั้น | ความเร็วตอน Backup & พื้นที่ที่ใช้ | ความยากง่ายตอนกู้คืน (Restore) |
|---|---|---|---|
| **Full Backup** (เช่น ทำทุกวันอาทิตย์) | สำเนาข้อมูล **ทั้งหมดทุกไฟล์ (100%)** ในขณะนั้น | **ช้าที่สุด** และเปลืองพื้นที่จัดเก็บมากที่สุด | **กู้คืนง่ายและเร็วที่สุด** (ใช้ไฟล์ชุดเดียวจบ) |
| **Incremental Backup** (เช่น ทำทุกวัน จ.-ส.) | เก็บเฉพาะข้อมูลที่เปลี่ยนแปลง **"นับจากการทำ Backup ครั้งล่าสุดไม่ว่าจะเป็นแบบใด"** (เก็บเฉพาะส่วนต่างของวันต่อวัน) | **เร็วที่สุดและประหยัดพื้นที่ที่สุด!** | **กู้คืนซับซ้อนที่สุด**: ต้องใช้ก้อน Full ล่าสุด + ก้อน Incremental **ทุกวันเรียงตามลำดับ** (ถ้าไฟล์วันพุธเสีย ข้อมูลตั้งแต่วันพฤหัสไปจะกู้ไม่ได้!) |
| **Differential Backup** | เก็บข้อมูลที่เปลี่ยนแปลงสะสม **"นับจากการทำ Full Backup ครั้งล่าสุด"** | เร็วปานกลาง ขนาดไฟล์จะใหญ่ขึ้นเรื่อยๆ ในแต่ละวัน | **กู้คืนเร็วเป็นอันดับสอง**: ใช้แค่ **2 ก้อนเสมอ** คือ ก้อน Full ล่าสุด + ก้อน Differential ของวันล่าสุด |

---

## 3. RPO vs RTO: 2 ตัวชี้วัดที่ออกสอบสัมภาษณ์ทุกที่!

เมื่อออกแบบแผนกู้คืนระบบจากภัยพิบัติ (**DR — Disaster Recovery**) ผู้บริหารและทีมวิศวกรจะตกลงเกณฑ์วัดผล 2 ตัวนี้ร่วมกันเสมอ:

![เส้นเวลาเปรียบเทียบค่า RPO (ยอมเสียข้อมูลย้อนหลังได้แค่ไหน) กับ RTO (ต้องกู้ระบบเสร็จภายในเวลาเท่าใด)](/images/troubleshooting/rpo-vs-rto-timeline.png)

| ตัวชี้วัด | ชื่อเต็ม | ทิศทางบนเส้นเวลา | คำถามสำคัญที่ต้องตอบ | ตัวอย่างการนำไปออกแบบระบบจริง |
|---|---|---|---|---|
| **RPO** | **Recovery Point Objective** | **มองย้อนกลับไปในอดีต** (ก่อนเกิดเหตุ) | *"ธุรกิจยอมรับ **ปริมาณข้อมูลสูญหายย้อนหลัง** ได้มากที่สุดกี่นาที/กี่ชั่วโมง?"* | ถ้าธุรกิจกำหนด **RPO = 1 ชั่วโมง** ➔ แปลว่าคุณต้องตั้งเวลาทำ Backup หรือ Database Replication **อย่างน้อยทุกๆ 1 ชั่วโมง** (จะทำ Backup วันละครั้งตอนเที่ยงคืนไม่ได้เด็ดขาด!) |
| **RTO** | **Recovery Time Objective** | **มองไปข้างหน้า** (หลังเกิดเหตุจนระบบฟื้น) | *"เมื่อระบบล่มแล้ว **ต้องกู้ระบบให้กลับมาออนไลน์ใช้งานได้** ภายในเวลากี่นาที/กี่ชั่วโมง?"* | ถ้ากำหนด **RTO = 15 นาที** ➔ คุณจะมัวติดตั้ง OS ใหม่และดึงไฟล์จากเทปไม่ได้ ต้องทำระบบ **Hot Standby / Active-Passive Failover** ที่สลับระบบได้ในไม่กี่นาที |

---

## 4. ขั้นตอนรับมือฉุกเฉินเมื่อตรวจพบ Ransomware (First Responder Playbook)

หากผู้ใช้งานโทรแจ้ง Helpdesk ว่า *"หน้าจอขึ้นข้อความสีแดงเรียกค่าไถ่เป็น Bitcoin และไฟล์ในเครื่องเปลี่ยนนามสกุลเป็น `.locked` เปิดไม่ได้เลย!"* นี่คือลำดับสิ่งที่ต้องทำทันทีภายในวินาทีแรก:

1. **STEP 1 — ISOLATE IMMEDIATELY (ตัดการเชื่อมต่อเครือข่ายทันที!)**:
   - สั่งให้ผู้ใช้หรือช่าง **ดึงสาย LAN ออกทันที และกดปิด Wi-Fi / Bluetooth** (และหากรู้พอร์ตสวิตช์ ให้สั่ง `shutdown` พอร์ตนั้นทันที)
   - **เหตุผล**: เพื่อหยุดไม่ให้มัลแวร์วิ่งผ่านพอร์ต **SMB (445)** ไปเข้ารหัสทำลายไฟล์ในโฟลเดอร์แชร์ของแผนก (`\\server\share`) และเครื่องอื่นๆ ในวงแลน!
2. **STEP 2 — DO NOT PLUG IN USB / EXTERNAL BACKUP**:
   - ห้ามนำแฟลชไดรฟ์หรือ External Harddisk ที่มีไฟล์สำรองไปเสียบเข้าเครื่องที่ติดเชื้อเด็ดขาด เพราะมัลแวร์จะเข้ารหัสไฟล์ในไดรฟ์สำรองนั้นทันที
   - ตามมาตรฐาน Incident Response แนะนำให้ **ถอดสายเน็ตแต่ยังไม่ต้องรีบูตหรือล้างเครื่องทันที** เพื่อให้ทีม Security/SOC เข้ามาเก็บหลักฐาน (Forensic Artifacts / Memory Dump) หรือระบุสายพันธุ์ของแรนซัมแวร์ก่อน
3. **STEP 3 — DISABLE ACCOUNT & ESCALATE TO SOC**:
   - แจ้งหัวหน้าทีมและทีม Security (SOC) ทันที
   - สั่ง **Disable หรือ Reset รหัสผ่านบัญชี Active Directory** ของผู้ใช้เครื่องนั้น และสั่ง **Revoke Active Sessions** เพื่อป้องกันคนร้ายใช้บัญชีที่ขโมยไปขยายผลการโจมตี (Lateral Movement)
', 12, 'intermediate', 7, true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.lessons VALUES ('2f157328-48ee-496e-bcef-7afd1b6a8d1f', 1, 'linux-basics', 'พื้นฐาน Linux และการใช้งาน Terminal (pwd, ls, cd, cp, mv, rm, cat, less)', 'ปูพื้นฐานการใช้งาน Shell เส้นทางไฟล์แบบ Absolute/Relative คำสั่งจัดการไฟล์เบื้องต้น และข้อควรระวังหน้างานสำหรับ Support Tier 1', '
# พื้นฐาน Linux และการใช้งาน Terminal

ในการทำงานของทีม **Application Support และ NOC Tier 1** การรีโมตเข้าไปตรวจสอบเครื่องเซิร์ฟเวอร์ผ่านหน้าจอข้อความ (Command Line Interface) เป็นกิจวัตรประจำวัน ความแม่นยำในการระบุตำแหน่งโฟลเดอร์ การเปิดอ่านไฟล์อย่างปลอดภัย และการหลีกเลี่ยงคำสั่งที่อาจกระทบไฟล์ระบบ จะช่วยให้การตรวจสอบปัญหาเบื้องต้นรวดเร็วและไม่สร้างผลกระทบซ้ำซ้อน

---

## 1. แนวคิดและโครงสร้างพื้นฐาน

### 1.1 Terminal, Shell และ Prompt
- **Terminal**: โปรแกรมหน้าต่างที่ใช้รับคำสั่งและแสดงผลข้อความ
- **Shell**: ตัวแปลคำสั่ง (เช่น `bash` หรือ `zsh`) ที่รับข้อความจากผู้ใช้ไปสั่งงานระบบปฏิบัติการ
- **Prompt**: บรรทัดข้อความที่แสดงสถานะพร้อมรับคำสั่ง เช่น `support@app-prod-01:/var/log$`
  - `support` = ชื่อผู้ใช้ปัจจุบัน
  - `app-prod-01` = ชื่อเครื่อง (Hostname)
  - `/var/log` = โฟลเดอร์ที่กำลังเปิดอยู่ปัจจุบัน
  - `$` = สิทธิ์ผู้ใช้ทั่วไป (หากเป็น `#` หมายถึงสิทธิ์สูงสุด `root`)

### 1.2 โครงสร้างคำสั่งและเส้นทางไฟล์ (Path)
คำสั่ง Linux มีรูปแบบมาตรฐานคือ: `คำสั่ง [ตัวเลือก/Options] [อาร์กิวเมนต์/เป้าหมาย]` เช่น `ls -lah /var/log`

| ประเภทเส้นทาง (Path) | ลักษณะการเขียน | ตัวอย่าง | การใช้งานหน้างาน |
|---|---|---|---|
| **Absolute Path** | ขึ้นต้นด้วย `/` เสมอ (อ้างอิงจากรากสุดของระบบ) | `/var/log/nginx/error.log` | มั่นใจได้ว่าชี้ถูกตำแหน่งเสมอไม่ว่าจะยืนอยู่ที่โฟลเดอร์ใด เหมาะกับการรันคำสั่งสำคัญหรือส่งต่อใน Ticket |
| **Relative Path** | ไม่ขึ้นต้นด้วย `/` (อ้างอิงจากตำแหน่งปัจจุบัน `pwd`) | `./app.log`, `../config/env` | สะดวกเวลาทำงานอยู่ในโฟลเดอร์นั้นแล้ว (`.` คือโฟลเดอร์ปัจจุบัน, `..` คือโฟลเดอร์แม่ 1 ชั้น, `~` คือ Home ของผู้ใช้) |

### 1.3 ตัวช่วยประหยัดเวลาและ Wildcards
- **Tab Completion**: กดปุ่ม `Tab` เพื่อให้ Shell เติมชื่อไฟล์หรือคำสั่งให้อัตโนมัติ ลดโอกาสพิมพ์ชื่อไฟล์ผิด
- **Wildcard `*`**: แทนตัวอักษรใดๆ กี่ตัวก็ได้ เช่น `*.log` หมายถึงไฟล์ทุกตัวที่ลงท้ายด้วย `.log`
- **Wildcard `?`**: แทนตัวอักษรใดๆ เพียง 1 ตัวอักษร เช่น `app-0?.log` จะตรงกับ `app-01.log`, `app-02.log`

---

## 2. ตารางสรุป / คำสั่งที่ใช้งานจริง

| หมวดหมู่ | คำสั่ง | หน้าที่หลักในงาน Support |
|---|---|---|
| **สำรวจตำแหน่ง** | `pwd` | แสดงเส้นทางเต็มของโฟลเดอร์ที่ยืนอยู่ปัจจุบัน (Print Working Directory) |
| **ดูรายการไฟล์** | `ls -lah` | แสดงรายการไฟล์ทั้งหมด (`-a` รวมไฟล์ซ่อนที่ขึ้นต้นด้วย `.`), แบบละเอียด (`-l`), ขนาดอ่านง่าย (`-h`) |
| **เปลี่ยนโฟลเดอร์** | `cd <path>` | ย้ายไปยังโฟลเดอร์เป้าหมาย (`cd -` ย้อนกลับโฟลเดอร์ก่อนหน้า, `cd ~` กลับ Home) |
| **จัดการไฟล์/โฟลเดอร์** | `cp`, `mv`, `mkdir`, `touch` | คัดลอกไฟล์ (`cp -r` สำหรับโฟลเดอร์), ย้ายหรือเปลี่ยนชื่อ (`mv`), สร้างโฟลเดอร์ (`mkdir -p`), สร้างไฟล์เปล่า/อัปเดตเวลา (`touch`) |
| **ลบไฟล์** | `rm` | ลบไฟล์ (`rm -i` ให้ถามยืนยันก่อนลบ) |
| **เปิดอ่านเนื้อหา** | `cat`, `less`, `head`, `tail` | แสดงทั้งไฟล์ (`cat`), เปิดอ่านทีละหน้าสำหรับไฟล์ใหญ่ (`less`), ดูบรรทัดแรก (`head -n 20`), ดูบรรทัดท้าย (`tail -n 50`) |
| **คู่มือและประวัติ** | `man <cmd>`, `<cmd> --help`, `history` | เปิดคู่มือการใช้งานคำสั่ง (`man`), ดูสรุปตัวเลือกย่อ (`--help`), ดูประวัติคำสั่งที่เคยรัน (`history`) |

### ตัวอย่างการสำรวจไฟล์และอ่าน Log เบื้องต้น (ตัวอย่างประกอบ)

```bash
$ pwd
/home/support

$ cd /var/log/nginx
$ pwd
/var/log/nginx

$ ls -lah
total 125M
drwxr-xr-x  2 root adm  4.0K Nov  3 10:00 .
drwxrwxr-x 11 root syslog 4.0K Nov  3 06:25 ..
-rw-r-----  1 www-data adm  120M Nov  3 10:14 access.log
-rw-r-----  1 www-data adm  4.8M Nov  3 10:12 error.log

$ tail -n 3 error.log
2026/11/03 10:11:02 [error] 1042#1042: *881 connect() failed (111: Connection refused) while connecting to upstream
2026/11/03 10:11:45 [warn] 1042#1042: *895 an upstream response is buffered to a temporary file
2026/11/03 10:12:10 [error] 1042#1042: *902 upstream timed out (110: Connection timed out) while reading response header
```

> ⚠️ **คำเตือนสำคัญ**: ห้ามรันคำสั่ง `rm -rf` บนเซิร์ฟเวอร์ Production โดยไม่จำเป็น โดยเฉพาะการใช้คู่กับ `*` หรือการเว้นวรรคผิด เช่น `rm -rf / tmp/cache` เพราะจะสั่งลบไฟล์โดยไม่ถามยืนยันและไม่สามารถกู้คืนได้ ก่อนลบไฟล์ใดๆ ต้องรัน `pwd` และ `ls` ตรวจสอบให้แน่ใจทุกครั้ง

> **Support Tip**: หากต้องเปิดดูไฟล์ Log ขนาดใหญ่หลายร้อย MB ห้ามใช้ `cat` เพราะข้อความจะไหลทะลักเต็มหน้าจอและกินหน่วยความจำ ให้ใช้ `less error.log` (กด `/` เพื่อค้นหาคำ, กด `q` เพื่อออก) หรือใช้ `tail -n 50 error.log` เพื่อดูเฉพาะเหตุการณ์ล่าสุด

---

## 3. กรณีศึกษาและวิธีแก้ปัญหาหน้างาน (Troubleshooting)

| อาการที่พบ | สาเหตุที่เป็นไปได้ | วิธีตรวจสอบ / ขั้นตอนทำต่อ | ข้อมูลที่ต้องเก็บก่อน Escalate |
|---|---|---|---|
| รันคำสั่งเปิดไฟล์แล้วขึ้น `No such file or directory` | 1. พิมพ์ชื่อไฟล์ผิด (Linux แยกตัวพิมพ์เล็ก-ใหญ่ เช่น `App.log` กับ `app.log` คนละไฟล์)<br>2. ใช้ Relative Path ขณะยืนอยู่ผิดโฟลเดอร์ | 1. รัน `pwd` ดูว่ายืนอยู่ที่ไหน<br>2. รัน `ls -la` ดูชื่อไฟล์จริง และใช้ปุ่ม `Tab` ช่วยเติมชื่อไฟล์ | เส้นทางเต็ม (`pwd`) และผลลัพธ์จาก `ls -la` ในโฟลเดอร์ที่คาดว่าจะมีไฟล์นั้น |
| รันคำสั่งแล้วขึ้น `command not found` | 1. พิมพ์คำสั่งผิด<br>2. โปรแกรมนั้นไม่ได้ติดตั้งไว้ หรือไม่อยู่ในตัวแปร `PATH` ของผู้ใช้ | ตรวจตัวสะกด หรือลองเรียกผ่านพาธเต็ม เช่น `/usr/sbin/ip` | คำสั่งที่รัน ชื่อผู้ใช้ (`whoami`) และข้อความ Error เต็ม |
| จำไม่ได้ว่าคำสั่งต้องใส่ Option ตัวไหน (เช่น อยากเรียงไฟล์ตามเวลาล่าสุด) | คำสั่งมีตัวเลือกจำนวนมาก | รัน `man ls` หรือ `ls --help` เพื่อค้นหา Option (เช่นพบว่า `ls -lt` เรียงตามเวลาแก้ไขล่าสุด) | ไม่ต้อง Escalate (สามารถค้นจากคู่มือในเครื่องได้ทันที) |
| ต้องการสำรองไฟล์คอนฟิกก่อนให้ทีม Tier 2 เข้ามาตรวจสอบ | ป้องกันไฟล์ต้นฉบับเสียหายระหว่างการทดสอบ | ใช้ `cp -p app.conf app.conf.bak_20261103` (`-p` ช่วยคงสิทธิ์และเวลาเดิมของไฟล์ไว้) | พาธของไฟล์ต้นฉบับและไฟล์สำรองที่สร้างไว้ |

---

## สรุป
- ตรวจสอบตำแหน่งปัจจุบันด้วย `pwd` และดูรายละเอียดไฟล์ด้วย `ls -lah` เสมอก่อนดำเนินการใดๆ
- เข้าใจความต่างระหว่าง **Absolute Path** (ขึ้นต้นด้วย `/`) และ **Relative Path** เพื่อป้องกันการอ้างอิงผิดไฟล์
- เลือกใช้ `less`, `head`, `tail` แทน `cat` เมื่อต้องเปิดอ่านไฟล์ Log ขนาดใหญ่บน Production
- ใช้ `man` หรือ `--help` เมื่อไม่มั่นใจ Option ของคำสั่ง และหลีกเลี่ยงการใช้ `rm -rf` ในงาน Tier 1

## อ้างอิง
- คู่มือในระบบ: `man bash`, `man ls`, `man cp`, `man rm`, `man less`, `man tail`
- GNU Coreutils Manual: https://www.gnu.org/software/coreutils/manual/
', 8, 'beginner', 1, true, '2026-11-03 10:24:40.983748+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.lessons VALUES ('adeaa019-95a7-4877-8d5a-94c875441152', 1, 'linux-file-system', 'โครงสร้างไดเรกทอรีและการจัดการไฟล์ (find, stat, file, ln -s, du)', 'ทำความเข้าใจโครงสร้างไดเรกทอรีมาตรฐานบน Linux ไฟล์คอนฟิกสำคัญที่งาน Support ต้องเปิดอ่าน และการค้นหาไฟล์ด้วย find', '
# โครงสร้างไดเรกทอรีและการจัดการไฟล์บน Linux

เมื่อเกิดเหตุแจ้งเตือน (Alert) เช่น พื้นที่ดิสก์เต็ม หรือแอปพลิเคชันอ่านค่าคอนฟิกผิดพลาด เจ้าหน้าที่ **Application Support / NOC Tier 1** ต้องทราบว่าไฟล์คอนฟิก ไฟล์ Log และตัวโปรแกรมถูกจัดเก็บไว้ที่ไดเรกทอรีใด รวมถึงใช้คำสั่งค้นหาไฟล์ที่มีขนาดใหญ่หรือเพิ่งถูกแก้ไขก่อนเกิดปัญหาได้อย่างแม่นยำ

---

## 1. แนวคิดและโครงสร้างพื้นฐาน

### 1.1 โครงสร้างไดเรกทอรีมาตรฐาน (Filesystem Hierarchy Standard - FHS)
บน Linux ทุกไฟล์และพาร์ทิชันเริ่มต้นจากรากเดียวกันคือ `/` (Root Directory) โดยมีโฟลเดอร์สำคัญดังนี้:

| ไดเรกทอรี | หน้าที่และสิ่งที่เก็บภายใน | ความสำคัญต่อสาย Support |
|---|---|---|
| `/` | รากสุดของระบบไฟล์ทั้งหมด (Root Directory) | จุดเริ่มต้นของ Absolute Path ทุกเส้นทาง |
| `/etc` | ไฟล์ตั้งค่า (Configuration) ของระบบและบริการต่างๆ | ใช้เปิดอ่านไฟล์ตั้งค่า เช่น `/etc/hosts`, `/etc/nginx/nginx.conf` |
| `/var` | ข้อมูลที่มีการเปลี่ยนแปลงขนาดตลอดเวลา (Variable data) | เก็บฐานข้อมูล แคช สปูล และโดยเฉพาะ `/var/log` ที่มักเต็มบ่อยที่สุด |
| `/var/log` | ไฟล์บันทึกเหตุการณ์ (System & Application Logs) | จุดแรกที่ต้องเข้าไปตรวจสอบเมื่อระบบหรือบริการมีปัญหา |
| `/home` | พื้นที่ส่วนตัวของผู้ใช้ทั่วไป เช่น `/home/support` | ที่เก็บไฟล์สคริปต์ส่วนตัว หรือไฟล์ชั่วคราวที่อัปโหลดเข้ามาตรวจสอบ |
| `/opt` | โปรแกรมเสริมหรือซอฟต์แวร์ขององค์กรที่ติดตั้งแยกต่างหาก | แอปพลิเคชันภายในองค์กรหรือ Agent มอนิเตอร์มักติดตั้งอยู่ที่นี่ |
| `/tmp` | ไฟล์ชั่วคราว (Temporary files) ที่ทุกโปรเซสเขียนได้ | แอปมักสร้างไฟล์พักที่นี่ และไฟล์อาจถูกล้างเมื่อรีบูตเครื่อง |
| `/usr` | โปรแกรมคำสั่งและไลบรารีของระบบ (`/usr/bin`, `/usr/lib`) | ที่อยู่ของคำสั่งมาตรฐานส่วนใหญ่ที่เรียกใช้งาน |

### 1.2 ไฟล์ Configuration พื้นฐานที่ต้องอ่านให้เป็น (ห้ามแก้ไขเองในระดับ Tier 1)
1. **`/etc/hostname`**: เก็บชื่อเครื่องเซิร์ฟเวอร์ปัจจุบัน
2. **`/etc/hosts`**: ไฟล์จับคู่ IP Address กับชื่อโดเมนภายในเครื่อง (ระบบจะอ่านไฟล์นี้ก่อนถาม DNS เสมอ)
3. **`/etc/resolv.conf`**: ระบุ IP ของ DNS Nameserver ที่เครื่องใช้แปลงชื่อโดเมน (บรรทัด `nameserver`)
4. **`/etc/fstab`**: กำหนดรายการดิสก์และพาร์ทิชันที่จะถูก Mount อัตโนมัติเมื่อเปิดเครื่อง

### 1.3 Symbolic Link (Soft Link) เทียบกับ Hard Link
- **Symbolic Link (`ln -s <ต้นทาง> <ชื่อลิงก์>`)**: เสมือนไฟล์ทางลัด (Shortcut) ที่ชี้ไปยังเส้นทางของไฟล์จริง ข้ามพาร์ทิชันได้และชี้ไปยังโฟลเดอร์ได้ หากไฟล์ต้นทางถูกลบ ลิงก์จะกลายเป็น **Broken Link (ลิงก์เสีย)**
- **Hard Link (`ln <ต้นทาง> <ชื่อลิงก์>`)**: ชี้ไปยังหมายเลข Inode เดียวกันบนดิสก์โดยตรง หากลบชื่อไฟล์ต้นทาง ข้อมูลยังอยู่ตราบใดที่ยังมี Hard Link เหลืออยู่ (ใช้ข้ามพาร์ทิชันไม่ได้)

---

## 2. ตารางสรุป / คำสั่งที่ใช้งานจริง

| คำสั่ง | ตัวอย่างการใช้งาน | คำอธิบายสำหรับหน้างาน |
|---|---|---|
| `find <path> -name` | `find /var/log -name "*.log"` | ค้นหาไฟล์ตามชื่อ (`-iname` หากไม่สนใจตัวพิมพ์เล็ก-ใหญ่) |
| `find <path> -size` | `find /var -type f -size +100M` | ค้นหาเฉพาะไฟล์ (`-type f`) ที่มีขนาดใหญ่กว่า 100 MB |
| `find <path> -mmin` | `find /etc/nginx -mmin -60` | ค้นหาไฟล์ที่ถูกแก้ไขเนื้อหาภายใน 60 นาทีที่ผ่านมา (เช็กว่าใครเพิ่งแก้คอนฟิก) |
| `stat <file>` | `stat /etc/hosts` | ดูเวลา Access, Modify (แก้เนื้อหา), Change (แก้สิทธิ์/เจ้าของ) และเลข Inode อย่างละเอียด |
| `file <file>` | `file backup_data` | ตรวจสอบชนิดที่แท้จริงของไฟล์ (เช่น ASCII text, gzip compressed, ELF binary) โดยไม่อิงนามสกุล |
| `du -sh <path>` | `du -sh /var/log/*` | สรุปขนาดพื้นที่ที่ใช้จริงของแต่ละไฟล์หรือโฟลเดอร์ในหน่วยอ่านง่าย |
| `ln -s <target> <link>` | `ln -s /opt/releases/v2 /opt/current` | สร้าง Symbolic Link (นิยมใช้ชี้เวอร์ชันแอปพลิเคชันปัจจุบัน) |

### ตัวอย่างการค้นหาไฟล์และตรวจสอบ Symbolic Link (ตัวอย่างประกอบ)

```bash
# 1. ค้นหาไฟล์ที่มีขนาดเกิน 500MB ใน /var/log
$ find /var/log -type f -size +500M
/var/log/nginx/access.log
/var/log/app/worker-debug.log

# 2. ค้นหาไฟล์คอนฟิกใน /etc/nginx ที่เพิ่งถูกแก้ไขในรอบ 30 นาทีที่ผ่านมา
$ find /etc/nginx -type f -mmin -30
/etc/nginx/conf.d/upstream.conf

# 3. ตรวจสอบเวลาแก้ไขและสิทธิ์อย่างละเอียดด้วย stat
$ stat /etc/nginx/conf.d/upstream.conf
  File: /etc/nginx/conf.d/upstream.conf
  Size: 412       	Blocks: 8          IO Block: 4096   regular file
Device: 801h/2049d	Inode: 524312      Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2026-11-03 14:10:05.112000000 +0700
Modify: 2026-11-03 14:09:50.408000000 +0700
Change: 2026-11-03 14:09:50.412000000 +0700

# 4. ตรวจสอบ Symbolic Link ของแอปพลิเคชัน
$ ls -l /opt/app/current
lrwxrwxrwx 1 deploy deploy 24 Nov  3 13:00 /opt/app/current -> /opt/app/releases/v1.4.2
```

> ⚠️ **คำเตือนสำคัญ**: ห้ามแก้ไขไฟล์ `/etc/fstab`, `/etc/resolv.conf` หรือ `/etc/hosts` บนเครื่อง Production โดยพลการ เพราะการพิมพ์ผิดใน `/etc/fstab` อาจทำให้เซิร์ฟเวอร์บูตไม่ขึ้นในรอบถัดไป หน้าที่ของ Tier 1 คือเปิดอ่าน (`cat` หรือ `less`) เพื่อยืนยันค่าและรวบรวมข้อมูลส่งต่อเท่านั้น

> **Support Tip**: ถ้ารัน `find / ...` ด้วยสิทธิ์ผู้ใช้ทั่วไป จะมีข้อความ `Permission denied` ปนออกมาจำนวนมาก ให้ต่อท้ายคำสั่งด้วย `2>/dev/null` เช่น `find /var -type f -size +100M 2>/dev/null` เพื่อกรองข้อความแจ้งเตือนสิทธิ์ออกไปให้เหลือเฉพาะผลลัพธ์ที่อ่านง่าย

---

## 3. กรณีศึกษาและวิธีแก้ปัญหาหน้างาน (Troubleshooting)

| อาการที่พบ | สาเหตุที่เป็นไปได้ | วิธีตรวจสอบ / ขั้นตอนทำต่อ | ข้อมูลที่ต้องเก็บก่อน Escalate |
|---|---|---|---|
| ระบบ শুরুเกิด Error หลังเวลา 14:00 น. โดยไม่มีแจ้ง Deploy ในตารางงาน | มีการแก้ไขไฟล์คอนฟิกหรือไฟล์ระบบบางตัวโดยตรงบนเครื่อง | รัน `find /etc /opt/app -type f -mmin -120` เพื่อหาไฟล์ที่ถูกแก้ไขใน 2 ชั่วโมงล่าสุด และรัน `stat` ดูเวลา `Modify` ที่ชัดเจน | รายชื่อไฟล์ที่เพิ่งถูกแก้ไข + ผลลัพธ์จาก `stat <file>` |
| แอปพลิเคชันแจ้ง `File not found` ทั้งที่เห็นชื่อไฟล์ลิงก์อยู่ในโฟลเดอร์ | Symbolic Link ชี้ไปยังโฟลเดอร์หรือไฟล์ปลายทางที่ถูกลบไปแล้ว (Broken Symlink) | รัน `ls -la` ดูว่าปลายทางหลังลูกศร `->` มีอยู่จริงหรือไม่ หรือใช้ `file <ชื่อลิงก์>` (จะฟ้องว่า `broken symbolic link to ...`) | ผลลัพธ์ `ls -la` ของลิงก์ และผลตรวจสอบโฟลเดอร์ปลายทาง |
| เรียกชื่อโดเมนภายในแล้วได้ IP ผิด ไม่ตรงกับ DNS Server กลาง | มีการผูก IP แบบตายตัวค้างไว้ในไฟล์ `/etc/hosts` ของเครื่องนั้น | รัน `cat /etc/hosts` และ `cat /etc/resolv.conf` เพื่อตรวจค่าที่ตั้งไว้ในเครื่อง | เนื้อหาใน `/etc/hosts` และ `/etc/resolv.conf` |
| แตกไฟล์ `.tar.gz` ไม่ผ่านและฟ้องว่า `not in gzip format` | ไฟล์ที่ดาวน์โหลดมาอาจเป็นหน้า HTML Error หรือเป็นไฟล์ชนิดอื่นที่ตั้งนามสกุลผิด | รัน `file <ชื่อไฟล์>` เพื่อดูชนิดไฟล์จริง (เช่นอาจพบว่าเป็น `HTML document` หรือ `POSIX tar archive`) | ผลลัพธ์จากคำสั่ง `file` และ `ls -lh` ของไฟล์นั้น |

---

## สรุป
- จำตำแหน่งสำคัญให้แม่น: `/etc` เก็บคอนฟิก, `/var/log` เก็บไฟล์ Log, `/opt` มักเก็บแอปพลิเคชันเสริม, `/tmp` เก็บไฟล์ชั่วคราว
- ใช้ `find` ค้นหาไฟล์ตามชื่อ (`-name`), ขนาด (`-size +100M`), หรือเวลาที่เพิ่งแก้ไข (`-mmin -60`)
- ใช้ `stat` เพื่อดู Timestamp การแก้ไขที่แม่นยำ และใช้ `file` เพื่อตรวจสอบประเภทไฟล์จริง
- ตรวจสอบ Symbolic Link ด้วย `ls -l` หรือ `file` เสมอเมื่อสงสัยปัญหา Broken Link

## อ้างอิง
- คู่มือในระบบ: `man hier`, `man find`, `man stat`, `man file`, `man ln`, `man du`
- Filesystem Hierarchy Standard (FHS) 3.0 Specification
', 9, 'beginner', 2, true, '2026-11-03 10:24:40.983748+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.lessons VALUES ('b1a10001-0000-0000-0000-000000000001', 1, 'linux-permissions', 'การจัดการสิทธิ์และ Permission ไฟล์ (chmod, chown, umask)', 'เจาะลึกระบบสิทธิ์ rwx บน Linux การคำนวณเลข Octal และกรณีศึกษาที่พบบ่อยในงาน Support', '
# การจัดการสิทธิ์ไฟล์และโฟลเดอร์บน Linux

ในฐานะสาย Support ปัญหา **Permission Denied** คือหนึ่งในเคสที่พบบ่อยที่สุด การเข้าใจโครงสร้างสิทธิ์ของ Linux อย่างถ่องแท้จะช่วยให้แก้ปัญหาได้อย่างรวดเร็วและปลอดภัย

---

## 1. โครงสร้างสิทธิ์ 3 กลุ่ม (User / Group / Others)
เมื่อใช้คำสั่ง `ls -l` จะเห็นสตริงสิทธิ์ 10 หลัก เช่น:
`-rwxr-xr-- 1 appuser devteam 4096 Nov 3 12:00 script.sh`

- **หลักที่ 1**: ประเภทไฟล์ (`-` ไฟล์ธรรมดา, `d` ไดเรกทอรี, `l` symlink)
- **หลักที่ 2-4 (User/Owner)**: สิทธิ์ของเจ้าของไฟล์ (`rwx` = อ่าน, เขียน, สั่งรัน)
- **หลักที่ 5-7 (Group)**: สิทธิ์ของกลุ่ม (`r-x` = อ่าน และสั่งรันได้ ห้ามแก้ไข)
- **หลักที่ 8-10 (Others)**: สิทธิ์ของผู้ใช้อื่นๆ ในระบบ (`r--` = อ่านได้อย่างเดียว)

---

## 2. การคำนวณ Octal Number (ตัวเลขฐานแปด)
แต่ละสิทธิ์มีค่าน้ำหนักตัวเลขดังนี้:
- `r` (Read) = **4**
- `w` (Write) = **2**
- `x` (Execute) = **1**

### ตัวอย่างสิทธิ์ยอดนิยม:
| เลข | สิทธิ์ | การใช้งานทั่วไป |
|---|---|---|
| **755** | `rwxr-xr-x` | สคริปต์, ไดเรกทอรีเว็บ, Binary (เจ้าของเขียนได้ คนอื่นอ่าน+รัน) |
| **644** | `rw-r--r--` | ไฟล์คอนฟิกทั่วไป, รูปภาพ, ไฟล์ HTML/Text |
| **600** | `rw-------` | กุญแจส่วนตัว เช่น `~/.ssh/id_rsa`, ไฟล์รหัสผ่าน |
| **777** | `rwxrwxrwx` | สิทธิ์เปิดกว้างสูงสุด (ทุกคนอ่าน เขียน และรันได้) |

> ⚠️ **คำเตือนความปลอดภัย (Warning)**: สิทธิ์ 777 (`rwxrwxrwx`) เป็นสิทธิ์ที่อันตรายมาก! ทุกคนสามารถแก้ไขและลบไฟล์ได้ ห้ามนำมาใช้เพื่อแก้ปัญหาขัดตาทัพในระบบ Production เด็ดขาด

---

## 3. คำสั่งสำคัญในงาน Support
1. **เปลี่ยนสิทธิ์**: `chmod 755 /var/www/html` หรือ `chmod -R 644 /var/www/html/*.php`
2. **เปลี่ยนเจ้าของ**: `chown nginx:nginx /var/log/nginx/access.log`
3. **ตรวจสอบสิทธิ์**: `namei -l /path/to/file` (ตรวจสอบสิทธิ์ทีละโฟลเดอร์ตั้งแต่ root จนถึงไฟล์ปลายทาง มีประโยชน์มากเมื่อเจอปัญหาสิทธิ์เข้าถึงโฟลเดอร์แม่)

> **Support Tip**: สิทธิ์ `x` (Execute) บนโฟลเดอร์หมายถึง "สิทธิ์ในการ cd เข้าไปข้างใน" หากโฟลเดอร์มีแค่ `r` แต่อยากเปิดอ่านไฟล์ข้างใน ระบบจะแจ้ง *Permission Denied* ทันที
', 7, 'beginner', 3, true, '2026-11-03 09:22:14.247234+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.lessons VALUES ('b1a10001-0000-0000-0000-000000000005', 1, 'linux-process-and-resources', 'การตรวจวัด CPU, RAM, Disk และจัดการ Process (ps, top, kill, df, free)', 'วิธีวิเคราะห์เมื่อ Server อืด Disk เต็ม หรือแอปพลิเคชันเกิด Zombie / Deadlock Process', '# การตรวจสอบ Process และ System Resources

เมื่อลูกค้าแจ้งว่า **"Server ช้ามาก เข้าเว็บไม่ได้"** หรือเกิด Alarm แจ้งเตือน Disk Full สิ่งที่ Support ต้องทำคือ:

---

## 1. ตรวจสอบ Memory และ Swap
```bash
# แสดง Memory แบบอ่านง่าย (MB/GB)
free -h
```
- **total**: หน่วยความจำทั้งหมด
- **used**: หน่วยความจำที่โปรแกรมใช้งานจริง
- **buff/cache**: หน่วยความจำที่ Linux นำไปพักแคชไฟล์ (ระบบจะคืนให้อัตโนมัติเมื่อแอปต้องการ)
- **available**: หน่วยความจำที่พร้อมให้โปรแกรมใหม่ใช้งานได้จริง (ดูตัวเลขนี้เป็นหลัก)

---

## 2. ตรวจสอบ Disk Space และ Inodes
```bash
# ตรวจสอบพื้นที่ดิสก์ในแต่ละ Mount point
df -h

# ตรวจสอบจำนวน Inode (บ่อยครั้งดิสก์ยังเหลือ แต่สร้างไฟล์ไม่ได้เพราะ Inode เต็ม!)
df -i

# หาโฟลเดอร์ที่กินพื้นที่มากที่สุด 10 อันดับแรกใน /var
du -sh /var/* | sort -hr | head -n 10
```

---

## 3. จัดการ Process ที่มีปัญหา
```bash
# ค้นหา Process ID (PID) ของโปรแกรม
ps aux | grep node
pgrep -fl python

# ปิด Process อย่างสุภาพ (SIGTERM - รหัส 15 ให้โปรแกรมเคลียร์งานก่อนปิด)
kill 12345

# บังคับปิดทันทีเมื่อ Process ค้างไม่ตอบสนอง (SIGKILL - รหัส 9)
kill -9 12345
```

> **Support Tip (กรณีศึกษา Disk Full แต่ลบไฟล์แล้วพื้นที่ไม่คืน)**:
หากลบไฟล์ Log ขนาด 50GB ไปแล้วแต่ `df -h` ยังฟ้องว่าเต็ม 100% มักเกิดจาก **โปรแกรมยังคงเปิดไฟล์นั้นค้างอยู่ (Held open)** ให้รัน `lsof | grep deleted` เพื่อหาว่า Process ไหนถือไฟล์อยู่ แล้วสั่ง reload หรือ restart Service นั้น', 8, 'intermediate', 4, true, '2026-11-03 09:22:14.247234+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.lessons VALUES ('b1a10001-0000-0000-0000-000000000002', 1, 'linux-services-and-systemctl', 'การจัดการ Service ด้วย systemctl และสืบค้น Log ด้วย journalctl', 'คู่มือการสั่งการ Systemd Services การตรวจสอบสถานะ Failed และการกรอง System Log เมื่อระบบมีปัญหา', '# การจัดการ Systemd Service และการวิเคราะห์ Log

บน Linux สมัยใหม่ (Ubuntu, RHEL, CentOS, Debian) ระบบจัดการ Service หลักคือ **systemd**

---

## 1. คำสั่งควบคุม Service ด้วย `systemctl`
- ตรวจสอบสถานะ: `systemctl status nginx`
- เริ่ม/หยุด/รีสตาร์ท: `systemctl start | stop | restart nginx`
- โหลดคอนฟิกใหม่โดยไม่ตัดการเชื่อมต่อ: `systemctl reload nginx`
- เปิด/ปิดให้รันอัตโนมัติเมื่อบูตเครื่อง: `systemctl enable | disable nginx`
- ค้นหา Service ที่สถานะ Failed: `systemctl --failed`

---

## 2. การสืบค้น Log อย่างมือโปรด้วย `journalctl`
เมื่อ Service สตาร์ทไม่ติด (`Active: failed`) ห้ามเดา ให้เปิด Log ทันที:
```bash
# ดู Log ล่าสุดของ Service นั้นๆ แบบเรียลไทม์ (Follow)
journalctl -u nginx -f

# ดู Log ของ Service เฉพาะรอบการบูตปัจจุบัน (Current Boot)
journalctl -u nginx -b

# ดูเฉพาะ Log ระดับ Error ขึ้นไป
journalctl -u nginx -p err

# ดู Log ย้อนหลัง 30 นาที
journalctl -u nginx --since "30 minutes ago"
```

> **Support Tip**: หากรัน `systemctl restart nginx` แล้วแจ้งเตือนว่า "Job for nginx.service failed" ให้ทดสอบคอนฟิกด้วย `nginx -t` ทันที มักเกิดจากเครื่องหมายเซมิโคลอน `;` หาย หรือพอร์ตชน', 6, 'beginner', 6, true, '2026-11-03 09:22:14.247234+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.lessons VALUES ('f96ce3b7-1a44-4b37-b45c-aa3ee895c375', 1, 'linux-text-tools', 'การค้นหาและกรองข้อความจากไฟล์ Log (grep, pipe, awk, sort, uniq, wc)', 'เทคนิคการใช้ Pipe และ Redirection ร่วมกับ grep, awk, sort, uniq เพื่อค้นหา Error และสรุปสถิติจากไฟล์ Log หน้างาน', '
# การค้นหาและกรองข้อความจากไฟล์ Log

ไฟล์ Log บนเซิร์ฟเวอร์ Production มักมีความยาวหลายแสนบรรทัด การเปิดอ่านด้วยตาเปล่าทีละบรรทัดจึงไม่สามารถทำได้ทันเวลาเมื่อเกิด Incident เจ้าหน้าที่ **Application Support และ NOC Tier 1** จึงต้องใช้เครื่องมือกรองข้อความอย่าง `grep`, `awk`, `sort`, `uniq` และ `wc` เชื่อมต่อกันผ่านเครื่องหมาย **Pipe (`|`)** เพื่อสกัดเฉพาะบรรทัดที่เกิดปัญหา นับจำนวน Error หรือหา IP ที่ยิงเข้ามาผิดปกติภายในไม่กี่วินาที

---

## 1. แนวคิดและโครงสร้างพื้นฐาน

### 1.1 Standard Streams, Pipe (`|`) และ Redirection
ทุกคำสั่งบน Linux มีช่องทางรับ-ส่งข้อมูลมาตรฐาน 3 ช่องทาง:
1. **`stdin` (0)**: ข้อมูลขาเข้า (Standard Input)
2. **`stdout` (1)**: ผลลัพธ์ปกติขาออก (Standard Output)
3. **`stderr` (2)**: ข้อความแจ้งเตือนข้อผิดพลาดขาออก (Standard Error)

| สัญลักษณ์ | ชื่อเรียก | การทำงาน | ตัวอย่างการใช้งานจริง |
|---|---|---|---|
| `\|` | **Pipe** | ส่งผลลัพธ์ (`stdout`) ของคำสั่งซ้าย ไปเป็นข้อมูลขาเข้า (`stdin`) ของคำสั่งขวา | `cat access.log \| grep "500"` |
| `>` | **Redirect (Overwrite)** | เขียนผลลัพธ์ลงไฟล์ใหม่ (**ทับเนื้อหาเดิมทั้งหมดทันที**) | `grep "ERROR" app.log > error_today.txt` |
| `>>` | **Redirect (Append)** | เขียนผลลัพธ์ต่อท้ายไฟล์เดิม โดยไม่ลบข้อมูลเก่า | `echo "Checked at 10:00" >> notes.txt` |
| `2>&1` | **Merge stderr to stdout** | รวมข้อความ Error (`2`) เข้ากับผลลัพธ์ปกติ (`1`) เพื่อเก็บลงไฟล์เดียวกัน | `./script.sh > run.log 2>&1` |

> ⚠️ **คำเตือนสำคัญ**: ห้ามใช้เครื่องหมาย `>` (ลูกศรเดียว) ชี้ไปยังไฟล์คอนฟิกหรือไฟล์ที่ต้องการเก็บข้อมูลเดิมไว้ เพราะ `>` จะล้างข้อมูลเก่าในไฟล์ปลายทางทิ้งทันทีตั้งแต่เริ่มรันคำสั่ง หากต้องการเขียนต่อท้ายให้ใช้ `>>` และเมื่อบันทึกไฟล์หลักฐานก่อน Escalate ให้เขียนลงใน `/tmp/` หรือโฟลเดอร์ Home ของตนเองเสมอ

---

## 2. ตารางสรุป / คำสั่งที่ใช้งานจริง

### 2.1 ตัวเลือกสำคัญของ `grep`
| คำสั่ง / ตัวเลือก | ความหมาย | ตัวอย่าง |
|---|---|---|
| `grep "คำค้น" <file>` | ค้นหาบรรทัดที่มีข้อความตรงกัน (แยกตัวพิมพ์เล็ก-ใหญ่) | `grep "Timeout" app.log` |
| `-i` | ไม่สนใจตัวพิมพ์เล็ก-ใหญ่ (Case-insensitive) | `grep -i "error" app.log` |
| `-n` | แสดงเลขบรรทัดกำกับข้างหน้า | `grep -n "Exception" app.log` |
| `-r` | ค้นหาทุกไฟล์ในโฟลเดอร์และโฟลเดอร์ย่อย (Recursive) | `grep -rn "db-prod-01" /etc/nginx/` |
| `-v` | กรองเอาเฉพาะบรรทัดที่ **ไม่มี** คำนั้น (Invert match) | `grep -v "healthcheck" access.log` |
| `-E` | ใช้ Extended Regex เช่น ค้นหาหลายคำพร้อมกันด้วย `\|` | `grep -E "ERROR\|FATAL\|CRITICAL" app.log` |
| `-C <N>` | แสดงบรรทัดก่อนหน้าและหลังบรรทัดที่พบอย่างละ `N` บรรทัด (Context) | `grep -C 3 "OutOfMemory" app.log` |

### 2.2 คำสั่งตัดคอลัมน์ นับจำนวน และจัดกลุ่ม
| คำสั่ง | หน้าที่หลัก | ตัวอย่างการใช้งาน |
|---|---|---|
| `tail -f <file>` | ติดตามบรรทัดใหม่ที่เขียนลงไฟล์แบบเรียลไทม์ | `tail -f /var/log/nginx/error.log \| grep -i "refused"` |
| `wc -l` | นับจำนวนบรรทัดทั้งหมด | `grep "502" access.log \| wc -l` |
| `awk ''{print $1}''` | ดึงข้อมูลคอลัมน์ที่ระบุ (คั่นด้วยช่องว่างอัตโนมัติ โดย `$1` คือคอลัมน์แรก) | `awk ''{print $1}'' access.log` (ดึง Client IP) |
| `cut -d'':'' -f1` | ตัดข้อความตามตัวคั่นที่กำหนด (`-d`) และเลือกฟิลด์ (`-f`) | `cut -d'':'' -f1 /etc/passwd` |
| `sort` | เรียงลำดับบรรทัด (`-n` เรียงตามค่าตัวเลข, `-r` เรียงจากมากไปน้อย) | `sort -nr` |
| `uniq -c` | ยุบรวมบรรทัดที่ติดกันแล้วซ้ำกัน พร้อมนับจำนวน (`-c`) **ต้อง `sort` ก่อนเสมอ** | `sort ip.txt \| uniq -c` |
| `tee <file>` | แสดงผลออกหน้าจอพร้อมกับบันทึกเขียนลงไฟล์ในเวลาเดียวกัน | `grep "ERROR" app.log \| tee /tmp/incident_err.log` |

### ตัวอย่างการวิเคราะห์ Access Log และนับ Error หน้างาน (ตัวอย่างประกอบ)

```bash
# 1. นับจำนวนบรรทัดที่เกิด HTTP 500 หรือ 502 ในไฟล์ log
$ grep -E " 500 | 502 " /var/log/nginx/access.log | wc -l
1482

# 2. หา Top 5 IP Address ที่เรียกเข้ามาที่ Web Server มากที่สุด
# (ดึงคอลัมน์ที่ 1 -> เรียงให้ IP เดียวกันอยู่ติดกัน -> นับจำนวนซ้ำ -> เรียงตัวเลขมากไปน้อย -> เอา 5 อันดับแรก)
$ awk ''{print $1}'' /var/log/nginx/access.log | sort | uniq -c | sort -nr | head -n 5
   8420 203.0.113.45
   1912 198.51.100.22
    640 192.0.2.108
    315 10.20.1.15
    128 10.20.1.16

# 3. ดูบรรทัดที่เกิด NullPointerException พร้อมดูบริบทก่อน-หลัง 2 บรรทัด และแสดงเลขบรรทัด
$ grep -n -C 2 "NullPointerException" /var/log/app/backend.log
4102-2026-11-03 15:01:10 INFO  [req-991] Processing checkout for user_id=4821
4103-2026-11-03 15:01:10 WARN  [req-991] Coupon code field is empty
4104:2026-11-03 15:01:10 ERROR [req-991] java.lang.NullPointerException at CheckoutService.java:142
4105-2026-11-03 15:01:10 INFO  [req-991] Rolling back transaction tx_88210
4106-2026-11-03 15:01:11 ERROR [req-991] Request failed with status 500
```

> **Support Tip**: คำสั่ง `uniq -c` จะยุบรวมเฉพาะบรรทัดที่ซ้ำกันและ **"อยู่ติดกันเท่านั้น"** ดังนั้นในงานจริงจึงต้องคั่นด้วย `sort` ก่อนส่งเข้า `uniq -c` เสมอ (เช่น `... | sort | uniq -c | sort -nr`)

---

## 3. กรณีศึกษาและวิธีแก้ปัญหาหน้างาน (Troubleshooting)

| อาการที่พบ | สาเหตุที่เป็นไปได้ | วิธีตรวจสอบ / ขั้นตอนทำต่อ | ข้อมูลที่ต้องเก็บก่อน Escalate |
|---|---|---|---|
| เว็บไซต์ตอบสนองช้ามาก สงสัยว่ามี IP ภายนอกยิง Request ถี่ผิดปกติเข้ามา | เกิด Bot traffic หรือมี Client ยิง API ซ้ำรัวๆ | รัน `awk ''{print $1}'' access.log \| sort \| uniq -c \| sort -nr \| head -n 10` เพื่อดู 10 อันดับ IP สูงสุด | รายชื่อ Top 10 IP พร้อมจำนวนครั้ง และตัวอย่างบรรทัด Request ของ IP อันดับแรก |
| พบบรรทัด `ERROR` ใน Log แต่ไม่เข้าใจสาเหตุเพราะเห็นแค่บรรทัดเดียว | Stack trace หรือพารามิเตอร์ก่อนเกิดปัญหาอยู่ในบรรทัดข้างเคียง | ใช้ `grep -n -C 5 "ข้อความ Error" app.log` เพื่อดึงบริบทก่อนและหลัง 5 บรรทัดมาอ่านต่อเนื่องกัน | ข้อความ Log ทั้งก้อนที่ได้จาก `-C 5` พร้อมเลขบรรทัดและเวลาที่เกิดเหตุ |
| ต้องการค้นหาว่าไฟล์คอนฟิกตัวไหนใน `/etc/nginx/` ที่มีการตั้งค่าชี้ไปหาพอร์ต `8080` | การตั้งค่ากระจายอยู่ในหลายไฟล์ย่อยใน `conf.d/` หรือ `sites-enabled/` | รัน `grep -rn "8080" /etc/nginx/` เพื่อค้นหาทุกไฟล์พร้อมระบุชื่อไฟล์และเลขบรรทัด | ชื่อไฟล์ เลขบรรทัด และข้อความบรรทัดที่ค้นพบ |
| ไฟล์ Access Log เต็มไปด้วยบรรทัด `/healthz` จาก Load Balancer ทำให้ไล่ดู Request ของผู้ใช้จริงยาก | Load Balancer ยิงตรวจสุขภาพทุก 2 วินาที | ใช้ `grep -v "/healthz" access.log \| tail -n 50` เพื่อตัดบรรทัด `/healthz` ออกจากการแสดงผล | บรรทัด Request ของผู้ใช้จริงที่เกิดปัญหาหลังกรอง `/healthz` ออกแล้ว |

---

## สรุป
- ใช้ Pipe (`|`) เชื่อมคำสั่งย่อยเข้าด้วยกัน และระวังความต่างระหว่าง `>` (เขียนทับไฟล์) กับ `>>` (เขียนต่อท้ายไฟล์)
- จำตัวเลือกหลักของ `grep`: `-i` (ไม่สนพิมพ์เล็ก-ใหญ่), `-n` (เลขบรรทัด), `-r` (ค้นทั้งโฟลเดอร์), `-v` (ไม่เอาคำนี้), `-E` (ค้นหลายคำ), `-C` (ดูบรรทัดรอบข้าง)
- สูตรมาตรฐานหาค่าที่พบบ่อยที่สุดใน Log: `awk ''{print $1}'' <file> | sort | uniq -c | sort -nr | head`
- ใช้ `tee` เมื่อต้องการทั้งดูผลลัพธ์บนหน้าจอและบันทึกเก็บเป็นไฟล์แนบ Ticket ไปพร้อมกัน

## อ้างอิง
- คู่มือในระบบ: `man grep`, `man awk`, `man sort`, `man uniq`, `man wc`, `man cut`, `man tee`
- GNU Grep Manual: https://www.gnu.org/software/grep/manual/
', 10, 'intermediate', 7, true, '2026-11-03 10:24:40.983748+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.lessons VALUES ('b5b35ad3-068d-4e04-b07b-670f9697aea3', 1, 'linux-log-reading', 'การอ่านและวิเคราะห์ System & Application Log (journalctl, dmesg, zgrep, logrotate)', 'ตำแหน่งไฟล์ Log มาตรฐานบน Ubuntu/Debian และ RHEL การค้นหา Log ตามช่วงเวลา การอ่านไฟล์ที่ถูก Rotate (.gz) และข้อควรระวังเรื่อง Timezone', '
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
', 10, 'intermediate', 8, true, '2026-11-03 10:24:40.983748+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.lessons VALUES ('5f86a586-91de-4a51-b749-fcf6d837849f', 1, 'linux-disk-memory-cpu', 'การตรวจทรัพยากรเครื่อง Disk, Memory และ CPU (df, du, free, uptime, lsof, vmstat)', 'วิธีตรวจสอบดิสก์เต็ม Inode เต็ม พื้นที่ไม่คืนหลังลบไฟล์ การอ่านค่าหน่วยความจำ available และวิเคราะห์ Load Average เทียบกับจำนวน Core', '
# การตรวจทรัพยากรเครื่อง (Disk, Memory, CPU)

เมื่อระบบ 모니터링 (Monitoring) แจ้งเตือนว่าเซิร์ฟเวอร์ทำงานช้า ดิสก์ใกล้เต็ม หรือหน่วยความจำสูง เจ้าหน้าที่ **Application Support และ NOC Tier 1** ต้องสามารถรันคำสั่งพื้นฐานเพื่อแยกแยะให้ได้ว่าคอขวดเกิดจาก **Disk**, **Memory** หรือ **CPU/I/O** และรวบรวมตัวเลขสำคัญส่งต่อให้ทีมที่รับผิดชอบโดยไม่ไปลบไฟล์ระบบโดยพลการ

---

## 1. แนวคิดและโครงสร้างพื้นฐาน

### 1.1 พื้นที่ดิสก์ (Block Space) เทียบกับจำนวน Inode
บนระบบไฟล์ Linux การสร้างไฟล์ใหม่ต้องใช้ทรัพยากร 2 ส่วนพร้อมกัน:
1. **พื้นที่จัดเก็บข้อมูล (Disk Space — ดูด้วย `df -h`)**: ความจุหน่วยเป็น MB/GB/TB
2. **หมายเลขสารบัญไฟล์ (Inode — ดูด้วย `df -i`)**: 1 ไฟล์ต้องใช้ 1 Inode เสมอ หากมีไฟล์ขนาดเล็กจำนวนหลายล้านไฟล์ (เช่น ไฟล์ Session หรือไฟล์แคชย่อยๆ) **Inode อาจเต็ม 100% (`IUse% = 100%`) ทั้งที่พื้นที่ GB ยังเหลือว่าง** และระบบจะฟ้อง `No space left on device` เหมือนดิสก์เต็มทุกประการ

### 1.2 การอ่านค่าหน่วยความจำจาก `free -h`
Linux จะนำหน่วยความจำที่ว่างอยู่ไปพักข้อมูลไฟล์ชั่วคราว (`buff/cache`) เพื่อเร่งความเร็วในการอ่านดิสก์ และจะคืนหน่วยความจำส่วนนี้ให้แอปพลิเคชันทันทีเมื่อจำเป็น ดังนั้น:
- **ห้ามดูแค่คอลัมน์ `free`** (ซึ่งมักมีค่าน้อยเป็นเรื่องปกติ)
- **ให้ดูคอลัมน์ `available` เป็นหลัก** เพราะคือหน่วยความจำที่พร้อมให้แอปพลิเคชันใช้งานได้จริง

### 1.3 ค่า Load Average (`uptime`) เทียบกับจำนวน CPU Core (`nproc`)
- `uptime` แสดงค่า **Load Average 3 ตัวเลข** คือค่าเฉลี่ยของงานที่กำลังรันและรอคิวรันในรอบ **1 นาที, 5 นาที และ 15 นาที** ล่าสุด
- ต้องนำค่า Load Average ไปเทียบกับจำนวนแกนประมวลผลจากคำสั่ง `nproc`:
  - เช่น เครื่องมี `nproc = 4` (4 Cores) หาก Load Average เท่ากับ `3.50` แปลว่าเครื่องเริ่มทำงานเกือบเต็มกำลัง และหากสูงถึง `12.00` แปลว่ามีงานรอคิวล้นกว่าจำนวน Core ถึง 3 เท่า
- **ข้อสังเกตสำคัญ**: บน Linux ค่า Load Average นับรวมโปรเซสที่รอการอ่านเขียนดิสก์ (`D` state / Disk I/O wait) ด้วย ดังนั้นหาก **Load สูงมากแต่ `%id` (CPU idle) ยังว่างอยู่** มักเกิดจากปัญหา **Disk I/O ค้าง (`%wa` สูง)** ไม่ใช่ CPU คำนวณหนัก

---

## 2. ตารางสรุป / คำสั่งที่ใช้งานจริง

| หมวดทรัพยากร | คำสั่ง | หน้าที่หลักในงาน Support |
|---|---|---|
| **Disk Space** | `df -h` | ดูพื้นที่ดิสก์ทั้งหมด ใช้ไป และคงเหลือแยกตามพาร์ทิชัน (`Use%`) |
| **Disk Inodes** | `df -i` | ดูจำนวน Inode ที่ใช้ไปและคงเหลือ (`IUse%`) |
| **ขนาดโฟลเดอร์** | `du -sh * \| sort -h` | สรุปขนาดไฟล์และโฟลเดอร์ในตำแหน่งปัจจุบัน เรียงจากน้อยไปมาก |
| **ไฟล์ที่ลบแต่ไม่คืนพื้นที่** | `lsof +L1` | ค้นหาไฟล์ที่ถูกลบชื่อไปแล้ว (Link count < 1) แต่ยังมีโปรเซสเปิดค้างอยู่ |
| **Memory & Swap** | `free -h` | ดูขนาด RAM และ Swap ทั้งหมด โดยโฟกัสที่คอลัมน์ `available` และ Swap `used` |
| **OOM Killer** | `dmesg -T \| grep -i oom` | ตรวจว่ามีโปรเซสถูก Kernel ตัดการทำงานเพราะ RAM หมดหรือไม่ |
| **CPU & Load** | `uptime` และ `nproc` | ดูระยะเวลาที่เครื่องเปิดต่อเนื่อง ค่า Load Average (1, 5, 15 นาที) และจำนวน CPU Core |
| **I/O & System Stat** | `vmstat 1 5` | ดูสถิติหน่วยความจำ Swap และ CPU (`us`, `sy`, `id`, `wa`) ทุก 1 วินาที จำนวน 5 ครั้ง |

### ตัวอย่างการตรวจสอบ Disk, Memory และ Load Average (ตัวอย่างประกอบ)

```bash
# 1. ตรวจสอบพื้นที่ดิสก์และ Inode
$ df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        50G   48G  2.0G  96% /
/dev/sdb1       200G   45G  155G  23% /data

# 2. เจาะหาว่าโฟลเดอร์ใดใน /var/log ใช้พื้นที่มากที่สุด
$ du -sh /var/log/* 2>/dev/null | sort -h | tail -n 5
12M     /var/log/auth.log
85M     /var/log/syslog
420M    /var/log/journal
6.2G    /var/log/nginx
28G     /var/log/app-worker

# 3. ตรวจสอบหน่วยความจำและ Load Average เทียบกับจำนวน Core
$ free -h
               total        used        free      shared  buff/cache   available
Mem:           15Gi       4.2Gi       512Mi       120Mi        10Gi        10Gi
Swap:         2.0Gi          0B       2.0Gi

$ nproc
4

$ uptime
 15:30:10 up 42 days,  6:12,  2 users,  load average: 1.15, 0.95, 0.80
```

> ⚠️ **คำเตือนสำคัญ**: เมื่อพบว่าดิสก์เต็ม ห้ามเจ้าหน้าที่ Tier 1 สั่งลบไฟล์ด้วย `rm` เองโดยไม่มีระบุไว้ใน Runbook ของระบบนั้นๆ เพราะอาจลบไฟล์ข้อมูลธุรกรรมหรือทำให้เกิดปัญหาไฟล์ถูกลบแต่โปรเซสยังถือค้างไว้ (พื้นที่ไม่คืน) ให้รวบรวมรายชื่อไฟล์ขนาดใหญ่จาก `du -sh` และ `lsof +L1` แล้วส่งต่อตามขั้นตอน

---

## 3. กรณีศึกษาและวิธีแก้ปัญหาหน้างาน (Troubleshooting)

| อาการที่พบ | สาเหตุที่เป็นไปได้ | วิธีตรวจสอบ / ขั้นตอนทำต่อ | ข้อมูลที่ต้องเก็บก่อน Escalate |
|---|---|---|---|
| ระบบแจ้ง `No space left on device` แต่เมื่อรัน `df -h` พบว่าพื้นที่ว่างยังเหลืออีกหลายสิบ GB | **Inode เต็ม 100%** จากการมีไฟล์ขนาดเล็กจำนวนมหาศาล (เช่นใน `/tmp` หรือโฟลเดอร์แคช/สปูล) | รัน `df -i` เพื่อยืนยันว่าพาร์ทิชันใดมี `IUse%` เป็น `100%` | ผลลัพธ์จากทั้ง `df -h` และ `df -i` เพื่อชี้ให้เห็นว่า Inode เต็ม |
| มีการลบไฟล์ Log ขนาดใหญ่ด้วย `rm` ไปแล้ว แต่ `df -h` ยังแสดงว่าพื้นที่ดิสก์เต็มเท่าเดิม | โปรเซสของแอปพลิเคชันยังคงเปิดไฟล์นั้นค้างไว้ (File descriptor open) ระบบจึงยังไม่คืนพื้นที่จริงบนดิสก์ | รัน `sudo lsof +L1` (หรือ `sudo lsof \| grep deleted`) เพื่อดูว่าโปรเซสใดและ PID ใดถือไฟล์ที่ถูกลบอยู่ | ผลลัพธ์ `df -h` เทียบกับ `du -sh` และรายการโปรเซสจาก `lsof +L1` (เพื่อรอรีสตาร์ท/รีโหลดบริการนั้นตาม Runbook) |
| มี Alert แจ้งว่า `free memory` ต่ำกว่า 5% แต่เครื่องยังทำงานลื่นไหลปกติ | Linux นำ RAM ที่ว่างไปทำ `buff/cache` ตามกลไกปกติ | รัน `free -h` แล้วดูที่คอลัมน์ **`available`** และดูว่ามีการใช้ `Swap` พุ่งสูงหรือไม่ | ผลลัพธ์ `free -h` (หาก `available` ยังเหลือมากและ Swap ไม่ถูกใช้งานหนัก แสดงว่าปกติ) |
| ค่า Load Average พุ่งสูงถึง `18.0` (บนเครื่อง 4 Cores) แต่ดู `top` แล้ว CPU Usage (`%us`) ต่ำมาก | โปรเซสจำนวนมากติดค้างรอการอ่านเขียนดิสก์หรือ NFS (**I/O Wait — `%wa` สูง**) | รัน `top` หรือ `vmstat 1 5` สังเกตคอลัมน์ `wa` (I/O wait) และดูใน `ps aux` ว่ามีโปรเซสติดสถานะ `D` จำนวนมากหรือไม่ | ผลลัพธ์ `uptime`, `nproc`, `vmstat 1 5` และรายชื่อโปรเซสสถานะ `D` |

---

## สรุป
- ตรวจดิสก์ต้องดูคู่กันทั้ง `df -h` (พื้นที่ GB) และ `df -i` (จำนวน Inode) เสมอ
- ใช้ `du -sh * | sort -h` เพื่อไล่หาโฟลเดอร์ที่กินพื้นที่มากที่สุด และใช้ `lsof +L1` เมื่อลบไฟล์แล้วพื้นที่ดิสก์ไม่คืน
- การดูหน่วยความจำใน `free -h` ให้ยึดคอลัมน์ **`available`** เป็นหลัก ไม่ใช่คอลัมน์ `free`
- ค่า Load Average จาก `uptime` ต้องเทียบกับจำนวน Core จาก `nproc` เสมอ และหาก Load สูงแต่ CPU ว่างให้ตรวจค่า I/O wait (`wa` ใน `vmstat` หรือ `top`)

## อ้างอิง
- คู่มือในระบบ: `man df`, `man du`, `man free`, `man uptime`, `man nproc`, `man vmstat`, `man lsof`
- Linux Kernel Documentation (procfs & memory): https://docs.kernel.org/filesystems/proc.html
', 10, 'intermediate', 9, true, '2026-11-03 10:24:40.983748+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.lessons VALUES ('75b271d2-e3ff-464b-be92-18b9ea5a0d05', 1, 'linux-remote-access', 'การเข้าถึงระยะไกลด้วย SSH, การโอนไฟล์ (scp, rsync) และ tmux พื้นฐาน', 'การใช้งาน SSH และ SSH Key สิทธิ์ของโฟลเดอร์ .ssh การโอนไฟล์ด้วย scp/rsync การใช้ tmux ป้องกันเซสชันหลุด และการแก้ปัญหาเชื่อมต่อไม่ได้', '
# การเข้าถึงระยะไกลด้วย SSH, การโอนไฟล์ และ tmux พื้นฐาน

การทำงานของทีม **Application Support และ NOC Tier 1** ต้องเชื่อมต่อเข้าสู่เครื่องเซิร์ฟเวอร์ปลายทางผ่านโปรโตคอล **SSH (Secure Shell)** ตลอดจนดึงไฟล์ Log ออกมาวิเคราะห์หรือรักษาเซสชันการทำงานไม่ให้หลุดเมื่อเน็ตเวิร์กกระตุก นอกจากนี้ ปัญหา *"SSH เข้าเครื่องไม่ได้"* ยังเป็นหนึ่งใน Ticket ยอดฮิตที่ต้องแยกสาเหตุให้ได้ว่าเกิดจากเครือข่าย พอร์ต หรือสิทธิ์ของไฟล์กุญแจ

---

## 1. แนวคิดและโครงสร้างพื้นฐาน

### 1.1 การพิสูจน์ตัวตนด้วย SSH Key และสิทธิ์ไฟล์ที่บังคับ
การล็อกอินแบบ **SSH Key-based Authentication** ใช้คู่กุญแจ 2 ดอก:
- **Private Key (เช่น `~/.ssh/id_ed25519`)**: เก็บไว้ที่เครื่องต้นทางของเรา **ห้ามแชร์หรือส่งต่อให้ผู้อื่นเด็ดขาด**
- **Public Key (เช่น `~/.ssh/id_ed25519.pub`)**: นำไปวางไว้ในไฟล์ `~/.ssh/authorized_keys` บนเครื่องเซิร์ฟเวอร์ปลายทาง

บริการ `sshd` มีระบบตรวจสอบความปลอดภัยที่เข้มงวดมาก หากสิทธิ์ไฟล์เปิดกว้างเกินไป **ระบบจะปฏิเสธการล็อกอินด้วย Key ทันที**:

| ไฟล์หรือโฟลเดอร์ | สิทธิ์ Octal ที่ถูกต้อง | สิทธิ์แบบตัวอักษร | หน้าที่ |
|---|---|---|---|
| `~/.ssh` | **`700`** | `drwx------` | โฟลเดอร์เก็บกุญแจและคอนฟิก SSH (เจ้าของเข้าได้คนเดียว) |
| `~/.ssh/authorized_keys` | **`600`** | `-rw-------` | เก็บรายการ Public Key ที่อนุญาตให้ล็อกอินเข้าบัญชีนี้บนเครื่องปลายทาง |
| `~/.ssh/id_ed25519` (Private Key) | **`600`** | `-rw-------` | กุญแจส่วนตัวบนเครื่องต้นทาง (ถ้าเป็น `644` หรือ `777` คำสั่ง `ssh` จะฟ้อง `UNPROTECTED PRIVATE KEY FILE!`) |
| `~/.ssh/known_hosts` | **`600` หรือ `644`** | `-rw-------` | บันทึกลายนิ้วมือ (Host key fingerprint) ของเซิร์ฟเวอร์ที่เคยเชื่อมต่อแล้ว |

### 1.2 การรักษาเซสชันด้วย `tmux` (Terminal Multiplexer)
เมื่อต้องรันคำสั่งที่ใช้เวลานานหรือติดตาม Log ต่อเนื่อง หากอินเทอร์เน็ตของเราหลุด โปรเซสในเซสชัน SSH ปกติจะถูกตัดจบไปด้วย การเปิด **`tmux`** บนเซิร์ฟเวอร์จะช่วยสร้างเซสชันเสมือนที่ทำงานต่อไปเบื้องหลัง แม้ SSH จะหลุดก็สามารถต่อกลับเข้ามา (`tmux attach`) ที่หน้าจอเดิมได้ทันที

---

## 2. ตารางสรุป / คำสั่งที่ใช้งานจริง

| หมวดหมู่ | คำสั่ง | หน้าที่หลักในงาน Support |
|---|---|---|
| **เชื่อมต่อ SSH** | `ssh user@host` | เชื่อมต่อไปยังเซิร์ฟเวอร์ที่พอร์ตมาตรฐาน (`22`) |
| **ระบุพอร์ต / กุญแจ** | `ssh -p 2222 -i ~/.ssh/mykey user@host` | เชื่อมต่อโดยระบุพอร์ต (`-p` ตัวพิมพ์เล็ก) และระบุไฟล์ Private Key (`-i`) |
| **โหมดไล่ปัญหา SSH** | `ssh -v user@host` | แสดงขั้นตอนการเชื่อมต่อและตรวจสอบกุญแจอย่างละเอียด (Verbose mode) |
| **สร้างคู่กุญแจ SSH** | `ssh-keygen -t ed25519` | สร้างคู่กุญแจสมัยใหม่แบบ Ed25519 ที่ปลอดภัยและรวดเร็ว |
| **ส่ง Public Key** | `ssh-copy-id user@host` | คัดลอก Public Key ไปใส่ใน `~/.ssh/authorized_keys` ของปลายทางพร้อมตั้งสิทธิ์ให้อัตโนมัติ |
| **ลบ Host Key เก่า** | `ssh-keygen -R <host_or_ip>` | ลบลายนิ้วมือเครื่องปลายทางเดิมออกจาก `~/.ssh/known_hosts` (ใช้เมื่อมีการลง OS เครื่องปลายทางใหม่ใน IP เดิม) |
| **คัดลอกไฟล์ผ่าน SSH** | `scp -P 2222 user@host:/tmp/err.log ./` | ดึงไฟล์จากเซิร์ฟเวอร์มาที่เครื่องเรา (**ระวัง: `scp` ใช้ `-P` พิมพ์ใหญ่สำหรับระบุพอร์ต**) |
| **ซิงก์ไฟล์มีประสิทธิภาพ** | `rsync -avz user@host:/var/log/app/ ./logs/` | โอนถ่ายไฟล์แบบบีบอัดระหว่างส่ง (`-z`), คงสิทธิ์เดิม (`-a`), และส่งเฉพาะส่วนที่ต่างกัน |
| **ใช้งาน `tmux` พื้นฐาน** | `tmux new -s work`, `tmux ls`, `tmux a -t work` | สร้างเซสชันชื่อ `work`, ดูรายการเซสชัน, และกลับเข้าเซสชันเดิม (กด `Ctrl+b` แล้วปล่อย ตามด้วย `d` เพื่อถอยออกมาโดยไม่ปิดงาน) |

### ตัวอย่างการตรวจสอบปัญหา SSH ด้วย `ssh -v` และการดึงไฟล์ Log (ตัวอย่างประกอบ)

```bash
# 1. ใช้ ssh -v เพื่อดูว่าทำไมล็อกอินไม่ผ่าน
$ ssh -v -i ~/.ssh/support_key support@10.20.1.50
OpenSSH_9.6p1, OpenSSL 3.0.13
debug1: Connecting to 10.20.1.50 [10.20.1.50] port 22.
debug1: Connection established.
debug1: Next authentication method: publickey
debug1: Offering public key: /home/user/.ssh/support_key ED25519 SHA256:abc123xyz... explicit
debug1: Authentications that can continue: publickey
debug1: No more authentication methods to try.
support@10.20.1.50: Permission denied (publickey).

# 2. ดึงไฟล์ Log ที่รวบรวมไว้ใน /tmp ออกมาแนบ Ticket
$ scp support@10.20.1.50:/tmp/incident_20261103.log ./
incident_20261103.log                         100%  412KB  18.5MB/s   00:00
```

> ⚠️ **คำเตือนสำคัญ**: ห้ามส่งไฟล์ Private Key (ไฟล์ที่ไม่มีนามสกุล `.pub`) เข้ากลุ่มแชต อีเมล หรือแนบลงใน Ticket เด็ดขาด และเมื่อเกิดข้อความเตือน `WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!` ห้ามรัน `ssh-keygen -R` ทันทีจนกว่าจะยืนยันกับทีม Infrastructure แล้วว่าเซิร์ฟเวอร์ปลายทางมีการติดตั้งใหม่หรือเปลี่ยน IP จริง (เพื่อป้องกันการถูกโจมตีแบบ Man-in-the-Middle)

> **Support Tip**: ชื่อบริการ SSH Daemon บน **Ubuntu/Debian** มักใช้ `ssh` (`systemctl status ssh`) ส่วนบน **RHEL/Rocky Linux** จะใช้ชื่อ `sshd` (`systemctl status sshd`)

---

## 3. กรณีศึกษาและวิธีแก้ปัญหาหน้างาน (Troubleshooting)

| อาการที่พบ | สาเหตุที่เป็นไปได้ | วิธีตรวจสอบ / ขั้นตอนทำต่อ | ข้อมูลที่ต้องเก็บก่อน Escalate |
|---|---|---|---|
| `ssh: connect to host ... port 22: Connection timed out` | แพ็กเก็ตไปไม่ถึงปลายทาง (ติด Firewall, Security Group, ยังไม่ได้ต่อ VPN หรือเครื่องปลายทางดับ) | 1. ตรวจว่าต่อ VPN แล้วหรือยัง และ IP ถูกต้องไหม<br>2. รัน `ssh -v` ดูว่าค้างที่ขั้นตอน `Connecting to ...` | IP ต้นทางของเรา, IP/พอร์ตปลายทาง และผลจาก `ssh -v` |
| `ssh: connect to host ... port 22: Connection refused` | ไปถึงเครื่องปลายทางแล้ว แต่พอร์ต 22 ไม่มีบริการ `sshd` เปิดรับอยู่ (บริการ `sshd` ดับ หรือเปลี่ยนไปใช้พอร์ตอื่น เช่น `2222`) | ตรวจสอบกับเอกสารของระบบว่าใช้ Custom SSH Port หรือไม่ แล้วลอง `ssh -p <port>` | ข้อความ `Connection refused` และหมายเลขพอร์ตที่ใช้เชื่อมต่อ |
| `Permission denied (publickey)` | 1. ระบุชื่อ user ผิด หรือเลือกไฟล์ `-i` ผิดดอก<br>2. สิทธิ์ของ `~/.ssh` ไม่ใช่ `700` หรือ `authorized_keys` บนปลายทางไม่ใช่ `600` | 1. รัน `ssh -v` ดูว่าส่งกุญแจดอกไหนไป (`Offering public key`)<br>2. หากเข้าผ่านช่องทางอื่นได้ ให้เช็กสิทธิ์ `ls -ld ~/.ssh` และ `ls -l ~/.ssh/authorized_keys` | ผลลัพธ์จาก `ssh -v` และ Fingerprint ของ Public Key ของผู้ที่เข้าไม่ได้ |
| `WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!` | เซิร์ฟเวอร์ที่ IP นั้นเพิ่งถูกลง OS ใหม่ หรือย้าย IP ไปเครื่องอื่น ทำให้ Host key ไม่ตรงกับที่จำไว้ใน `~/.ssh/known_hosts` | 1. สอบถามทีม Infra ยืนยันว่ามีการ Rebuild เครื่องจริง<br>2. เมื่อยืนยันแล้ว รัน `ssh-keygen -R <IP_หรือ_Host>` บนเครื่องเราเพื่อล้างค่าเก่า | ภาพข้อความเตือน เลขบรรทัดใน `known_hosts` และผลการยืนยันจากทีม Infra |

---

## สรุป
- แยกความต่างของ Error เชื่อมต่อให้แม่น: **Timed out** = ติดเครือข่าย/Firewall, **Connection refused** = ไปถึงเครื่องแล้วแต่พอร์ตไม่เปิด/บริการ `sshd` ไม่รัน, **Permission denied (publickey)** = กุญแจไม่ตรงหรือสิทธิ์ไฟล์ `.ssh` ผิด
- จำสิทธิ์บังคับของ SSH: โฟลเดอร์ `~/.ssh` ต้องเป็น **`700`** และไฟล์ `authorized_keys` / Private Key ต้องเป็น **`600`**
- สังเกตตัวเลือกพอร์ต: `ssh` ใช้ `-p` (พิมพ์เล็ก) แต่ `scp` ใช้ `-P` (พิมพ์ใหญ่)
- ใช้ `tmux` เสมอเมื่อต้องรันงานต่อเนื่องผ่าน SSH เพื่อป้องกันเซสชันหลุดกลางคัน

## อ้างอิง
- คู่มือในระบบ: `man ssh`, `man ssh-keygen`, `man scp`, `man rsync`, `man tmux`, `man sshd_config`
- OpenSSH Manual Pages: https://www.openssh.com/manual.html
', 10, 'intermediate', 10, true, '2026-11-03 10:24:40.983748+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.lessons VALUES ('5a93786b-3b53-4b51-8232-c77e8324453b', 1, 'linux-cron-schedule', 'การตรวจสอบงานตั้งเวลาด้วย Cron และ Crontab (crontab -l, /etc/cron.d, Cron Log)', 'โครงสร้างเวลา 5 ฟิลด์ของ Crontab ความต่างของบริการ cron บน Ubuntu กับ RHEL และวิธีไล่ปัญหาเมื่อ Batch Job ไม่ทำงานตามเวลา', '
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
', 9, 'intermediate', 11, true, '2026-11-03 10:24:40.983748+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.lessons VALUES ('9ed1b0db-122c-4d06-9d9c-bd4613afd6dd', 1, 'linux-health-check', 'เช็กสถานะ Service, Port และ Endpoint (systemctl, ss, nc, curl)', 'ชุดคำสั่งตรวจสอบเบื้องต้นตามลำดับ ตั้งแต่ Service รันอยู่ไหม Port เปิดฟังไหม ต่อ Port ปลายทางได้ไหม จนถึง Endpoint ตอบ HTTP ปกติไหม พร้อมวิธีแปลผลและข้อมูลที่ต้องเก็บก่อน Escalate', '
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
| `ss -ltnp ''sport = :8080''` | กรองเฉพาะ Port 8080 |
| `ss -tn state established ''( sport = :443 )''` | ดูการเชื่อมต่อที่กำลังใช้งานอยู่ที่ Port 443 |
| `sudo lsof -i :8080` | ดูว่า Process ไหนใช้ Port 8080 อยู่ (ตรวจกรณี Port ชน) |

### 2.3 ชั้นเครือข่ายไปยังปลายทาง
| คำสั่ง | ใช้ทำอะไร |
|---|---|
| `nc -zv 10.20.1.50 5432` | ลองต่อ TCP Port โดยไม่ส่งข้อมูล (`-z` สแกนเฉยๆ, `-v` แสดงผล) |
| `timeout 3 bash -c ''</dev/tcp/10.20.1.50/5432'' && echo open` | ทางเลือกเมื่อไม่มี `nc` ใช้ bash ต่อ Port โดยตรง |
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
$ sudo ss -ltnp ''sport = :8080''
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
| สตาร์ท Service แล้วขึ้น `Address already in use` | มี Process อื่นใช้ Port นั้นอยู่ | `sudo lsof -i :<port>` หรือ `sudo ss -ltnp ''sport = :<port>''` เพื่อหา PID | ชื่อและ PID ของ Process ที่ถือ Port อยู่ (ไม่ kill เองถ้าไม่ได้อยู่ใน Runbook) |
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
', 10, 'intermediate', 12, true, '2026-11-03 16:05:54.729798+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.lessons VALUES ('e2bdf887-4d4b-4710-b6c1-8dd61f020fdc', 10, 'dc-interview-and-mindset', 'ทัศนคติ ความปลอดภัย และเทคนิคพิชิตสัมภาษณ์งาน Data Center (Hosting vs Colocation)', 'วิธีคิดเรื่องความปลอดภัยและสติเมื่อเกิดเหตุฉุกเฉิน, ความซื่อสัตย์ในการตอบสัมภาษณ์, ความต่างของบริษัท Hosting vs Colocation และแนวคำตอบ STAR Method', '
# ทัศนคติ ความปลอดภัย และเทคนิคพิชิตสัมภาษณ์งาน Data Center

ในการสัมภาษณ์งานสาย **Data Center Technician / Data Center Operations (DC Ops)** สิ่งที่ผู้จัดการทีม (Hiring Manager) ให้ความสำคัญมากที่สุด **ไม่ใช่แค่ว่าคุณท่องจำคำสั่งได้มากแค่ไหน** แต่คือ **"คุณเป็นคนที่ไว้ใจให้ถือบัตรผ่านเข้าไปเดินในห้องที่มีเซิร์ฟเวอร์มูลค่าหลายร้อยล้านบาทโดยไม่ทำระบบล่มได้หรือไม่?"**

---

## 1. ทัศนคติหลักที่ผู้สัมภาษณ์มองหา (Mindset & Safety First)

### 1.1 ความรอบคอบ มีสติ และไม่ตื่นตระหนกเมื่อเกิดวิกฤต (Calmness Under Pressure)
ผู้จัดการกังวลเรื่อง **Human Error (ความผิดพลาดจากความประมาทหรือความตกใจของคน)** มากที่สุด เพราะการกดปุ่มผิดหรือสับเบรกเกอร์ผิดเพียงครั้งเดียวอาจทำให้ระบบธนาคารหรืออีคอมเมิร์ซล่มทั้งประเทศ

#### กรณีศึกษาคำถามวัดใจในห้องสัมภาษณ์:
> **คำถาม**: *"สมมติคุณเดินตรวจความเรียบร้อยใน Data Hall แล้วเห็นประกายไฟช็อตสั้นๆ หรือได้กลิ่นไหม้มาจาก Power Supply (PSU) ลูกหนึ่งของเซิร์ฟเวอร์เครื่องหนึ่งในตู้แร็ค คุณจะวิ่งไปสับเบรกเกอร์ไฟหลักของทั้งตู้แร็คลงทันทีเลยไหม?"*

- **คำตอบที่ผิด (ตกสัมภาษณ์ทันที)**: *"รีบวิ่งไปสับเบรกเกอร์ไฟหลักของตู้แร็คหรือกดปุ่ม EPO (Emergency Power Off) ทันทีครับ เพื่อความปลอดภัย"*
  - **ทำไมถึงผิด?** เพราะในตู้แร็ค 1 ตู้ มีเซิร์ฟเวอร์ของลูกค้าหรือระบบ Production อื่นที่ไม่ได้เกี่ยวข้องด้วยอีก 20–40 เครื่อง การสับไฟหลักของตู้แร็คจะทำให้อุปกรณ์ที่เหลือดับตามไปด้วย (Outage วงกว้างโดยไม่จำเป็น)
- **แนวทางคำตอบที่ถูกต้องและแสดงถึงสติระดับมืออาชีพ**:
  1. **ตั้งสติและประเมินสถานการณ์ทันที (Assess without Panic)**: ดูว่ามีเปลวไฟลุกไหม้ต่อเนื่องที่เป็นอันตรายต่อชีวิตหรือไม่ หากเป็นเพียงอาการช็อตภายในตัวลูก PSU ของเซิร์ฟเวอร์เครื่องเดียว (ซึ่งปกติมีวงจรตัดไฟตัวมันเองและมีลูกที่สองเป็น Redundant PSU รับช่วงต่ออยู่) **จะไม่ไปสับเบรกเกอร์หลักของทั้งตู้แร็คเด็ดขาด**
  2. **ตรวจสอบและจำกัดวงความเสียหาย (Isolate the Fault)**: ตรวจสอบหมายเลขเครื่อง/ตำแหน่ง U และดูสถานะไฟของ PSU ลูกที่มีปัญหา หากปลอดภัยที่จะทำได้ ให้ถอดเฉพาะสายไฟเส้นที่จ่ายเข้า PSU ลูกที่ช็อตออก (เพื่อให้เครื่องรันต่อด้วย PSU อีกลูกบนอีก Feed หนึ่ง)
  3. **แจ้งเตือนตามลำดับขั้น (Escalate & Document)**: รีบแจ้งหัวหน้ากะ (Shift Lead), ทีม NOC และทีม Facilities ทันทีเพื่อตรวจสอบค่ากระแสไฟบน PDU และวางแผนเปลี่ยนอะไหล่ PSU ตัวใหม่ตามขั้นตอนมาตรฐาน (MOP/SOP)

---

### 1.2 ความซื่อสัตย์ (Integrity & Honesty)
ในสายงานโครงสร้างพื้นฐาน **การโกหกหรือแสร้งทำเป็นรู้ในสิ่งที่ตัวเองทำไม่เป็น คือสัญญาณอันตรายร้ายแรงที่สุด**

- หากผู้สัมภาษณ์ถามทักษะเฉพาะทางที่คุณยังไม่เคยทำจริง เช่น:
  - *"คุณเข้าหัวสายไฟเบอร์ด้วยการเชื่อมต่อใยแก้ว (Fusion Fiber Splicing) เป็นไหม?"*
  - *"คุณเคยตั้งค่า Zoning บนสวิตช์ Brocade Fibre Channel ด้วยตัวเองไหม?"*
- **วิธีตอบที่ได้คะแนนความน่าเชื่อถือสูงสุด**:
  > *"สำหรับการใช้เครื่อง Fusion Splicer เชื่อมสายไฟเบอร์โดยตรง ผมยังไม่เคยลงมือทำหน้างานจริงครับ แต่ผมเข้าใจหลักการแยกชนิดสาย Single-mode/Multi-mode การทำความสะอาดหัวสายด้วย One-Click Cleaner และการวัดค่าการสูญเสียแสงด้วย Optical Power Meter ครับ ซึ่งผมเป็นคนเรียนรู้เครื่องมือใหม่ได้เร็วและพร้อมฝึกปฏิบัติตามมาตรฐานของทีมทันทีครับ"*
- **ทำไมคำตอบนี้ถึงชนะใจผู้สัมภาษณ์?**
  1. แสดงความซื่อสัตย์ ไม่เสี่ยงไปทำอุปกรณ์ราคาแพงพังหน้างานเพราะไม่กล้าถาม
  2. แสดงให้เห็นว่ามีความรู้พื้นฐานที่เกี่ยวข้อง และมีความกระตือรือร้นที่จะเรียนรู้ต่อยอด

---

## 2. เข้าใจธรรมชาติของบริษัทที่ไปสัมภาษณ์: Hosting vs Colocation

ก่อนเข้าห้องสัมภาษณ์ ให้ตรวจสอบว่าบริษัทนั้นทำธุรกิจหลักรูปแบบใด เพื่อเน้นจุดแข็งให้ตรงเป้า:

| รูปแบบบริษัท | ลักษณะงานหลัก | หัวข้อที่จะถูกถามเจาะลึก |
|---|---|---|
| **1. บริษัท Hosting / Cloud / Enterprise DC ของตัวเอง**<br>*(มีเซิร์ฟเวอร์เป็นของบริษัทเองหลายพันเครื่อง)* | ดูแลตั้งแต่ฮาร์ดแวร์ไปจนถึงการลง OS และแก้ปัญหาให้ระบบกลับมาออนไลน์ | • การติดตั้งและแก้ปัญหา **Linux / Windows Server**<br>• กระบวนการบูตเครื่อง, **PXE Boot**, การตั้งค่า RAID<br>• การใช้ **iDRAC / iLO / IPMI** ดู Log ฮาร์ดแวร์และเปลี่ยน CPU, RAM, Disk<br>• คำสั่งตรวจเช็กเครือข่าย (`ip`, `ping`, `traceroute`, `ss`, `ethtool`) |
| **2. บริษัท Colocation Data Center**<br>*(เช่น Equinix, NTT, STT GDC, Telehouse — ให้เช่าพื้นที่ตู้แร็ค ไฟ และ Cross-Connect)* | งานบริการลูกค้าหน้าตู้ (**Smart Hands**) และการเดินสายเชื่อมต่อระหว่างตู้ (**Cross-Connect**) โดยไม่ได้ล็อกอินเข้า OS ของลูกค้า | • ความแม่นยำเรื่อง **Cabling & Fiber** (SMF vs MMF, SC/LC/MPO, SR/LR)<br>• การไล่สายบน **Patch Panel**, การสลับขั้วสายไฟเบอร์ (**Rolling Fiber Tx/Rx**)<br>• การใช้เครื่องมือวัดสาย (**Fluke Tester, Visual Fault Locator, Optical Power Meter**)<br>• ระบบไฟ **A/B Feed**, **Hot/Cold Aisle**, และระเบียบความปลอดภัยในการเข้าพื้นที่ลูกค้า |

---

## 3. เทคนิคการตอบคำถามเชิงพฤติกรรม (Behavioral Questions) ด้วย STAR Method

ในการสัมภาษณ์เกือบทุกที่ จะมีคำถามแนวเล่าประสบการณ์จริงที่ขึ้นต้นด้วย **"จงเล่าเหตุการณ์ตอนที่คุณต้องรับมือกับ..."** (*"Tell me about a time when..."*)

ให้จัดระเบียบคำตอบเป็น 4 ส่วนตามโครงสร้าง **STAR Method** เสมอ เพื่อให้เรื่องเล่ากระชับ ชัดเจน และเห็นผลลัพธ์:

- **S — Situation (สถานการณ์)**: เหตุการณ์เกิดขึ้นที่ไหน เมื่อไหร่ และบริบทคืออะไร (เล่าสั้นๆ 1–2 ประโยค)
- **T — Task (ภารกิจ/โจทย์ที่ต้องแก้)**: ปัญหาหรือความท้าทายที่คุณรับผิดชอบในตอนนั้นคืออะไร
- **A — Action (สิ่งที่คุณลงมือทำอย่างเป็นระบบ)**: ขั้นตอนการตรวจสอบ การใช้สติ การสื่อสารกับทีม และการป้องกันไม่ให้กระทบส่วนอื่น
- **R — Result (ผลลัพธ์ที่ได้และบทเรียน)**: แก้ปัญหาสำเร็จอย่างไร ใช้เวลาเท่าไหร่ และได้ปรับปรุงคู่มือ (Runbook) อย่างไรเพื่อไม่ให้เกิดซ้ำ

---

### ตัวอย่างคำถามและแนวคำตอบแบบ STAR Method

#### คำถามที่ 1: "จงเล่าเหตุการณ์ตอนที่คุณต้องทำงานภายใต้ความกดดัน หรือเจอปัญหาหน้างานที่ไม่เคยเจอมาก่อน"
- **Situation**: *"ในการฝึกซ้อมแล็บจำลองเหตุการณ์วิกฤต (Incident P1) เซิร์ฟเวอร์เว็บหลักไม่สามารถสตาร์ทบริการ Nginx ขึ้นมาได้หลังการอัปเดตระบบ"*
- **Task**: *"ผมต้องหาสาเหตุที่แท้จริงและทำให้บริการเว็บกลับมาออนไลน์ให้เร็วที่สุดโดยไม่ทำข้อมูลหรือการตั้งค่าเดิมเสียหาย"*
- **Action**: *"แทนที่จะสุ่มรีบูตเครื่องซ้ำๆ ผมตั้งสติและไล่ตามขั้นตอนมาตรฐาน เริ่มจากเช็ก `systemctl status nginx` และอ่าน Log ด้วย `journalctl -u nginx` จนพบ Error ว่า `Address already in use` บนพอร์ต 80 จากนั้นใช้ `ss -tulnp` ตรวจสอบจนเจอว่ามีบริการ `apache2` แอบรันขึ้นมาแย่งพอร์ต 80 อยู่ จึงสั่งหยุด `apache2` แล้วสตาร์ท `nginx` ใหม่ พร้อมทดสอบด้วย `curl -I http://localhost`"*
- **Result**: *"ระบบเว็บกลับมาตอบกลับ `200 OK` ได้ภายในเวลาไม่ถึง 5 นาทีโดยไม่ต้องรีบูตเซิร์ฟเวอร์ และผมได้บันทึกขั้นตอนการเช็กพอร์ตชนไว้ใน Runbook เพื่อเป็นแนวทางให้ทีมต่อไปครับ"*

#### คำถามที่ 2: "คุณมีวิธีป้องกันความผิดพลาด (Human Error) เวลาต้องถอดสายหรือปิดเครื่องเซิร์ฟเวอร์ในตู้แร็คอย่างไร?"
- **แนวคำตอบ**:
  1. **ตรวจสอบใบงาน (Change Ticket / Work Order)** ให้ตรงกันอย่างน้อย 3 จุดเสมอ: **หมายเลขตู้ (Rack ID) → ตำแหน่งความสูง (U Position) → หมายเลขเครื่อง/Serial Number (Service Tag)**
  2. สั่งเปิด **ไฟกระพริบสีฟ้า (UID / Chassis Identify LED)** จากระบบ iDRAC/iLO ก่อนเดินไปหลังตู้แร็ค เพื่อให้เห็นเครื่องเป้าหมายชัดเจนทั้งด้านหน้าและด้านหลัง
  3. ตรวจสอบป้ายกำกับสาย (**Cable Label**) ทั้งฝั่งต้นทางและปลายทาง และยืนยันกับทีม NOC ในสายโทรศัพท์หรือแชตก่อนดึงสายออกจริงทุกครั้ง (**Measure twice, cut once**)
', 8, 'beginner', 11, true, '2026-11-04 15:19:45.48554+00', '2026-11-10 13:22:20.548088+00');
INSERT INTO public.lessons VALUES ('681252fc-9293-40e3-9100-c19b27e9f69c', 10, 'dc-equipment-connectors-toolkit', 'อุปกรณ์ประจำตู้แร็ค หัวปลั๊กไฟ IEC และเครื่องมือช่างหน้างาน Data Center (DC Equipment, Power Connectors & Field Toolkit)', 'รู้จักเครื่องมือช่าง DC (ปากกาแสง VFL, One-Click Cleaner, OPM, หัวอุด Loopback), มาตรฐานหัวปลั๊กไฟ IEC C13/C14 vs C19/C20 และปลั๊ก Commando 1/3 เฟส, อุปกรณ์ตู้แร็ค (Cage Nut, Blanking Panel, Sliding Rail) และการต่อสาย Console 9600-8-N-1', '# อุปกรณ์ประจำตู้แร็ค หัวปลั๊กไฟ IEC และเครื่องมือช่างหน้างาน Data Center

สำหรับวิศวกรหรือช่างเทคนิคระดับเริ่มต้น (Junior Data Center Technician / NOC / Field Engineer) ความท้าทายในวันแรกที่ก้าวเข้าห้องเซิร์ฟเวอร์ (Data Hall) คือการเห็นอุปกรณ์และเครื่องมือเฉพาะทางจำนวนมากที่ไม่เคยเห็นตามบ้านหรือออฟฟิศทั่วไป บทเรียนนี้รวบรวม **อุปกรณ์ทุกชิ้นที่ต้องหยิบจับจริงหน้างาน** เพื่อให้คุณเรียกชื่อ เลือกใช้งาน และตอบคำถามสัมภาษณ์ได้อย่างแม่นยำ

---

## 1. กระเป๋าเครื่องมือช่างไฟเบอร์และสายสัญญาณ (Optical & Copper Field Toolkit)

เมื่อได้รับใบงานให้ไปตรวจสอบว่า *"ทำไมเสียบสายไฟเบอร์แล้วไฟพอร์ตไม่ติด (Link Down)"* นี่คือเครื่องมือมาตรฐาน 5 ชิ้นที่ช่าง Data Center ต้องใช้เป็น:

![ชุดเครื่องมือช่างไฟเบอร์ออปติกและเครือข่าย: ปากกายิงแสง VFL, ปากกาทำความสะอาด One-Click Cleaner, มิเตอร์วัดแสง OPM และหัว Loopback](/images/datacenter/dc-fiber-testing-toolkit.png)

| ชื่อเครื่องมือ | หน้าที่และการใช้งานจริงหน้าตู้แร็ค | ข้อควรระวังสำคัญ |
|---|---|---|
| **1. VFL (Visual Fault Locator / ปากกายิงแสงเลเซอร์สีแดง)** | ยิงแสงเลเซอร์สีแดงที่ตามองเห็นได้ (ความยาวคลื่น `650 nm`) เข้าไปในสายไฟเบอร์เพื่อ:<br>• **หาปลายสายอีกฝั่ง** ในแผงพักสาย ODF ที่มีสายนับร้อยเส้น<br>• **หาจุดสายหักหรือขาด**: หากสายไฟเบอร์หักงอเกินพิกัด แสงสีแดงจะรั่วทะลุปลอกสายออกมาตรงจุดที่หักทันที! | **ห้ามส่องเข้าดวงตาโดยตรงเด็ดขาด!** และห้ามยิงแสง VFL สวนเข้าหัว SFP ที่กำลังเปิดใช้งานอยู่ เพราะความเข้มแสงเลเซอร์จะทำให้ตัวรับแสงของ SFP เสียหาย |
| **2. One-Click Fiber Cleaner (ปากกากดทำความสะอาดหัวไฟเบอร์)** | ใช้กดทำความสะอาดหน้าตัดเซรามิก (Ferrule) ของหัวไฟเบอร์ **LC (ขนาด 1.25 มม.)** หรือ **SC (2.5 มม.)** และช่องภายในหัว SFP ด้วยแถบผ้าไมโครไฟเบอร์แห้งในตัว (กด 1 คลิก แถบผ้าจะเลื่อนส่วนที่สะอาดมาเช็ดอัตโนมัติ) | กว่า **80% ของปัญหาไฟเบอร์ล่มเกิดจากฝุ่นและคราบนิ้วมือ!** ห้ามใช้ปากเป่าลมหรือใช้ชายเสื้อเช็ดหัวไฟเบอร์เด็ดขาด |
| **3. OPM (Optical Power Meter / มิเตอร์วัดกำลังแสง)** | วัดความเข้มของแสงที่ปลายสายไฟเบอร์ออกมาเป็นตัวเลขหน่วย **`dBm`** (เช่น `-2.8 dBm`) เพื่อเช็กว่าแสงแรงพอที่จะทำให้พอร์ตสวิตช์ทำงานได้หรือไม่ | ต้องกดเลือกความยาวคลื่นบนเครื่อง OPM ให้ตรงกับชนิดของแสงที่วัด (เช่น `850 nm` สำหรับ Multi-mode SR หรือ `1310 nm` สำหรับ Single-mode LR) |
| **4. Loopback Plug (หัวอุดวนสัญญาณ Fiber / RJ45 Loopback)** | เป็นปลั๊กตัวสั้นๆ ที่เชื่อมวงจรขาส่ง (`Tx`) วนกลับเข้าขารับ (`Rx`) ของพอร์ตตัวเองทันที ใช้สำหรับ **แยกแยะว่าพอร์ตสวิตช์/หัว SFP เสีย หรือสายในผนังเสีย** | ถ้าเสียบหัว Loopback เข้าที่ตัว SFP แล้วไฟพอร์ตขึ้นสีเขียวทันที ➔ พิสูจน์ได้ว่า **พอร์ตสวิตช์และหัว SFP ปกติ 100%** ปัญหาอยู่ที่สายเคเบิล! |
| **5. LAN Cable Tester & Tone Probe (เครื่องเช็กสายแลนและลำโพงไล่สาย)** | ตรวจสอบว่าสายทองแดง Cat6 เข้าหัวครบทั้ง 8 เส้น ไม่สลับคู่ (Crossed/Split Pair) ไม่ขาดใน (Open) และวัดความยาวสายด้วยสัญญาณสะท้อน (TDR) | หากต่อเข้ากับพอร์ตสวิตช์ที่ปล่อยไฟ PoE ต้องใช้เครื่องรุ่นที่รองรับการป้องกันไฟ PoE เท่านั้น |

---

## 2. มาตรฐานหัวปลั๊กไฟในศูนย์ข้อมูล (IEC 60320 & Commando Power Plugs)

ในห้องเซิร์ฟเวอร์จะไม่ใช้ปลั๊กสามขาแบบบ้านทั่วไป แต่ใช้หัวปลั๊กมาตรฐานสากล **IEC 60320** เพื่อป้องกันการเสียบผิดขนาดกระแสไฟ และมีคลิปล็อกกันสายหลุด (**Locking Power Cord**):

![การเปรียบเทียบหัวปลั๊กไฟมาตรฐานศูนย์ข้อมูล IEC C13/C14, C19/C20 และปลั๊กพาวเวอร์กลมใต้พื้นยก IEC 60309](/images/datacenter/iec-power-connectors-c13-c19.png)

| ชนิดหัวปลั๊ก | รูปร่างจุดสังเกต | พิกัดกระแสไฟสูงสุด | อุปกรณ์ที่ใช้งานคู่กัน |
|---|---|---|---|
| **IEC `C13 / C14`** | หัวทรงหกเหลี่ยมขนาดมาตรฐาน **ขาแนวตั้ง 3 ขา** (`C13` = ตัวเมียเสียบเข้าท้ายเซิร์ฟเวอร์, `C14` = ตัวผู้เสียบเข้าราง PDU) | **10A – 15A** (200–240V) | เซิร์ฟเวอร์ Rack 1U/2U ทั่วไป, Access/ToR Switch, Firewall, Storage ขั้นต้น |
| **IEC `C19 / C20`** | **หัวทรงสี่เหลี่ยมผืนผ้าขนาดใหญ่ ขาแนวนอน 3 ขา** (`C19` = ตัวเมียเสียบท้ายอุปกรณ์ใหญ่, `C20` = ตัวผู้เสียบเข้าราง PDU) | **16A – 20A** (200–240V) | อุปกรณ์ที่กินไฟสูงมาก เช่น **Blade Server Chassis, AI/GPU Server, Core Switch ขนาดใหญ่, หรือสายไฟหลักเข้า UPS/PDU** |
| **IEC 60309 (Commando Plug สีน้ำเงิน 3 ขา)** | ปลั๊กกลมอุตสาหกรรมขนาดใหญ่มีฝาปิดกันน้ำ/ฝุ่น **สีน้ำเงิน (2P+E: L, N, Earth)** ติดตั้งอยู่ใต้พื้นยก (Raised Floor) | **16A หรือ 32A** (**ไฟ 1 เฟส 230V**) | สายไฟหลักที่จ่ายจากตู้ไฟห้องเซิร์ฟเวอร์ขึ้นมายังรางปลั๊กไฟ **Rack PDU แบบ 1 เฟส** |
| **IEC 60309 (Commando Plug สีแดง 5 ขา)** | ปลั๊กกลมอุตสาหกรรมขนาดใหญ่ **สีแดง (3P+N+E: L1, L2, L3, N, Earth)** ติดตั้งใต้พื้นยก | **32A หรือ 63A** (**ไฟ 3 เฟส 400V**) | สายไฟหลักที่จ่ายให้ **Rack PDU แบบ 3 เฟส** ในตู้แร็คที่มีความหนาแน่นพลังงานสูง (High-Density Rack) |

---

## 3. อุปกรณ์ประกอบตู้แร็ค 42U (Rack Mounting Hardware & Airflow Accessories)

การนำเซิร์ฟเวอร์ขึ้นติดตั้งในตู้แร็ค 19 นิ้ว (42U/45U/48U) ต้องใช้อุปกรณ์ประกอบมาตรฐานดังนี้:

![อุปกรณ์ประกอบตู้แร็ค: น็อตกรงสี่เหลี่ยม Cage Nut, รางสไลด์ Sliding Rail และแผ่นปิดช่องว่างกั้นลมร้อน Blanking Panel](/images/datacenter/rack-cage-nuts-blanking-panel.png)

1. **Cage Nuts & Screws (น็อตกรงสี่เหลี่ยมและสกรูยึดแร็ค)**:
   - เสาตู้แร็คเซิร์ฟเวอร์มาตรฐานจะเจาะเป็น **รูสี่เหลี่ยม (Square Hole)** ไม่ได้ต๊าปเกลียวไว้ที่เสาโดยตรง
   - ช่างต้องบีบใส่ **Cage Nut (น็อตตัวเมียที่หุ้มด้วยสปริงกรงเหล็กสี่เหลี่ยม)** เข้าไปจาก **ด้านในของรูเสาแร็ค** แล้วจึงขันสกรู (`M6` หรือ `10-32`) จากด้านหน้าเข้าไปยึดหูเครื่อง
   - **ข้อดี**: หากขันน็อตปีนเกลียวจนเกลียวหวาน ก็แค่แกะ Cage Nut ตัวละไม่กี่บาทออกเปลี่ยนใหม่ ไม่ต้องเปลี่ยนเสาตู้แร็คทั้งตู้! (และควรใช้ **Cage Nut Tool** ช่วยหนีบใส่เพื่อไม่ให้ขอบเหล็กบาดนิ้ว)
2. **Sliding Rails (รางสไลด์รับน้ำหนักเซิร์ฟเวอร์) & CMA (Cable Management Arm)**:
   - เซิร์ฟเวอร์หนัก 20–35 กิโลกรัม **ห้ามยึดแค่หูหน้า 2 ข้างลอยๆ เด็ดขาด** (หูเครื่องจะงอและพัง!) ต้องติดตั้งรางสไลด์ยึดทั้งเสาหน้าและเสาหลังทั้ง 4 มุมเสมอ
   - รางแบบ **Tool-less (เช่น Dell ReadyRails)** สามารถดันเข้าล็อกกับรูสี่เหลี่ยมของเสาแร็คได้โดยไม่ต้องใช้ไขควง และช่วยให้ชักเซิร์ฟเวอร์เลื่อนออกมาด้านหน้าตู้เพื่อเปิดฝาเครื่องซ่อมบำรุงได้สะดวก
3. **Blanking Panels (แผ่นพลาสติก/เหล็กปิดช่องว่าง U หน้าตู้แร็ค)**:
   - **คำถามสัมภาษณ์ยอดฮิต**: *"ทำไมช่อง U ในตู้แร็คที่ว่างอยู่ ถึงห้ามปล่อยโบ๋ไว้เฉยๆ แต่ต้องเอาแผ่นทึบ (Blanking Panel) มาปิดให้เต็ม?"*
   - **คำตอบ**: เพื่อ **ป้องกันลมร้อนจากด้านหลังตู้แร็คไหลย้อนวนกลับมาด้านหน้า (Hot Air Recirculation)** หากปล่อยช่อง U ว่างไว้ พัดลมหน้าเครื่องเซิร์ฟเวอร์ตัวข้างๆ จะดูดลมร้อนจากหลังตู้ตัวเองกลับเข้าไปใหม่ ทำให้ความร้อนสะสมพุ่งสูงขึ้นทันที!

---

## 4. อุปกรณ์เชื่อมต่อหน้าเครื่องเมื่อรีโมทไม่ได้ (Crash Cart, KVM & Serial Console)

เมื่อเกิดเหตุฉุกเฉิน เช่น ตั้งค่า IP ผิดจน SSH และ iDRAC/iLO เข้าไม่ได้เลย ช่างหน้างานจะต้องใช้อุปกรณ์เชื่อมต่อโดยตรงที่หน้าตู้แร็ค:

![การเชื่อมต่อหน้าตู้แร็คด้วยรถเข็น Crash Cart, จอพับ KVM Console และสาย Serial Console สีฟ้าเข้าพอร์ตสวิตช์](/images/datacenter/crash-cart-serial-console.png)

1. **Crash Cart (รถเข็นซ่อมบำรุงประจำห้อง Data Hall)**:
   - รถเข็นที่มีจอภาพ มอนิเตอร์ คีย์บอร์ด เมาส์ และสาย **VGA / DisplayPort / HDMI + USB** สำหรับเข็นไปเสียบหน้าเครื่องเซิร์ฟเวอร์ที่มีปัญหา (หรือในยุคใหม่ใช้อุปกรณ์ขนาดพกพา **USB Crash Cart Adapter** ต่อเข้าโน้ตบุ๊กของช่างเพื่อให้หน้าจอโน้ตบุ๊กกลายเป็นจอของเซิร์ฟเวอร์ได้ทันที!)
2. **Rackmount KVM Console (จอพับ 1U พร้อมสวิตช์สลับเครื่อง)**:
   - จอภาพพร้อมคีย์บอร์ดแบบลิ้นชักความสูงเพียง 1U ที่ติดตั้งตายตัวอยู่ในตู้แร็ค ต่อพ่วงเข้ากับ **KVM Switch (Keyboard, Video, Mouse)** เพื่อกดปุ่มสลับดูหน้าจอของเซิร์ฟเวอร์หลายสิบเครื่องในตู้นั้นได้จากจอเดียว
3. **สาย Console (USB-to-RJ45 Rollover Cable / สายสีฟ้าอ่อน)**:
   - อุปกรณ์เครือข่ายอย่าง **Switch, Router และ Firewall ไม่มีพอร์ตต่อจอภาพ VGA/HDMI!** การเข้าไปตั้งค่าครั้งแรกหรือแก้ปัญหาเมื่อรีโมทไม่ได้ ต้องใช้สาย **Console (ด้านหนึ่งเป็น USB เสียบโน้ตบุ๊ก อีกด้านเป็นหัว RJ45 หรือ Micro-USB เสียบเข้าพอร์ตที่เขียนว่า `CONSOLE` บนสวิตช์)**
   - **ค่ามาตรฐานสากลในการเปิดโปรแกรม PuTTY / Tera Term โหมด Serial (`9600-8-N-1`)**:
     - **Speed (Baud rate)**: **`9600`** (อุปกรณ์บางรุ่นยุคใหม่ใช้ `115200`)
     - **Data bits**: **`8`**
     - **Parity**: **`None`**
     - **Stop bits**: **`1`**
     - **Flow control**: **`None`** *(สำคัญมาก: ถ้าเผลอตั้งเป็น XON/XOFF บางครั้งจะพิมพ์คีย์บอร์ดไม่ไป!)*
', 12, 'beginner', 10, true, '2026-11-10 13:22:20.548088+00', '2026-11-10 13:22:20.548088+00');
INSERT INTO public.lessons VALUES ('3e090998-8642-4e35-af78-02f95246485a', 2, 'network-design-architecture', 'การออกแบบระบบเครือข่าย: สถาปัตยกรรม 3-Tier, Spine-Leaf, Redundancy และการวางแผน IP (Network Design & Architecture)', 'หลักการออกแบบ Enterprise Network: โครงสร้าง 3-Tier (Core, Distribution, Access) เทียบกับ Spine-Leaf ใน Data Center, การออกแบบระบบสำรอง Redundancy (HSRP/VRRP, LACP, vPC), การวางแผนแบ่ง Subnet/VLAN และแนวคิดโซนความปลอดภัย DMZ', '# การออกแบบระบบเครือข่าย: สถาปัตยกรรม 3-Tier, Spine-Leaf, Redundancy และการวางแผน IP

การแก้ปัญหาเครือข่าย (Troubleshooting) ที่ดีเริ่มต้นจากการเข้าใจ **"สถาปัตยกรรมการออกแบบ (Network Architecture)"** เพราะหากระบบเครือข่ายถูกวางโครงสร้างมาอย่างถูกต้อง มีจุดสำรองที่ไร้จุดบอด (No Single Point of Failure) และแบ่งกลุ่มทราฟฟิกชัดเจน เวลาเกิดปัญหาจะสามารถจำกัดวงความเสียหาย (Fault Domain) และสืบหาต้นตอได้อย่างรวดเร็ว

---

## 1. สถาปัตยกรรมองค์กรแบบดั้งเดิม: Cisco Hierarchical 3-Tier Model

สำหรับระบบเครือข่ายสำนักงาน อาคาร หรือแคมปัสองค์กร มาตรฐานสากลที่ใช้มายาวนานคือ **โมเดลลำดับชั้น 3 ระดับ (Hierarchical 3-Tier Network Model)**:

![แผนภาพเปรียบเทียบสถาปัตยกรรมเครือข่าย 3-Tier Model กับ Spine-Leaf Architecture](/images/network/network-3tier-vs-spineleaf.png)

| ชั้น (Layer) | หน้าที่หลัก (Role & Responsibilities) | คุณสมบัติของอุปกรณ์และเทคโนโลยีที่ใช้ |
|---|---|---|
| **1. Core Layer (แกนหลัก)** | **"ทางด่วนส่งข้อมูลด้วยความเร็วสูงสุด"** มีหน้าที่นำส่งแพ็กเก็ตระหว่างส่วนต่างๆ ของเครือข่ายให้เร็วที่สุดเท่าที่จะทำได้<br>• **กฎเหล็ก**: ห้ามใส่ Access Control Lists (ACLs), ห้ามทำ Packet Filtering หรือ QoS ที่ซับซ้อนในชั้นนี้ เพราะจะทำให้สวิตช์ช้าลง | สวิตช์ระดับ Core Switch สเปกสูง มีพอร์ตความเร็วสูง (40G/100G) และทำงานแบบ Redundant คู่เสมอ |
| **2. Distribution Layer (ชั้นกระจายสัญญาณ)** | **"ด่านควบคุมนโยบายและการคัดกรอง"** เชื่อมโยงระหว่าง Access Layer และ Core Layer<br>• ทำหน้าที่ Routing ระหว่าง VLAN (Inter-VLAN Routing)<br>• บังคับใช้นโยบายความปลอดภัย (Firewall / ACLs / Packet Filtering)<br>• รวมทราฟฟิก (Aggregation) และทำ QoS ก่อนส่งขึ้น Core | สวิตช์ Layer 3 ที่รองรับการประมวลผล Routing และ ACLs ได้อย่างรวดเร็ว |
| **3. Access Layer (ชั้นเข้าถึง)** | **"ด่านเชื่อมต่ออุปกรณ์ปลายทาง"** เป็นจุดที่ผู้ใช้งาน คอมพิวเตอร์ ปริ้นเตอร์ กล้องวงจรปิด และ Access Point (AP) เสียบสายเข้ามาในเครือข่าย<br>• กำหนด VLAN ให้กับพอร์ต (Access Port)<br>• มีฟีเจอร์ป้องกันพอร์ต เช่น Port Security, DHCP Snooping, BPDU Guard | สวิตช์ Layer 2 หรือ Layer 2+ ที่มีพอร์ตหนาแน่น (24/48 พอร์ต) และรองรับ PoE จ่ายไฟให้อุปกรณ์ |

> **Collapsed Core Architecture (2-Tier)**:
> ในองค์กรขนาดเล็กถึงขนาดกลาง (SME) ที่มีงบประมาณจำกัด มักจะยุบชั้น Core และ Distribution เข้าด้วยกัน เรียกว่า **Collapsed Core** โดยมีสวิตช์หลักคู่หนึ่งทำหน้าที่ทั้ง Routing และเป็น Core ขององค์กร

---

## 2. สถาปัตยกรรมศูนย์ข้อมูลยุคใหม่: Spine-Leaf Architecture

ทำไมใน **Data Center ยุคใหม่ (Cloud / Virtualization / Microservices)** จึงเลิกใช้โมเดล 3-Tier แล้วเปลี่ยนมาใช้ **Spine-Leaf Architecture (Clos Network)**?

### ความแตกต่างของรูปแบบการไหลของข้อมูล (Traffic Patterns):
- **North-South Traffic**: การไหลเข้า-ออกจากภายนอก (User นอกองค์กร วิ่งเข้ามาหา Server ในห้องแอร์) ➔ โมเดล 3-Tier ออกแบบมาเพื่อรองรับรูปแบบนี้ได้ดี
- **East-West Traffic**: การคุยกันระหว่างเซิร์ฟเวอร์ต่อเซิร์ฟเวอร์ภายในห้องเดียวกัน (Server ➔ Database, Microservice ➔ Cache, VM ➔ VM Replication) ➔ ใน Data Center ยุคใหม่ **ทราฟฟิก East-West พุ่งสูงเกิน 80% ของทราฟฟิกทั้งหมด!**

### จุดเด่นของ Spine-Leaf Architecture:
1. **ทุก Leaf เชื่อมโยงกับทุก Spine (Full Mesh)**:
   - **Leaf Switch**: ทำหน้าที่เป็นสวิตช์ประจำตู้แร็ค (Top-of-Rack - ToR) เชื่อมต่อตรงเข้ากับเซิร์ฟเวอร์
   - **Spine Switch**: ทำหน้าที่เป็นแกนหลักเชื่อมระหว่าง Leaf ทุกตัว
   - **กฎเหล็กของ Spine-Leaf**: **Leaf จะไม่คุยกันเองโดยตรง** และ **Spine จะไม่คุยกันเองโดยตรง**
2. **ระยะทางและความหน่วงคงที่ (Predictable Latency / Maximum 2 Hops)**:
   - เซิร์ฟเวอร์จากตู้แร็คใดๆ จะส่งข้อมูลไปยังเซิร์ฟเวอร์ในตู้แร็คอื่นโดยผ่านเพียง **Leaf ต้นทาง ➔ Spine ➔ Leaf ปลายทาง (เสมอ 2 Hops เท่านั้น!)**
3. **เลิกใช้ STP แล้วแทนที่ด้วย ECMP (Equal-Cost Multi-Pathing)**:
   - สวิตช์ใช้ Routing (Layer 3 เช่น BGP หรือ OSPF) และ ECMP ทำให้สายเชื่อมต่อทุกเส้น **เปิดใช้งานและส่งข้อมูลพร้อมกัน 100% (ไม่มีพอร์ตไหนถูกบล็อกเหมือน Spanning Tree)**

---

## 3. การออกแบบระบบสำรองความพร้อมใช้งานสูง (High Availability & Redundancy)

เครือข่ายระดับมืออาชีพต้องไม่มี **Single Point of Failure (SPOF)** หากสายขาดหรือสวิตช์ตัวใดตัวหนึ่งระเบิด ระบบต้องทำงานต่อได้ทันทีโดยผู้ใช้ไม่รู้สึก:

![การออกแบบระบบสำรอง Gateway ด้วย HSRP และ VRRP คู่กับ Link Aggregation LACP](/images/network/hsrp-vrrp-redundancy-design.png)

### 1) การสำรอง Default Gateway: First Hop Redundancy Protocols (FHRP)
คอมพิวเตอร์ลูกข่ายมักตั้งค่า Default Gateway เป็น IP เดียว หากเราเตอร์ตัวนั้นดับ เครื่องจะออกเน็ตไม่ได้ จึงต้องรวมสวิตช์/เราเตอร์ 2 ตัวเข้าด้วยกันด้วย Virtual IP (VIP):
- **HSRP (Hot Standby Router Protocol)**: โปรโตคอลเฉพาะของ Cisco แบ่งบทบาทเป็น **Active** (ทำงานตัวหลัก) และ **Standby** (รอสแตนด์บาย)
- **VRRP (Virtual Router Redundancy Protocol)**: มาตรฐานเปิดสากล (RFC 5798) ทำงานร่วมกันได้ทุกยี่ห้อ แบ่งเป็น **Master** และ **Backup**

### 2) การรวมสายสัญญาณสำรอง: LACP / Port Channel
การลากสายแลน 2–4 เส้นระหว่างสวิตช์เพื่อเพิ่มแบนด์วิดท์และเป็นเส้นทางสำรอง:
- ใช้มาตรฐาน **802.3ad / 802.1AX (LACP - Link Aggregation Control Protocol)**
- หากสายเส้นใดเส้นหนึ่งขาด ทราฟฟิกจะวิ่งผ่านสายเส้นที่เหลือทันทีโดยไม่เกิด Packet Drop

### 3) การเชื่อมต่อแบบ Multi-Chassis (vPC / VSS / Switch Stacking)
เพื่อให้เซิร์ฟเวอร์ 1 เครื่องสามารถต่อสายแลน 2 เส้นแยกไปยังสวิตช์คนละตัว (Switch A และ Switch B) เพื่อทำ LACP ข้ามตู้ได้:
- **Cisco vPC (Virtual Port Channel)**: นิยมใช้บนสวิตช์ Cisco Nexus ใน Data Center
- **Switch Stacking (เช่น Cisco Catalyst StackWise)**: นำสวิตช์หลายตัวมาผูกรวมเป็นสวิตช์เสมือนตัวเดียวกัน ควบคุมผ่าน Management IP เดียว

---

## 4. การวางแผนผัง IP และการแบ่งโซนความปลอดภัย (Network Segmentation)

การออกแบบผัง IP ที่ดีต้องคิดถึงการขยายตัวในอนาคต (Scalability) และความปลอดภัย:

1. **การแบ่ง VLAN ตามหน้าที่การทำงาน (Functional Segmentation)**:
   - ห้ามนำเครื่องลูกข่าย เซิร์ฟเวอร์ และระบบจัดการมารวมอยู่ใน VLAN เดียวกันเด็ดขาด!
   - ตัวอย่างการจัดสรร VLAN มาตรฐาน:
     - `VLAN 10` (Workstations / Users): `10.10.10.0/24`
     - `VLAN 20` (Voice / VoIP): `10.10.20.0/24` (เปิด QoS จัดลำดับความสำคัญ)
     - `VLAN 50` (Server Farm / Production): `10.10.50.0/24`
     - `VLAN 99` (Management / OOB): `10.10.99.0/24` (จำกัดสิทธิ์เฉพาะแอดมิน)
2. **การออกแบบโซน DMZ (Demilitarized Zone)**:
   - โซนที่อยู่ตรงกลางระหว่างอินเทอร์เน็ตภายนอกกับเครือข่ายภายในองค์กร
   - วางเฉพาะเซิร์ฟเวอร์ที่ต้องเปิดให้คนภายนอกเข้าถึง (เช่น Web Server, Reverse Proxy, Mail Gateway)
   - **กฎเหล็กของ DMZ**: **เซิร์ฟเวอร์ใน DMZ ต้องไม่มีสิทธิ์สั่งเปิดการเชื่อมต่อไปยังเครือข่ายภายใน (Internal Network) ได้โดยตรง!** (หากเว็บถูกแฮก คนร้ายจะติดอยู่ที่ DMZ ไม่สามารถทะลุเข้าฐานข้อมูลองค์กรได้)
', 12, 'intermediate', 11, true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.lessons VALUES ('93a91167-81c5-4497-a769-3930c59a54b1', 11, 'tools-cisco-packet-tracer', 'Cisco Packet Tracer: การจำลองระบบเครือข่าย, โหมด Realtime vs Simulation และการแกะแพ็กเก็ต PDU (Cisco Packet Tracer Essentials)', 'ภาพรวมโปรแกรม Cisco Packet Tracer, การต่อสายและอุปกรณ์ Cisco (Router, Catalyst Switch, PC, Server), ความต่างของ Realtime Mode vs Simulation Mode (Event List, PDU Inspector) และข้อจำกัดเมื่อเทียบกับอุปกรณ์จริง', '# Cisco Packet Tracer: การจำลองระบบเครือข่าย, โหมด Realtime vs Simulation และการแกะแพ็กเก็ต PDU

สำหรับทุกคนที่เริ่มต้นศึกษาด้าน Network, System Support หรือเตรียมสอบใบเซอร์ระดับสากลอย่าง **Cisco CCNA (200-301)** โปรแกรมจำลองเครือข่ายตัวแรกที่ทุกคนต้องได้สัมผัสคือ **Cisco Packet Tracer** ซึ่งพัฒนาโดย Cisco Networking Academy เพื่อให้เราสามารถออกแบบ ต่อสาย และพิมพ์คำสั่งคอนฟิกอุปกรณ์เครือข่ายได้เสมือนนั่งอยู่หน้าตู้แร็คจริงโดยไม่ต้องเสียเงินซื้ออุปกรณ์ฮาร์ดแวร์หลักแสนบาท

---

## 1. Packet Tracer คืออะไร และทำงานอย่างไร?

**Cisco Packet Tracer จัดเป็นซอฟต์แวร์ประเภท "Network Simulator" (โปรแกรมจำลองพฤติกรรมเครือข่าย)**:
- ตัวโปรแกรมไม่ได้รันระบบปฏิบัติการ Cisco IOS จริงๆ แต่ใช้วิธี **เขียนโปรแกรมเลียนแบบ (Simulate) การทำงานและคำสั่งของ IOS**
- **ข้อดี**: กินทรัพยากรเครื่องน้อยมาก คอมพิวเตอร์สเปกทั่วไปหรือโน้ตบุ๊กทำงานก็สามารถเปิดแล็บที่มี Router 10 ตัว Switch 20 ตัวได้ลื่นไหล ไม่กิน RAM และ CPU
- **ข้อจำกัดสำคัญ**: รองรับเฉพาะชุดคำสั่งพื้นฐานถึงระดับกลางของ Cisco IOS เท่านั้น คำสั่งระดับสูงเฉพาะทาง (เช่น สวิตชิ่งฟีเจอร์ขั้นสูงบางตัว, Dynamic Routing ขั้นสูง, BGP แบบละเอียด) จะพิมพ์ไม่ผ่าน

![หน้าจอโปรแกรม Cisco Packet Tracer แสดงการต่อ Topology และการจำลอง PDU ในโหมด Simulation](/images/tools/packet-tracer-simulation-mode.png)

---

## 2. การเลือกอุปกรณ์และชนิดสายเชื่อมต่อ (Device & Cable Selection)

ที่แถบเครื่องมือด้านล่างซ้ายของโปรแกรม คุณจะพบกับหมวดหมู่อุปกรณ์ที่ต้องเลือกใช้งาน:

| สัญลักษณ์ / อุปกรณ์ | อุปกรณ์ยอดนิยมในโปรแกรม | หน้าที่และการใช้งานในแล็บ |
|---|---|---|
| **Routers** | **Cisco 2911 / 4321 / 1941** | ทำหน้าที่เชื่อมต่อข้ามเครือข่าย (Layer 3 Routing), NAT, DHCP Server และสร้าง VPN |
| **Switches** | **Cisco Catalyst 2960 (Layer 2) / 3650 (Layer 3 Multilayer Switch)** | เชื่อมต่ออุปกรณ์ในวงแลนเดียวกัน, ตั้งค่า VLAN, Trunking 802.1Q, Spanning Tree และ Inter-VLAN Routing บน 3650 |
| **End Devices** | **PC, Laptop, Server, Printer** | เครื่องลูกข่ายสำหรับตั้งค่า IP, ทดสอบ `ping`, `ipconfig`, ใช้งาน Web Browser, และ Server จำลอง (DNS, HTTP, DHCP, Syslog, TFTP) |
| **Connections (สายเชื่อมต่อ)** | • **Copper Straight-Through (สายตรงเส้นทึบ)**<br>• **Copper Cross-Over (สายครอสเส้นประ)**<br>• **Fiber (สายไฟเบอร์สีส้ม)**<br>• **Console (สายสีฟ้าอ่อน)**<br>• **Serial DTE/DCE (สายสีแดงมีนาฬิกา)** | • **สายตรง**: ต่ออุปกรณ์ต่างชนิดกัน (PC ➔ Switch, Switch ➔ Router)<br>• **สายครอส**: ต่ออุปกรณ์ชนิดเดียวกัน (Switch ➔ Switch, Router ➔ Router, PC ➔ PC)<br>• **สาย Console**: ต่อจาก RS-232/USB ของ PC เข้าพอร์ต CONSOLE เพื่อเปิดหน้าต่าง Terminal คอนฟิก |

> **Support Tip: Auto-Connect Cable (สายสายฟ้าสีส้ม)**:
> หากเป็นมือใหม่ที่ไม่แน่ใจว่าต้องใช้สายประเภทใด สามารถคลิกที่ไอคอน **รูปสายฟ้าสีส้ม (Automatically Choose Connection Type)** โปรแกรมจะเลือกประเภทสายและพอร์ตที่เหมาะสมให้โดยอัตโนมัติ

---

## 3. หัวใจสำคัญ: Realtime Mode vs Simulation Mode

จุดแข็งที่สุดที่ทำให้ Cisco Packet Tracer เหนือกว่าการทดลองบนอุปกรณ์จริงสำหรับผู้เริ่มต้น คือการสลับระหว่าง 2 โหมดการทำงาน:

### 1) Realtime Mode (โหมดเวลาจริง - รูปนาฬิกา)
- ระบบเครือข่ายทำงานตามเวลาจริง เช่นเดียวกับสวิตช์และเราเตอร์ของจริง
- เมื่อเสียบสายแลน ไฟพอร์ตจะขึ้น **สีส้มกะพริบประมาณ 30–50 วินาที** (เพราะ Spanning Tree Protocol กำลังทำงานในสถานะ Listening ➔ Learning ➔ Forwarding)
- **ทิปเร่งเวลา**: สามารถกดปุ่ม **"Fast Forward Time (Alt + D)"** เพื่อเร่งเวลาข้ามขั้นตอนรอคอย ให้ไฟพอร์ตเปลี่ยนเป็นสีเขียวทันที!

### 2) Simulation Mode (โหมดจำลองภาพทีละก้าว - รูปนาฬิกาทราย/ซองจดหมาย)
- **เวลาในเครือข่ายจะหยุดนิ่งชั่วคราว!**
- เมื่อคุณสั่ง `ping` จาก PC0 ไปยัง PC1 คุณจะเห็น **ซองจดหมาย (PDU - Protocol Data Unit)** ปรากฏขึ้นบนหน้าจอ
- เมื่อคุณกดปุ่ม **"Capture / Forward" (หรือกดแป้น Spacebar)** ซองจดหมายจะค่อยๆ เคลื่อนที่ทีละสเต็ป จาก PC0 ➔ Switch ➔ Router ➔ PC1
- **Event List & Event Filter**: สามารถกดฟิลเตอร์เลือกดูเฉพาะโปรโตคอลที่สนใจได้ เช่น ดูเฉพาะ `ICMP`, `ARP`, `DNS`, `TCP`, `OSPF`

---

## 4. การผ่าโครงสร้างซองจดหมายด้วย PDU Inspector

เมื่อคลิกที่ซองจดหมายในโหมด Simulation หน้าต่าง **PDU Information** จะเปิดขึ้นมา โดยแสดงข้อมูลแบ่งเป็น 2 มุมมองที่มีประโยชน์อย่างมหาศาลต่อการเรียนรู้:

1. **OSI Model View (วิเคราะห์ตาม 7 เลเยอร์)**:
   - แสดงให้เห็นทีละ Layer ตั้งแต่ **Layer 1 ถึง Layer 7** ทั้งฝั่งขาเข้า (**In Layers**) และฝั่งขาออก (**Out Layers**)
   - มีคำอธิบายภาษาอังกฤษชัดเจน เช่น:
     - *Layer 3: The destination IP address is not on the same subnet. The device sends the packet to the default gateway.*
     - *Layer 2: The next-hop IP is not in the ARP table. The device drops the frame and broadcasts an ARP Request.*
2. **Inbound / Outbound PDU Details (ผ่าไส้ในแพ็กเก็ต)**:
   - แสดงโครงสร้าง Header จริง เช่น **Ethernet II Frame** (Source/Destination MAC), **IP Packet Header** (TTL, Protocol 1 สำหรับ ICMP, Source/Destination IP) และ **ICMP Payload**

---

## 5. การจัดการไฟล์และการเตรียมสอบ: PKT vs PKA

- **ไฟล์ `.pkt` (Packet Tracer Network File)**: ไฟล์บันทึกผังเครือข่ายและคอนฟิกอุปกรณ์ทั่วไปที่เราสร้างขึ้น สามารถเซฟและส่งต่อให้เพื่อนร่วมทีมเปิดดูได้
- **ไฟล์ `.pka` (Packet Tracer Activity File)**: ไฟล์โจทย์แบบฝึกหัดที่ล็อกการตั้งค่าไว้ มีหน้าต่างคำสั่งงาน (Instruction) พร้อมระบบ **ตรวจคะแนนอัตโนมัติ (Completion %)** และปุ่ม **Check Results** เพื่อดูว่าเราคอนฟิกหัวข้อใดถูกหรือผิด เป็นรูปแบบเดียวกับที่ใช้สอบวัดผลในหลักสูตร Cisco Networking Academy
', 12, 'beginner', 1, true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.lessons VALUES ('9a90cb58-d93b-420d-b47b-7cb59fd88ba0', 11, 'tools-gns3-network-emulation', 'GNS3 & Network Emulation: การจำลองเราเตอร์ สวิตช์ และเซิร์ฟเวอร์ด้วย Real OS และ GNS3 VM (GNS3 & EVE-NG Emulation)', 'ความแตกต่างระหว่าง Network Simulator (Packet Tracer) vs Network Emulator (GNS3 / EVE-NG), สถาปัตยกรรม GNS3 GUI + GNS3 VM, การนำเข้า Cisco IOU / Dynamips / QEMU / Docker, การดักจับ Packet ด้วย Wireshark แบบเรียลไทม์', '# GNS3 & Network Emulation: การจำลองเราเตอร์ สวิตช์ และเซิร์ฟเวอร์ด้วย Real OS และ GNS3 VM

เมื่อคุณก้าวข้ามจากระดับเริ่มต้น (CCNA) ไปสู่ระดับสูง (CCNP, CCIE, หรือระดับวิศวกรออกแบบระบบ Enterprise) คุณจะพบว่าข้อจำกัดของ Cisco Packet Tracer ไม่เพียงพออีกต่อไป เพราะในโลกความเป็นจริงคุณต้องทดสอบฟีเจอร์ขั้นสูง เช่น BGP, MPLS, OSPF Multi-Area, หรือเชื่อมต่อ Router ของ Cisco เข้ากับอุปกรณ์ยี่ห้ออื่นอย่าง Juniper, MikroTik, Fortinet และ Linux Server จริงๆ เครื่องมือระดับมาตรฐานอุตสาหกรรมสำหรับงานนี้คือ **GNS3 (Graphical Network Simulator-3)** และ **EVE-NG**

---

## 1. Network Simulator vs Network Emulator: ต่างกันอย่างไร?

คำถามสัมภาษณ์ยอดฮิตที่ทดสอบความรู้ลึกทางเทคนิค:

![สถาปัตยกรรม GNS3 Architecture ทำงานร่วมกับ GNS3 VM และการต่อ Bridge เข้ากับเครือข่ายจริง](/images/tools/gns3-vm-architecture.png)

| คุณสมบัติ | Network Simulator (เช่น Cisco Packet Tracer) | Network Emulator (เช่น GNS3, EVE-NG) |
|---|---|---|
| **การทำงานเบื้องหลัง** | **เขียนโค้ดเลียนแบบพฤติกรรม** (Simulated Software) คำสั่งไหนคนเขียนโปรแกรมไม่ได้ใส่ไว้จะพิมพ์ไม่ผ่าน | **จำลองฮาร์ดแวร์เสมือน (CPU/RAM/NIC) แล้วนำ "ระบบปฏิบัติการจริง (Real OS Image)" มาบูตทำงาน** |
| **ความสมจริงของฟังก์ชัน** | รองรับคำสั่งประมาณ 40–60% ของอุปกรณ์จริง | **สมจริง 100%!** คุณรัน Cisco IOS/IOS-XE, Juniper Junos, หรือ FortiOS ของจริง พิมพ์ได้ทุกคำสั่งและพฤติกรรมบั๊กเหมือนเครื่องจริงทุกประการ |
| **การเชื่อมต่ออุปกรณ์ต่างค่าย** | จำลองได้เฉพาะอุปกรณ์ในระบบนิเวศของ Cisco | **จำลองอุปกรณ์ได้ไม่จำกัดค่าย** (Cisco, Arista, Juniper, MikroTik, Linux, Windows Server, pfSense) |
| **การใช้ทรัพยากรเครื่อง** | ใช้ RAM/CPU น้อยมาก (ไม่เกิน 500 MB) | **กิน RAM และ CPU ตามจำนวนระบบปฏิบัติการจริง** (มักต้องใช้คอมพิวเตอร์ RAM 16–32 GB ขึ้นไป) |
| **การจับแพ็กเก็ต (Packet Capture)** | ใช้โหมด Simulation ภายในโปรแกรม | **คลิกขวาแล้วเปิดโปรแกรม Wireshark ตัวจริงมาดักจับแพ็กเก็ตที่วิ่งผ่านสายสัญญาณแบบเรียลไทม์ได้เลย!** |

---

## 2. สถาปัตยกรรมของ GNS3: GUI Client + GNS3 VM

ในการติดตั้ง GNS3 อย่างถูกต้องตามมาตรฐานสากล จะแบ่งโครงสร้างเป็น 2 ส่วนหลัก:

1. **GNS3 All-in-One GUI Client**:
   - เป็นโปรแกรมหน้าต่างกราฟิกติดตั้งบน Windows/macOS ของคุณ ใช้สำหรับวาดผัง (Topology), ลากวางอุปกรณ์, ลากสายเชื่อมต่อ และเปิดหน้าต่าง Terminal
2. **GNS3 VM (Virtual Machine)**:
   - เป็นระบบปฏิบัติการ Linux (Ubuntu) ที่ติดตั้งอยู่บน Hypervisor เช่น **VMware Workstation, VMware ESXi หรือ VirtualBox**
   - **ทำไมต้องมี GNS3 VM?**: เพราะระบบปฏิบัติการเราเตอร์ยุคใหม่ (QEMU / KVM, IOU, Docker) ทำงานบน Linux Kernel ได้รวดเร็วและเสถียรกว่าบน Windows โดยตรงหลายเท่าตัว! ชิป CPU บนเครื่องของคุณจะเปิดฟีเจอร์ **Nested Virtualization (VT-x/AMD-V)** ส่งตรงให้ GNS3 VM จัดการ

---

## 3. รูปแบบอิมเมจของอุปกรณ์ที่นำมาวิ่งใน GNS3

เมื่อคุณต้องการเพิ่มอุปกรณ์ใหม่เข้าไปใน GNS3 คุณจะได้ยินคำศัพท์เทคนิค 4 ชนิดนี้เสมอ:

1. **Dynamips (Cisco IOS Image เก่า)**:
   - บูตไฟล์ `.bin` ของเราเตอร์ตระกูลเก่า เช่น Cisco 7200, 3725, 2691
   - **เทคนิคสำคัญ (Idle-PC)**: เนื่องจากเราเตอร์จริงไม่มีระบบประหยัดพลังงาน เมื่อรันในคอมพิวเตอร์ CPU ของคุณจะวิ่ง 100% ทันที ช่างเทคนิคจึงต้องคลิกขวาแล้วคำนวณค่า **`Idle-PC`** เพื่อบอกให้โปรแกรมสั่งหยุดรอบหมุน CPU ตอนเราเตอร์ว่างงาน ทำให้ CPU ลดลงเหลือ 1–2%
2. **Cisco IOU / IOL (IOS on Linux / IOS on Unix)**:
   - ไบนารีของ Cisco IOS ที่คอมไพล์มาเพื่อรันบนระบบปฏิบัติการ Linux โดยตรง
   - **ข้อดี**: กิน RAM น้อยมาก (สวิตช์ 1 ตัวใช้ RAM เพียง 256–512 MB) และรองรับคำสั่ง Layer 2 Switching ขั้นสูงอย่างสมบูรณ์แบบ
3. **QEMU / KVM Appliances (อิมเมจสมัยใหม่)**:
   - ใช้จำลองอุปกรณ์ระดับองค์กรยุคใหม่ เช่น **Cisco CSR1000v / Catalyst 8000v (IOS-XE), Cisco ASAv (Firewall), Nexus 9000v, FortiGate VM, MikroTik CHR, Ubuntu Server**
   - อิมเมจมักมาในรูปแบบไฟล์ `.qcow2` หรือ `.vmdk`
4. **Docker Containers**:
   - คอนเทนเนอร์ขนาดจิ๋วที่เปิดใช้งานได้ใน 1 วินาที เหมาะสำหรับทำโฮสต์ทดสอบ (เช่น Alpine Linux, Network Tools, Web Server) กิน RAM เพียง 16–32 MB ต่อตัว

---

## 4. ฟีเจอร์ไม้ตาย: Wireshark Live Capture & Cloud Node

สิ่งที่ทำให้วิศวกรเครือข่ายทั่วโลกยกย่อง GNS3 คือ 2 ฟีเจอร์นี้:

1. **Live Packet Capture with Wireshark**:
   - เพียงแค่คลิกขวาที่เส้นสายเคเบิลระหว่าง Router 1 กับ Switch 1 แล้วเลือก **"Start Capture"**
   - โปรแกรม **Wireshark ตัวจริงจะเด้งเปิดขึ้นมาทันที** และดักจับแพ็กเก็ตที่วิ่งผ่านสายเส้นนั้นแบบสดๆ ช่วยให้คุณเห็นแพ็กเก็ต OSPF Hello, BGP Open, หรือ TCP SYN ที่เราเตอร์ส่งหากันจริงๆ!
2. **Cloud Node (การเชื่อมต่อเข้ากับเน็ตเวิร์กของโลกจริง)**:
   - คุณสามารถลากไอคอน **`Cloud`** หรือ **`NAT`** มาวางในผัง แล้วลากสายแลนจากเราเตอร์เสมือนไปเสียบเข้ากับ Cloud Node
   - ผลลัพธ์: **เราเตอร์เสมือนในคอมพิวเตอร์ของคุณจะสามารถออกสู่อินเทอร์เน็ตจริงได้!** สามารถสั่ง `ping 8.8.8.8`, สั่งอัปเดตแพ็กเกจบน Linux Server ในแล็บ หรือให้คอมพิวเตอร์ข้างนอกบ้าน SSH ข้ามเข้ามาจัดการเราเตอร์ในแล็บได้เสมือนอุปกรณ์จริง
', 13, 'intermediate', 2, true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.lessons VALUES ('e0a4cdec-9071-4a41-bc6a-0aa782e85680', 11, 'tools-wireshark-packet-analysis', 'Wireshark: การดักจับและผ่าโครงสร้างแพ็กเก็ต การใช้ Capture/Display Filters และวิเคราะห์ปัญหา (Wireshark Deep Dive)', 'เจาะลึกโปรแกรม Wireshark, การเลือก Interface ดักจับ (Promiscuous Mode / Monitor Mode), ความต่างของ Capture Filter (BPF) vs Display Filter, เทคนิค Follow TCP Stream, Expert Info (Retransmission, Zero Window, RST) และการคำนวณ Latency', '# Wireshark: การดักจับและผ่าโครงสร้างแพ็กเก็ต การใช้ Capture/Display Filters และวิเคราะห์ปัญหา

ในโลกของการแก้ปัญหาเครือข่ายระดับมืออาชีพ มีคำกล่าวว่า: *"แพ็กเก็ตไม่เคยโกหก (Packets Never Lie)"* ต่อให้แอปพลิเคชันจะฟ้องข้อความ Error คลุมเครือ หรือระบบปลายทางจะอ้างว่าฝั่งตนเองปกติ แต่ถ้าคุณเปิดโปรแกรม **Wireshark (Network Protocol Analyzer)** ขึ้นมาดักจับและผ่าดูไส้ในแพ็กเก็ต คุณจะเห็นความจริง 100% ว่าใครส่งอะไรมา หรือใครไม่ตอบสนอง

---

## 1. ส่วนประกอบหน้าต่างโปรแกรม Wireshark (The 3 Panes)

เมื่อเปิดไฟล์บันทึกการดักจับ (`.pcap` หรือ `.pcapng`) หน้าจอหลักของ Wireshark จะแบ่งเป็น 3 บานหน้าต่าง (Three-Pane View):

![หน้าต่างโปรแกรม Wireshark แสดง Packet List, Packet Details, Display Filter และ Expert Information](/images/tools/wireshark-interface-filters.png)

1. **Top Pane: Packet List (รายการแพ็กเก็ตทั้งหมด)**:
   - แสดงรายการแพ็กเก็ตเรียงตามเวลา (`No.`, `Time`, `Source`, `Destination`, `Protocol`, `Length`, `Info`)
   - มีแถบสีอัตโนมัติ (**Coloring Rules**) ช่วยแยกแยะ เช่น สีเขียวอ่อน = HTTP, สีฟ้าอ่อน = DNS, สีดำตัวหนังสือแดง = TCP Error / Retransmission / RST
2. **Middle Pane: Packet Details (ผ่าโครงสร้างตามชั้น OSI / TCP-IP)**:
   - จุดเด่นที่สุดของ Wireshark! แสดง Header ของแต่ละชั้นที่ซ้อนกันอยู่ (Encapsulation):
     - **Frame**: ข้อมูลระดับกายภาพ (Layer 1) เช่น ความยาวบิต และเวลาประทับ
     - **Ethernet II**: ข้อมูล Layer 2 (Source/Destination MAC Address)
     - **Internet Protocol Version 4/6**: ข้อมูล Layer 3 (Source/Destination IP, TTL, Flags)
     - **Transmission Control Protocol / UDP**: ข้อมูล Layer 4 (Source/Destination Port, Seq, Ack, Window Size)
     - **Hypertext Transfer Protocol / DNS**: ข้อมูล Layer 7 (Application Data)
3. **Bottom Pane: Packet Bytes (ข้อมูลไบนารีระดับ Raw Bytes)**:
   - แสดงรหัสเลขฐานสิบหก (**Hex Dump**) คู่กับตัวอักษร ASCII ดิบทางฝั่งขวา

---

## 2. กฎเหล็ก: Capture Filter vs Display Filter ต่างกันอย่างไร?

ข้อผิดพลาดอันดับหนึ่งของผู้เริ่มต้นคือการจำสับสนระหว่างฟิลเตอร์ 2 ชนิดนี้:

| คุณลักษณะ | Capture Filter (ฟิลเตอร์ก่อนดักจับ) | Display Filter (ฟิลเตอร์หลังดักจับ) |
|---|---|---|
| **จังหวะการทำงาน** | **กรองตั้งแต่ตอนดักจับข้อมูลจริง** แพ็กเก็ตที่ไม่ตรงเงื่อนไขจะถูกทิ้งทันที ไม่ถูกบันทึกหรือกินพื้นที่ใน RAM | **ดักจับทุกอย่างมาก่อน แล้วค่อยซ่อน/แสดงเฉพาะแพ็กเก็ตที่ต้องการ** บนหน้าจอในภายหลัง |
| **ตำแหน่งที่ใส่** | กล่องข้อความสีเขียวก่อนกดเริ่ม Start Capture | แถบข้อความด้านบนสุดของหน้าต่าง Packet List (พิมพ์แล้วแถบจะเป็นสีเขียวถ้าไวยากรณ์ถูก, สีแดงถ้าไวยากรณ์ผิด) |
| **ไวยากรณ์ (Syntax)** | **BPF (Berkeley Packet Filter)**<br>• ตัวอย่าง: `host 192.168.1.1`<br>• `port 80 or port 443`<br>• `net 10.0.0.0/8`<br>• `not arp and not icmp` | **Wireshark Display Syntax**<br>• ตัวอย่าง: `ip.addr == 192.168.1.1`<br>• `tcp.port in {80, 443}`<br>• `http.response.code >= 400`<br>• `tcp.flags.reset == 1` |
| **ความยืดหยุ่น** | ต่ำกว่า (เปลี่ยนเงื่อนไขระหว่างจับไม่ได้) | **สูงมาก** (สามารถพิมพ์เปลี่ยนมุมมองค้นหาข้อมูลได้ตลอดเวลาโดยข้อมูลดิบไม่หาย) |

---

## 3. สูตรลัด Display Filter สำหรับงาน Support ประจำวัน

เมื่อต้องสืบหาสาเหตุว่า *"เว็บช้า"*, *"ต่อไม่ติด"*, หรือ *"ระบบตัดการเชื่อมต่อไปเอง"* ให้ใช้สูตรฟิลเตอร์ยอดฮิตเหล่านี้:

```text
# 1. กรองเฉพาะ IP หรือ Subnet ที่ต้องการ
ip.addr == 10.20.1.50
ip.src == 192.168.1.100 and ip.dst == 10.0.0.1

# 2. กรองหาปัญหาการเชื่อมต่อ TCP หลุด หรือถูกปฏิเสธ (Connection Reset / Refused)
tcp.flags.reset == 1

# 3. กรองหาแพ็กเก็ตที่ส่งซ้ำเนื่องจากเน็ตเวิร์กกระตุกหรือสูญหาย (Packet Loss / Retransmission)
tcp.analysis.retransmission
tcp.analysis.duplicate_ack

# 4. กรองหาอาการเครื่องเซิร์ฟเวอร์ประมวลผลไม่ทันจนบัฟเฟอร์เต็ม (TCP Zero Window)
tcp.analysis.zero_window

# 5. กรองหาข้อผิดพลาดของเว็บและ API (HTTP 4xx Client Error หรือ 5xx Server Error)
http.response.code >= 400

# 6. กรองเฉพาะการสืบค้น DNS ที่ตอบกลับเป็น Error (เช่น ไม่พบชื่อโดเมน NXDOMAIN)
dns.flags.rcode != 0
```

---

## 4. เทคนิคไม้ตาย: Follow TCP Stream & Expert Info

1. **Follow ➔ TCP Stream**:
   - เมื่อเห็นแพ็กเก็ต HTTP หรือการคุยกันของแอปพลิเคชัน เพียงแค่ **คลิกขวาที่แพ็กเก็ตนั้น ➔ เลือก Follow ➔ TCP Stream**
   - Wireshark จะถอดรหัสแพ็กเก็ตหลายร้อยตัว แล้วนำข้อความบทสนทนามาต่อกันเป็นหน้าต่างเดียวให้อ่านเหมือนแชต!
   - **ข้อความสีแดง** = ข้อมูลที่ฝั่ง Client ส่งไป (เช่น `GET /api/login HTTP/1.1`)
   - **ข้อความสีน้ำเงิน** = ข้อมูลที่ฝั่ง Server ตอบกลับมา (เช่น `HTTP/1.1 500 Internal Server Error`)
2. **Expert Information (วิเคราะห์ปัญหาอัตโนมัติ)**:
   - คลิกที่ปุ่มวงกลมสีที่มุมล่างซ้าย หรือเมนู **Analyze ➔ Expert Information**
   - Wireshark จะสรุปความผิดปกติของเครือข่ายออกมาเป็นหมวดหมู่ทันที:
     - **Errors (สีแดง)**: เช่น Malformed Packet หรือ Checksum ผิด
     - **Warnings (สีเหลือง)**: เช่น Connection Reset, Retransmission, Spurious Retransmission
     - **Notes (สีฟ้า)**: เช่น HTTP 404, Reassembled PDU
', 13, 'intermediate', 3, true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.lessons VALUES ('3b325ae8-b7e2-4b0a-b86d-8e2bef22bd87', 11, 'tools-nmap-iperf-diagnostics', 'Nmap & iPerf3: การสแกนพอร์ต ตรวจสอบช่องโหว่ และวัดประสิทธิภาพ Throughput เครือข่าย (Network Scanning & Performance Testing)', 'การใช้งาน Nmap ค้นหา Host และ Port (-sS Stealth SYN, -sT, -sV, -O, -sU), การใช้งาน iPerf3 ทดสอบความเร็ว Throughput ท่อเครือข่าย (TCP Bandwidth, UDP Jitter & Packet Loss) และการใช้งาน WinMTR ตรวจจุด Latency คอขวด', '# Nmap & iPerf3: การสแกนพอร์ต ตรวจสอบช่องโหว่ และวัดประสิทธิภาพ Throughput เครือข่าย

เมื่อมีข้อสงสัยว่า *"มีเซิร์ฟเวอร์เปิดพอร์ตอะไรทิ้งไว้บ้าง?"* หรือผู้ใช้งานบ่นว่า *"เน็ตเวิร์กระหว่างสาขาวิ่งช้ามาก ไม่ได้ความเร็ว 1 Gbps ตามที่ขอผู้ให้บริการไว้"* สองเครื่องมือมาตรฐานสากลที่สาย Network และ System Engineer ต้องมีติดตัวเสมอคือ **Nmap (Network Mapper)** และ **iPerf3**

---

## 1. Nmap: สุดยอดเครื่องมือสำรวจและสแกนพอร์ต (Network Scanner)

**Nmap** คือเครื่องมือโอเพนซอร์สที่ใช้ค้นหาเครื่องโฮสต์ที่เปิดอยู่ในเครือข่าย (Host Discovery), ตรวจสอบพอร์ตที่เปิดให้บริการ (Port Scanning), ค้นหาเวอร์ชันของระบบปฏิบัติการ (OS Detection) และบริการที่รันอยู่ (Service Fingerprinting)

![ผลลัพธ์การสแกนพอร์ตด้วย Nmap และการทดสอบความเร็ว Bandwidth Throughput ด้วย iPerf3](/images/tools/nmap-iperf3-testing.png)

### รูปแบบคำสั่ง Nmap ที่ใช้จริงในงาน Support:

```bash
# 1. Ping Scan (ค้นหาว่ามี IP ใดเปิดเครื่องอยู่บ้างในวงแลน โดยไม่ต้องสแกนพอร์ต)
nmap -sn 192.168.1.0/24

# 2. TCP SYN Stealth Scan (สแกนแบบเนียน: ไม่ต่อ Handshake ครบ 3 ขั้น ไม่บันทึกลง Application Log)
sudo nmap -sS 10.20.1.50

# 3. สแกนตรวจสอบเวอร์ชันของบริการ (Service Version Detection) และระบบปฏิบัติการ (OS Detection)
sudo nmap -sV -O 10.20.1.50

# 4. สแกนพอร์ตเฉพาะเจาะจง หรือสแกนครบทุกพอร์ต (1-65535)
nmap -p 22,80,443,3389 10.20.1.50
nmap -p- 10.20.1.50

# 5. สแกนพอร์ต UDP (ช้ากว่า TCP มาก ต้องระบุพอร์ตชัดเจน เช่น DNS 53 หรือ SNMP 161)
sudo nmap -sU -p 53,161 10.20.1.50

# 6. ใช้ Nmap Scripting Engine (NSE) ตรวจสอบช่องโหว่เบื้องต้น
nmap --script vuln 10.20.1.50
```

### การอ่านสถานะของพอร์ต (Port States) จากผลลัพธ์ Nmap:
- **`open`**: มีแอปพลิเคชันกำลังดักฟัง (Listening) และยอมรับการเชื่อมต่อ
- **`closed`**: แพ็กเก็ตส่งไปถึงเครื่องปลายทาง แต่ **ไม่มีแอปพลิเคชันเปิดฟังที่พอร์ตนั้น** (เครื่องตอบกลับมาด้วย TCP RST ทันที)
- **`filtered`**: แพ็กเก็ตไปไม่ถึงหรือไม่มีการตอบกลับ เพราะ **ถูก Firewall หรือ Access Control List (ACL) บล็อกไว้กลางทาง**

---

## 2. iPerf3: เครื่องมือวัดแบนด์วิดท์ Throughput ท่อเครือข่ายจริง

เวลาทดสอบความเร็ว หลายคนชอบทดสอบด้วยการดาวน์โหลดไฟล์ผ่าน SMB/FTP แต่ความเร็วนั้นมักถูกจำกัดด้วยความเร็วของฮาร์ดดิสก์ (Disk I/O Bottleneck) ไม่ใช่ความเร็วจริงของสายสัญญาณ!

**iPerf3** ขจัดปัญหานี้โดยการ **สร้างข้อมูลทราฟฟิกสังเคราะห์ขึ้นบน RAM โดยตรง แล้วยิงอัดผ่านท่อเน็ตเวิร์ก** เพื่อวัดขีดความสามารถสูงสุดของสายเคเบิลหรือลิงก์ระหว่างสาขา:

### สถาปัตยกรรม Client-Server ของ iPerf3:
1. **เครื่องฝั่ง Server (ผู้รอรับการทดสอบ)**:
   ```bash
   # รันโหมด Server รอรับการเชื่อมต่อที่พอร์ตมาตรฐาน TCP 5201
   iperf3 -s
   ```
2. **เครื่องฝั่ง Client (ผู้เริ่มยิงทดสอบ)**:
   ```bash
   # 1. ทดสอบ TCP Throughput ปกติ นาน 10 วินาที
   iperf3 -c 10.20.1.50

   # 2. ทดสอบแบบเปิด 4 สตรีมพร้อมกัน (Parallel Streams) เพื่อเค้นท่อแบนด์วิดท์ให้เต็มพิกัด
   iperf3 -c 10.20.1.50 -P 4

   # 3. ทดสอบแบบสลับทิศทาง (Reverse Mode: ให้ Server ส่งข้อมูลกลับมาหา Client เพื่อวัดความเร็วดาวน์โหลด)
   iperf3 -c 10.20.1.50 -R

   # 4. ทดสอบโหมด UDP เพื่อวัดค่า Jitter (ความสั่นไหวของเวลา) และ Packet Loss (จำเป็นมากสำหรับระบบ Voice/VoIP)
   iperf3 -c 10.20.1.50 -u -b 100M
   ```

---

## 3. WinMTR: ตรวจสอบจุดคอขวดและจุด Packet Loss บนเส้นทาง

เมื่อมีอาการ *"อินเทอร์เน็ตหลุดบ่อย"* หรือ *"เล่นเกม/ใช้งานแอปพลิเคชันแล้วแล็กเป็นพักๆ"* คำสั่ง `ping` ปกติบอกได้แค่ว่าปลายทางตอบหรือไม่ แต่ไม่บอกว่าสายมีปัญหาที่ชุมสายตัวไหน

**WinMTR (หรือ MTR บน Linux)** นำคำสั่ง **`ping`** และ **`traceroute`** มารวมร่างกัน โดยการส่ง ICMP ต่อเนื่องไปยังทุกๆ Hop บนเส้นทางแบบเรียลไทม์:
- ดูคอลัมน์ **`Loss %`**: หากพบ Packet Loss สูงที่ Hop ใด และตัวเลข Loss นั้น **ลามต่อเนื่องไปยัง Hop ถัดไปจนถึงปลายทาง** ➔ แสดงว่า **เราเตอร์ที่ Hop นั้นคือจุดที่มีปัญหาจริง!**
- ดูคอลัมน์ **`Avg / Worst (ms)`**: ช่วยระบุได้ชัดเจนว่าความหน่วงพุ่งสูงขึ้นตั้งแต่การข้ามลิงก์ไหน
', 12, 'intermediate', 4, true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.lessons VALUES ('57df0d37-2e95-4e42-9185-f2ba49596293', 11, 'tools-terminal-remote-access', 'MobaXterm & Remote Admin Tools: รวมเครื่องมือ SSH, Serial Console, X11 และการโอนไฟล์ SFTP/SCP (Terminal Emulators & Remote Access)', 'เครื่องมือรีโมทประจำเครื่องช่าง: MobaXterm vs PuTTY vs SecureCRT, ฟีเจอร์ Multi-execution (พิมพ์คำสั่ง 10 เครื่องพร้อมกัน), การเชื่อมต่อ Serial Console (COM Port 9600 8N1), Embedded SFTP Browser, X11 Forwarding และ WinSCP', '# MobaXterm & Remote Admin Tools: รวมเครื่องมือ SSH, Serial Console, X11 และการโอนไฟล์ SFTP/SCP

งานของทีม Network Engineer, SysAdmin และ IT Support ในแต่ละวันกว่า 80% ไม่ได้นั่งอยู่หน้าเครื่องจริง แต่เป็นการ **เชื่อมต่อระยะไกล (Remote Access)** ไปยังอุปกรณ์สวิตช์ เราเตอร์ ไฟร์วอลล์ และลินุกซ์เซิร์ฟเวอร์นับร้อยเครื่อง การเลือกโปรแกรม Terminal Emulator ที่มีเครื่องมืออำนวยความสะดวกครบครันจะช่วยลดเวลาทำงานและป้องกันความผิดพลาดได้อย่างมหาศาล

---

## 1. เปรียบเทียบเครื่องมือ Terminal ยอดนิยม: PuTTY vs MobaXterm vs SecureCRT

![หน้าจอโปรแกรม MobaXterm แสดง Multi-Execution SSH Sessions, Embedded SFTP และ Serial Console](/images/tools/mobaxterm-remote-sessions.png)

| โปรแกรม | ข้อดีเด่น | ข้อจำกัด | ความเหมาะสมในการใช้งาน |
|---|---|---|---|
| **PuTTY** | • ขนาดไฟล์เล็กมาก (หลัก KB) พกใส่แฟลชไดรฟ์ได้ทันที<br>• กินแรมน้อย เสถียร ไม่เคยแฮงก์<br>• ฟรีและโอเพนซอร์ส | • หน้าตาเรียบง่าย ไม่มีแถบแท็บ (Tabbed)<br>• ไม่มีตัวจัดการไฟล์ SFTP ในตัว (ต้องลง WinSCP เพิ่ม)<br>• จัดการเซสชันจำนวนมากได้ยาก | เครื่องมือฉุกเฉินประจำกระเป๋าช่าง หรือใช้กับงานง่ายๆ เชื่อมต่อเครื่องเดียว |
| **MobaXterm (All-In-One)** | • **มี Embedded SFTP ในตัว**: ล็อกอิน SSH ปุ๊บ โฟลเดอร์ไฟล์จะเด้งขึ้นมาทางซ้าย ลากวางไฟล์ขึ้นลงได้ทันที!<br>• **Multi-Execution**: พิมพ์คำสั่งครั้งเดียว วิ่งออกไปรันบนทุกแท็บพร้อมกัน<br>• มี X11 Server ในตัว (รันโปรแกรมหน้าต่างกราฟิกจาก Linux ข้ามมาโชว์บน Windows ได้ทันที)<br>• รองรับครบทุกโปรโตคอล: SSH, Telnet, Serial, RDP, VNC, FTP | เวอร์ชันฟรีจำกัดจำนวน Session ที่เซฟได้ไม่เกิน 12 เซสชัน | **เครื่องมืออันดับ 1 สำหรับวิศวกรและสาย Support ที่ต้องดูแลเซิร์ฟเวอร์และเน็ตเวิร์กประจำวัน** |
| **SecureCRT** | • เสถียรและทรงพลังที่สุดในระดับ Enterprise<br>• รองรับระบบ Scripting (Python, VBScript) ขั้นสูงสำหรับงานอัตโนมัติ<br>• ปรับแต่งสีและคีย์ลัดได้ละเอียด | เป็นซอฟต์แวร์แบบมีค่าลิขสิทธิ์ (Commercial License) ราคาค่อนข้างสูง | องค์กรขนาดใหญ่ โทรคมนาคม (ISP) และทีม Network Automation ระดับสูง |

---

## 2. ฟีเจอร์ไม้ตายของ MobaXterm ที่คนทำงานต้องรู้

### 1) Multi-Execution Mode (พิมพ์ทีเดียว รันทุกเครื่อง)
- สมมุติว่าคุณต้องตรวจสอบสถานะ `uptime` หรืออัปเดตกฎไฟร์วอลล์บนเซิร์ฟเวอร์ 10 เครื่องพร้อมกัน
- เพียงแค่เปิดแท็บ SSH เชื่อมต่อเซิร์ฟเวอร์ทั้ง 10 ตัว แล้วกดปุ่ม **"MultiExec" (รูปหน้าจอซ้อนกันที่มุมขวาบน)**
- หน้าจอจะแบ่งเป็นตาราง และ **ทุกตัวอักษรที่คุณพิมพ์ จะถูกส่งไปประมวลผลบนเซิร์ฟเวอร์ทั้ง 10 เครื่องพร้อมกันในวินาทีเดียว!** ช่วยประหยัดเวลาได้นับสิบเท่า

### 2) Automatic Embedded SFTP Browser (ลากวางไฟล์โดยไม่ต้องจำคำสั่ง)
- เมื่อคุณล็อกอินเข้า Linux Server ด้วย SSH แถบด้านซ้ายของ MobaXterm จะเปิด **SFTP File Browser** ของเครื่องนั้นขึ้นมาทันที
- สามารถดับเบิลคลิกเปิดแก้ไขไฟล์คอนฟิก (เช่น `/etc/nginx/nginx.conf`) บน Text Editor ของ Windows และเมื่อกดเซฟ โปรแกรมจะอัปโหลดกลับไปแทนที่บนเซิร์ฟเวอร์อัตโนมัติ

### 3) X11 Forwarding (เปิดโปรแกรม GUI ของ Linux บน Windows)
- ปกติเซิร์ฟเวอร์ Linux ในห้อง Data Center จะติดตั้งแบบ Minimal ไร้หน้าจอ Graphic (Headless)
- แต่ถ้าคุณต้องติดตั้งฐานข้อมูลอย่าง **Oracle Database** หรือโปรแกรมที่ต้องใช้หน้าต่างติดตั้ง GUI (เช่น `xclock`, `virt-manager`, `wireshark`)
- MobaXterm มี **X11 Server ฝังตัวอยู่ในโปรแกรม** เมื่อคุณพิมพ์คำสั่งเปิดโปรแกรม GUI บน SSH หน้าต่างโปรแกรมนั้นจะเด้งขึ้นมาให้คลิกบนหน้าจอ Windows ของคุณได้ทันทีโดยไม่ต้องลง Desktop Environment บนเซิร์ฟเวอร์!

---

## 3. การเชื่อมต่อ Serial Console หน้าตู้แร็ค (COM Port & Baud Rate)

เมื่อสวิตช์หรือเราเตอร์ใหม่ยังไม่มี IP Address คุณต้องเสียบ **สาย Console (USB-to-RJ45)** เข้าคอมพิวเตอร์:

1. ตรวจสอบหมายเลขพอร์ตใน Windows:
   - กดปุ่ม `Win + X` ➔ เลือก **Device Manager ➔ Ports (COM & LPT)**
   - ดูว่าสาย USB Serial ของคุณได้รับพอร์ตหมายเลขใด เช่น **`COM3`** หรือ **`COM4`**
2. ตั้งค่าใน MobaXterm หรือ PuTTY:
   - เลือกประเภทการเชื่อมต่อเป็น **`Serial`**
   - **Serial port**: ใส่ชื่อพอร์ตให้ตรง เช่น **`COM3`**
   - **Speed (Baud rate)**: มาตรฐานสากลคือ **`9600`** (ยกเว้นอุปกรณ์บางรุ่นใหม่ที่อาจใช้ `115200`)
   - **Data bits: 8, Stop bits: 1, Parity: None, Flow Control: None (9600-8-N-1)**
3. กดปุ่ม Connect แล้วเคาะแป้น **Enter 1–2 ครั้ง** บนคีย์บอร์ดเพื่อปลุกหน้าต่าง Console ของอุปกรณ์!

---

## 4. WinSCP: เครื่องมือโอนย้ายไฟล์ความปลอดภัยสูง (SFTP / SCP Client)

หากต้องการโอนย้ายไฟล์ขนาดใหญ่ (เช่น อิมเมจระบบปฏิบัติการ ISO ขนาด 4–8 GB หรือไฟล์ Dump ฐานข้อมูล) ระหว่างเครื่อง Windows กับ Linux Server:
- **WinSCP** เป็นโปรแกรมโอนไฟล์ผ่านโปรโตคอล **SFTP (SSH File Transfer Protocol - Port 22)** ที่เสถียรที่สุด
- รองรับการ Resume ดาวน์โหลดต่อเมื่อเน็ตเวิร์กหลุด
- มีฟังก์ชัน **Keepuptodate (Directory Synchronization)** ที่คอยตรวจจับว่าหากไฟล์ในเครื่องคอมพิวเตอร์ของคุณมีการแก้ไข จะสั่งซิงก์อัปโหลดขึ้นเซิร์ฟเวอร์ให้โดยอัตโนมัติ
', 11, 'beginner', 5, true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.questions VALUES ('c1a10001-0000-0000-0000-000000000004', 'sql:joins:q01', 3, '5a3d9602-fb56-4f50-b4fa-c231d799a302', 'คำสั่ง SQL ใดใช้สำหรับค้นหาข้อมูลพนักงานทุกคน พร้อมชื่อแผนก โดยต้องการแสดงพนักงานแม้ว่าจะยังไม่ได้ถูกจัดให้อยู่แผนกใดก็ตาม (Department เป็น NULL)?', NULL, 'easy', 'multiple_choice', 'LEFT JOIN จะคงข้อมูลของตารางฝั่งซ้าย (employees) ไว้ทั้งหมด แม้จะไม่มีคู่ที่ตรงกันในตารางขวา (departments) ซึ่งคอลัมน์ของแผนกจะแสดงเป็นค่า NULL เหมาะสมกับโจทย์นี้', '{sql,join,database}', true, '2026-11-03 09:22:14.247234+00', '2026-11-03 09:22:14.247234+00');
INSERT INTO public.questions VALUES ('c1a10001-0000-0000-0000-000000000002', 'linux:services:q02', 1, 'b1a10001-0000-0000-0000-000000000002', 'คุณได้รับแจ้งว่า Service เว็บ Nginx บน Production เกิด Crash สตาร์ทไม่ขึ้น และเมื่อรัน systemctl start nginx พบข้อความ "Job for nginx.service failed". ในฐานะ Support ขั้นตอนแรกที่ดีที่สุดในการตรวจสอบสาเหตุคืออะไร?', '# systemctl start nginx
Job for nginx.service failed because the control process exited with error code.
See "systemctl status nginx.service" and "journalctl -xeu nginx.service" for details.', 'medium', 'scenario', 'เมื่อ Nginx สตาร์ทไม่ติด สาเหตุอันดับ 1 มักเกิดจาก Syntax ผิดพลาดในไฟล์ nginx.conf หรือพอร์ต 80/443 ชนกับโปรเซสอื่น การรัน `nginx -t` จะตรวจสอบความถูกต้องของ Configuration ทันที หรือใช้ `journalctl -xeu nginx.service` เพื่อดู Error ล่าสุด', '{nginx,systemctl,journalctl,troubleshooting}', true, '2026-11-03 09:22:14.247234+00', '2026-11-03 09:22:14.247234+00');
INSERT INTO public.questions VALUES ('c1a10001-0000-0000-0000-000000000006', 'linux:disk:q03', 1, 'b1a10001-0000-0000-0000-000000000005', 'เกิดปัญหา Disk /var เต็ม 100% คุณได้สั่งลบไฟล์ log ขนาด 50GB ด้วยคำสั่ง `rm /var/log/app.log` ไปแล้ว แต่เมื่อเช็คคำสั่ง `df -h` ปรากฏว่าพื้นที่ยังคงเต็ม 100% เหมือนเดิม สาเหตุเกิดจากอะไรและแก้ปัญหาอย่างไร?', '# df -h /var
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda3       100G  100G     0 100% /var', 'hard', 'scenario', 'เมื่อรัน `rm` บน Linux ตัว Pointer ใน Directory จะถูกลบออก แต่หากยังมี Process (เช่น Java/Node.js) เปิดเขียนไฟล์นั้นค้างอยู่ (File descriptor open) พื้นที่จริงใน Disk จะยังไม่ถูกคืน (Held open) วิธีตรวจสอบคือใช้ `lsof +L1` หรือ `lsof | grep deleted` และทำการ reload/restart process นั้น หรือแทนที่จะใช้ `rm` ให้ใช้คำสั่งเคลียร์เนื้อหาไฟล์แทน เช่น `> /var/log/app.log` (truncate)', '{linux,disk,lsof,storage}', true, '2026-11-03 09:22:14.247234+00', '2026-11-03 09:22:14.247234+00');
INSERT INTO public.questions VALUES ('c1a10001-0000-0000-0000-000000000007', 'network:http:q02', 2, NULL, 'ผู้ใช้แจ้งว่าเข้าเว็บแล้วพบหน้าขาวพร้อมข้อความ "HTTP 504 Gateway Timeout" จากมุมมองของ Reverse Proxy (เช่น Nginx หรือ Cloudflare) ปัญหานี้เกิดขึ้นจากอะไร?', '# curl -I https://api.mycompany.com/checkout
HTTP/1.1 504 Gateway Timeout
Server: nginx/1.24.0', 'medium', 'multiple_choice', 'HTTP 504 Gateway Timeout หมายถึง ตัว Reverse Proxy สามารถเชื่อมต่อไปยัง Upstream / Backend Server ได้ แต่ Upstream ทำงานช้าเกินไปจนเกินเวลา timeout (เช่น `proxy_read_timeout`) ยังไม่ยอมส่ง Response กลับมา (ต่างจาก 502 Bad Gateway ที่ Upstream ตัดการเชื่อมต่อทันที หรือล่มไปแล้ว)', '{http,nginx,status-codes,proxy}', true, '2026-11-03 09:22:14.247234+00', '2026-11-03 09:22:14.247234+00');
INSERT INTO public.questions VALUES ('c1a10001-0000-0000-0000-000000000003', 'network:tools:q01', 2, '3ff8610b-94c3-43a7-8e1f-436f27946647', 'เมื่อใช้คำสั่ง `curl -v http://192.168.1.50:8080` แล้วได้รับผลลัพธ์ว่า `curl: (7) Failed to connect to 192.168.1.50 port 8080: Connection refused` ข้อใดคือสาเหตุที่เป็นไปได้มากที่สุด?', NULL, 'medium', 'multiple_choice', 'Connection Refused หมายความว่า แพ็กเก็ต TCP SYN เดินทางไปถึงโฮสต์ปลายทางเรียบร้อยแล้ว แต่โฮสต์ปลายทางตอบกลับด้วย TCP RST (Reset) ซึ่งแปลว่า "ไม่มี Process/Application ใดเปิดฟัง (Listening) อยู่ที่พอร์ต 8080" หรือถูกปฏิเสธโดย Local Firewall แบบ reject (ต่างจาก Timeout ที่แพ็กเก็ตโดนดรอปเงียบๆ)', '{network,tcp,curl,ports}', true, '2026-11-03 09:22:14.247234+00', '2026-11-03 09:22:14.247234+00');
INSERT INTO public.questions VALUES ('c1a10001-0000-0000-0000-000000000005', 'sql:explain:q02', 3, '0ec2fdf6-2627-408b-9791-35963b5fe97e', 'ใน PostgreSQL เมื่อพบว่า Query `SELECT * FROM orders WHERE customer_id = 45000 AND status = ''PENDING''` ทำงานช้ามากบนตารางที่มี 10,000,000 แถว คำสั่งใดที่ช่วยแสดง Execution Plan เพื่อดูว่า Query ใช้วิธี Sequential Scan หรือ Index Scan?', NULL, 'hard', 'multiple_choice', '`EXPLAIN ANALYZE` เป็นคำสั่งสำคัญของ PostgreSQL ที่จะรัน Query จริงและรายงาน Query Planner Plan พร้อมเวลาที่ใช้จริงในแต่ละ Node (Cost, Actual Time, Rows, Index Scan vs Seq Scan)', '{sql,postgresql,performance,explain}', true, '2026-11-03 09:22:14.247234+00', '2026-11-03 09:22:14.247234+00');
INSERT INTO public.questions VALUES ('c1a10001-0000-0000-0000-000000000001', 'linux:permissions:q01', 1, 'b1a10001-0000-0000-0000-000000000001', 'หากต้องการกำหนดสิทธิ์ไฟล์ `deploy.sh` ให้ ''เจ้าของสามารถ อ่าน-เขียน-รันได้'' ส่วน ''กลุ่มและผู้อื่น อ่านและรันได้เท่านั้น'' ต้องใช้คำสั่ง chmod ตัวเลขใด?', NULL, 'easy', 'multiple_choice', 'คำนวณสิทธิ์ตามเลข Octal:
- Owner (rwx) = 4 + 2 + 1 = 7
- Group (r-x) = 4 + 0 + 1 = 5
- Others (r-x) = 4 + 0 + 1 = 5
ดังนั้นคำตอบคือ chmod 755 deploy.sh', '{chmod,linux,permissions}', true, '2026-11-03 09:22:14.247234+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('1b0c7347-ec8c-4c56-abd9-96fe64f7019e', 'web-api:01-http-status-codes:q03', 4, '8cd3f8e6-7571-47ca-bd5b-cd313f6179c6', 'ผู้ใช้งานกดปุ่ม Export Report ข้อมูลประจำปี แล้วหน้าเว็บหมุนค้างอยู่ 60 วินาที จากนั้นขึ้นข้อความ ''504 Gateway Timeout'' จุดแรกที่ทีม Support ควรเข้าไปตรวจสอบคืออะไร?', 'ลูกค้าแจ้งว่าฟังก์ชัน Export รายงานยอดขายขนาดใหญ่ใช้งานไม่ได้ ขึ้น 504 หลังจากรอนานประมาณ 1 นาที', 'medium', 'multiple_choice', '504 Gateway Timeout หมายถึง Reverse Proxy เชื่อมต่อ Backend ได้แต่ Backend ทำงานค้างจนเกิน proxy_read_timeout สาเหตุอันดับหนึ่งของการ Export ข้อมูลช้าคือ Slow Query หรือ Database Lock ในฐานข้อมูล', '{web,http,504,database,timeout}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('4fe283f1-19c2-4303-a2fa-0b62358c2440', 'web-api:02-curl-api-testing:q01', 4, 'cfa14627-c168-4b14-9e7b-15eb4f7e1ead', 'คำสั่ง curl ใดใช้สำหรับดูเฉพาะ HTTP Response Headers โดยไม่ต้องดาวน์โหลด Body?', 'คุณต้องการตรวจสอบค่า Cache-Control และ Server Header ของเว็บอย่างรวดเร็วผ่าน Terminal', 'easy', 'multiple_choice', 'แฟล็ก -I (ตัวไอใหญ่) จะส่งคำขอแบบ HEAD method ซึ่งเซิร์ฟเวอร์จะตอบกลับเฉพาะส่วน Headers โดยไม่มี Content Body', '{web,curl,http-headers}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('f92cd87a-0d5e-49eb-a61a-7764f41baf12', 'web-api:02-curl-api-testing:q02', 4, 'cfa14627-c168-4b14-9e7b-15eb4f7e1ead', 'หากต้องการทดสอบยิง Request ไปยัง IP ของเซิร์ฟเวอร์หลังบ้าน 10.0.1.25 โดยตรง แต่ยังต้องการให้ Web Server ทราบว่าเรียกโดเมน api.company.com ควรทำอย่างไร?', 'ระบบหน้าบ้านมี CDN/Cloudflare ขวางอยู่ และคุณต้องการบายพาสเพื่อทดสอบว่าปัญหาน้ำท่วมทราฟฟิกเกิดที่ CDN หรือเซิร์ฟเวอร์จริง', 'medium', 'multiple_choice', 'การระบุ Host Header ด้วย -H ''Host: api.company.com'' หรือใช้ตัวเลือก --resolve จะส่งคำขอตรงไปยัง IP ปลายทางโดยที่ Web Server (เช่น Nginx) สามารถเลือก Virtual Host ได้ถูกต้อง', '{web,curl,headers,virtualhost}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('35845f5e-4dcb-431d-8543-90b3ad2d0b52', 'web-api:03-ssl-tls-certificates:q01', 4, 'c1527b50-8bf1-4171-95ce-52bd25ee35f4', 'คำสั่ง openssl ใดต่อไปนี้ใช้สำหรับตรวจสอบวันหมดอายุของใบรับรอง SSL บนเซิร์ฟเวอร์ปลายทางผ่านพอร์ต 443 ได้อย่างแม่นยำ?', 'คุณได้รับแจ้งเตือนจากระบบ Monitoring ว่ามีแนวโน้มที่ใบรับรองของเว็บจะหมดอายุ และต้องการยืนยันวันหมดอายุจริง', 'medium', 'multiple_choice', 'openssl s_client -connect domain:443 ร่วมกับการไพพ์ไปยัง openssl x509 -noout -enddate เป็นวิธีมาตรฐานในการดึงวันหมดอายุโดยตรงจากพอร์ต HTTPS ของเซิร์ฟเวอร์', '{web,ssl,tls,openssl}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('fed5a2b0-f7b7-4585-869c-d21e36063fab', 'dc:fiber:q01', 10, 'd610df66-7525-44ca-9e83-02b4749afe01', 'สายไฟเบอร์ออปติกสีเหลือง (OS2) และสีฟ้าอมเขียว Aqua (OM3/OM4) แตกต่างกันอย่างไร และควรจับคู่กับหัว Transceiver รหัสใด?', NULL, 'easy', 'multiple_choice', 'สายสีเหลืองคือ Single-mode (OS2, แกน 9µm) สำหรับระยะไกล ใช้คู่กับหัวรหัส LR (1310nm) ส่วนสายสีฟ้า Aqua คือ Multi-mode (OM3/OM4, แกน 50µm) สำหรับระยะใกล้ในห้อง Data Hall ใช้คู่กับหัวรหัส SR (850nm)', '{fiber,smf,mmf,transceiver,datacenter}', true, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('cf23fcf6-0d35-4d10-9843-e5cd963707d1', 'dc:fiber:q02', 10, 'd610df66-7525-44ca-9e83-02b4749afe01', 'เมื่อคุณเดินสายไฟเบอร์ Duplex LC เชื่อมต่อระหว่าง Switch A กับ Switch B ผ่าน Patch Panel เสร็จแล้ว พบว่าไฟสถานะพอร์ตไม่ติด (Link Down) ทั้งที่เช็กแล้วว่าหัว SFP+ ทั้งสองฝั่งปกติ สาเหตุที่พบบ่อยที่สุดและวิธีแก้ไขเบื้องต้นคืออะไร?', 'Switch-A (TenGigabitEthernet1/0/1) <---> Patch Panel <---> Switch-B (TenGigabitEthernet1/0/1)
Status: notconnect (Link Down), Transceiver Tx Power: -2.1 dBm, Rx Power: -40.0 dBm (LOS)', 'medium', 'scenario', 'เมื่อค่า Tx Power ปกติแต่ Rx Power เป็น -40 dBm (Loss of Signal) หลังเดินสายผ่าน Patch Panel มักเกิดจากขั้วสายไฟเบอร์ไม่ได้ไขว้กัน (Tx วิ่งไปชน Tx และ Rx ชน Rx) วิธีแก้คือการทำ Rolling Fiber (สลับขั้วหัวสาย LC คู่ซ้าย-ขวาที่ปลายด้านใดด้านหนึ่ง) เพื่อให้ Tx ของฝั่งหนึ่งตรงกับ Rx ของอีกฝั่ง', '{fiber,rolling-fiber,tx-rx,troubleshooting}', true, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('60d9f418-713b-4218-bba9-7763e3ec1077', 'dc:cabling:q03', 10, 'd610df66-7525-44ca-9e83-02b4749afe01', 'หัว Transceiver ชนิดใดที่รองรับความเร็ว 10 Gbps และชนิดใดรองรับ 100 Gbps ตามลำดับ?', NULL, 'easy', 'multiple_choice', 'SFP = 1G, SFP+ = 10G, SFP28 = 25G, QSFP+ = 40G และ QSFP28 = 100G (4 ช่องสัญญาณ x 25G)', '{sfp,qsfp,transceiver,datacenter}', true, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('31507ab1-5704-4dca-adbb-845cb298008c', 'dc:cabling:q04', 10, 'd610df66-7525-44ca-9e83-02b4749afe01', 'ในการเข้าหัวสายแลนทองแดง RJ45 ตามมาตรฐาน T568B ลำดับสีสายตั้งแต่พิน 1 ถึงพิน 8 ข้อใดถูกต้อง?', NULL, 'medium', 'multiple_choice', 'มาตรฐาน T568B เรียงลำดับจากพิน 1 ถึง 8 คือ: (1) ขาวส้ม (2) ส้ม (3) ขาวเขียว (4) น้ำเงิน (5) ขาวน้ำเงิน (6) เขียว (7) ขาวน้ำตาล (8) น้ำตาล', '{t568b,rj45,cabling,utp}', true, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('9d9f0119-30e0-4f74-a490-6f63150858f8', 'dc:hardware:q05', 10, 'a64393d6-d903-4f53-958f-99df97e3d586', 'อุปกรณ์ใดในเครื่อง Rack Server ขนาด 1U/2U ที่ทำหน้าที่แปลงสล็อต PCIe บนเมนบอร์ดให้สามารถเสียบการ์ด HBA หรือการ์ด NIC ในแนวนอนขนานกับตัวเครื่องได้?', NULL, 'easy', 'multiple_choice', 'Riser Card เป็นแผงวงจรรูปตัว L ที่เสียบลงบนเมนบอร์ดเพื่อหันสล็อต PCIe ให้อยู่ในแนวนอน ทำให้สามารถติดตั้งการ์ด PCIe ในตัวถังเซิร์ฟเวอร์ที่มีความสูงจำกัด (1U/2U) ได้', '{hardware,riser-card,pcie,server}', true, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('9600ac8c-a971-4c6f-96be-42e68bba2936', 'dc:hardware:q06', 10, 'a64393d6-d903-4f53-958f-99df97e3d586', 'ในการนำอุปกรณ์เข้าติดตั้งในตู้แร็คขนาด 42U (Racking & Stacking) ข้อใดคือแนวปฏิบัติที่ถูกต้องที่สุดเพื่อความปลอดภัยและเสถียรภาพ?', NULL, 'easy', 'multiple_choice', 'การติดตั้งอุปกรณ์ที่มีน้ำหนักมากที่สุด (เช่น UPS หรือตู้ Storage Array) ไว้ที่ด้านล่างสุดของตู้แร็คจะช่วยรักษาจุดศูนย์ถ่วงให้อยู่ต่ำ ป้องกันไม่ให้ตู้แร็คกระดกหรือล้มคว่ำเมื่อดึงรางสไลด์เซิร์ฟเวอร์ออกมา', '{racking,rack-unit,safety,datacenter}', true, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('8cca4bdc-4664-4c04-8b68-ba8cd1c3c87e', 'dc:oob:q07', 10, 'a64393d6-d903-4f53-958f-99df97e3d586', 'เซิร์ฟเวอร์ Dell PowerEdge เครื่องหนึ่งใน Data Center เกิดอาการค้างสนิทจน SSH เข้าไม่ได้ และมีไฟแจ้งเตือนสีส้มกระพริบหน้าเครื่อง วิศวกรควรใช้ระบบใดในการตรวจเช็ก System Event Log (SEL) และเปิดดูหน้าจอ Console จากระยะไกล?', NULL, 'easy', 'multiple_choice', 'สำหรับเซิร์ฟเวอร์ Dell ระบบ Out-of-Band Management ประจำเครื่องคือ iDRAC (ส่วน HPE คือ iLO) ซึ่งทำงานแยกอิสระจาก OS ช่วยให้อ่านฮาร์ดแวร์ Log (SEL), เปิดหน้าจอ Virtual KVM และสั่ง Power Cycle ได้แม้ OS จะค้างไปแล้ว', '{idrac,ilo,ipmi,oob}', true, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('322d8847-058b-4e2b-aaf5-b73a6f99c8db', 'dc:pxe:q08', 10, 'a8d18af7-6692-4b1b-86b5-88a0d4fb8f9b', 'ในกระบวนการบูตเครื่องผ่านเครือข่าย (PXE Boot) เพื่อติดตั้งระบบปฏิบัติการอัตโนมัติ โปรโตคอลคู่ใดที่ทำงานร่วมกันเพื่อแจกเลข IP และส่งไฟล์บูตอิมเมจเริ่มต้นให้กับการ์ดแลนของเซิร์ฟเวอร์?', NULL, 'medium', 'multiple_choice', 'PXE Boot อาศัย DHCP (ในการแจก IP พร้อมระบุ Next-Server Option 66 และ Boot Filename Option 67) และ TFTP (UDP พอร์ต 69) ในการดาวน์โหลดไฟล์ Bootloader และ Kernel ลงมาบูตในหน่วยความจำ', '{pxe,dhcp,tftp,boot}', true, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('7dc94aeb-fbb7-495c-b1a6-e0e7a616e571', 'dc:san:q09', 10, 'a8d18af7-6692-4b1b-86b5-88a0d4fb8f9b', 'ในระบบเครือข่ายพื้นที่จัดเก็บข้อมูล Fibre Channel SAN การทำ ''Zoning'' บน SAN Switch ใช้หมายเลขประจำพอร์ตชนิดใดในการกำหนดสิทธิ์ให้ HBA ของเซิร์ฟเวอร์มองเห็นพอร์ตของตู้ Storage?', NULL, 'medium', 'multiple_choice', 'ในโลกของ Fibre Channel SAN จะใช้หมายเลข WWPN (World Wide Port Name) ขนาด 64-bit ของการ์ด HBA (Initiator) และพอร์ต Storage (Target) ในการตั้งค่า सॉफ्टแวร์ Zoning บน SAN Switch', '{san,zoning,wwpn,hba,storage}', true, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('a917b677-c0d8-4beb-9d74-003d1ecba5d7', 'dc:power:q10', 10, '92409c70-8fd7-4575-b8c5-22e661376a62', 'หน้าที่ของ UPS (Uninterruptible Power Supply) และ ATS (Automatic Transfer Switch) ในศูนย์ข้อมูล Data Center แตกต่างกันอย่างไร?', NULL, 'medium', 'multiple_choice', 'UPS ใช้แบตเตอรี่จ่ายไฟสำรองทันทีแบบไร้รอยต่อเมื่อไฟตก/ไฟดับและกรองไฟให้นิ่งในช่วงสั้นๆ (5-15 นาที) ส่วน ATS ทำหน้าที่เป็นสวิตช์สลับแหล่งจ่ายไฟอัตโนมัติจากไฟการไฟฟ้า (Utility Grid) ไปยังเครื่องปั่นไฟสำรอง (Generator) เมื่อเครื่องปั่นไฟสตาร์ทติดและกระแสไฟนิ่งแล้ว', '{ups,ats,power,generator,datacenter}', true, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('7196c4c2-9d55-4195-b076-2fd1f73327e3', 'dc:power:q11', 10, '92409c70-8fd7-4575-b8c5-22e661376a62', 'หากต้องเปิดระบบทั้งหมดในตู้แร็คขึ้นมาใหม่หลังจากปิดบำรุงรักษาระบบไฟฟ้า (Rack Power-Up Sequence) ลำดับการเปิดอุปกรณ์ในข้อใดถูกต้องที่สุด?', NULL, 'medium', 'multiple_choice', 'เวลาเปิดระบบกลับขึ้นมา ต้องเปิด Network/SAN Switch ก่อน → ตามด้วยตู้ Storage (รอให้ดิสก์และ LUN พร้อมใช้งาน) → แล้วจึงทยอยเปิดเครื่อง Compute Server ทีละกลุ่ม เพื่อให้เซิร์ฟเวอร์บูตขึ้นมาเจอก้อน Storage และเครือข่ายได้ทันที และลดไฟกระชาก (Inrush current)', '{power-sequence,rack,storage,datacenter}', true, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('933dfdc8-419d-4b12-9ccc-1a634e095c13', 'dc:cooling:q12', 10, '92409c70-8fd7-4575-b8c5-22e661376a62', 'การจัดเรียงตู้แร็คแบบ Hot Aisle / Cold Aisle ในห้อง Data Center มีหลักการอย่างไร และทำไมจึงต้องติดแผ่น Blanking Panel ในช่อง U ที่ว่าง?', NULL, 'easy', 'multiple_choice', 'การจัดแบบ Hot/Cold Aisle คือการหันด้านหน้าตู้แร็คเข้าหากันในช่องลมเย็น (Cold Aisle) เพื่อดูดแอร์เข้าหน้าเครื่อง และหันด้านหลังตู้ชนกันในช่องลมร้อน (Hot Aisle) ส่วนการติดแผ่น Blanking Panel ปิดช่อง U ที่ว่างช่วยป้องกันไม่ให้ลมร้อนจากหลังตู้ไหลวนย้อนกลับมาเข้าหน้าเครื่อง', '{cooling,hot-aisle,cold-aisle,blanking-panel}', true, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('6f372fdb-946b-43aa-a8a4-868bc32651ea', 'dc:fire:q13', 10, '92409c70-8fd7-4575-b8c5-22e661376a62', 'ระบบดับเพลิงในห้องเซิร์ฟเวอร์ของ Data Center มาตรฐานนิยมใช้สารชนิดใดในการดับไฟเพื่อไม่ให้ทำลายแผงวงจรอิเล็กทรอนิกส์?', NULL, 'easy', 'multiple_choice', 'ห้อง Data Hall จะใช้สารสะอาดดับเพลิงชนิดแก๊ส (Clean Agent Fire Suppression) เช่น FM-200 (HFC-227ea), Novec 1230 หรือแก๊สเฉื่อย Inergen ซึ่งไม่นำไฟฟ้าและไม่ทิ้งคราบสกปรกไว้บนเซิร์ฟเวอร์', '{fire-suppression,fm200,novec1230,safety}', true, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('583a1f9b-0196-4bd5-b6ca-18b2fd163774', 'dc:interview:q14', 10, 'e2bdf887-4d4b-4710-b6c1-8dd61f020fdc', '[คำถามสัมภาษณ์สถานการณ์จริง] หากคุณกำลังเดินตรวจในห้อง Data Hall แล้วเห็นประกายไฟช็อตสั้นๆ ที่ลูก Power Supply (PSU 1) ของเซิร์ฟเวอร์เครื่องหนึ่ง (ซึ่งมี Redundant PSU 2 ลูก) คุณควรตัดสินใจทำอย่างไร?', NULL, 'medium', 'scenario', 'ผู้จัดการกังวลเรื่องความตื่นตระหนกจนไปสับเบรกเกอร์หลักของทั้งตู้แร็ค (ซึ่งจะทำให้เซิร์ฟเวอร์อีก 30 เครื่องในตู้ดับทั้งหมด) วิธีที่ถูกต้องคือตั้งสติ ประเมินว่ามีไฟลุกไหม้หรือไม่ ตรวจสอบว่า PSU ลูกที่ 2 ยังจ่ายไฟเลี้ยงเครื่องอยู่ ถอดเฉพาะสายไฟเส้นที่เข้า PSU ลูกที่มีปัญหาออกอย่างปลอดภัย และรีบแจ้งหัวหน้าทีม/NOC เพื่อเปลี่ยนอะไหล่ตามขั้นตอน', '{interview,mindset,psu,safety,incident}', true, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('30e66b8d-6030-4b13-8c81-97a7a8358886', 'dc:interview:q15', 10, 'e2bdf887-4d4b-4710-b6c1-8dd61f020fdc', '[คำถามสัมภาษณ์ทัศนคติ] หากผู้สัมภาษณ์ถามว่า ''คุณเชื่อมสายไฟเบอร์ด้วยเครื่อง Fusion Splicer เป็นหรือไม่?'' แต่คุณยังไม่เคยทำมาก่อน คำตอบใดเหมาะสมและสร้างความประทับใจมากที่สุด?', NULL, 'easy', 'multiple_choice', 'ความซื่อสัตย์ (Integrity) เป็นสิ่งสำคัญมากในการทำงาน Data Center หากทำไม่เป็นต้องตอบตามตรงว่ายังไม่เคยทำจริง แต่อธิบายความรู้พื้นฐานที่เกี่ยวข้อง (เช่น ชนิดสายไฟเบอร์ การทำความสะอาดหัวสาย) และแสดงความพร้อมที่จะเรียนรู้เพิ่มเติมอย่างรวดเร็ว', '{interview,honesty,mindset,fiber}', true, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('5e788bf5-347f-4201-9344-7e3f4c9e180f', 'docker:02-troubleshooting-exit-codes:q01', 5, '13d2405e-0e29-4bf2-9f78-03f4f29d3aef', 'Container ตัวหนึ่งดับลงโดยแสดงสถานะ ''Exited (137)'' และเมื่อ inspect ดูพบว่า OOMKilled เป็น true ข้อใดคือสาเหตุที่แท้จริง?', 'บริการประมวลผลไฟล์ภาพขนาดใหญ่ดับลงกะทันหันในขณะที่มีผู้ใช้งานอัปโหลดไฟล์เข้ามาพร้อมกันเป็นจำนวนมาก', 'medium', 'multiple_choice', 'Exit Code 137 เท่ากับ 128 + 9 (SIGKILL) ซึ่งเกิดขึ้นเมื่อคอนเทนเนอร์ใช้งานหน่วยความจำ RAM เกินกว่าขีดจำกัด (Memory Limit) ที่กำหนดไว้ ทำให้ถูก Linux Kernel OOM (Out Of Memory) Killer ส่งสัญญาณสั่งฆ่าทันที', '{docker,exit-codes,oomkilled,memory}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('5d2f59f3-3800-4751-84af-43e8f7a2c8f4', 'docker:02-troubleshooting-exit-codes:q02', 5, '13d2405e-0e29-4bf2-9f78-03f4f29d3aef', 'Exit Code ใดใน Docker ที่บ่งบอกว่า Container ได้รับคำสั่งสั่งปิดการทำงานอย่างสุภาพ (Graceful Shutdown ด้วย SIGTERM)?', 'คำถามสัมภาษณ์งานตำแหน่ง DevOps / Support Engineer', 'easy', 'multiple_choice', 'Exit Code 143 คำนวณมาจาก 128 + 15 (SIGTERM) ซึ่งเป็นสัญญาณที่ส่งเมื่อมีการสั่ง docker stop หรือระบบ Orchestrator สั่งยุติเพื่อทำการ Deploy เวอร์ชันใหม่', '{docker,exit-codes,sigterm}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('6164b7cc-ad3b-4035-8811-281134f2b57d', 'network:01-ip-subnetting:q01', 2, 'd8929572-6865-40b4-bf65-a32bfcdb15a5', 'Subnet ขนาด /28 มีจำนวน IP Address ที่สามารถนำไปกำหนดให้กับ Host ใช้งานได้จริงกี่ IP?', 'ทีม Network แจ้งว่าได้จัดสรรวง Subnet 192.168.10.64/28 ให้กับเซิร์ฟเวอร์ชุดใหม่ใน DMZ', 'medium', 'multiple_choice', '/28 มีบิตเหลือสำหรับ Host คือ 32 - 28 = 4 บิต จำนวน IP ทั้งหมดคือ 2^4 = 16 IP แต่ต้องหัก Network ID (ตัวแรก) และ Broadcast ID (ตัวสุดท้าย) ออก 2 ค่าเสมอ จึงเหลือ Host ใช้งานได้จริง 14 IP', '{network,subnetting,cidr}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('424f36a8-1a09-4c7c-8511-fe7c60417e2e', 'linux:02-basics:q04', 1, '2f157328-48ee-496e-bcef-7afd1b6a8d1f', 'เมื่อต้องตรวจสอบไฟล์ `application.log` ที่มีขนาดใหญ่ถึง 2.5 GB บนเซิร์ฟเวอร์ Production เหตุใดจึงไม่ควรใช้คำสั่ง `cat application.log`?', NULL, 'medium', 'multiple_choice', '`cat` จะอ่านและพิมพ์เนื้อหาทั้งไฟล์ออกทางหน้าจอรวดเดียว สำหรับไฟล์ขนาดหลาย GB จะทำให้หน้าจอค้าง สิ้นเปลือง I/O และแบนด์วิดท์ของเซสชัน SSH ควรใช้ `less` (อ่านทีละหน้า) หรือ `tail` (ดูเฉพาะท้ายไฟล์) แทน', '{cat,less,tail,logs}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('ff930bba-7a53-42c5-acae-936a295c3727', 'linux:02-basics:q05', 1, '2f157328-48ee-496e-bcef-7afd1b6a8d1f', 'จากเหตุการณ์ในหน้าจอ Terminal ด้านล่าง หากผู้ใช้งานกด Enter เพื่อรันคำสั่งดังกล่าว จะเกิดผลกระทบอย่างไร?', 'root@app-prod-01:/var/www/html# pwd
/var/www/html
root@app-prod-01:/var/www/html# rm -rf / tmp/cache/*', 'hard', 'scenario', 'สังเกตช่องว่างระหว่าง `/` กับ `tmp/cache/*` คำสั่ง `rm -rf / tmp/cache/*` จะถูก Shell ตีความว่าให้ลบ 2 เป้าหมาย คือ `/` (รากของระบบทั้งหมด) และ `tmp/cache/*` ซึ่งอันตรายร้ายแรงมากในสิทธิ์ root (แม้ว่าระบบสมัยใหม่จะมี `--preserve-root` ป้องกันระดับหนึ่ง แต่หากเผลอพิมพ์เว้นวรรคผิดกับพาธสำคัญอื่น เช่น `/var/www/ html` ก็จะลบทั้ง `/var/www/` ทันที)', '{rm,wildcard,safety,troubleshooting}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('a41d9eb7-8d8e-4280-992f-cc029c329c9a', 'linux:02-basics:q06', 1, '2f157328-48ee-496e-bcef-7afd1b6a8d1f', 'ขณะยืนอยู่ที่โฟลเดอร์ `/var/log/nginx` หากต้องการเปลี่ยนโฟลเดอร์ไปยัง `/var/log` โดยใช้เส้นทางแบบ Relative Path ควรพิมพ์คำสั่งใด?', NULL, 'easy', 'multiple_choice', 'สัญลักษณ์ `..` หมายถึงโฟลเดอร์แม่ (Parent Directory) ที่อยู่สูงขึ้นไป 1 ระดับ ดังนั้นเมื่อยืนอยู่ที่ `/var/log/nginx` การรัน `cd ..` จะพาไปยัง `/var/log`', '{cd,path,navigation}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('d7c21650-b866-4270-89b0-b1694c2881dd', 'linux:02-basics:q07', 1, '2f157328-48ee-496e-bcef-7afd1b6a8d1f', 'หากต้องการสำรองไฟล์คอนฟิก `app.conf` เป็น `app.conf.bak` โดยยังคงรักษาค่าเวลาแก้ไขเดิม (Timestamp) และสิทธิ์เจ้าของไฟล์เดิมไว้ทั้งหมด เพื่อใช้เปรียบเทียบภายหลัง ควรใช้คำสั่งใด?', NULL, 'medium', 'multiple_choice', 'คำสั่ง `cp -p` (`--preserve=mode,ownership,timestamps`) จะคัดลอกไฟล์พร้อมเก็บรักษาสิทธิ์ เจ้าของ และเวลาแก้ไขเดิมของไฟล์ต้นฉบับไว้ ซึ่งมีประโยชน์มากในงาน Support เมื่อต้องเก็บหลักฐานเวลาแก้ไขไฟล์', '{cp,backup,basics}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('c76d1ecb-de00-4fe1-b3cd-fb37fb4de9f3', 'linux:03-file-system:q01', 1, 'adeaa019-95a7-4877-8d5a-94c875441152', 'ตามมาตรฐานโครงสร้างไดเรกทอรีของ Linux (FHS) ไฟล์ตั้งค่าระบบ (System Configuration) และไฟล์บันทึกเหตุการณ์ (System Logs) จะถูกจัดเก็บไว้ที่ไดเรกทอรีใดตามลำดับ?', NULL, 'easy', 'multiple_choice', 'ตามมาตรฐาน FHS ไดเรกทอรี `/etc` ใช้เก็บไฟล์ตั้งค่าระบบและบริการต่างๆ ส่วน `/var/log` ใช้เก็บไฟล์บันทึกเหตุการณ์ (Logs) ที่มีขนาดเปลี่ยนแปลงตลอดเวลา', '{filesystem,fhs,directories}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('31f353c9-c627-49e9-a19b-a79eb9cfc624', 'linux:03-file-system:q02', 1, 'adeaa019-95a7-4877-8d5a-94c875441152', 'เมื่อได้รับแจ้งเตือนว่าพาร์ทิชัน `/var` กำลังจะเต็ม หากต้องการค้นหาเฉพาะไฟล์ธรรมดา (`-type f`) ใน `/var` ที่มีขนาดใหญ่กว่า 200 MB ต้องใช้คำสั่งใด?', NULL, 'easy', 'multiple_choice', 'คำสั่ง `find /var -type f -size +200M` ใช้ค้นหาเฉพาะไฟล์ปกติ (`-type f`) ภายใน `/var` ที่มีขนาดมากกว่า (`+`) 200 เมกะไบต์ (`M`)', '{find,disk,filesystem}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('1ac01c44-5005-4ecb-88fc-c771eb4dae59', 'linux:03-file-system:q03', 1, 'adeaa019-95a7-4877-8d5a-94c875441152', 'จากผลลัพธ์การตรวจสอบด้านล่าง สาเหตุที่แอปพลิเคชันไม่สามารถอ่านไฟล์คอนฟิกผ่าน `/opt/payment/current/config.yml` ได้คืออะไร?', '$ ls -l /opt/payment/current
lrwxrwxrwx 1 deploy deploy 31 Nov  2 22:00 /opt/payment/current -> /opt/payment/releases/20261015

$ file /opt/payment/current
/opt/payment/current: broken symbolic link to /opt/payment/releases/20261015

$ ls -l /opt/payment/releases/
total 8
drwxr-xr-x 4 deploy deploy 4096 Nov  1 09:00 20261101
drwxr-xr-x 4 deploy deploy 4096 Nov  3 08:30 20261103', 'medium', 'scenario', 'จากผลของ `file /opt/payment/current` แจ้งชัดเจนว่าเป็น `broken symbolic link` เพราะชี้ไปยังโฟลเดอร์ `/opt/payment/releases/20261015` ซึ่งถูกลบออกไปแล้ว (ใน `releases/` เหลือเพียง `20261101` และ `20261103`) ต้องแจ้งทีมที่ดูแลทำการอัปเดต Symlink ให้ชี้ไปยัง Release ที่ถูกต้อง', '{symlink,file,troubleshooting}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('e19ee335-78a0-4eac-b7a7-95af8779fa8f', 'linux:03-file-system:q04', 1, 'adeaa019-95a7-4877-8d5a-94c875441152', 'แอปพลิเคชันบนเครื่อง `app-01` พยายามเชื่อมต่อฐานข้อมูลด้วยชื่อ `db-internal.corp` แต่กลับวิ่งไปยัง IP เก่า (`10.10.1.50`) ทั้งที่ทีม Network ยืนยันว่าอัปเดต DNS Server กลางเป็น IP ใหม่ (`10.10.2.99`) เรียบร้อยแล้ว ควรตรวจสอบไฟล์ใดบนเครื่อง `app-01` เป็นอันดับแรก?', '$ ping -c 1 db-internal.corp
PING db-internal.corp (10.10.1.50) 56(84) bytes of data.', 'medium', 'scenario', 'โดยค่าเริ่มต้น Linux จะตรวจสอบการจับคู่ชื่อโฮสต์ในไฟล์ `/etc/hosts` ของเครื่องก่อนส่งคำถามไปที่ DNS Server ที่ระบุใน `/etc/resolv.conf` หากมีการผูก IP เก่าค้างไว้ใน `/etc/hosts` เครื่องจะใช้ IP นั้นทันที', '{hosts,dns,etc,troubleshooting}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('23509a71-f1f8-45bf-96da-6d3a6a9c3f91', 'linux:03-file-system:q05', 1, 'adeaa019-95a7-4877-8d5a-94c875441152', 'ระบบเกิดความผิดปกติเมื่อ 25 นาทีที่แล้ว หัวหน้าทีมต้องการทราบว่ามีไฟล์ใดใน `/etc/nginx` ถูกแก้ไขเนื้อหาในช่วง 30 นาทีที่ผ่านมาหรือไม่ ควรใช้คำสั่งใดตรวจสอบ?', NULL, 'medium', 'multiple_choice', 'ในคำสั่ง `find` ตัวเลือก `-mmin -30` หมายถึงค้นหาไฟล์ที่มีการแก้ไขเนื้อหา (Modification time in minutes) น้อยกว่า 30 นาทีที่ผ่านมา (ส่วน `-mtime` จะนับเป็นหน่วยวัน/24 ชั่วโมง)', '{find,stat,timestamp}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('27c7d63d-8846-4721-927d-742b789c9ef0', 'linux:03-file-system:q06', 1, 'adeaa019-95a7-4877-8d5a-94c875441152', 'เมื่อใช้คำสั่ง `stat config.yml` จะเห็นเวลา 3 ค่า ได้แก่ Access, Modify และ Change ค่า `Modify` กับ `Change` ต่างกันอย่างไร?', NULL, 'hard', 'multiple_choice', 'ในระบบไฟล์ Linux: `Modify` (mtime) คือเวลาที่เนื้อหาภายในไฟล์ถูกแก้ไขครั้งล่าสุด ส่วน `Change` (ctime) คือเวลาที่ข้อมูลกำกับไฟล์ (Metadata เช่น สิทธิ์ `chmod`, เจ้าของ `chown`, หรือจำนวนลิงก์) ถูกเปลี่ยนแปลง', '{stat,inode,filesystem}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('1ec400d8-3617-45ec-8fb7-3dbea642ec4b', 'linux:03-file-system:q07', 1, 'adeaa019-95a7-4877-8d5a-94c875441152', 'คำสั่ง `file report_2026.gz` มีประโยชน์อย่างไรในการตรวจสอบปัญหาหน้างาน?', NULL, 'easy', 'multiple_choice', 'คำสั่ง `file` จะอ่านข้อมูลส่วนหัว (Magic bytes) ของไฟล์เพื่อบอกชนิดที่แท้จริงของไฟล์โดยไม่เชื่อแค่ชื่อนามสกุล ช่วยให้รู้ว่าไฟล์ `.gz` ที่แตกไม่ได้ แท้จริงแล้วเป็นไฟล์ข้อความธรรมดาหรือไฟล์ว่างหรือไม่', '{file,troubleshooting,filesystem}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('f3e4853e-922b-4d4a-b10f-7d2bd40d88f1', 'linux:04-process-service:q01', 1, 'f18ea418-7710-44cb-b1b9-4a5724a2a92b', 'คำสั่ง `kill 14520` กับคำสั่ง `kill -9 14520` มีความแตกต่างกันอย่างไรในแง่ของการจัดการโปรเซส?', NULL, 'easy', 'multiple_choice', '`kill <PID>` โดยไม่ระบุตัวเลขสัญญาณ จะส่งสัญญาณเริ่มต้นคือ `SIGTERM` (15) เพื่อขอให้โปรเซสปิดตัวเองอย่างสุภาพและบันทึกข้อมูลที่ค้างให้เรียบร้อย ส่วน `kill -9 <PID>` ส่งสัญญาณ `SIGKILL` (9) ซึ่งสั่งให้ Kernel ตัดการทำงานของโปรเซสทันทีโดยไม่ให้โอกาสเคลียร์งาน', '{kill,signals,process}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('f8280394-341a-4956-bc80-97c392a1c7be', 'linux:04-process-service:q02', 1, 'f18ea418-7710-44cb-b1b9-4a5724a2a92b', 'จากผลลัพธ์ของคำสั่ง `systemctl status payment-worker.service` ด้านล่าง สาเหตุที่ทำให้บริการหยุดทำงานคืออะไร?', '× payment-worker.service - Payment Queue Worker
     Loaded: loaded (/etc/systemd/system/payment-worker.service; enabled)
     Active: failed (Result: oom-kill) since Tue 2026-11-03 13:45:02 +07; 3min ago
    Process: 9412 ExecStart=/usr/bin/python3 /opt/payment/worker.py (code=killed, signal=KILL)
   Main PID: 9412 (code=killed, signal=KILL)

Nov 03 13:45:02 app-02 systemd[1]: payment-worker.service: A process of this unit has been killed by the OOM killer.
Nov 03 13:45:02 app-02 systemd[1]: payment-worker.service: Failed with result ''oom-kill''.', 'medium', 'scenario', 'บรรทัด `Active: failed (Result: oom-kill)` และข้อความ `killed by the OOM killer` ระบุชัดเจนว่าเครื่องมีหน่วยความจำ (RAM) ไม่เพียงพอ จนระบบ Out-Of-Memory (OOM) Killer ของ Linux Kernel ต้องส่งสัญญาณ `SIGKILL` มาบังคับปิดโปรเซสนี้', '{systemctl,oom-kill,troubleshooting}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('90c789a2-b6f3-4c51-9a7a-df5d3e8f28e2', 'linux:04-process-service:q03', 1, 'f18ea418-7710-44cb-b1b9-4a5724a2a92b', 'หากต้องการตรวจสอบรายชื่อบริการ (systemd units) ทั้งหมดบนเครื่องที่อยู่ในสถานะ `failed` ในคำสั่งเดียว ควรใช้คำสั่งใด?', NULL, 'easy', 'multiple_choice', 'คำสั่ง `systemctl list-units --failed` (หรือ `systemctl --failed`) จะกรองและแสดงเฉพาะยูนิตบริการที่มีปัญหาอยู่ในสถานะ `failed` ทั้งหมด ช่วยให้ NOC Tier 1 ตรวจภาพรวมของเครื่องได้รวดเร็ว', '{systemctl,systemd,service}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('38b2cbc9-0ffb-4c2f-9042-fcd9bf03fa06', 'linux:04-process-service:q04', 1, 'f18ea418-7710-44cb-b1b9-4a5724a2a92b', 'จากผลลัพธ์ของคำสั่ง `ps aux` ด้านล่าง โปรเซส PID `24109` ที่มีสถานะ `Z` และมีคำว่า `<defunct>` ต่อท้ายคืออะไร และเหตุใดการใช้ `kill -9 24109` จึงไม่ทำให้รายการนี้หายไป?', '$ ps aux | grep report
appuser   24100  0.2  1.5 412800 31200 ?  Sl   09:00   0:14 /usr/bin/python3 /opt/app/scheduler.py
appuser   24109  0.0  0.0      0     0 ?  Z    10:15   0:00 [report_gen.sh] <defunct>', 'hard', 'scenario', 'สถานะ `Z` (`<defunct>`) คือ **Zombie Process** ซึ่งเป็นโปรเซสที่ทำงานจบและคืนหน่วยความจำไปแล้ว แต่โปรเซสแม่ (PPID) ยังไม่ได้เรียก `wait()` เพื่ออ่านค่าสถานะจบงาน เนื่องจากมันจบการทำงานไปแล้ว จึงไม่สามารถฆ่าซ้ำด้วย `kill -9 24109` ได้ การเคลียร์ต้องให้โปรเซสแม่อ่านสถานะ หรือรีสตาร์ทโปรเซสแม่ตาม Runbook', '{ps,zombie,process,troubleshooting}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('d7eedd6d-d129-48c5-a471-bde470b716ee', 'linux:04-process-service:q05', 1, 'f18ea418-7710-44cb-b1b9-4a5724a2a92b', 'หากต้องการดู Log ของบริการ `nginx` ย้อนหลัง 100 บรรทัดล่าสุด และเปิดติดตามบรรทัดใหม่ที่เข้ามาแบบเรียลไทม์ (Real-time follow) ต้องใช้คำสั่งใด?', NULL, 'easy', 'multiple_choice', '`journalctl -u nginx` ระบุชื่อยูนิตบริการ, `-n 100` แสดงย้อนหลัง 100 บรรทัด, และ `-f` (follow) ติดตามข้อความใหม่แบบสด', '{journalctl,logs,systemd}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('9d6fdd1a-c91e-4801-b419-5b7464be34e6', 'linux:04-process-service:q06', 1, 'f18ea418-7710-44cb-b1b9-4a5724a2a92b', 'คำสั่ง `systemctl enable nginx` ทำหน้าที่อะไร?', NULL, 'medium', 'multiple_choice', '`systemctl enable <service>` เป็นการสร้าง Symbolic link เพื่อให้บริการนั้นเริ่มทำงานอัตโนมัติเมื่อเปิดเครื่อง (Boot) แต่ไม่ได้สั่งสตาร์ทบริการในทันที (หากต้องการสตาร์ททันทีด้วยต้องใช้ `systemctl start` หรือ `systemctl enable --now`)', '{systemctl,systemd,boot}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('1585e544-0263-4635-83aa-d715e87cb38e', 'linux:04-process-service:q07', 1, 'f18ea418-7710-44cb-b1b9-4a5724a2a92b', 'เมื่อเปิดโปรแกรม `top` เพื่อดูโปรเซสที่กำลังทำงานอยู่ หากต้องการเรียงลำดับโปรเซสตามปริมาณการใช้หน่วยความจำ (`%MEM`) จากมากไปน้อย ต้องกดปุ่มใดบนคีย์บอร์ด?', NULL, 'medium', 'multiple_choice', 'ในหน้าจอโปรแกรม `top` การกดปุ่ม `M` (ตัวพิมพ์ใหญ่) จะเรียงลำดับตาม `%MEM` จากมากไปน้อย ส่วนการกดปุ่ม `P` (ตัวพิมพ์ใหญ่) จะเรียงตาม `%CPU` และการกด `q` คือออกจากโปรแกรม', '{top,memory,process}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('063ee6ab-3870-4443-a4c7-f47dd6b52be3', 'linux:05-text-tools:q01', 1, 'f96ce3b7-1a44-4b37-b45c-aa3ee895c375', 'หากต้องการค้นหาคำว่า `timeout` ในไฟล์ `app.log` โดยไม่สนใจว่าเป็นตัวพิมพ์เล็กหรือพิมพ์ใหญ่ (`Timeout`, `TIMEOUT`, `timeout`) พร้อมแสดงหมายเลขบรรทัดกำกับ ต้องใช้คำสั่งใด?', NULL, 'easy', 'multiple_choice', 'ในคำสั่ง `grep` ตัวเลือก `-i` หมายถึงไม่สนใจตัวพิมพ์เล็ก-ใหญ่ (ignore case) และ `-n` หมายถึงแสดงหมายเลขบรรทัด (line number) เมื่อรวมกันคือ `grep -in "timeout" app.log`', '{grep,logs,text-tools}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('c848a792-a49c-488d-ba20-3fbea6501ed6', 'linux:05-text-tools:q02', 1, 'f96ce3b7-1a44-4b37-b45c-aa3ee895c375', 'ความแตกต่างที่สำคัญระหว่างการรัน `grep "ERROR" app.log > summary.txt` กับ `grep "ERROR" app.log >> summary.txt` คืออะไร?', NULL, 'easy', 'multiple_choice', 'เครื่องหมาย `>` (Single redirect) จะล้างข้อมูลเดิมในไฟล์ `summary.txt` ทิ้งทั้งหมดแล้วเขียนทับใหม่ ส่วน `>>` (Append redirect) จะนำผลลัพธ์ใหม่ไปเขียนต่อท้ายไฟล์เดิมโดยไม่ลบข้อมูลเก่า', '{redirect,bash,text-tools}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('a2fad7a4-377c-4205-a3dd-ba2639d4f345', 'linux:05-text-tools:q03', 1, 'f96ce3b7-1a44-4b37-b45c-aa3ee895c375', 'จากตัวอย่างบรรทัดในไฟล์ `access.log` ด้านล่าง หากต้องการหา 5 อันดับ IP Address ที่ส่ง Request เข้ามามากที่สุด พร้อมจำนวนครั้ง เรียงจากมากไปน้อย ควรใช้ชุดคำสั่งใด?', '$ head -n 3 /var/log/nginx/access.log
203.0.113.50 - - [03/Nov/2026:14:00:01 +0700] "GET /api/v1/items HTTP/1.1" 200 1420
198.51.100.12 - - [03/Nov/2026:14:00:02 +0700] "POST /api/v1/login HTTP/1.1" 401 85
203.0.113.50 - - [03/Nov/2026:14:00:02 +0700] "GET /api/v1/items HTTP/1.1" 200 1420', 'medium', 'scenario', 'IP Address อยู่ในคอลัมน์ที่ 1 จึงใช้ `awk ''{print $1}''` ดึงออกมา จากนั้นต้องใช้ `sort` เพื่อให้ IP เดียวกันมาเรียงติดกันก่อนส่งให้ `uniq -c` นับจำนวน แล้วจึงใช้ `sort -nr` เรียงตามตัวเลขจากมากไปน้อย ปิดท้ายด้วย `head -n 5`', '{awk,sort,uniq,logs}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('6beac71f-ab96-429b-ba53-7d8e90efdf67', 'network:06-vlan:q05', 2, 'd297f4f2-4aec-41db-b324-a8e4ae10ea05', 'บนเครื่องเซิร์ฟเวอร์ Linux คำสั่งใดใช้สำหรับตรวจสอบตารางจับคู่ระหว่าง IP Address และ MAC Address (ARP Table)?', 'การตรวจสอบปัญหาความขัดแย้งของเครือข่ายบนเครื่องลูกข่าย', 'easy', 'multiple_choice', 'บน Linux ยุคใหม่ใช้คำสั่ง ''ip neigh show'' (ย่อมาจาก neighbor) หรือคำสั่งดั้งเดิม ''arp -an'' เพื่อดูตาราง ARP Cache', '{network,arp,linux,commands}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('ebbab95e-1663-4e95-9c8e-47efd927b2b5', 'linux:05-text-tools:q04', 1, 'f96ce3b7-1a44-4b37-b45c-aa3ee895c375', 'ในการตรวจสอบไฟล์ `access.log` พบว่ามีบรรทัดของระบบตรวจสอบสุขภาพ `/healthcheck` ปะปนอยู่จำนวนมาก หากต้องการกรองเอาเฉพาะบรรทัดที่ **ไม่มี** คำว่า `healthcheck` ออกมาดู 20 บรรทัดสุดท้าย ควรใช้คำสั่งใด?', NULL, 'medium', 'multiple_choice', 'ตัวเลือก `-v` (invert match) ของ `grep` จะคัดกรองเอาเฉพาะบรรทัดที่ไม่มีคำค้นหานั้น เมื่อส่งผ่าน Pipe ไปยัง `tail -n 20` จะได้ 20 บรรทัดล่าสุดที่ไม่ใช่ healthcheck', '{grep,tail,pipe}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('beef98a0-5be8-485d-84d7-dc1947afead4', 'linux:05-text-tools:q05', 1, 'f96ce3b7-1a44-4b37-b45c-aa3ee895c375', 'จากคำสั่งและผลลัพธ์ด้านล่าง เหตุใดผลลัพธ์ของคำสั่ง `uniq -c` จึงยังมีชื่อสถานะ `ERROR` แยกกันอยู่ 2 บรรทัดแทนที่จะรวมกันเป็น 3 ครั้ง?', '$ cat status.txt
ERROR
INFO
ERROR
ERROR

$ cat status.txt | uniq -c
      1 ERROR
      1 INFO
      2 ERROR', 'medium', 'scenario', 'คำสั่ง `uniq` จะเปรียบเทียบและยุบรวมเฉพาะบรรทัดที่ซ้ำกันซึ่ง **อยู่ติดกันเท่านั้น** เนื่องจากมีบรรทัด `INFO` คั่นกลางระหว่าง `ERROR` ตัวแรกกับสองตัวหลัง จึงต้องรัน `sort` ก่อนส่งเข้า `uniq -c` (`sort status.txt | uniq -c`)', '{uniq,sort,troubleshooting}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('94e77eb0-8531-4d36-b351-a394e5a164e3', 'linux:05-text-tools:q06', 1, 'f96ce3b7-1a44-4b37-b45c-aa3ee895c375', 'หากต้องการค้นหาบรรทัดที่มีคำว่า `ERROR` หรือ `FATAL` หรือ `CRITICAL` ในไฟล์ `server.log` พร้อมแสดงบรรทัดก่อนหน้าและหลังจุดที่พบอย่างละ 3 บรรทัดเพื่อดูบริบท ต้องใช้คำสั่งใด?', NULL, 'hard', 'multiple_choice', 'ตัวเลือก `-E` เปิดใช้งาน Extended Regular Expressions ทำให้ใช้ `|` แทนคำว่า ''หรือ'' ได้ และตัวเลือก `-C 3` (Context) จะแสดงบรรทัดก่อนหน้า 3 บรรทัด และบรรทัดถัดไป 3 บรรทัดรอบจุดที่พบ', '{grep,regex,logs}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('ffc2a0cd-6e46-43a2-90b3-9302014d2039', 'linux:05-text-tools:q07', 1, 'f96ce3b7-1a44-4b37-b45c-aa3ee895c375', 'ในคำสั่ง `./check_health.sh > /tmp/check.log 2>&1` ส่วนของ `2>&1` มีความหมายว่าอย่างไร?', NULL, 'hard', 'multiple_choice', 'ใน Linux File Descriptor `1` คือ Standard Output (`stdout`) และ `2` คือ Standard Error (`stderr`) การเขียน `2>&1` จึงหมายถึงการส่งข้อความ Error (`2`) ไปรวมที่ช่องทางเดียวกับผลลัพธ์ปกติ (`1`) เพื่อให้ทั้งผลลัพธ์ปกติและข้อความ Error ถูกบันทึกลงในไฟล์ `/tmp/check.log` ครบถ้วน', '{redirect,stderr,stdout,bash}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('1ca32e9b-b597-44d2-8add-2849374abcb5', 'linux:06-log-reading:q01', 1, 'b5b35ad3-068d-4e04-b07b-670f9697aea3', 'หากต้องการตรวจสอบประวัติการล็อกอิน SSH และการใช้คำสั่ง `sudo` บนเซิร์ฟเวอร์ตระกูล Ubuntu/Debian เทียบกับตระกูล RHEL/Rocky Linux ต้องเปิดดูที่ไฟล์ใดตามลำดับ?', NULL, 'easy', 'multiple_choice', 'บนระบบ Ubuntu/Debian บันทึกเกี่ยวกับการพิสูจน์ตัวตน (Authentication, SSH, sudo) จะอยู่ที่ `/var/log/auth.log` ส่วนบนระบบ RHEL/Rocky/AlmaLinux จะเก็บไว้ที่ `/var/log/secure`', '{logs,auth,ubuntu,rhel}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('892ec4d9-193b-40fa-a7c6-71c4e3031c2d', 'linux:02-basics:q01', 1, '2f157328-48ee-496e-bcef-7afd1b6a8d1f', 'เจ้าหน้าที่ Support รีโมตเข้าเครื่องเซิร์ฟเวอร์แล้วต้องการตรวจสอบว่าขณะนี้ตนเองกำลังยืนอยู่ที่โฟลเดอร์ใดแบบเส้นทางเต็ม (Absolute Path) ควรใช้คำสั่งใด?', NULL, 'easy', 'multiple_choice', 'คำสั่ง `pwd` (Print Working Directory) ใช้แสดงเส้นทางเต็มของโฟลเดอร์ปัจจุบันตั้งแต่ราก (`/`) ช่วยป้องกันความผิดพลาดก่อนรันคำสั่งจัดการไฟล์', '{pwd,basics,navigation}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('1e16fb7f-d0aa-4285-b8d2-3faa3bccb016', 'linux:02-basics:q02', 1, '2f157328-48ee-496e-bcef-7afd1b6a8d1f', 'หากต้องการดูรายการไฟล์ทั้งหมดในโฟลเดอร์ รวมถึงไฟล์ซ่อนที่ขึ้นต้นด้วยจุด (`.`) พร้อมแสดงสิทธิ์และขนาดไฟล์ในหน่วยที่อ่านง่าย (KB, MB, GB) ควรใช้คำสั่งใด?', NULL, 'easy', 'multiple_choice', 'ตัวเลือก `-l` แสดงรายละเอียดแบบยาว, `-a` แสดงไฟล์ทั้งหมดรวมไฟล์ซ่อน (dotfiles), และ `-h` แปลงหน่วยขนาดไฟล์ให้อ่านง่าย (human-readable) เมื่อรวมกันคือ `ls -lah`', '{ls,basics,files}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('35d32f57-908c-4509-84c0-94b315f2bd35', 'linux:02-basics:q03', 1, '2f157328-48ee-496e-bcef-7afd1b6a8d1f', 'จากผลลัพธ์บนหน้าจอ Terminal ด้านล่าง ทำไมคำสั่ง `tail -n 20 error.log` จึงแจ้งว่า `No such file or directory` และควรแก้ไขอย่างไร?', 'support@web-01:/var/log/nginx$ ls -l
total 48
-rw-r----- 1 www-data adm 38420 Nov  3 11:00 access.log
-rw-r----- 1 www-data adm  8192 Nov  3 10:55 Error.log
support@web-01:/var/log/nginx$ tail -n 20 error.log
tail: cannot open ''error.log'' for reading: No such file or directory', 'easy', 'scenario', 'ระบบไฟล์บน Linux แยกแยะตัวพิมพ์เล็กและตัวพิมพ์ใหญ่ (Case-sensitive) จากผลของ `ls -l` ชื่อไฟล์จริงคือ `Error.log` (ตัว E พิมพ์ใหญ่) ดังนั้นการพิมพ์ `error.log` จึงถือเป็นคนละไฟล์ วิธีป้องกันคือใช้ปุ่ม Tab ช่วยเติมชื่อไฟล์', '{case-sensitive,tail,troubleshooting}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('1fabb88c-d4d0-4b99-b096-f544592a7eae', 'linux:06-log-reading:q02', 1, 'b5b35ad3-068d-4e04-b07b-670f9697aea3', 'เมื่อต้องการค้นหาคำว่า `ORA-12170` ในไฟล์ Log ของเมื่อวานซึ่งถูก `logrotate` บีบอัดเป็นไฟล์ `/var/log/app/worker.log.1.gz` ไปแล้ว วิธีใดเหมาะสมและปลอดภัยที่สุดบนเครื่อง Production?', NULL, 'easy', 'multiple_choice', 'คำสั่ง `zgrep` สามารถค้นหาข้อความภายในไฟล์ที่ถูกบีบอัดด้วย gzip (`.gz`) ได้โดยตรงในหน่วยความจำ โดยไม่ต้องแตกไฟล์ออกมาเขียนลงดิสก์ จึงไม่เสี่ยงทำให้พาร์ทิชัน `/var/log` เต็ม', '{zgrep,logrotate,logs}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('aaa1442e-1b0e-4ba3-9c3b-d709f527716c', 'linux:06-log-reading:q03', 1, 'b5b35ad3-068d-4e04-b07b-670f9697aea3', 'ลูกค้าแจ้งว่าทำรายการโอนเงินไม่สำเร็จเมื่อเวลา **15:20 น. (ตามเวลาประเทศไทย)** เมื่อคุณรีโมตเข้าเซิร์ฟเวอร์และรันคำสั่งด้านล่าง คุณควรระบุช่วงเวลาค้นหาใน `journalctl` อย่างไรจึงจะตรงกับเหตุการณ์ที่ลูกค้าแจ้ง?', '$ timedatectl
               Local time: Tue 2026-11-03 08:45:10 UTC
           Universal time: Tue 2026-11-03 08:45:10 UTC
                Time zone: Etc/UTC (UTC, +0000)', 'medium', 'scenario', 'จากผลลัพธ์ของ `timedatectl` เครื่องเซิร์ฟเวอร์ตั้งค่า Timezone เป็น **UTC (+0000)** ซึ่งช้ากว่าเวลาประเทศไทย (GMT+7) อยู่ 7 ชั่วโมง ดังนั้นเวลา 15:20 น. ของไทย จึงตรงกับเวลา **08:20 UTC** บนเครื่องเซิร์ฟเวอร์', '{timezone,journalctl,timedatectl,troubleshooting}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('2000d365-d8a9-4337-acea-cf9b3795d920', 'linux:06-log-reading:q04', 1, 'b5b35ad3-068d-4e04-b07b-670f9697aea3', 'จากผลลัพธ์ของคำสั่ง `dmesg -T` ด้านล่าง เกิดอะไรขึ้นกับโปรเซส `java` (PID 11204) และควรดำเนินการอย่างไร?', '$ dmesg -T | tail -n 3
[Tue Nov  3 11:02:14 2026] Out of memory: Killed process 11204 (java) total-vm:8421040kB, anon-rss:3812400kB, file-rss:0kB
[Tue Nov  3 11:02:14 2026] oom_reaper: reaped process 11204 (java), now anon-rss:0kB, file-rss:0kB', 'medium', 'scenario', 'ข้อความจาก Kernel Ring Buffer (`dmesg -T`) ระบุว่าเกิดภาวะหน่วยความจำของระบบหมด (`Out of memory`) ทำให้ Kernel สั่งฆ่าโปรเซส `java` (PID 11204) ที่ใช้หน่วยความจำจริง (`anon-rss`) ไปราว 3.8 GB ในฐานะ Tier 1 ต้องเก็บบรรทัด Log นี้พร้อมผล `free -h` และสถานะบริการเพื่อส่งต่อ (Escalate) ให้ทีมตรวจสอบปัญหา Memory leak หรือการตั้งค่า JVM Heap', '{dmesg,oom,kernel,logs}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('ec034ac3-b426-4d0c-b5d3-44e557e114b3', 'linux:06-log-reading:q05', 1, 'b5b35ad3-068d-4e04-b07b-670f9697aea3', 'คำสั่ง `journalctl -u api-gateway --since "2026-11-03 09:00:00" --until "2026-11-03 09:30:00" -p err` จะแสดงผลลัพธ์อย่างไร?', NULL, 'medium', 'multiple_choice', 'ตัวเลือก `-u api-gateway` กรองเฉพาะบริการนั้น, `--since` และ `--until` กำหนดกรอบเวลา 09:00 ถึง 09:30 และ `-p err` กรองเฉพาะข้อความที่มีระดับความรุนแรงตั้งแต่ Error ขึ้นไป (`err`, `crit`, `alert`, `emerg`)', '{journalctl,systemd,logs}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('72dae6ef-9cc7-4886-a78e-b03dcf03b3f0', 'linux:06-log-reading:q06', 1, 'b5b35ad3-068d-4e04-b07b-670f9697aea3', 'ตัวเลือก `-T` ในคำสั่ง `dmesg -T` ช่วยให้การอ่าน Log ของเจ้าหน้าที่ Support ง่ายขึ้นอย่างไร?', NULL, 'easy', 'multiple_choice', 'โดยค่าเริ่มต้น `dmesg` จะแสดงเวลาเป็นตัวเลขวินาทีนับจากตอนเปิดเครื่อง (เช่น `[14250.120411]`) ซึ่งเทียบกับเวลาที่เกิดเหตุจริงได้ยาก การใส่ `-T` (`--ctime`) จะแปลงเป็นวันที่และเวลาที่มนุษย์อ่านเข้าใจได้ง่าย (เช่น `[Tue Nov 3 11:02:14 2026]`)', '{dmesg,timestamp,logs}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('727c6eae-6010-4167-8926-e7b834cdb6c4', 'linux:06-log-reading:q07', 1, 'b5b35ad3-068d-4e04-b07b-670f9697aea3', 'เมื่อต้องรวบรวมข้อมูล Log ส่งต่อ (Escalate) ให้ทีม Tier 2 หรือทีมนักพัฒนา ข้อมูลชุดใดครบถ้วนและมีประโยชน์มากที่สุด?', NULL, 'easy', 'multiple_choice', 'การส่งต่อ Ticket ที่มีคุณภาพควรระบุชื่อเครื่อง (Hostname), พาธของไฟล์ Log, ช่วงเวลาที่เกิดเหตุพร้อมระบุ Timezone ของเครื่อง (เช่น UTC หรือ +07), ข้อความ Error พร้อมบรรทัดบริบทรอบข้าง (`grep -C`) และรหัสรายการ (Transaction/Request ID) หากมี', '{escalate,troubleshooting,logs}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('4405d551-253e-42a6-8516-84a2da370226', 'linux:07-disk-memory-cpu:q01', 1, '5f86a586-91de-4a51-b749-fcf6d837849f', 'จากผลลัพธ์ของคำสั่ง `free -h` ด้านล่าง ข้อใดอธิบายสถานะหน่วยความจำของเซิร์ฟเวอร์เครื่องนี้ได้ถูกต้องที่สุด?', '$ free -h
               total        used        free      shared  buff/cache   available
Mem:            15Gi       3.1Gi       380Mi        95Mi        12Gi        11Gi
Swap:          4.0Gi          0B       4.0Gi', 'easy', 'scenario', 'แม้คอลัมน์ `free` จะแสดงเพียง `380Mi` แต่ Linux นำหน่วยความจำที่ว่างไปพักแคชไฟล์ใน `buff/cache` ถึง `12Gi` ซึ่งพร้อมคืนให้แอปพลิเคชันใช้งานทันที โดยดูได้จากคอลัมน์ `available` ที่มีอยู่ถึง `11Gi` (จาก `15Gi`) และ `Swap` ยังเป็น `0B` ดังนั้นหน่วยความจำของเครื่องนี้ยังเหลือใช้งานได้อย่างสบาย', '{free,memory,ram}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('ff00fcfc-cc97-4ef4-a859-b9e111a5857a', 'linux:07-disk-memory-cpu:q02', 1, '5f86a586-91de-4a51-b749-fcf6d837849f', 'แอปพลิเคชันไม่สามารถสร้างไฟล์ใหม่ในพาร์ทิชัน `/var` ได้และฟ้อง `No space left on device` แต่เมื่อรัน `df -h` พบว่าพื้นที่ดิสก์ยังว่างอีก 40 GB เมื่อตรวจสอบต่อด้วย `df -i` ได้ผลดังด้านล่าง สาเหตุเกิดจากอะไร?', '$ df -h /var
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdb1        80G   40G   40G  50% /var

$ df -i /var
Filesystem      Inodes   IUsed   IFree IUse% Mounted on
/dev/sdb1      5242880 5242880       0  100% /var', 'medium', 'scenario', 'จากผลของ `df -i /var` พบว่า `IFree` เป็น `0` และ `IUse%` เป็น `100%` แสดงว่าหมายเลข **Inode เต็ม** (มักเกิดจากการมีไฟล์ขนาดเล็กจำนวนหลายล้านไฟล์ เช่น ไฟล์ Session หรือไฟล์ชั่วคราวที่ไม่ถูกลบ) ทำให้ระบบไฟล์ไม่สามารถสร้างไฟล์ใหม่เพิ่มได้แม้พื้นที่ความจุ (GB) จะยังว่างอยู่', '{df,inode,disk,troubleshooting}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('70a6fe79-8783-47a0-9025-d0f2dfc849f9', 'linux:07-disk-memory-cpu:q03', 1, '5f86a586-91de-4a51-b749-fcf6d837849f', 'หลังจากมีการลบไฟล์ Log ขนาด 30 GB ด้วยคำสั่ง `rm` ไปแล้ว แต่เมื่อตรวจด้วย `df -h` พื้นที่ดิสก์ยังไม่ลดลง คำสั่งใดใช้ตรวจสอบว่ามีโปรเซสใดยังคงเปิดถือไฟล์ที่ถูกลบไปแล้วค้างอยู่?', NULL, 'medium', 'multiple_choice', 'คำสั่ง `lsof +L1` ใช้แสดงรายการไฟล์ที่ถูกเปิดอยู่ซึ่งมีจำนวนลิงก์ (Link count) น้อยกว่า 1 (กล่าวคือชื่อไฟล์ถูกลบออกจากไดเรกทอรีไปแล้ว แต่โปรเซสยังเปิด File descriptor ค้างอยู่ ทำให้พื้นที่ดิสก์ยังไม่ถูกคืน)', '{lsof,disk,troubleshooting}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('b1082aee-a82d-4fac-8295-780e7b4bc4c0', 'linux:07-disk-memory-cpu:q04', 1, '5f86a586-91de-4a51-b749-fcf6d837849f', 'เมื่อรันคำสั่ง `uptime` ได้ผลว่า `load average: 0.80, 1.10, 1.25` ตัวเลขทั้ง 3 ค่านี้แทนช่วงเวลาใดตามลำดับ?', NULL, 'easy', 'multiple_choice', 'ค่า Load Average ทั้ง 3 ตัวเลขในคำสั่ง `uptime` และ `top` แทนค่าเฉลี่ยของโหลดงานในระบบย้อนหลัง **1 นาที, 5 นาที และ 15 นาที** ตามลำดับ', '{uptime,load-average,cpu}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('34c5edbf-6823-4260-850d-6273902007aa', 'linux:07-disk-memory-cpu:q05', 1, '5f86a586-91de-4a51-b749-fcf6d837849f', 'ในการประเมินว่าค่า `load average: 6.50` สูงเกินกำลังของเครื่องหรือไม่ ต้องใช้คำสั่งใดเพื่อดูจำนวน CPU Core ของเครื่องมาเปรียบเทียบ?', NULL, 'easy', 'multiple_choice', 'คำสั่ง `nproc` จะแสดงจำนวนหน่วยประมวลผล (CPU Cores/Threads) ที่มีให้ใช้งาน เช่น หาก `nproc` ได้ `2` ค่าโหลด `6.50` ถือว่าสูงเกินจำนวน Core มาก แต่หาก `nproc` ได้ `16` ค่าโหลด `6.50` ถือว่ายังมีกำลังเหลือ', '{nproc,cpu,load-average}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('7bb99738-0e7d-4e64-af8c-c6c23eb55759', 'linux:07-disk-memory-cpu:q06', 1, '5f86a586-91de-4a51-b749-fcf6d837849f', 'หากพบว่าเซิร์ฟเวอร์มีค่า Load Average สูงมาก แต่เมื่อตรวจสอบด้วย `vmstat 1 5` หรือ `top` กลับพบว่าค่าการใช้ CPU ของโปรแกรม (`us`) ต่ำมาก แต่ค่า `wa` สูงถึง 75% พร้อมมีโปรเซสติดสถานะ `D` จำนวนมาก บ่งชี้ถึงปัญหาใด?', NULL, 'hard', 'multiple_choice', 'คอลัมน์ `wa` คือ **I/O Wait** (เวลาที่ CPU ต้องรอการอ่าน/เขียนดิสก์หรือเครือข่ายสตอเรจ) และสถานะโปรเซส `D` คือ Uninterruptible sleep ที่รอ I/O บน Linux โปรเซสในสถานะ `D` จะถูกนับรวมใน Load Average ด้วย จึงทำให้ Load สูงทั้งที่ CPU ไม่ได้คำนวณหนัก', '{vmstat,iowait,load-average,troubleshooting}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('26fe4415-b506-49a7-90b7-1aff3eeabb25', 'linux:07-disk-memory-cpu:q07', 1, '5f86a586-91de-4a51-b749-fcf6d837849f', 'หากต้องการตรวจสอบขนาดของทุกโฟลเดอร์ย่อยในตำแหน่งปัจจุบันและเรียงลำดับตามขนาดจากน้อยไปมาก (โดยเข้าใจหน่วย K, M, G อย่างถูกต้อง) ควรใช้คำสั่งใด?', NULL, 'medium', 'multiple_choice', '`du -sh *` จะสรุปขนาดของแต่ละรายการในหน่วย Human-readable (K, M, G) และเมื่อส่งผ่าน Pipe ไปยัง `sort -h` (`--human-numeric-sort`) จะสามารถเรียงลำดับโดยเข้าใจว่า `2G` ใหญ่กว่า `500M` ได้อย่างถูกต้อง', '{du,sort,disk}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('a2110b46-0e41-4ae6-898e-582052248f0b', 'linux:08-remote-access:q01', 1, '75b271d2-e3ff-464b-be92-18b9ea5a0d05', 'เพื่อให้การล็อกอินแบบ SSH Key-based ทำงานได้โดยไม่ถูก `sshd` ปฏิเสธ สิทธิ์ (Octal Permission) ที่ถูกต้องของโฟลเดอร์ `~/.ssh` และไฟล์ `~/.ssh/authorized_keys` คือข้อใดตามลำดับ?', NULL, 'easy', 'multiple_choice', 'บริการ `sshd` มีโหมด `StrictModes` ซึ่งกำหนดให้โฟลเดอร์ `~/.ssh` ต้องมีสิทธิ์ `700` (`drwx------` เจ้าของเข้าได้คนเดียว) และไฟล์ `~/.ssh/authorized_keys` ต้องมีสิทธิ์ `600` (`-rw-------` เจ้าของอ่าน/เขียนได้คนเดียว) หากเปิดสิทธิ์ให้กลุ่มหรือผู้อื่นแก้ไขได้ `sshd` จะปฏิเสธการใช้ Key ทันที', '{ssh,permissions,security}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('c50abf18-1605-4875-adee-013bf4c85344', 'linux:08-remote-access:q02', 1, '75b271d2-e3ff-464b-be92-18b9ea5a0d05', 'เมื่อพยายามเชื่อมต่อ SSH ด้วยคำสั่งด้านล่างแล้วได้รับข้อความแจ้งเตือนดังภาพ สาเหตุเกิดจากอะไรและควรแก้ไขอย่างไร?', '$ ssh -i ~/.ssh/id_ed25519 support@10.20.1.50
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@         WARNING: UNPROTECTED PRIVATE KEY FILE!          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Permissions 0644 for ''/home/user/.ssh/id_ed25519'' are too open.
It is required that your private key files are NOT accessible by others.
This private key will be ignored.', 'easy', 'scenario', 'ข้อความ `Permissions 0644 for ''/home/user/.ssh/id_ed25519'' are too open` ระบุว่าไฟล์ Private Key บนเครื่องต้นทางมีสิทธิ์เปิดกว้างเกินไป (`644` ทำให้คนอื่นในเครื่องอ่านไฟล์กุญแจส่วนตัวได้) โปรแกรม `ssh` จึงเพิกเฉยไม่ยอมใช้กุญแจนี้ วิธีแก้คือรัน `chmod 600 ~/.ssh/id_ed25519`', '{ssh,permissions,troubleshooting}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('4ea1f21a-007e-415a-91bd-4faa49b43e2f', 'linux:08-remote-access:q03', 1, '75b271d2-e3ff-464b-be92-18b9ea5a0d05', 'ข้อผิดพลาด `Connection refused` กับ `Connection timed out` ขณะรันคำสั่ง `ssh user@10.20.1.50` บ่งชี้สาเหตุต่างกันอย่างไร?', NULL, 'medium', 'multiple_choice', '`Connection refused` แปลว่าแพ็กเก็ตเดินทางไปถึงเครื่อง `10.20.1.50` แล้ว แต่ปลายทางตอบปฏิเสธกลับมาทันทีเพราะพอร์ต 22 ไม่มีบริการ `sshd` เปิดฟังอยู่ (เช่น `sshd` หยุดทำงาน หรือเปลี่ยนไปฟังพอร์ตอื่น) ส่วน `Connection timed out` แปลว่าส่งแพ็กเก็ตไปแล้วไม่ได้รับการตอบกลับเลย มักเกิดจากติด Firewall, Security Group, Routing หรือยังไม่ได้ต่อ VPN', '{ssh,network,troubleshooting}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('05515d73-1a5e-475d-b40b-94ce12001fab', 'linux:08-remote-access:q04', 1, '75b271d2-e3ff-464b-be92-18b9ea5a0d05', 'ทีม Infrastructure แจ้งว่าเพิ่งติดตั้ง OS ใหม่ให้กับเซิร์ฟเวอร์ `10.20.1.88` เสร็จเรียบร้อย เมื่อคุณสั่ง `ssh support@10.20.1.88` จึงพบข้อความเตือนด้านล่าง หลังจากยืนยันกับทีม Infra แล้วว่าเป็นการลงเครื่องใหม่จริง คุณควรรันคำสั่งใดเพื่อล้างค่า Host key เก่าของ IP นี้ออกจากไฟล์ `known_hosts`?', '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Host key for 10.20.1.88 has changed and you have requested strict checking.
Host key verification failed.', 'medium', 'scenario', 'เมื่อเซิร์ฟเวอร์ถูกติดตั้ง OS ใหม่ที่ IP เดิม ลายนิ้วมือของเครื่อง (Host key) จะเปลี่ยนไป ทำให้ไม่ตรงกับค่าเก่าที่บันทึกไว้ใน `~/.ssh/known_hosts` คำสั่งที่ปลอดภัยและตรงจุดที่สุดในการลบเฉพาะบรรทัดของโฮสต์นั้นคือ `ssh-keygen -R 10.20.1.88`', '{ssh,known_hosts,ssh-keygen,troubleshooting}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('61f3e206-c48a-46a6-bfd0-f3c8b21d81ad', 'linux:08-remote-access:q05', 1, '75b271d2-e3ff-464b-be92-18b9ea5a0d05', 'หากเซิร์ฟเวอร์ปลายทางเปิดรับ SSH ที่พอร์ต `2222` และคุณต้องการคัดลอกไฟล์ `/tmp/report.txt` จากเซิร์ฟเวอร์มาไว้ที่โฟลเดอร์ปัจจุบันด้วยคำสั่ง `scp` ต้องระบุตัวเลือกพอร์ตอย่างไร?', NULL, 'medium', 'multiple_choice', 'ข้อควรระวังยอดฮิต: คำสั่ง `ssh` ใช้ `-p` (ตัวพิมพ์เล็ก) สำหรับระบุพอร์ต แต่คำสั่ง `scp` ใช้ **`-P` (ตัวพิมพ์ใหญ่)** สำหรับระบุพอร์ต (เนื่องจาก `-p` พิมพ์เล็กใน `scp` ถูกใช้สำหรับ preserve timestamps/modes เหมือนใน `cp -p`)', '{scp,ssh,ports}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('cae06534-8367-4658-867b-09de72d34502', 'linux:08-remote-access:q06', 1, '75b271d2-e3ff-464b-be92-18b9ea5a0d05', 'เหตุใดการใช้โปรแกรม `tmux` บนเซิร์ฟเวอร์จึงมีประโยชน์อย่างมากสำหรับเจ้าหน้าที่ Support เวลาต้องติดตาม Log หรือรันสคริปต์ตรวจสอบที่ใช้เวลานาน?', NULL, 'easy', 'multiple_choice', '`tmux` สร้างเซสชันเทอร์มินัลที่รันอยู่บนฝั่งเซิร์ฟเวอร์ หากสัญญาณอินเทอร์เน็ตของเจ้าหน้าที่หลุดหรือหน้าต่าง SSH ปิดลง งานที่รันอยู่ใน `tmux` จะไม่ถูกตัดจบ และสามารถใช้คำสั่ง `tmux attach` กลับเข้ามาดูหน้าจอเดิมต่อได้ทันที', '{tmux,ssh,remote-access}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('22fcc240-b574-4819-8d9b-af1205ffe0df', 'web-api:03-ssl-tls-certificates:q02', 4, 'c1527b50-8bf1-4171-95ce-52bd25ee35f4', 'หลังจากที่ทีมงานอัปเดตไฟล์ใบรับรอง SSL ใหม่ลงในไดเรกทอรี /etc/ssl/certs/ บน Linux Server เรียบร้อยแล้ว ทำไมเมื่อทดสอบเข้าเว็บยังคงแจ้งเตือนว่าใบรับรองเดิมหมดอายุอยู่?', 'ทีมงานเพิ่งต่ออายุใบรับรองเสร็จ แต่ผู้ใช้งานยังเข้าเว็บไม่ได้และได้ Error เก่า', 'easy', 'multiple_choice', 'Web Server (เช่น Nginx หรือ Apache) จะโหลด Certificate เก็บไว้ในหน่วยความจำ RAM ตั้งแต่ตอนบูตเซอร์วิส หากไม่สั่ง Reload หรือ Restart เว็บเซิร์ฟเวอร์จะไม่ดึงไฟล์ใบรับรองใหม่มาใช้งาน', '{web,ssl,nginx,troubleshooting}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('df8cecab-518d-43d8-926c-ffcd0f2e042e', 'linux:08-remote-access:q07', 1, '75b271d2-e3ff-464b-be92-18b9ea5a0d05', 'เมื่อต้องการซิงก์โฟลเดอร์ไฟล์ Log ขนาดใหญ่จากเซิร์ฟเวอร์ปลายทางมาที่เครื่องโลคอล โดยต้องการให้ส่งเฉพาะส่วนที่เปลี่ยนแปลง คงค่าสิทธิ์/เวลาเดิม และบีบอัดข้อมูลระหว่างส่งผ่านเครือข่าย ควรใช้คำสั่งใด?', NULL, 'medium', 'multiple_choice', 'คำสั่ง `rsync -avz` เหมาะสมที่สุด โดย `-a` (archive) คัดลอกทั้งโฟลเดอร์พร้อมคงสิทธิ์และเวลาเดิม, `-v` (verbose) แสดงรายการไฟล์ที่ส่ง, และ `-z` (compress) บีบอัดข้อมูลขณะส่งผ่านเครือข่าย และหากหลุดกลางคันสามารถรันซ้ำเพื่อส่งต่อเฉพาะส่วนที่ยังขาดได้', '{rsync,scp,remote-access}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('bb4bdd67-7b76-4f2a-bf49-f0e2b0c9c1f8', 'linux:09-cron-schedule:q01', 1, '5a93786b-3b53-4b51-8232-c77e8324453b', 'ในตาราง Crontab บรรทัดตั้งเวลา `30 3 * * 1-5 /opt/app/backup.sh` หมายถึงการสั่งรันสคริปต์ในเวลาใด?', NULL, 'easy', 'multiple_choice', 'ฟิลด์ที่ 1 คือนาที (`30`), ฟิลด์ที่ 2 คือชั่วโมง (`3` = 03:30 น.), ฟิลด์ที่ 3 คือวันที่ (`*` = ทุกวันที่), ฟิลด์ที่ 4 คือเดือน (`*` = ทุกเดือน), และฟิลด์ที่ 5 คือวันในสัปดาห์ (`1-5` = วันจันทร์ถึงวันศุกร์) ดังนั้นหมายถึงรันเวลา 03:30 น. ของทุกวันจันทร์ถึงศุกร์', '{cron,crontab,schedule}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('d18c78fa-edc9-4d07-bcee-55e19d3afd37', 'linux:09-cron-schedule:q02', 1, '5a93786b-3b53-4b51-8232-c77e8324453b', 'หากต้องการตรวจสอบรายการงานตั้งเวลา (Crontab) ของผู้ใช้ปัจจุบันโดยไม่เสี่ยงเผลอแก้ไขหรือลบข้อมูล ต้องใช้คำสั่งใด และควรระวังห้ามพิมพ์สลับกับคำสั่งใดมากที่สุด?', NULL, 'easy', 'multiple_choice', '`crontab -l` (list) ใช้แสดงรายการ Crontab ออกทางหน้าจออย่างปลอดภัย และต้องระวังห้ามพิมพ์ `crontab -r` (remove) เพราะจะลบตาราง Crontab ทั้งหมดทิ้งทันทีโดยไม่ถามยืนยัน', '{crontab,safety,cron}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('cbd582ae-b4a6-412f-852d-649e880f77b2', 'linux:09-cron-schedule:q03', 1, '5a93786b-3b53-4b51-8232-c77e8324453b', 'นักพัฒนาแจ้งว่าเมื่อล็อกอินเข้าเครื่องแล้วรัน `/opt/report/gen.sh` ด้วยตนเอง สคริปต์ทำงานสำเร็จปกติ แต่เมื่อตั้งเวลาใน Crontab ให้รันตอนเที่ยงคืนกลับล้มเหลวและพบข้อความในไฟล์ Log ดังด้านล่าง สาเหตุเกิดจากอะไร?', '$ sudo crontab -u appuser -l
0 0 * * * /opt/report/gen.sh >> /var/log/report.log 2>&1

$ tail -n 3 /var/log/report.log
Starting daily report generation...
/opt/report/gen.sh: line 14: node: command not found
Report generation failed with exit code 127.', 'medium', 'scenario', 'เมื่อ Cron สั่งรันงาน จะใช้สภาพแวดล้อม (Environment) พื้นฐานที่มีค่าตัวแปร `PATH` สั้นมาก (เช่น `/usr/bin:/bin`) ต่างจากตอนล็อกอินผ่าน Shell ปกติ หากโปรแกรม `node` ติดตั้งอยู่ที่ `/usr/local/bin/node` หรือในโฟลเดอร์ของ `nvm` ตัวสคริปต์ที่เรียกแค่ `node` เฉยๆ จึงหาคำสั่งไม่เจอ (`command not found`, exit code 127) ต้องแก้ไขโดยระบุ Absolute Path เต็มของคำสั่งหรือกำหนด `PATH` ในสคริปต์', '{cron,path,troubleshooting}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('aea9e7b1-71c1-4b19-9424-3f9410a25f28', 'linux:09-cron-schedule:q04', 1, '5a93786b-3b53-4b51-8232-c77e8324453b', 'จากบรรทัด Crontab และบันทึกใน `/var/log/syslog` ด้านล่าง เหตุใดคำสั่งสำรองไฟล์จึงล้มเหลวและเห็นคำสั่งถูกตัดจบแค่คำว่า `backup_`?', '$ crontab -l
0 1 * * * cp /opt/app/config.yml /opt/backup/config_$(date +%Y%m%d).yml

$ grep CRON /var/log/syslog | tail -n 1
Nov  3 01:00:01 app-01 CRON[19022]: (support) CMD (cp /opt/app/config.yml /opt/backup/config_$(date +)', 'hard', 'scenario', 'ในไฟล์ Crontab เครื่องหมายเปอร์เซ็นต์ (`%`) มีความหมายพิเศษคือถูกแปลงเป็น **การขึ้นบรรทัดใหม่ (Newline)** และข้อความหลัง `%` ตัวแรกจะถูกส่งเป็น Standard Input แทนที่จะเป็นส่วนหนึ่งของคำสั่ง ดังนั้นหากต้องใช้ `%` ในบรรทัด Crontab (เช่นใน `date +\%Y\%m\%d`) ต้องใส่เครื่องหมาย Backslash (`\`) นำหน้า `%` ทุกตัว หรือย้ายคำสั่งไปไว้ในไฟล์สคริปต์ `.sh`', '{crontab,percent,troubleshooting}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('8c5078fb-64e4-4e84-bbbb-ac15123d866d', 'linux:09-cron-schedule:q05', 1, '5a93786b-3b53-4b51-8232-c77e8324453b', 'หากต้องการตรวจสอบว่าบริการ Cron ได้สั่งปลุกงานตามเวลาที่ตั้งไว้จริงหรือไม่ บนเซิร์ฟเวอร์ **Ubuntu/Debian** เทียบกับ **RHEL/Rocky Linux** ต้องตรวจสอบที่ไฟล์ Log ใดตามลำดับ?', NULL, 'medium', 'multiple_choice', 'บน Ubuntu/Debian บันทึกการทำงานของบริการ `cron` จะถูกรวมอยู่ใน `/var/log/syslog` (ใช้ `grep CRON /var/log/syslog`) ส่วนบน RHEL/Rocky Linux บริการ `crond` จะแยกไฟล์ Log เฉพาะไว้ที่ `/var/log/cron`', '{cron,logs,ubuntu,rhel}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('8e9483d6-ae5f-40c0-b138-8ed3177059f1', 'linux:09-cron-schedule:q06', 1, '5a93786b-3b53-4b51-8232-c77e8324453b', 'ความแตกต่างทางโครงสร้างบรรทัดระหว่างการตั้งเวลาใน User Crontab (`crontab -e`) กับการตั้งเวลาในไฟล์ภายใต้ `/etc/cron.d/` คืออะไร?', NULL, 'medium', 'multiple_choice', 'ไฟล์ตารางงานระดับระบบใน `/etc/crontab` และ `/etc/cron.d/` จะต้องระบุ **ชื่อบัญชีผู้ใช้ (username)** แทรกเป็นฟิลด์ที่ 6 (หลังฟิลด์เวลา 5 ตัว และก่อนตัวคำสั่ง) เพื่อบอกว่าจะให้รันคำสั่งนั้นภายใต้สิทธิ์ของใคร ส่วนใน `crontab -e` เป็นของใครของมันอยู่แล้วจึงไม่มีฟิลด์ชื่อผู้ใช้', '{crontab,cron.d,system}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('2a3504c4-29e5-46af-b2fb-9ebf81c95947', 'linux:09-cron-schedule:q07', 1, '5a93786b-3b53-4b51-8232-c77e8324453b', 'บนเซิร์ฟเวอร์ Linux สมัยใหม่ หากตรวจสอบทั้ง `crontab -l` และ `/etc/cron*` แล้วไม่พบงานตั้งเวลาที่ตามหา แต่ยังมีงานรันอัตโนมัติตามรอบเวลาอยู่ ควรใช้คำสั่งใดเพื่อตรวจสอบกลไกตั้งเวลาของ `systemd`?', NULL, 'easy', 'multiple_choice', 'นอกเหนือจาก Cron แล้ว ระบบที่ใช้ `systemd` สามารถตั้งเวลางานด้วย **systemd timer** ได้ โดยตรวจสอบรายการทั้งหมดพร้อมเวลาที่จะรันรอบถัดไปและรอบล่าสุดได้ด้วยคำสั่ง `systemctl list-timers` (หรือ `systemctl list-timers --all`)', '{systemd,timers,cron}', true, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('4e95dfd0-892c-4c0c-b51f-9f1b56c0ad9f', 'linux:10-health-check:q01', 1, '9ed1b0db-122c-4d06-9d9c-bd4613afd6dd', 'เมื่อมีคนแจ้งว่าเว็บเข้าไม่ได้ ลำดับการตรวจแบบล่างขึ้นบนที่เหมาะสมที่สุดคือข้อใด?', NULL, 'easy', 'multiple_choice', 'ตรวจจากชั้นล่างขึ้นบนเพื่อหาชั้นแรกที่ผิดปกติ: Service รันอยู่ไหม (systemctl) → Process ฟัง Port ถูกต้องไหม (ss) → ต่อ Port จากภายนอกได้ไหม (nc) → Endpoint ตอบ HTTP ปกติไหม (curl)', '{troubleshooting,systemctl,ss,curl}', true, '2026-11-03 16:05:54.729798+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('a5cff860-3040-413a-b67a-63944822a4ad', 'linux:10-health-check:q03', 1, '9ed1b0db-122c-4d06-9d9c-bd4613afd6dd', 'จากผลลัพธ์ด้านล่าง ทำไมเครื่อง app-02 จึงต่อ Port 8080 ของเครื่องนี้ไม่ได้ ทั้งที่ Service รันปกติ?', '$ systemctl is-active order-api
active

$ sudo ss -ltnp ''sport = :8080''
State   Recv-Q  Send-Q  Local Address:Port  Peer Address:Port  Process
LISTEN  0       511         127.0.0.1:8080       0.0.0.0:*      users:(("node",pid=18420,fd=19))

# จาก app-02
$ nc -zv 10.20.1.50 8080
nc: connect to 10.20.1.50 port 8080 (tcp) failed: Connection refused', 'medium', 'scenario', 'Local Address เป็น 127.0.0.1:8080 แปลว่าแอปฟังเฉพาะภายในเครื่อง เครื่องอื่นจึงได้ Connection refused ต้องแจ้งทีมที่ดูแลแอปให้ตรวจ Config ว่ากำหนดให้ฟังที่ 0.0.0.0 หรือ IP ของเครื่อง ไม่ใช่ปัญหา Firewall หรือ Network', '{ss,bind-address,troubleshooting}', true, '2026-11-03 16:05:54.729798+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('af321481-4010-42cc-a917-de4dc61cda20', 'linux:10-health-check:q04', 1, '9ed1b0db-122c-4d06-9d9c-bd4613afd6dd', 'ความหมายของ Connection refused กับ Connection timed out ต่างกันอย่างไร?', NULL, 'easy', 'multiple_choice', 'refused: แพ็กเก็ตถึงเครื่องปลายทางแล้ว แต่ไม่มีโปรแกรมฟัง Port นั้น (หรือถูก reject) ส่วน timed out: ไม่มีคำตอบกลับมา มักเกิดจาก Firewall/Security Group ดรอปเงียบๆ หรือไม่มีเส้นทาง', '{tcp,curl,nc}', true, '2026-11-03 16:05:54.729798+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('f986cb3a-3b71-4610-889e-2cc401e88854', 'linux:10-health-check:q05', 1, '9ed1b0db-122c-4d06-9d9c-bd4613afd6dd', 'ต้องการดูเฉพาะ HTTP Status Code และเวลาที่ใช้ของ https://api.example.com/health โดยไม่แสดง Body และไม่ให้ค้างเกิน 10 วินาที ควรใช้คำสั่งใด?', NULL, 'medium', 'multiple_choice', '-sS ปิด Progress แต่ยังแสดง Error, -o /dev/null ทิ้ง Body, -w กำหนดรูปแบบผลลัพธ์ และ --max-time จำกัดเวลารวม', '{curl,health-check}', true, '2026-11-03 16:05:54.729798+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('7973243b-4e81-479c-9ae6-9ec56f46a8b5', 'linux:10-health-check:q06', 1, '9ed1b0db-122c-4d06-9d9c-bd4613afd6dd', 'จากผลลัพธ์ด้านล่าง การสตาร์ท Service ไม่สำเร็จเพราะอะไร และควรทำอะไรต่อ?', '$ sudo systemctl start report-api
Job for report-api.service failed.

$ journalctl -u report-api -n 3 --no-pager
Nov 03 14:20:11 app-prod-01 node[22011]: Error: listen EADDRINUSE: address already in use :::9000
Nov 03 14:20:11 app-prod-01 systemd[1]: report-api.service: Main process exited, code=exited, status=1/FAILURE

$ sudo ss -ltnp ''sport = :9000''
LISTEN 0 511 *:9000 *:* users:(("java",pid=1544,fd=77))', 'medium', 'scenario', 'EADDRINUSE แปลว่า Port 9000 ถูกใช้อยู่แล้ว จาก ss พบว่า Process java PID 1544 ถือ Port นี้ Tier 1 ควรเก็บชื่อและ PID ของ Process และ Log แล้วส่งต่อตาม Runbook ไม่ kill Process ที่ไม่รู้ที่มา', '{EADDRINUSE,ss,lsof,troubleshooting}', true, '2026-11-03 16:05:54.729798+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('d63a08cb-8a15-4783-8eba-9dec781d11b9', 'linux:10-health-check:q07', 1, '9ed1b0db-122c-4d06-9d9c-bd4613afd6dd', 'คำสั่ง curl ได้ผลลัพธ์ HTTP 502 Bad Gateway จาก Nginx ควรตรวจอะไรเป็นอันดับแรก?', '$ curl -I https://shop.example.com
HTTP/2 502
server: nginx/1.24.0', 'hard', 'scenario', '502 หมายถึง Nginx ทำงานอยู่แต่ได้คำตอบที่ใช้ไม่ได้หรือต่อ Upstream ไม่ได้ จึงควรตรวจ Service และ Port ของ Backend และอ่าน error.log ของ Nginx เพื่อดูข้อความ upstream', '{nginx,502,curl,upstream}', true, '2026-11-03 16:05:54.729798+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('98df92a1-ad7f-46d6-9529-d780a7dad658', 'network:01-ip-subnetting:q02', 2, 'd8929572-6865-40b4-bf65-a32bfcdb15a5', 'หากเครื่องเซิร์ฟเวอร์เปิดขึ้นมาแล้วรัน ip addr พบว่าได้รับ IP เป็น 169.254.12.34 ปัญหาน่าจะเกิดจากอะไร?', 'ได้รับแจ้งจากลูกค้าว่าตู้ Kiosk ไม่สามารถเชื่อมต่อกับ Backend API ได้ ตรวจสอบพบ IP 169.254.x.x', 'easy', 'multiple_choice', 'IP ในช่วง 169.254.0.0/16 คือ APIPA (Automatic Private IP Addressing) ซึ่งระบบปฏิบัติการจะกำหนดขึ้นเองเมื่อไม่สามารถขอ IP จาก DHCP Server ได้ หรือสาย LAN หลุด/ไม่เชื่อมต่อ', '{network,ip,dhcp,troubleshooting}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('b4c8e401-d6ff-494a-84f3-715e4b84eaba', 'network:01-ip-subnetting:q03', 2, 'd8929572-6865-40b4-bf65-a32bfcdb15a5', 'IP Address ใดต่อไปนี้จัดเป็น Public IP ที่สามารถวิ่งบน Public Internet ได้จริง?', 'คุณต้องตรวจสอบ Whitelist ใน Firewall ของลูกค้าว่าไอพีที่เข้ามาเป็น Private IP หรือ Public IP', 'easy', 'multiple_choice', 'Private IP ตาม RFC 1918 คือ 10.0.0.0/8, 172.16.0.0/12 (172.16-172.31), 192.168.0.0/16 ดังนั้น 172.32.1.1 จึงอยู่นอกช่วง Private และเป็น Public IP', '{network,ip,rfc1918}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('a6917e20-839e-4d3c-821d-4541711f8053', 'network:01-ip-subnetting:q04', 2, 'd8929572-6865-40b4-bf65-a32bfcdb15a5', 'เมื่อสั่ง ip route show แล้วไม่พบข้อความ ''default via ...'' ผลกระทบที่จะเกิดขึ้นกับเซิร์ฟเวอร์คือข้อใด?', 'เครื่องเซิร์ฟเวอร์เพิ่งถูกแก้ไขคอนฟิกเน็ตเวิร์ก หลังจากรีสตาร์ทสามารถ ping เครื่องข้างเคียงในวงเดียวกันเจอ แต่ออกเน็ตไม่ได้', 'medium', 'multiple_choice', 'default via ระบุ Default Gateway หากไม่มี จะทำให้เซิร์ฟเวอร์คุยได้เฉพาะเครื่องใน Local Subnet เดียวกันเท่านั้น แต่ไม่สามารถส่ง Packet ข้ามวงหรือออกอินเทอร์เน็ตได้', '{network,routing,gateway}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('9b606785-3b1d-4039-8aef-d077d30d52dc', 'network:02-dns-resolution:q01', 2, '04cb05e0-09ef-4ee4-8cf5-1ed7d502bbfe', 'คำสั่ง dig ใดต่อไปนี้ใช้สำหรับสอบถาม A Record ไปยัง Google DNS (8.8.8.8) โดยตรงและให้แสดงผลลัพธ์เฉพาะ IP แบบย่อ?', 'คุณต้องการทดสอบว่าปัญหาโดเมน resolve ไม่ได้เกิดจาก DNS Server ในองค์กรหรือเกิดจาก Cloudflare กันแน่', 'medium', 'multiple_choice', 'ไวยากรณ์ของ dig ในการระบุ DNS Server ปลายทางจะใช้เครื่องหมาย @ นำหน้า (@8.8.8.8) และการแสดงเฉพาะคำตอบสั้นๆ จะใช้ flag +short', '{network,dns,dig}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('f3360feb-004a-49b9-9366-b7b9899c587f', 'network:02-dns-resolution:q02', 2, '04cb05e0-09ef-4ee4-8cf5-1ed7d502bbfe', 'หากเครื่องเซิร์ฟเวอร์ resolve ชื่อโดเมนได้เป็น IP เดิมที่เลิกใช้ไปแล้ว ทั้งๆ ที่ผู้ให้บริการ DNS ยืนยันว่าเปลี่ยน IP แล้ว สาเหตุที่น่าจะเป็นไปได้มากที่สุดคืออะไร?', 'ระบบเพิ่ง Migrate เซิร์ฟเวอร์และเปลี่ยน IP ใน Cloudflare เมื่อ 10 นาทีที่แล้ว แต่ Web Server เครื่องหนึ่งยังยิงไป IP เก่า', 'easy', 'multiple_choice', 'DNS Resolver ฝั่ง Local หรือ ISP จะแคชค่าไว้จนกว่าค่า TTL (Time-To-Live) ของ Record นั้นจะหมดอายุลง เรียกว่าระยะ DNS Propagation', '{network,dns,ttl,caching}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('611c9533-5018-4260-93b1-75368ecf0e4b', 'network:02-dns-resolution:q03', 2, '04cb05e0-09ef-4ee4-8cf5-1ed7d502bbfe', 'หากต้องการตรวจสอบว่า IP 203.0.113.50 ผูกกับชื่อโฮสต์ใด (Reverse DNS Lookup) ควรใช้คำสั่งใด?', 'คุณได้รับ Alert จาก Firewall แจ้ง IP ต้องสงสัยเข้ามาและต้องการตรวจสอบย้อนกลับว่าเป็นชื่อโดเมนอะไร', 'medium', 'multiple_choice', 'การทำ Reverse DNS (PTR Record) ด้วย dig จะใช้แฟล็ก -x ตามด้วย IP เช่น dig -x 203.0.113.50', '{network,dns,ptr,reverse-dns}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('b8d26fbb-9136-4651-a96a-004a0568191c', 'network:03-routing-latency:q01', 2, '240e3caf-58b9-4b37-9d41-8d7a2830fe79', 'หากรัน mtr แล้วพบว่า Hop ที่ 4 มี Loss 40% แต่ Hop ที่ 5, 6 และปลายทางมี Loss 0% และ Latency ปกติ ข้อใดคือการวิเคราะห์ที่ถูกต้องที่สุด?', 'ผู้ใช้งานแจ้งว่าระบบช้า คุณทดสอบ mtr เพื่อนำข้อมูลไปแจ้งผู้ให้บริการ ISP', 'hard', 'multiple_choice', 'เราเตอร์กลางทาง (Hop 4) มักจะตั้งค่า ICMP Rate-limiting เพื่อป้องกัน CPU Overload ซึ่งจะดรอปเฉพาะ ICMP ที่วิ่งมาหาตัวมันเอง แต่ยัง Forward ทราฟฟิกจริงไปยัง Hop ถัดไปได้อย่างสมบูรณ์ จึงไม่ถือว่าเครือข่ายมีปัญหา', '{network,mtr,icmp,troubleshooting}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('62acd40b-f56e-4c54-ab90-2fa76164588b', 'network:06-vlan:q04', 2, 'd297f4f2-4aec-41db-b324-a8e4ae10ea05', 'เมื่อ Switch ได้รับ Frame ที่มี Destination MAC Address ที่ ''ไม่มีอยู่ใน MAC Address Table'' สวิตช์จะทำพฤติกรรมใด?', 'กลไกการส่งต่อข้อมูลพื้นฐานของสวิตช์ (Switch Learning & Forwarding)', 'medium', 'multiple_choice', 'หากสวิตช์ไม่รู้จัก Destination MAC Address จะเกิดพฤติกรรมเรียกว่า ''Unknown Unicast Flooding'' โดยสวิตช์จะส่งเฟรมนั้นออกไปยังทุกพอร์ตที่อยู่ใน VLAN เดียวกัน ยกเว้นพอร์ตที่รับเข้ามา', '{network,switching,mac-table,flooding}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('15081888-fb1c-4b94-9d2a-5bab1372ddd3', 'network:03-routing-latency:q02', 2, '240e3caf-58b9-4b37-9d41-8d7a2830fe79', 'ทำไมการทดสอบ ping ไปยังเซิร์ฟเวอร์ปลายทางแล้วได้ Request Timed Out จึงไม่สามารถฟันธงได้ว่าเซิร์ฟเวอร์ล่ม?', 'ลูกค้าแจ้งว่าเซิร์ฟเวอร์เว็บล่มเพราะลอง ping แล้วไม่ตอบกลับ', 'easy', 'multiple_choice', 'ping ใช้โปรโตคอล ICMP ซึ่งเซิร์ฟเวอร์และ Firewall ส่วนใหญ่ปิดการตอบรับ ICMP เพื่อป้องกันการสแกนและการโจมตี แต่เว็บเซิร์ฟเวอร์ที่เปิด Port 80/443 (TCP) อาจยังทำงานได้ตามปกติ', '{network,ping,icmp,firewall}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('809eec81-5754-4afb-8940-ff635ec0484c', 'network:04-tcp-ports-firewall:q01', 2, '3ff8610b-94c3-43a7-8e1f-436f27946647', 'เมื่อสั่ง nc -zv db-server 5432 แล้วได้รับผลลัพธ์ว่า ''Connection refused'' สาเหตุที่เป็นไปได้มากที่สุดคือข้อใด?', 'แอปพลิเคชันขึ้น Error ไม่สามารถเชื่อมต่อกับฐานข้อมูล PostgreSQL บนเครื่อง db-server ได้', 'medium', 'multiple_choice', 'Connection refused หมายถึงแพ็กเก็ตวิ่งไปถึงเครื่องปลายทางแล้ว แต่ OS ฝั่งปลายทางส่ง TCP RST กลับมาเพราะไม่มี Service ใดเปิด LISTEN อยู่ที่พอร์ต 5432 หรือ Service ดับอยู่', '{network,tcp,ports,connection-refused}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('9305fed3-82a6-4ca9-a25b-a0ae68b2049d', 'network:04-tcp-ports-firewall:q02', 2, '3ff8610b-94c3-43a7-8e1f-436f27946647', 'หากรันคำสั่ง ss -tulpn บนเซิร์ฟเวอร์ฐานข้อมูลแล้วพบว่า Local Address คือ ''127.0.0.1:5432'' จะส่งผลอย่างไรต่อการเชื่อมต่อ?', 'เครื่อง Backend Server ที่อยู่คนละเครื่องพยายามต่อ Database เครื่องนี้แต่ล้มเหลว', 'medium', 'multiple_choice', '127.0.0.1 คือ Loopback Interface การ Bind ที่ IP นี้จะทำให้รับการเชื่อมต่อได้เฉพาะจากภายในเครื่องตัวเองเท่านั้น หากต้องการให้เครื่องภายนอกเชื่อมต่อได้ ต้องตั้งค่าใน postgresql.conf ให้ listen_addresses = ''*'' หรือ bind ที่ 0.0.0.0', '{network,tcp,bind,postgresql}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('5f978533-62ea-48fe-9698-8ee8b1b27294', 'network:04-tcp-ports-firewall:q03', 2, '3ff8610b-94c3-43a7-8e1f-436f27946647', 'ความแตกต่างหลักระหว่างข้อผิดพลาด ''Connection Refused'' และ ''Connection Timed Out'' คืออะไร?', 'คำถามสัมภาษณ์งานตำแหน่ง Junior Application Support', 'easy', 'multiple_choice', 'Connection Refused ได้รับคำตอบปฏิเสธ (TCP RST) จากเครื่องปลายทาง แสดงว่าเครื่องปลายทางยังเปิดอยู่แต่ไม่มี Service รอรับ ส่วน Timed Out ไม่มีสัญญาณตอบกลับใดๆ เลยจนหมดเวลา มักเกิดจาก Firewall บล็อกทิ้ง (DROP) หรือเครื่องปลายทางดับ', '{network,tcp,interview,troubleshooting}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('8e98bdbc-25ff-4734-ab03-4f4cc8d75ec6', 'sql:01-queries-joins:q01', 3, '5a3d9602-fb56-4f50-b4fa-c231d799a302', 'หากต้องการค้นหาข้อมูลลูกค้า (customers) ทั้งหมดที่ยังไม่เคยมีประวัติการสั่งซื้อสินค้า (orders) เลยแม้แต่ครั้งเดียว ควรเขียนคำสั่ง SQL อย่างไร?', 'ทีม Marketing ขอให้ Support ดึงรายชื่อลูกค้าที่สมัครสมาชิกแล้วแต่ยังไม่ได้สั่งซื้อ', 'medium', 'multiple_choice', 'การทำ Anti-Join ที่มีประสิทธิภาพสูงใน SQL คือการใช้ LEFT JOIN ตาราง orders ด้วย customer_id แล้วระบุเงื่อนไขใน WHERE clause ว่า WHERE orders.id IS NULL', '{sql,join,anti-join,"null"}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('1965fab0-45b2-4e02-adc4-72650a0c04f0', 'sql:01-queries-joins:q02', 3, '5a3d9602-fb56-4f50-b4fa-c231d799a302', 'ทำไมการเขียนเงื่อนไข ''WHERE email = NULL'' ใน SQL จึงไม่ได้ผลลัพธ์ข้อมูลใดๆ กลับมาเลย?', 'Support ต้องการหาผู้ใช้ที่ไม่มีอีเมลในระบบ แต่เมื่อรันคำสั่งกลับได้ 0 แถว ทั้งที่มีข้อมูลเว้นว่างอยู่', 'easy', 'multiple_choice', 'ในมาตรฐาน SQL ค่า NULL หมายถึง Unknown ไม่ใช่ค่าที่นำมาเปรียบเทียบด้วยเครื่องหมายเท่ากับ (=) ได้ ผลของการเปรียบเทียบกับ NULL จะได้ค่า UNKNOWN ซึ่งถือเป็น False ใน WHERE clause เสมอ ต้องใช้ ''IS NULL'' แทน', '{sql,"null",syntax}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('31c1b64e-e85e-4f8c-9eca-381f6805148b', 'sql:01-queries-joins:q03', 3, '5a3d9602-fb56-4f50-b4fa-c231d799a302', 'ฟังก์ชัน COALESCE(phone, mobile, ''N/A'') จะให้ผลลัพธ์การทำงานอย่างไร?', 'คุณกำลังเขียน Query ดึงเบอร์ติดต่อเพื่อส่ง SMS แจ้งเตือนลูกค้า', 'easy', 'multiple_choice', 'COALESCE จะคืนค่าแรกจากซ้ายไปขวาที่ไม่เป็น NULL หากทั้ง phone และ mobile เป็น NULL ทั้งคู่ จะคืนค่าตัวสุดท้ายคือ ''N/A''', '{sql,coalesce,functions}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('c75407f1-a3a5-4a5b-981b-b9e31701154f', 'linux:10-health-check:q02', 1, '9ed1b0db-122c-4d06-9d9c-bd4613afd6dd', 'คำสั่งใดแสดงทุก Port ที่ฟังอยู่ (TCP และ UDP) พร้อมชื่อ Process และแสดงเป็นตัวเลข?', NULL, 'easy', 'multiple_choice', 'ss -tulpn: t = TCP, u = UDP, l = Listening, p = แสดง Process, n = ตัวเลข ไม่แปลงเป็นชื่อ ควรใช้ sudo เพื่อเห็น Process ของผู้ใช้อื่น', '{ss,port}', true, '2026-11-03 16:05:54.729798+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('5718c858-1020-4652-9789-1d2f2f1629ae', 'sql:02-aggregations-grouping:q01', 3, '10413c74-c724-4168-99e9-fc7c279fb980', 'หากต้องการค้นหา IP Address ที่ส่งคำขอ Login Failed มากกว่า 10 ครั้ง ควรเขียนเงื่อนไขกรองจำนวนครั้งที่จุดใด?', 'คุณกำลังตรวจสอบเหตุการณ์ Brute-force Attack ในฐานข้อมูลระบบยืนยันตัวตน', 'medium', 'multiple_choice', 'เงื่อนไขที่ตรวจสอบผลลัพธ์จากฟังก์ชันรวบรวมข้อมูล เช่น COUNT(*) > 10 จะต้องวางไว้ใน HAVING clause เท่านั้น ไม่สามารถวางใน WHERE clause ได้เพราะ WHERE ทำงานก่อนที่ข้อมูลจะถูกรวบกลุ่ม', '{sql,group-by,having,security}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('48ef625d-f83d-4e25-9661-d28975cfb48c', 'sql:02-aggregations-grouping:q02', 3, '10413c74-c724-4168-99e9-fc7c279fb980', 'ตาราง tickets มีทั้งหมด 100 แถว โดยมีคอลัมน์ resolved_by ที่มีค่าว่าง (NULL) อยู่ 20 แถว ผลลัพธ์ของ COUNT(*) และ COUNT(resolved_by) จะเป็นเท่าใดตามลำดับ?', 'หัวหน้างานสอบถามยอดสรุป Ticket ทั้งหมด และ Ticket ที่แก้เสร็จแล้ว', 'easy', 'multiple_choice', 'COUNT(*) นับแถวทั้งหมดไม่ว่าจะมีค่า NULL หรือไม่ จึงได้ 100 ส่วน COUNT(column_name) จะละเว้นแถวที่เป็น NULL จึงนับเฉพาะแถวที่มีค่า คือ 100 - 20 = 80', '{sql,count,"null",aggregates}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('e39e6e87-df02-4e08-a4a3-ddfce1e64731', 'sql:03-indexes-performance:q01', 3, '0ec2fdf6-2627-408b-9791-35963b5fe97e', 'เมื่อสั่ง EXPLAIN ANALYZE บนตารางขนาด 5 ล้านแถว แล้วพบคำว่า ''Seq Scan on orders (cost=0.00..184500.00 rows=1 width=64) (actual time=0.021..1420.350 ms)'' ปัญหานี้ควรแก้ไขอย่างไร?', 'หน้าประวัติคำสั่งซื้อของลูกค้าโหลดช้าผิดปกติ ใช้เวลามากกว่า 1.5 วินาทีต่อครั้ง', 'medium', 'multiple_choice', 'Seq Scan บนตารางขนาดใหญ่บ่งชี้ว่า Database ต้องกวาดอ่านทุกบล็อกในดิสก์เพราะไม่มี Index ตรงกับเงื่อนไขใน WHERE clause การสร้าง B-Tree Index บนคอลัมน์ที่ถูกค้นหาจะเปลี่ยนเป็น Index Scan และลดเวลาเหลือต่ำกว่า 5ms', '{sql,performance,index,explain}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('442a963b-7185-4a91-9925-5d292b0ec6cd', 'sql:03-indexes-performance:q02', 3, '0ec2fdf6-2627-408b-9791-35963b5fe97e', 'หากพบว่ามี Query ตัวหนึ่งทำงานค้างมานานกว่า 30 นาที และดึง CPU สูงจน Database ไม่ตอบสนอง คุณควรใช้คำสั่งใดใน PostgreSQL เพื่อตัดเซสชันและยกเลิกคำสั่งนั้นทันที?', 'เกิดเหตุการณ์ฉุกเฉินบนระบบ Production จำเป็นต้องหยุด Query อันตรายที่มี pid = 12450', 'medium', 'multiple_choice', 'SELECT pg_terminate_backend(pid) จะสั่งตัดการเชื่อมต่อ (terminate) ของเซสชันนั้นทันที ส่วน pg_cancel_backend จะพยายามส่งสัญญาณยกเลิกคำสั่งอย่างสุภาพแต่หาก Query ติด I/O หรือ Lock อาจไม่หยุด', '{sql,postgresql,kill-query,troubleshooting}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('264fa5d3-53b8-42c9-9879-5fe87517011a', 'troubleshooting:01-incident-triage-methodology:q01', 6, '11fc305a-c347-452a-8cbb-f81491cb8cae', 'เมื่อเกิดเหตุการณ์ระบบชำระเงินล่มทั้งระบบ (Sev 1 Critical Incident) เป้าหมายสูงสุดข้อแรกของทีม Incident Management คืออะไร?', 'ระบบตัดบัตรเครดิตล่มในวันแคมเปญ 11.11 ทำให้ลูกค้าสั่งซื้อไม่ได้', 'easy', 'multiple_choice', 'ตามมาตรฐาน ITIL และ SRE เป้าหมายอันดับหนึ่งของ Incident Management คือการกู้คืนระบบให้กลับมาให้บริการได้เร็วที่สุด (Restore Service / ลด MTTR) เช่น การ Rollback หรือ Failover ส่วนการหาสาเหตุที่แท้จริงจะทำในกระบวนการ Problem Management หลังจากระบบออนไลน์แล้ว', '{troubleshooting,itil,incident-management,sev1}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('d2bfba71-09f3-46d0-aacd-24c38ff4e835', 'docker:01-container-basics:q01', 5, 'cf0d4598-1c64-4a7f-b8c9-d6a18307a0f9', 'หากรันคำสั่ง docker ps แล้วไม่พบ Container ของฐานข้อมูล แต่เมื่อรัน docker ps -a กลับพบว่าสถานะคือ ''Exited (1) 2 minutes ago'' คุณควรทำขั้นตอนใดต่อไปเป็นอันดับแรก?', 'ระบบแจ้งเตือนว่าฐานข้อมูลดับลงและไม่สามารถเข้าใช้งานได้', 'easy', 'multiple_choice', 'เมื่อ Container อยู่ในสถานะ Exited บ่งบอกว่า Container ดับลง ขั้นตอนแรกที่ถูกต้องคือการดู Log ด้วย docker logs <container_name> เพื่อหาสาเหตุของ Error หรือ Panic ที่ทำให้โปรเซสดับ', '{docker,logs,troubleshooting}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('0fc16af1-29b0-41f4-af69-ba9e1cd8aa60', 'docker:01-container-basics:q02', 5, 'cf0d4598-1c64-4a7f-b8c9-d6a18307a0f9', 'คำสั่งใดใช้เปิด Interactive Shell เพื่อเข้าไปตรวจสอบไฟล์คอนฟิกและสภาพแวดล้อมภายใน Container ชื่อ api_gateway ที่กำลังรันอยู่?', 'คุณต้องการเข้าไปทดสอบรันคำสั่ง curl ภายใน Container ไปยัง Backend', 'easy', 'multiple_choice', 'docker exec -it <container_name> <command> โดย -i (interactive) และ -t (allocate pseudo-TTY) ร่วมกับคำสั่ง shell เช่น sh หรือ bash คือวิธีมาตรฐานในการเข้าไปใน Container', '{docker,exec,cli}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('32ec1200-c002-4d27-b0d8-89f96f2d05d5', 'troubleshooting:01-incident-triage-methodology:q02', 6, '11fc305a-c347-452a-8cbb-f81491cb8cae', 'ในการ Triage ปัญหาทางเทคนิค คำถามใดต่อไปนี้ถือเป็น ''คำถามทองคำ'' ที่มักนำไปสู่ต้นตอของปัญหาได้เร็วที่สุด?', 'ระบบที่เคยทำงานได้ตามปกติมาตลอด 6 เดือน จู่ๆ วันนี้เริ่มแสดงข้อผิดพลาด', 'easy', 'multiple_choice', 'ระบบคอมพิวเตอร์ที่เคยทำงานได้ปกติมักไม่พังขึ้นมาเองโดยไม่มีเหตุผล กว่า 80-90% ของ Incident เกิดจากการเปลี่ยนแปลง (Change) เช่น การดีพลอยโค้ดใหม่, แก้ไขคอนฟิก, เปลี่ยนใบรับรอง, หรืออัปเดตแพตช์ OS', '{troubleshooting,methodology,triage}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('9a165cbe-1a6d-41a7-994d-d7f2c50274c7', 'troubleshooting:02-root-cause-escalation:q01', 6, '782f94c6-acb3-408b-b091-a093bf7d0c40', 'ข้อมูลใดต่อไปนี้มีความจำเป็นและช่วยให้ทีมผู้พัฒนา (Developer) สามารถสืบสวนและแก้ไขปัญหาที่ส่งต่อมาได้อย่างรวดเร็วที่สุด?', 'ในฐานะ Tier 1 Support คุณกำลังเขียน Ticket ส่งต่อปัญหา (Escalation) ไปยังทีม Dev', 'easy', 'multiple_choice', 'Ticket ที่มีคุณภาพต้องระบุ Request/Response หรือ Error Log ที่ชัดเจน, Transaction/Order ID ที่เกิดปัญหา, เวลาที่เริ่มพบปัญหา และสิ่งที่ทีม Support ได้ทำการทดสอบคัดกรองไปแล้ว เพื่อที่ Dev จะได้ไม่ต้องเสียเวลาเริ่มต้นถามใหม่ตั้งแต่ศูนย์', '{troubleshooting,escalation,support-skills}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('cad3c17c-591e-452d-bc6f-28238eee28f1', 'troubleshooting:02-root-cause-escalation:q02', 6, '782f94c6-acb3-408b-b091-a093bf7d0c40', 'หัวใจหลักของแนวคิด ''Blameless Post-Mortem'' ในกระบวนการ RCA หลังเกิดระบบล่มคืออะไร?', 'การประชุมสรุปบทเรียนหลังจากเหตุการณ์ระบบล่มครั้งใหญ่', 'easy', 'multiple_choice', 'Blameless Post-Mortem เชื่อว่ามนุษย์ทุกคนมีโอกาสผิดพลาดได้ หัวใจสำคัญไม่ใช่การหาตัวคนผิดมาลงโทษ แต่เป็นการปรับปรุงกระบวนการและสร้างระบบป้องกันที่ทำให้ความผิดพลาดของมนุษย์ไม่สามารถพังระบบได้', '{troubleshooting,rca,blameless,culture}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('e6ac9105-39ae-46e1-85cb-1df0720cf127', 'web-api:01-http-status-codes:q01', 4, '8cd3f8e6-7571-47ca-bd5b-cd313f6179c6', 'ผู้ใช้งานเปิดหน้าเว็บแล้วพบข้อผิดพลาด ''502 Bad Gateway'' จาก Nginx ข้อใดคือสาเหตุที่เป็นไปได้มากที่สุด?', 'ระบบแจ้งเตือนว่าหน้าเว็บล่ม Nginx ส่ง 502 Bad Gateway กลับมายัง Client', 'medium', 'multiple_choice', '502 Bad Gateway เกิดจากตัว Reverse Proxy (Nginx) พยายามส่งต่อคำขอไปยัง Backend Upstream Service แต่ Backend ดับอยู่ ไม่ได้เปิดพอร์ต หรือแครช ทำให้เกิด Connection Refused', '{web,http,status-codes,502,nginx}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('5b92c358-a418-4117-a664-1c45579f5e01', 'web-api:01-http-status-codes:q02', 4, '8cd3f8e6-7571-47ca-bd5b-cd313f6179c6', 'ความแตกต่างระหว่างรหัส HTTP 401 Unauthorized และ 403 Forbidden คือข้อใด?', 'คำถามสัมภาษณ์งานตำแหน่ง Technical Support Engineer', 'easy', 'multiple_choice', '401 คือไม่พบข้อมูลยืนยันตัวตน (ยังไม่ได้ Login หรือ Token ผิด/หมดอายุ) ส่วน 403 คือระบบรู้จักตัวตนแล้วแต่ผู้ใช้นั้นไม่มีสิทธิ์ (No Permission) ในการเข้าถึงทรัพยากรนั้น', '{web,http,auth,interview}', true, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.questions VALUES ('327a3f1f-ee09-4088-b3ec-5b8dc48e5c8c', 'network:01-ip-subnetting:q05', 2, 'd8929572-6865-40b4-bf65-a32bfcdb15a5', 'กำหนดให้ IP Address คือ 192.168.1.130/26 จงหา Network ID และ Broadcast IP ของ Subnet นี้?', 'ข้อสอบคำนวณ Subnetting ภาคปฏิบัติในการคัดเลือก Junior Network Engineer', 'hard', 'multiple_choice', '/26 มี Subnet Mask คือ 255.255.255.192 ขนาด Block Size = 256 - 192 = 64 ช่วงของ Subnet คือ: 0-63, 64-127, 128-191, 192-255 ตัวเลข .130 ตกอยู่ในช่วง 128-191 ดังนั้น Network ID คือ 192.168.1.128 และ Broadcast IP คือ 192.168.1.191 (Host ใช้งานได้คือ .129 ถึง .190)', '{network,subnetting,cidr,calculation}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('38803ea5-5df5-408e-b93f-89f392bbb11f', 'network:01-ip-subnetting:q06', 2, 'd8929572-6865-40b4-bf65-a32bfcdb15a5', 'ต้องการจัดสรร Subnet ให้กับแผนกหนึ่งที่มีเครื่องคอมพิวเตอร์และเซิร์ฟเวอร์รวม 28 เครื่อง ควรเลือก Subnet Mask ขนาดใดที่ประหยัด IP ที่สุดและเพียงพอต่อการใช้งาน?', 'การวางแผน Subnet ในการขยายสาขาใหม่ของบริษัท', 'medium', 'multiple_choice', 'ต้องการ 28 เครื่อง ต้องหา 2^n - 2 >= 28 ถ้า n=4 (2^4-2 = 14) ไม่พอ ถ้า n=5 (2^5-2 = 30 เครื่อง) เพียงพอ ดังนั้น Host bit = 5 บิต และ Prefix length = 32 - 5 = /27 (Mask 255.255.255.224)', '{network,subnetting,cidr,calculation}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('e75e4f1e-eac7-4c46-bc80-4535f39071c8', 'network:05-osi:q01', 2, '6b461aa2-fd34-427d-8b52-fe4455276c56', 'ผู้ใช้งานแจ้งว่าเข้าเว็บ https://portal.internal ไม่ได้ ช่างตรวจสอบพบว่า ''ping 192.168.10.1 (Gateway)'' ติด และ ''ping 8.8.8.8'' ติด แต่ ''ping portal.internal'' แจ้งว่า ''Name or service not known'' ปัญหาน่าจะเกิดที่ชั้นใดในโมเดล OSI?', 'ช่างกำลังใช้วิธี Divide-and-Conquer ไล่ตรวจสอบการเชื่อมต่ออินเทอร์เน็ตของเครื่องลูกข่าย', 'medium', 'multiple_choice', 'การที่ ping IP ทั้งภายในและภายนอกติด แสดงว่า Layer 1 (Physical), Layer 2 (Data Link) และ Layer 3 (Network Routing) ทำงานสมบูรณ์ แต่แปลงชื่อโดเมนไม่ได้เกิดจาก DNS ซึ่งเป็นโปรโตคอลที่ทำงานใน Layer 7 (Application Layer)', '{network,osi,dns,troubleshooting}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('6e981c68-db2f-4533-9f5d-8a923e156a67', 'network:05-osi:q02', 2, '6b461aa2-fd34-427d-8b52-fe4455276c56', 'หน่วยข้อมูล (PDU: Protocol Data Unit) ใน Layer 2 (Data Link) และ Layer 3 (Network) มีชื่อเรียกตามลำดับว่าอย่างไร?', 'คำถามสัมภาษณ์พื้นฐานสำหรับตำแหน่ง Junior Network Engineer', 'easy', 'multiple_choice', 'ใน Layer 2 ข้อมูลที่มีการหุ้ม MAC Header เรียกว่า ''Frame'' ส่วนใน Layer 3 ที่มี IP Header เรียกว่า ''Packet'' (และใน Layer 4 TCP เรียกว่า Segment)', '{network,osi,pdu,fundamentals}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('d1fd2b23-0add-4fd1-95ea-8e56dc91c7cb', 'network:05-osi:q03', 2, '6b461aa2-fd34-427d-8b52-fe4455276c56', 'เมื่อสั่ง ''nc -zvw3 10.0.1.50 3306'' แล้วระบบแจ้งกลับมาว่า ''Connection timed out'' แต่ ''ping 10.0.1.50'' มีการตอบกลับปกติ อาการนี้ชี้ชัดที่สุดว่าปัญหาอยู่ที่ชั้นใด?', 'Application Support กำลังทดสอบเชื่อมต่อไปยังฐานข้อมูล MySQL บนอีกเครื่องหนึ่ง', 'medium', 'multiple_choice', 'การที่ ping (ICMP) ติด แสดงว่า Layer 1-3 สมบูรณ์ แต่พอร์ต 3306 เกิด Timeout หมายถึงแพ็กเก็ต TCP ถูกทิ้งเงียบๆ โดย Firewall หรือ Security Group ซึ่งกรองข้อมูลที่ Layer 4 (Transport Layer)', '{network,osi,transport,firewall,nc}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('ce1f94cc-3909-4aa0-baf9-6db3001a8836', 'network:05-osi:q04', 2, '6b461aa2-fd34-427d-8b52-fe4455276c56', 'อุปกรณ์ Switch Layer 2 และ Router ทำงานที่ชั้นใดของโมเดล OSI ตามลำดับ?', 'ความรู้เรื่องอุปกรณ์เครือข่ายพื้นฐาน', 'easy', 'multiple_choice', 'Switch ทั่วไป (Layer 2) ส่งข้อมูลโดยอ้างอิง MAC Address ซึ่งอยู่ใน Data Link Layer ส่วน Router ส่งข้อมูลโดยอ้างอิง IP Address ซึ่งอยู่ใน Network Layer (Layer 3)', '{network,osi,hardware,switch,router}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('811e4d06-268a-48ee-8694-c9d2e24494bf', 'network:05-osi:q05', 2, '6b461aa2-fd34-427d-8b52-fe4455276c56', 'แนวทางการแก้ปัญหาแบบ ''Bottom-Up Approach'' เหมาะสมที่สุดในสถานการณ์ใด?', 'การเลือกระเบียบวิธีวิเคราะห์ปัญหาในการปฏิบัติงานจริง', 'medium', 'multiple_choice', 'วิธี Bottom-Up เริ่มตรวจตั้งแต่สายสัญญาณ ฮาร์ดแวร์ พอร์ต ไปจนถึงคอนฟิก จึงเหมาะสมที่สุดเมื่อมีการติดตั้งเครื่องใหม่ ย้ายตู้แร็ค หรือเพิ่งเดินสายสัญญาณใหม่', '{network,osi,methodology,troubleshooting}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('d5a6607b-d2ab-4160-b0f5-bf5a8e021c1d', 'network:06-vlan:q01', 2, 'd297f4f2-4aec-41db-b324-a8e4ae10ea05', 'เครื่อง Server A (IP 192.168.10.5) เสียบเข้าพอร์ต Gi0/1 (VLAN 10) และเครื่อง Server B (IP 192.168.20.5) เสียบเข้าพอร์ต Gi0/2 (VLAN 20) บน Switch ตัวเดียวกัน ทั้งสองเครื่องไม่สามารถ ping หากันได้เพราะสาเหตุใด?', 'ช่างเทคนิคเสียบเซิร์ฟเวอร์สองตัวเข้าที่สวิตช์ตัวเดียวกัน แล้วสงสัยว่าทำไมปิงไม่ติด', 'medium', 'multiple_choice', 'เครื่องที่อยู่คนละ VLAN จะถูกแยก Broadcast Domain ออกจากกันอย่างเด็ดขาดที่ Layer 2 แม้จะอยู่บนสวิตช์ฮาร์ดแวร์ตัวเดียวกัน หากต้องการสื่อสารข้าม VLAN จะต้องมีอุปกรณ์ Layer 3 (Router หรือ L3 Switch) ทำหน้าที่ Inter-VLAN Routing', '{network,vlan,switching,routing}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('7c3302c8-0a22-43e9-ab9a-6f3e9cb1b549', 'network:06-vlan:q02', 2, 'd297f4f2-4aec-41db-b324-a8e4ae10ea05', 'มาตรฐานสากลที่ใช้ในการแปะหัว Tag ขนาด 4 bytes ลงใน Ethernet Frame เพื่อระบุหมายเลข VLAN บนพอร์ต Trunk คือมาตรฐานใด?', 'คำถามมาตรฐานในข้อสอบ Network Certification', 'easy', 'multiple_choice', 'IEEE 802.1Q (หรือเรียกสั้นๆ ว่า Dot1q) คือมาตรฐานสากลสำหรับการทำ VLAN Tagging บนพอร์ต Trunk', '{network,vlan,standards,trunk}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('7d3ba65b-d6e0-4272-be9d-2132dc332262', 'network:06-vlan:q03', 2, 'd297f4f2-4aec-41db-b324-a8e4ae10ea05', 'เมื่อมีเฟรมที่ ''ไม่มี Tag'' (Untagged Frame) วิ่งเข้ามาที่พอร์ต Trunk สวิตช์จะจัดการกับเฟรมนั้นอย่างไร?', 'การทำความเข้าใจหลักการ Native VLAN บนพอร์ต Trunk', 'medium', 'multiple_choice', 'พอร์ต Trunk จะส่งต่อเฟรมที่ไม่มี Tag ไปยัง ''Native VLAN'' (ซึ่งค่าเริ่มต้นบนสวิตช์มักเป็น VLAN 1)', '{network,vlan,trunk,native-vlan}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('a3d59ff8-03bc-4ee8-a561-93a6feb5cf8e', 'network:07-dhcp:q01', 2, '11100691-a71e-441a-abe3-ba9a1d4ba021', 'ขั้นตอน 4 สเต็ปในการขอรับ IP Address จาก DHCP Server เรียงตามลำดับอย่างถูกต้องตามข้อใด?', 'คำถามพื้นฐานเรื่อง DORA Process ในการสอบสัมภาษณ์สายไอทีซัพพอร์ตและเน็ตเวิร์ก', 'easy', 'multiple_choice', 'ขั้นตอนของ DHCP คือ Discover (ส่งหา) -> Offer (เสนอไอพี) -> Request (ขอยืนยัน) -> Acknowledge (ตอบรับสัญญาสุดท้าย) เรียกย่อว่า D-O-R-A', '{network,dhcp,dora,protocols}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('a4d3b42b-b063-43a3-b338-578b87fae333', 'network:07-dhcp:q02', 2, '11100691-a71e-441a-abe3-ba9a1d4ba021', 'หากเครื่องคอมพิวเตอร์ที่ตั้งค่าให้รับ IP อัตโนมัติ ได้หมายเลขไอพีเป็น ''169.254.120.45'' และ Subnet Mask ''255.255.0.0'' อาการนี้บ่งบอกถึงสิ่งใดอย่างชัดเจนที่สุด?', 'ผู้ใช้งานแจ้งว่าเปิดเครื่องขึ้นมาแล้วเข้าอินเทอร์เน็ตไม่ได้ ช่างสั่ง ipconfig พบไอพีดังกล่าว', 'easy', 'multiple_choice', 'ไอพีในย่าน 169.254.0.0/16 คือ APIPA ซึ่งระบบปฏิบัติการจะกำหนดขึ้นมาเองโดยอัตโนมัติเมื่อเครื่องไม่สามารถติดต่อขอรับ IP จาก DHCP Server ได้สำเร็จ', '{network,dhcp,apipa,troubleshooting}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('79645a39-48ce-4bfd-b6f6-b8809dfba87c', 'network:07-dhcp:q03', 2, '11100691-a71e-441a-abe3-ba9a1d4ba021', 'หากเครื่องลูกข่ายอยู่ใน VLAN 10 แต่เครื่อง DHCP Server ตั้งอยู่ใน Server Farm VLAN 100 ข้ามเราเตอร์ ช่างเทคนิคต้องเปิดใช้งานฟังก์ชันใดบน Interface ของ Router เพื่อให้เครื่องลูกข่ายขอไอพีได้?', 'การออกแบบเครือข่ายองค์กรที่มีการรวมศูนย์ DHCP Server ไว้ที่ Data Center', 'medium', 'multiple_choice', 'เนื่องจาก DHCP Discover เป็น Broadcast ซึ่งวิ่งข้าม Router ไม่ได้ จึงต้องเปิดฟังก์ชัน DHCP Relay Agent (บน Cisco คือคำสั่ง ''ip helper-address <IP>'') เพื่อแปลง Broadcast เป็น Unicast ส่งไปยัง DHCP Server ข้ามวง', '{network,dhcp,dhcp-relay,cisco}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('c81e6aa9-e017-4ee8-bd8a-f170ba5d2e30', 'network:07-dhcp:q04', 2, '11100691-a71e-441a-abe3-ba9a1d4ba021', 'เทคโนโลยีการแปลงแอดเดรสแบบใดที่ช่วยให้อุปกรณ์หลายร้อยเครื่องที่ถือ Private IP สามารถออกสู่อินเทอร์เน็ตได้พร้อมกันผ่าน Public IP จริงเพียงเบอร์เดียว โดยอาศัยการจำแนกด้วยหมายเลขพอร์ต?', 'การทำความเข้าใจความแตกต่างของเทคโนโลยี NAT ประเภทต่างๆ', 'medium', 'multiple_choice', 'PAT (Port Address Translation) หรือที่นิยมเรียกว่า NAT Overload เป็นวิธีที่แมป Private IP จำนวนมากเข้ากับ Public IP เดียวโดยใช้ Port Number ในการแยกเซสชัน', '{network,nat,pat,firewall}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('49da2415-c6d1-440c-b962-0d129a95f694', 'network:07-dhcp:q05', 2, '11100691-a71e-441a-abe3-ba9a1d4ba021', 'เซิร์ฟเวอร์เปิดเว็บในระบบคลาวด์มี Private IP เป็น 10.0.1.10 ต้องการให้ลูกค้าภายนอกสามารถเข้าชมเว็บไซต์ผ่าน Public IP 203.0.113.88 พอร์ต 443 ได้ จะต้องตั้งค่าการแปลงแอดเดรสแบบใด?', 'การตั้งค่าเผยแพร่เว็บเซิร์ฟเวอร์หลังบ้านออกสู่อินเทอร์เน็ต', 'medium', 'multiple_choice', 'การอนุญาตให้ภายนอกยิงเข้ามาหาบริการภายในที่ระบุแน่นอน ต้องใช้ Static NAT (1-to-1) หรือ Port Forwarding (Destination NAT) จาก Public IP:Port มายัง Private IP:Port', '{network,nat,port-forwarding,cloud}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('078a7bed-80ff-486c-8dee-ef31175e5ef5', 'network:08-cli:q01', 2, 'c349c769-a0a4-4287-a5dd-73daeaa0f3a8', 'ในผลลัพธ์ของคำสั่ง ''show ip interface brief'' บน Cisco Switch หากพอร์ตแสดงสถานะเป็น ''administratively down / down'' มีความหมายว่าอย่างไร?', 'การวิเคราะห์สถานะพอร์ตสวิตช์ของช่างเทคนิคศูนย์ข้อมูล', 'easy', 'multiple_choice', 'สถานะ ''administratively down'' หมายถึงพอร์ตนั้นถูกแอดมินสั่งปิดใช้งานด้วยคำสั่ง ''shutdown'' ด้วยตนเอง หากต้องการให้พอร์ตกลับมาทำงานต้องสั่ง ''no shutdown'' ในโหมด interface configuration', '{network,cisco,cli,show-commands}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('52df195e-483c-4a2b-a982-463827ca7fbd', 'network:08-cli:q02', 2, 'c349c769-a0a4-4287-a5dd-73daeaa0f3a8', 'เมื่อสั่ง ''show interfaces GigabitEthernet0/1'' บนสวิตช์ แล้วพบว่าค่า ''CRC errors'' เพิ่มขึ้นอย่างต่อเนื่องตลอดเวลา ปัญหาน่าจะเกิดจากสิ่งใดมากที่สุด?', 'ผู้ใช้งานแจ้งว่าการโอนไฟล์ขนาดใหญ่ไปยังเซิร์ฟเวอร์ช้าผิดปกติและหลุดบ่อยครั้ง', 'medium', 'multiple_choice', 'CRC (Cyclic Redundancy Check) Errors เกิดจากเฟรมที่ส่งมาเกิดความเสียหายระหว่างทาง สาเหตุหลักมักมาจากสายสัญญาณมีสัญญาณรบกวน (Noise/EMI), หัวต่อ RJ45 หรือ Fiber เข้าหัวไม่ดี, หรือความยาวสายเกินมาตรฐาน 100 เมตร', '{network,cisco,troubleshooting,layer1,crc}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('69303d68-e689-49b4-9c70-5faa75c07553', 'network:08-cli:q03', 2, 'c349c769-a0a4-4287-a5dd-73daeaa0f3a8', 'หากต้องการตรวจสอบว่าพอร์ตใดถูกกำหนดให้อยู่ใน VLAN ใดบ้างอย่างรวดเร็วบน Cisco Switch ควรใช้คำสั่งใด?', 'การตรวจสอบคอนฟิกพอร์ตของทีมซัพพอร์ต', 'easy', 'multiple_choice', 'คำสั่ง ''show vlan brief'' จะสรุปรายการ VLAN ทั้งหมด พร้อมรายชื่อพอร์ตที่เป็น Access Port ของแต่ละ VLAN ให้เห็นในหน้าเดียวอย่างชัดเจน', '{network,cisco,vlan,cli}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('8d7e57ad-f961-4347-ad2d-199066471909', 'network:08-cli:q04', 2, 'c349c769-a0a4-4287-a5dd-73daeaa0f3a8', 'ในการเชื่อมต่อคอมพิวเตอร์เข้ากับพอร์ต Console ของอุปกรณ์เครือข่ายด้วยโปรแกรม PuTTY ค่า Baud Rate (Speed) มาตรฐานสากลที่ต้องตั้งคือเท่าใด?', 'การเข้าจัดการอุปกรณ์ Network ผ่านสาย Console ประจำศูนย์ข้อมูล', 'easy', 'multiple_choice', 'ค่าความเร็วการสื่อสารแบบ Serial Console ของอุปกรณ์ Cisco และอุปกรณ์เครือข่ายส่วนใหญ่ตามมาตรฐานคือ 9600 bps (8 data bits, no parity, 1 stop bit)', '{network,console,cisco,hardware}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('0248a868-1d00-463b-8b08-6f3f8cf82efb', 'network:08-cli:q05', 2, 'c349c769-a0a4-4287-a5dd-73daeaa0f3a8', 'ในตาราง Routing Table ของคำสั่ง ''show ip route'' สัญลักษณ์ตัวอักษร ''C'' และ ''S*'' หมายถึงเส้นทางประเภทใดตามลำดับ?', 'การอ่านผลลัพธ์ตาราง Routing บนเราเตอร์', 'medium', 'multiple_choice', '''C'' ย่อมาจาก Connected (เครือข่ายที่เชื่อมต่ออยู่กับขา Interface ของเราเตอร์โดยตรง) ส่วน ''S*'' หมายถึง Static Route ที่เป็น Default Route (Gateway of last resort)', '{network,routing,cisco,show-ip-route}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('29a4fa57-6dd7-4b04-9a94-3f64ef1ea7ab', 'network:09-l1l2:q01', 2, 'ff620473-be72-44d1-bbee-3112ba85188d', 'ปัญหา ''Duplex Mismatch'' ระหว่างสองอุปกรณ์ (ฝั่งหนึ่งเป็น Full-Duplex อีกฝั่งเป็น Half-Duplex) จะส่งผลกระทบและแสดงอาการแบบใดที่ชัดเจนที่สุดในระบบเครือข่าย?', 'ผู้ใช้งานแจ้งว่าการทดสอบปิงขนาดเล็ก (ping) ผ่านปกติ แต่เมื่อเริ่มดาวน์โหลดหรืออัปโหลดไฟล์ขนาดใหญ่ ความเร็วจะตกต่ำมากและมี Packet Loss สูง', 'medium', 'multiple_choice', 'เมื่อ Traffic น้อย ปัญหาจะไม่ชัดเจน แต่เมื่อเริ่มมีข้อมูลวิ่งเยอะ ฝั่ง Half-duplex จะมองว่ามีการส่งสวนทางจึงนึกว่าเกิด Collision แล้วส่ง Jam signal สั่งหยุดส่ง ทำให้เกิด Late Collisions และ Packet Loss มหาศาล', '{network,duplex,layer1,troubleshooting,collisions}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('48a688b6-b7e4-4d4f-8164-32df8b03b281', 'network:09-l1l2:q02', 2, 'ff620473-be72-44d1-bbee-3112ba85188d', 'อะไรคือสาเหตุหลักที่ทำให้เกิด ''Broadcast Storm'' บนเครือข่าย Layer 2 และเหตุใดมันจึงไม่หยุดวนเวียนจนกระทั่งเน็ตเวิร์กล่ม?', 'จู่ๆ สวิตช์ทั้งออฟฟิศไฟกะพริบถี่พร้อมกัน และผู้ใช้ทุกคนหลุดจากเครือข่ายทั้งหมด', 'medium', 'multiple_choice', 'เกิดจากมี Loop ในสายเชื่อมต่อของ Switch และเนื่องจาก Ethernet Frame ใน Layer 2 ''ไม่มีฟิลด์ TTL (Time-to-Live)'' เฟรมบรอดคาสต์จึงถูกส่งกระจายวนเวียนซ้ำไปมาอย่างไม่มีที่สิ้นสุดจนแบนด์วิดท์และ CPU เต็ม', '{network,broadcast-storm,stp,switching-loop}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('6742174c-264e-4fba-a6da-56b09a01ac39', 'network:09-l1l2:q03', 2, 'ff620473-be72-44d1-bbee-3112ba85188d', 'โปรโตคอลใดทำหน้าที่ป้องกันการเกิด Switching Loop ในระบบเครือข่าย Ethernet สวิตช์?', 'ความรู้เรื่องโปรโตคอลมาตรฐานของ Switch', 'easy', 'multiple_choice', 'STP (Spanning Tree Protocol - IEEE 802.1D / 802.1w RSTP) ทำหน้าที่ตรวจจับและบล็อกพอร์ตที่เป็นเส้นทางสำรองเพื่อป้องกันไม่ให้เกิด Loop', '{network,stp,switching,loop-prevention}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('1e185f85-4700-463f-a971-4c02526fc962', 'network:09-l1l2:q04', 2, 'ff620473-be72-44d1-bbee-3112ba85188d', 'ฟีเจอร์ความปลอดภัย ''BPDU Guard'' บน Cisco Switch มีหน้าที่สำคัญอย่างไรเมื่อใช้งานคู่กับพอร์ตที่เปิด PortFast?', 'การตั้งค่าความปลอดภัยของพอร์ตที่เชื่อมต่อเครื่องลูกข่ายหรือเซิร์ฟเวอร์', 'medium', 'multiple_choice', 'หากมีใครนำ Switch ตัวอื่นมาเสียบเข้าพอร์ตที่เปิด PortFast สวิตช์จะได้รับแพ็กเก็ต BPDU ซึ่ง BPDU Guard จะสั่งปิดพอร์ตนั้นทันที (เข้าสู่สถานะ err-disabled) เพื่อป้องกันไม่ให้เกิด Switching Loop หรือแย่งชิงสิทธิ์ Root Bridge', '{network,cisco,stp,bpdu-guard,portfast}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('34d76a3b-7fb2-4a41-b949-84b1bbd4537d', 'network:09-l1l2:q05', 2, 'ff620473-be72-44d1-bbee-3112ba85188d', 'หากต้องการรวมสายสัญญาณ Gigabit Ethernet 2 เส้นระหว่าง Server กับ Switch เพื่อเพิ่ม Bandwidth และทำ Redundancy สำรองสาย ต้องใช้โปรโตคอลมาตรฐานสากลใด?', 'การตั้งค่า Network Teaming / Bonding ของเซิร์ฟเวอร์ในศูนย์ข้อมูล', 'easy', 'multiple_choice', 'LACP (Link Aggregation Control Protocol ตามมาตรฐาน IEEE 802.3ad) คือโปรโตคอลมาตรฐานสากลสำหรับการเจรจารวมพอร์ตทางกายภาพเข้าเป็น Port-Channel หรือ Bond เดียวกัน', '{network,lacp,bonding,link-aggregation}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('eed83e79-382d-4cd4-b70c-a794fdc8d5be', 'network:10-pcap:q01', 2, '7c93ea29-3948-44d5-a0bb-77f87d3fedcd', 'ในการใช้งานคำสั่ง tcpdump บนเซิร์ฟเวอร์ Linux เหตุใดจึงแนะนำอย่างยิ่งให้ใส่แฟล็ก ''-nn'' ร่วมด้วยเสมอ?', 'การใช้งานคำสั่งดักจับแพ็กเก็ตอย่างปลอดภัยและมีประสิทธิภาพ', 'easy', 'multiple_choice', 'แฟล็ก -nn สั่งให้ tcpdump ไม่ต้องพยายามแปลง IP Address เป็น Hostname และไม่ต้องแปลง Port เป็นชื่อบริการ ซึ่งช่วยป้องกันไม่ให้ระบบส่ง DNS Query เพิ่มเติมจนทำให้ผลลัพธ์ช้าหรือหน้าจอค้าง', '{network,tcpdump,cli,packet-capture}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('4179d86f-e2c7-4331-a1f3-c90aae750b83', 'network:10-pcap:q02', 2, '7c93ea29-3948-44d5-a0bb-77f87d3fedcd', 'ในผลลัพธ์ของ tcpdump หากเห็นเครื่องต้นทางส่งแพ็กเก็ตที่มี ''Flags [S]'' ออกไปซ้ำๆ แต่ไม่มีแพ็กเก็ตใดตอบกลับมาเลย พฤติกรรมนี้บ่งบอกถึงสาเหตุใดมากที่สุด?', 'ช่างเทคนิคกำลังตรวจสอบว่าทำไมระบบ Web Application จึงเชื่อมต่อไปยังหลังบ้านไม่ได้', 'medium', 'multiple_choice', 'Flags [S] คือการส่ง SYN เพื่อขอเริ่มทำ 3-Way Handshake หากส่งซ้ำๆ (SYN Retransmission) โดยไม่มี SYN-ACK หรือ RST ตอบกลับมาเลย แสดงว่าแพ็กเก็ตถูกทิ้งเงียบๆ (Drop/Timeout) โดย Firewall หรือเครื่องปลายทางล่มสนิท', '{network,tcp,tcpdump,handshake,firewall}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('d3078369-34bc-435c-a843-0aa4c32c9797', 'network:10-pcap:q03', 2, '7c93ea29-3948-44d5-a0bb-77f87d3fedcd', 'หากเครื่องต้นทางส่งแพ็กเก็ต ''Flags [S]'' (SYN) ออกไป แล้วได้รับแพ็กเก็ตที่มี ''Flags [R]'' (RST / Reset) ตอบกลับมาในทันที ข้อสรุปใดถูกต้องที่สุด?', 'การแยกแยะอาการระหว่าง Connection Timed Out กับ Connection Refused ด้วย Packet Capture', 'medium', 'multiple_choice', 'การได้รับ RST กลับมาแสดงว่าเส้นทางเครือข่ายและ Firewall ปล่อยให้แพ็กเก็ตผ่านไปถึงเครื่องปลายทางเรียบร้อยแล้ว แต่ที่เครื่องปลายทางไม่มีแอปพลิเคชันเปิดดักฟัง (Listen) อยู่ที่พอร์ตนั้น OS จึงปฏิเสธการเชื่อมต่อกลับมา', '{network,tcp,tcp-flags,reset,troubleshooting}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('caf4b43f-815a-4731-afe7-e459846dc1fe', 'network:10-pcap:q04', 2, '7c93ea29-3948-44d5-a0bb-77f87d3fedcd', 'คำสั่ง tcpdump ในข้อใดถูกต้องในการดักจับแพ็กเก็ตบนการ์ดแลน eth0 เฉพาะพอร์ต 443 จำนวน 50 แพ็กเก็ต แล้วบันทึกลงไฟล์ชื่อ /tmp/ssl_test.pcap โดยไม่ Resolve ชื่อ?', 'การดึงหลักฐานเพื่อนำไปวิเคราะห์ปัญหา SSL Handshake บน Wireshark', 'easy', 'multiple_choice', 'ไวยากรณ์ที่ถูกต้องคือ tcpdump -nn -i eth0 port 443 -c 50 -w /tmp/ssl_test.pcap', '{network,tcpdump,cli,pcap}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('70b5a05d-a58c-4b52-8750-07b0d905cae1', 'network:10-pcap:q05', 2, '7c93ea29-3948-44d5-a0bb-77f87d3fedcd', 'ในโปรแกรม Wireshark หากต้องการวิเคราะห์ข้อความหรือข้อมูลดิบที่แอปพลิเคชันคุยกันในเซสชัน TCP ตั้งแต่เริ่มจนจบการเชื่อมต่ออย่างต่อเนื่อง ควรใช้ฟีเจอร์ใด?', 'การแกะดูเนื้อหาคำสั่ง HTTP หรือข้อความที่มีปัญหาใน Wireshark', 'easy', 'multiple_choice', 'การคลิกขวาที่แพ็กเก็ตแล้วเลือก ''Follow -> TCP Stream'' จะช่วยให้ Wireshark รวม Segment ทั้งหมดมารวบเป็นบทสนทนาแบบอ่านง่าย (เช่น ข้อความ HTTP Request และ Response ทั้งหมด)', '{network,wireshark,tcp-stream,packet-analysis}', true, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.questions VALUES ('a98c2c8e-00de-4244-837b-4ba6540ceb62', 'datacenter:06-raid:q01', 10, '75403d93-f9e9-4644-9d96-62d933af29b7', 'เซิร์ฟเวอร์ฐานข้อมูลมีฮาร์ดดิสก์ขนาดลูกละ 2 TB จำนวน 6 ลูก หากตั้งค่าเป็น RAID 6 และ RAID 10 จะได้พื้นที่ใช้งานจริง (Usable Capacity) เท่าใดตามลำดับ?', 'การคำนวณพื้นที่จัดเก็บข้อมูลก่อนจัดเตรียมเซิร์ฟเวอร์ให้ทีม Database', 'medium', 'multiple_choice', 'RAID 6 หักดิสก์ทำ Dual Parity 2 ลูก เหลือ (6 - 2) * 2 TB = 8 TB ส่วน RAID 10 หักครึ่งหนึ่งทำ Mirror เหลือ (6 / 2) * 2 TB = 6 TB', '{datacenter,raid,storage,calculation}', true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.questions VALUES ('a49c6a82-b2f6-4f5a-bcf4-870770ee3d9b', 'datacenter:06-raid:q02', 10, '75403d93-f9e9-4644-9d96-62d933af29b7', 'เมื่อโวลุ่ม RAID 5 (มีดิสก์ 4 ลูก) เกิดดิสก์เสียไป 1 ลูก สถานะของ RAID จะเปลี่ยนเป็น "Degraded" หากช่างเผลอดึงดิสก์ลูกที่ยังดีอยู่ออกมาผิดลูกในขณะนั้น จะเกิดอะไรขึ้น?', 'ความเสี่ยงสูงสุดในการเปลี่ยนดิสก์แบบ Hot-Swap หน้าตู้แร็ค', 'easy', 'multiple_choice', 'RAID 5 ทนดิสก์เสียได้เพียง 1 ลูกเท่านั้น หากดิสก์ลูกที่สองหลุดออกพร้อมกัน โวลุ่ม RAID จะล่ม (Failed/Offline) ทันที ทำให้ระบบล่มและข้อมูลเสียหาย', '{datacenter,raid,hotswap,incident}', true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.questions VALUES ('af06e4f6-6e32-44a7-af4b-e131ce5c199f', 'datacenter:06-raid:q03', 10, '75403d93-f9e9-4644-9d96-62d933af29b7', 'ไฟสถานะ LED สีน้ำเงินกะพริบ (Blinking Blue) บนถาดดิสก์หน้าเครื่องเซิร์ฟเวอร์มีความหมายว่าอย่างไร?', 'การปฏิบัติงานเปลี่ยนดิสก์ร่วมกันระหว่างทีม NOC และช่างประจำห้อง Data Hall', 'easy', 'multiple_choice', 'ไฟสีน้ำเงินคือ Locator / UID LED ที่แอดมินสั่งเปิดผ่าน iDRAC/iLO เพื่อชี้ตำแหน่งดิสก์ลูกที่ต้องการให้ช่างหน้างานเห็นอย่างชัดเจน ป้องกันการถอดดิสก์ผิดลูก', '{datacenter,hardware,led,hotswap}', true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.questions VALUES ('9f4e6bb4-4c0d-4f17-b5f9-a5d1eb4768ec', 'datacenter:06-raid:q04', 10, '75403d93-f9e9-4644-9d96-62d933af29b7', 'ในการติดตั้งระบบ Software-Defined Storage เช่น ZFS หรือ Ceph เหตุใดวิศวกรจึงต้องตั้งค่าการ์ดควบคุมดิสก์ให้อยู่ในโหมด "HBA Mode (IT Mode / Passthrough)" แทนการใช้ Hardware RAID?', 'การตั้งค่า BIOS/Storage Controller ก่อนส่งมอบเครื่องให้ทีม Infrastructure', 'medium', 'multiple_choice', 'ระบบอย่าง ZFS และ Ceph ต้องการเข้าถึงและควบคุมดิสก์แต่ละลูกโดยตรง (เห็นดิสก์แยกกันทุกใบและอ่านค่า SMART ได้โดยตรง) เพื่อจัดการการทำสำเนาและตรวจจับข้อมูลเพี้ยน (Bit rot) ด้วยซอฟต์แวร์เอง', '{datacenter,storage,hba,zfs,ceph}', true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.questions VALUES ('d6d47579-3742-448d-ab63-850146c740bd', 'datacenter:06-raid:q05', 10, '75403d93-f9e9-4644-9d96-62d933af29b7', 'เมื่อตรวจสอบสุขภาพดิสก์บน Linux ด้วยคำสั่ง "smartctl -a /dev/sda" หากพบว่าค่า "Reallocated_Sector_Ct" และ "Current_Pending_Sector" เพิ่มสูงขึ้นอย่างต่อเนื่อง หมายความว่าอย่างไร?', 'การวิเคราะห์ปัญหาดิสก์อ่านข้อมูลช้าและเกิด I/O error ในระบบ', 'medium', 'multiple_choice', 'ค่าทั้งสองบ่งชี้ว่าพื้นผิวของฮาร์ดดิสก์เริ่มเกิด Bad Sector และมีเซกเตอร์ที่อ่านข้อมูลไม่ออก เป็นสัญญาณเตือนล่วงหน้า (Predictive Failure) ว่าดิสก์กำลังจะเสีย ควรเตรียมเปลี่ยนดิสก์ทันที', '{datacenter,smartctl,linux,storage,troubleshooting}', true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.questions VALUES ('4cd3080a-83c4-4ea4-99f0-b166c7c3d551', 'datacenter:07-sel:q01', 10, 'c64810d8-bf76-49f4-aadd-3cd45d92d14b', 'ความแตกต่างที่สำคัญที่สุดระหว่าง "Correctable ECC Memory Error (CE)" กับ "Uncorrectable ECC Memory Error (UCE)" คือข้อใด?', 'การประเมินความเร่งด่วนเมื่อระบบ Monitoring แจ้งเตือนปัญหาหน่วยความจำบนเซิร์ฟเวอร์', 'medium', 'multiple_choice', 'Correctable Error (Single-bit) ชิป ECC สามารถแก้ไขบิตที่เพี้ยนให้อัตโนมัติโดยเครื่องไม่ดับ ส่วน Uncorrectable Error (Multi-bit) เกินขีดความสามารถในการซ่อมแซม ส่งผลให้ระบบเกิด Kernel Panic หรือรีบูตทันทีเพื่อปกป้องข้อมูล', '{datacenter,memory,ecc,hardware,troubleshooting}', true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.questions VALUES ('8b74d788-98ec-4a05-8a4b-d7301a0ec4b2', 'datacenter:07-sel:q02', 10, 'c64810d8-bf76-49f4-aadd-3cd45d92d14b', 'เมื่อเซิร์ฟเวอร์แจ้งเตือน Memory Error ที่ช่อง "DIMM_A1" ช่างเทคนิคจึงถอดแรมจากช่อง DIMM_A1 ไปสลับใส่ช่อง DIMM_B1 แล้วเปิดเครื่องใหม่ ปรากฏว่าข้อผิดพลาดย้ายตามไปฟ้องที่ "DIMM_B1" ข้อสรุปใดถูกต้อง?', 'การใช้เทคนิค Swap Test เพื่อแยกแยะชิ้นส่วนที่เสียก่อนเปิดเคสเคลมประกัน (RMA)', 'easy', 'multiple_choice', 'เมื่อสลับแรมแล้วอาการเสียย้ายตามตัวแรมไปยังช่องใหม่ แปลว่าตัวแผงการ์ด RAM แถวนั้นเสียแน่นอน ไม่ใช่สล็อตบนเมนบอร์ดเสีย', '{datacenter,memory,troubleshooting,rma}', true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.questions VALUES ('997a72f5-5b33-446f-97b8-2c613c1665e6', 'datacenter:09-dcim:q05', 10, '14d01b82-65c5-4700-b72d-d0b9e1d84c75', 'ซอฟต์แวร์ประเภท DCIM (เช่น NetBox) มีบทบาทสำคัญอย่างไรในการบริหารจัดการศูนย์ข้อมูล?', 'การใช้ระบบสารสนเทศเพื่อจัดการโครงสร้างพื้นฐานในห้องเซิร์ฟเวอร์', 'easy', 'multiple_choice', 'DCIM และ NetBox ทำหน้าที่เป็นฐานข้อมูลกลาง (Source of Truth) สำหรับบันทึกผังตู้แร็ค (Rack Elevation), ตำแหน่งอุปกรณ์แต่ละชั้น U, การเชื่อมโยงสายสัญญาณและสายไฟ, ไปจนถึงการบริหารจัดการ IP Address (IPAM)', '{datacenter,dcim,netbox,asset-management}', true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.questions VALUES ('290bd7fb-a136-4e0a-8251-0315c238a1a1', 'datacenter:07-sel:q03', 10, 'c64810d8-bf76-49f4-aadd-3cd45d92d14b', 'หากเซิร์ฟเวอร์เกิดอาการรีบูตเองเมื่อคืนเวลา 02:15 น. แต่ในบันทึก /var/log/messages ของ Linux ไม่มีข้อมูลใดๆ ก่อนเครื่องดับ ช่างควรตรวจสอบบันทึกเหตุการณ์ฮาร์ดแวร์จากแหล่งใดที่จะยังเก็บร่องรอยสาเหตุไว้ได้?', 'การหา Root Cause เมื่อระบบไฟดับหรือเกิดความร้อนสูงจนเครื่องตัดไฟฉุกเฉิน', 'easy', 'multiple_choice', 'System Event Log (SEL) ถูกบันทึกโดยชิป BMC (iDRAC/iLO) ลงในหน่วยความจำไม่ลบเลือน (NVRAM) แม้ OS จะแฮงก์กระทันหันและเขียนดิสก์ไม่ทัน แต่ BMC จะยังบันทึกเหตุการณ์ เช่น Power Supply AC lost หรือ Thermal Trip ไว้เสมอ', '{datacenter,sel,idrac,ilo,ipmitool}', true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.questions VALUES ('6ce08b38-2b09-43bb-b2e4-18a321887e7e', 'datacenter:07-sel:q04', 10, 'c64810d8-bf76-49f4-aadd-3cd45d92d14b', 'คำสั่ง ipmitool ในข้อใดใช้สำหรับดูค่าเซนเซอร์วัดอุณหภูมิ ความเร็วรอบพัดลม (RPM) และแรงดันไฟฟ้าของเซิร์ฟเวอร์ทั้งหมด?', 'การตรวจสอบอุณหภูมิหน้าเครื่องและสถานะพัดลมผ่านคอมมานด์ไลน์', 'medium', 'multiple_choice', 'คำสั่ง "ipmitool sdr list" (Sensor Data Repository) จะดึงค่าการอ่านของเซนเซอร์ทุกตัวในเซิร์ฟเวอร์ ทั้งอุณหภูมิ พัดลม และแรงดันไฟ ออกมาแสดง', '{datacenter,ipmitool,sdr,sensors,cli}', true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.questions VALUES ('cb7dbfcd-a8ce-4e92-a1bb-34ba1207ff7c', 'datacenter:07-sel:q05', 10, 'c64810d8-bf76-49f4-aadd-3cd45d92d14b', 'เมื่อพัดลมระบายความร้อนภายในเซิร์ฟเวอร์เสียไป 1 ตัวจากทั้งหมด 6 ตัว พฤติกรรมปกติที่ชิป BMC จะสั่งการทันทีเพื่อปกป้องเครื่องคือข้อใด?', 'ช่างได้ยินเสียงพัดลมดังผิดปกติจากเซิร์ฟเวอร์ตัวหนึ่งในตู้แร็คพร้อมไฟสีส้มกะพริบ', 'easy', 'multiple_choice', 'เพื่อป้องกันไม่ให้เกิดจุดอับความร้อน ชิป BMC จะสั่งเร่งความเร็วรอบพัดลมตัวที่เหลือทั้งหมดให้หมุนที่ความเร็วสูงสุด (100% Duty Cycle) จนเกิดเสียงดังชัดเจน และแจ้งเตือนสถานะ Redundancy Lost/Degraded', '{datacenter,hardware,cooling,fan,bmc}', true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.questions VALUES ('608b4ca0-6f74-4428-9dcc-a4d91e2e7fd6', 'datacenter:08-fw:q01', 10, 'a20fa558-7295-4a2a-bbf2-0700729e95e9', 'ฟีเจอร์ใดบนระบบ iDRAC หรือ iLO ที่ช่วยให้วิศวกรสามารถนำไฟล์ .iso ของระบบปฏิบัติการไปเชื่อมต่อให้เซิร์ฟเวอร์มองเห็นเสมือนเป็นแผ่นดีวีดีเสียบอยู่หน้าเครื่องผ่านเครือข่ายระยะไกล?', 'การลง OS ใหม่ให้เซิร์ฟเวอร์จากที่บ้านโดยไม่ต้องเดินทางเข้าห้อง Data Hall', 'easy', 'multiple_choice', 'ฟีเจอร์ Virtual Media ในหน้า Virtual Console ของ iDRAC/iLO ช่วยจำลองไฟล์ .iso จากเครื่องแอดมินหรือไฟล์แชร์ให้กลายเป็นไดรฟ์ CD/DVD เสมือนต่อเข้ากับเซิร์ฟเวอร์โดยตรง', '{datacenter,idrac,ilo,virtual-media,os-install}', true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.questions VALUES ('3ead4a3b-6128-4695-a9f2-cbc18355084f', 'datacenter:08-fw:q02', 10, 'a20fa558-7295-4a2a-bbf2-0700729e95e9', 'การอัปเดตเฟิร์มแวร์ส่วนใดของเซิร์ฟเวอร์ที่โดยทั่วไปสามารถดำเนินการและรีสตาร์ทตัวชิปนั้นได้ทันที "โดยไม่ต้องรีบูตเครื่องเซิร์ฟเวอร์หลักและไม่ทำให้ระบบปฏิบัติการหยุดทำงาน (Zero OS Downtime)"?', 'การวางแผนบำรุงรักษาเซิร์ฟเวอร์ที่มีบริการรันอยู่ตลอดเวลา', 'medium', 'multiple_choice', 'ชิป BMC (iDRAC / iLO) เป็นระบบคอมพิวเตอร์ขนาดเล็กที่แยกอิสระจาก CPU และ OS หลัก ดังนั้นการอัปเดตและรีบูตเฉพาะ iDRAC/iLO จึงไม่กระทบต่อระบบปฏิบัติการที่กำลังรันอยู่บนเซิร์ฟเวอร์', '{datacenter,firmware,bmc,idrac,ilo}', true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.questions VALUES ('855868fc-446e-4fb2-b42c-99a6ff11a6e3', 'datacenter:08-fw:q03', 10, 'a20fa558-7295-4a2a-bbf2-0700729e95e9', 'เมื่อต้องการติดตั้งระบบปฏิบัติการตระกูล RHEL / Rocky Linux ให้กับเซิร์ฟเวอร์ใหม่ 50 เครื่องพร้อมกันผ่าน PXE Boot โดยไม่ต้องมานั่งกรอกข้อมูลทีละหน้า จะต้องใช้ไฟล์กำหนดค่าอัตโนมัติ (Answer File) ที่เรียกว่าอะไร?', 'การทำ Automated Server Provisioning ในศูนย์ข้อมูลขนาดใหญ่', 'medium', 'multiple_choice', 'ระบบปฏิบัติการตระกูล Red Hat (RHEL, CentOS, Rocky, AlmaLinux) ใช้ระบบติดตั้งอัตโนมัติที่เรียกว่า Kickstart (ไฟล์ ks.cfg) ส่วน Ubuntu ยุคใหม่ใช้ Cloud-Init Autoinstall', '{datacenter,pxe,kickstart,linux,provisioning}', true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.questions VALUES ('c9d0a4bf-c55e-4e83-a1dc-81e5d2b1eb32', 'datacenter:08-fw:q04', 10, 'a20fa558-7295-4a2a-bbf2-0700729e95e9', 'หากเกิดอุบัติเหตุไฟดับหรือมีคนเผลอกดปุ่มรีเซ็ตเครื่องกลางคันในขณะที่เซิร์ฟเวอร์กำลังเขียนทับชิป BIOS (Flashing BIOS) จนเครื่องเปิดไม่ติด ช่างเทคนิคสามารถกู้คืนเครื่องด้วยกลไกใดที่มีในเซิร์ฟเวอร์ระดับองค์กร?', 'การกู้ชีพเซิร์ฟเวอร์เมื่อการอัปเดต BIOS ล้มเหลวกลางคัน', 'medium', 'multiple_choice', 'เซิร์ฟเวอร์ระดับ Enterprise (เช่น Dell PowerEdge, HPE ProLiant) มีชิป ROM สำรอง (Redundant / Backup BIOS ROM) ซึ่งสามารถสั่งสลับให้บูตจาก Backup ROM ผ่านหน้าจัดการ iDRAC/iLO หรือตั้งค่า NVRAM/Recovery Jumper บนเมนบอร์ดได้', '{datacenter,bios,firmware,recovery,troubleshooting}', true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.questions VALUES ('7d3b8788-3089-4c1e-bcee-d2937b6f029f', 'datacenter:08-fw:q05', 10, 'a20fa558-7295-4a2a-bbf2-0700729e95e9', 'เหตุใดเมื่อต้องติดตั้ง OS ผ่าน Virtual Media จากระยะไกล จึงแนะนำให้นำไฟล์ .iso ไปวางไว้บน File Share (HTTP/NFS/SMB) ภายในวงเครือข่ายของ Data Center แทนการอัปโหลดตรงจากแล็ปท็อปของช่างผ่าน VPN?', 'แนวทางปฏิบัติที่ดีที่สุด (Best Practice) ในการลง OS ระยะไกล', 'easy', 'multiple_choice', 'ไฟล์ ISO มีขนาดใหญ่หลายกิกะไบต์ การดึงผ่านอินเทอร์เน็ตและ VPN จากบ้านของช่างมีความเร็วต่ำและหากเน็ตบ้านกระตุกจะทำให้การติดตั้งค้างกลางคัน การวาง ISO ไว้บนเซิร์ฟเวอร์ในวงเดียวกับ iDRAC/iLO จะโอนถ่ายด้วยความเร็วระดับ Gigabit และเสถียรมากกว่า', '{datacenter,virtual-media,oob,best-practices}', true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.questions VALUES ('35b7ef7c-568b-45f1-832d-aaa946957ac3', 'datacenter:09-dcim:q01', 10, '14d01b82-65c5-4700-b72d-d0b9e1d84c75', 'ในการจัดระเบียบมัดสายสัญญาณ (โดยเฉพาะสายไฟเบอร์ออปติกและสาย Cat6A) ภายในตู้แร็ค เหตุใดมาตรฐาน Data Center จึงกำหนดให้ใช้สายรัดตีนตุ๊กแก (Velcro Strap) แทนการใช้เคเบิลไทร์พลาสติก (Plastic Zip Tie)?', 'คำถามสัมภาษณ์ยอดฮิตเพื่อทดสอบประสบการณ์หน้างานจริงของช่างเทคนิค Data Center', 'easy', 'multiple_choice', 'เคเบิลไทร์พลาสติกมักถูกรัดแน่นจนกดทับแกนสายไฟเบอร์ (ทำให้เกิด Micro-bending แสงดรอป) และเวลาต้องแก้ไขต้องใช้คีมตัดซึ่งเสี่ยงตัดโดนสายอื่นขาด ส่วนตีนตุ๊กแกไม่บีบสายและแกะออกเพื่อเพิ่มลดสายได้ง่าย', '{datacenter,cabling,velcro,best-practices}', true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.questions VALUES ('9a28af2c-2332-44f7-956d-28c33b97cbc0', 'datacenter:09-dcim:q02', 10, '14d01b82-65c5-4700-b72d-d0b9e1d84c75', 'สถาปัตยกรรมการเดินสายแบบ "Top-of-Rack (ToR)" มีลักษณะการจัดวางอุปกรณ์อย่างไร?', 'การออกแบบระบบเครือข่ายภายในแถวตู้แร็คของศูนย์ข้อมูล', 'easy', 'multiple_choice', 'Top-of-Rack (ToR) คือการติดตั้ง Network Switch ไว้ที่ด้านบนสุดของตู้แร็คแต่ละตู้ เพื่อให้เซิร์ฟเวอร์ทุกเครื่องในตู้นั้นเสียบสาย Patch Cord สั้นๆ ขึ้นไปยังสวิตช์ประจำตู้ตัวเอง แล้วจึงลากเฉพาะสาย Uplink ออกไปหา Spine/Core Switch', '{datacenter,tor,architecture,cabling}', true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.questions VALUES ('d9a0cafa-ab7f-4017-8a74-8790c9115acd', 'datacenter:09-dcim:q03', 10, '14d01b82-65c5-4700-b72d-d0b9e1d84c75', 'ข้อมูลที่ควรระบุบนป้ายกำกับสายสัญญาณ (Cable Label) ที่ถูกต้องตามมาตรฐาน Data Center คือข้อใด?', 'การติดป้ายกำกับสาย LAN และสายไฟเบอร์ที่เพิ่งเดินใหม่ในตู้เซิร์ฟเวอร์', 'easy', 'multiple_choice', 'ป้าย Label มาตรฐานต้องติดที่ปลายสายทั้งสองฝั่ง โดยระบุทั้งตำแหน่งต้นทาง (A-End: Rack, U, Device, Port) และตำแหน่งปลายทาง (Z-End: Rack, U, Device, Port) เพื่อให้รู้ทันทีว่าสายมาจากไหนและไปที่ไหน', '{datacenter,labeling,cabling,operations}', true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.questions VALUES ('10ee6d5a-fcd8-4f5b-a1ba-bcfb8d54577e', 'datacenter:09-dcim:q04', 10, '14d01b82-65c5-4700-b72d-d0b9e1d84c75', 'เมื่อตรวจสอบค่าแสงของหัวไฟเบอร์ SFP+ บนสวิตช์ผ่านฟีเจอร์ DOM/DDM พบว่าพอร์ต Te1/0/2 มีค่า "Tx Power = -2.1 dBm" แต่ค่า "Rx Power = -39.5 dBm (Low Alarm)" และพอร์ตไม่ขึ้น Link สาเหตุใดเป็นไปได้มากที่สุด?', 'การวิเคราะห์ปัญหาไฟเบอร์ออปติกด้วยตัวเลขความเข้มแสง dBm', 'medium', 'multiple_choice', 'ค่า Tx Power (-2.1 dBm) ปกติ แปลว่าหัว SFP ฝั่งเราปล่อยแสงออกปกติ แต่ Rx Power (-39.5 dBm คือแทบไม่มีแสงเข้ามาเลย) แปลว่าแสงจากฝั่งตรงข้ามมาไม่ถึงเรา เช่น สายไฟเบอร์ขาเข้าขาด, หลุด, เสียบสลับขั้ว หรือหัว SFP ฝั่งตรงข้ามดับ', '{datacenter,fiber,dom,ddm,troubleshooting}', true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.questions VALUES ('5e77e5f5-b2a6-4ef7-b604-cd1bb221d8de', 'datacenter:10-ops:q01', 10, '4239ddec-0437-4d0e-9b43-7cf2d26d3c23', 'เหตุใดศูนย์ข้อมูลมาตรฐานสากลจึงมีกฎห้ามนำ "กล่องกระดาษลูกฟูก (Cardboard Boxes)" เข้าไปในห้องเซิร์ฟเวอร์ (Data Hall) โดยต้องแกะอุปกรณ์ออกจากกล่องตั้งแต่ห้องพักของด้านนอกเสมอ?', 'กฎระเบียบความปลอดภัยและความสะอาดภายในห้อง Data Hall', 'easy', 'multiple_choice', 'กล่องกระดาษลูกฟูกเป็นแหล่งกำเนิดฝุ่นละอองและเส้นใยกระดาษที่ปลิวเข้าไปอุดตันแผ่นกรองแอร์และพัดลมเซิร์ฟเวอร์ อีกทั้งยังเป็นเชื้อเพลิงติดไฟง่าย (Fire Hazard) ที่อันตรายในห้องเซิร์ฟเวอร์', '{datacenter,safety,operations,fire-safety}', true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.questions VALUES ('89c6c052-d4f4-417e-b26f-b8dc659a4deb', 'datacenter:10-ops:q02', 10, '4239ddec-0437-4d0e-9b43-7cf2d26d3c23', 'มาตรฐานศูนย์ข้อมูลระดับ "Tier III (Concurrently Maintainable)" มีคุณสมบัติเด่นที่แตกต่างจาก Tier I และ Tier II อย่างไร?', 'การทำความเข้าใจระดับมาตรฐาน Uptime Institute Tier', 'medium', 'multiple_choice', 'คำว่า Concurrently Maintainable ของ Tier III หมายถึง มีเส้นทางจ่ายไฟและระบบทำความเย็นสำรองที่ช่วยให้สามารถปิดซ่อมบำรุงอุปกรณ์ชิ้นใดชิ้นหนึ่งตามแผนได้ "โดยไม่ต้องหยุดการทำงานของเซิร์ฟเวอร์ในศูนย์ข้อมูลเลย"', '{datacenter,tier,uptime,redundancy}', true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.questions VALUES ('8dc5b9d6-8e1f-4760-a9dd-dc4539c06fad', 'datacenter:10-ops:q03', 10, '4239ddec-0437-4d0e-9b43-7cf2d26d3c23', 'ก่อนที่จะเปิดฝาเครื่องเซิร์ฟเวอร์เพื่อเปลี่ยนแผงหน่วยความจำ (RAM) หรือเมนบอร์ด ช่างเทคนิคต้องปฏิบัติสิ่งใดเพื่อป้องกันไม่ให้ชิปอิเล็กทรอนิกส์เสียหายจากร่างกายของช่าง?', 'ขั้นตอนความปลอดภัยพื้นฐานในการซ่อมบำรุงฮาร์ดแวร์', 'easy', 'multiple_choice', 'ต้องสวมสายรัดข้อมือป้องกันไฟฟ้าสถิต (ESD Wrist Strap) และต่อสายกราวด์เข้ากับโครงโลหะของตู้แร็ค เพื่อคายประจุไฟฟ้าสถิตจากร่างกายลงดินก่อนสัมผัสแผงวงจร', '{datacenter,esd,hardware,safety}', true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.questions VALUES ('3c363e7c-9f30-455c-b6db-be46fb48c093', 'datacenter:10-ops:q04', 10, '4239ddec-0437-4d0e-9b43-7cf2d26d3c23', 'หากศูนย์ข้อมูลแห่งหนึ่งใช้พลังงานไฟฟ้ารวมทั้งอาคาร (Total Facility Power) เท่ากับ 1,500 kW โดยเป็นพลังงานที่ใช้กับเครื่องเซิร์ฟเวอร์และอุปกรณ์ไอที (IT Equipment Power) เท่ากับ 1,000 kW ค่า PUE ของศูนย์ข้อมูลนี้มีค่าเท่าใด?', 'การคำนวณดัชนีวัดประสิทธิภาพการใช้พลังงานของ Data Center', 'medium', 'multiple_choice', 'สูตร PUE = Total Facility Power / IT Equipment Power = 1,500 / 1,000 = 1.5 (ยิ่งเข้าใกล้ 1.0 ยิ่งประหยัดพลังงาน)', '{datacenter,pue,power,calculation}', true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.questions VALUES ('7a926c05-18f5-464f-b5ad-6fe69d1f02a7', 'datacenter:10-ops:q05', 10, '4239ddec-0437-4d0e-9b43-7cf2d26d3c23', 'เอกสาร "MOP (Method of Procedure)" ที่ใช้ในการขออนุมัติทำงานเปลี่ยนแปลงระบบใน Data Center มีองค์ประกอบสำคัญที่ไม่สามารถขาดได้คือส่วนใด เพื่อรองรับกรณีที่การเปลี่ยนแปลงล้มเหลว?', 'การเตรียมเอกสาร Change Management ก่อนเข้าช่วง Maintenance Window', 'easy', 'multiple_choice', 'ทุก MOP ต้องมี Rollback Plan (แผนการย้อนกลับสู่สภาพเดิม) ที่ชัดเจนและระบุเวลาตัดสินใจ (Cut-off time) เพื่อให้มั่นใจว่าหากเกิดปัญหาที่ไม่คาดคิด ระบบจะถูกกู้คืนกลับสู่สภาพปกติได้ทันก่อนหมดเวลา Maintenance', '{datacenter,mop,change-management,rollback}', true, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.questions VALUES ('256f966e-df8f-4ed0-a9d3-51b607070273', 'troubleshooting:03-itil-sla:q01', 6, '20d9ad57-bea5-4819-889f-9ff3841bb039', 'ตามกรอบมาตรฐาน ITIL ข้อใดจัดเป็น "Service Request" ไม่ใช่ "Incident"?', 'การจัดหมวดหมู่ใบงาน (Ticket Categorization) หน้างาน IT Helpdesk', 'easy', 'multiple_choice', 'Incident คือเหตุขัดข้องที่ทำให้บริการที่เคยใช้ได้หยุดชะงักหรือช้าลง ส่วน Service Request คือคำขอรับบริการมาตรฐานที่ไม่ได้เกิดจากระบบพัง เช่น ขอสร้างบัญชีผู้ใช้ใหม่ ขอสิทธิ์เข้าโฟลเดอร์ หรือขอติดตั้งซอฟต์แวร์เพิ่มเติม', '{itil,incident,service-request,helpdesk}', true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.questions VALUES ('b292d3f9-fb78-417a-92da-e50ff999bc5d', 'troubleshooting:03-itil-sla:q02', 6, '20d9ad57-bea5-4819-889f-9ff3841bb039', 'หากเกิดเหตุขัดข้อง "เครื่องสแกนเอกสารของสำนักงานทำงานช้าลงเล็กน้อย มีผู้ใช้งานได้รับผลกระทบเพียง 1 คน และสามารถเดินไปใช้เครื่องสแกนอีกเครื่องที่อยู่ข้างๆ ทดแทนได้ไปก่อน" แต่ผู้ใช้งานรายนั้นโทรมาเร่งให้จัดเป็นเคสวิกฤตระดับ P1 (Critical) ทันที ในฐานะ IT Support คุณควรจัดระดับ Priority อย่างไรตามหลัก ITIL?', 'การคำนวณ Priority จากตาราง Impact × Urgency', 'medium', 'multiple_choice', 'ตามหลัก ITIL ระดับความสำคัญ (Priority) ต้องคำนวณจาก Impact (กระทบคนเดียว = Low) คูณกับ Urgency (มีเครื่องสำรองข้างๆ ใช้แทนได้ งานไม่หยุดชะงัก = Low) ดังนั้นจึงควรจัดเป็น P3 หรือ P4 ไม่ใช่ P1 ซึ่งสงวนไว้สำหรับเหตุระบบหลักล่มทั้งองค์กร', '{itil,priority,impact,urgency,sla}', true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.questions VALUES ('5ec568d1-840c-4aef-bed2-e73cb97ed488', 'troubleshooting:03-itil-sla:q03', 6, '20d9ad57-bea5-4819-889f-9ff3841bb039', 'ความแตกต่างระหว่าง "Response SLA" และ "Resolution SLA" คือข้อใด?', 'การวัดผลการปฏิบัติงานของทีม Support และ NOC', 'easy', 'multiple_choice', 'Response SLA คือกรอบเวลานับจากเปิดเคสจนถึงตอนที่เจ้าหน้าที่รับเรื่องและตอบกลับผู้แจ้งครั้งแรก ส่วน Resolution SLA คือกรอบเวลานับจากเปิดเคสจนกระทั่งแก้ไขปัญหาเสร็จสิ้นและบริการกลับมาใช้งานได้', '{sla,itil,metrics,support}', true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.questions VALUES ('06283e37-8fad-40a5-96a4-d9d0ad99807b', 'troubleshooting:03-itil-sla:q04', 6, '20d9ad57-bea5-4819-889f-9ff3841bb039', 'เมื่อสวิตช์เครือข่ายที่ชั้น 2 เกิดอาการค้างทุกสัปดาห์ ช่าง L1 แก้ปัญหาเฉพาะหน้าด้วยการรีบูตสวิตช์เพื่อให้พนักงานทำงานต่อได้ (ปิดเคส Incident) แต่หัวหน้าทีมสั่งให้เปิดใบงานอีกประเภทหนึ่งเพื่อสืบหาสาเหตุรากเหง้า (Root Cause) ว่าทำไมสวิตช์จึงค้างซ้ำๆ ใบงานประเภทนั้นในกรอบ ITIL เรียกว่าอะไร?', 'การจัดการปัญหาที่เกิดซ้ำ (Recurring Incidents) เพื่อป้องกันไม่ให้เกิดอีกในอนาคต', 'medium', 'multiple_choice', 'ใน ITIL เมื่อเกิด Incident ซ้ำๆ หรือเป็นเหตุการณ์รุนแรงที่ยังไม่ทราบต้นตอ จะมีการเปิด "Problem" (Problem Management) เพื่อสืบสวนหา Root Cause และหาทางป้องกันถาวร', '{itil,problem-management,incident,rca}', true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.questions VALUES ('97328fad-ee72-4dd2-a54f-e7fe04a22cb8', 'troubleshooting:03-itil-sla:q05', 6, '20d9ad57-bea5-4819-889f-9ff3841bb039', 'ข้อมูลใดสำคัญที่สุดที่เจ้าหน้าที่ L1 Support ควรระบุไว้ใน "Escalation Note" ก่อนส่งต่อใบงาน (Escalate) ให้ทีมวิศวกร L2/L3?', 'การส่งต่อเคสอย่างมีประสิทธิภาพเพื่อลดเวลา MTTR (Mean Time To Resolve)', 'easy', 'multiple_choice', 'Escalation Note ที่ดีต้องระบุ 5W (ใครได้รับผลกระทบ อาการคืออะไร เกิดเมื่อไหร่ ระบบไหน) พร้อมแนบหลักฐาน Error/Log และระบุสิ่งที่ L1 ได้ตรวจสอบหรือตัดประเด็นไปแล้ว เพื่อไม่ให้ L2 ต้องเริ่มถามคำถามเดิมซ้ำตั้งแต่ต้น', '{escalation,ticketing,support,communication}', true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.questions VALUES ('c05c4fb2-1c30-4982-93ae-6301b6464eec', 'troubleshooting:04-ad-gpo:q01', 6, 'db3e3c4d-8da3-45fd-99a6-c07212788dff', 'ในระบบ Active Directory ออบเจกต์ชนิดใดที่ออกแบบมาเพื่อใช้จัดหมวดหมู่โครงสร้างตามแผนก (เช่น Sales, HR, IT) และใช้เป็นเป้าหมายหลักในการผูกนโยบาย Group Policy (GPO)?', 'การออกแบบโครงสร้าง Active Directory และการบังคับใช้นโยบายคอมพิวเตอร์แยกตามแผนก', 'easy', 'multiple_choice', 'Organizational Unit (OU) คือคอนเทนเนอร์ที่ใช้จำลองโครงสร้างแผนกหรือสาขาขององค์กร เพื่อใช้ผูก Group Policy (GPO) และมอบหมายสิทธิ์การดูแล (Delegation of Control) ส่วน Security Group ใช้สำหรับกำหนดสิทธิ์การเข้าถึงทรัพยากร (Permissions) ไม่สามารถผูก GPO เข้ากับ Security Group โดยตรงได้', '{active-directory,ou,gpo,windows-server}', true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.questions VALUES ('e868866f-050c-4fd4-a36a-5054d97fe0dc', 'troubleshooting:04-ad-gpo:q02', 6, 'db3e3c4d-8da3-45fd-99a6-c07212788dff', 'เมื่อผู้ใช้งานล็อกอินเข้าคอมพิวเตอร์ในออฟฟิศแล้วขึ้นข้อความ "The trust relationship between this workstation and the primary domain failed" สาเหตุหลักเกิดจากอะไร?', 'พนักงานนำโน้ตบุ๊กของบริษัทที่ปิดเก็บไว้ในตู้ 3 เดือนกลับมาเปิดใช้งานที่ออฟฟิศ', 'medium', 'multiple_choice', 'คอมพิวเตอร์ที่ Join Domain จะมีรหัสผ่านประจำเครื่อง (Machine Account Password / Secure Channel) ที่ต้องซิงก์กับ Domain Controller เป็นระยะ หากเครื่องออฟไลน์ไปนานหรือถูกย้อน Snapshot รหัสผ่านของตัวเครื่องจะไม่ตรงกับใน AD', '{active-directory,trust-relationship,troubleshooting,domain}', true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.questions VALUES ('ef69e1ac-1034-4c68-af69-79ad37cabb59', 'troubleshooting:04-ad-gpo:q03', 6, 'db3e3c4d-8da3-45fd-99a6-c07212788dff', 'เหตุใดหากนาฬิกาของเครื่องคอมพิวเตอร์ลูกข่ายเดินช้าหรือเร็วกว่า Domain Controller เกิน 5 นาที ผู้ใช้งานจึงไม่สามารถล็อกอินเข้า Domain หรือเข้าใช้งาน File Share ได้?', 'ถ่านกระดุม CMOS บนเมนบอร์ดหมดทำให้เวลาเครื่องเพี้ยนหลังไฟดับ', 'medium', 'multiple_choice', 'โปรโตคอล Kerberos ที่ Active Directory ใช้ในการยืนยันตัวตนมีกลไกป้องกันการดักจับแพ็กเก็ตมาส่งซ้ำ (Replay Attack) โดยกำหนดค่าเริ่มต้นให้เวลาของเครื่องต้นทางและเครื่องปลายทางห้ามคลาดเคลื่อนเกิน 5 นาที (Maximum tolerance for computer clock synchronization)', '{active-directory,kerberos,ntp,time-skew,security}', true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.questions VALUES ('4bffbea3-efde-4d90-9fe8-e8f028d932ef', 'troubleshooting:04-ad-gpo:q04', 6, 'db3e3c4d-8da3-45fd-99a6-c07212788dff', 'หลังจากผู้ดูแลระบบแก้ไขการตั้งค่า Group Policy (GPO) บนเซิร์ฟเวอร์เรียบร้อยแล้ว หากต้องการให้เครื่องคอมพิวเตอร์ของผู้ใช้งานดึงนโยบายใหม่มาบังคับใช้ทันทีพร้อมตรวจสอบรายงานว่าได้รับ GPO ตัวใดบ้าง ควรใช้คำสั่งคู่ใด?', 'การทดสอบการบังคับใช้นโยบาย Map Drive อัตโนมัติผ่าน GPO', 'easy', 'multiple_choice', 'คำสั่ง gpupdate /force ใช้บังคับให้เครื่องลูกดึงและประมวลผล GPO ล่าสุดทันที ส่วนคำสั่ง gpresult /r (หรือ gpresult /h report.html) ใช้ตรวจสอบผลลัพธ์ว่ามี GPO ตัวใดถูกนำมาใช้กับเครื่องและผู้ใช้นี้บ้าง', '{gpo,gpupdate,gpresult,windows,cli}', true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.questions VALUES ('65a54171-261e-43c5-8a61-ae28af22fecd', 'troubleshooting:04-ad-gpo:q05', 6, 'db3e3c4d-8da3-45fd-99a6-c07212788dff', 'พนักงานแจ้งว่าเพิ่งเปลี่ยนรหัสผ่าน Domain เมื่อเช้านี้ แต่หลังจากนั้นบัญชีถูกล็อก (Account Locked Out) ซ้ำทุกๆ 15 นาที ทั้งที่เจ้าตัวไม่ได้พิมพ์รหัสผ่านผิดอีกเลย สาเหตุที่พบบ่อยที่สุดคือข้อใด?', 'การวิเคราะห์ปัญหา Account Lockout ซ้ำซากหลังเปลี่ยนรหัสผ่าน', 'medium', 'multiple_choice', 'เมื่อเปลี่ยนรหัสผ่าน AD แล้ว อุปกรณ์อื่นหรือบริการที่จำรหัสผ่านเก่าไว้ (เช่น Wi-Fi/Email บนสมาร์ตโฟน, Windows Credential Manager, หรือเซสชัน RDP ที่เปิดค้างไว้บนเซิร์ฟเวอร์อื่น) จะยังคงพยายามส่งรหัสผ่านเก่าไปล็อกอินอัตโนมัติอยู่เบื้องหลังจนบัญชีถูกล็อกซ้ำ', '{active-directory,account-lockout,troubleshooting,helpdesk}', true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.questions VALUES ('e3ce04a7-9751-4d98-89a4-264a8629e1fb', 'troubleshooting:05-m365-email:q01', 6, 'b4c768d7-eb4b-47f6-8044-356dd03f07cc', 'แผนกทรัพยากรบุคคลต้องการอีเมลกลางชื่อ "recruitment@company.com" เพื่อให้เจ้าหน้าที่ HR จำนวน 3 คนสามารถเปิดอ่านและตอบกลับผู้สมัครงานร่วมกันได้ โดยบริษัทไม่ต้องการเสียค่าเช่า License รายเดือนเพิ่มสำหรับอีเมลกลางนี้ ผู้ดูแลระบบ Microsoft 365 ควรสร้างกล่องจดหมายประเภทใด?', 'การบริหารจัดการบัญชีและประหยัดค่าใช้จ่าย License บน Microsoft 365', 'easy', 'multiple_choice', 'Shared Mailbox ใน Microsoft 365 มีพื้นที่เก็บอีเมลได้ถึง 50 GB โดยไม่ต้องใช้ License เสียเงิน เพียงแค่กำหนดสิทธิ์ Full Access และ Send As ให้กับบัญชีของพนักงาน HR ทั้ง 3 คนที่มี License ของตัวเองอยู่แล้ว', '{m365,shared-mailbox,exchange,licensing}', true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.questions VALUES ('da4b8bc6-0a41-4f85-b707-09de5924b3db', 'troubleshooting:05-m365-email:q02', 6, 'b4c768d7-eb4b-47f6-8044-356dd03f07cc', 'ระเบียน DNS ชนิดใดทำหน้าที่ประกาศรายชื่อ IP Address และเซิร์ฟเวอร์ที่ได้รับอนุญาตให้ส่งอีเมลออกในนามโดเมนขององค์กร เพื่อป้องกันผู้ไม่หวังดีปลอมชื่อโดเมนส่งอีเมล (Email Spoofing)?', 'การตั้งค่าระบบความปลอดภัยของอีเมลองค์กรหลังเริ่มใช้งานระบบส่งใบแจ้งหนี้อัตโนมัติ', 'easy', 'multiple_choice', 'SPF (Sender Policy Framework) คือระเบียน TXT บน DNS ที่ระบุว่ามี IP หรือผู้ให้บริการเมลรายใดบ้าง (เช่น include:spf.protection.outlook.com) ที่ได้รับอนุญาตให้ส่งอีเมลในนามโดเมนนั้น', '{email,spf,dns,security,m365}', true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.questions VALUES ('aa628f4a-aff3-4b5e-a6bb-de94aabf628a', 'troubleshooting:05-m365-email:q03', 6, 'b4c768d7-eb4b-47f6-8044-356dd03f07cc', 'ความแตกต่างระหว่างหน้าที่ของ "DKIM" และ "DMARC" ในระบบยืนยันตัวตนอีเมลคือข้อใด?', 'การตั้งค่า Email Authentication ครบวงจรเพื่อให้อีเมลบริษัทไม่ตกถัง Spam ของลูกค้า', 'medium', 'multiple_choice', 'DKIM ใช้การแนบลายเซ็นดิจิทัลเข้ารหัส (Cryptographic Signature) ไปกับหัวจดหมายเพื่อยืนยันความถูกต้องและไม่ถูกแก้ไขกลางทาง ส่วน DMARC คือนโยบายที่สั่งเซิร์ฟเวอร์ผู้รับว่าต้องจัดการอย่างไร (none, quarantine, reject) หากอีเมลตรวจไม่ผ่าน SPF/DKIM พร้อมส่งรายงานกลับมาให้เจ้าของโดเมน', '{email,dkim,dmarc,security}', true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.questions VALUES ('a5818f60-b037-4677-8bca-6ed90aa6506c', 'troubleshooting:05-m365-email:q04', 6, 'b4c768d7-eb4b-47f6-8044-356dd03f07cc', 'เมื่อผู้ใช้งานส่งอีเมลหาลูกค้าแล้วได้รับจดหมายตีกลับ (NDR / Bounce Message) พร้อมรหัสข้อผิดพลาด "550 5.1.1 User Unknown" สาเหตุของปัญหานี้คือข้อใด?', 'การอ่านรหัสข้อผิดพลาดในใบแจ้งเตือนอีเมลตีกลับ (Non-Delivery Report)', 'easy', 'multiple_choice', 'รหัส 550 5.1.1 (User Unknown / Bad destination mailbox address) หมายความว่าไม่มีชื่อบัญชีอีเมลผู้รับนั้นอยู่ในระบบของโดเมนปลายทาง ซึ่งมักเกิดจากการสะกดชื่ออีเมลผิด หรือพนักงานฝั่งลูกค้าลาออกและถูกลบบัญชีไปแล้ว', '{email,ndr,smtp,troubleshooting}', true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.questions VALUES ('520d87f5-c584-4b4b-b599-fa6741ba2b2b', 'troubleshooting:05-m365-email:q05', 6, 'b4c768d7-eb4b-47f6-8044-356dd03f07cc', 'หากพนักงานลาออกจากบริษัท และฝ่ายบริหารต้องการเก็บรักษาอีเมลเก่าทั้งหมดในกล่องจดหมายของพนักงานคนนั้นไว้ตรวจสอบย้อนหลัง แต่ต้องการถอด License ของ Microsoft 365 ออกเพื่อนำไปให้พนักงานใหม่ใช้งาน แนวทางปฏิบัติที่ถูกต้องที่สุดคือข้อใด?', 'ขั้นตอนการ Offboarding พนักงานในระบบ Microsoft 365 อย่างคุ้มค่าและปลอดภัย', 'medium', 'multiple_choice', 'ใน Exchange Online หากถอด License ออกจาก User Mailbox ทันที กล่องจดหมายจะถูกลบภายใน 30 วัน แต่วิธีมาตรฐานคือแปลง (Convert) กล่องจดหมายนั้นให้เป็น Shared Mailbox เสียก่อน (หากขนาดไม่เกิน 50 GB) แล้วจึงถอด License ออก ข้อมูลจะยังอยู่ครบถาวรโดยไม่เสียค่า License', '{m365,offboarding,shared-mailbox,sysadmin}', true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.questions VALUES ('512ff8b7-0533-409f-8e09-f98ec0e4f245', 'troubleshooting:06-printer-smb:q01', 6, '36390028-97e0-4e57-b0db-c9c4f778cb68', 'เมื่อมีเอกสารค้างอยู่ในคิวเครื่องพิมพ์บน Windows (Stuck Print Job) และผู้ใช้งานกดยกเลิก (Cancel) แล้วแต่สถานะยังคงค้างอยู่ที่คำว่า "Deleting..." ไม่ยอมหายไป ขั้นตอนการแก้ไขที่ถูกต้องคือข้อใด?', 'การล้างคิวงานพิมพ์ที่ค้างตายจนทำให้คนทั้งแผนกสั่งพิมพ์งานต่อไม่ได้', 'easy', 'multiple_choice', 'เมื่อไฟล์งานพิมพ์ค้างใน Spooler Service การกด Cancel ปกติมักไม่สำเร็จ ต้องสั่งหยุดบริการ Print Spooler (net stop spooler) เพื่อปลดล็อกไฟล์ แล้วเข้าไปลบไฟล์ค้างใน C:\Windows\System32\spool\PRINTERS จากนั้นสั่งเริ่มบริการใหม่ (net start spooler)', '{printer,spooler,windows,troubleshooting}', true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.questions VALUES ('b1a7c889-ec7f-44a7-b4f3-badaee11adc0', 'troubleshooting:06-printer-smb:q02', 6, '36390028-97e0-4e57-b0db-c9c4f778cb68', 'พอร์ตมาตรฐานใดที่ใช้สำหรับการส่งข้อมูลงานพิมพ์ผ่านเครือข่ายแบบ Standard TCP/IP (RAW / JetDirect) ไปยัง Network Printer และทำไมจึงแนะนำให้ใช้แทน WSD Port?', 'การแก้ปัญหาเครื่องพิมพ์เครือข่ายในสำนักงานขึ้นสถานะ Offline บ่อยครั้ง', 'medium', 'multiple_choice', 'การพิมพ์แบบ Standard TCP/IP (RAW / HP JetDirect) ใช้พอร์ต TCP 9100 ซึ่งเชื่อมต่อตรงด้วย IP Address ของเครื่องพิมพ์ จึงมีความเสถียรสูงกว่าพอร์ต WSD ที่อาศัยโปรโตคอลค้นหาแบบ Multicast ซึ่งหลุดง่ายเมื่อเครื่องพิมพ์เข้าโหมด Sleep', '{printer,tcp-9100,wsd,network}', true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.questions VALUES ('bc88461e-fd06-4893-8284-d9a61fcd853b', 'datacenter:11-equip:q03', 10, '681252fc-9293-40e3-9100-c19b27e9f69c', 'ความแตกต่างระหว่างหัวปลั๊กไฟมาตรฐานศูนย์ข้อมูล "IEC C13/C14" และ "IEC C19/C20" คือข้อใด?', 'การเลือกสายไฟ (Power Cord) ให้ตรงกับพาวเวอร์ซัพพลายของเซิร์ฟเวอร์และรางไฟ PDU', 'easy', 'multiple_choice', 'IEC C13/C14 เป็นปลั๊กมาตรฐานขาแนวตั้ง รองรับกระแสสูงสุด 10A-15A ใช้กับเซิร์ฟเวอร์ 1U/2U และสวิตช์ทั่วไป ส่วน IEC C19/C20 เป็นปลั๊กทรงสี่เหลี่ยมขนาดใหญ่ ขาแนวนอน รองรับกระแสสูง 16A-20A ใช้กับอุปกรณ์ที่กินไฟสูง เช่น Blade Chassis, GPU Server หรือ Core Switch', '{datacenter,power,iec-c13,iec-c19,pdu}', true, '2026-11-10 13:22:20.548088+00', '2026-11-10 13:22:20.548088+00');
INSERT INTO public.questions VALUES ('9f84eb24-f2f7-4a37-a212-cdf50df72acb', 'troubleshooting:06-printer-smb:q03', 6, '36390028-97e0-4e57-b0db-c9c4f778cb68', 'ผู้ดูแลระบบสร้างโฟลเดอร์แชร์บน Windows Server โดยตั้งค่า "Share Permission" ให้กลุ่มฝ่ายขายเป็น "Read (อ่านอย่างเดียว)" แต่ตั้งค่าในแท็บ "NTFS Security Permission" ให้กลุ่มฝ่ายขายเป็น "Full Control" เมื่อพนักงานฝ่ายขายเชื่อมต่อเข้าโฟลเดอร์นี้ผ่านเครือข่าย (\\server\sales) พนักงานจะมีสิทธิ์ทำอะไรได้บ้าง?', 'การคำนวณสิทธิ์รวม (Effective Permissions) ระหว่าง Share Permission และ NTFS Permission', 'medium', 'multiple_choice', 'เมื่อเข้าถึงโฟลเดอร์ผ่านเครือข่าย SMB ระบบจะนำ Share Permission มาเปรียบเทียบกับ NTFS Permission และยึดตามตัวที่ "เข้มงวดที่สุด (Most Restrictive)" ดังนั้น Read ปะทะกับ Full Control จึงเหลือเพียงสิทธิ์ Read (อ่านได้อย่างเดียว สร้างหรือแก้ไขไฟล์ไม่ได้)', '{smb,permissions,ntfs,windows-server}', true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.questions VALUES ('5b3a90cc-98f5-4e20-84a0-4571ae4f7428', 'troubleshooting:06-printer-smb:q04', 6, '36390028-97e0-4e57-b0db-c9c4f778cb68', 'โปรโตคอล SMB (Server Message Block) ที่ใช้สำหรับการแชร์ไฟล์และโฟลเดอร์บนเครือข่าย Windows (\\server\share) ทำงานบนพอร์ตมาตรฐานใด?', 'การตรวจสอบ Firewall Rule เมื่อคอมพิวเตอร์ต่าง VLAN ไม่สามารถเปิดโฟลเดอร์แชร์ของไฟล์เซิร์ฟเวอร์ได้', 'easy', 'multiple_choice', 'โปรโตคอล SMB ยุคปัจจุบันทำงานผ่านพอร์ต TCP 445 โดยตรง (และเป็นพอร์ตสำคัญที่ต้องระวังไม่ให้เปิดออกสู่อินเทอร์เน็ตสาธารณะเพราะเสี่ยงต่อการโจมตีด้วย Ransomware)', '{smb,ports,network,file-share}', true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.questions VALUES ('29bbd4c8-8c53-4803-aed5-19065d230d4f', 'troubleshooting:06-printer-smb:q05', 6, '36390028-97e0-4e57-b0db-c9c4f778cb68', 'พนักงานที่ทำงานจากบ้านแจ้งว่า เมื่อเชื่อมต่อ VPN ของบริษัท (ซึ่งตั้งค่าแบบ Split Tunnel) สามารถเปิดเข้าเซิร์ฟเวอร์ภายในด้วยหมายเลข IP (https://10.20.1.50) ได้ปกติ แต่พอพิมพ์ชื่อโดเมนภายใน (https://intranet.company.local) กลับขึ้นว่าไม่พบเว็บไซต์ (DNS_PROBE_FINISHED_NXDOMAIN) สาเหตุเกิดจากอะไร?', 'การวิเคราะห์ปัญหาการแปลงชื่อโดเมนภายในเมื่อเชื่อมต่อผ่านระบบ VPN', 'medium', 'multiple_choice', 'หากเข้าด้วย IP ได้ แปลว่า Routing ในอุโมงค์ VPN ทำงานถูกต้องแล้ว แต่การเข้าด้วยชื่อ .local ไม่ได้ แสดงว่าเครื่องของพนักงานยังคงถามชื่อโดเมนไปที่ DNS ของเน็ตบ้าน (หรือ 8.8.8.8) ซึ่งไม่รู้จักชื่อภายในบริษัท ต้องตั้งค่าให้ VPN จ่าย Internal DNS Server และ Search Domain ของบริษัทมาให้เครื่องลูกด้วย', '{vpn,split-tunnel,dns,troubleshooting}', true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.questions VALUES ('ac2a6f12-d7c5-40f8-8115-75aed1a9e22a', 'troubleshooting:07-backup-dr:q01', 6, 'efdde8b7-94d1-4638-bb7d-cc05c37f6634', 'ตามกฎการสำรองข้อมูลมาตรฐาน "3-2-1 Backup Rule" ตัวเลข 3, 2 และ 1 หมายถึงข้อใดตามลำดับ?', 'การออกแบบสถาปัตยกรรมการสำรองข้อมูลขององค์กรให้ปลอดภัยจากเหตุฮาร์ดแวร์พังและไฟไหม้', 'easy', 'multiple_choice', 'กฎ 3-2-1 หมายถึง มีข้อมูลทั้งหมดอย่างน้อย 3 ชุด (1 ข้อมูลจริง + 2 สำเนา), เก็บไว้บนสื่อบันทึกข้อมูลที่ต่างชนิดกันอย่างน้อย 2 ประเภท และมีอย่างน้อย 1 ชุดที่เก็บไว้นอกสถานที่ (Offsite/Cloud)', '{backup,3-2-1-rule,disaster-recovery,sysadmin}', true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.questions VALUES ('0f5d259c-9fb1-4888-8eaf-a4d4bbbeded2', 'troubleshooting:07-backup-dr:q02', 6, 'efdde8b7-94d1-4638-bb7d-cc05c37f6634', 'ความแตกต่างที่สำคัญที่สุดระหว่างค่า "RPO (Recovery Point Objective)" และ "RTO (Recovery Time Objective)" คือข้อใด?', 'การประชุมกำหนดเป้าหมายแผนกู้คืนระบบจากภัยพิบัติ (Disaster Recovery Plan) ร่วมกับผู้บริหาร', 'medium', 'multiple_choice', 'RPO วัดปริมาณข้อมูลที่ธุรกิจยอมให้สูญหายย้อนหลังได้ (เช่น ข้อมูลหายได้ไม่เกิน 15 นาที = ต้องซิงก์หรือ Backup ทุก 15 นาที) ส่วน RTO วัดระยะเวลาที่ระบบต้องใช้ในการกู้คืนจนกลับมาเปิดให้บริการได้อีกครั้งหลังเกิดเหตุล่ม', '{rpo,rto,disaster-recovery,sla}', true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.questions VALUES ('568dc972-faec-464f-ad31-e4e8daafcde6', 'tools:02-gns3:q01', 11, '9a90cb58-d93b-420d-b47b-7cb59fd88ba0', 'ความแตกต่างพื้นฐานที่สำคัญที่สุดระหว่าง Network Simulator (เช่น Packet Tracer) กับ Network Emulator (เช่น GNS3 หรือ EVE-NG) คือข้อใด?', 'การเลือกเครื่องมือสำหรับฝึกทำแล็บระดับสูง CCNP/CCIE และงานออกแบบระบบเครือข่าย', 'easy', 'multiple_choice', 'Simulator เขียนโปรแกรมเลียนแบบพฤติกรรมและมีชุดคำสั่งจำกัด ส่วน Emulator จำลองฮาร์ดแวร์เสมือนแล้วนำ "ระบบปฏิบัติการจริง (Real OS Image)" เช่น Cisco IOS, Juniper Junos, FortiOS มาบูตทำงาน จึงได้ฟังก์ชันและพฤติกรรมเหมือนอุปกรณ์จริง 100%', '{tools,gns3,emulator,simulator}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('7ee858e7-a270-4176-97df-b0535c488c4b', 'troubleshooting:07-backup-dr:q03', 6, 'efdde8b7-94d1-4638-bb7d-cc05c37f6634', 'บริษัทตั้งเวลาทำ "Full Backup" ทุกคืนวันอาทิตย์ และทำ "Incremental Backup" ทุกคืนวันจันทร์ถึงวันเสาร์ หากเซิร์ฟเวอร์พังในเช้าวันพฤหัสบดี ผู้ดูแลระบบจะต้องใช้ไฟล์ Backup ชุดใดบ้างในการกู้คืนข้อมูลให้กลับมาครบถ้วนถึงคืนวันพุธ?', 'การวางแผนและคำนวณชุดข้อมูลที่ต้องใช้ในการทำ Data Restore', 'medium', 'multiple_choice', 'Incremental Backup จะเก็บเฉพาะข้อมูลที่เปลี่ยนแปลงนับจาก Backup ครั้งก่อนหน้า (วันต่อวัน) ดังนั้นการกู้คืนจนถึงวันพุธ ต้องเริ่มจาก Full Backup ของวันอาทิตย์ แล้วนำ Incremental ของวันจันทร์ + วันอังคาร + วันพุธ มาต่อกันตามลำดับห้ามขาดแม้แต่วันเดียว', '{backup,incremental,differential,restore}', true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.questions VALUES ('01178e2b-5bd0-469a-b6ac-eb8e42962154', 'troubleshooting:07-backup-dr:q04', 6, 'efdde8b7-94d1-4638-bb7d-cc05c37f6634', 'เหตุใดในยุคที่การโจมตีด้วยไวรัสเรียกค่าไถ่ (Ransomware) ระบาดหนัก องค์กรจึงต้องมีสำเนาข้อมูลแบบ "Immutable Backup (WORM)" หรือ "Air-Gapped Backup" เพิ่มเติมจากการสำรองข้อมูลลง NAS ที่เชื่อมต่ออยู่ในเครือข่ายปกติ?', 'การป้องกันไม่ให้ข้อมูลสำรองถูกทำลายไปพร้อมกับเซิร์ฟเวอร์หลักเมื่อถูกโจมตีทางไซเบอร์', 'easy', 'multiple_choice', 'Ransomware สมัยใหม่ไม่ได้เข้ารหัสแค่ไฟล์ในเครื่องเหยื่อ แต่จะสแกนหา Network Share / NAS และเซิร์ฟเวอร์ Backup ที่ต่ออยู่ในเครือข่ายเพื่อสั่งลบหรือเข้ารหัสไฟล์ Backup ทิ้งด้วย การทำ Immutable (ห้ามลบ/ห้ามแก้ภายในระยะเวลาที่ล็อกไว้) หรือ Air-Gapped (ตัดขาดจากเครือข่าย) จึงเป็นปราการด่านสุดท้ายที่รับประกันว่าจะมีไฟล์สะอาดไว้กู้คืนแน่นอน', '{backup,ransomware,immutable,air-gap,security}', true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.questions VALUES ('12b0b468-bbe8-4508-915b-2ad193586103', 'troubleshooting:07-backup-dr:q05', 6, 'efdde8b7-94d1-4638-bb7d-cc05c37f6634', 'เมื่อพนักงานโทรแจ้ง Helpdesk ด้วยความตกใจว่า "ไฟล์ในเครื่องกำลังถูกเปลี่ยนนามสกุลเป็นรหัสแปลกๆ และหน้าจอขึ้นข้อความเรียกค่าไถ่ (Ransomware)" สิ่งแรกสุดที่เจ้าหน้าที่ IT Support ต้องสั่งให้ทำทันทีคือข้อใด?', 'การตอบสนองต่อเหตุการณ์ด้านความปลอดภัย (Incident Response - Containment) ในวินาทีแรก', 'easy', 'multiple_choice', 'หัวใจสำคัญที่สุดในวินาทีแรกที่พบการติดเชื้อ Ransomware คือการจำกัดวงความเสียหาย (Containment / Isolation) โดยต้องดึงสาย LAN ออกและปิด Wi-Fi ทันที เพื่อตัดขาดเครื่องนั้นออกจากเครือข่าย ไม่ให้มัลแวร์วิ่งผ่านพอร์ต SMB ไปเข้ารหัสทำลายไฟล์บน File Server ของทั้งบริษัท', '{ransomware,incident-response,security,containment}', true, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.questions VALUES ('f03f5c64-7d5e-4964-9ad8-bff75f35a6f5', 'datacenter:11-equip:q01', 10, '681252fc-9293-40e3-9100-c19b27e9f69c', 'เมื่อช่างเทคนิคต้องการตรวจสอบว่าสายไฟเบอร์ออปติกเส้นหนึ่งในแผงพักสาย (ODF) ไปโผล่ที่พอร์ตไหนของอีกตู้หนึ่ง หรือต้องการตรวจดูว่าสายไฟเบอร์หักงอขาดในบริเวณใด ควรเลือกใช้เครื่องมือชนิดใด?', 'การเลือกใช้เครื่องมือตรวจสอบสายไฟเบอร์ออปติกหน้างาน Data Center', 'easy', 'multiple_choice', 'VFL (Visual Fault Locator) หรือปากกายิงแสงเลเซอร์สีแดง (ความยาวคลื่น 650 nm ที่ตามองเห็นได้) ใช้ยิงแสงเข้าไปในแกนสายไฟเบอร์เพื่อดูปลายทางของสาย และหากสายหักงอหรือขาด แสงสีแดงจะรั่วสว่างออกมาตรงจุดที่เสียหายทันที', '{datacenter,vfl,fiber,tools}', true, '2026-11-10 13:22:20.548088+00', '2026-11-10 13:22:20.548088+00');
INSERT INTO public.questions VALUES ('3f1df441-85cc-45d3-9b85-504478cb0d29', 'datacenter:11-equip:q02', 10, '681252fc-9293-40e3-9100-c19b27e9f69c', 'หากเสียบสายไฟเบอร์เข้ากับโมดูล SFP+ บนสวิตช์แล้วไฟสถานะพอร์ตไม่ติด (Link Down) ช่างจึงถอดสายไฟเบอร์ออก แล้วนำ "หัวอุด Fiber Loopback Plug" เสียบเข้าที่ตัว SFP+ โดยตรง ปรากฏว่าไฟสถานะพอร์ตเปลี่ยนเป็นสีเขียว (Link Up) ทันที ข้อสรุปใดถูกต้อง?', 'การใช้เทคนิค Loopback Test เพื่อแยกแยะปัญหาพอร์ตสวิตช์/SFP กับสายเคเบิล', 'medium', 'multiple_choice', 'หัว Loopback ทำหน้าที่วนสัญญาณขาส่ง (Tx) กลับเข้าขารับ (Rx) ของตัว SFP+ เอง เมื่อเสียบแล้วไฟพอร์ตติดสีเขียว แสดงว่าทั้งพอร์ตของสวิตช์และตัวโมดูล SFP+ ทำงานส่งและรับแสงได้สมบูรณ์ 100% ปัญหาจึงเกิดจากสายไฟเบอร์หรืออุปกรณ์ปลายทางอีกฝั่งแน่นอน', '{datacenter,loopback,sfp,troubleshooting}', true, '2026-11-10 13:22:20.548088+00', '2026-11-10 13:22:20.548088+00');
INSERT INTO public.questions VALUES ('5ebf818c-bdc8-4cf2-86d7-b46f7a87c14c', 'datacenter:11-equip:q04', 10, '681252fc-9293-40e3-9100-c19b27e9f69c', 'เหตุใดมาตรฐานการจัดการตู้แร็คใน Data Center จึงกำหนดให้ต้องนำแผ่นทึบที่เรียกว่า "Blanking Panel (Filler Panel)" ไปปิดทับช่อง U ที่ว่างอยู่ด้านหน้าตู้แร็คเสมอ?', 'การควบคุมทิศทางการไหลเวียนอากาศ (Airflow Management) ภายในตู้แร็ค 42U', 'easy', 'multiple_choice', 'หากปล่อยช่อง U ด้านหน้าตู้แร็คให้ว่างโบ๋ ลมร้อนที่ถูกเป่าออกทางด้านหลังตู้จะไหลย้อนผ่านช่องว่างนั้นวนกลับมาเข้าด้านหน้าของเซิร์ฟเวอร์ตัวข้างเคียง (Hot Air Recirculation) ทำให้เซิร์ฟเวอร์ดูดลมร้อนกลับเข้าไปจนอุณหภูมิสูงขึ้น', '{datacenter,rack,blanking-panel,cooling,airflow}', true, '2026-11-10 13:22:20.548088+00', '2026-11-10 13:22:20.548088+00');
INSERT INTO public.questions VALUES ('197578ef-435e-4bf8-b842-3791da759a4c', 'datacenter:11-equip:q05', 10, '681252fc-9293-40e3-9100-c19b27e9f69c', 'ในการนำสาย Console (USB-to-RJ45 Rollover Cable) ไปเสียบเข้าพอร์ต CONSOLE ของ Network Switch หน้าตู้แร็ค ค่าพารามิเตอร์มาตรฐานสากล (Serial Configuration) ที่ต้องตั้งในโปรแกรม PuTTY คือข้อใด?', 'การเชื่อมต่อเข้าตั้งค่า Switch หรือ Router ครั้งแรกผ่านพอร์ต Serial Console หน้าเครื่อง', 'medium', 'multiple_choice', 'ค่ามาตรฐานสากลของพอร์ต Serial Console บนอุปกรณ์เครือข่าย (Cisco, Juniper, Aruba, HPE) คือ 9600-8-N-1 ได้แก่ Baud rate (Speed) = 9600, Data bits = 8, Parity = None, Stop bits = 1 และ Flow control = None', '{datacenter,console,serial,9600-8n1,switch}', true, '2026-11-10 13:22:20.548088+00', '2026-11-10 13:22:20.548088+00');
INSERT INTO public.questions VALUES ('a52403ec-d3a6-4da0-9422-08738063d262', 'network:11-design:q01', 2, '3e090998-8642-4e35-af78-02f95246485a', 'ในสถาปัตยกรรมเครือข่ายแบบ 3-Tier Model (Core, Distribution, Access) ชั้นใดมีหน้าที่หลักในการนำส่งแพ็กเก็ตด้วยความเร็วสูงสุด (High-Speed Switching) โดยมีกฎเหล็กว่าห้ามเปิดใช้ ACLs หรือ Packet Filtering ที่ซับซ้อนในชั้นนี้เพื่อไม่ให้กระทบประสิทธิภาพ?', 'การออกแบบระบบเครือข่ายของแคมปัสองค์กรตามหลักการของ Cisco', 'easy', 'multiple_choice', 'Core Layer มีหน้าที่เพียงอย่างเดียวคือการสลับและส่งผ่านทราฟฟิกจำนวนมหาศาลด้วยความเร็วสูงสุด ดังนั้นจึงห้ามนำงานตรวจสอบความปลอดภัย เช่น ACLs, Packet Filtering หรือการประมวลผลที่ซับซ้อนมาไว้ในชั้นนี้ โดยงานเหล่านั้นจะถูกผลักไปไว้ที่ชั้น Distribution Layer แทน', '{network,network-design,3-tier,core-layer}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('0c0e2c5e-3d78-42c0-b521-d904e7ee48b9', 'network:11-design:q02', 2, '3e090998-8642-4e35-af78-02f95246485a', 'เหตุผลหลักที่ศูนย์ข้อมูล (Data Center) ยุคใหม่เปลี่ยนจากสถาปัตยกรรม 3-Tier มาใช้ "Spine-Leaf Architecture" คือข้อใด?', 'การออกแบบเครือข่ายเพื่อรองรับ Cloud Computing และ Microservices ใน Data Center', 'medium', 'multiple_choice', 'ใน Data Center ยุคใหม่ ทราฟฟิกส่วนใหญ่เป็นแบบ East-West (เครื่องเซิร์ฟเวอร์คุยกันเองภายใน) ซึ่ง Spine-Leaf ออกแบบมาให้ Leaf ทุกตัวเชื่อมกับ Spine ทุกตัว ทำให้การคุยข้ามตู้แร็คมีระยะทางเพียง 2 Hops เสมอ และใช้ ECMP วิ่งทุกท่อพร้อมกันโดยไม่ถูก STP บล็อก', '{network,spine-leaf,datacenter,architecture}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('a8a4e9a3-b5ff-4059-97c5-1ea9fd24f1f4', 'network:11-design:q03', 2, '3e090998-8642-4e35-af78-02f95246485a', 'โปรโตคอลมาตรฐานเปิดสากล (Open Standard) ในข้อใดที่ใช้สร้าง Virtual Default Gateway ร่วมกันระหว่างเราเตอร์/สวิตช์ 2 ตัว เพื่อป้องกันไม่ให้เครื่องลูกข่ายออกอินเทอร์เน็ตไม่ได้เมื่อเราเตอร์ตัวหลักดับลง?', 'การทำ First Hop Redundancy Protocol (FHRP) ระหว่างอุปกรณ์ต่างยี่ห้อ', 'easy', 'multiple_choice', 'VRRP (Virtual Router Redundancy Protocol) เป็นมาตรฐานเปิดสากล (RFC 5798) ที่รองรับการทำ Virtual Gateway บนอุปกรณ์ทุกยี่ห้อ ส่วน HSRP เป็นโปรโตคอลเฉพาะของ Cisco', '{network,vrrp,hsrp,redundancy,fhrp}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('58226d42-ba11-4316-b7ed-a5926488badd', 'network:11-design:q04', 2, '3e090998-8642-4e35-af78-02f95246485a', 'เทคโนโลยีใดที่ช่วยให้สวิตช์คู่หนึ่ง (เช่น Cisco Nexus) ทำงานร่วมกันเสมือนเป็นสวิตช์ตัวเดียว ทำให้เซิร์ฟเวอร์สามารถรวมสายแลน 2 เส้นด้วย LACP ต่อแยกไปยังสวิตช์คนละตู้ได้ เพื่อป้องกันปัญหา Single Point of Failure ระดับตู้สวิตช์?', 'การออกแบบการเชื่อมต่อสาย Dual Uplink จาก Server ไปยัง Top-of-Rack Switch คู่', 'medium', 'multiple_choice', 'Cisco vPC (Virtual Port Channel) หรือ Multi-chassis EtherChannel ช่วยให้พอร์ตจากสวิตช์สองตัวที่แยกจากกันทางกายภาพ ทำงานเป็น Port Channel เดียวกันเชื่อมต่อเข้ากับเซิร์ฟเวอร์ลูกได้', '{network,vpc,lacp,etherchannel,redundancy}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('2078e3ed-e858-4d2a-b8b4-e0ee255ac29c', 'network:11-design:q05', 2, '3e090998-8642-4e35-af78-02f95246485a', 'ตามหลักการออกแบบความปลอดภัยของโซน DMZ (Demilitarized Zone) ข้อใดคือกฎเหล็กที่สำคัญที่สุดในการป้องกันการโจมตีทะลุเข้าสู่ระบบฐานข้อมูลภายใน?', 'การออกแบบสถาปัตยกรรม Firewall แบ่งแยกโซน Web, DMZ และ Internal Database', 'medium', 'multiple_choice', 'กฎเหล็กของ DMZ คือ อนุญาตให้คนภายนอกเรียกเข้า DMZ ได้ และอนุญาตให้ภายในเรียกเข้า DMZ ได้ แต่ "ห้ามให้เซิร์ฟเวอร์ใน DMZ เป็นผู้ริเริ่มสร้างการเชื่อมต่อไปยังเครือข่ายภายใน (Initiate Connection to Internal)" หากเว็บถูกยึด คนร้ายจะไม่สามารถสั่งโจมตีเจาะระบบฐานข้อมูลภายในได้โดยตรง', '{network,dmz,firewall,security,architecture}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('a727b57c-471f-4098-baa1-0369e65a00ee', 'tools:01-packet-tracer:q01', 11, '93a91167-81c5-4497-a769-3930c59a54b1', 'Cisco Packet Tracer จัดเป็นซอฟต์แวร์ประเภทใด และมีความแตกต่างจาก Network Emulator อย่าง GNS3 หรือ EVE-NG อย่างไร?', 'การทำความเข้าใจขีดความสามารถและข้อจำกัดของเครื่องมือจำลองเครือข่าย', 'easy', 'multiple_choice', 'Packet Tracer เป็น Network Simulator (โปรแกรมจำลองพฤติกรรม) ที่เลียนแบบการทำงานและคำสั่งของ Cisco IOS โดยไม่ได้รันไฟล์ระบบปฏิบัติการจริง จึงกินทรัพยากรเครื่องน้อยมาก แต่รองรับชุดคำสั่งจำกัดเฉพาะที่โปรแกรมสร้างไว้ ต่างจาก GNS3/EVE-NG ที่เป็น Emulator รันระบบปฏิบัติการจริง', '{tools,cisco-packet-tracer,simulator,network}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('06567e5a-aea4-4301-889e-31d49ac89174', 'tools:01-packet-tracer:q02', 11, '93a91167-81c5-4497-a769-3930c59a54b1', 'ในโปรแกรม Cisco Packet Tracer โหมดการทำงาน "Simulation Mode" มีจุดเด่นสำคัญที่แตกต่างจาก "Realtime Mode" อย่างไร?', 'การฝึกหัดวิเคราะห์การเดินทางของแพ็กเก็ตและโปรโตคอล ARP/ICMP', 'easy', 'multiple_choice', 'ใน Simulation Mode เวลาในเครือข่ายจะหยุดนิ่ง และผู้ใช้สามารถกดเดินหน้า (Capture/Forward) เพื่อดูซองจดหมาย PDU เดินทางทีละก้าว พร้อมคลิกเปิดดู Header ของแต่ละเลเยอร์ใน OSI Model (Layer 1-7) ได้อย่างละเอียด', '{tools,packet-tracer,simulation-mode,pdu}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('854a5934-7449-45be-80a5-c32b00b0208c', 'tools:01-packet-tracer:q03', 11, '93a91167-81c5-4497-a769-3930c59a54b1', 'เมื่อต่อสายแลนระหว่าง Switch กับ PC ในโหมด Realtime แล้วพบว่าไฟพอร์ตที่สวิตช์ขึ้นเป็น "สีส้ม" นานประมาณ 30–50 วินาทีก่อนจะเปลี่ยนเป็นสีเขียว อาการนี้เกิดจากสาเหตุใดและสามารถกดเร่งเวลาได้อย่างไร?', 'พฤติกรรมการทำงานของ Spanning Tree Protocol (STP) บนสวิตช์ Cisco', 'medium', 'multiple_choice', 'ไฟสีส้มเกิดจากกระบวนการทำงานปกติของ Spanning Tree Protocol (STP) ที่กำลังตรวจสอบสถานะ Listening และ Learning เพื่อป้องกัน Loop และใน Packet Tracer สามารถกดปุ่ม "Fast Forward Time (Alt + D)" เพื่อเร่งเวลาข้ามการรอคอยได้ทันที', '{tools,packet-tracer,stp,spanning-tree}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('a665524c-1dcd-4cb9-af0f-3c7110e65a72', 'tools:01-packet-tracer:q04', 11, '93a91167-81c5-4497-a769-3930c59a54b1', 'หากต้องการเชื่อมต่อระหว่างคอมพิวเตอร์ PC เข้ากับพอร์ต CONSOLE ของ Cisco Switch ใน Packet Tracer เพื่อพิมพ์คำสั่งคอนฟิก IOS ผ่านโปรแกรม Terminal เสมือน จะต้องเลือกใช้สายเคเบิลชนิดใดในโปรแกรม?', 'การต่อสายเพื่อเข้าตั้งค่าอุปกรณ์เครือข่ายครั้งแรก (Out-of-Band Management)', 'easy', 'multiple_choice', 'สาย Console ในโปรแกรม Packet Tracer มีสัญลักษณ์เป็นสายสีฟ้าอ่อน (Rollover Cable) เชื่อมจากพอร์ต RS 232 หรือ USB ของ PC เข้ากับพอร์ต CONSOLE ของ Switch/Router', '{tools,packet-tracer,console,cabling}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('1b69be04-7692-4128-a45d-4e898b67651b', 'tools:01-packet-tracer:q05', 11, '93a91167-81c5-4497-a769-3930c59a54b1', 'ไฟล์นามสกุล ".pka" ในโปรแกรม Cisco Packet Tracer มีคุณลักษณะพิเศษที่แตกต่างจากไฟล์ ".pkt" ทั่วไปอย่างไร?', 'การทำแบบฝึกหัดและข้อสอบในหลักสูตร Cisco Networking Academy', 'easy', 'multiple_choice', 'ไฟล์ .pka (Packet Tracer Activity) คือไฟล์ข้อสอบหรือแล็บแบบฝึกหัดที่มีการล็อก Topology ไว้ มีหน้าต่างโจทย์แนะนำขั้นตอน และมีระบบตรวจวัดคะแนนความถูกต้อง (Completion Percentage) แบบอัตโนมัติ', '{tools,packet-tracer,pka,pkt,certification}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('bab6c130-fd6a-4bcd-b882-377783f5af02', 'tools:02-gns3:q02', 11, '9a90cb58-d93b-420d-b47b-7cb59fd88ba0', 'ในการใช้งาน GNS3 ร่วมกับอิมเมจเราเตอร์ตระกูลเก่าของ Dynamips (เช่น Cisco 3725 หรือ 7200) เหตุใดช่างเทคนิคจึงต้องกดคำนวณและตั้งค่า "Idle-PC"?', 'การแก้ปัญหาคอมพิวเตอร์ทำงานหนักและพัดลมหมุนเสียงดังเมื่อเปิดรันเราเตอร์ใน GNS3', 'medium', 'multiple_choice', 'เราเตอร์ของจริงไม่มีกลไกหยุดหมุนรอบ CPU เมื่อว่างงาน เมื่อนำอิมเมจมาบูตบน PC ตัวโปรแกรมจะกิน CPU คอมพิวเตอร์ 100% เต็ม การคำนวณและใส่ค่า Idle-PC จะช่วยบอก GNS3 ให้สั่งหยุดการทำงานของลูปว่าง (Idle loop) ทำให้การใช้งาน CPU ของเครื่องลดลงเหลือเพียง 1-2%', '{tools,gns3,dynamips,idle-pc,performance}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('f01fc036-5329-41fe-9b18-f53eb57ef654', 'tools:02-gns3:q03', 11, '9a90cb58-d93b-420d-b47b-7cb59fd88ba0', 'เหตุใดแนวทางปฏิบัติที่ดีที่สุด (Best Practice) ในการติดตั้ง GNS3 บนคอมพิวเตอร์ยุคปัจจุบัน จึงแนะนำให้รันร่วมกับ "GNS3 VM" บน VMware หรือ VirtualBox แทนการรันบนระบบปฏิบัติการหลักโดยตรง?', 'การวางสถาปัตยกรรมระบบสำหรับทำแล็บเสมือนที่มีเราเตอร์และอุปกรณ์จำนวนมาก', 'medium', 'multiple_choice', 'ระบบปฏิบัติการเราเตอร์ยุคใหม่ส่วนใหญ่ทำงานบน QEMU/KVM, IOU และ Docker ซึ่งต้องการ Linux Kernel และระบบ Nested Virtualization ทำให้การรันบน GNS3 VM (ที่เป็น Linux) มีความเสถียร ประสิทธิภาพสูงกว่า และรองรับอิมเมจได้หลากหลายกว่าการรันบน Windows โดยตรง', '{tools,gns3,gns3-vm,virtualization,qemu}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('09b67e70-88d1-4ad7-8214-29e1433c3b30', 'tools:02-gns3:q04', 11, '9a90cb58-d93b-420d-b47b-7cb59fd88ba0', 'หากวิศวกรต้องการตรวจสอบการทำงานของแพ็กเก็ตที่วิ่งผ่านสายสัญญาณระหว่างเราเตอร์ 2 ตัวใน GNS3 อย่างละเอียดแบบเรียลไทม์ ฟีเจอร์ใดของ GNS3 ที่ตอบโจทย์การทำงานนี้ได้ดีที่สุด?', 'การวิเคราะห์ปัญหา OSPF Neighbor ไม่ขึ้นในแล็บเสมือน', 'easy', 'multiple_choice', 'GNS3 มีความสามารถผสานการทำงานกับ Wireshark ในตัว เพียงแค่คลิกขวาที่สายเชื่อมต่อแล้วเลือก "Start Capture" โปรแกรม Wireshark ตัวจริงจะเปิดขึ้นมาดักจับแพ็กเก็ตที่วิ่งผ่านสายเส้นนั้นได้แบบสดๆ', '{tools,gns3,wireshark,packet-capture}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('c029cd6e-d453-43e2-9215-ccfdfde2dd1a', 'tools:02-gns3:q05', 11, '9a90cb58-d93b-420d-b47b-7cb59fd88ba0', 'โหนดประเภทใดใน GNS3 ที่ใช้สำหรับการเชื่อมต่อ (Bridge) เครือข่ายเสมือนภายในแล็บ ให้ออกสู่อินเทอร์เน็ตจริง หรือเชื่อมต่อกับเน็ตเวิร์กการ์ด (NIC) ของคอมพิวเตอร์จริงภายนอกได้?', 'การทำให้อุปกรณ์เราเตอร์ในแล็บ GNS3 สามารถทดสอบ ping ออก 8.8.8.8 บนอินเทอร์เน็ตจริง', 'easy', 'multiple_choice', 'Cloud Node หรือ NAT Node ใน GNS3 ทำหน้าที่บริดจ์พอร์ตเสมือนเข้ากับอินเทอร์เฟซจริงของการ์ดแลน/Wi-Fi บนเครื่องจริง ทำให้เครื่องในแล็บสามารถรับ IP และวิ่งออกสู่อินเทอร์เน็ตภายนอกได้', '{tools,gns3,cloud-node,nat,bridging}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('5f156ae1-1e17-450b-8749-f9e0c3e70abd', 'tools:03-wireshark:q01', 11, 'e0a4cdec-9071-4a41-bc6a-0aa782e85680', 'ความแตกต่างที่สำคัญที่สุดระหว่าง "Capture Filter" และ "Display Filter" ในโปรแกรม Wireshark คือข้อใด?', 'การเลือกใช้งานตัวกรองข้อมูลขณะดักจับทราฟฟิกเครือข่ายความเร็วสูง', 'medium', 'multiple_choice', 'Capture Filter ทำงานก่อนการบันทึก (ใช้ไวยากรณ์ BPF เช่น "port 80") แพ็กเก็ตที่ไม่ตรงเงื่อนไขจะถูกทิ้งทันทีช่วยประหยัดเนื้อที่ RAM/Disk ส่วน Display Filter ทำงานหลังจากการดักจับแล้ว (ใช้ไวยากรณ์ เช่น "http.response.code == 404") โดยสามารถเปลี่ยนมุมมองฟิลเตอร์ไปมาได้ตลอดเวลาโดยข้อมูลดิบไม่สูญหาย', '{tools,wireshark,filters,packet-capture}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('41b6c586-ddea-48bd-82a2-898b85af31b7', 'tools:03-wireshark:q02', 11, 'e0a4cdec-9071-4a41-bc6a-0aa782e85680', 'หากต้องการกรองดูเฉพาะแพ็กเก็ตที่เกิดปัญหาการส่งข้อมูลซ้ำเนื่องจากเครือข่ายมี Packet Loss (TCP Retransmission) บนแถบ Display Filter ของ Wireshark ควรใช้คำสั่งใด?', 'การวิเคราะห์ปัญหาแอปพลิเคชันทำงานช้าและสงสัยว่ามีสัญญาณดรอปบนลิงก์เครือข่าย', 'easy', 'multiple_choice', 'คำสั่ง "tcp.analysis.retransmission" เป็น Display Filter ในตัวของ Wireshark ที่ใช้กรองแสดงเฉพาะแพ็กเก็ตที่ถูกส่งซ้ำเนื่องจากไม่ได้รับ ACK ภายในเวลาที่กำหนด', '{tools,wireshark,tcp,retransmission,troubleshooting}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('6d0e94d0-a2a7-44fc-9f1d-476523f2d61e', 'tools:03-wireshark:q03', 11, 'e0a4cdec-9071-4a41-bc6a-0aa782e85680', 'ฟีเจอร์ "Follow TCP Stream" ในโปรแกรม Wireshark มีประโยชน์อย่างไรต่องานวิเคราะห์ปัญหาของทีม Support?', 'การตรวจสอบเนื้อหาข้อความการสนทนาระหว่าง Client กับ Web Server', 'easy', 'multiple_choice', 'Follow TCP Stream จะรวมรวมแพ็กเก็ตทั้งหมดของเซสชัน TCP นั้นมาเรียงต่อกันและถอดรหัสเป็นข้อความบทสนทนา (Application Payload) แสดงในหน้าต่างเดียว โดยแยกสีระหว่างข้อความที่ Client ส่งไป (สีแดง) และข้อความที่ Server ตอบกลับ (สีน้ำเงิน)', '{tools,wireshark,follow-tcp-stream,support}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('d135eb3b-8119-4b9e-a8a7-d02cbe474d93', 'tools:03-wireshark:q04', 11, 'e0a4cdec-9071-4a41-bc6a-0aa782e85680', 'เมื่อวิเคราะห์ไฟล์ดักจับแพ็กเก็ตแล้วพบข้อความเตือนในหมวด TCP Analysis ว่า "TCP ZeroWindow" อาการนี้สะท้อนถึงปัญหาทางเทคนิคใด?', 'การตรวจสอบสาเหตุที่การโอนย้ายไฟล์ขนาดใหญ่เกิดอาการค้างและชะงักเป็นระยะ', 'medium', 'multiple_choice', 'TCP ZeroWindow หมายถึง บัฟเฟอร์ขารับ (Receive Buffer) ของเครื่องปลายทางเต็ม จนไม่สามารถรับข้อมูลเพิ่มได้ จึงส่งแพ็กเก็ตบอกฝั่งส่งให้หยุดส่งข้อมูลชั่วคราว มักเกิดจากเครื่องปลายทาง CPU สูง หรือดิสก์เขียนข้อมูลไม่ทัน', '{tools,wireshark,tcp,zerowindow,performance}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('6d64dc59-ddea-4533-8979-6b8ea6f9f142', 'tools:03-wireshark:q05', 11, 'e0a4cdec-9071-4a41-bc6a-0aa782e85680', 'ในแถบสีแสดงผลเริ่มต้นของ Wireshark (Coloring Rules) บรรทัดของแพ็กเก็ตที่มี "พื้นหลังสีดำและตัวอักษรสีแดง" มักสื่อถึงเหตุการณ์ประเภทใด?', 'การสังเกตความผิดปกติของเครือข่ายอย่างรวดเร็วผ่านสายตา (Visual Inspection)', 'easy', 'multiple_choice', 'ตามกฎการระบายสีเริ่มต้นของ Wireshark แถบสีดำตัวหนังสือสีแดงถูกสงวนไว้สำหรับข้อผิดพลาดของโพรโทคอล TCP เช่น TCP RST (Reset / ปฏิเสธการเชื่อมต่อ), Retransmission หรือ Checksum Error', '{tools,wireshark,coloring-rules,tcp-error}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('9f476cd4-a948-43f9-b90d-84b81fd323eb', 'tools:04-nmap-iperf:q01', 11, '3b325ae8-b7e2-4b0a-b86d-8e2bef22bd87', 'เมื่อรันคำสั่ง Nmap สแกนพอร์ตไปยังเซิร์ฟเวอร์ปลายทางแล้วผลลัพธ์แสดงสถานะของพอร์ตเป็น "filtered" ความหมายที่ถูกต้องที่สุดคือข้อใด?', 'การตรวจสอบผลการสแกนพอร์ตเพื่อวิเคราะห์ปัญหาการเข้าถึงบริการ', 'easy', 'multiple_choice', 'สถานะ "filtered" หมายความว่า Nmap ไม่สามารถระบุได้ว่าพอร์ตนั้นเปิดหรือปิดอยู่ เนื่องจากแพ็กเก็ตถูกไฟร์วอลล์ (Firewall), ตัวกรองแพ็กเก็ต (Packet Filter) หรือกฎ ACL บล็อกไว้ทำให้ไม่มีการตอบกลับมายังเครื่องสแกน', '{tools,nmap,port-scanning,firewall}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('e4a1fbaa-6e2c-410a-90ac-765d08fe8cac', 'tools:04-nmap-iperf:q02', 11, '3b325ae8-b7e2-4b0a-b86d-8e2bef22bd87', 'การสแกนพอร์ตด้วย Nmap แบบ "TCP SYN Scan (-sS)" หรือ Stealth Scan มีข้อดีอย่างไรเมื่อเทียบกับ TCP Connect Scan (-sT)?', 'การเลือกโหมดการสแกนพอร์ตที่รวดเร็วและไม่สร้างภาระให้แอปพลิเคชันบนเซิร์ฟเวอร์', 'medium', 'multiple_choice', 'TCP SYN Scan (-sS) เป็นการสแกนแบบกึ่งเปิด (Half-open) โดยส่งแพ็กเก็ต SYN ไป เมื่อเซิร์ฟเวอร์ตอบ SYN-ACK กลับมา Nmap จะส่ง RST ไปตัดการเชื่อมต่อทันทีโดยไม่ส่ง ACK ขั้นสุดท้าย ทำให้ไม่เกิดการเชื่อมต่อสมบูรณ์ จึงไม่ถูกบันทึกใน Application Log ของเซิร์ฟเวอร์ส่วนใหญ่และทำงานเร็วกว่า', '{tools,nmap,tcp-syn-scan,security}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('73ff1c39-1bb8-4053-906a-d70a3304293d', 'tools:04-nmap-iperf:q03', 11, '3b325ae8-b7e2-4b0a-b86d-8e2bef22bd87', 'เหตุใดการทดสอบความเร็วแบนด์วิดท์ของลิงก์เครือข่ายด้วย "iPerf3" จึงให้ผลลัพธ์ที่แม่นยำกว่าการทดสอบด้วยการดาวน์โหลดไฟล์ขนาดใหญ่ผ่านโฟลเดอร์แชร์ SMB/Windows?', 'การตรวจรับมอบสายเช่าสัญญาณ (Leased Line 1 Gbps) ระหว่างสองสาขา', 'easy', 'multiple_choice', 'การดาวน์โหลดไฟล์จริงจะติดคอขวดที่ความเร็วการอ่านเขียนของฮาร์ดดิสก์ (Disk I/O) และ Overhead ของโพรโทคอล SMB ส่วน iPerf3 สร้างข้อมูลสังเคราะห์บนหน่วยความจำ RAM โดยตรงแล้วยิงอัดผ่านท่อเน็ตเวิร์ก ทำให้วัดสมรรถนะจริงของระบบเครือข่ายได้ 100%', '{tools,iperf3,bandwidth,throughput,testing}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('ba52ae68-c043-400b-acaf-37a707acee39', 'tools:04-nmap-iperf:q04', 11, '3b325ae8-b7e2-4b0a-b86d-8e2bef22bd87', 'ในการทดสอบประสิทธิภาพเครือข่ายเพื่อประเมินความพร้อมสำหรับระบบโทรศัพท์ไอพี (VoIP) หรือระบบประชุมออนไลน์ การรัน iPerf3 ในโหมด "UDP (-u)" ช่วยวัดค่าสำคัญใดเพิ่มเติมจากโหมด TCP ปกติ?', 'การตรวจสอบคุณภาพเครือข่ายก่อนติดตั้งระบบโทรศัพท์ IP Phone ของสำนักงาน', 'medium', 'multiple_choice', 'ระบบ VoIP ทำงานบน UDP ซึ่งความเสถียรของเสียงขึ้นอยู่กับค่า Jitter (ความสั่นไหวของเวลาหน่วง) และ Packet Loss (การสูญหายของแพ็กเก็ต) ซึ่งคำสั่ง "iperf3 -u" จะแสดงสถิติทั้ง Jitter และ Packet Loss ออกมาอย่างละเอียด', '{tools,iperf3,udp,jitter,voip}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('2dabfa05-a324-432d-ae60-5c73846c9e73', 'tools:04-nmap-iperf:q05', 11, '3b325ae8-b7e2-4b0a-b86d-8e2bef22bd87', 'เมื่อใช้เครื่องมือ "WinMTR" ตรวจสอบเส้นทางเครือข่ายไปยังเซิร์ฟเวอร์ปลายทาง สัญญาณใดที่บ่งบอกว่าเราเตอร์ตัวใดตัวหนึ่งบนเส้นทางคือ "จุดคอขวดหรือจุดที่เกิดปัญหาจริง"?', 'การไล่หาสาเหตุอาการเน็ตเวิร์กกระตุกและหลุดเป็นช่วงๆ', 'easy', 'multiple_choice', 'หากค่า Loss % เกิดขึ้นที่ Hop ใด Hop หนึ่ง แล้วตัวเลข Loss นั้นยังคงส่งผลต่อเนื่องไปยัง Hop ถัดไปจนถึงปลายทาง แสดงว่าเราเตอร์ที่ Hop นั้นเกิดปัญหาจริง (ต่างจากกรณีที่ Hop กลางทางติด Loss ตัวเดียวแต่ Hop ถัดไปเป็น 0% ซึ่งเกิดจากการที่อุปกรณ์ตัวนั้นตั้งค่าลดความสำคัญของการตอบ ICMP)', '{tools,winmtr,mtr,latency,packet-loss}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('b09a3292-b282-4bd5-b1bc-9c369e87d4b5', 'tools:05-mobaxterm:q01', 11, '57df0d37-2e95-4e42-9185-f2ba49596293', 'ฟีเจอร์ "Multi-Execution Mode" ในโปรแกรม MobaXterm มีประโยชน์อย่างไรต่องานดูแลระบบของวิศวกรเครือข่ายและ SysAdmin?', 'การตรวจสอบสถานะและเวอร์ชันของสวิตช์จำนวน 8 ตัวในเวลาเดียวกัน', 'easy', 'multiple_choice', 'Multi-Execution Mode ช่วยให้พิมพ์คำสั่งบนคีย์บอร์ดเพียงครั้งเดียว แล้วคำสั่งนั้นจะถูกส่งไปประมวลผลบนทุกเซสชันหรือแท็บเทอร์มินัลที่เปิดอยู่พร้อมกันทันที ช่วยประหยัดเวลาอย่างมหาศาลในการตรวจเช็กอุปกรณ์หลายเครื่อง', '{tools,mobaxterm,multi-execution,sysadmin}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('2a6d2840-cad2-417a-99c9-0819e078bee2', 'tools:05-mobaxterm:q02', 11, '57df0d37-2e95-4e42-9185-f2ba49596293', 'เมื่อเชื่อมต่อสาย Console (USB-to-RJ45) เข้ากับโน้ตบุ๊กเพื่อตั้งค่าสวิตช์หน้าตู้แร็ค หากไม่ทราบว่าสายแปลงนั้นได้รับหมายเลขพอร์ต COM ใด ช่างเทคนิคสามารถเข้าไปตรวจสอบได้จากเมนูใดของระบบปฏิบัติการ Windows?', 'ขั้นตอนการตรวจสอบพอร์ต Serial ก่อนเริ่มการเชื่อมต่อผ่าน Terminal Emulator', 'easy', 'multiple_choice', 'สามารถตรวจสอบหมายเลขพอร์ต COM ได้จาก Device Manager (ตัวจัดการอุปกรณ์) ภายใต้หมวดหมู่ Ports (COM & LPT) ซึ่งจะแสดงชื่อพอร์ต เช่น COM3 หรือ COM4', '{tools,serial,com-port,device-manager,console}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('fbf79fd2-d9f5-4d67-ae52-1d301301aa23', 'tools:05-mobaxterm:q03', 11, '57df0d37-2e95-4e42-9185-f2ba49596293', 'การเปิดใช้งาน "X11 Forwarding" ผ่านเซสชัน SSH ในโปรแกรม MobaXterm ช่วยให้ผู้ดูแลระบบสามารถทำสิ่งใดได้?', 'การติดตั้งซอฟต์แวร์บนเซิร์ฟเวอร์ Linux ที่จำเป็นต้องมีหน้าต่างตัวช่วยติดตั้งแบบกราฟิก (GUI Wizard)', 'medium', 'multiple_choice', 'X11 Forwarding ช่วยส่งผ่านหน้าต่างกราฟิก (GUI) ของโปรแกรมที่รันอยู่บน Linux Server ข้ามผ่านช่องทาง SSH มาเรนเดอร์และแสดงผลบนหน้าจอ Windows ของเครื่องลูกข่ายได้โดยตรง โดยที่ตัวเซิร์ฟเวอร์ไม่จำเป็นต้องลง Desktop Environment', '{tools,x11,ssh,mobaxterm,gui}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('064b4c09-3817-47a7-887d-304df38cb2a2', 'tools:05-mobaxterm:q04', 11, '57df0d37-2e95-4e42-9185-f2ba49596293', 'โปรแกรม WinSCP ใช้โปรโตคอลความปลอดภัยมาตรฐานใดในการโอนย้ายไฟล์ระหว่างคอมพิวเตอร์ Windows กับเซิร์ฟเวอร์ Linux และทำงานบนพอร์ตเริ่มต้นหมายเลขใด?', 'การอัปโหลดไฟล์คอนฟิกและไฟล์อิมเมจระบบขึ้นเซิร์ฟเวอร์อย่างปลอดภัย', 'easy', 'multiple_choice', 'WinSCP ใช้โปรโตคอล SFTP (SSH File Transfer Protocol) ซึ่งทำงานอยู่บนช่องทางปลอดภัยของ SSH ผ่านพอร์ตมาตรฐาน TCP 22', '{tools,winscp,sftp,scp,ports}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.questions VALUES ('903470ef-ea5f-4fdf-9738-2d4c4feb90fa', 'tools:05-mobaxterm:q05', 11, '57df0d37-2e95-4e42-9185-f2ba49596293', 'ข้อได้เปรียบสำคัญที่โปรแกรม MobaXterm มอบให้แก่ผู้ใช้งานทันทีที่เปิดเซสชัน SSH เชื่อมต่อไปยัง Linux Server คือข้อใด?', 'การบริหารจัดการไฟล์คอนฟิกบนเซิร์ฟเวอร์โดยไม่ต้องเปิดโปรแกรม FTP แยกต่างหาก', 'easy', 'multiple_choice', 'MobaXterm มีตัวจัดการไฟล์ SFTP ฝังตัวอยู่ทางแถบซ้ายมืออัตโนมัติ (Embedded SFTP Browser) ทำให้สามารถลากไฟล์ไปมาระหว่าง Windows กับ Linux ได้ทันที และสามารถดับเบิลคลิกแก้ไขไฟล์คอนฟิกบน Text Editor ในเครื่องแล้วกดเซฟอัปเดตกลับไปได้เลย', '{tools,mobaxterm,sftp,remote-access}', true, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');


--
-- Data for Name: choices; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.choices VALUES ('375b1883-d9b3-43a3-a52a-66c436aa5d4f', 'c1a10001-0000-0000-0000-000000000002', 'รัน `nginx -t` เพื่อตรวจสอบ Syntax คอนฟิก และตรวจ `journalctl -xeu nginx.service`', true, NULL, 1);
INSERT INTO public.choices VALUES ('2ca9e2be-160b-4026-b8c9-0efc7973cbf8', 'c1a10001-0000-0000-0000-000000000002', 'รีบูตเซิร์ฟเวอร์ทันทีด้วยคำสั่ง `reboot`', false, NULL, 2);
INSERT INTO public.choices VALUES ('cad6c3f3-e140-4412-b13e-0bf0b8e129e1', 'c1a10001-0000-0000-0000-000000000002', 'ลบโฟลเดอร์ `/etc/nginx` แล้วติดตั้งใหม่', false, NULL, 3);
INSERT INTO public.choices VALUES ('94cc0c34-4a10-43e3-ab05-9b1827b88c0e', 'c1a10001-0000-0000-0000-000000000002', 'เปลี่ยนสิทธิ์ทั้งระบบเป็น `chmod 777 -R /`', false, NULL, 4);
INSERT INTO public.choices VALUES ('b8870a3e-f926-41fa-91ef-fce4cf238b65', 'c1a10001-0000-0000-0000-000000000006', 'ยังมีโปรเซสเปิดไฟล์นั้นค้างอยู่ ให้รัน `lsof | grep deleted` และรีสตาร์ทโปรเซสนั้นเพื่อปล่อยพื้นที่', true, NULL, 1);
INSERT INTO public.choices VALUES ('e2829e2a-3830-4bbb-8c7e-b87c3575ac46', 'c1a10001-0000-0000-0000-000000000006', 'Linux ติดไวรัส Ransomware ต้องฟอร์แมตดิสก์', false, NULL, 2);
INSERT INTO public.choices VALUES ('67a82cdf-2d73-4914-8ed6-73967678a3b5', 'c1a10001-0000-0000-0000-000000000006', 'คำสั่ง rm ใช้งานไม่ได้บนไดรฟ์ประเภท ext4', false, NULL, 3);
INSERT INTO public.choices VALUES ('e79a5953-f615-49ba-9f3a-d5bbe50064cf', 'c1a10001-0000-0000-0000-000000000006', 'ต้องรอครบ 24 ชั่วโมง Linux จึงจะรัน Garbage Collection', false, NULL, 4);
INSERT INTO public.choices VALUES ('5077b771-c4d8-4133-aa8a-035b32b864da', 'c1a10001-0000-0000-0000-000000000003', 'เครื่องปลายทางไม่ได้เปิดโปรแกรมหรือ Service รับการเชื่อมต่อที่พอร์ต 8080', true, NULL, 1);
INSERT INTO public.choices VALUES ('88d254f3-b2c3-4ed6-a798-60b0bec45639', 'c1a10001-0000-0000-0000-000000000003', 'สาย LAN ขาด หรือสัญญาณ Wi-Fi หลุด', false, NULL, 2);
INSERT INTO public.choices VALUES ('16592b2c-366e-4158-a33a-a6661fffc822', 'c1a10001-0000-0000-0000-000000000003', 'Domain Name หมดอายุ', false, NULL, 3);
INSERT INTO public.choices VALUES ('20e45227-5d3f-4230-a5c3-cb497cea5398', 'c1a10001-0000-0000-0000-000000000003', 'RAM ของเครื่องลูกข่ายไม่เพียงพอ', false, NULL, 4);
INSERT INTO public.choices VALUES ('cf5e2537-beb6-41df-b902-d3134e90edc2', 'c1a10001-0000-0000-0000-000000000007', 'Backend / Upstream Server ทำงานช้าจนหมดเวลา timeout ไม่ยอมส่งคำตอบกลับมายัง Proxy', true, NULL, 1);
INSERT INTO public.choices VALUES ('d16340db-8b31-45ca-8d2e-bf0c65e393fa', 'c1a10001-0000-0000-0000-000000000007', 'ผู้ใช้พิมพ์ URL ผิด หน้าเว็บไม่มีอยู่จริง', false, NULL, 2);
INSERT INTO public.choices VALUES ('26dd6b8b-c8e9-4538-a8e5-01561b16e538', 'c1a10001-0000-0000-0000-000000000007', 'ผู้ใช้ใส่รหัสผ่านผิดระบบจึงไม่อนุญาต', false, NULL, 3);
INSERT INTO public.choices VALUES ('e49f552c-cce0-46d9-ab08-cfa052e65154', 'c1a10001-0000-0000-0000-000000000007', 'ใบรับรอง SSL/TLS ของเว็บไซต์หมดอายุ', false, NULL, 4);
INSERT INTO public.choices VALUES ('9bd1ee5a-7fcb-4b89-a379-452595550cb0', 'c1a10001-0000-0000-0000-000000000004', 'SELECT e.name, d.dept_name FROM employees e LEFT JOIN departments d ON e.dept_id = d.id', true, NULL, 1);
INSERT INTO public.choices VALUES ('10a87cf5-821f-4e65-bf88-451da5e362b3', 'c1a10001-0000-0000-0000-000000000004', 'SELECT e.name, d.dept_name FROM employees e INNER JOIN departments d ON e.dept_id = d.id', false, NULL, 2);
INSERT INTO public.choices VALUES ('577961b1-9516-448e-8fa8-353799d7a15d', 'c1a10001-0000-0000-0000-000000000004', 'SELECT e.name, d.dept_name FROM employees e RIGHT JOIN departments d ON e.dept_id = d.id', false, NULL, 3);
INSERT INTO public.choices VALUES ('9ab63674-6fea-4031-b301-325754b40cdf', 'c1a10001-0000-0000-0000-000000000004', 'SELECT e.name, d.dept_name FROM employees e CROSS JOIN departments d', false, NULL, 4);
INSERT INTO public.choices VALUES ('7fd97d9c-9ce4-4100-9921-771bd12e13b9', 'c1a10001-0000-0000-0000-000000000005', 'EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 45000 AND status = ''PENDING'';', true, NULL, 1);
INSERT INTO public.choices VALUES ('49fc0340-3878-4e8e-8e95-089a56ecac0a', 'c1a10001-0000-0000-0000-000000000005', 'OPTIMIZE TABLE orders;', false, NULL, 2);
INSERT INTO public.choices VALUES ('438f2f82-db85-413e-b867-c42618a4b3bc', 'c1a10001-0000-0000-0000-000000000005', 'SHOW PROFILE FOR QUERY 1;', false, NULL, 3);
INSERT INTO public.choices VALUES ('5544dddb-517e-4851-9d7d-16217f20f8f4', 'c1a10001-0000-0000-0000-000000000005', 'REINDEX DATABASE postgres;', false, NULL, 4);
INSERT INTO public.choices VALUES ('f544c9df-702e-4322-9033-daab06807065', '48ef625d-f83d-4e25-9661-d28975cfb48c', '100 และ 80', true, 'ถูกต้อง COUNT(*) ได้ 100 แถว และ COUNT(resolved_by) ละเว้น 20 แถวที่เป็น NULL จึงได้ 80', 1);
INSERT INTO public.choices VALUES ('e9ab2a4c-cac8-403c-a62b-238ad5d0a094', '48ef625d-f83d-4e25-9661-d28975cfb48c', '100 และ 100', false, 'COUNT(column) จะไม่นับแถวที่เป็น NULL', 2);
INSERT INTO public.choices VALUES ('70cacd63-b386-4a7e-bc6e-91fa92b3b3c0', '48ef625d-f83d-4e25-9661-d28975cfb48c', '80 และ 80', false, 'COUNT(*) จะนับแถวทั้งหมดเสมอ', 3);
INSERT INTO public.choices VALUES ('0a7c7239-ac60-4ae0-aab8-93a107256beb', 'fed5a2b0-f7b7-4585-869c-d21e36063fab', 'สีเหลืองคือ Single-mode (OS2) คู่กับหัว LR ระยะไกล ส่วนสีฟ้า Aqua คือ Multi-mode (OM3/OM4) คู่กับหัว SR ระยะใกล้', true, 'ถูกต้องตามมาตรฐาน TIA-598 และการใช้งานจริงใน Data Center', 1);
INSERT INTO public.choices VALUES ('d455a08d-784a-40f3-bf20-5d0cf1a8708b', 'fed5a2b0-f7b7-4585-869c-d21e36063fab', 'สีเหลืองคือ Multi-mode คู่กับหัว SR ส่วนสีฟ้าคือ Single-mode คู่กับหัว LR', false, 'สลับชนิดกัน', 2);
INSERT INTO public.choices VALUES ('55e9f2d5-5366-4a90-ad3c-9f05c7187342', 'fed5a2b0-f7b7-4585-869c-d21e36063fab', 'ทั้งสองสีเป็นสายชนิดเดียวกัน ต่างกันแค่ยี่ห้อผู้ผลิต สามารถเสียบแทนกันได้ทั้งหมด', false, 'แกนแสงต่างกัน (9µm vs 50µm) ห้ามเสียบข้ามชนิดกัน', 3);
INSERT INTO public.choices VALUES ('197187d2-5a49-4bc4-8b92-2f3aaaa79c44', 'fed5a2b0-f7b7-4585-869c-d21e36063fab', 'สีเหลืองใช้สำหรับสายไฟแรงสูง ส่วนสีฟ้าใช้สำหรับสายแลนทองแดง Cat6', false, 'ทั้งคู่เป็นรหัสสีของสาย Fiber Optic', 4);
INSERT INTO public.choices VALUES ('3e060ac7-888f-455b-9c59-8a43e36848e9', 'cf23fcf6-0d35-4d10-9843-e5cd963707d1', 'ขั้วสายไฟเบอร์ Tx/Rx ไม่ตรงกัน (Tx ชน Tx) ให้ถอดหัว LC ฝั่งหนึ่งมาสลับขั้วสายคู่ซ้าย-ขวา (Rolling the fiber) แล้วเสียบใหม่', true, 'ถูกต้อง การสลับขั้ว Tx/Rx (Roll fiber) เป็นวิธีแก้พื้นฐานที่สุดเมื่อต่อสายไฟเบอร์แล้วไฟ Link ไม่ขึ้น', 1);
INSERT INTO public.choices VALUES ('e6532020-1317-44e3-9cff-31a7aecb5853', 'cf23fcf6-0d35-4d10-9843-e5cd963707d1', 'ใช้สายตาเปล่าส่องเข้าไปในรูหัว SFP+ ทันทีเพื่อดูว่ามีแสงเลเซอร์สีแดงออกมาหรือไม่', false, 'ห้ามใช้ตาเปล่าส่องปลายสายไฟเบอร์หรือหัว Transceiver เด็ดขาดเพราะแสงเลเซอร์อาจทำลายจอประสาทตา', 2);
INSERT INTO public.choices VALUES ('bdf33064-4997-47dd-8e0d-a5250b25bf0d', 'cf23fcf6-0d35-4d10-9843-e5cd963707d1', 'พับสายไฟเบอร์ให้หักเป็นมุมฉาก 90 องศาเพื่อเร่งความเร็วการสะท้อนของแสง', false, 'การพับสายเกิน Bend radius จะทำให้แกนแก้วหักหรือแสงรั่วออกนอกสาย', 3);
INSERT INTO public.choices VALUES ('4890bc6c-a953-4e3c-ada9-7aceac5fffa4', 'cf23fcf6-0d35-4d10-9843-e5cd963707d1', 'สั่งรีบูต Switch ทั้งสองตัวพร้อมกันทันที', false, 'ห้ามรีบูต Production Switch จากปัญหาแค่พอร์ตเดียวไม่ขึ้น', 4);
INSERT INTO public.choices VALUES ('e0dd1342-b4e4-4f19-a1a3-3457e262debf', '60d9f418-713b-4218-bba9-7763e3ec1077', 'SFP+ (10 Gbps) และ QSFP28 (100 Gbps)', true, 'ถูกต้อง', 1);
INSERT INTO public.choices VALUES ('a4705471-b4a3-4985-9639-181139f652ee', '60d9f418-713b-4218-bba9-7763e3ec1077', 'SFP (10 Gbps) และ SFP+ (100 Gbps)', false, 'SFP รองรับ 1 Gbps และ SFP+ รองรับ 10 Gbps', 2);
INSERT INTO public.choices VALUES ('1316db4e-748e-4ffb-a765-fbc05ae0aa08', '60d9f418-713b-4218-bba9-7763e3ec1077', 'RJ45 (10 Gbps) และ SC (100 Gbps)', false, 'RJ45 และ SC เป็นชื่อหัวคอนเน็กเตอร์สาย ไม่ใช่ชนิดของฟอร์มแฟกเตอร์ Transceiver', 3);
INSERT INTO public.choices VALUES ('f6b63598-6f98-46b3-847f-3956cd924ab4', '60d9f418-713b-4218-bba9-7763e3ec1077', 'QSFP+ (10 Gbps) และ SFP (100 Gbps)', false, 'QSFP+ คือ 40 Gbps และ SFP คือ 1 Gbps', 4);
INSERT INTO public.choices VALUES ('9130a987-db2d-455b-a81d-c61f333996cf', '31507ab1-5704-4dca-adbb-845cb298008c', 'ขาวส้ม, ส้ม, ขาวเขียว, น้ำเงิน, ขาวน้ำเงิน, เขียว, ขาวน้ำตาล, น้ำตาล', true, 'ถูกต้องตามมาตรฐาน T568B', 1);
INSERT INTO public.choices VALUES ('1496bdc3-a377-4b39-b3da-2a31dd2e1acf', '31507ab1-5704-4dca-adbb-845cb298008c', 'ขาวเขียว, เขียว, ขาวส้ม, น้ำเงิน, ขาวน้ำเงิน, ส้ม, ขาวน้ำตาล, น้ำตาล', false, 'ลำดับนี้คือมาตรฐาน T568A', 2);
INSERT INTO public.choices VALUES ('b425418d-4db9-46bb-be03-9dff23a8971e', '31507ab1-5704-4dca-adbb-845cb298008c', 'ขาวส้ม, ส้ม, ขาวเขียว, เขียว, ขาวน้ำเงิน, น้ำเงิน, ขาวน้ำตาล, น้ำตาล', false, 'พิน 3-6 ไม่ได้เรียงคู่เขียวติดกัน เพราะต้องคร่อมคู่สีน้ำเงินเพื่อลดสัญญาณรบกวน (Crosstalk)', 3);
INSERT INTO public.choices VALUES ('3729eb0c-73e2-4a88-b21e-c4ca54ecbf29', '31507ab1-5704-4dca-adbb-845cb298008c', 'น้ำตาล, ขาวน้ำตาล, เขียว, ขาวเขียว, น้ำเงิน, ขาวน้ำเงิน, ส้ม, ขาวส้ม', false, 'เรียงลำดับผิด', 4);
INSERT INTO public.choices VALUES ('44571d68-53b4-4162-a807-a900c288e449', '9d9f0119-30e0-4f74-a490-6f63150858f8', 'Riser Card', true, 'ถูกต้อง', 1);
INSERT INTO public.choices VALUES ('3b47e161-a22c-4c75-82e6-e8d206ee544f', '9d9f0119-30e0-4f74-a490-6f63150858f8', 'BMC (Baseboard Management Controller)', false, 'BMC คือชิปควบคุมระบบจัดการระยะไกล (เช่น iDRAC/iLO)', 2);
INSERT INTO public.choices VALUES ('d80bc617-194e-482c-a7ae-7ab7091d8897', '9d9f0119-30e0-4f74-a490-6f63150858f8', 'Blanking Panel', false, 'Blanking Panel คือแผ่นปิดช่องว่างหน้าตู้แร็คเพื่อกั้นลมร้อน', 3);
INSERT INTO public.choices VALUES ('5d043525-51b1-4ba3-81cb-ca690cbdf090', '9d9f0119-30e0-4f74-a490-6f63150858f8', 'SFP+ Transceiver', false, 'SFP+ คือหัวแปลงสัญญาณแสงที่เสียบเข้าพอร์ตของการ์ดเครือข่าย', 4);
INSERT INTO public.choices VALUES ('1159beb5-fa2f-4b26-9bae-efa2df6553e6', '9600ac8c-a971-4c6f-96be-42e68bba2936', 'ติดตั้งอุปกรณ์ที่หนักที่สุด (เช่น UPS และ Storage Array) ไว้ที่ระยะ U ด้านล่างสุดของตู้แร็คเสมอ', true, 'ถูกต้อง ช่วยถ่วงน้ำหนักไม่ให้ตู้แร็คคว่ำ', 1);
INSERT INTO public.choices VALUES ('fb5d5c73-728a-4f09-a57b-dae3871dad5c', '9600ac8c-a971-4c6f-96be-42e68bba2936', 'ติดตั้ง UPS ไว้ที่ชั้นบนสุด (U40-U42) เพื่อให้ง่ายต่อการมองเห็นหน้าจอสถานะ', false, 'อันตรายมากทั้งตอนยกขึ้นและเสี่ยงทำให้ตู้แร็คเสียสมดุลล้มคว่ำ', 2);
INSERT INTO public.choices VALUES ('0812c6c7-bbb6-42e2-bd58-24d61af49499', '9600ac8c-a971-4c6f-96be-42e68bba2936', 'เสียบสายไฟของเซิร์ฟเวอร์ทั้งสองเส้นเข้าที่รางปลั๊ก PDU เส้นเดียวกันเพื่อประหยัดช่องเสียบ', false, 'ผิดหลัก Redundancy ต้องแยกเสียบเข้า PDU ฝั่ง A และฝั่ง B', 3);
INSERT INTO public.choices VALUES ('90d8fa7e-4454-49f5-8ef4-2c856b4abe7e', '9600ac8c-a971-4c6f-96be-42e68bba2936', 'ถอดแผ่นปิดช่องว่าง (Blanking Panel) ออกทั้งหมดเพื่อให้ลมร้อนไหลวนกลับมาด้านหน้าตู้ได้สะดวก', false, 'ต้องใส่ Blanking Panel เพื่อป้องกันลมร้อนไหลย้อนกลับมาด้านหน้า', 4);
INSERT INTO public.choices VALUES ('2e7ce4f1-f068-41e5-a528-8f78b832323f', '8cca4bdc-4664-4c04-8b68-ba8cd1c3c87e', 'เชื่อมต่อผ่านระบบ Out-of-Band เช่น iDRAC (หรือ IPMI / Redfish) เพื่ออ่าน System Event Log และเปิด Virtual Console', true, 'ถูกต้อง', 1);
INSERT INTO public.choices VALUES ('73b3a3dc-cf92-46dd-a0b4-f0470ac067d5', '8cca4bdc-4664-4c04-8b68-ba8cd1c3c87e', 'รอจนกว่าเครื่องจะหายค้างเอง เพราะเมื่อ SSH ไม่ได้จะไม่มีวิธีอื่นในการตรวจสอบ', false, 'ระบบ OOB ถูกออกแบบมาเพื่อแก้ปัญหากรณี SSH/OS ค้างโดยเฉพาะ', 2);
INSERT INTO public.choices VALUES ('764b8e74-b75b-4f03-8dde-368acfcd73a3', '8cca4bdc-4664-4c04-8b68-ba8cd1c3c87e', 'เดินไปถอดแรมออกทีละแถวในขณะที่เครื่องยังเปิดไฟทำงานอยู่', false, 'แรมไม่ได้เป็นอุปกรณ์ Hot-swap ห้ามถอดขณะเปิดเครื่องเด็ดขาด', 3);
INSERT INTO public.choices VALUES ('14d13a57-431a-4c74-9a86-14d675f6137e', '8cca4bdc-4664-4c04-8b68-ba8cd1c3c87e', 'สับเบรกเกอร์ไฟหลักของทั้งห้อง Data Hall ลงแล้วเปิดใหม่', false, 'ห้ามแตะต้องไฟหลักของห้องเพราะจะทำให้เครื่องอื่นดับทั้งหมด', 4);
INSERT INTO public.choices VALUES ('08956aa6-7313-4ed3-802f-26adf1d34edf', '322d8847-058b-4e2b-aaf5-b73a6f99c8db', 'DHCP (แจก IP และชี้ตำแหน่งเซิร์ฟเวอร์) คู่กับ TFTP (ดาวน์โหลดไฟล์ Bootloader และ Kernel)', true, 'ถูกต้อง', 1);
INSERT INTO public.choices VALUES ('296cf77a-b561-4cc8-8eb8-83af8140120c', '322d8847-058b-4e2b-aaf5-b73a6f99c8db', 'SMTP คู่กับ POP3', false, 'SMTP และ POP3 เป็นโปรโตคอลรับส่งอีเมล', 2);
INSERT INTO public.choices VALUES ('6a10428c-da78-4a57-be6e-121e9fe5bd33', '322d8847-058b-4e2b-aaf5-b73a6f99c8db', 'BGP คู่กับ OSPF', false, 'BGP และ OSPF เป็นโปรโตคอล Routing', 3);
INSERT INTO public.choices VALUES ('9a984cc3-3fee-444d-baff-0f93338c71f7', '322d8847-058b-4e2b-aaf5-b73a6f99c8db', 'SNMP คู่กับ NTP', false, 'SNMP ใช้มอนิเตอร์อุปกรณ์ และ NTP ใช้ซิงก์เวลา', 4);
INSERT INTO public.choices VALUES ('66b8d85e-4c32-4a54-8ede-59cadd26bb73', '7dc94aeb-fbb7-495c-b1a6-e0e7a616e571', 'WWPN (World Wide Port Name) ของการ์ด HBA และพอร์ตของตู้ Storage', true, 'ถูกต้อง WWPN ทำหน้าที่คล้าย MAC Address ในระบบ Fibre Channel', 1);
INSERT INTO public.choices VALUES ('73b75a06-c32b-4b43-8d34-e79a7f9eb9ae', '7dc94aeb-fbb7-495c-b1a6-e0e7a616e571', 'หมายเลขพอร์ต TCP 80 และ 443', false, 'TCP 80/443 เป็นพอร์ตของ HTTP/HTTPS', 2);
INSERT INTO public.choices VALUES ('f194ccdb-2eff-4ceb-beff-e2fed80b67b1', '7dc94aeb-fbb7-495c-b1a6-e0e7a616e571', 'ชื่อโดเมนเว็บไซต์ในไฟล์ /etc/resolv.conf', false, 'ไม่เกี่ยวข้องกับ Fibre Channel Zoning', 3);
INSERT INTO public.choices VALUES ('5a10fcc5-5c39-4dd7-beca-8274b30c5e4f', '7dc94aeb-fbb7-495c-b1a6-e0e7a616e571', 'หมายเลข Serial Number ของพัดลมระบายความร้อน', false, 'ไม่เกี่ยวข้องกับระบบ SAN', 4);
INSERT INTO public.choices VALUES ('6182029a-f11d-4ee7-8b72-df54fe8efbbc', '6e981c68-db2f-4533-9f5d-8a923e156a67', 'Frame และ Packet', true, 'ถูกต้อง Layer 2 = Frame, Layer 3 = Packet', 1);
INSERT INTO public.choices VALUES ('0c34e859-6396-4277-bdc5-2988451fbd01', 'a917b677-c0d8-4beb-9d74-003d1ecba5d7', 'UPS จ่ายไฟจากแบตเตอรี่ทันทีเพื่อประคองระบบช่วงสั้นๆ ส่วน ATS ทำหน้าที่สลับแหล่งจ่ายไฟระหว่างไฟการไฟฟ้ากับเครื่องปั่นไฟ (Generator) อัตโนมัติ', true, 'ถูกต้อง', 1);
INSERT INTO public.choices VALUES ('9e56322a-c562-46fe-b850-b75a845c0082', 'a917b677-c0d8-4beb-9d74-003d1ecba5d7', 'UPS ใช้ดับเพลิงเมื่อเกิดไฟไหม้ ส่วน ATS ใช้ทำความเย็นให้ตู้แร็ค', false, 'ทั้งคู่เป็นอุปกรณ์ในระบบไฟฟ้ากำลัง', 2);
INSERT INTO public.choices VALUES ('20b50d60-e7f2-4c85-ba14-ff1fa4c68ba4', 'a917b677-c0d8-4beb-9d74-003d1ecba5d7', 'ATS คือแบตเตอรี่สำรองไฟ ส่วน UPS คือเครื่องปั่นไฟดีเซล', false, 'สลับความหมายและหน้าที่กัน', 3);
INSERT INTO public.choices VALUES ('7ffe2cc6-cfc7-4b31-aabd-997e6ad5ad3b', 'a917b677-c0d8-4beb-9d74-003d1ecba5d7', 'UPS ใช้เฉพาะกับไฟ 110V เท่านั้น ส่วน ATS ใช้เฉพาะสายไฟเบอร์ออปติก', false, 'ไม่ถูกต้อง', 4);
INSERT INTO public.choices VALUES ('a4776ee2-187c-4105-b26d-f5dfc3b83088', '7196c4c2-9d55-4195-b076-2fd1f73327e3', '1. เปิด Network/SAN Switches -> 2. เปิดตู้ Storage Array -> 3. ทยอยเปิดเครื่องเซิร์ฟเวอร์ (Compute Servers)', true, 'ถูกต้อง ช่วยให้เซิร์ฟเวอร์มองเห็นเครือข่ายและดิสก์ทันทีที่บูตขึ้น และป้องกันไฟกระชาก', 1);
INSERT INTO public.choices VALUES ('fcd5326f-405e-4a1a-b975-b6c3c9c62685', '7196c4c2-9d55-4195-b076-2fd1f73327e3', '1. เปิดเครื่องเซิร์ฟเวอร์ทั้งหมดพร้อมกัน -> 2. เปิด Storage -> 3. เปิด Switch หลังสุด', false, 'จะทำให้เซิร์ฟเวอร์บูตขึ้นมาไม่เจอ Storage (Mount ล้มเหลว) และเกิดไฟกระชากสูง', 2);
INSERT INTO public.choices VALUES ('eec2cc39-7f47-4c7d-b3b8-3febbf492c1c', '7196c4c2-9d55-4195-b076-2fd1f73327e3', 'สับเบรกเกอร์เปิดและปิดสลับกันเร็วๆ 3 ครั้งเพื่อเป็นการอุ่นเครื่อง', false, 'จะทำให้ภาคจ่ายไฟและฮาร์ดดิสก์พังเสียหาย', 3);
INSERT INTO public.choices VALUES ('ebcb5af8-94d1-4d19-9750-efaa31a5d1a3', '7196c4c2-9d55-4195-b076-2fd1f73327e3', 'เปิดเฉพาะ PSU ฝั่ง A ทิ้งไว้ 24 ชั่วโมงแล้วค่อยเสียบสายแลน', false, 'ไม่ถูกต้อง', 4);
INSERT INTO public.choices VALUES ('914ecdbe-7ecf-470b-97de-51b872426d89', '05515d73-1a5e-475d-b40b-94ce12001fab', 'ssh-keygen -R 10.20.1.88', true, 'ถูกต้อง — ลบเฉพาะรายการ Host key ของ 10.20.1.88 ออกจาก ~/.ssh/known_hosts อย่างปลอดภัย', 1);
INSERT INTO public.choices VALUES ('e66dae09-0252-4cab-b5ff-a24b228b49f1', '48ef625d-f83d-4e25-9661-d28975cfb48c', '100 และ 20', false, '20 คือจำนวนแถวที่เป็น NULL ไม่ใช่จำนวนแถวที่มีค่า', 4);
INSERT INTO public.choices VALUES ('a8814cf4-3035-4da3-8baf-a1b1ed304f67', '933dfdc8-419d-4b12-9ccc-1a634e095c13', 'หันหน้าตู้เข้าหากันเพื่อรับลมเย็น (Cold Aisle) หันหลังตู้ชนกันเพื่อระบายลมร้อน (Hot Aisle) และติด Blanking Panel เพื่อกั้นไม่ให้ลมร้อนไหลย้อนกลับมาด้านหน้า', true, 'ถูกต้องตามมาตรฐานการจัดการการไหลเวียนอากาศใน Data Center', 1);
INSERT INTO public.choices VALUES ('ad6a1b86-0e33-4b8a-b689-d19caab70d34', '933dfdc8-419d-4b12-9ccc-1a634e095c13', 'หันหน้าตู้สลับกับหลังตู้ในแถวเดียวกันเพื่อให้ลมร้อนและลมเย็นผสมกันให้อุณหภูมิเท่ากันทั้งห้อง', false, 'การผสมลมร้อนกับลมเย็นทำให้ประสิทธิภาพการระบายความร้อนแย่ลงและเซิร์ฟเวอร์ร้อนจัด', 2);
INSERT INTO public.choices VALUES ('e7a9f5bf-47ef-41ac-b0a3-8058f66f54f1', '933dfdc8-419d-4b12-9ccc-1a634e095c13', 'เป่าลมเย็นเข้าทางด้านหลังเครื่อง PSU และดูดลมร้อนออกทางด้านหน้าฮาร์ดดิสก์', false, 'เซิร์ฟเวอร์มาตรฐานดูดลมเย็นเข้าด้านหน้า (Front Intake) และเป่าออกด้านหลัง (Rear Exhaust)', 3);
INSERT INTO public.choices VALUES ('24b49473-e7f3-4141-b992-e1bc0fb732bc', '933dfdc8-419d-4b12-9ccc-1a634e095c13', 'ติด Blanking Panel เพื่อเพิ่มน้ำหนักให้ตู้แร็คไม่สั่นสะเทือน', false, 'Blanking Panel เบามาก มีไว้เพื่อกั้นทิศทางลม ไม่ใช่ถ่วงน้ำหนัก', 4);
INSERT INTO public.choices VALUES ('f7d0c72d-880a-4e61-91ca-e8246ad46e4d', '6f372fdb-946b-43aa-a8a4-868bc32651ea', 'แก๊สสารสะอาดดับเพลิง (Clean Agent เช่น FM-200, Novec 1230 หรือ Inergen) คู่กับระบบตรวจจับควันความไวสูง VESDA', true, 'ถูกต้อง ดับไฟได้โดยเซิร์ฟเวอร์ยังทำงานต่อได้และไม่เกิดความเสียหายจากน้ำหรือผงเคมี', 1);
INSERT INTO public.choices VALUES ('080d7a79-ce4a-4b73-aef9-7bc6afa0823f', '6f372fdb-946b-43aa-a8a4-868bc32651ea', 'หัวฉีดน้ำสปริงเกอร์แรงดันสูงที่ฉีดน้ำท่วมตู้แร็คทันทีเมื่อมีกลิ่นเหม็น', false, 'น้ำจะทำให้ไฟฟ้าลัดวงจรและอุปกรณ์ทั้งหมดเสียหาย', 2);
INSERT INTO public.choices VALUES ('5ba1e7ab-e087-482c-90d6-ddbda7ef0325', '6f372fdb-946b-43aa-a8a4-868bc32651ea', 'ถังดับเพลิงชนิดผงเคมีแห้งสีแดงฉีดพ่นเข้าไปในพัดลมเซิร์ฟเวอร์', false, 'ผงเคมีแห้งมีความเป็นกรดและกัดกร่อนแผงวงจรเมนบอร์ดทุกเครื่องในห้องจนพัง', 3);
INSERT INTO public.choices VALUES ('71ca36fa-4985-436c-96d7-577dd67ba353', '6f372fdb-946b-43aa-a8a4-868bc32651ea', 'โฟมเคมีผสมน้ำเกลือ', false, 'นำไฟฟ้าอย่างรุนแรง ห้ามใช้กับอุปกรณ์ไฟฟ้า', 4);
INSERT INTO public.choices VALUES ('ccaa39fd-3003-488c-bfae-ac99ae8a0758', '583a1f9b-0196-4bd5-b6ca-18b2fd163774', 'ตั้งสติ ไม่สับเบรกเกอร์หลักของทั้งตู้แร็ค ประเมินความปลอดภัย ตรวจสอบสถานะ Redundant PSU ถอดเฉพาะสายไฟของลูก PSU ที่มีปัญหา และแจ้งหัวหน้าทีม/NOC ทันที', true, 'ถูกต้อง แสดงถึงความรอบคอบ มีสติ และเข้าใจผลกระทบต่อระบบส่วนรวม (Blast radius)', 1);
INSERT INTO public.choices VALUES ('cc8e11ac-e1e9-4b29-a332-e8637c4c478a', '892ec4d9-193b-40fa-a7c6-71c4e3031c2d', 'pwd', true, 'ถูกต้อง — แสดงเส้นทางเต็มของโฟลเดอร์ที่กำลังทำงานอยู่ปัจจุบัน', 1);
INSERT INTO public.choices VALUES ('5f13781e-84fe-458f-8a78-65d0b019463d', '583a1f9b-0196-4bd5-b6ca-18b2fd163774', 'รีบวิ่งไปสับเบรกเกอร์ไฟหลักของทั้งตู้แร็คลงทันทีโดยไม่ต้องแจ้งใคร', false, 'จะทำให้เซิร์ฟเวอร์เครื่องอื่นทั้งตู้แร็คดับทั้งหมดโดยไม่จำเป็น', 2);
INSERT INTO public.choices VALUES ('5c3adc1f-9305-4f90-a15e-69cf86bea955', '583a1f9b-0196-4bd5-b6ca-18b2fd163774', 'ทุบกระจกกดปุ่ม EPO (Emergency Power Off) เพื่อตัดไฟทั้งอาคาร Data Center ทันที', false, 'ปุ่ม EPO ใช้เฉพาะกรณีเกิดภัยพิบัติร้ายแรงถึงชีวิตเท่านั้น การกดโดยไม่จำเป็นจะทำให้ทั้งศูนย์ข้อมูลล่ม', 3);
INSERT INTO public.choices VALUES ('340bc71b-0648-4774-a937-787628ab7aca', '583a1f9b-0196-4bd5-b6ca-18b2fd163774', 'เพิกเฉยและเดินผ่านไปเหมือนไม่มีอะไรเกิดขึ้นเพราะเห็นว่าเซิร์ฟเวอร์ยังไม่ดับ', false, 'ขาดความรับผิดชอบ ต้องตรวจสอบและรายงานเพื่อเปลี่ยน PSU ลูกที่เสีย', 4);
INSERT INTO public.choices VALUES ('b0008d02-95ad-49d4-9d28-1e1621396653', '30e66b8d-6030-4b13-8c81-97a7a8358886', 'ตอบตามตรงว่ายังไม่เคยใช้เครื่องเชื่อมสายจริง แต่อธิบายความเข้าใจเรื่องชนิดสายไฟเบอร์ การดูแลรักษาหัวสาย และแสดงความพร้อมที่จะเรียนรู้ฝึกฝนอย่างรวดเร็ว', true, 'ถูกต้อง ซื่อสัตย์และแสดงศักยภาพในการเรียนรู้', 1);
INSERT INTO public.choices VALUES ('bf664cac-2684-4a6f-bc58-9125e153545b', '30e66b8d-6030-4b13-8c81-97a7a8358886', 'โกหกว่าทำเป็นชำนาญมากเพื่อให้ได้งานก่อน แล้วค่อยไปแอบดูวิธีทำทีหลัง', false, 'ผู้สัมภาษณ์มักจะถามจี้รายละเอียดขั้นตอนทันที หากตอบไม่ได้จะเสียคะแนนความน่าเชื่อถือทั้งหมด', 2);
INSERT INTO public.choices VALUES ('49fb3981-bf97-48ed-a035-399bae51accc', '30e66b8d-6030-4b13-8c81-97a7a8358886', 'ตอบว่าไม่รู้และไม่อยากทำเพราะเป็นงานของช่างเดินสายเท่านั้น', false, 'แสดงทัศนคติปิดกั้นการเรียนรู้', 3);
INSERT INTO public.choices VALUES ('e99100dd-270a-4f79-bea7-3ce7fa2fc09b', '30e66b8d-6030-4b13-8c81-97a7a8358886', 'เปลี่ยนเรื่องคุยไปพูดเรื่องการเขียนโปรแกรมแทนโดยไม่ตอบคำถาม', false, 'ไม่ตรงคำถาม', 4);
INSERT INTO public.choices VALUES ('a86309fb-e00e-4e00-8db9-21c93a461e28', 'd2bfba71-09f3-46d0-aacd-24c38ff4e835', 'รันคำสั่ง docker logs <container_name> เพื่อดูข้อความ Error สาเหตุที่ Container ดับ', true, 'ถูกต้อง docker logs จะแสดง stdout/stderr ของโปรเซสก่อนที่จะดับลง', 1);
INSERT INTO public.choices VALUES ('b409f840-ec32-42ef-8cc7-bb2a230e7912', 'd2bfba71-09f3-46d0-aacd-24c38ff4e835', 'ลบ Docker Image ทิ้งแล้วดาวน์โหลดใหม่ทันที', false, 'การลบ Image โดยไม่ดู Log จะทำให้ไม่ทราบสาเหตุของปัญหา', 2);
INSERT INTO public.choices VALUES ('72de650c-43c9-4b34-b970-fb9f2fc3c794', 'd2bfba71-09f3-46d0-aacd-24c38ff4e835', 'รัน docker exec -it <container_name> bash', false, 'docker exec ใช้ได้กับ Container ที่กำลังรันอยู่เท่านั้น ไม่สามารถ exec เข้าตัวที่ Exited ได้', 3);
INSERT INTO public.choices VALUES ('3f4b97de-7e2c-427f-a840-fb8888384b01', 'd2bfba71-09f3-46d0-aacd-24c38ff4e835', 'รีสตาร์ทเครื่อง Physical Host ทันที', false, 'การรีสตาร์ทเครื่องแม่ข่ายเป็นการกระทำที่เกินกว่าเหตุและกระทบระบบอื่น', 4);
INSERT INTO public.choices VALUES ('a5b473ad-3936-4414-9c91-ba289052c2b2', '0fc16af1-29b0-41f4-af69-ba9e1cd8aa60', 'docker exec -it api_gateway sh', true, 'ถูกต้อง คำสั่งนี้จะเปิด Terminal shell เข้าไปใน Container ที่กำลังทำงานอยู่', 1);
INSERT INTO public.choices VALUES ('d8336586-6f27-45e8-bd54-5457a5f6fe4f', '0fc16af1-29b0-41f4-af69-ba9e1cd8aa60', 'docker run -it api_gateway', false, 'docker run จะเป็นการสร้าง Container ตัวใหม่ขึ้นมา ไม่ใช่เข้าไปในตัวเดิม', 2);
INSERT INTO public.choices VALUES ('29faeaf6-4242-493f-aac8-caab8c80b71a', '0fc16af1-29b0-41f4-af69-ba9e1cd8aa60', 'docker ssh api_gateway', false, 'ไม่มีคำสั่งย่อย docker ssh ใน Docker CLI', 3);
INSERT INTO public.choices VALUES ('142182c4-99b1-4b2d-add5-839808215b2b', '0fc16af1-29b0-41f4-af69-ba9e1cd8aa60', 'docker attach api_gateway', false, 'docker attach จะผูก stdout/stderr ของโปรเซสหลัก ซึ่งหากกด Ctrl+C อาจทำให้ Container ดับไปด้วย', 4);
INSERT INTO public.choices VALUES ('12ff97cf-6710-47f9-9757-7ba345f9adbd', '5e788bf5-347f-4201-9344-7e3f4c9e180f', 'คอนเทนเนอร์ใช้หน่วยความจำ RAM เกินขีดจำกัดที่ตั้งไว้ จนถูก Linux Kernel OOM Killer สั่งยุติการทำงานทันที', true, 'ถูกต้อง นี่คือนิยามและสาเหตุของ Exit code 137 OOMKilled', 1);
INSERT INTO public.choices VALUES ('7e044336-2025-4348-b338-0c216fff49a5', '5e788bf5-347f-4201-9344-7e3f4c9e180f', 'คอนเทนเนอร์ทำงานเสร็จสิ้นสมบูรณ์ตามปกติ', false, 'ทำงานเสร็จตามปกติคือ Exit Code 0', 2);
INSERT INTO public.choices VALUES ('dfdc48d9-b443-4855-b04c-9c0cc8f8a46a', '5e788bf5-347f-4201-9344-7e3f4c9e180f', 'มีคนสั่งลบไดเรกทอรี root ของคอนเทนเนอร์', false, 'ไม่ใช่อาการของ OOMKilled', 3);
INSERT INTO public.choices VALUES ('26b3a62e-2b5b-4954-9672-87d20f6dc1ba', '5e788bf5-347f-4201-9344-7e3f4c9e180f', 'พอร์ตเครือข่ายมีคนใช้งานซ้ำซ้อน', false, 'พอร์ตชนกันจะเกิด Exit Code 1 ตอนเริ่มต้น ไม่ใช่ 137 ตอนกำลังรันงานหนัก', 4);
INSERT INTO public.choices VALUES ('3b13a230-1cdf-4881-a676-3ba71caf969c', '5d2f59f3-3800-4751-84af-43e8f7a2c8f4', 'Exit Code 143', true, 'ถูกต้อง 128 + 15 (SIGTERM) = 143', 1);
INSERT INTO public.choices VALUES ('3f8e3874-508d-4288-b972-0f88376c050d', '5d2f59f3-3800-4751-84af-43e8f7a2c8f4', 'Exit Code 0', false, '0 คือโปรเซสทำงานจบด้วยตัวมันเองสำเร็จ', 2);
INSERT INTO public.choices VALUES ('ad386fd3-aacd-455b-9b92-c9ce10a235b5', '5d2f59f3-3800-4751-84af-43e8f7a2c8f4', 'Exit Code 1', false, '1 คือ Application Error ทั่วไป', 3);
INSERT INTO public.choices VALUES ('b0e270ec-6dea-4f12-9ffd-adb45a7001fd', '5d2f59f3-3800-4751-84af-43e8f7a2c8f4', 'Exit Code 255', false, '255 มักเกิดจากข้อผิดพลาดร้ายแรงของ Entrypoint หรือ Docker Engine', 4);
INSERT INTO public.choices VALUES ('91f3cdee-bc8a-4132-ae39-6c9bed01f524', 'c1a10001-0000-0000-0000-000000000001', 'chmod 755 deploy.sh', true, NULL, 1);
INSERT INTO public.choices VALUES ('1066ba17-9cef-419c-a742-9e64633b8826', 'c1a10001-0000-0000-0000-000000000001', 'chmod 644 deploy.sh', false, NULL, 2);
INSERT INTO public.choices VALUES ('c141e7aa-24cf-423a-b0ce-10590e64688d', 'c1a10001-0000-0000-0000-000000000001', 'chmod 777 deploy.sh', false, NULL, 3);
INSERT INTO public.choices VALUES ('146f1f0d-cfd8-4da0-80f2-706d203401f6', 'c1a10001-0000-0000-0000-000000000001', 'chmod 764 deploy.sh', false, NULL, 4);
INSERT INTO public.choices VALUES ('9ce6749e-c03b-47f9-99bd-f8c178194f2b', 'a41d9eb7-8d8e-4280-992f-cc029c329c9a', 'cd /', false, '`cd /` คือการย้ายไปยังรากสุดของระบบ (Root directory) และเป็น Absolute Path', 4);
INSERT INTO public.choices VALUES ('613c7a6c-8806-4ce6-85c4-1080007ed23c', '892ec4d9-193b-40fa-a7c6-71c4e3031c2d', 'cd', false, 'cd ใช้สำหรับเปลี่ยนโฟลเดอร์ หากพิมพ์ cd เปล่าๆ จะพากลับไปยัง Home directory', 2);
INSERT INTO public.choices VALUES ('79179020-9ec7-4fb9-8d38-a50615902723', '892ec4d9-193b-40fa-a7c6-71c4e3031c2d', 'whoami', false, 'whoami ใช้แสดงชื่อบัญชีผู้ใช้ปัจจุบัน ไม่ใช่ตำแหน่งโฟลเดอร์', 3);
INSERT INTO public.choices VALUES ('1c54fbf8-ff71-4978-94ea-2434ce613243', '892ec4d9-193b-40fa-a7c6-71c4e3031c2d', 'ls -a', false, 'ls -a ใช้แสดงรายชื่อไฟล์ในโฟลเดอร์ปัจจุบัน ไม่ได้แสดงเส้นทางเต็ม', 4);
INSERT INTO public.choices VALUES ('b858c880-79c6-48c2-948b-85acb06bd032', '1e16fb7f-d0aa-4285-b8d2-3faa3bccb016', 'ls -lah', true, 'ถูกต้อง — รวมตัวเลือกดูรายละเอียด (-l), ไฟล์ซ่อน (-a) และหน่วยอ่านง่าย (-h)', 1);
INSERT INTO public.choices VALUES ('b12d888d-9bd5-45fd-938a-e17f7bad322d', '1e16fb7f-d0aa-4285-b8d2-3faa3bccb016', 'ls -l', false, 'แสดงรายละเอียดแต่ไม่แสดงไฟล์ซ่อนที่ขึ้นต้นด้วยจุด และขนาดไฟล์ยังเป็นหน่วยไบต์', 2);
INSERT INTO public.choices VALUES ('492de5d5-ab88-42d3-8696-aaf6980de153', '1e16fb7f-d0aa-4285-b8d2-3faa3bccb016', 'ls -r', false, 'ls -r เป็นการเรียงลำดับรายชื่อไฟล์แบบย้อนกลับ (reverse)', 3);
INSERT INTO public.choices VALUES ('4323ff4c-1fec-4f40-ae2d-0740cf2597ce', '1e16fb7f-d0aa-4285-b8d2-3faa3bccb016', 'cat -n *', false, 'cat เป็นคำสั่งเปิดอ่านเนื้อหาภายในไฟล์ ไม่ใช่การแสดงรายการไฟล์ในโฟลเดอร์', 4);
INSERT INTO public.choices VALUES ('13bbce03-849b-4e02-941e-b1a936c4cf97', '35d32f57-908c-4509-84c0-94b315f2bd35', 'ชื่อไฟล์บน Linux แยกตัวพิมพ์เล็ก-ใหญ่ ต้องระบุเป็น `tail -n 20 Error.log` ให้ตรงกับชื่อไฟล์จริง', true, 'ถูกต้อง — Error.log กับ error.log คือคนละชื่อไฟล์บน Linux', 1);
INSERT INTO public.choices VALUES ('6dc72aea-fd1b-4c15-b749-fc326d9df4a5', '35d32f57-908c-4509-84c0-94b315f2bd35', 'คำสั่ง tail ไม่สามารถอ่านไฟล์ขนาดต่ำกว่า 10KB ได้ ต้องใช้คำสั่ง less แทน', false, 'tail สามารถอ่านไฟล์ข้อความทุกขนาดได้', 2);
INSERT INTO public.choices VALUES ('1c4fa316-0109-4259-b423-1fe9dae56d0e', '35d32f57-908c-4509-84c0-94b315f2bd35', 'ต้องใส่เครื่องหมาย `/` นำหน้าชื่อไฟล์เป็น `/error.log` เสมอ', false, 'การใส่ `/error.log` จะกลายเป็นอ้างอิงไฟล์ที่รากสุดของระบบ (`/`) ซึ่งผิดตำแหน่ง', 3);
INSERT INTO public.choices VALUES ('d804b822-8313-4477-92aa-031de1bd3448', '35d32f57-908c-4509-84c0-94b315f2bd35', 'ไฟล์ถูกบีบอัดอยู่ ต้องแตกไฟล์ด้วย gunzip ก่อนเปิดอ่าน', false, 'ไฟล์ไม่ได้มีนามสกุล .gz และสาเหตุเกิดจากการสะกดตัวพิมพ์ใหญ่-เล็กไม่ตรงกัน', 4);
INSERT INTO public.choices VALUES ('1bfe1f3d-c099-4535-bf7d-50e4a46cded0', '424f36a8-1a09-4c7c-8511-fe7c60417e2e', 'เพราะ cat จะเทเนื้อหาทั้งหมดออกหน้าจอรวดเดียว ทำให้เปลืองทรัพยากรและอ่านข้อมูลลำบาก ควรใช้ less หรือ tail แทน', true, 'ถูกต้อง — less และ tail ออกแบบมาให้อ่านเฉพาะส่วนที่ต้องการโดยไม่โหลดทั้งไฟล์ลงหน้าจอ', 1);
INSERT INTO public.choices VALUES ('be6cd004-7cbb-40e4-9e84-2ce736520aa8', '424f36a8-1a09-4c7c-8511-fe7c60417e2e', 'เพราะคำสั่ง cat จะทำการล็อกไฟล์ (File lock) ทำให้แอปพลิเคชันเขียน Log ต่อไม่ได้จนระบบล่ม', false, 'cat ไม่ได้ล็อกไฟล์ไม่ให้โปรเซสอื่นเขียนต่อ แต่ปัญหาคือการอ่านและแสดงผลรวดเดียวทั้งหมด', 2);
INSERT INTO public.choices VALUES ('fd397b06-4f2e-479f-a925-f8831fc49a95', '424f36a8-1a09-4c7c-8511-fe7c60417e2e', 'เพราะ cat จะลบเนื้อหาเก่าในไฟล์ทิ้งหลังจากแสดงผลเสร็จ', false, 'cat เป็นคำสั่งอ่านอย่างเดียว ไม่ได้ลบเนื้อหาในไฟล์', 3);
INSERT INTO public.choices VALUES ('51f38174-d697-42c9-bedf-f188191a0c80', '424f36a8-1a09-4c7c-8511-fe7c60417e2e', 'เพราะ cat รองรับเฉพาะไฟล์ที่มีขนาดไม่เกิน 1 MB เท่านั้นตามข้อจำกัดของ Kernel', false, 'cat ไม่มีข้อจำกัดที่ 1 MB แต่ไม่เหมาะกับการเปิดอ่านไฟล์ใหญ่โต้ตอบบนหน้าจอ', 4);
INSERT INTO public.choices VALUES ('af34dc81-c62a-4efc-8e5e-a98be337abea', 'ff930bba-7a53-42c5-acae-936a295c3727', 'มีช่องว่างหลังเครื่องหมาย `/` ทำให้คำสั่งถูกตีความว่าสั่งลบตั้งแต่ Root (`/`) และตามด้วย `tmp/cache/*` ซึ่งเสี่ยงทำให้ระบบเสียหายร้ายแรง', true, 'ถูกต้อง — การเว้นวรรคผิดในคำสั่ง rm -rf ทำให้อาร์กิวเมนต์แยกออกเป็น 2 พาธ', 1);
INSERT INTO public.choices VALUES ('9fcb0503-76df-4032-95c3-83d3cd81d0a2', 'ff930bba-7a53-42c5-acae-936a295c3727', 'ระบบจะลบเฉพาะไฟล์ใน `/tmp/cache/*` ได้ตามปกติ เพราะ Shell จะตัดช่องว่างออกให้อัตโนมัติ', false, 'Shell ใช้ช่องว่างเป็นตัวคั่นอาร์กิวเมนต์ ไม่ได้ตัดช่องว่างรวมเข้าด้วยกัน', 2);
INSERT INTO public.choices VALUES ('add090b8-b57a-4f3b-89c6-c7a7ba752af8', 'ff930bba-7a53-42c5-acae-936a295c3727', 'คำสั่งจะไม่ทำงานเพราะตัวเลือก `-rf` ไม่สามารถใช้ร่วมกับเครื่องหมาย `*` ได้', false, '-rf ใช้ร่วมกับ wildcard * ได้ และนั่นคือสาเหตุที่ทำให้เกิดความเสียหายได้ง่าย', 3);
INSERT INTO public.choices VALUES ('bc146859-c6f6-42bc-b9ea-8eabcac651ba', 'ff930bba-7a53-42c5-acae-936a295c3727', 'ระบบจะย้ายไฟล์ทั้งหมดไปไว้ในถังขยะ `~/.Trash` ซึ่งสามารถกู้คืนได้ภายหลัง', false, 'คำสั่ง rm บน Linux CLI จะลบไฟล์ออกจากไดเรกทอรีโดยตรง ไม่ได้ย้ายไปถังขยะ', 4);
INSERT INTO public.choices VALUES ('b8b8c054-abb5-456d-9634-d164a6182a92', 'a41d9eb7-8d8e-4280-992f-cc029c329c9a', 'cd ..', true, 'ถูกต้อง — `..` แทนโฟลเดอร์แม่ 1 ชั้น', 1);
INSERT INTO public.choices VALUES ('46e5bc6f-7be5-4c58-ae59-0454030653eb', 'a41d9eb7-8d8e-4280-992f-cc029c329c9a', 'cd .', false, '`.` หมายถึงโฟลเดอร์ปัจจุบัน การรัน `cd .` จึงยังคงอยู่ที่เดิม', 2);
INSERT INTO public.choices VALUES ('a44e253a-3598-4168-8be1-4a6bf8f995ce', 'a41d9eb7-8d8e-4280-992f-cc029c329c9a', 'cd ~', false, '`~` หมายถึง Home directory ของผู้ใช้ เช่น `/home/support`', 3);
INSERT INTO public.choices VALUES ('dbf0ead7-22bc-47e1-b1e9-339ec4742237', '6e981c68-db2f-4533-9f5d-8a923e156a67', 'Packet และ Segment', false, 'ผิด Packet คือ Layer 3 ส่วน Segment คือ Layer 4', 2);
INSERT INTO public.choices VALUES ('991f7d6a-07ef-4a68-83a2-5bd90682ed53', 'd7c21650-b866-4270-89b0-b1694c2881dd', 'cp -p app.conf app.conf.bak', true, 'ถูกต้อง — `-p` ช่วยคงค่า mode, ownership และ timestamps เดิมไว้', 1);
INSERT INTO public.choices VALUES ('4845569d-8da0-40d2-82eb-c81941e03ee2', 'd7c21650-b866-4270-89b0-b1694c2881dd', 'mv app.conf app.conf.bak', false, 'mv เป็นการย้ายหรือเปลี่ยนชื่อไฟล์ จะทำให้ไฟล์ต้นฉบับ `app.conf` หายไปและกระทบแอปพลิเคชัน', 2);
INSERT INTO public.choices VALUES ('75ff46bb-5d8b-41db-bdb9-9680a9031ade', 'd7c21650-b866-4270-89b0-b1694c2881dd', 'touch app.conf.bak', false, 'touch จะสร้างเพียงไฟล์เปล่าที่ไม่มีเนื้อหาข้างใน', 3);
INSERT INTO public.choices VALUES ('9a7c1996-8981-4d24-ad4d-8adffc11eb9c', 'd7c21650-b866-4270-89b0-b1694c2881dd', 'mkdir app.conf.bak', false, 'mkdir เป็นคำสั่งสร้างโฟลเดอร์ ไม่ใช่การคัดลอกไฟล์', 4);
INSERT INTO public.choices VALUES ('5fac4501-81d6-45cc-a66f-98e01dfea59f', 'c76d1ecb-de00-4fe1-b3cd-fb37fb4de9f3', '/etc และ /var/log', true, 'ถูกต้อง — /etc เก็บไฟล์คอนฟิก และ /var/log เก็บไฟล์ Log', 1);
INSERT INTO public.choices VALUES ('2a71a4a5-bdee-44f5-9bb4-5d8e9fac1e4d', 'c76d1ecb-de00-4fe1-b3cd-fb37fb4de9f3', '/usr และ /tmp', false, '/usr เก็บโปรแกรมและไลบรารี ส่วน /tmp เก็บไฟล์ชั่วคราว', 2);
INSERT INTO public.choices VALUES ('53924a83-7bbd-4a38-8733-3134712c7e6e', 'c76d1ecb-de00-4fe1-b3cd-fb37fb4de9f3', '/opt และ /home', false, '/opt เก็บซอฟต์แวร์เสริม ส่วน /home เก็บโฟลเดอร์ส่วนตัวของผู้ใช้', 3);
INSERT INTO public.choices VALUES ('d71c6bf9-c4fe-432d-aaea-cecb96e59c7c', 'c76d1ecb-de00-4fe1-b3cd-fb37fb4de9f3', '/bin และ /sbin', false, '/bin และ /sbin เก็บไฟล์คำสั่ง Binary ของระบบ', 4);
INSERT INTO public.choices VALUES ('60391389-1f39-4b2b-917e-09490ad75397', '31f353c9-c627-49e9-a19b-a79eb9cfc624', 'find /var -type f -size +200M', true, 'ถูกต้อง — ระบุโฟลเดอร์ /var กรองเฉพาะไฟล์ด้วย -type f และขนาดเกิน 200M ด้วย -size +200M', 1);
INSERT INTO public.choices VALUES ('e2e277bb-607e-41ae-b9a5-e4970c42f84e', '31f353c9-c627-49e9-a19b-a79eb9cfc624', 'find /var -type d -size -200M', false, '-type d คือการหาโฟลเดอร์ และ -200M คือขนาดน้อยกว่า 200MB', 2);
INSERT INTO public.choices VALUES ('b02b5c1f-84bf-42e5-92c3-a6b3d2bdb31d', '31f353c9-c627-49e9-a19b-a79eb9cfc624', 'du -sh /var +200M', false, 'du ไม่รองรับพารามิเตอร์กรองขนาดแบบ +200M', 3);
INSERT INTO public.choices VALUES ('4c75d5a1-986d-467d-ba9f-b94974f800c6', '31f353c9-c627-49e9-a19b-a79eb9cfc624', 'ls -lah /var --size=200M', false, 'ls ไม่ได้ค้นหาลงไปทุกโฟลเดอร์ย่อยและไม่มีตัวเลือกกรองขนาดแบบนี้', 4);
INSERT INTO public.choices VALUES ('0559adfa-bc9b-4469-bccb-48af2ddf0f64', '1ac01c44-5005-4ecb-88fc-c771eb4dae59', 'Symbolic link `/opt/payment/current` ชี้ไปยังโฟลเดอร์ `/opt/payment/releases/20261015` ที่ถูกลบไปแล้ว (Broken link)', true, 'ถูกต้อง — ลิงก์ชี้ไปยังปลายทางที่ไม่มีอยู่จริงในโฟลเดอร์ releases/', 1);
INSERT INTO public.choices VALUES ('83461c72-ae10-4f70-9763-3a8976c12365', '1ac01c44-5005-4ecb-88fc-c771eb4dae59', 'สิทธิ์ของ `/opt/payment/current` เป็น `lrwxrwxrwx` (777) ระบบความปลอดภัยจึงบล็อกการเข้าถึง', false, 'สิทธิ์ของตัว Symbolic link จะแสดงเป็น lrwxrwxrwx เสมอตามปกติ โดยสิทธิ์จริงจะอิงตามไฟล์ปลายทาง', 2);
INSERT INTO public.choices VALUES ('a3c2f877-06a9-4dff-adb8-1907bdc04671', '1ac01c44-5005-4ecb-88fc-c771eb4dae59', 'ผู้ใช้ deploy ไม่มีสิทธิ์อ่านโฟลเดอร์ `20261103`', false, 'ปัญหาไม่ได้อยู่ที่สิทธิ์ของ 20261103 แต่อยู่ที่ตัวลิงก์ current ยังชี้ไปที่ 20261015 ซึ่งไม่มีอยู่แล้ว', 3);
INSERT INTO public.choices VALUES ('17705452-f530-44b5-8b0c-f82ef2aa3082', '1ac01c44-5005-4ecb-88fc-c771eb4dae59', 'ฮาร์ดดิสก์พาร์ทิชัน `/opt` เสียหาย ต้องรัน fsck ทันที', false, 'เป็นเพียงปัญหา Symbolic link ชี้ผิดโฟลเดอร์หลังการลบ Release เก่า ไม่ใช่ดิสก์เสีย', 4);
INSERT INTO public.choices VALUES ('11d180d2-ef8d-4d5c-b48f-be4084ae6179', 'e19ee335-78a0-4eac-b7a7-95af8779fa8f', 'ตรวจสอบไฟล์ `/etc/hosts` ว่ามีการระบุ IP `10.10.1.50` คู่กับชื่อ `db-internal.corp` ค้างไว้หรือไม่', true, 'ถูกต้อง — ระบบจะอ่าน /etc/hosts ก่อนสอบถาม DNS Server เสมอ', 1);
INSERT INTO public.choices VALUES ('2473e22e-869d-448c-9c87-e4dd735907d8', 'e19ee335-78a0-4eac-b7a7-95af8779fa8f', 'ตรวจสอบไฟล์ `/etc/fstab` ว่ามีการตั้งค่า Network Drive ผิดหรือไม่', false, '/etc/fstab ใช้สำหรับตั้งค่าการ Mount ระบบไฟล์และดิสก์ ไม่เกี่ยวกับการแปลงชื่อโดเมน', 2);
INSERT INTO public.choices VALUES ('0de2abe7-d674-4824-b591-1ee5484616d3', 'e19ee335-78a0-4eac-b7a7-95af8779fa8f', 'ตรวจสอบไฟล์ `/etc/hostname` เพราะชื่อเครื่องอาจซ้ำกับฐานข้อมูล', false, '/etc/hostname เก็บเฉพาะชื่อของเครื่องตัวเอง ไม่ได้เก็บตารางแปลง IP ของปลายทางอื่น', 3);
INSERT INTO public.choices VALUES ('71c01aae-e99e-4bb7-9b32-018f381507e7', 'e19ee335-78a0-4eac-b7a7-95af8779fa8f', 'ลบไฟล์ทั้งหมดใน `/tmp` เพื่อล้างแคชของระบบไฟล์', false, 'ไฟล์ใน /tmp ไม่ใช่ตาราง Host resolution ของระบบปฏิบัติการ', 4);
INSERT INTO public.choices VALUES ('16e8b226-6fee-44c8-b069-f791a5c06bfc', '23509a71-f1f8-45bf-96da-6d3a6a9c3f91', 'find /etc/nginx -type f -mmin -30', true, 'ถูกต้อง — `-mmin -30` ค้นหาไฟล์ที่ถูกแก้ไขภายใน 30 นาทีล่าสุด', 1);
INSERT INTO public.choices VALUES ('9f1599fe-e61c-446c-81c5-6b68f447daac', '23509a71-f1f8-45bf-96da-6d3a6a9c3f91', 'find /etc/nginx -type f -mtime +30', false, '`-mtime +30` คือไฟล์ที่ถูกแก้ไขมานานกว่า 30 วันแล้ว', 2);
INSERT INTO public.choices VALUES ('4466890a-8473-46a0-ad0b-3869238d3b07', '23509a71-f1f8-45bf-96da-6d3a6a9c3f91', 'stat /etc/nginx --minutes 30', false, 'คำสั่ง stat ไม่มีพารามิเตอร์ --minutes สำหรับค้นหาไฟล์', 3);
INSERT INTO public.choices VALUES ('317c2586-f75d-443d-a4ba-9c7a3c2e591c', '23509a71-f1f8-45bf-96da-6d3a6a9c3f91', 'du -sh /etc/nginx -m 30', false, 'du ใช้สำหรับคำนวณขนาดพื้นที่ดิสก์ ไม่ใช่การค้นหาไฟล์ตามเวลา', 4);
INSERT INTO public.choices VALUES ('8099cc57-afc1-47d9-95fd-72402ae2eaa0', '27c7d63d-8846-4721-927d-742b789c9ef0', 'Modify คือเวลาที่แก้ไขเนื้อหาภายในไฟล์ ส่วน Change คือเวลาที่แก้ไข Metadata เช่น สิทธิ์หรือเจ้าของไฟล์', true, 'ถูกต้อง — mtime เปลี่ยนเมื่อแก้เนื้อหาไฟล์ ส่วน ctime เปลี่ยนเมื่อแก้เนื้อหาหรือแก้สิทธิ์/เจ้าของ', 1);
INSERT INTO public.choices VALUES ('e0239bd4-a106-4337-b9d1-61858bfc1661', '27c7d63d-8846-4721-927d-742b789c9ef0', 'Modify คือเวลาที่สร้างไฟล์ครั้งแรก ส่วน Change คือเวลาที่เปิดอ่านไฟล์ล่าสุด', false, 'เวลาเปิดอ่านคือ Access (atime) และเวลาสร้างไฟล์คือ Birth', 2);
INSERT INTO public.choices VALUES ('80fc38fe-ca1b-4e83-8828-ba87b045d934', '27c7d63d-8846-4721-927d-742b789c9ef0', 'Modify ใช้กับไฟล์ข้อความเท่านั้น ส่วน Change ใช้กับไฟล์ Binary เท่านั้น', false, 'ทั้งสองค่ามีอยู่ในทุกไฟล์บนระบบ Linux', 3);
INSERT INTO public.choices VALUES ('ee73dd64-fd13-4c0b-ab4f-b58b727628a5', '27c7d63d-8846-4721-927d-742b789c9ef0', 'ทั้งสองค่ามีความหมายเหมือนกันทุกประการ แสดงซ้ำเพื่อรองรับระบบเก่า', false, 'ทั้งสองค่าแยกกันชัดเจน เช่น การรัน chmod จะอัปเดตเฉพาะ Change แต่ไม่อัปเดต Modify', 4);
INSERT INTO public.choices VALUES ('00d8de74-4aa4-4f90-b164-14c24057d608', '1ec400d8-3617-45ec-8fb7-3dbea642ec4b', 'ใช้ตรวจสอบชนิดที่แท้จริงของไฟล์จากข้อมูลภายใน โดยไม่ได้ดูแค่ชื่อนามสกุลไฟล์', true, 'ถูกต้อง — ช่วยจับผิดไฟล์ที่ตั้งนามสกุลไม่ตรงกับเนื้อหาจริง เช่น ไฟล์ดาวน์โหลดเสียที่ได้เนื้อหาเป็น HTML', 1);
INSERT INTO public.choices VALUES ('52ce6e4b-70fd-46fb-960f-b602dac3c706', '1ec400d8-3617-45ec-8fb7-3dbea642ec4b', 'ใช้แตกไฟล์บีบอัดตระกูล .gz ออกมาเป็นโฟลเดอร์', false, 'การแตกไฟล์ .gz ต้องใช้ gunzip หรือ tar ไม่ใช่คำสั่ง file', 2);
INSERT INTO public.choices VALUES ('8ace51a5-b8a3-4081-a237-bb3fb5e03f80', '1ec400d8-3617-45ec-8fb7-3dbea642ec4b', 'ใช้ซ่อมแซมไฟล์ที่เสียหายให้กลับมาเปิดได้ตามปกติ', false, 'คำสั่ง file เป็นการอ่านเพื่อระบุประเภทไฟล์เท่านั้น ไม่ได้ซ่อมแซมไฟล์', 3);
INSERT INTO public.choices VALUES ('94672ec4-9fb4-4cd3-8345-3533a51b8867', '1ec400d8-3617-45ec-8fb7-3dbea642ec4b', 'ใช้เปลี่ยนเจ้าของไฟล์ให้เป็นของผู้ใช้ปัจจุบัน', false, 'การเปลี่ยนเจ้าของไฟล์คือคำสั่ง chown', 4);
INSERT INTO public.choices VALUES ('dbb6e1d3-0b9e-4d5a-9186-0af25f2e28c3', 'f3e4853e-922b-4d4a-b10f-7d2bd40d88f1', '`kill 14520` ส่งสัญญาณ SIGTERM (15) ให้โปรเซสเคลียร์งานก่อนปิด ส่วน `kill -9 14520` ส่ง SIGKILL (9) บังคับตัดการทำงานทันที', true, 'ถูกต้อง — ควรเริ่มด้วย SIGTERM เสมอเพื่อป้องกันข้อมูลเสียหาย', 1);
INSERT INTO public.choices VALUES ('fb5f3427-f18b-47a4-9ab9-1e4473edb0dd', '05515d73-1a5e-475d-b40b-94ce12001fab', 'ssh-copy-id 10.20.1.88', false, 'ssh-copy-id ใช้ส่ง Public key ของเราไปปลายทาง ซึ่งจะติดปัญหา Host key verification failed เช่นเดียวกัน', 2);
INSERT INTO public.choices VALUES ('5311a7ed-5d31-416f-b39a-94bf54c6658e', 'f3e4853e-922b-4d4a-b10f-7d2bd40d88f1', '`kill 14520` ใช้สำหรับหยุดชั่วคราว (Pause) ส่วน `kill -9 14520` ใช้สำหรับรีสตาร์ทโปรเซสใหม่', false, 'ทั้งสองคำสั่งใช้หยุดการทำงานของโปรเซส ไม่ใช่การรีสตาร์ท', 2);
INSERT INTO public.choices VALUES ('f9a254a4-e073-4e59-affc-a62c8292897f', 'f3e4853e-922b-4d4a-b10f-7d2bd40d88f1', '`kill -9` จะรอให้โปรเซสทำงานเสร็จอีก 9 วินาทีก่อนปิด ส่วน `kill` ปิดทันที', false, 'เลข 9 คือรหัสสัญญาณ SIGKILL ไม่ใช่จำนวนวินาทีที่รอ', 3);
INSERT INTO public.choices VALUES ('d212aadf-3331-468a-a9b2-3df1941c64c1', 'f3e4853e-922b-4d4a-b10f-7d2bd40d88f1', 'ไม่มีความแตกต่างกัน เป็นเพียงรูปแบบการเขียนแบบย่อและแบบเต็ม', false, 'ต่างกันอย่างชัดเจนระหว่างการปิดแบบ Graceful (SIGTERM) และการบังคับตัดทันที (SIGKILL)', 4);
INSERT INTO public.choices VALUES ('2784cce9-c80e-4a64-a1ea-98ce6d7be6d8', 'f8280394-341a-4956-bc80-97c392a1c7be', 'หน่วยความจำ (RAM) ของเครื่องไม่เพียงพอ ทำให้ระบบ OOM Killer ของ Kernel บังคับปิดโปรเซส', true, 'ถูกต้อง — Result: oom-kill บ่งชี้ว่าถูก Out-Of-Memory Killer ตัดการทำงาน', 1);
INSERT INTO public.choices VALUES ('8ddac4d5-e0db-4709-857e-72f67c52b128', 'f8280394-341a-4956-bc80-97c392a1c7be', 'ไฟล์ `/opt/payment/worker.py` ถูกลบออกจากเครื่อง', false, 'หากไฟล์หายจะฟ้องตั้งแต่เริ่มรันด้วย exit-code ไม่ใช่ oom-kill', 2);
INSERT INTO public.choices VALUES ('21f3ce17-5577-4296-912a-e4b07293ebd6', 'f8280394-341a-4956-bc80-97c392a1c7be', 'พอร์ตเครือข่ายของบริการชนกับโปรแกรมอื่น', false, 'พอร์ตชนจะจบการทำงานด้วย exit-code และฟ้อง Address already in use', 3);
INSERT INTO public.choices VALUES ('80ac2668-c5bb-4342-ba1b-9ee93caf82f4', 'f8280394-341a-4956-bc80-97c392a1c7be', 'ยังไม่ได้เปิดใช้งาน `systemctl enable` ให้กับบริการนี้', false, 'ในบรรทัด Loaded แสดงว่า enabled อยู่แล้ว และสาเหตุคือหน่วยความจำเต็ม', 4);
INSERT INTO public.choices VALUES ('89d70e0d-9e35-4727-afe7-7635912b6688', '90c789a2-b6f3-4c51-9a7a-df5d3e8f28e2', 'systemctl list-units --failed', true, 'ถูกต้อง — แสดงเฉพาะบริการที่อยู่ในสถานะ failed ทั้งหมด', 1);
INSERT INTO public.choices VALUES ('9bb68765-6e40-4d14-a430-ff85355bc8bd', '90c789a2-b6f3-4c51-9a7a-df5d3e8f28e2', 'systemctl is-active --all', false, 'is-active ใช้ตรวจชื่อบริการที่ระบุ ไม่ใช่การแสดงรายการที่ล่มทั้งหมด', 2);
INSERT INTO public.choices VALUES ('1017258d-1850-4249-a883-b4c1148b9b19', '90c789a2-b6f3-4c51-9a7a-df5d3e8f28e2', 'ps aux --failed', false, 'คำสั่ง ps aux แสดงโปรเซสที่ยังรันอยู่ ไม่มีตัวเลือก --failed', 3);
INSERT INTO public.choices VALUES ('1086a172-09b8-4a29-ba11-fb460337afcd', '90c789a2-b6f3-4c51-9a7a-df5d3e8f28e2', 'journalctl --list-failed', false, 'journalctl ใช้เปิดอ่าน Log ไม่มีตัวเลือก --list-failed', 4);
INSERT INTO public.choices VALUES ('94f18c3e-d233-42c0-8f0f-01ca5c8211dd', '38b2cbc9-0ffb-4c2f-9042-fcd9bf03fa06', 'คือ Zombie Process ที่ทำงานจบไปแล้วแต่โปรเซสแม่ยังไม่อ่านสถานะจบงาน จึงไม่สามารถใช้ kill -9 สั่งฆ่าตัวมันซ้ำได้', true, 'ถูกต้อง — Zombie ไม่มีโค้ดรันอยู่แล้ว เหลือเพียงรายการในตารางโปรเซสที่รอโปรเซสแม่มาเก็บกวาด', 1);
INSERT INTO public.choices VALUES ('d2c85bfa-1519-4662-ba60-2fb398ca77bd', '38b2cbc9-0ffb-4c2f-9042-fcd9bf03fa06', 'คือโปรเซสที่ถูกเข้ารหัสด้วยไวรัส ต้องใช้สิทธิ์ root รัน `pkill -f defunct` เท่านั้น', false, 'Zombie process เป็นกลไกปกติของตารางโปรเซสบน Linux ไม่ใช่ไวรัส', 2);
INSERT INTO public.choices VALUES ('cf9a551f-dbd7-4e59-99c9-e5ae31b6f70f', 'ebbab95e-1663-4e95-9c8e-47efd927b2b5', 'grep -r "healthcheck" access.log | tail -n 20', false, 'จะแสดงเฉพาะบรรทัดที่มีคำว่า healthcheck เท่านั้น (ตรงข้ามกับที่ต้องการ)', 2);
INSERT INTO public.choices VALUES ('f78ff077-1b24-4b38-b68b-73bdc35aa8c0', '38b2cbc9-0ffb-4c2f-9042-fcd9bf03fa06', 'คือโปรเซสที่กำลังบีบอัดไฟล์แบบ Zip (Z) และห้ามขัดจังหวะจนกว่าจะบีบอัดเสร็จ', false, 'ตัวอักษร Z ในคอลัมน์ STAT หมายถึง Zombie ไม่ใช่การบีบอัดไฟล์', 3);
INSERT INTO public.choices VALUES ('4d805f1b-7f72-4b60-a62c-d3bdab45636a', '38b2cbc9-0ffb-4c2f-9042-fcd9bf03fa06', 'คือโปรเซสของ Kernel ที่ถูกล็อกด้วยฮาร์ดแวร์ ต้องถอดสายแลนออกก่อนจึงจะ kill ได้', false, 'ไม่เกี่ยวข้องกับสายแลนหรือการล็อกฮาร์ดแวร์', 4);
INSERT INTO public.choices VALUES ('59c7390a-2dcf-4f2f-bf27-ac548e511f6b', 'd7eedd6d-d129-48c5-a471-bde470b716ee', 'journalctl -u nginx -n 100 -f', true, 'ถูกต้อง — ระบุยูนิต (-u), จำนวนบรรทัด (-n 100) และติดตามสด (-f)', 1);
INSERT INTO public.choices VALUES ('0b80ee61-b221-48bd-8165-cf25afc2af92', 'd7eedd6d-d129-48c5-a471-bde470b716ee', 'systemctl log nginx --tail 100', false, 'systemctl ไม่มีคำสั่งย่อย log', 2);
INSERT INTO public.choices VALUES ('430bf8d5-b545-478e-a23b-0694160d5db7', 'd7eedd6d-d129-48c5-a471-bde470b716ee', 'ps aux -u nginx -n 100', false, 'ps ใช้ดูรายการโปรเซส ไม่ใช่คำสั่งเปิดอ่าน Log ของ systemd', 3);
INSERT INTO public.choices VALUES ('0b031d9f-dfbb-41da-bd8a-f1dd1668048d', 'd7eedd6d-d129-48c5-a471-bde470b716ee', 'top -u nginx -f 100', false, 'top ใช้ดูการใช้ CPU/RAM ของโปรเซส ไม่ใช่การอ่าน Log', 4);
INSERT INTO public.choices VALUES ('62dda2c8-76c7-4c2f-b836-f10c034a539d', '9d6fdd1a-c91e-4801-b419-5b7464be34e6', 'ตั้งค่าให้บริการ nginx เริ่มทำงานอัตโนมัติเมื่อบูตเครื่องเซิร์ฟเวอร์', true, 'ถูกต้อง — enable คือการผูกบริการเข้ากับเป้าหมายการบูตเครื่อง', 1);
INSERT INTO public.choices VALUES ('722c0325-8c51-4662-a0d0-4027f05849a0', '9d6fdd1a-c91e-4801-b419-5b7464be34e6', 'สั่งรีสตาร์ทบริการ nginx ทันทีโดยไม่ตั้งค่าการบูต', false, 'การรีสตาร์ททันทีคือคำสั่ง systemctl restart nginx', 2);
INSERT INTO public.choices VALUES ('f9744e61-4874-44ec-9062-ca5cd56a9d84', '9d6fdd1a-c91e-4801-b419-5b7464be34e6', 'เปิดพอร์ต 80 และ 443 บน Firewall ให้กับ nginx', false, 'systemctl enable จัดการเฉพาะ systemd unit ไม่ได้แก้กฎ Firewall', 3);
INSERT INTO public.choices VALUES ('c31c2fec-76fb-4cf3-8f14-ba23205b0dff', '9d6fdd1a-c91e-4801-b419-5b7464be34e6', 'อัปเดตโปรแกรม nginx เป็นเวอร์ชันล่าสุด', false, 'การอัปเดตแพ็กเกจต้องใช้ apt หรือ dnf ไม่ใช่ systemctl', 4);
INSERT INTO public.choices VALUES ('1433b4fc-7e4a-492d-a0de-b9dc7ddbfdf0', '1585e544-0263-4635-83aa-d715e87cb38e', 'กดปุ่ม M (พิมพ์ใหญ่)', true, 'ถูกต้อง — M रेียงตาม Memory, P เรียงตาม CPU', 1);
INSERT INTO public.choices VALUES ('875786b5-6a6a-4f67-9c44-aa198452f0d7', '1585e544-0263-4635-83aa-d715e87cb38e', 'กดปุ่ม R (พิมพ์ใหญ่)', false, 'ปุ่ม r/R ใช้สำหรับเปลี่ยนค่า renice หรือสลับทิศทางการเรียง', 2);
INSERT INTO public.choices VALUES ('7cb3bcec-cf70-48da-bbbf-c03698002731', '1585e544-0263-4635-83aa-d715e87cb38e', 'กดปุ่ม K (พิมพ์ใหญ่)', false, 'ปุ่ม k ใช้สำหรับส่งสัญญาณ kill โปรเซส', 3);
INSERT INTO public.choices VALUES ('a708f5df-5037-4a35-831e-c4b100b137b8', '1585e544-0263-4635-83aa-d715e87cb38e', 'กดปุ่ม Z (พิมพ์ใหญ่)', false, 'ปุ่ม Z ใช้ตั้งค่าสีการแสดงผลใน top', 4);
INSERT INTO public.choices VALUES ('406eab2b-67a9-4e02-80c7-b8ebd31bc70e', '063ee6ab-3870-4443-a4c7-f47dd6b52be3', 'grep -in "timeout" app.log', true, 'ถูกต้อง — -i ไม่สนใจตัวพิมพ์เล็ก-ใหญ่ และ -n แสดงเลขบรรทัด', 1);
INSERT INTO public.choices VALUES ('66787394-6f9d-41d0-8c38-016066eff954', '063ee6ab-3870-4443-a4c7-f47dd6b52be3', 'grep -vr "timeout" app.log', false, '-v คือการกลับเงื่อนไข (ไม่เอาบรรทัดที่มีคำนี้) และ -r คือค้นหาทั้งโฟลเดอร์', 2);
INSERT INTO public.choices VALUES ('5a116f87-b6d5-4261-bc7d-c75965a28095', '063ee6ab-3870-4443-a4c7-f47dd6b52be3', 'grep -c "timeout" app.log', false, '-c แสดงเฉพาะจำนวนบรรทัดรวมที่พบ ไม่ได้แสดงข้อความและเลขบรรทัด', 3);
INSERT INTO public.choices VALUES ('107dc27e-2523-4609-a91a-66d53e9eacff', '063ee6ab-3870-4443-a4c7-f47dd6b52be3', 'find app.log -name "timeout"', false, 'find -name ใช้ค้นหาชื่อไฟล์ ไม่ใช่การค้นหาข้อความภายในไฟล์', 4);
INSERT INTO public.choices VALUES ('6492f027-c44d-4ac8-804d-7e189c8128b7', 'c848a792-a49c-488d-ba20-3fbea6501ed6', '`>` จะเขียนทับข้อมูลเดิมในไฟล์ `summary.txt` ทั้งหมด ส่วน `>>` จะเขียนต่อท้ายไฟล์เดิม', true, 'ถูกต้อง — ต้องระวังการใช้ `>` กับไฟล์ที่มีข้อมูลสำคัญอยู่แล้ว', 1);
INSERT INTO public.choices VALUES ('c17e19a8-fdaa-4fb9-b2d7-384bd870f31e', 'c848a792-a49c-488d-ba20-3fbea6501ed6', '`>` ใช้สำหรับข้อความสั้นๆ ส่วน `>>` ใช้สำหรับไฟล์ที่มีขนาดเกิน 100 MB', false, 'ทั้งสองตัวไม่ได้จำกัดขนาดไฟล์ แต่ต่างกันที่การเขียนทับหรือเขียนต่อท้าย', 2);
INSERT INTO public.choices VALUES ('ae70f5f8-ff09-4968-ae3c-fdcd3d688908', 'c848a792-a49c-488d-ba20-3fbea6501ed6', '`>>` จะเรียงลำดับข้อความจากมากไปน้อยให้อัตโนมัติ ส่วน `>` ไม่เรียง', false, 'การ Redirect ไม่มีการเรียงลำดับข้อความ', 3);
INSERT INTO public.choices VALUES ('76a2d5c5-2463-4ffd-b910-763745e9da7e', 'c848a792-a49c-488d-ba20-3fbea6501ed6', '`>` จะบันทึกเฉพาะ Standard Output ส่วน `>>` จะบันทึกทั้ง Standard Output และ Standard Error', false, 'ทั้ง `>` และ `>>` บันทึกเฉพาะ stdout (1) หากต้องการรวม stderr ต้องใช้ `2>&1`', 4);
INSERT INTO public.choices VALUES ('74527afe-d268-4177-9455-fa5c4118b773', 'a2fad7a4-377c-4205-a3dd-ba2639d4f345', 'awk ''{print $1}'' /var/log/nginx/access.log | sort | uniq -c | sort -nr | head -n 5', true, 'ถูกต้อง — ดึงคอลัมน์แรก เรียงก่อนนับด้วย uniq -c แล้วเรียงตัวเลขจากมากไปน้อย', 1);
INSERT INTO public.choices VALUES ('10219b8b-bcc1-40b3-8b34-e69da78dba35', 'a2fad7a4-377c-4205-a3dd-ba2639d4f345', 'awk ''{print $1}'' /var/log/nginx/access.log | uniq -c | head -n 5', false, 'หากไม่รัน sort ก่อน uniq -c บรรทัด IP เดียวกันที่ไม่ได้อยู่ติดกันจะไม่ถูกนับรวมกัน', 2);
INSERT INTO public.choices VALUES ('6403c9f9-7b35-43b0-902e-d1958aa38638', 'a2fad7a4-377c-4205-a3dd-ba2639d4f345', 'grep -c "IP" /var/log/nginx/access.log | sort -r | tail -n 5', false, 'ในไฟล์ log ไม่มีคำว่า "IP" ตรงๆ และ grep -c คืนค่าเป็นตัวเลขรวมบรรทัดเดียว', 3);
INSERT INTO public.choices VALUES ('cd8b3c44-1327-4165-9204-df22c531c50c', 'a2fad7a4-377c-4205-a3dd-ba2639d4f345', 'cut -d'':'' -f1 /var/log/nginx/access.log | wc -l', false, 'คอลัมน์คั่นด้วยช่องว่างไม่ใช่โคลอน และ wc -l นับเพียงจำนวนบรรทัดทั้งหมด', 4);
INSERT INTO public.choices VALUES ('945bc5fa-bd7a-42f9-88f2-6ae1aaecb705', 'ebbab95e-1663-4e95-9c8e-47efd927b2b5', 'grep -v "healthcheck" access.log | tail -n 20', true, 'ถูกต้อง — grep -v ใช้ตัดบรรทัดที่มีคำว่า healthcheck ออก', 1);
INSERT INTO public.choices VALUES ('793754a2-95fe-4d93-90d7-575688b9b05d', 'ebbab95e-1663-4e95-9c8e-47efd927b2b5', 'grep -E "healthcheck" access.log | head -n 20', false, 'แสดงเฉพาะบรรทัดที่มีคำว่า healthcheck 20 บรรทัดแรก', 3);
INSERT INTO public.choices VALUES ('68ea6579-5e74-4692-b4db-a97cece643cc', 'ebbab95e-1663-4e95-9c8e-47efd927b2b5', 'uniq -v "healthcheck" access.log', false, 'คำสั่ง uniq ไม่มีตัวเลือก -v สำหรับกรองข้อความ', 4);
INSERT INTO public.choices VALUES ('70146e4a-d7ac-4817-8cc3-55b90c445cf9', 'beef98a0-5be8-485d-84d7-dc1947afead4', 'เพราะคำสั่ง uniq จะรวมเฉพาะบรรทัดซ้ำที่อยู่ติดกันเท่านั้น ต้องใส่ `sort` คั่นก่อน `uniq -c` เสมอ', true, 'ถูกต้อง — การใช้ sort status.txt | uniq -c จะจัดกลุ่มให้คำเดียวกันอยู่ติดกันก่อนนับ', 1);
INSERT INTO public.choices VALUES ('e2e4654f-f201-4f2d-b4da-c870fbce22b5', 'beef98a0-5be8-485d-84d7-dc1947afead4', 'เพราะคำสั่ง uniq รองรับเฉพาะตัวเลข ไม่รองรับข้อความภาษาอังกฤษ', false, 'uniq รองรับข้อความทุกชนิดแต่ต้องเรียงให้บรรทัดซ้ำอยู่ติดกันก่อน', 2);
INSERT INTO public.choices VALUES ('20f36c6d-26af-459b-a0d8-d4b34e33af8d', 'beef98a0-5be8-485d-84d7-dc1947afead4', 'เพราะต้องใช้คำสั่ง `wc -l` แทน `uniq -c` ในการแยกนับตามกลุ่มคำ', false, 'wc -l นับจำนวนบรรทัดรวมทั้งหมด ไม่ได้แยกนับตามกลุ่มคำ', 3);
INSERT INTO public.choices VALUES ('156e4756-f985-48c3-b867-7f9eaca69eff', 'beef98a0-5be8-485d-84d7-dc1947afead4', 'เพราะบรรทัดแรกมีช่องว่างที่มองไม่เห็นต่อท้าย', false, 'ต่อให้ข้อความเหมือนกันทุกประการ หากมีบรรทัดอื่นคั่นกลาง uniq ก็จะไม่รวมให้หากไม่ sort ก่อน', 4);
INSERT INTO public.choices VALUES ('49f6c9a5-81dc-44d9-89d7-1c2ec827f419', '94e77eb0-8531-4d36-b351-a394e5a164e3', 'grep -E -C 3 "ERROR|FATAL|CRITICAL" server.log', true, 'ถูกต้อง — -E ใช้ค้นหาหลายเงื่อนไขด้วย | และ -C 3 แสดงบริบทรอบข้าง 3 บรรทัด', 1);
INSERT INTO public.choices VALUES ('7be5ae7a-bd9d-4e53-b5d9-ca4db531f07b', '94e77eb0-8531-4d36-b351-a394e5a164e3', 'grep -v -n 3 "ERROR|FATAL|CRITICAL" server.log', false, '-v คือการตัดออก และ -n ไม่ได้รับตัวเลขจำนวนบรรทัดบริบท', 2);
INSERT INTO public.choices VALUES ('6310dc25-d1d4-4d1f-a360-7e37b261b20a', '94e77eb0-8531-4d36-b351-a394e5a164e3', 'awk "ERROR|FATAL|CRITICAL" -C 3 server.log', false, 'ไวยากรณ์ของ awk ไม่ได้ใช้ตัวเลือก -C 3 แบบ grep', 3);
INSERT INTO public.choices VALUES ('2b70eeee-47b7-4c2d-8d2c-568b082613b3', '94e77eb0-8531-4d36-b351-a394e5a164e3', 'cut -C 3 "ERROR,FATAL,CRITICAL" server.log', false, 'cut ใช้ตัดคอลัมน์ตามตัวคั่น ไม่ใช่คำสั่งค้นหาบรรทัด', 4);
INSERT INTO public.choices VALUES ('de4b8e1a-9cf1-4de5-a3f7-a5975edc1c65', 'ffc2a0cd-6e46-43a2-90b3-9302014d2039', 'ส่งข้อความข้อผิดพลาด (stderr = 2) ไปรวมกับผลลัพธ์ปกติ (stdout = 1) เพื่อบันทึกลงไฟล์เดียวกัน', true, 'ถูกต้อง — ช่วยให้ไม่พลาดข้อความ Error เวลาเก็บผลรันลงไฟล์', 1);
INSERT INTO public.choices VALUES ('ad40d922-92e9-4e42-b163-8fd29d73e807', 'ffc2a0cd-6e46-43a2-90b3-9302014d2039', 'สั่งให้รันสคริปต์ซ้ำ 2 รอบ และหน่วงเวลา 1 วินาที', false, 'ตัวเลข 2 และ 1 คือหมายเลข File Descriptor ไม่ใช่จำนวนรอบการรัน', 2);
INSERT INTO public.choices VALUES ('60e44d42-a4c4-45b1-8532-baab50f1b490', 'ffc2a0cd-6e46-43a2-90b3-9302014d2039', 'บันทึกเฉพาะ 2 บรรทัดแรกและ 1 บรรทัดสุดท้ายของผลลัพธ์', false, 'การตัดบรรทัดแรกและท้ายต้องใช้ head และ tail', 3);
INSERT INTO public.choices VALUES ('6a6d16d1-11b2-488f-9568-e4a312b3d262', 'ffc2a0cd-6e46-43a2-90b3-9302014d2039', 'เปรียบเทียบว่าค่าตัวแปรที่ 2 มากกว่าตัวแปรที่ 1 หรือไม่', false, 'ไม่ใช่ตัวดำเนินการเปรียบเทียบทางคณิตศาสตร์', 4);
INSERT INTO public.choices VALUES ('0002fcad-c676-43bc-af11-0d1996d3c582', '1ca32e9b-b597-44d2-8add-2849374abcb5', '`/var/log/auth.log` (Ubuntu/Debian) และ `/var/log/secure` (RHEL/Rocky)', true, 'ถูกต้อง — เป็นไฟล์มาตรฐานสำหรับตรวจประวัติ SSH และ sudo ของแต่ละค่าย', 1);
INSERT INTO public.choices VALUES ('41b8d9e8-4a5b-49df-bfd5-f17cf31ab6d5', '1ca32e9b-b597-44d2-8add-2849374abcb5', '`/var/log/syslog` (Ubuntu/Debian) และ `/var/log/httpd` (RHEL/Rocky)', false, 'syslog เป็น log ทั่วไป ส่วน httpd เป็นโฟลเดอร์ log ของ Apache Web Server', 2);
INSERT INTO public.choices VALUES ('091be5f2-bb38-4983-b701-d18e44fa2425', '1ca32e9b-b597-44d2-8add-2849374abcb5', '`/etc/passwd` (Ubuntu/Debian) และ `/etc/shadow` (RHEL/Rocky)', false, '/etc/passwd และ /etc/shadow เป็นไฟล์เก็บข้อมูลบัญชีผู้ใช้ ไม่ใช่ไฟล์ Log', 3);
INSERT INTO public.choices VALUES ('d8d6b822-6d80-4003-bfee-5331295080cc', '1ca32e9b-b597-44d2-8add-2849374abcb5', '`/var/log/dmesg` ทั้งสองตระกูล', false, 'dmesg เก็บข้อความจาก Kernel และฮาร์ดแวร์ ไม่ใช่ประวัติการล็อกอิน SSH', 4);
INSERT INTO public.choices VALUES ('1a4a748c-bb00-43c1-8a34-00406c1ad5e8', '1fabb88c-d4d0-4b99-b096-f544592a7eae', 'ใช้คำสั่ง `zgrep "ORA-12170" /var/log/app/worker.log.1.gz` เพื่อค้นหาโดยไม่ต้องแตกไฟล์ลงดิสก์', true, 'ถูกต้อง — รวดเร็วและไม่ใช้พื้นที่ดิสก์เพิ่ม', 1);
INSERT INTO public.choices VALUES ('64575ced-d7e0-4be7-9354-b824c673abbb', '1fabb88c-d4d0-4b99-b096-f544592a7eae', 'รัน `gunzip /var/log/app/worker.log.1.gz` เพื่อแตกไฟล์ออกมาก่อนทุกครั้ง', false, 'การแตกไฟล์ใหญ่ลงใน /var/log อาจทำให้ดิสก์เต็มทันทีและทำให้ไฟล์ .gz เดิมหายไป', 2);
INSERT INTO public.choices VALUES ('9d87b974-abe3-4188-8f3f-651fbd1f381a', '1fabb88c-d4d0-4b99-b096-f544592a7eae', 'เปลี่ยนชื่อไฟล์โดยลบ `.gz` ออกด้วยคำสั่ง `mv` แล้วใช้ `cat` เปิดอ่าน', false, 'การเปลี่ยนแค่ชื่อไฟล์ไม่ได้คลายการบีบอัด เนื้อหาข้างในยังเป็นข้อมูลไบนารีที่อ่านไม่ได้', 3);
INSERT INTO public.choices VALUES ('0089c71a-0403-4f01-b402-5ee9555eaa9d', '1fabb88c-d4d0-4b99-b096-f544592a7eae', 'ลบไฟล์ `.gz` ทิ้งแล้วสั่งให้แอปพลิเคชันสร้าง Log ของเมื่อวานขึ้นมาใหม่', false, 'Log เป็นข้อมูลเหตุการณ์ที่ผ่านไปแล้ว หากลบทิ้งจะไม่สามารถสร้างย้อนหลังได้', 4);
INSERT INTO public.choices VALUES ('5e8ef015-0917-4dc4-924a-ecb53b144c1b', 'aaa1442e-1b0e-4ba3-9c3b-d709f527716c', 'ค้นหาช่วงเวลาประมาณ 08:15 ถึง 08:25 (เนื่องจากเครื่องใช้เวลา UTC ซึ่งช้ากว่าเวลาไทย 7 ชั่วโมง)', true, 'ถูกต้อง — 15:20 (GMT+7) ลบ 7 ชั่วโมง = 08:20 UTC', 1);
INSERT INTO public.choices VALUES ('9626bcb4-5c2a-445f-8fa9-74f569526073', 'aaa1442e-1b0e-4ba3-9c3b-d709f527716c', 'ค้นหาช่วงเวลา 15:15 ถึง 15:25 ได้ทันที เพราะ journalctl จะแปลงเป็นเวลาไทยให้อัตโนมัติเสมอ', false, 'journalctl อ้างอิงตาม Local time ของเครื่องเซิร์ฟเวอร์ ซึ่งในที่นี้ตั้งเป็น UTC', 2);
INSERT INTO public.choices VALUES ('13e7098b-6f3c-4b12-9bd8-55df5090c025', 'aaa1442e-1b0e-4ba3-9c3b-d709f527716c', 'ค้นหาช่วงเวลา 22:15 ถึง 22:25 (บวกเพิ่มไปอีก 7 ชั่วโมง)', false, 'UTC ช้ากว่าเวลาไทย ต้องนำเวลาไทยลบออก 7 ชั่วโมง ไม่ใช่บวกเพิ่ม', 3);
INSERT INTO public.choices VALUES ('d815a860-affb-4680-a8a6-267ae241d405', 'aaa1442e-1b0e-4ba3-9c3b-d709f527716c', 'เปลี่ยน Timezone ของเซิร์ฟเวอร์ Production ทันทีด้วย `timedatectl set-timezone` ก่อนค้นหา', false, 'ห้ามเปลี่ยน Timezone ของเครื่อง Production โดยพลการเพราะจะกระทบแอปพลิเคชันและ Cron job ทั้งระบบ', 4);
INSERT INTO public.choices VALUES ('f0e5c59a-cda2-4718-aa29-2456ef1ee4b8', '2000d365-d8a9-4337-acea-cf9b3795d920', 'โปรเซส java ถูก Kernel OOM Killer บังคับปิดเพราะ RAM ไม่พอ ให้เก็บบรรทัด Log นี้พร้อมสถานะหน่วยความจำเพื่อส่งต่อตาม Runbook', true, 'ถูกต้อง — dmesg -T เป็นหลักฐานสำคัญที่สุดเมื่อโปรเซสดับจาก OOM โดยไม่มี Error ใน application log', 1);
INSERT INTO public.choices VALUES ('a8ead9cc-81fc-4677-99e9-152b774db665', '2000d365-d8a9-4337-acea-cf9b3795d920', 'การ์ดเครือข่ายของเครื่องหลุดการเชื่อมต่อ ต้องรีสตาร์ทระบบเครือข่าย', false, 'ข้อความระบุชัดเจนว่าเป็น Out of memory ไม่ใช่ปัญหาเครือข่าย', 2);
INSERT INTO public.choices VALUES ('9486d5f7-d303-4471-afa2-84ff730e16a5', '2000d365-d8a9-4337-acea-cf9b3795d920', 'พื้นที่ฮาร์ดดิสก์เต็ม 100% ต้องลบไฟล์โปรแกรม java ทิ้ง', false, 'Out of memory หมายถึงหน่วยความจำหลัก (RAM/Swap) ไม่พอ ไม่ใช่พื้นที่ดิสก์', 3);
INSERT INTO public.choices VALUES ('df713038-ad8f-41f7-99d7-4b7838f49295', '2000d365-d8a9-4337-acea-cf9b3795d920', 'ผู้ดูแลระบบคนอื่นสั่งรันคำสั่ง `systemctl stop` ตามปกติ', false, 'การหยุดปกติจะไม่ขึ้นข้อความ Out of memory: Killed process ใน dmesg', 4);
INSERT INTO public.choices VALUES ('b5a47da0-1d0f-4b0c-a2ee-cc91fd074118', 'ec034ac3-b426-4d0c-b5d3-44e557e114b3', 'แสดง Log ของบริการ api-gateway ในช่วงเวลา 09:00 ถึง 09:30 เฉพาะระดับ Error ขึ้นไปเท่านั้น', true, 'ถูกต้อง — ช่วยจำกัดวงค้นหาเฉพาะช่วงเกิดเหตุและตัดข้อความ INFO/DEBUG ออก', 1);
INSERT INTO public.choices VALUES ('d70e16e6-8153-4f33-972c-37e038df7c88', 'ec034ac3-b426-4d0c-b5d3-44e557e114b3', 'ลบ Log ของบริการ api-gateway ในช่วงเวลา 09:00 ถึง 09:30 ทิ้งทั้งหมด', false, 'เป็นคำสั่งเปิดอ่านและกรองข้อมูล ไม่ได้ลบ Log', 2);
INSERT INTO public.choices VALUES ('96e7a915-7511-41c5-b665-bd7932268173', 'ec034ac3-b426-4d0c-b5d3-44e557e114b3', 'แสดง Log ทุกบริการในเครื่องยกเว้น api-gateway', false, '-u เป็นการเลือกเฉพาะยูนิตที่ระบุ ไม่ใช่การยกเว้น', 3);
INSERT INTO public.choices VALUES ('f9340d2c-031f-4320-82b0-714af6a552b6', 'ec034ac3-b426-4d0c-b5d3-44e557e114b3', 'แสดงเฉพาะ Log ระดับ INFO และ DEBUG เท่านั้น', false, '-p err จะกรองเอาเฉพาะระดับ error, crit, alert และ emerg', 4);
INSERT INTO public.choices VALUES ('8cfb3aab-c4ee-47c3-9263-07f0baf9c3c7', '72dae6ef-9cc7-4886-a78e-b03dcf03b3f0', 'แปลงเวลานับจากตอนบูตเครื่อง (วินาที) ให้เป็นรูปแบบวันที่และเวลาปกติที่อ่านเข้าใจง่าย', true, 'ถูกต้อง — ช่วยให้เทียบเวลาเกิดเหตุกับ Log อื่นๆ ได้ทันที (แม้เวลาจาก dmesg -T อาจคลาดเคลื่อนเล็กน้อยหากเครื่องเคย suspend)', 1);
INSERT INTO public.choices VALUES ('3cedeb24-4365-4026-bbc2-ba13e4927c31', '72dae6ef-9cc7-4886-a78e-b03dcf03b3f0', 'แปลข้อความภาษาอังกฤษใน Kernel ให้เป็นภาษาไทยทั้งหมด', false, '-T ย่อมาจาก human-readable timestamp ไม่ใช่การแปลภาษา', 2);
INSERT INTO public.choices VALUES ('e13b8ad2-e200-4790-8856-523f268879f0', '72dae6ef-9cc7-4886-a78e-b03dcf03b3f0', 'ส่งข้อความ Log ไปยังโปรแกรม Telegram อัตโนมัติ', false, 'dmesg ไม่มีฟีเจอร์ส่งแจ้งเตือนออกภายนอก', 3);
INSERT INTO public.choices VALUES ('42dad8d4-6d29-48a3-8167-452a343ef84f', '72dae6ef-9cc7-4886-a78e-b03dcf03b3f0', 'กรองเฉพาะข้อความที่เกี่ยวกับโปรโตคอล TCP เท่านั้น', false, '-T เกี่ยวกับการแสดงผลเวลา ไม่ใช่การกรองโปรโตคอล', 4);
INSERT INTO public.choices VALUES ('40efff27-475e-4ec9-9522-4b3ee71be1fe', '727c6eae-6010-4167-8926-e7b834cdb6c4', 'ชื่อเครื่อง, พาธไฟล์ Log, ช่วงเวลาพร้อม Timezone, บรรทัด Error พร้อมบริบทรอบข้าง และ Request/Transaction ID', true, 'ถูกต้อง — ช่วยให้ทีม Tier 2 วิเคราะห์ต่อได้ทันทีโดยไม่ต้องกลับมานั่งไล่หาพื้นฐานใหม่', 1);
INSERT INTO public.choices VALUES ('ed315225-0bc5-453c-9e35-542fa2a38e08', '727c6eae-6010-4167-8926-e7b834cdb6c4', 'แคปภาพหน้าจอเฉพาะคำว่า Error คำเดียวโดยตัดเวลาและชื่อเครื่องออก', false, 'ภาพแคปที่ไม่มีเวลา ชื่อเครื่อง และบริบทรอบข้างทำให้ตรวจสอบต่อไม่ได้', 2);
INSERT INTO public.choices VALUES ('065d3eec-7ad0-42e3-8a36-e55687ba1b8b', '727c6eae-6010-4167-8926-e7b834cdb6c4', 'คัดลอกไฟล์ Log ขนาด 5 GB ทั้งไฟล์วางลงในช่องแชต', false, 'ไฟล์ใหญ่เกินไปและไม่ได้คัดกรองช่วงเวลาที่เกิดเหตุ', 3);
INSERT INTO public.choices VALUES ('d02047c6-244a-46ca-b6cd-32003ce519bf', '727c6eae-6010-4167-8926-e7b834cdb6c4', 'แจ้งแค่ว่า ''ระบบเสีย รบกวนเช็กให้ด้วย'' โดยไม่แนบ Log ใดๆ', false, 'ขาดข้อมูลหลักฐานเบื้องต้นที่ Tier 1 ต้องตรวจสอบก่อนส่งต่อ', 4);
INSERT INTO public.choices VALUES ('1a477275-4471-4d6b-9259-0cfdd9921288', '4405d551-253e-42a6-8516-84a2da370226', 'หน่วยความจำยังเหลือพร้อมใช้งานอีกประมาณ 11 GiB (ดูจากคอลัมน์ available) โดยส่วนที่เหลือถูกนำไปทำ buff/cache ตามปกติ', true, 'ถูกต้อง — ใน Linux ต้องดูค่า available เป็นหลัก ไม่ใช่ค่า free', 1);
INSERT INTO public.choices VALUES ('845a4b5f-2f02-4b67-918e-46e2446e0f9b', '4405d551-253e-42a6-8516-84a2da370226', 'หน่วยความจำกำลังจะหมดวิกฤต เพราะเหลือพื้นที่ว่างจริงเพียง 380 MiB ต้องรีบูตเครื่องทันที', false, 'เข้าใจผิดเพราะดูเฉพาะคอลัมน์ free โดยไม่ดู available ที่รวมหน่วยความจำซึ่งพร้อมคืนจาก cache แล้ว', 2);
INSERT INTO public.choices VALUES ('166e9a09-2f6a-43ba-95d3-6fe8b94e267d', '4405d551-253e-42a6-8516-84a2da370226', 'เกิดปัญหา Memory Leak ในระบบแคชจนกิน RAM ไปถึง 12 GiB', false, 'การใช้ RAM ว่างมาทำ Page cache (buff/cache) เป็นกลไกเพิ่มความเร็วปกติของ Linux Kernel', 3);
INSERT INTO public.choices VALUES ('e10dd692-e668-4ef5-a300-8cb7d619db99', '4405d551-253e-42a6-8516-84a2da370226', 'Swap เสียหายเพราะค่า used แสดงเป็น 0B', false, 'Swap used เป็น 0B แปลว่า RAM มีเพียงพอจนไม่ต้องนำข้อมูลไปพักลง Swap บนดิสก์', 4);
INSERT INTO public.choices VALUES ('78a71ea1-2c02-47fe-acc9-3da7bf6d5b14', 'ff00fcfc-cc97-4ef4-a859-b9e111a5857a', 'จำนวน Inode ของพาร์ทิชัน `/var` ถูกใช้จนเต็ม 100% เพราะมีไฟล์ย่อยจำนวนมากเกินไป', true, 'ถูกต้อง — เมื่อ IFree = 0 ระบบจะไม่สามารถสร้างไฟล์หรือโฟลเดอร์ใหม่ได้เลย', 1);
INSERT INTO public.choices VALUES ('8b2fdfae-2c60-4a4d-89ff-9089053ba5aa', 'ff00fcfc-cc97-4ef4-a859-b9e111a5857a', 'คำสั่ง `df -h` แสดงผลผิดพลาดเพราะไม่ได้รันด้วยสิทธิ์ root', false, 'df -h แสดงความจุถูกต้องแล้ว แต่ปัญหาเกิดจากจำนวน Inode เต็ม', 2);
INSERT INTO public.choices VALUES ('d457ecc6-8656-46b2-879f-c2b45579bb3d', 'ff00fcfc-cc97-4ef4-a859-b9e111a5857a', 'แรมของเครื่องเต็มทำให้สร้างไฟล์ลงดิสก์ไม่ได้', false, 'ผลลัพธ์ชี้ชัดเจนที่ IUse% = 100% ซึ่งเป็นเรื่องของ Inode บนระบบไฟล์', 3);
INSERT INTO public.choices VALUES ('e79e7abe-fa40-4781-b239-b7b1a9ba1c53', 'ff00fcfc-cc97-4ef4-a859-b9e111a5857a', 'พาร์ทิชัน `/var` จำกัดให้เก็บข้อมูลได้สูงสุดเพียง 50% ของขนาดจริง', false, 'ไม่ได้จำกัดที่ 50% แต่ติดที่จำนวน Inode หมด (5,242,880 Inodes)', 4);
INSERT INTO public.choices VALUES ('b303fdc0-2e7a-4a81-968a-271aa16149e7', '70a6fe79-8783-47a0-9025-d0f2dfc849f9', 'lsof +L1', true, 'ถูกต้อง — แสดงโปรเซสและ PID ที่ยังเปิดไฟล์ซึ่งถูกลบชื่อไปแล้ว (unlinked open files)', 1);
INSERT INTO public.choices VALUES ('83ff8a29-2aac-499b-91ea-7cff5472d42e', '70a6fe79-8783-47a0-9025-d0f2dfc849f9', 'df -i', false, 'df -i ใช้ดูจำนวน Inode ไม่ได้แสดงรายชื่อโปรเซสที่เปิดไฟล์ค้าง', 2);
INSERT INTO public.choices VALUES ('80110808-e977-4b8f-941c-e0b673915762', '70a6fe79-8783-47a0-9025-d0f2dfc849f9', 'free -h', false, 'free -h ใช้ดูหน่วยความจำ RAM และ Swap', 3);
INSERT INTO public.choices VALUES ('8868a1ea-7876-4141-9aee-79a1961006c8', '70a6fe79-8783-47a0-9025-d0f2dfc849f9', 'uptime', false, 'uptime ใช้ดูเวลาที่เปิดเครื่องและค่า Load Average', 4);
INSERT INTO public.choices VALUES ('489b5d5f-750d-41a4-9f8c-98e292f31026', 'b1082aee-a82d-4fac-8295-780e7b4bc4c0', 'ค่าเฉลี่ยย้อนหลัง 1 นาที, 5 นาที และ 15 นาที ตามลำดับ', true, 'ถูกต้อง — หากค่า 1 นาทีต่ำกว่า 15 นาที แสดงว่าโหลดกำลังลดลง', 1);
INSERT INTO public.choices VALUES ('1b23f8a1-837b-4018-abb7-cfdb22ea3fb0', 'b1082aee-a82d-4fac-8295-780e7b4bc4c0', 'ค่าเฉลี่ยย้อนหลัง 1 ชั่วโมง, 5 ชั่วโมง และ 15 ชั่วโมง ตามลำดับ', false, 'หน่วยของ Load Average เป็นนาที (1, 5, 15 นาที) ไม่ใช่ชั่วโมง', 2);
INSERT INTO public.choices VALUES ('dd943a21-4d7d-4046-a6d0-5f8627f18905', 'b1082aee-a82d-4fac-8295-780e7b4bc4c0', 'เปอร์เซ็นต์การใช้ CPU, RAM และ Disk ตามลำดับ', false, 'ทั้ง 3 ตัวเลขคือค่า Load Average ในแต่ละช่วงเวลา ไม่ใช่ CPU/RAM/Disk', 3);
INSERT INTO public.choices VALUES ('70fe8e21-f1e6-4482-bb3a-cf03aaf347a8', 'b1082aee-a82d-4fac-8295-780e7b4bc4c0', 'ค่าต่ำสุด, ค่าเฉลี่ย และค่าสูงสุดของวันนี้', false, 'ไม่ใช่ค่า Min/Avg/Max ของวัน แต่เป็นค่าเฉลี่ย 1, 5 และ 15 นาทีล่าสุด', 4);
INSERT INTO public.choices VALUES ('bbdddab5-2a93-4207-aaef-f3b85d8988b9', '34c5edbf-6823-4260-850d-6273902007aa', 'nproc', true, 'ถูกต้อง — แสดงจำนวนหน่วยประมวลผล (processing units/cores) ของเครื่องทันที', 1);
INSERT INTO public.choices VALUES ('8491e2a9-8798-4562-9d71-b952c97f41b2', '34c5edbf-6823-4260-850d-6273902007aa', 'du -sh', false, 'du -sh ใช้ดูขนาดไฟล์และโฟลเดอร์บนดิสก์', 2);
INSERT INTO public.choices VALUES ('cbeab7cf-baea-42e5-af7d-2b8183ca8832', '34c5edbf-6823-4260-850d-6273902007aa', 'df -h', false, 'df -h ใช้ดูพื้นที่พาร์ทิชันบนดิสก์', 3);
INSERT INTO public.choices VALUES ('e7d1476d-ffe1-400f-97e0-a5221d6b4fbc', '34c5edbf-6823-4260-850d-6273902007aa', 'pwd', false, 'pwd ใช้ดูโฟลเดอร์ที่ยืนอยู่ปัจจุบัน', 4);
INSERT INTO public.choices VALUES ('7a7b3f75-cbde-4e90-aaad-c05f934a4073', '7bb99738-0e7d-4e64-af8c-c6c23eb55759', 'เกิดคอขวดที่การอ่านเขียนดิสก์หรือสตอเรจ (High Disk I/O Wait) ทำให้โปรเซสรอคิว I/O ค้างอยู่', true, 'ถูกต้อง — ค่า wa สูงและโปรเซสสถานะ D เป็นสัญญาณชัดเจนของปัญหา Disk/Storage I/O', 1);
INSERT INTO public.choices VALUES ('056127ce-f6d0-4165-8128-2431f033e966', '7bb99738-0e7d-4e64-af8c-c6c23eb55759', 'พัดลมระบายความร้อนของ CPU หยุดหมุน', false, 'ค่า wa ย่อมาจาก I/O Wait ไม่เกี่ยวกับพัดลม CPU', 2);
INSERT INTO public.choices VALUES ('cec6aab6-37aa-4b25-a3c8-6f6fd3fda2af', '7bb99738-0e7d-4e64-af8c-c6c23eb55759', 'ไฟล์ `/etc/hosts` ถูกลบ', false, 'ไม่เกี่ยวกับค่า I/O Wait ใน vmstat', 3);
INSERT INTO public.choices VALUES ('996eb1c6-fb1b-4196-a818-7c8f60041747', '7bb99738-0e7d-4e64-af8c-c6c23eb55759', 'มีผู้ใช้เปิดหน้าต่าง Terminal ทิ้งไว้เฉยๆ หลายคน', false, 'หน้าต่าง Terminal ที่ไม่ได้รันงานจะอยู่ในสถานะ S (Sleeping) ซึ่งไม่เพิ่มค่า Load Average และไม่เพิ่ม wa', 4);
INSERT INTO public.choices VALUES ('a7651a9e-66dc-42e4-ba6b-66a6191e46a0', '26fe4415-b506-49a7-90b7-1aff3eeabb25', 'du -sh * | sort -h', true, 'ถูกต้อง — sort -h สามารถเปรียบเทียบหน่วย K, M, G จากผลลัพธ์ของ du -sh ได้อย่างแม่นยำ', 1);
INSERT INTO public.choices VALUES ('874ef423-648c-4bcf-80fa-cc429f006360', '26fe4415-b506-49a7-90b7-1aff3eeabb25', 'df -h * | uniq -c', false, 'df ใช้ดูระดับพาร์ทิชัน และ uniq -c ไม่ใช่การเรียงขนาด', 2);
INSERT INTO public.choices VALUES ('d801c315-a7a4-4721-b386-0fa7feece909', '26fe4415-b506-49a7-90b7-1aff3eeabb25', 'free -h | sort -n', false, 'free -h ใช้ดูหน่วยความจำ RAM ไม่ใช่ขนาดโฟลเดอร์บนดิสก์', 3);
INSERT INTO public.choices VALUES ('3a48a0fa-cc51-43f7-a333-27f2dbabd29d', 'f986cb3a-3b71-4610-889e-2cc401e88854', 'curl -v https://api.example.com/health > /dev/null', false, 'ไม่ได้จำกัดเวลาและพิมพ์ข้อความ Verbose จำนวนมาก', 2);
INSERT INTO public.choices VALUES ('a65d6e6c-4ba8-40b9-857a-0f8a8b79ade4', '26fe4415-b506-49a7-90b7-1aff3eeabb25', 'lsof +L1 | wc -l', false, 'lsof +L1 ใช้ดูไฟล์ที่ถูกลบแต่ยังเปิดค้าง ไม่ใช่การเรียงขนาดโฟลเดอร์', 4);
INSERT INTO public.choices VALUES ('d9906b17-02e4-4de1-a244-4949764981aa', 'a2110b46-0e41-4ae6-898e-582052248f0b', '`~/.ssh` เป็น 700 และ `~/.ssh/authorized_keys` เป็น 600', true, 'ถูกต้อง — เป็นสิทธิ์มาตรฐานที่ปลอดภัยและผ่านการตรวจสอบของ sshd', 1);
INSERT INTO public.choices VALUES ('38fa1195-3413-4139-97e6-75b79e186003', 'a2110b46-0e41-4ae6-898e-582052248f0b', '`~/.ssh` เป็น 777 และ `~/.ssh/authorized_keys` เป็น 666', false, 'สิทธิ์ 777 และ 666 เปิดให้ผู้อื่นเขียนทับกุญแจได้ จึงถูก sshd บล็อกการล็อกอินทันที', 2);
INSERT INTO public.choices VALUES ('fb1d0fb6-14e1-4c3e-a30c-7d3974d0686d', 'a2110b46-0e41-4ae6-898e-582052248f0b', '`~/.ssh` เป็น 644 และ `~/.ssh/authorized_keys` เป็น 755', false, 'โฟลเดอร์ต้องมีสิทธิ์ x (700) จึงจะเข้าถึงไฟล์ข้างในได้ ส่วนไฟล์กุญแจไม่ควรมีสิทธิ์ x', 3);
INSERT INTO public.choices VALUES ('7c325010-7631-4263-9a84-1448adedb7b5', 'a2110b46-0e41-4ae6-898e-582052248f0b', '`~/.ssh` เป็น 400 และ `~/.ssh/authorized_keys` เป็น 000', false, 'โฟลเดอร์ที่ไม่มีสิทธิ์ x (400) จะไม่สามารถเปิดอ่านไฟล์ข้างในได้ และสิทธิ์ 000 อ่านไม่ได้เลย', 4);
INSERT INTO public.choices VALUES ('f0d078f3-8004-4645-97e0-c83816ccca18', 'c50abf18-1605-4875-adee-013bf4c85344', 'ไฟล์ Private Key มีสิทธิ์เปิดกว้างเกินไป (0644) ให้แก้ไขด้วยคำสั่ง `chmod 600 ~/.ssh/id_ed25519`', true, 'ถูกต้อง — กุญแจส่วนตัวต้องจำกัดให้เจ้าของอ่านได้คนเดียวเท่านั้น (600 หรือ 400)', 1);
INSERT INTO public.choices VALUES ('8497de5a-eeac-4731-b471-479bd158f644', 'c50abf18-1605-4875-adee-013bf4c85344', 'ไฟล์ Private Key หมดอายุ ต้องสร้างใหม่ด้วย `ssh-keygen` ทุก 30 วัน', false, 'กุญแจ SSH มาตรฐานไม่ได้หมดอายุตามข้อความนี้ แต่ติดเรื่อง Permission 0644', 2);
INSERT INTO public.choices VALUES ('dae8f144-6e17-4272-b23b-4335f7dcad67', 'c50abf18-1605-4875-adee-013bf4c85344', 'ต้องเปลี่ยนสิทธิ์เป็น `chmod 777 ~/.ssh/id_ed25519` เพื่อให้โปรแกรม ssh อ่านไฟล์ได้', false, 'ยิ่งเปลี่ยนเป็น 777 จะยิ่งเปิดกว้างและยังติดข้อผิดพลาดเดิม', 3);
INSERT INTO public.choices VALUES ('35263f2e-b119-4d5f-a82a-dde920eb3cfe', 'c50abf18-1605-4875-adee-013bf4c85344', 'เซิร์ฟเวอร์ปลายทาง `10.20.1.50` ปิดพอร์ต 22 อยู่', false, 'ปัญหานี้เกิดที่การตรวจสิทธิ์ไฟล์ Private Key บนเครื่องต้นทางของเราเอง', 4);
INSERT INTO public.choices VALUES ('65779a5b-e0f2-429c-9244-9ac386bb9731', '4ea1f21a-007e-415a-91bd-4faa49b43e2f', 'Connection refused คือไปถึงเครื่องแล้วแต่พอร์ตไม่มีบริการ sshd เปิดรับ ส่วน Connection timed out คือแพ็กเก็ตไปไม่ถึงหรือถูก Firewall ดรอปเงียบๆ', true, 'ถูกต้อง — ช่วยแยกแยะได้ทันทีว่าปัญหาอยู่ที่ตัวบริการ sshd หรืออยู่ที่ระดับเครือข่าย/Firewall', 1);
INSERT INTO public.choices VALUES ('43d0efb1-bba7-406d-9484-e286f09706a9', '4ea1f21a-007e-415a-91bd-4faa49b43e2f', 'Connection refused คือใส่รหัสผ่านผิด ส่วน Connection timed out คือใส่ชื่อผู้ใช้ผิด', false, 'หากใส่รหัสผ่านหรือกุญแจผิดจะขึ้นว่า Permission denied ไม่ใช่ Connection refused', 2);
INSERT INTO public.choices VALUES ('e9273d7e-935e-4aa8-aab3-2e7ed7937e2d', '4ea1f21a-007e-415a-91bd-4faa49b43e2f', 'ทั้งสองข้อความมีความหมายเหมือนกัน ขึ้นอยู่กับเวอร์ชันของ Ubuntu หรือ RHEL', false, 'เป็นรหัสข้อผิดพลาดระดับ TCP ที่ต่างกันอย่างชัดเจนในทุกระบบปฏิบัติการ', 3);
INSERT INTO public.choices VALUES ('382fac67-fc28-4976-bf3d-979eace398a6', '4ea1f21a-007e-415a-91bd-4faa49b43e2f', 'Connection refused เกิดจากสายแลนหลุด ส่วน Connection timed out เกิดจากฮาร์ดดิสก์เต็ม', false, 'สายแลนหลุดจะไม่สามารถส่งแพ็กเก็ตไปรับคำตอบ RST (Refused) จากปลายทางได้', 4);
INSERT INTO public.choices VALUES ('daeedc72-2e29-4b4f-8195-f2e891a0ec7c', '05515d73-1a5e-475d-b40b-94ce12001fab', 'rm -rf ~/.ssh', false, 'การลบทั้งโฟลเดอร์ ~/.ssh จะทำให้ Private Key และคอนฟิกทั้งหมดของเราหายไปด้วย!', 3);
INSERT INTO public.choices VALUES ('b495a9e8-a7bb-43ab-b5e9-0f3bf0238b58', '05515d73-1a5e-475d-b40b-94ce12001fab', 'chmod 777 ~/.ssh/known_hosts', false, 'การเปลี่ยนสิทธิ์ไฟล์ไม่ได้ลบค่า Host key เก่าที่ขัดแย้งกันออก', 4);
INSERT INTO public.choices VALUES ('1a85a0ca-4263-4d84-a910-81adf1195a5d', '61f3e206-c48a-46a6-bfd0-f3c8b21d81ad', 'scp -P 2222 support@10.20.1.50:/tmp/report.txt ./', true, 'ถูกต้อง — คำสั่ง scp ต้องใช้ -P (ตัวพิมพ์ใหญ่) ในการระบุหมายเลขพอร์ต', 1);
INSERT INTO public.choices VALUES ('0c411917-840e-4e28-8795-f9a85d396d5c', '61f3e206-c48a-46a6-bfd0-f3c8b21d81ad', 'scp -p 2222 support@10.20.1.50:/tmp/report.txt ./', false, '-p (ตัวพิมพ์เล็ก) ใน scp หมายถึงการคงค่าเวลาและสิทธิ์ของไฟล์ ไม่ใช่การระบุพอร์ต', 2);
INSERT INTO public.choices VALUES ('df6ad7e5-e35d-4870-af94-21807bddf9be', '61f3e206-c48a-46a6-bfd0-f3c8b21d81ad', 'scp --port=2222 support@10.20.1.50:/tmp/report.txt ./', false, 'scp มาตรฐานไม่รองรับตัวเลือก --port=', 3);
INSERT INTO public.choices VALUES ('9af2c325-14e9-4887-a8ed-bf7320b941ec', '61f3e206-c48a-46a6-bfd0-f3c8b21d81ad', 'scp -i 2222 support@10.20.1.50:/tmp/report.txt ./', false, '-i ใช้สำหรับระบุไฟล์ Private Key (identity file) ไม่ใช่หมายเลขพอร์ต', 4);
INSERT INTO public.choices VALUES ('1055ca3d-b3b5-4d9d-9d85-54b04fbe41f1', 'cae06534-8367-4658-867b-09de72d34502', 'ช่วยให้โปรเซสและหน้าจอทำงานต่อไปบนเซิร์ฟเวอร์แม้การเชื่อมต่อ SSH จะหลุด และสามารถกลับเข้าเซสชันเดิมได้ด้วย `tmux attach`', true, 'ถูกต้อง — ป้องกันงานค้างหรือตัดจบกลางคันเมื่อเน็ตหลุด', 1);
INSERT INTO public.choices VALUES ('5edeb6b8-d801-4b20-b764-09d9923c6eb8', 'cae06534-8367-4658-867b-09de72d34502', 'ช่วยเร่งความเร็วของ CPU บนเซิร์ฟเวอร์ให้ทำงานเร็วขึ้น 2 เท่า', false, 'tmux เป็น Terminal Multiplexer ไม่ได้เร่งความเร็วฮาร์ดแวร์ CPU', 2);
INSERT INTO public.choices VALUES ('9b58c411-6ccd-4c28-b185-7320372dea9d', 'f986cb3a-3b71-4610-889e-2cc401e88854', 'curl -k https://api.example.com/health', false, '-k ข้ามการตรวจใบรับรอง ไม่ได้ช่วยให้ได้ Status Code ตามต้องการ', 3);
INSERT INTO public.choices VALUES ('8077d8db-574d-4521-b9f2-15202a77c1e4', 'cae06534-8367-4658-867b-09de72d34502', 'ช่วยข้ามการตรวจสอบรหัสผ่านและ SSH Key ทั้งหมด', false, 'ต้องล็อกอินผ่าน SSH ตามปกติก่อนจึงจะรัน tmux บนเซิร์ฟเวอร์ได้', 3);
INSERT INTO public.choices VALUES ('5e68c66d-bd74-4762-9216-e71906bbee3a', 'cae06534-8367-4658-867b-09de72d34502', 'ช่วยบีบอัดไฟล์ Log ทั้งหมดใน `/var/log` เป็น `.gz` อัตโนมัติ', false, 'หน้าที่บีบอัดไฟล์ Log ตามรอบคือ logrotate ไม่ใช่ tmux', 4);
INSERT INTO public.choices VALUES ('4740ad45-7db3-435b-97d2-4ed8dfd2a419', 'df8cecab-518d-43d8-926c-ffcd0f2e042e', 'rsync -avz support@10.20.1.50:/var/log/app/ ./app-logs/', true, 'ถูกต้อง — ประหยัดแบนด์วิดท์ด้วย -z และส่งเฉพาะส่วนที่ต่างกัน', 1);
INSERT INTO public.choices VALUES ('fdd85206-8637-4555-aefd-c73eddd9d379', 'df8cecab-518d-43d8-926c-ffcd0f2e042e', 'ssh -v support@10.20.1.50 /var/log/app/', false, 'เป็นการสั่งรันพาธโฟลเดอร์ผ่าน ssh ซึ่งจะฟ้องว่าเป็นไดเรกทอรี ไม่ใช่การโอนไฟล์', 2);
INSERT INTO public.choices VALUES ('0db60506-e216-4214-8d73-6b2ccc2fb10e', 'df8cecab-518d-43d8-926c-ffcd0f2e042e', 'tmux -avz support@10.20.1.50:/var/log/app/', false, 'tmux ใช้จัดการเซสชันหน้าจอ ไม่ใช่คำสั่งโอนถ่ายไฟล์', 3);
INSERT INTO public.choices VALUES ('2c2a452d-5a11-4386-b96f-3cb42be5fdeb', 'df8cecab-518d-43d8-926c-ffcd0f2e042e', 'cp -p support@10.20.1.50:/var/log/app/ ./', false, 'คำสั่ง cp มาตรฐานใช้คัดลอกไฟล์ภายในเครื่องเดียวกัน ไม่รองรับการส่งข้ามเครื่องผ่าน SSH', 4);
INSERT INTO public.choices VALUES ('e374b91a-e13b-407e-8d0e-6c9a3aabe702', 'bb4bdd67-7b76-4f2a-bf49-f0e2b0c9c1f8', 'เวลา 03:30 น. ของทุกวันจันทร์ถึงวันศุกร์', true, 'ถูกต้อง — 30 = นาทีที่ 30, 3 = ชั่วโมงที่ 3, 1-5 = จันทร์ถึงศุกร์', 1);
INSERT INTO public.choices VALUES ('41f9e998-8db2-4ad3-bebc-74627d208a98', 'bb4bdd67-7b76-4f2a-bf49-f0e2b0c9c1f8', 'ทุกๆ 30 นาที ในช่วงเวลา 01:00 น. ถึง 05:00 น.', false, 'ทุกๆ 30 นาทีต้องเขียนเป็น */30 ไม่ใช่ 30 เฉยๆ', 2);
INSERT INTO public.choices VALUES ('c7713614-b710-41bb-b9f1-5d44f12fb091', 'bb4bdd67-7b76-4f2a-bf49-f0e2b0c9c1f8', 'เวลา 15:03 น. ของวันที่ 1 ถึงวันที่ 5 ของทุกเดือน', false, 'ฟิลด์แรกคือนาทีไม่ใช่ชั่วโมง และ 1-5 อยู่ในฟิลด์ที่ 5 (วันในสัปดาห์) ไม่ใช่ฟิลด์ที่ 3 (วันที่)', 3);
INSERT INTO public.choices VALUES ('bf8e43a0-1121-4a00-b483-5e3d0c0f54c2', 'bb4bdd67-7b76-4f2a-bf49-f0e2b0c9c1f8', 'รันเพียง 3 ครั้งต่อเดือน ในเดือนมกราคมถึงพฤษภาคม', false, 'ฟิลด์เดือนคือฟิลด์ที่ 4 ซึ่งในที่นี้เป็น *', 4);
INSERT INTO public.choices VALUES ('f281a0bf-634d-4544-9e00-ebbbb0091745', 'd18c78fa-edc9-4d07-bcee-55e19d3afd37', 'ใช้ `crontab -l` เพื่อดูรายการ และห้ามพิมพ์ `crontab -r` เพราะจะลบตาราง Crontab ทั้งหมดทันที', true, 'ถูกต้อง — -l คือ list ส่วน -r คือ remove', 1);
INSERT INTO public.choices VALUES ('16ff1d65-2cfc-4429-b0c1-93422589ba76', 'd18c78fa-edc9-4d07-bcee-55e19d3afd37', 'ใช้ `crontab -r` เพื่ออ่านรายการ และห้ามพิมพ์ `crontab -l` เพราะจะล็อกตารางงาน', false, 'สลับกัน! การรัน crontab -r จะลบ Crontab หายทั้งหมดทันที', 2);
INSERT INTO public.choices VALUES ('d36a5efb-e962-44e3-bb37-7abd0ce44968', 'd18c78fa-edc9-4d07-bcee-55e19d3afd37', 'ใช้ `crontab -e` เพื่อดูอย่างเดียว และห้ามพิมพ์ `crontab -u`', false, '-e คือเปิดแก้ไข (edit) ส่วน -u คือระบุชื่อผู้ใช้', 3);
INSERT INTO public.choices VALUES ('5b4721a9-6bba-4cc7-aee6-632c0f5fd395', 'd18c78fa-edc9-4d07-bcee-55e19d3afd37', 'ใช้ `cron --show` เพื่อดูรายการ', false, 'คำสั่งมาตรฐานในการจัดการตารางของผู้ใช้คือ crontab -l', 4);
INSERT INTO public.choices VALUES ('781f42c2-7eb0-4663-86f2-e96f6c93f5ac', 'cbd582ae-b4a6-412f-852d-649e880f77b2', 'สภาพแวดล้อมของ Cron มีค่า PATH จำกัดกว่า Shell ปกติ ทำให้หาคำสั่ง `node` ไม่เจอ ต้องระบุพาธเต็มเช่น `/usr/local/bin/node`', true, 'ถูกต้อง — เป็นสาเหตุอันดับ 1 ที่สคริปต์รันมือผ่านแต่รันใน Cron แล้วขึ้น command not found', 1);
INSERT INTO public.choices VALUES ('40622e25-3911-4428-8fe0-962678a9412d', 'cbd582ae-b4a6-412f-852d-649e880f77b2', 'โปรแกรม Node.js ไม่สามารถทำงานในช่วงเวลาเที่ยงคืน (00:00) ได้', false, 'Node.js ทำงานได้ทุกเวลา แต่ติดที่หาไฟล์คำสั่ง node ไม่เจอจากตัวแปร PATH', 2);
INSERT INTO public.choices VALUES ('a61a5ec5-1b40-420a-bd26-be7e9175bc4f', 'cbd582ae-b4a6-412f-852d-649e880f77b2', 'บริการ Cron อนุญาตให้รันเฉพาะคำสั่งภาษา Python เท่านั้น', false, 'Cron สามารถรันโปรแกรมและสคริปต์ได้ทุกภาษาหากระบุพาธถูกต้อง', 3);
INSERT INTO public.choices VALUES ('2099cbe0-bdd0-4107-9221-f5901109edfb', 'cbd582ae-b4a6-412f-852d-649e880f77b2', 'ไฟล์ `/var/log/report.log` ถูกล็อกทำให้คำสั่ง node ถูกลบออกจากเครื่อง', false, 'ไฟล์ Log บันทึกข้อความได้ตามปกติ แต่ฟ้องว่าหาคำสั่ง node ไม่พบในบรรทัดที่ 14', 4);
INSERT INTO public.choices VALUES ('bf1e2873-a1a1-4c6b-8d06-dc93d1d9b0d9', 'aea9e7b1-71c1-4b19-9424-3f9410a25f28', 'ใน Crontab เครื่องหมาย `%` จะถูกตีความเป็นการตัดขึ้นบรรทัดใหม่ ต้องใส่ Backslash นำหน้าเป็น `\%` หรือย้ายคำสั่งเข้าไฟล์สคริปต์', true, 'ถูกต้อง — สังเกตจาก Log ของ CRON ที่คำสั่งถูกตัดจบตรงเครื่องหมาย % ตัวแรกพอดี', 1);
INSERT INTO public.choices VALUES ('1c275aec-1214-44a9-b31a-02c5167098ea', 'aea9e7b1-71c1-4b19-9424-3f9410a25f28', 'คำสั่ง `cp` ไม่สามารถทำงานร่วมกับคำสั่ง `date` บน Linux ได้', false, 'บน Shell ปกติรันได้ แต่ในไฟล์ Crontab ติดกฎพิเศษของเครื่องหมาย %', 2);
INSERT INTO public.choices VALUES ('39869c70-2919-4a83-9315-9d3aa7779fca', 'aea9e7b1-71c1-4b19-9424-3f9410a25f28', 'บริการ Cron ห้ามตั้งเวลาทำงานตอนตี 1 (01:00 น.)', false, 'Cron สั่งรันงานตอน 01:00:01 แล้วตามที่ปรากฏใน syslog', 3);
INSERT INTO public.choices VALUES ('abb4bddd-88b3-4f41-a8a4-fc9a72a5023d', 'aea9e7b1-71c1-4b19-9424-3f9410a25f28', 'ชื่อไฟล์ใน Linux ห้ามมีตัวเลขปี ค.ศ. อยู่ในชื่อไฟล์', false, 'ชื่อไฟล์ใส่ตัวเลขวันที่ได้ตามปกติ', 4);
INSERT INTO public.choices VALUES ('40b04dc3-3660-4494-b659-b7e5db18be56', 'f986cb3a-3b71-4610-889e-2cc401e88854', 'ping https://api.example.com/health', false, 'ping ใช้ไม่ได้กับ URL และไม่ตรวจ HTTP', 4);
INSERT INTO public.choices VALUES ('f40e4cb6-c263-4b8b-af4c-380e54f58a25', '8c5078fb-64e4-4e84-bbbb-ac15123d866d', '`/var/log/syslog` (Ubuntu/Debian) และ `/var/log/cron` (RHEL/Rocky)', true, 'ถูกต้อง — เป็นตำแหน่งมาตรฐานของบันทึกการทำงาน Cron ในแต่ละค่าย', 1);
INSERT INTO public.choices VALUES ('588afe6e-5694-442f-9e89-b48d51585c18', '8c5078fb-64e4-4e84-bbbb-ac15123d866d', '`/var/log/auth.log` (Ubuntu/Debian) และ `/var/log/secure` (RHEL/Rocky)', false, 'auth.log และ secure เก็บเรื่องการล็อกอินและสิทธิ์เป็นหลัก (แม้จะมี session ของ pam_unix บ้าง แต่รายการคำสั่ง CMD ของ RHEL อยู่ที่ /var/log/cron)', 2);
INSERT INTO public.choices VALUES ('5bd57a73-8240-481d-a554-b9fa5d70f74e', '8c5078fb-64e4-4e84-bbbb-ac15123d866d', '`/etc/crontab` ทั้งสองตระกูล', false, '/etc/crontab คือไฟล์ตั้งค่าตารางงาน ไม่ใช่ไฟล์บันทึกผลการทำงาน (Log)', 3);
INSERT INTO public.choices VALUES ('c24867c5-e770-4299-8aaf-3af8420fc4e8', '8c5078fb-64e4-4e84-bbbb-ac15123d866d', '`/var/log/dmesg` ทั้งสองตระกูล', false, 'dmesg เป็นบันทึกของ Kernel ไม่ได้เก็บประวัติการรัน Cron job', 4);
INSERT INTO public.choices VALUES ('d61b3ea4-73fc-40fa-a2bc-5b7db1c599f3', '8e9483d6-ae5f-40c0-b138-8ed3177059f1', 'ไฟล์ใน `/etc/cron.d/` ต้องระบุชื่อผู้ใช้ (username) แทรกเป็นคอลัมน์ที่ 6 ก่อนคำสั่ง ส่วน User Crontab ไม่ต้องระบุชื่อผู้ใช้', true, 'ถูกต้อง — หากลืมใส่ชื่อผู้ใช้ในไฟล์ภายใต้ /etc/cron.d/ งานนั้นจะรันไม่ทำงานเพราะถือว่าชื่อคำสั่งผิด', 1);
INSERT INTO public.choices VALUES ('d4e82a8f-8d39-4933-9c8e-3ad073bf72e2', '8e9483d6-ae5f-40c0-b138-8ed3177059f1', 'ไฟล์ใน `/etc/cron.d/` มีฟิลด์เวลาเพียง 3 ฟิลด์ ส่วน User Crontab มี 5 ฟิลด์', false, 'ทั้งสองแบบใช้ฟิลด์เวลา 5 ฟิลด์เหมือนกัน', 2);
INSERT INTO public.choices VALUES ('49127d15-8fe0-4a46-a76d-5e811f827431', '8e9483d6-ae5f-40c0-b138-8ed3177059f1', 'User Crontab รันได้เฉพาะวันจันทร์ถึงศุกร์ ส่วน `/etc/cron.d/` รันได้ทุกวัน', false, 'ทั้งสองแบบตั้งเวลารันได้ทุกวันเหมือนกัน', 3);
INSERT INTO public.choices VALUES ('4cc68483-e564-4c56-8840-8f663151fd80', '8e9483d6-ae5f-40c0-b138-8ed3177059f1', 'ไม่มีความแตกต่างกัน สามารถคัดลอกบรรทัดวางสลับกันได้ทันที', false, 'วางสลับกันตรงๆ ไม่ได้ เพราะต่างกันที่คอลัมน์ระบุชื่อผู้ใช้ (User field)', 4);
INSERT INTO public.choices VALUES ('795ccc37-fde6-4fd4-b188-f38df3fd5620', '2a3504c4-29e5-46af-b2fb-9ebf81c95947', 'systemctl list-timers', true, 'ถูกต้อง — แสดงรายการ systemd timers ทั้งหมดพร้อมเวลารันครั้งล่าสุดและครั้งถัดไป', 1);
INSERT INTO public.choices VALUES ('5840b3a2-60fa-4901-9d58-e754eea22a74', '2a3504c4-29e5-46af-b2fb-9ebf81c95947', 'systemctl list-sockets', false, 'list-sockets ใช้ดูรายการ Socket units ไม่ใช่การตั้งเวลา', 2);
INSERT INTO public.choices VALUES ('9583e1c1-ffa4-4919-9b78-f25056964409', '2a3504c4-29e5-46af-b2fb-9ebf81c95947', 'ps aux --timers', false, 'คำสั่ง ps aux ไม่มีตัวเลือก --timers', 3);
INSERT INTO public.choices VALUES ('480af81e-0990-4fdc-95ef-c91c114199fc', '2a3504c4-29e5-46af-b2fb-9ebf81c95947', 'dmesg --cron', false, 'dmesg ไม่มีตัวเลือก --cron', 4);
INSERT INTO public.choices VALUES ('f3ae3f5f-bcc2-4dfa-a5f5-ede8e4678376', '4e95dfd0-892c-4c0c-b51f-9f1b56c0ad9f', 'systemctl → ss → nc → curl', true, 'ถูกต้อง — ไล่จาก Service, Port ในเครื่อง, การต่อจากภายนอก ไปจนถึง HTTP', 1);
INSERT INTO public.choices VALUES ('5209e17b-b8c0-4ba9-813b-63c0c3f1f451', '4e95dfd0-892c-4c0c-b51f-9f1b56c0ad9f', 'curl → ss → systemctl → nc', false, 'เริ่มที่ชั้นบนสุดทำให้ไม่รู้ว่าปัญหาอยู่ชั้นไหนจริงๆ', 2);
INSERT INTO public.choices VALUES ('add6bb49-4b1f-492c-89a4-45af48c078ac', '4e95dfd0-892c-4c0c-b51f-9f1b56c0ad9f', 'reboot เครื่องก่อน แล้วค่อยตรวจตามลำดับ', false, 'การรีบูตทำให้หลักฐานหาย และอาจกระทบผู้ใช้อื่น', 3);
INSERT INTO public.choices VALUES ('89e446b9-f48e-42db-8c52-21f01b9a27ef', '4e95dfd0-892c-4c0c-b51f-9f1b56c0ad9f', 'nc → reboot → ss → systemctl', false, 'ไม่มีเหตุผลที่จะข้ามการตรวจ Service และมีการรีบูตโดยไม่จำเป็น', 4);
INSERT INTO public.choices VALUES ('04a0d79f-00e2-44bd-8ac0-61c6e02adc90', 'c75407f1-a3a5-4a5b-981b-b9e31701154f', 'sudo ss -tulpn', true, 'ถูกต้อง — จำเป็นต้องมี sudo ถึงจะเห็น Process ของผู้ใช้อื่นครบ', 1);
INSERT INTO public.choices VALUES ('576aa2f2-edbd-4b75-9806-fe3c93476888', 'c75407f1-a3a5-4a5b-981b-b9e31701154f', 'ss -s', false, 'แสดงสรุปจำนวน Socket ไม่ใช่รายการ Port ที่ฟัง', 2);
INSERT INTO public.choices VALUES ('3832c86f-799f-483a-b9bb-0b8d3d11ebc9', 'c75407f1-a3a5-4a5b-981b-b9e31701154f', 'systemctl list-sockets', false, 'แสดง systemd socket unit ไม่ใช่ทุก Port ที่ฟังอยู่ในเครื่อง', 3);
INSERT INTO public.choices VALUES ('b51d466e-44a5-4565-97e9-5a8458f17d1a', 'c75407f1-a3a5-4a5b-981b-b9e31701154f', 'curl -v localhost', false, 'ทดสอบการเรียก HTTP ไม่ได้แสดงรายการ Port', 4);
INSERT INTO public.choices VALUES ('b7b465ed-1cff-4737-90d3-f61b454c23f0', 'a5cff860-3040-413a-b67a-63944822a4ad', 'แอปฟังเฉพาะ 127.0.0.1 จึงรับเฉพาะการเชื่อมต่อจากในเครื่อง ต้องส่งต่อทีมแอปให้ตรวจ bind address', true, 'ถูกต้อง — ดู Local Address ใน ss เป็นอันดับแรก', 1);
INSERT INTO public.choices VALUES ('5578f065-9eab-454f-873d-752c9f6f709b', 'a5cff860-3040-413a-b67a-63944822a4ad', 'Firewall ของ Network ดรอปแพ็กเก็ต จึงต้องส่งต่อทีม Network', false, 'ถ้าถูก Firewall ดรอปมักได้ timed out ไม่ใช่ refused', 2);
INSERT INTO public.choices VALUES ('b049a70a-c191-41d5-ad56-36e9b350a611', 'a5cff860-3040-413a-b67a-63944822a4ad', 'Service order-api ล่ม ต้องรีสตาร์ททันที', false, 'systemctl แสดงว่า active และ ss เห็น Process ฟังอยู่', 3);
INSERT INTO public.choices VALUES ('098990d9-6b4c-4ebb-8882-9c1278bc7881', 'a5cff860-3040-413a-b67a-63944822a4ad', 'Port 8080 ถูกโปรเซสอื่นใช้อยู่แล้ว', false, 'Process ที่ฟังคือ node PID 18420 ซึ่งเป็นตัวแอปเอง', 4);
INSERT INTO public.choices VALUES ('338ce2ee-4345-492b-9da8-7f97837198d3', 'af321481-4010-42cc-a917-de4dc61cda20', 'refused = ไม่มีโปรแกรมฟัง Port, timed out = ไม่มีคำตอบกลับ มักถูกบล็อกหรือไม่มีเส้นทาง', true, 'ถูกต้อง', 1);
INSERT INTO public.choices VALUES ('68f591bf-8296-44e4-82c0-d761d7b20c5f', 'af321481-4010-42cc-a917-de4dc61cda20', 'refused = DNS ผิด, timed out = รหัสผ่านผิด', false, 'DNS ผิดจะขึ้น Could not resolve host และรหัสผ่านผิดไม่เกี่ยวกับ TCP', 2);
INSERT INTO public.choices VALUES ('96119a99-cc11-4554-bdab-42505f1798db', 'af321481-4010-42cc-a917-de4dc61cda20', 'ทั้งสองคำเหมือนกัน', false, 'บ่งชี้ปัญหาคนละชั้น', 3);
INSERT INTO public.choices VALUES ('f6400730-c830-4ab4-8446-5bf7e5b96c31', 'af321481-4010-42cc-a917-de4dc61cda20', 'refused = ดิสก์เต็ม, timed out = RAM เต็ม', false, 'ไม่เกี่ยวกับทรัพยากรเครื่อง', 4);
INSERT INTO public.choices VALUES ('ee5f1037-6e5b-4fbd-9d60-debbfc548c1c', 'f986cb3a-3b71-4610-889e-2cc401e88854', 'curl -sS -o /dev/null -w "%{http_code} %{time_total}s\n" --max-time 10 https://api.example.com/health', true, 'ถูกต้อง', 1);
INSERT INTO public.choices VALUES ('5f18e908-56c5-4dda-b954-f2e8e05f0fcb', '7973243b-4e81-479c-9ae6-9ec56f46a8b5', 'Port 9000 ถูก Process java (PID 1544) ใช้อยู่ ให้เก็บข้อมูลแล้วส่งต่อตาม Runbook ก่อนตัดสินใจจัดการ', true, 'ถูกต้อง — รู้ตัวผู้ถือ Port แล้ว แต่ต้องยืนยันก่อนว่าเป็น Process ที่ควรอยู่หรือไม่', 1);
INSERT INTO public.choices VALUES ('f1146496-dd38-4736-bb9b-9fd06733c5a6', '7973243b-4e81-479c-9ae6-9ec56f46a8b5', 'ไฟล์ Config สะกดผิด ให้แก้ไฟล์ทันที', false, 'Log ชี้ที่ Port ถูกใช้ ไม่ใช่ Config ผิดรูปแบบ', 2);
INSERT INTO public.choices VALUES ('273f3782-2135-4f94-8bf1-cb764213bd97', '7973243b-4e81-479c-9ae6-9ec56f46a8b5', 'ดิสก์เต็ม ให้ลบ Log', false, 'ไม่มีหลักฐานเรื่องดิสก์ใน Log', 3);
INSERT INTO public.choices VALUES ('c939ed84-2a14-4ed1-b8df-45974637ed05', '7973243b-4e81-479c-9ae6-9ec56f46a8b5', 'ใช้ kill -9 1544 ทันทีเพื่อให้ Service สตาร์ทได้', false, 'อาจฆ่าบริการสำคัญอื่น ต้องทำตาม Runbook', 4);
INSERT INTO public.choices VALUES ('7a197055-b098-46ff-83b9-9b13e1cff350', 'd63a08cb-8a15-4783-8eba-9dec781d11b9', 'ตรวจสถานะและ Port ของ Backend (systemctl, ss) และอ่าน error.log ของ Nginx หาบรรทัด upstream', true, 'ถูกต้อง — 502 มักมาจาก Backend ล่มหรือต่อไม่ได้', 1);
INSERT INTO public.choices VALUES ('df7bb28d-680c-46ce-a157-e05968790d38', 'd63a08cb-8a15-4783-8eba-9dec781d11b9', 'รีสตาร์ท Nginx ทันที', false, 'Nginx ตอบอยู่แล้ว การรีสตาร์ทยังไม่แก้สาเหตุ', 2);
INSERT INTO public.choices VALUES ('c48221fb-ea4e-46e2-b498-39c377e75675', 'd63a08cb-8a15-4783-8eba-9dec781d11b9', 'ตรวจ DNS ของผู้ใช้', false, 'curl ได้ Response จาก Nginx แล้ว แปลว่า DNS ใช้ได้', 3);
INSERT INTO public.choices VALUES ('907071c6-8d88-41b7-a75a-225c84e35119', 'd63a08cb-8a15-4783-8eba-9dec781d11b9', 'ลบแคชเบราว์เซอร์ของผู้ใช้', false, 'curl ไม่ผ่านแคชเบราว์เซอร์และเจอ 502 เหมือนกัน', 4);
INSERT INTO public.choices VALUES ('ecaaa173-4205-4679-8cf8-97372ebdb7eb', '6164b7cc-ad3b-4035-8811-281134f2b57d', '14 IP', true, 'ถูกต้อง /28 มี 16 IP ลบ 2 (Network + Broadcast) = 14 IP', 1);
INSERT INTO public.choices VALUES ('149cfce2-b6dc-4492-92d7-27f239d3f36e', '6164b7cc-ad3b-4035-8811-281134f2b57d', '16 IP', false, '16 คือจำนวน IP ทั้งหมด แต่ยังไม่ได้หัก Network และ Broadcast IP', 2);
INSERT INTO public.choices VALUES ('9c193bd6-e552-41f6-9d9a-abf8a7533afc', '6164b7cc-ad3b-4035-8811-281134f2b57d', '30 IP', false, '30 IP คือจำนวนของ /27', 3);
INSERT INTO public.choices VALUES ('2ee11eb8-bd5d-4ec4-a83d-bb8b74179c2d', '6164b7cc-ad3b-4035-8811-281134f2b57d', '6 IP', false, '6 IP คือจำนวนของ /29', 4);
INSERT INTO public.choices VALUES ('ff86e962-92a7-427f-9fb5-557deae19f41', '98df92a1-ad7f-46d6-9529-d780a7dad658', 'เครื่องไม่ได้รับ IP จาก DHCP Server หรือการเชื่อมต่อระดับสาย LAN มีปัญหา', true, 'ถูกต้อง ช่วง 169.254.x.x บ่งชี้ว่า DHCP Request ล้มเหลว', 1);
INSERT INTO public.choices VALUES ('7c9637d6-208b-4f40-b94e-769055d2df0d', '98df92a1-ad7f-46d6-9529-d780a7dad658', 'DNS Server ตอบกลับช้า ทำให้ได้ IP สำรอง', false, 'DNS มีหน้าที่แปลงชื่อโดเมน ไม่ได้จ่าย IP ให้เครื่อง', 2);
INSERT INTO public.choices VALUES ('34e857c5-587b-46c9-8cbc-5bec47e10a4c', '98df92a1-ad7f-46d6-9529-d780a7dad658', 'เป็น Public IP ปกติที่ออกเน็ตได้โดยตรง', false, '169.254.x.x เป็น Link-Local IP ไม่สามารถออกเน็ตได้', 3);
INSERT INTO public.choices VALUES ('c02a4326-967e-46d9-a6a2-6e65ddbfcae8', '98df92a1-ad7f-46d6-9529-d780a7dad658', 'เกิด IP ชนกัน (IP Conflict) บน Switch', false, 'IP ชนกันเครื่องมักจะตัดการเชื่อมต่อหรือขึ้น Warning IP conflict แต่จะไม่เปลี่ยนเป็น 169.254 โดยอัตโนมัติ', 4);
INSERT INTO public.choices VALUES ('0fb29788-e507-4bb5-bcf3-4759e9a16bb8', 'b4c8e401-d6ff-494a-84f3-715e4b84eaba', '172.32.1.1', true, 'ถูกต้อง Private Class B สิ้นสุดที่ 172.31.255.255 ดังนั้น 172.32.1.1 คือ Public IP', 1);
INSERT INTO public.choices VALUES ('f92847ee-37ca-439e-9fbb-b3663f632763', 'b4c8e401-d6ff-494a-84f3-715e4b84eaba', '10.240.1.5', false, '10.0.0.0/8 เป็น Private IP Class A', 2);
INSERT INTO public.choices VALUES ('3821f13e-cfef-44b8-a872-407e096af0b3', 'b4c8e401-d6ff-494a-84f3-715e4b84eaba', '172.20.10.5', false, '172.16.0.0 - 172.31.255.255 เป็น Private IP Class B', 3);
INSERT INTO public.choices VALUES ('ed246c97-1596-4ca4-b39f-f82bb2cd299a', 'b4c8e401-d6ff-494a-84f3-715e4b84eaba', '192.168.100.1', false, '192.168.0.0/16 เป็น Private IP Class C', 4);
INSERT INTO public.choices VALUES ('1e8e9a89-0b23-4793-850b-a54177058239', '809eec81-5754-4afb-8940-ff635ec0484c', 'DNS Server ล่มไม่สามารถแปลงชื่อ db-server ได้', false, 'ถ้า DNS ล่ม จะขึ้น Name or service not known ก่อนที่จะเริ่มส่ง TCP SYN', 4);
INSERT INTO public.choices VALUES ('4d206e3c-6b1e-42e9-b2b2-ce8ce3fe95cc', 'a6917e20-839e-4d3c-821d-4541711f8053', 'เครื่องสื่อสารได้เฉพาะภายใน Subnet เดียวกัน แต่ออกนอกวงหรือออกอินเทอร์เน็ตไม่ได้', true, 'ถูกต้อง ขาด Default Gateway ทำให้ไม่รู้จะส่ง Packet ออกนอกวงไปที่ใด', 1);
INSERT INTO public.choices VALUES ('03f2c281-1f28-4e3b-9ed2-c3a55c5f5cc2', 'a6917e20-839e-4d3c-821d-4541711f8053', 'เครื่องจะตัดการเชื่อมต่อเครือข่ายทั้งหมด แม้แต่วงเดียวกันก็คุยไม่ได้', false, 'ในวงเดียวกันคุยผ่าน ARP และ Switch Layer 2 ได้โดยตรงโดยไม่ต้องพึ่ง Gateway', 2);
INSERT INTO public.choices VALUES ('3e017dd6-03f7-4955-a0e9-e7dafbc50220', 'a6917e20-839e-4d3c-821d-4541711f8053', 'บริการ SSH จะหยุดทำงานทันที', false, 'SSH ยังเปิดรับการเชื่อมต่อจากเครื่องใน Subnet เดียวกันได้', 3);
INSERT INTO public.choices VALUES ('0d4ac371-27fc-42fb-bc5f-d001d2d93a0f', 'a6917e20-839e-4d3c-821d-4541711f8053', 'เครื่องจะสลับไปใช้ IP 127.0.0.1 อัตโนมัติ', false, 'Loopback 127.0.0.1 ทำงานแยกกัน ไม่เกี่ยวกับ Default Gateway', 4);
INSERT INTO public.choices VALUES ('f0afb309-87f6-4525-b4ca-97199287bb06', '9b606785-3b1d-4039-8aef-d077d30d52dc', 'dig @8.8.8.8 api.example.com +short', true, 'ถูกต้อง @ ระบุเซิร์ฟเวอร์ และ +short จะแสดงเฉพาะค่า IP ที่ตอบกลับ', 1);
INSERT INTO public.choices VALUES ('c9db95da-a074-4166-99ba-de3cbe57a169', '9b606785-3b1d-4039-8aef-d077d30d52dc', 'dig api.example.com --server 8.8.8.8 -q', false, 'dig ไม่ใช้ option --server หรือ -q', 2);
INSERT INTO public.choices VALUES ('672a229a-84d4-4514-a43e-f999488ec45c', '9b606785-3b1d-4039-8aef-d077d30d52dc', 'nslookup -short api.example.com @8.8.8.8', false, 'nslookup ไม่ใช้ @ หรือ -short', 3);
INSERT INTO public.choices VALUES ('e3d62eb7-75b8-49ee-9613-fd6213cd5ed3', '9b606785-3b1d-4039-8aef-d077d30d52dc', 'dig -ip 8.8.8.8 api.example.com', false, 'dig ไม่ใช้ flag -ip ในการระบุ DNS server', 4);
INSERT INTO public.choices VALUES ('bffdbf77-176c-48cf-84ef-5403369a92de', 'f3360feb-004a-49b9-9366-b7b9899c587f', 'DNS Resolver ยังคงติดแคชตามระยะเวลา TTL ของ Record เดิม', true, 'ถูกต้อง Resolver จะไม่ร้องขอ IP ใหม่จนกว่า TTL เดิมจะนับถอยหลังหมด', 1);
INSERT INTO public.choices VALUES ('be593a36-19af-489f-99cb-e8d726f42a15', 'f3360feb-004a-49b9-9366-b7b9899c587f', 'พอร์ต 53 บนเซิร์ฟเวอร์ถูกบล็อก', false, 'ถ้าพอร์ต 53 ถูกบล็อก จะเกิด Timeout ไม่ใช่ได้ IP เก่ากลับมา', 2);
INSERT INTO public.choices VALUES ('b6fb6403-793c-4f49-a645-55648df8da62', '6e981c68-db2f-4533-9f5d-8a923e156a67', 'Bits และ Frame', false, 'ผิด Bits คือ Layer 1', 3);
INSERT INTO public.choices VALUES ('594fbb8c-2e6c-442e-8184-929006f26817', 'f3360feb-004a-49b9-9366-b7b9899c587f', 'Default Gateway ของเครื่องล่ม', false, 'ถ้า Gateway ล่มจะไม่สามารถออกเน็ตหรือคุยข้ามวงได้', 3);
INSERT INTO public.choices VALUES ('01a03022-ec33-497f-9787-14307d202c5b', 'f3360feb-004a-49b9-9366-b7b9899c587f', 'A Record ไม่รองรับ IPv4', false, 'A Record คือมาตรฐานสำหรับ IPv4 โดยเฉพาะ', 4);
INSERT INTO public.choices VALUES ('0c454b0b-2edc-4b94-bc2d-ade3454a338f', '611c9533-5018-4260-93b1-75368ecf0e4b', 'dig -x 203.0.113.50', true, 'ถูกต้อง flag -x ย่อมาจาก reverse query (PTR record lookup)', 1);
INSERT INTO public.choices VALUES ('1857e5a5-ad01-46d0-bf2a-91ce31fc92c1', '611c9533-5018-4260-93b1-75368ecf0e4b', 'dig -r 203.0.113.50', false, '-r ไม่ใช่แฟล็กสำหรับ reverse dns', 2);
INSERT INTO public.choices VALUES ('677bd17d-11aa-498c-a257-25a597c6db50', '611c9533-5018-4260-93b1-75368ecf0e4b', 'nslookup -reverse 203.0.113.50', false, 'nslookup ทำ reverse lookup โดยพิมพ์ IP ตรงๆ ไม่ต้องใส่ -reverse', 3);
INSERT INTO public.choices VALUES ('6a504dbf-42a1-4ba1-b267-884a5ecdf62a', '611c9533-5018-4260-93b1-75368ecf0e4b', 'host -a 203.0.113.50', false, 'host สามารถใส่ IP ตรงๆ ได้ แต่ dig -x เป็นคำสั่งมาตรฐานที่นิยมใช้', 4);
INSERT INTO public.choices VALUES ('9d796172-ae91-4265-9ba2-08b33932d534', 'b8d26fbb-9136-4651-a96a-004a0568191c', 'Hop ที่ 4 มีการทำ ICMP Rate-limiting แต่ไม่ได้ส่งผลกระทบต่อทราฟฟิกจริงเพราะ Hop ปลายทางไม่มี Loss', true, 'ถูกต้อง ถ้าปัญหาเกิดจริง Loss จะต้องลุกลามต่อไปยังทุก Hop ข้างหลัง', 1);
INSERT INTO public.choices VALUES ('6fb7e0e2-d0fc-484e-ad2c-2a5905710f08', 'b8d26fbb-9136-4651-a96a-004a0568191c', 'เราเตอร์ตัวที่ 4 ชำรุด ต้องติดต่อให้ผู้ดูแลเปลี่ยนฮาร์ดแวร์ทันที', false, 'ถ้าฮาร์ดแวร์พัง Hop 5 และปลายทางจะไม่สามารถส่งข้อมูลผ่านได้แบบ 0% loss', 2);
INSERT INTO public.choices VALUES ('a9cb6eba-0d21-4702-a7b6-5a6ddc4410e8', 'b8d26fbb-9136-4651-a96a-004a0568191c', 'สาย LAN ของเครื่องเซิร์ฟเวอร์หลวม', false, 'ถ้าสาย LAN หลวม ปัญหาจะเริ่มแสดงที่ Hop ที่ 1 (Local Gateway) ทันที', 3);
INSERT INTO public.choices VALUES ('33f655c6-01cc-4aa4-b13b-809fef7d0b7e', 'b8d26fbb-9136-4651-a96a-004a0568191c', 'เป็นผลมาจากการทำ DNS Cache ล้มเหลว', false, 'mtr ทำงานบนระดับ IP Layer 3 ไม่เกี่ยวกับ DNS Cache', 4);
INSERT INTO public.choices VALUES ('41451867-e918-41b2-85cf-3e2f47375a8a', '15081888-fb1c-4b94-9d2a-5bab1372ddd3', 'Firewall หรือ OS ปลายทางอาจบล็อกโปรโตคอล ICMP ไว้ แต่พอร์ตของแอปพลิเคชัน (TCP 80/443) ยังเปิดให้บริการอยู่', true, 'ถูกต้อง ICMP ปิดกั้นได้ง่าย จึงต้องเช็คด้วย TCP port (เช่น curl หรือ nc) เพิ่มเติม', 1);
INSERT INTO public.choices VALUES ('bcad0c50-fcbe-43d4-bac8-099c29e453ee', '15081888-fb1c-4b94-9d2a-5bab1372ddd3', 'ping สามารถใช้ทดสอบได้เฉพาะเครื่องในวง LAN เดียวกันเท่านั้น', false, 'ping ใช้งานข้ามเครือข่ายอินเทอร์เน็ตได้ทั่วโลกหากไม่มีการบล็อก', 2);
INSERT INTO public.choices VALUES ('5ff96425-b92b-47e3-9d91-25474600c5db', '15081888-fb1c-4b94-9d2a-5bab1372ddd3', 'ping ต้องการสิทธิ์ root เสมอจึงไม่แสดงผล', false, 'คำสั่ง ping ทั่วไปผู้ใช้ธรรมดาก็รันได้', 3);
INSERT INTO public.choices VALUES ('ccf61d51-1024-4d1c-9661-04dab6fe42b4', '15081888-fb1c-4b94-9d2a-5bab1372ddd3', 'สาย Fiber Optic ไม่รองรับการส่งข้อมูลแบบ Echo Request', false, 'สายสัญญาณทุกประเภทรองรับ IP packet ทุกชนิด', 4);
INSERT INTO public.choices VALUES ('3d475c12-016b-4ce4-a6dd-6b4295df05b6', '809eec81-5754-4afb-8940-ff635ec0484c', 'Service PostgreSQL บนเครื่อง db-server หยุดทำงาน หรือไม่ได้เปิดพอร์ต LISTEN อยู่', true, 'ถูกต้อง Kernel ปลายทางจะส่ง RST ปฏิเสธทันทีเมื่อไม่มีโปรเซสรอรับที่พอร์ตนั้น', 1);
INSERT INTO public.choices VALUES ('fa1728d4-fa1f-4d57-a37c-199cc34dfd85', '809eec81-5754-4afb-8940-ff635ec0484c', 'Firewall หรือ Security Group สั่ง DROP แพ็กเก็ตทิ้ง', false, 'ถ้า Firewall สั่ง DROP จะเกิด Connection Timed Out ไม่ใช่ Connection Refused', 2);
INSERT INTO public.choices VALUES ('5de6be7d-6ea7-4e73-9f42-c3565d17a0c4', '809eec81-5754-4afb-8940-ff635ec0484c', 'สาย LAN ของเครื่อง Client ขาด', false, 'ถ้าสาย LAN ขาด จะขึ้น Network is unreachable', 3);
INSERT INTO public.choices VALUES ('182f098c-6953-4929-b880-f73969e1c7df', '9305fed3-82a6-4ca9-a25b-a0ae68b2049d', 'เครื่องภายนอกจะไม่สามารถเชื่อมต่อได้เลย จะเชื่อมต่อได้เฉพาะแอปพลิเคชันที่รันอยู่ในเครื่องตัวเองเท่านั้น', true, 'ถูกต้อง 127.0.0.1 จำกัดเฉพาะ Localhost ต้องเปลี่ยนเป็น 0.0.0.0 จึงจะรับจากภายนอกได้', 1);
INSERT INTO public.choices VALUES ('80e244da-ce1f-492d-9aff-83d28f4c4df8', '9305fed3-82a6-4ca9-a25b-a0ae68b2049d', 'เครื่องภายนอกเชื่อมต่อได้ตามปกติหากมี Firewall อนุญาต', false, 'แม้ Firewall จะเปิด แต่ OS จะไม่รับฟังทราฟฟิกภายนอกเข้ามาที่ 127.0.0.1', 2);
INSERT INTO public.choices VALUES ('0bd28997-65fa-4729-bae4-5e1479d1e6e8', '9305fed3-82a6-4ca9-a25b-a0ae68b2049d', 'Service PostgreSQL จะทำงานแบบ Read-only', false, 'ไม่เกี่ยวกับการจำกัดสิทธิ์ Read/Write', 3);
INSERT INTO public.choices VALUES ('93bfbf4b-f123-4112-af7e-30574b1cad55', '9305fed3-82a6-4ca9-a25b-a0ae68b2049d', 'พอร์ต 5432 จะสลับไปใช้ UDP อัตโนมัติ', false, 'PostgreSQL ใช้ TCP เท่านั้น', 4);
INSERT INTO public.choices VALUES ('8015805f-913c-4f89-8b0c-06d64da8db67', '5f978533-62ea-48fe-9698-8ee8b1b27294', 'Refused เกิดจากเครื่องปลายทางตอบปฏิเสธ (Service ดับ/ไม่ฟังพอร์ต), ส่วน Timed Out เกิดจากการไม่ได้รับการตอบกลับใดๆ เลย (Firewall ดรอปทิ้งหรือเครื่องดับ)', true, 'ถูกต้อง นี่คือคำตอบที่ตรงตามกลไก TCP และคำถามสัมภาษณ์งาน', 1);
INSERT INTO public.choices VALUES ('d8abc4be-4a35-41bd-a1f0-63fd0339ca32', '5f978533-62ea-48fe-9698-8ee8b1b27294', 'Refused คือรหัสผ่านผิด, ส่วน Timed Out คือชื่อผู้ใช้ผิด', false, 'Authentication เกิดขึ้นที่ Application Layer หลังจาก TCP Handshake สำเร็จแล้ว', 2);
INSERT INTO public.choices VALUES ('020c5bde-67a0-4779-a116-ca006947e6c0', '5f978533-62ea-48fe-9698-8ee8b1b27294', 'Refused เกิดขึ้นบน IPv4 เท่านั้น ส่วน Timed Out เกิดบน IPv6', false, 'ทั้งสองข้อผิดพลาดเกิดขึ้นได้ทั้งบน IPv4 และ IPv6', 3);
INSERT INTO public.choices VALUES ('23e1a3d9-9a60-4ac3-b02b-5bb99352b43a', '5f978533-62ea-48fe-9698-8ee8b1b27294', 'Refused เกิดจากฮาร์ดแวร์ เราเตอร์พัง ส่วน Timed Out เกิดจากซอฟต์แวร์', false, 'ไม่ถูกต้องตามหลักการทำงานของเครือข่าย', 4);
INSERT INTO public.choices VALUES ('e92b20be-fdb2-409c-a92c-dc0a57b5fe92', '8e98bdbc-25ff-4734-ab03-4f4cc8d75ec6', 'SELECT c.* FROM customers c LEFT JOIN orders o ON c.id = o.customer_id WHERE o.id IS NULL;', true, 'ถูกต้อง นี่คือรูปแบบ Anti-Join มาตรฐานที่ค้นหาแถวที่ไม่พบคู่ตรงกันในตารางฝั่งขวา', 1);
INSERT INTO public.choices VALUES ('c3e5f858-2e6a-468a-af41-0d8ac775ff48', '8e98bdbc-25ff-4734-ab03-4f4cc8d75ec6', 'SELECT c.* FROM customers c INNER JOIN orders o ON c.id = o.customer_id WHERE o.id IS NULL;', false, 'INNER JOIN จะดึงเฉพาะรายการที่มีคู่ตรงกันทั้งสองฝั่ง ทำให้เงื่อนไข WHERE o.id IS NULL ไม่ได้ผลลัพธ์ใดๆ เลย', 2);
INSERT INTO public.choices VALUES ('c370edf2-f2ad-4403-9151-639397bd87f9', '8e98bdbc-25ff-4734-ab03-4f4cc8d75ec6', 'SELECT c.* FROM customers c WHERE c.id = (SELECT customer_id FROM orders);', false, 'ไวยากรณ์นี้จะ Error หาก Subquery คืนค่ามากกว่า 1 แถว และเป็นเงื่อนไขที่ดึงเฉพาะคนที่มีออเดอร์', 3);
INSERT INTO public.choices VALUES ('d8538ccb-3c84-4418-b152-9abd9ed9202c', '8e98bdbc-25ff-4734-ab03-4f4cc8d75ec6', 'SELECT c.* FROM customers c RIGHT JOIN orders o ON c.id = o.customer_id;', false, 'RIGHT JOIN จะเน้นตาราง orders เป็นหลัก ซึ่งไม่ได้รายการลูกค้าที่ไม่มีออเดอร์', 4);
INSERT INTO public.choices VALUES ('7ac3e809-de40-471a-b626-e56ea4b7b302', '1965fab0-45b2-4e02-adc4-72650a0c04f0', 'เพราะ NULL คือสภาวะไม่มีค่า (Unknown) ไม่สามารถเปรียบเทียบด้วยเครื่องหมาย = ได้ ต้องใช้ไวยากรณ์ IS NULL เท่านั้น', true, 'ถูกต้อง NULL ต้องตรวจสอบด้วย IS NULL หรือ IS NOT NULL เสมอ', 1);
INSERT INTO public.choices VALUES ('33c8914a-c91e-483a-974a-a5aa47e15582', '1965fab0-45b2-4e02-adc4-72650a0c04f0', 'เพราะตารางบังคับให้คอลัมน์ email ต้องเป็น UNIQUE', false, 'ข้อจำกัด UNIQUE ไม่ได้ห้ามการ Query', 2);
INSERT INTO public.choices VALUES ('820b7491-22e3-42ae-8d4a-0e2c1b341871', '1965fab0-45b2-4e02-adc4-72650a0c04f0', 'เพราะต้องเปลี่ยนคำว่า NULL เป็นสตริง ''NULL'' เสมอ', false, '''NULL'' คือสตริงตัวอักษร ไม่ใช่ค่าว่าง NULL ในฐานข้อมูล', 3);
INSERT INTO public.choices VALUES ('744e07a2-863a-4271-b5ae-550d3f522de8', '1965fab0-45b2-4e02-adc4-72650a0c04f0', 'เพราะ PostgreSQL ไม่รองรับค่า NULL', false, 'PostgreSQL รองรับค่า NULL ตามมาตรฐาน SQL สากล', 4);
INSERT INTO public.choices VALUES ('e0f05385-311d-41c1-ac98-1363240ad3ad', '31c1b64e-e85e-4f8c-9eca-381f6805148b', 'คืนค่าตัวแรกที่ไม่เป็น NULL จากรายการที่ระบุ หากเป็น NULL ทั้งหมดจะคืนคำว่า ''N/A''', true, 'ถูกต้อง นี่คือนิยามและการทำงานของฟังก์ชัน COALESCE', 1);
INSERT INTO public.choices VALUES ('934f697f-aaf1-4dcf-a3c9-54a781f7beae', '31c1b64e-e85e-4f8c-9eca-381f6805148b', 'นำค่า phone, mobile และ ''N/A'' มาต่อกันเป็นข้อความเดียว', false, 'การต่อสตริงใช้ฟังก์ชัน CONCAT หรือโอเปอเรเตอร์ ||', 2);
INSERT INTO public.choices VALUES ('5c99259d-f10c-4ef7-adda-41e9594be1a8', '31c1b64e-e85e-4f8c-9eca-381f6805148b', 'คืนค่าเฉพาะกรณีที่ phone และ mobile มีค่าตรงกันเท่านั้น', false, 'ฟังก์ชันที่เช็คความเหมือนแล้วคืน NULL คือ NULLIF', 3);
INSERT INTO public.choices VALUES ('0850af74-78f5-401d-a2b3-49b141d8784c', '31c1b64e-e85e-4f8c-9eca-381f6805148b', 'บังคับแปลงเบอร์โทรศัพท์ให้เป็นรูปแบบสากล', false, 'COALESCE ไม่ได้จัด Format ตัวเลข', 4);
INSERT INTO public.choices VALUES ('ba3dd0fa-59c3-4bc7-9415-fa3152177e0c', '5718c858-1020-4652-9789-1d2f2f1629ae', 'ใช้ HAVING COUNT(*) > 10 หลังคำสั่ง GROUP BY ip_address', true, 'ถูกต้อง HAVING ใช้กรองเงื่อนไขของค่า Aggregate หลังจากจัดกลุ่มแล้ว', 1);
INSERT INTO public.choices VALUES ('1c1bc5ad-3ee1-4aae-b804-75b0f8cdcb9d', '5718c858-1020-4652-9789-1d2f2f1629ae', 'ใช้ WHERE COUNT(*) > 10 ก่อนคำสั่ง GROUP BY', false, 'จะเกิด Syntax error: aggregate functions are not allowed in WHERE', 2);
INSERT INTO public.choices VALUES ('d0b3ec53-9542-410f-925a-f1f8ff382393', '5718c858-1020-4652-9789-1d2f2f1629ae', 'ใช้ ORDER BY COUNT(*) > 10', false, 'ORDER BY ใช้จัดลำดับ ไม่ได้กรองตัดแถวที่ไม่ต้องการออก', 3);
INSERT INTO public.choices VALUES ('19234115-2c37-4cd4-87c6-b83826770bda', '5718c858-1020-4652-9789-1d2f2f1629ae', 'ใช้ LIMIT 10', false, 'LIMIT 10 เพียงแค่ตัดผลลัพธ์มาแสดง 10 แถวแรก ไม่ได้กรองตามเงื่อนไขจำนวนครั้ง', 4);
INSERT INTO public.choices VALUES ('cb3272f0-cf15-42a3-8656-bf053e2f8d93', 'e39e6e87-df02-4e08-a4a3-ddfce1e64731', 'สร้าง Index บนคอลัมน์ที่อยู่ในเงื่อนไข WHERE ของคำสั่ง Query เพื่อเปลี่ยนเป็นการค้นหาแบบ Index Scan', true, 'ถูกต้อง การสร้าง Index คือวิธีแก้ปัญหา Seq Scan บนตารางขนาดใหญ่โดยตรง', 1);
INSERT INTO public.choices VALUES ('0fa519e5-c6ac-4582-bc9c-473d85ed0c1a', 'e39e6e87-df02-4e08-a4a3-ddfce1e64731', 'เพิ่มขนาดของ CPU และ RAM ของ Database Server ให้สูงขึ้นทันที', false, 'การขยายเครื่องไม่ใช่วิธีแก้ปัญหาที่ถูกต้องเมื่อขาด Index การ Scan 5 ล้านแถวยังคงช้าอยู่ดี', 2);
INSERT INTO public.choices VALUES ('2d25ce7f-dd7a-44ed-a774-fd3bd50cf762', 'e39e6e87-df02-4e08-a4a3-ddfce1e64731', 'เปลี่ยนประเภทคอลัมน์เป็น VARCHAR ทั้งหมด', false, 'ไม่มีผลต่อการทำงานของ Index', 3);
INSERT INTO public.choices VALUES ('13496dbb-e16e-4b88-8a9c-b84ca50aefe1', 'e39e6e87-df02-4e08-a4a3-ddfce1e64731', 'สั่ง VACUUM FULL เพื่อลบข้อมูลเก่า', false, 'VACUUM เคลียร์ dead tuples แต่ไม่ได้สร้างดัชนีค้นหาใหม่', 4);
INSERT INTO public.choices VALUES ('2f2609ed-20de-4d9d-adca-aa2467eb4d98', '442a963b-7185-4a91-9925-5d292b0ec6cd', 'SELECT pg_terminate_backend(12450);', true, 'ถูกต้อง pg_terminate_backend บังคับตัดเซสชันของ pid นั้นทันทีอย่างแน่นอน', 1);
INSERT INTO public.choices VALUES ('73957f91-3da9-4a1d-b93d-011c39adf891', '442a963b-7185-4a91-9925-5d292b0ec6cd', 'KILL QUERY 12450;', false, 'KILL QUERY เป็นไวยากรณ์ของ MySQL ไม่ใช่ PostgreSQL', 2);
INSERT INTO public.choices VALUES ('4cddbec9-16db-4ac1-9c6e-76f5d5c73706', '442a963b-7185-4a91-9925-5d292b0ec6cd', 'DROP PROCESS 12450;', false, 'ไม่มีคำสั่งนี้ใน PostgreSQL', 3);
INSERT INTO public.choices VALUES ('08eb5281-0e05-4408-b41d-1717d1241ed5', '442a963b-7185-4a91-9925-5d292b0ec6cd', 'SYSTEMCTL STOP QUERY 12450;', false, 'systemctl จัดการ Service ระดับ Linux OS ไม่สามารถตัด pid ใน database ได้', 4);
INSERT INTO public.choices VALUES ('e2b178c2-3443-425e-a168-e82e236b999d', '264fa5d3-53b8-42c9-9879-5fe87517011a', 'กู้คืนระบบให้กลับมาใช้งานได้โดยเร็วที่สุด (Restore Service / ลด MTTR) แม้จะต้องใช้ทางเลี่ยงชั่วคราวหรือสั่ง Rollback', true, 'ถูกต้อง เป้าหมายคือหยุดความเสียหายต่อธุรกิจให้เร็วที่สุด', 1);
INSERT INTO public.choices VALUES ('1956ac60-5b00-411a-9967-b44d3441da2b', '6e981c68-db2f-4533-9f5d-8a923e156a67', 'Segment และ Datagram', false, 'ผิด Segment/Datagram คือ PDU ใน Layer 4', 4);
INSERT INTO public.choices VALUES ('d299f7fa-c629-4808-b5b0-87414824eac3', '264fa5d3-53b8-42c9-9879-5fe87517011a', 'นั่งไล่อ่านโค้ดทุกบรรทัดเพื่อหาบั๊กที่ทำให้เกิดปัญหาก่อนเปิดระบบ', false, 'การมัวแต่อ่านโค้ดโดยไม่ Rollback จะทำให้ธุรกิจเสียหายอย่างหนัก', 2);
INSERT INTO public.choices VALUES ('f22c4857-c359-4123-8668-0abb3784af02', '264fa5d3-53b8-42c9-9879-5fe87517011a', 'ประชุมเพื่อหาตัวคนผิดที่รับผิดชอบการดีพลอย', false, 'การกล่าวโทษ (Blame) ผิดหลักการ Blameless Post-Mortem', 3);
INSERT INTO public.choices VALUES ('7bd83241-d9ea-4d30-adf0-5562c866e25f', '264fa5d3-53b8-42c9-9879-5fe87517011a', 'ปิดระบบทั้งองค์กรเพื่อความปลอดภัย', false, 'ไม่ใช่แนวทางที่ถูกต้องสำหรับ Incident Management', 4);
INSERT INTO public.choices VALUES ('0174e6da-a0da-47b5-8f93-ffb28c9a43f4', '32ec1200-c002-4d27-b0d8-89f96f2d05d5', 'มีอะไรเปลี่ยนแปลงไปในระบบก่อนหน้าที่ปัญหาจะเริ่มเกิดขึ้นหรือไม่? (What Changed?)', true, 'ถูกต้อง การสืบค้น Change Logs มักไขข้อข้องใจได้ตรงจุดที่สุด', 1);
INSERT INTO public.choices VALUES ('91700085-e319-4e86-862e-13d41662e3d3', '32ec1200-c002-4d27-b0d8-89f96f2d05d5', 'เครื่องเซิร์ฟเวอร์ซื้อมาปีไหน?', false, 'อายุเครื่องไม่ใช่คำถามแรกในการ Triage', 2);
INSERT INTO public.choices VALUES ('602e95eb-1d45-4803-813a-32d7dbd5c9c7', '32ec1200-c002-4d27-b0d8-89f96f2d05d5', 'ใครเป็นคนเขียนโค้ดบรรทัดแรกของโปรเจกต์?', false, 'ไม่เกี่ยวข้องกับการแก้ปัญหาเฉพาะหน้า', 3);
INSERT INTO public.choices VALUES ('c9bb0881-ff0d-4a29-a8e8-89662961c0e5', '32ec1200-c002-4d27-b0d8-89f96f2d05d5', 'ดาต้าเบสรองรับภาษาอะไรบ้าง?', false, 'ไม่ใช่คำถามวิเคราะห์ต้นตอ', 4);
INSERT INTO public.choices VALUES ('f5220e5a-109c-4417-a8c1-8e3e0a937c4b', '9a165cbe-1a6d-41a7-994d-d7f2c50274c7', 'Log ข้อความ Error พร้อม Transaction ID ที่เจาะจง, ช่วงเวลาที่เริ่มเป็น และสิ่งที่ Support ได้ทดสอบคัดกรองเบื้องต้นไปแล้ว', true, 'ถูกต้อง นี่คือข้อมูลจำเป็นสำหรับการสืบสวนต่ออย่างมีประสิทธิภาพ', 1);
INSERT INTO public.choices VALUES ('6176fe47-0bd0-421d-814a-9b6b8ea99b84', '9a165cbe-1a6d-41a7-994d-d7f2c50274c7', 'เขียนสั้นๆ เพียงว่า ''ระบบช้า รบกวนช่วยดูด่วน''', false, 'ข้อมูลไม่เพียงพอ ทำให้ต้องเสียเวลาถามตอบไปมา', 2);
INSERT INTO public.choices VALUES ('367d9683-f379-4bdd-ae58-e772df6fad85', '9a165cbe-1a6d-41a7-994d-d7f2c50274c7', 'แนบเฉพาะสเปกฮาร์ดแวร์ของเครื่องคอมพิวเตอร์ลูกค้า', false, 'สเปกเครื่องลูกข่ายไม่ช่วยบอกสาเหตุของปัญหาฝั่งแอปพลิเคชัน', 3);
INSERT INTO public.choices VALUES ('096e6549-0ea1-4b2b-afe1-ef5e26eaa3ff', '9a165cbe-1a6d-41a7-994d-d7f2c50274c7', 'ส่งภาพหน้าต่างสีฟ้าโดยไม่ระบุรายละเอียด', false, 'ไม่ช่วยให้ผู้พัฒนาวิเคราะห์โค้ดได้', 4);
INSERT INTO public.choices VALUES ('0f50b0e6-40ed-4c54-a1e4-bc51d7178931', 'cad3c17c-591e-452d-bc6f-28238eee28f1', 'มุ่งเน้นการปรับปรุงระบบและกระบวนการทำงานเพื่อป้องกันไม่ให้เกิดปัญหาซ้ำ โดยไม่กล่าวโทษหรือลงโทษตัวบุคคล', true, 'ถูกต้อง มุ่งแก้ที่ระบบและกระบวนการ ไม่ใช่ลงโทษคน', 1);
INSERT INTO public.choices VALUES ('ed09dc1a-309c-421c-8ad9-48e61141c032', 'cad3c17c-591e-452d-bc6f-28238eee28f1', 'การปกปิดความผิดพลาดไม่ให้ผู้บริหารรับรู้', false, 'ผิดหลักความโปร่งใสและตรวจสอบได้', 2);
INSERT INTO public.choices VALUES ('80fe8f88-082b-42ee-8d71-20c207930c70', 'cad3c17c-591e-452d-bc6f-28238eee28f1', 'การตัดโบนัสพนักงานทุกคนที่อยู่ในกะที่ระบบล่ม', false, 'ตรงข้ามกับแนวคิด Blameless โดยสิ้นเชิง', 3);
INSERT INTO public.choices VALUES ('20533ebe-cccd-480a-9ac3-0fda1e77834c', 'cad3c17c-591e-452d-bc6f-28238eee28f1', 'การโยนความผิดให้ผู้ให้บริการคลาวด์ภายนอกเสมอ', false, 'ไม่ใช่แนวทางวิเคราะห์ที่สร้างสรรค์', 4);
INSERT INTO public.choices VALUES ('6e6995e5-d4cd-419a-98e0-f60ead13ae23', 'e6ac9105-39ae-46e1-85cb-1df0720cf127', 'Backend Application Server ด้านหลังหยุดทำงาน แครชล่ม หรือไม่เปิดพอร์ตตามที่ Nginx คอนฟิกไว้', true, 'ถูกต้อง Nginx ไม่สามารถเชื่อมต่อไปยัง Upstream ได้จึงส่ง 502 Bad Gateway', 1);
INSERT INTO public.choices VALUES ('5db3d8f2-a68f-4039-8067-49814f04563f', 'e6ac9105-39ae-46e1-85cb-1df0720cf127', 'Backend ประมวลผลช้าเกินกว่า 60 วินาที', false, 'ประมวลผลนานเกิน Timeout จะได้รหัส 504 Gateway Timeout ไม่ใช่ 502', 2);
INSERT INTO public.choices VALUES ('4a6845ad-1ccd-49b5-8630-9dd88cda2212', 'e6ac9105-39ae-46e1-85cb-1df0720cf127', 'Client ส่ง Header Authorization ที่มี Token หมดอายุมา', false, 'Token หมดอายุจะได้รหัส 401 Unauthorized', 3);
INSERT INTO public.choices VALUES ('a663e255-d684-41b2-8d01-a7b74239aebc', 'e6ac9105-39ae-46e1-85cb-1df0720cf127', 'Client ส่ง URL ที่ไม่มีอยู่จริงบนเซิร์ฟเวอร์', false, 'URL ไม่มีอยู่จริงจะได้รหัส 404 Not Found', 4);
INSERT INTO public.choices VALUES ('c0cc2028-8a14-4220-81a0-9458b12fed83', '5b92c358-a418-4117-a664-1c45579f5e01', '401 คือยังไม่ผ่านการยืนยันตัวตน (Authentication Failed/No Token), ส่วน 403 คือยืนยันตัวตนแล้วแต่ไม่มีสิทธิ์เข้าถึง (Authorization Failed/Forbidden)', true, 'ถูกต้อง 401 = Who are you? / 403 = I know who you are, but you cannot enter.', 1);
INSERT INTO public.choices VALUES ('37e50f17-c1b4-4aff-8b8d-51bd4c2504b0', '5b92c358-a418-4117-a664-1c45579f5e01', '401 ใช้กับหน้าเว็บ ส่วน 403 ใช้กับ REST API เท่านั้น', false, 'ทั้งสองรหัสเป็นมาตรฐาน HTTP ใช้ได้ทั้ง Web และ API', 2);
INSERT INTO public.choices VALUES ('d736d075-509b-490f-bb00-e7549afc8e15', '5b92c358-a418-4117-a664-1c45579f5e01', '401 เป็นข้อผิดพลาดฝั่ง Server ส่วน 403 เป็นฝั่ง Client', false, 'ทั้งรหัสขึ้นต้นด้วย 4xx จัดเป็น Client Error ทั้งคู่', 3);
INSERT INTO public.choices VALUES ('846318c3-ed31-4b30-a6d8-e4d6f513a2ae', '5b92c358-a418-4117-a664-1c45579f5e01', '401 คือเซิร์ฟเวอร์หาไฟล์ไม่พบ ส่วน 403 คือไฟล์ถูกลบไปแล้ว', false, 'ไฟล์หาไม่พบคือ 404 Not Found หรือ 410 Gone', 4);
INSERT INTO public.choices VALUES ('c9ad8e26-8ff6-4edc-9fb2-bedf66911668', 'd1fd2b23-0add-4fd1-95ea-8e56dc91c7cb', 'Layer 4 (Transport Layer) หรือการกรองพอร์ตของ Firewall', true, 'ถูกต้อง Connection Timed out มักเกิดจาก Firewall ทิ้งแพ็กเก็ต (DROP) ในชั้น Transport', 1);
INSERT INTO public.choices VALUES ('e5c71722-b6ca-45df-964c-58b94f68f032', '1b0c7347-ec8c-4c56-abd9-96fe64f7019e', 'ตรวจสอบ Slow Query หรือคำสั่งที่ค้างอยู่ใน Database และดูภาระ CPU/Memory ของ Backend Service', true, 'ถูกต้อง Backend ยังไม่ตายแต่ประมวลผลนานเกินกำหนด มักเกิดจากฐานข้อมูลช้า', 1);
INSERT INTO public.choices VALUES ('7bd3691a-6967-433a-9e5b-2bbe15667f31', '1b0c7347-ec8c-4c56-abd9-96fe64f7019e', 'สั่งรีสตาร์ท Router ของผู้ใช้งานทันที', false, '504 เกิดขึ้นที่ฝั่งเซิร์ฟเวอร์ (Proxy กับ Upstream) ไม่เกี่ยวกับเน็ตบ้านผู้ใช้', 2);
INSERT INTO public.choices VALUES ('1ef59d8f-8ec3-44a8-b746-11b49630231f', '1b0c7347-ec8c-4c56-abd9-96fe64f7019e', 'ตรวจสอบว่าผู้ใช้จำรหัสผ่านถูกหรือไม่', false, 'รหัสผ่านผิดจะไม่ทำให้เกิด 504 Timeout', 3);
INSERT INTO public.choices VALUES ('797d57fc-e777-461b-ace6-13d68f95ca14', '1b0c7347-ec8c-4c56-abd9-96fe64f7019e', 'เปลี่ยนโดเมนเนมของเว็บไซต์ใหม่', false, 'ไม่เกี่ยวกับการทำงานของ Gateway Timeout', 4);
INSERT INTO public.choices VALUES ('1447f67c-fa2e-46c8-ad38-68a4dd01798e', '4fe283f1-19c2-4303-a2fa-0b62358c2440', 'curl -I https://api.example.com', true, 'ถูกต้อง -I ส่ง HEAD request เพื่อดึงเฉพาะ Header', 1);
INSERT INTO public.choices VALUES ('a43a5a1e-b5a8-4ea9-8f95-d23c677f1277', '4fe283f1-19c2-4303-a2fa-0b62358c2440', 'curl -h https://api.example.com', false, '-h คือการเปิดหน้า Help ของคำสั่ง curl', 2);
INSERT INTO public.choices VALUES ('493c172b-80fd-444a-a0bc-bd92f5fa8695', '4fe283f1-19c2-4303-a2fa-0b62358c2440', 'curl --body-none https://api.example.com', false, 'ไม่มี option --body-none ใน curl', 3);
INSERT INTO public.choices VALUES ('fa7b3d61-410f-466c-b725-690d0831a720', '4fe283f1-19c2-4303-a2fa-0b62358c2440', 'curl -s https://api.example.com', false, '-s คือ silent mode เพื่อปิด progress bar', 4);
INSERT INTO public.choices VALUES ('443b61f4-4851-4d9b-97f8-aff76452305d', 'f92cd87a-0d5e-49eb-a61a-7764f41baf12', 'curl -H "Host: api.company.com" http://10.0.1.25/health', true, 'ถูกต้อง การใส่ Host Header ช่วยทดสอบเจาะจง IP ได้โดยตรง', 1);
INSERT INTO public.choices VALUES ('d42ce7d6-7e89-4d97-b9fe-07769878de92', 'f92cd87a-0d5e-49eb-a61a-7764f41baf12', 'curl http://10.0.1.25:api.company.com', false, 'ไวยากรณ์นี้ไม่ถูกต้อง หลังโคลอนต้องเป็นพอร์ตตัวเลข', 2);
INSERT INTO public.choices VALUES ('4cd001f0-51fe-4050-ba90-67ad3feca724', 'f92cd87a-0d5e-49eb-a61a-7764f41baf12', 'curl -X DOMAIN http://10.0.1.25', false, '-X กำหนด HTTP Method ไม่ใช่โดเมน', 3);
INSERT INTO public.choices VALUES ('d05ec264-9fc1-4c1a-9721-515974506caf', 'f92cd87a-0d5e-49eb-a61a-7764f41baf12', 'curl --dns-bypass http://10.0.1.25', false, 'ไม่มีแฟล็ก --dns-bypass ใน curl', 4);
INSERT INTO public.choices VALUES ('5d7208d8-3426-4c2b-b6ce-10b9d073b066', '35845f5e-4dcb-431d-8543-90b3ad2d0b52', 'openssl s_client -connect domain.com:443 -servername domain.com < /dev/null | openssl x509 -noout -enddate', true, 'ถูกต้อง นี่คือคำสั่งที่ถูกต้องพร้อมระบุ SNI (-servername) และแสดงบรรทัด notAfter', 1);
INSERT INTO public.choices VALUES ('42394f72-4d0e-4fbd-b836-3753d087da0d', '35845f5e-4dcb-431d-8543-90b3ad2d0b52', 'openssl check-cert domain.com:443', false, 'ไม่มีคำสั่งย่อย check-cert ใน openssl', 2);
INSERT INTO public.choices VALUES ('53d22a3e-9e4b-470c-9499-395e59c04b20', '35845f5e-4dcb-431d-8543-90b3ad2d0b52', 'curl --check-ssl-expiry domain.com', false, 'curl ไม่มีแฟล็ก --check-ssl-expiry', 3);
INSERT INTO public.choices VALUES ('76852451-286a-447e-9630-39c3ac04a06b', '35845f5e-4dcb-431d-8543-90b3ad2d0b52', 'ping -ssl domain.com', false, 'ping ทำงานบนระดับ ICMP Layer 3 ไม่รู้จัก SSL/TLS', 4);
INSERT INTO public.choices VALUES ('e01f4209-60ae-4bd7-9477-6715b8565d70', '22fcc240-b574-4819-8d9b-af1205ffe0df', 'ยังไม่ได้สั่ง Reload หรือ Restart โปรเซสของ Web Server (เช่น sudo systemctl reload nginx) ทำให้ระบบยังคงใช้ใบรับรองเดิมที่อยู่ใน RAM', true, 'ถูกต้อง ต้อง reload service เสมอหลังจากอัปเดตไฟล์ certificate', 1);
INSERT INTO public.choices VALUES ('25b7fd17-a598-41c9-87f9-49a7103040e0', '22fcc240-b574-4819-8d9b-af1205ffe0df', 'ระบบต้องรอเวลาอย่างน้อย 24 ชั่วโมงเพื่อให้ DNS อัปเดต', false, 'SSL Certificate อยู่บน Web Server ไม่เกี่ยวกับ DNS Propagation', 2);
INSERT INTO public.choices VALUES ('570e7fbb-ea61-47de-9a38-2db194827023', '22fcc240-b574-4819-8d9b-af1205ffe0df', 'เพราะไม่ได้ทำการ Format ดิสก์ใหม่', false, 'การเปลี่ยน Certificate ไม่เกี่ยวกับการ Format ดิสก์', 3);
INSERT INTO public.choices VALUES ('27a3bf9f-dc6a-48b8-9e8a-fa9cc7972fe9', '22fcc240-b574-4819-8d9b-af1205ffe0df', 'เพราะพอร์ต 443 ถูกจำกัดให้ใช้ Certificate ใบเดิมตลอดไป', false, 'พอร์ตเครือข่ายสามารถเปลี่ยน Certificate ได้ตลอดเวลา', 4);
INSERT INTO public.choices VALUES ('8b8118c7-4581-4858-ad3d-51f26817064a', '327a3f1f-ee09-4088-b3ec-5b8dc48e5c8c', 'Network ID: 192.168.1.128, Broadcast IP: 192.168.1.191', true, 'ถูกต้อง /26 มี Block Size ละ 64 ไอพี .130 อยู่ในช่วง .128 ถึง .191', 1);
INSERT INTO public.choices VALUES ('ecb4abcd-77fc-4013-95bf-a1dccdc14076', '327a3f1f-ee09-4088-b3ec-5b8dc48e5c8c', 'Network ID: 192.168.1.0, Broadcast IP: 192.168.1.255', false, 'ผิด นั่นคือช่วงของ /24', 2);
INSERT INTO public.choices VALUES ('0774bd4a-973c-437c-a926-0f9b4e431a02', '327a3f1f-ee09-4088-b3ec-5b8dc48e5c8c', 'Network ID: 192.168.1.64, Broadcast IP: 192.168.1.127', false, 'ผิด ช่วง .64-.127 ยังไม่ถึง .130', 3);
INSERT INTO public.choices VALUES ('cfba3133-c342-4a5e-94c3-83c60e851538', '327a3f1f-ee09-4088-b3ec-5b8dc48e5c8c', 'Network ID: 192.168.1.128, Broadcast IP: 192.168.1.255', false, 'ผิด Broadcast ของ /26 ต้องเป็น .191 ไม่ใช่ .255', 4);
INSERT INTO public.choices VALUES ('dca64936-acc4-477c-aaae-83bc501205e9', '38803ea5-5df5-408e-b93f-89f392bbb11f', '/27 (255.255.255.224 รองรับได้ 30 เครื่อง)', true, 'ถูกต้อง /27 ให้ 30 Usable Hosts เพียงพอสำหรับ 28 เครื่องและประหยัดที่สุด', 1);
INSERT INTO public.choices VALUES ('bb4be496-9073-4473-850f-b8d5e703e2ca', '38803ea5-5df5-408e-b93f-89f392bbb11f', '/28 (255.255.255.240 รองรับได้ 14 เครื่อง)', false, 'ผิด /28 ได้แค่ 14 เครื่อง ไม่พอสำหรับ 28 เครื่อง', 2);
INSERT INTO public.choices VALUES ('9d022c22-e001-4264-8f84-d38a3a7e7539', '38803ea5-5df5-408e-b93f-89f392bbb11f', '/26 (255.255.255.192 รองรับได้ 62 เครื่อง)', false, 'แม้จะพอแต่เปลือง IP เกินความจำเป็น ไม่ใช่ตัวเลือกที่ประหยัดที่สุด', 3);
INSERT INTO public.choices VALUES ('9c7a2f11-b3d7-4cfb-82f7-8aad9f37740f', '38803ea5-5df5-408e-b93f-89f392bbb11f', '/29 (255.255.255.248 รองรับได้ 6 เครื่อง)', false, 'ผิด /29 ได้แค่ 6 เครื่อง', 4);
INSERT INTO public.choices VALUES ('02d5d967-f3e3-4354-af0f-107435bea543', 'e75e4f1e-eac7-4c46-bc80-4535f39071c8', 'Layer 7 (Application Layer) เนื่องจากระบบ DNS มีปัญหา', true, 'ถูกต้อง เพราะ DNS เป็น Application Protocol ที่รับผิดชอบการแปลงชื่อ Hostname เป็น IP', 1);
INSERT INTO public.choices VALUES ('2e31f303-2334-43ae-9508-a9331e09e623', 'e75e4f1e-eac7-4c46-bc80-4535f39071c8', 'Layer 3 (Network Layer) เนื่องจาก Routing เสียหาย', false, 'ผิด เพราะ ping 8.8.8.8 และ Gateway ติด แสดงว่า Routing ปกติ', 2);
INSERT INTO public.choices VALUES ('071f4a6c-2b11-4109-b25a-b02a29ca6ff2', 'e75e4f1e-eac7-4c46-bc80-4535f39071c8', 'Layer 1 (Physical Layer) สายสัญญาณหลวม', false, 'ผิด หากสายหลวมจะ ping อะไรไม่ติดเลย', 3);
INSERT INTO public.choices VALUES ('defd7e8c-5371-4772-8210-91edd3d76007', 'e75e4f1e-eac7-4c46-bc80-4535f39071c8', 'Layer 2 (Data Link Layer) มีปัญหา VLAN', false, 'ผิด หาก VLAN ผิด จะ ping Gateway ในวงไม่ติด', 4);
INSERT INTO public.choices VALUES ('89253fee-f8ba-45d3-b70e-338d648e859f', 'd1fd2b23-0add-4fd1-95ea-8e56dc91c7cb', 'Layer 2 (Data Link Layer) สวิตช์ไม่ส่งข้อมูล', false, 'ผิด เพราะ ping ที่อยู่ Layer 3 สามารถวิ่งผ่านสวิตช์ไป-กลับได้ปกติ', 2);
INSERT INTO public.choices VALUES ('43ecd49d-66c5-4d3c-ad21-90567d31eb9a', 'd1fd2b23-0add-4fd1-95ea-8e56dc91c7cb', 'Layer 1 (Physical Layer) พอร์ตแลนชำรุด', false, 'ผิด หาก Physical เสีย จะไม่สามารถ ping ได้', 3);
INSERT INTO public.choices VALUES ('44edae78-a98c-4ca1-8826-9d19b2fb362d', 'd1fd2b23-0add-4fd1-95ea-8e56dc91c7cb', 'Layer 6 (Presentation Layer) ถอดรหัส SSL ไม่ได้', false, 'ผิด การเชื่อมต่อ TCP Handshake ยังไม่สำเร็จด้วยซ้ำ จึงยังไม่ถึงขั้น SSL', 4);
INSERT INTO public.choices VALUES ('ce49ea0d-6edf-40d2-8049-e2b205cf7750', 'ce1f94cc-3909-4aa0-baf9-6db3001a8836', 'Layer 2 (Data Link) และ Layer 3 (Network)', true, 'ถูกต้อง Switch = Layer 2, Router = Layer 3', 1);
INSERT INTO public.choices VALUES ('11c982de-b988-4e0c-8157-f202d8ea307c', 'ce1f94cc-3909-4aa0-baf9-6db3001a8836', 'Layer 1 (Physical) และ Layer 2 (Data Link)', false, 'ผิด Hub ทำงานที่ Layer 1, Switch อยู่ที่ Layer 2', 2);
INSERT INTO public.choices VALUES ('e72a13c8-824e-48d7-accb-9fef34c9662d', 'ce1f94cc-3909-4aa0-baf9-6db3001a8836', 'Layer 3 (Network) และ Layer 4 (Transport)', false, 'ผิด Router ทำงานที่ Layer 3 ไม่ใช่ Layer 4', 3);
INSERT INTO public.choices VALUES ('989150d2-59ae-4046-8337-e9e768b0d607', 'ce1f94cc-3909-4aa0-baf9-6db3001a8836', 'Layer 2 (Data Link) ทั้งคู่', false, 'ผิด Router ทำงานที่ Layer 3', 4);
INSERT INTO public.choices VALUES ('5f472038-1075-4d85-b4cc-e91a7564c43f', '811e4d06-268a-48ee-8694-c9d2e24494bf', 'เมื่อมีการติดตั้งเครื่องเซิร์ฟเวอร์ใหม่ หรือเพิ่งเดินสายสัญญาณและเชื่อมต่ออุปกรณ์เข้าตู้แร็ค', true, 'ถูกต้อง เพราะต้องตรวจว่าไฟพอร์ตติดและสายดีตั้งแต่ Layer 1 ก่อนคอนฟิกส่วนอื่น', 1);
INSERT INTO public.choices VALUES ('37ba0258-2941-4ac7-aa86-973b958c60f9', '811e4d06-268a-48ee-8694-c9d2e24494bf', 'เมื่อผู้ใช้แจ้งว่าเว็บมีปุ่มสีเพี้ยนในเบราว์เซอร์ Safari', false, 'ผิด กรณีนี้เป็นปัญหาหน้าบ้าน (Frontend UI) ไม่เกี่ยวกับสายแลน', 2);
INSERT INTO public.choices VALUES ('0afdb093-0621-4d62-8a1c-8a7d7b0fe046', '811e4d06-268a-48ee-8694-c9d2e24494bf', 'เมื่อระบบแจ้งเตือนว่า Memory ใช้งานเต็ม 99%', false, 'ผิด ปัญหาทรัพยากรเครื่องไม่จำเป็นต้องตรวจสายแลนหรือสวิตช์', 3);
INSERT INTO public.choices VALUES ('90d53382-1de6-4d9e-91a7-36f1b0f95775', '811e4d06-268a-48ee-8694-c9d2e24494bf', 'เมื่อต้องการตรวจสอบว่าทำไม Nginx ตอบกลับ HTTP 500', false, 'ผิด กรณีนี้เหมาะกับ Top-Down เพราะเครือข่ายต่อได้แล้วแต่ระบบแอปมีปัญหา', 4);
INSERT INTO public.choices VALUES ('27f764c7-a119-4e4b-b9f2-1f0342c3c22c', 'd5a6607b-d2ab-4160-b0f5-bf5a8e021c1d', 'เพราะอยู่คนละ VLAN ซึ่งตัดขาดการสื่อสารที่ Layer 2 ต้องอาศัย Router หรือ L3 Switch ในการส่งต่อ (Inter-VLAN Routing)', true, 'ถูกต้อง VLAN ทำหน้าที่แยกบรอดคาสต์โดเมน หากไม่มีอุปกรณ์ Layer 3 จะไม่สามารถคุยข้ามกันได้', 1);
INSERT INTO public.choices VALUES ('91882b9f-438e-4f5e-9126-adb689aa302a', 'd5a6607b-d2ab-4160-b0f5-bf5a8e021c1d', 'เพราะสายสัญญาณของ Server B ขาดใน', false, 'ผิด ไม่ใช่สาเหตุหลัก เพราะทั้งสองตั้งใจอยู่คนละ VLAN', 2);
INSERT INTO public.choices VALUES ('596ac809-c439-41a7-af61-4bf5c7df7f1d', 'd5a6607b-d2ab-4160-b0f5-bf5a8e021c1d', 'เพราะพอร์ตสวิตช์ต้องปรับเป็นโหมด Trunk ทั้งคู่', false, 'ผิด เซิร์ฟเวอร์ทั่วไปเชื่อมต่อด้วยพอร์ต Access ไม่ใช่ Trunk', 3);
INSERT INTO public.choices VALUES ('11cb292a-90e2-443a-a8a9-923d2004e52a', 'd5a6607b-d2ab-4160-b0f5-bf5a8e021c1d', 'เพราะสวิตช์ตัวเดียวกันไม่สามารถสร้างมากกว่า 1 VLAN ได้', false, 'ผิด สวิตช์สามารถสร้างได้หลาย VLAN (ปกติได้สูงสุด 4094 VLANs)', 4);
INSERT INTO public.choices VALUES ('7fcb6b08-b450-484e-839c-54a09c465582', '7c3302c8-0a22-43e9-ab9a-6f3e9cb1b549', 'IEEE 802.1Q (Dot1q)', true, 'ถูกต้อง 802.1Q คือมาตรฐานอุตสาหกรรมสำหรับการแท็ก VLAN', 1);
INSERT INTO public.choices VALUES ('9d423734-478d-4f63-a535-266c291399b2', '7c3302c8-0a22-43e9-ab9a-6f3e9cb1b549', 'IEEE 802.3ad', false, 'ผิด 802.3ad คือมาตรฐาน LACP (Link Aggregation)', 2);
INSERT INTO public.choices VALUES ('1bfc202c-bd7a-4cd0-a27c-eda605757db5', '7c3302c8-0a22-43e9-ab9a-6f3e9cb1b549', 'IEEE 802.11ax', false, 'ผิด 802.11ax คือ Wi-Fi 6', 3);
INSERT INTO public.choices VALUES ('bcf6707f-9576-4e26-904e-be7366081b3f', '7c3302c8-0a22-43e9-ab9a-6f3e9cb1b549', 'IEEE 802.1D', false, 'ผิด 802.1D คือ Spanning Tree Protocol (STP)', 4);
INSERT INTO public.choices VALUES ('95b2670a-ef4a-4a59-9ba0-e5c703e5207f', '7d3ba65b-d6e0-4272-be9d-2132dc332262', 'ส่งต่อเฟรมนั้นเข้าสู่ ''Native VLAN'' ที่กำหนดไว้ของพอร์ตนั้น', true, 'ถูกต้อง เฟรม Untagged จะถูกส่งเข้า Native VLAN อัตโนมัติ', 1);
INSERT INTO public.choices VALUES ('c9f03a0c-b35a-4e31-8b8e-03146117103c', '7d3ba65b-d6e0-4272-be9d-2132dc332262', 'สวิตช์จะทิ้ง (Drop) เฟรมนั้นทันทีเพราะพอร์ต Trunk รับเฉพาะ Tagged Frame', false, 'ผิด พอร์ต Trunk ยอมรับ Untagged Frame ได้ 1 วง นั่นคือ Native VLAN', 2);
INSERT INTO public.choices VALUES ('eaa810a9-885d-4ab6-86e1-9fd177c045f9', '7d3ba65b-d6e0-4272-be9d-2132dc332262', 'ส่งกระจายออกไปยังทุก VLAN ที่มีในสวิตช์', false, 'ผิด การส่งข้าม VLAN เป็นเรื่องต้องห้ามที่ Layer 2', 3);
INSERT INTO public.choices VALUES ('764fdbce-abf5-4d1a-ace6-19b00dae275e', '7d3ba65b-d6e0-4272-be9d-2132dc332262', 'สวิตช์จะแปลงเฟรมนั้นเป็นแพ็กเก็ต Layer 3 ทันที', false, 'ผิด สวิตช์ Layer 2 ไม่แปลงเฟรมเป็นแพ็กเก็ต', 4);
INSERT INTO public.choices VALUES ('ed07c900-4e52-4b89-9e5b-261b594d1845', '62acd40b-f56e-4c54-ab90-2fa76164588b', 'Flooding: ส่งเฟรมนั้นออกไปทุกพอร์ตใน VLAN เดียวกัน ยกเว้นพอร์ตที่รับเฟรมเข้ามา', true, 'ถูกต้อง นี่คือกลไกพื้นฐานเพื่อให้ปลายทางได้รับข้อมูลและตอบกลับ สวิตช์จะได้เรียนรู้ MAC นั้น', 1);
INSERT INTO public.choices VALUES ('d377404b-97ea-48dd-aa0f-c4ffcf51b755', '62acd40b-f56e-4c54-ab90-2fa76164588b', 'Drop: ทิ้งเฟรมนั้นทันทีเพื่อความปลอดภัยของเครือข่าย', false, 'ผิด สวิตช์จะไม่ทิ้ง แต่จะส่งกระจาย (Flooding)', 2);
INSERT INTO public.choices VALUES ('945ec7d9-9530-40ac-bc14-4abd6d5173cd', '62acd40b-f56e-4c54-ab90-2fa76164588b', 'ส่งเฟรมนั้นไปยัง Default Gateway เสมอ', false, 'ผิด สวิตช์ Layer 2 ส่งเฟรมด้วย MAC ไม่ส่งไปที่ Gateway เอง เว้นแต่เครื่องต้นทางจะระบุ MAC ของ Gateway มา', 3);
INSERT INTO public.choices VALUES ('d095dfbd-af9d-4f6b-8191-af49baf7c8c2', '62acd40b-f56e-4c54-ab90-2fa76164588b', 'สวิตช์จะทำการยิงคำสั่ง Ping ไปตรวจสอบเครื่องปลายทาง', false, 'ผิด สวิตช์ไม่มีกลไกส่ง Ping อัตโนมัติเมื่อไม่พบ MAC', 4);
INSERT INTO public.choices VALUES ('a029f140-17a4-4b4b-9e92-621dec337096', '6beac71f-ab96-429b-ba53-7d8e90efdf67', 'ip neigh show (หรือ arp -an)', true, 'ถูกต้อง ip neigh แสดงตาราง Neighbor/ARP บน Linux', 1);
INSERT INTO public.choices VALUES ('704f32ab-7dc6-4ae0-b517-11b8da455597', '6beac71f-ab96-429b-ba53-7d8e90efdf67', 'ip route show', false, 'ผิด ip route ใช้ดูตาราง Routing ไม่ใช่ ARP', 2);
INSERT INTO public.choices VALUES ('57bedc06-6c34-4622-aa15-b53d7602e915', '6beac71f-ab96-429b-ba53-7d8e90efdf67', 'ss -tulpn', false, 'ผิด ss ใช้ดูสถานะ Port และ Socket ไม่ใช่ ARP', 3);
INSERT INTO public.choices VALUES ('611636a2-d4fb-4781-b67d-7edc7e76e0e1', '6beac71f-ab96-429b-ba53-7d8e90efdf67', 'ethtool eth0', false, 'ผิด ethtool ใช้ดูความเร็วและฮาร์ดแวร์ของการ์ดแลน', 4);
INSERT INTO public.choices VALUES ('7d0dff00-b066-477f-92cd-56daf3d9c41b', 'a3d59ff8-03bc-4ee8-a561-93a6feb5cf8e', 'Discover -> Offer -> Request -> Acknowledge', true, 'ถูกต้อง นี่คือลำดับ DORA Process', 1);
INSERT INTO public.choices VALUES ('5e12c7c2-6b87-47b0-b2f3-a1442e9fab1d', 'a3d59ff8-03bc-4ee8-a561-93a6feb5cf8e', 'Discover -> Request -> Offer -> Acknowledge', false, 'ผิด Server ต้อง Offer ไอพีก่อนที่ Client จะ Request', 2);
INSERT INTO public.choices VALUES ('fc68c091-da7f-4235-8623-90ced419ac54', 'a3d59ff8-03bc-4ee8-a561-93a6feb5cf8e', 'Request -> Offer -> Discover -> Acknowledge', false, 'ผิด ขั้นแรกต้องเป็น Discover', 3);
INSERT INTO public.choices VALUES ('252a238d-4024-4247-a15e-164c3ee45434', 'a3d59ff8-03bc-4ee8-a561-93a6feb5cf8e', 'Demand -> Obtain -> Release -> Accept', false, 'ผิด ไม่ใช่ชื่อขั้นตอนของ DHCP', 4);
INSERT INTO public.choices VALUES ('e76e33f6-3cfa-4a6a-bb47-7a5fd68b8a5f', 'a4d3b42b-b063-43a3-b338-578b87fae333', 'เครื่องไม่สามารถติดต่อหรือรับไอพีจาก DHCP Server ได้ (APIPA)', true, 'ถูกต้อง 169.254.x.x เป็นสัญลักษณ์ของ APIPA เมื่อ DHCP ล้มเหลว', 1);
INSERT INTO public.choices VALUES ('17b67d8f-0113-41e2-9552-748fb9033b2d', 'a4d3b42b-b063-43a3-b338-578b87fae333', 'เครื่องได้รับ Public IP จริงจากผู้ให้บริการอินเทอร์เน็ตแล้ว', false, 'ผิด 169.254.x.x เป็น Link-Local Address ไม่ใช่ Public IP ที่ออกเน็ตได้', 2);
INSERT INTO public.choices VALUES ('ecae113d-9be2-43b7-b3fc-5261f78656b1', 'a4d3b42b-b063-43a3-b338-578b87fae333', 'ระบบกำลังเชื่อมต่อผ่าน VPN สำเร็จเรียบร้อย', false, 'ผิด ไม่เกี่ยวกับ VPN', 3);
INSERT INTO public.choices VALUES ('e9e9454d-1ae3-462c-9f21-cd881d24459f', 'a4d3b42b-b063-43a3-b338-578b87fae333', 'ระบบตรวจพบว่าการ์ดแลนถูกไวรัสโจมตีจนพังถาวร', false, 'ผิด การ์ดแลนยังทำงานได้ปกติ แต่ไม่ได้รับไอพีจากเน็ตเวิร์ก', 4);
INSERT INTO public.choices VALUES ('a86f2911-37f5-4abd-8541-94c6e18b295b', '79645a39-48ce-4bfd-b6f6-b8809dfba87c', 'DHCP Relay Agent (คำสั่ง ip helper-address)', true, 'ถูกต้อง DHCP Relay ทำหน้าที่ส่งต่อคำขอข้าม Subnet ไปยัง DHCP Server', 1);
INSERT INTO public.choices VALUES ('97d1a882-1f3d-41cd-a61b-a75956aa3531', '79645a39-48ce-4bfd-b6f6-b8809dfba87c', 'NAT Overload', false, 'ผิด NAT ใช้แปลงแอดเดรส ไม่ใช่ส่งต่อการขอไอพี', 2);
INSERT INTO public.choices VALUES ('7451d475-51aa-4437-a457-593aa3c42cfd', '79645a39-48ce-4bfd-b6f6-b8809dfba87c', 'Spanning Tree Protocol (STP)', false, 'ผิด STP ใช้ป้องกัน Loop ใน Layer 2', 3);
INSERT INTO public.choices VALUES ('931db5ef-171e-4d65-89ee-6ee70fd42032', '79645a39-48ce-4bfd-b6f6-b8809dfba87c', 'Dynamic ARP Inspection', false, 'ผิด DAI เป็นฟีเจอร์ความปลอดภัย ป้องกัน ARP Spoofing', 4);
INSERT INTO public.choices VALUES ('27f4ac42-cecf-4256-925b-775b92f44888', 'c81e6aa9-e017-4ee8-bd8a-f170ba5d2e30', 'PAT (Port Address Translation หรือ NAT Overload)', true, 'ถูกต้อง PAT ใช้ Port Number แยกเซสชันของอุปกรณ์นับร้อยเครื่องผ่าน Public IP เบอร์เดียว', 1);
INSERT INTO public.choices VALUES ('3c58da65-5ea1-4521-ac6c-18a79ed86a2f', 'c81e6aa9-e017-4ee8-bd8a-f170ba5d2e30', 'Static NAT (1-to-1)', false, 'ผิด Static NAT ใช้ Public IP 1 เบอร์ต่อเครื่องลูกข่าย 1 เครื่องเท่านั้น', 2);
INSERT INTO public.choices VALUES ('368d9ee5-a7f3-44f3-8cc1-7503841a5bed', 'c81e6aa9-e017-4ee8-bd8a-f170ba5d2e30', 'Dynamic Routing', false, 'ผิด การทำ Routing เป็นการหาเส้นทาง ไม่ใช่การแปลงแอดเดรส', 3);
INSERT INTO public.choices VALUES ('d9a4a5dc-4898-4849-8e77-dc71e1e4f9be', 'c81e6aa9-e017-4ee8-bd8a-f170ba5d2e30', 'Proxy ARP', false, 'ผิด Proxy ARP เป็นการตอบ ARP แทนเครื่องอื่น ไม่ใช่การแชร์ Public IP', 4);
INSERT INTO public.choices VALUES ('0b486f1c-5e20-480c-ac31-d076fe9f58dc', '49da2415-c6d1-440c-b962-0d129a95f694', 'Static NAT (1-to-1) หรือ Destination NAT / Port Forwarding', true, 'ถูกต้อง การชี้จากภายนอกเข้าหาเซิร์ฟเวอร์ภายในต้องทำ Port Forwarding หรือ Static NAT', 1);
INSERT INTO public.choices VALUES ('1f16b074-8b25-4eb4-a2e2-5a9b06165d8e', '49da2415-c6d1-440c-b962-0d129a95f694', 'DHCP Snooping', false, 'ผิด DHCP Snooping เป็นเรื่องป้องกัน DHCP เถื่อนในสวิตช์', 2);
INSERT INTO public.choices VALUES ('4628f386-d5e4-4637-9fd8-f697c80d7477', '49da2415-c6d1-440c-b962-0d129a95f694', 'Dynamic NAT แบบไม่มี Overload', false, 'ผิด Dynamic NAT สุ่มไอพีขาออก ไม่สามารถรับการเชื่อมต่อขาเข้าที่แน่นอนได้', 3);
INSERT INTO public.choices VALUES ('d4fca0e3-95f5-4b16-837f-bbf838e5f878', '49da2415-c6d1-440c-b962-0d129a95f694', 'APIPA', false, 'ผิด APIPA ไม่สามารถใช้งานบนอินเทอร์เน็ตได้', 4);
INSERT INTO public.choices VALUES ('bfd33699-99dc-4ef3-94ed-32267fe595d3', '078a7bed-80ff-486c-8dee-ef31175e5ef5', 'พอร์ตถูกสั่งปิดใช้งานด้วยคำสั่ง ''shutdown'' โดยผู้ดูแลระบบ', true, 'ถูกต้อง administratively down คือพอร์ตถูกปิดด้วยคำสั่ง shutdown', 1);
INSERT INTO public.choices VALUES ('a8fa2077-aceb-4232-b3d3-5d5095673267', '078a7bed-80ff-486c-8dee-ef31175e5ef5', 'สายสัญญาณแลนขาดใน หรือปลายทางไม่ได้เปิดเครื่อง', false, 'ผิด หากสายหลุดหรือปลายทางปิดเครื่อง สถานะจะเป็น ''down / down'' ไม่ใช่ administratively down', 2);
INSERT INTO public.choices VALUES ('6745b563-b283-4301-846a-24a24953944a', '078a7bed-80ff-486c-8dee-ef31175e5ef5', 'พอร์ตกำลังได้รับ Broadcast Storm โจมตี', false, 'ผิด หากโดน Storm พอร์ตอาจขึ้นสถานะ err-disabled', 3);
INSERT INTO public.choices VALUES ('ed4b1d15-98f0-40e3-9718-1098e82ce697', '078a7bed-80ff-486c-8dee-ef31175e5ef5', 'พอร์ตกำลังส่งข้อมูลด้วยความเร็วสูงสุด', false, 'ผิด สถานะนี้คือพอร์ตถูกปิดใช้งาน', 4);
INSERT INTO public.choices VALUES ('c3bdbb2e-cbbd-4bbc-8c01-319275303d1f', '52df195e-483c-4a2b-a982-463827ca7fbd', 'สายสัญญาณชำรุด มีสัญญาณรบกวน (Noise) หรือหัวต่อสายหลวม/สกปรก', true, 'ถูกต้อง CRC error บ่งบอกถึงปัญหาทางกายภาพและสัญญาณรบกวนใน Layer 1 ชัดเจนที่สุด', 1);
INSERT INTO public.choices VALUES ('85d188c7-ffc2-425e-865d-ea45104afee5', '52df195e-483c-4a2b-a982-463827ca7fbd', 'พอร์ตสวิตช์ถูกตั้งค่าผิด VLAN', false, 'ผิด การตั้ง VLAN ผิดจะไม่ทำให้เกิด CRC error แต่จะทำให้คุยกันไม่รู้เรื่อง', 2);
INSERT INTO public.choices VALUES ('96368ecf-9374-46d6-a335-f3d4d24249bc', '52df195e-483c-4a2b-a982-463827ca7fbd', 'เราเตอร์ไม่มี Default Gateway', false, 'ผิด Routing ไม่ทำให้เกิด CRC error บนพอร์ต Layer 2', 3);
INSERT INTO public.choices VALUES ('0e8fea03-697c-4629-a9ed-2c0a3d37f8ad', '52df195e-483c-4a2b-a982-463827ca7fbd', 'เซิร์ฟเวอร์ปลายทางใช้ Memory เต็ม 100%', false, 'ผิด Memory เซิร์ฟเวอร์ไม่ส่งผลให้เฟรมของสวิตช์เกิด CRC error', 4);
INSERT INTO public.choices VALUES ('9789bda0-2389-4cce-be5d-3e7c8d999f38', '69303d68-e689-49b4-9c70-5faa75c07553', 'show vlan brief', true, 'ถูกต้อง show vlan brief ใช้ดูรายการ VLAN และพอร์ตที่สังกัด', 1);
INSERT INTO public.choices VALUES ('e046bdc5-fd40-4bbc-9037-d7730faab787', '69303d68-e689-49b4-9c70-5faa75c07553', 'show ip route', false, 'ผิด show ip route ใช้ดูตาราง Routing ของ Layer 3', 2);
INSERT INTO public.choices VALUES ('49a63a34-cbec-40d7-b947-b94d9f7e0d30', '69303d68-e689-49b4-9c70-5faa75c07553', 'show mac address-table', false, 'ผิด show mac address-table ใช้ดูตาราง MAC Address ที่เรียนรู้มา', 3);
INSERT INTO public.choices VALUES ('5bb930cf-4d52-40d7-b26d-12993dd8e691', '69303d68-e689-49b4-9c70-5faa75c07553', 'show running-config interface', false, 'ผิด เป็นคำสั่งดูคอนฟิกดิบ ไม่ได้สรุปภาพรวมในรูปแบบตาราง', 4);
INSERT INTO public.choices VALUES ('bb8406aa-9839-4e0c-9e06-cf937ce52f8a', '8d7e57ad-f961-4347-ad2d-199066471909', '9600', true, 'ถูกต้อง 9600 คือ Baud rate มาตรฐานของ Console port', 1);
INSERT INTO public.choices VALUES ('991f051a-9472-4be7-a757-9d7939075e63', '8d7e57ad-f961-4347-ad2d-199066471909', '115200', false, 'ผิด 115200 นิยมใช้ในอุปกรณ์บอร์ดบางประเภท แต่ Cisco ดั้งเดิมคือ 9600', 2);
INSERT INTO public.choices VALUES ('0d2cb680-8702-4b1a-a7f7-966234eb3dcf', '8d7e57ad-f961-4347-ad2d-199066471909', '1000', false, 'ผิด ไม่ใช่ค่ามาตรฐาน Serial', 3);
INSERT INTO public.choices VALUES ('dff18879-6302-4152-92e5-526c7c411f3f', '8d7e57ad-f961-4347-ad2d-199066471909', '4800', false, 'ผิด ช้าเกินไปไม่ใช่มาตรฐานของ Cisco', 4);
INSERT INTO public.choices VALUES ('47239a32-9270-457f-b6eb-121ed30b13a7', '0248a868-1d00-463b-8b08-6f3f8cf82efb', 'C = Directly Connected (ต่อตรง) และ S* = Static Default Route (เส้นทางหลักออกข้างนอก)', true, 'ถูกต้อง C คือ Connected และ S* คือ Default Static Route 0.0.0.0/0', 1);
INSERT INTO public.choices VALUES ('178637ce-0145-4519-89bd-c776ffd4e231', '0248a868-1d00-463b-8b08-6f3f8cf82efb', 'C = Cisco Proprietary และ S* = Standard Route', false, 'ผิด ไม่ใช่ความหมายของสัญลักษณ์ C และ S', 2);
INSERT INTO public.choices VALUES ('bbe8aa57-96e2-4422-813e-6b311c51b7ef', '0248a868-1d00-463b-8b08-6f3f8cf82efb', 'C = Core Network และ S* = Subnet Mask', false, 'ผิด ไม่ถูกต้อง', 3);
INSERT INTO public.choices VALUES ('7c128821-b1cd-4fd6-b718-5ec6da1c2fc9', '0248a868-1d00-463b-8b08-6f3f8cf82efb', 'C = Collision Detected และ S* = Spanning-tree Route', false, 'ผิด C ใน Routing table หมายถึง Connected', 4);
INSERT INTO public.choices VALUES ('96da29e7-5e61-4109-8765-d4dd331b3b3a', '29a4fa57-6dd7-4b04-9a94-3f64ef1ea7ab', 'เกิด Late Collisions จำนวนมาก และมี Packet Loss สูงมากเมื่อมีการรับส่งข้อมูลปริมาณมาก', true, 'ถูกต้อง นี่คืออาการจำเพาะของ Duplex Mismatch', 1);
INSERT INTO public.choices VALUES ('7cd4a43c-99b2-4bd2-bf3f-c2fd5541f748', '29a4fa57-6dd7-4b04-9a94-3f64ef1ea7ab', 'พอร์ตจะดับ (down/down) สนิททันทีตั้งแต่เริ่มเสียบสาย', false, 'ผิด พอร์ตจะยังขึ้น up/up และใช้งานได้ช้าๆ', 2);
INSERT INTO public.choices VALUES ('f6ffaee9-cc15-4508-a10e-81b38edec4fb', '29a4fa57-6dd7-4b04-9a94-3f64ef1ea7ab', 'เครื่องลูกข่ายจะได้รับไอพีเป็น 169.254.x.x เสมอ', false, 'ผิด ไม่เกี่ยวกับ APIPA', 3);
INSERT INTO public.choices VALUES ('d7d6402a-6044-480d-a2be-26fd3444ce14', '29a4fa57-6dd7-4b04-9a94-3f64ef1ea7ab', 'สวิตช์จะปิดระบบดับเพลิงในห้องเซิร์ฟเวอร์', false, 'ผิด ไม่เกี่ยวข้องกัน', 4);
INSERT INTO public.choices VALUES ('2203d007-a3c5-484a-b485-96a139031876', '48a688b6-b7e4-4d4f-8164-32df8b03b281', 'เกิด Loop ทางกายภาพใน Switch และ Ethernet Frame ไม่มีฟิลด์ TTL จึงวนเวียนไม่สิ้นสุด', true, 'ถูกต้อง เพราะ Layer 2 ไม่มี TTL มาคอยตัดรอบเหมือน Layer 3 IP Packet', 1);
INSERT INTO public.choices VALUES ('121c217a-812d-4818-9ef5-50ee40d2d045', '48a688b6-b7e4-4d4f-8164-32df8b03b281', 'เกิดจากมีคนตั้งค่า Default Gateway ซ้ำกันเกิน 2 เครื่อง', false, 'ผิด Gateway ชนกันไม่ทำให้เกิด Broadcast Storm ระดับสวิตช์ล่ม', 2);
INSERT INTO public.choices VALUES ('d5572638-00f3-448c-b7dc-2a8683eda87a', '48a688b6-b7e4-4d4f-8164-32df8b03b281', 'เกิดจากสายไฟเบอร์ถูกดัดงอเกินรัศมี Bend Radius', false, 'ผิด สัญญาณแสงดรอปไม่ทำให้เกิด Storm', 3);
INSERT INTO public.choices VALUES ('370eff7f-7bec-4a60-9069-c183bba7382c', '48a688b6-b7e4-4d4f-8164-32df8b03b281', 'เกิดจากระบบ DNS มีการตั้งค่า TTL เป็น 0', false, 'ผิด DNS TTL คือการแคชชื่อโดเมน ไม่เกี่ยวกับ Ethernet Frame loop', 4);
INSERT INTO public.choices VALUES ('1f1d4edf-b148-4234-bcfa-59e77cb6914d', '6742174c-264e-4fba-a6da-56b09a01ac39', 'STP (Spanning Tree Protocol)', true, 'ถูกต้อง STP คือโปรโตคอลหลักในการป้องกัน Switching Loop', 1);
INSERT INTO public.choices VALUES ('bc889589-68be-494f-a431-fe78f6bccaaf', '6742174c-264e-4fba-a6da-56b09a01ac39', 'BGP (Border Gateway Protocol)', false, 'ผิด BGP คือโปรโตคอล Routing บนอินเทอร์เน็ต', 2);
INSERT INTO public.choices VALUES ('74389850-88ce-480b-8660-01c0ca776824', '6742174c-264e-4fba-a6da-56b09a01ac39', 'SNMP (Simple Network Management Protocol)', false, 'ผิด SNMP ใช้สำหรับ Monitoring ตรวจสอบอุปกรณ์', 3);
INSERT INTO public.choices VALUES ('c1b825af-5a9d-44c8-94fe-ef1880247b35', '6742174c-264e-4fba-a6da-56b09a01ac39', 'OSPF (Open Shortest Path First)', false, 'ผิด OSPF คือโปรโตคอล Dynamic Routing ใน Layer 3', 4);
INSERT INTO public.choices VALUES ('a655a0e2-023b-4b46-b934-09ade4a49f97', '1e185f85-4700-463f-a971-4c02526fc962', 'หากมีเฟรม BPDU ส่งเข้ามาที่พอร์ตนั้น สวิตช์จะสั่งปิดพอร์ตทันที (err-disabled) เพื่อป้องกันการต่อสวิตช์เถื่อนมาทำ Loop', true, 'ถูกต้อง BPDU Guard ปกป้องพอร์ต edge ไม่ให้มีอุปกรณ์สวิตช์อื่นมาเชื่อมต่อ', 1);
INSERT INTO public.choices VALUES ('0657cd6c-cadb-4724-a2ce-227bea911c10', '1e185f85-4700-463f-a971-4c02526fc962', 'ช่วยเพิ่มความเร็วในการดาวน์โหลดไฟล์ของพอร์ตนั้นเป็น 2 เท่า', false, 'ผิด ไม่ได้เพิ่มความเร็ว', 2);
INSERT INTO public.choices VALUES ('fff58c29-6597-4f0f-9684-6a9607eb911d', '1e185f85-4700-463f-a971-4c02526fc962', 'ทำการสำรองข้อมูลการคอนฟิกเก็บไว้ใน Flash memory อัตโนมัติ', false, 'ผิด ไม่เกี่ยวกับแบ็กอัปคอนฟิก', 3);
INSERT INTO public.choices VALUES ('2a8328bd-316a-486a-8148-247d8e691a84', '1e185f85-4700-463f-a971-4c02526fc962', 'อนุญาตให้พอร์ตนั้นรองรับเฉพาะการต่อสายไฟเบอร์ออปติกเท่านั้น', false, 'ผิด ใช้ได้ทั้งสายทองแดงและสายไฟเบอร์', 4);
INSERT INTO public.choices VALUES ('fbdbe20c-b181-4877-9492-4e8476207fc6', '34d76a3b-7fb2-4a41-b949-84b1bbd4537d', 'LACP (Link Aggregation Control Protocol - IEEE 802.3ad)', true, 'ถูกต้อง LACP คือมาตรฐานเปิดที่รองรับการรวมสายข้ามยี่ห้อ', 1);
INSERT INTO public.choices VALUES ('1df75c95-04b7-4649-9ed2-f3b704ff5d19', '34d76a3b-7fb2-4a41-b949-84b1bbd4537d', 'VTP (VLAN Trunking Protocol)', false, 'ผิด VTP ใช้ซิงค์ฐานข้อมูล VLAN', 2);
INSERT INTO public.choices VALUES ('ef1c8425-0043-4e97-b579-15ca7dfcb855', '34d76a3b-7fb2-4a41-b949-84b1bbd4537d', 'CDP (Cisco Discovery Protocol)', false, 'ผิด CDP ใช้ค้นหาอุปกรณ์ข้างเคียง', 3);
INSERT INTO public.choices VALUES ('b472d490-70fe-42f3-81d8-eb6f13e1504b', '34d76a3b-7fb2-4a41-b949-84b1bbd4537d', 'HSRP (Hot Standby Router Protocol)', false, 'ผิด HSRP คือการสำรอง Default Gateway ของ Router', 4);
INSERT INTO public.choices VALUES ('f8e44536-99c9-49c5-b7d5-599c6a756ad2', 'eed83e79-382d-4cd4-b70c-a794fdc8d5be', 'เพื่อป้องกันไม่ให้ tcpdump พยายามแปลง IP เป็น Hostname และแปลง Port เป็นชื่อบริการ ซึ่งทำให้ผลลัพธ์แสดงได้รวดเร็วและไม่รบกวน DNS', true, 'ถูกต้อง -n ปิดการ Resolve IP, -nn ปิดการ Resolve ทั้ง IP และ Port', 1);
INSERT INTO public.choices VALUES ('46ca8078-e17e-41ed-8467-125b3ca38c70', 'eed83e79-382d-4cd4-b70c-a794fdc8d5be', 'เพื่อเปิดการเข้ารหัสข้อมูลที่ดักจับได้ด้วยมาตรฐาน AES-256', false, 'ผิด tcpdump ไม่ได้เข้ารหัสไฟล์ด้วยแฟล็กนี้', 2);
INSERT INTO public.choices VALUES ('4ab9e12e-661e-495a-9309-f65a44ba340c', 'eed83e79-382d-4cd4-b70c-a794fdc8d5be', 'เพื่อจำกัดให้ดักจับเฉพาะแพ็กเก็ตที่เป็นไวรัสเท่านั้น', false, 'ผิด tcpdump ดักจับแพ็กเก็ตตามฟิลเตอร์ ไม่ใช่โปรแกรมแอนตี้ไวรัส', 3);
INSERT INTO public.choices VALUES ('404d01ae-8888-43cb-ae56-0739e5743f74', 'eed83e79-382d-4cd4-b70c-a794fdc8d5be', 'เพื่อสั่งให้ระบบจำลองการส่งข้อมูลเสมือนโดยไม่ต้องแตะการ์ดแลนจริง', false, 'ผิด tcpdump ดักฟังจากการ์ดแลนจริง', 4);
INSERT INTO public.choices VALUES ('2e88d2f8-044d-4dfb-ad21-58f3d50d6a9d', '4179d86f-e2c7-4331-a1f3-c90aae750b83', 'แพ็กเก็ตถูกบล็อกหรือถูกทิ้ง (DROP) โดย Firewall หรือเครื่องปลายทางปิดเครื่องอยู่', true, 'ถูกต้อง หากโดน DROP จะไม่มีการตอบกลับใดๆ ทำให้เครื่องต้นทางส่ง SYN ซ้ำจนกระทั่ง Connection timed out', 1);
INSERT INTO public.choices VALUES ('15b7a30d-ee15-4fcd-9216-f6ca33504913', '4179d86f-e2c7-4331-a1f3-c90aae750b83', 'การเชื่อมต่อสำเร็จสมบูรณ์และกำลังดาวน์โหลดไฟล์', false, 'ผิด ถ้าสำเร็จต้องมี [S.] และ [.] ตอบกลับมา', 2);
INSERT INTO public.choices VALUES ('53a8333c-2d66-4e45-9ec3-e6348e443ce9', '4179d86f-e2c7-4331-a1f3-c90aae750b83', 'เครื่องปลายทางตอบปฏิเสธการเชื่อมต่อด้วย Connection Refused', false, 'ผิด หากปฏิเสธ ปลายทางจะส่ง Flags [R] (RST) สวนกลับมา ไม่ใช่เงียบหาย', 3);
INSERT INTO public.choices VALUES ('889db75d-61e2-4f24-a824-27bf29416d22', '4179d86f-e2c7-4331-a1f3-c90aae750b83', 'สายแลนของเครื่องต้นทางหลุดออกจากเครื่องตนเอง', false, 'ผิด หากสายหลุดตั้งแต่เครื่องตัวเอง tcpdump จะไม่เห็นแพ็กเก็ตส่งออกไปได้', 4);
INSERT INTO public.choices VALUES ('05928e3a-a3ba-4cad-965a-b1831d7638e4', 'd3078369-34bc-435c-a843-0aa4c32c9797', 'เครือข่ายส่งข้อมูลถึงปลายทางได้ปกติ แต่ไม่มี Service หรือ Application เปิดรันรองรับอยู่ที่พอร์ตนั้น (Connection Refused)', true, 'ถูกต้อง RST เป็นสัญญาณว่าเครื่องปลายทางยังมีชีวิตอยู่แต่ไม่มีโปรแกรมเปิดฟังพอร์ตนั้น', 1);
INSERT INTO public.choices VALUES ('cb745f59-65c4-4230-8aa9-ae841948e8af', 'd3078369-34bc-435c-a843-0aa4c32c9797', 'สายแลนระหว่างทางขาดใน', false, 'ผิด หากสายขาดจะไม่มีแพ็กเก็ต RST ส่งสวนกลับมาหาเราได้', 2);
INSERT INTO public.choices VALUES ('3c4a814c-3e43-4bfe-bfe1-2224f381a064', 'd3078369-34bc-435c-a843-0aa4c32c9797', 'Firewall กำลังทำการทิ้งข้อมูลทั้งหมด', false, 'ผิด Firewall drop มักทำให้แพ็กเก็ตเงียบหายไป (Timed out)', 3);
INSERT INTO public.choices VALUES ('f4340d1a-9bef-44dc-a6d5-2feb30c5d3ad', 'd3078369-34bc-435c-a843-0aa4c32c9797', 'ฮาร์ดดิสก์ของเครื่องต้นทางเสีย', false, 'ผิด ไม่เกี่ยวกับฮาร์ดดิสก์', 4);
INSERT INTO public.choices VALUES ('f1c3b99f-6d83-4859-8c4f-a3b258658b37', 'caf4b43f-815a-4731-afe7-e459846dc1fe', 'sudo tcpdump -nn -i eth0 port 443 -c 50 -w /tmp/ssl_test.pcap', true, 'ถูกต้อง มีครบทั้ง -nn, -i eth0, port 443, -c 50 และ -w ชี้ชื่อไฟล์', 1);
INSERT INTO public.choices VALUES ('169ec223-96e3-40d0-a6d9-e046a10dce9e', 'caf4b43f-815a-4731-afe7-e459846dc1fe', 'sudo tcpdump -i eth0 --save /tmp/ssl_test.pcap 443', false, 'ผิด tcpdump ไม่มีแฟล็ก --save (ต้องใช้ -w)', 2);
INSERT INTO public.choices VALUES ('bd5d98ee-0dbb-40d1-a423-fbe29df1e6fa', 'caf4b43f-815a-4731-afe7-e459846dc1fe', 'sudo tcpdump --port=443 --count=50 > /tmp/ssl_test.pcap', false, 'ผิด ไวยากรณ์ไม่ถูกต้องและใช้ redirection ธรรมดาจะทำให้ไฟล์ pcap เสียหาย', 3);
INSERT INTO public.choices VALUES ('dc62c9d8-c2bc-4233-85cb-3df7fda27f9c', 'caf4b43f-815a-4731-afe7-e459846dc1fe', 'sudo tcpdump -r /tmp/ssl_test.pcap port 443', false, 'ผิด แฟล็ก -r ใช้สำหรับอ่านไฟล์ย้อนหลัง ไม่ใช่บันทึกไฟล์ใหม่', 4);
INSERT INTO public.choices VALUES ('0d70c6da-293e-4b09-be5d-166fb3bf814a', '70b5a05d-a58c-4b52-8750-07b0d905cae1', 'คลิกขวาที่แพ็กเก็ตแล้วเลือก Follow -> TCP Stream', true, 'ถูกต้อง Follow TCP Stream ใช้ประกอบข้อมูลทั้งเซสชันออกมาเป็นข้อความอ่านต่อเนื่อง', 1);
INSERT INTO public.choices VALUES ('29de3bdf-3bc9-490c-9b48-1be6d23cdb7b', '70b5a05d-a58c-4b52-8750-07b0d905cae1', 'เลือกเมนู File -> Export Objects -> JSON', false, 'ผิด ไม่ใช่การอ่านสตรีมข้อมูล TCP', 2);
INSERT INTO public.choices VALUES ('dd599aa7-a6cb-435e-8ec1-3ab05728710d', '70b5a05d-a58c-4b52-8750-07b0d905cae1', 'คลิกเลือก Apply as Filter -> Selected MAC', false, 'ผิด เป็นเพียงการกรอง MAC Address', 3);
INSERT INTO public.choices VALUES ('60eeab6e-dd15-47c9-b732-e48f38df3ba5', '70b5a05d-a58c-4b52-8750-07b0d905cae1', 'กดปุ่ม Restart Capture ทันที', false, 'ผิด จะเป็นการเริ่มดักจับใหม่และล้างข้อมูลเก่า', 4);
INSERT INTO public.choices VALUES ('6ac24d33-8d64-4af8-9828-05a8ee913627', 'a98c2c8e-00de-4244-837b-4ba6540ceb62', 'RAID 6 ได้ 8 TB และ RAID 10 ได้ 6 TB', true, 'ถูกต้อง RAID 6 = (N-2)*Size = 8TB, RAID 10 = (N/2)*Size = 6TB', 1);
INSERT INTO public.choices VALUES ('ea150cf5-d5de-4f40-b0dc-5a44a5fc060f', 'a98c2c8e-00de-4244-837b-4ba6540ceb62', 'RAID 6 ได้ 10 TB และ RAID 10 ได้ 8 TB', false, 'ผิด 10 TB คือความจุของ RAID 5 (N-1)', 2);
INSERT INTO public.choices VALUES ('ac93ef2f-9cf2-4405-a876-b39fb99c32c7', 'a98c2c8e-00de-4244-837b-4ba6540ceb62', 'RAID 6 ได้ 6 TB และ RAID 10 ได้ 12 TB', false, 'ผิด RAID 10 ใช้พื้นที่ครึ่งหนึ่งทำ Mirror จึงเหลือ 6 TB ไม่ใช่ 12 TB', 3);
INSERT INTO public.choices VALUES ('390b5043-6d36-4e20-9b39-244fef064f8b', '8b74d788-98ec-4a05-8a4b-d7301a0ec4b2', 'สายไฟเข้าพาวเวอร์ซัพพลายหลวม', false, 'ผิด ไม่เกี่ยวกับสายไฟ PSU', 3);
INSERT INTO public.choices VALUES ('f7f5fe45-7301-42cf-ba10-1e5087155267', 'a98c2c8e-00de-4244-837b-4ba6540ceb62', 'ได้ 12 TB เท่ากันทั้งสองแบบ', false, 'ผิด เฉพาะ RAID 0 เท่านั้นที่ได้ความจุเต็ม 12 TB', 4);
INSERT INTO public.choices VALUES ('bf18bc26-630e-4045-9123-dfeadf04e988', 'a49c6a82-b2f6-4f5a-bcf4-870770ee3d9b', 'โวลุ่ม RAID 5 จะล่มทันที (Volume Failed) เนื่องจากเสียดิสก์เกินจำนวนที่ทนได้ (เกิน 1 ลูก)', true, 'ถูกต้อง RAID 5 ทนเสียได้แค่ 1 ลูก การดึงลูกดีออกเท่ากับเสีย 2 ลูกพร้อมกัน', 1);
INSERT INTO public.choices VALUES ('b8fa0444-f86e-4ec9-8adf-3558a01da4ff', 'a49c6a82-b2f6-4f5a-bcf4-870770ee3d9b', 'ระบบจะสลับไปใช้ CPU จำลองข้อมูลแทนโดยไม่มีผลกระทบใดๆ', false, 'ผิด ไม่สามารถจำลองข้อมูลได้หากขาดดิสก์เกินจำนวน Parity', 2);
INSERT INTO public.choices VALUES ('fd43ec60-0d23-4586-bbed-1df8a5c503c0', 'a49c6a82-b2f6-4f5a-bcf4-870770ee3d9b', 'ระบบจะแปลงตัวเองเป็น RAID 0 โดยอัตโนมัติ', false, 'ผิด RAID 5 ไม่สามารถแปลงเป็น RAID 0 เองเมื่อดิสก์หลุด', 3);
INSERT INTO public.choices VALUES ('1fb9f99c-fbce-43b9-8b8a-7cbbafdb3e27', 'a49c6a82-b2f6-4f5a-bcf4-870770ee3d9b', 'ไม่มีผลกระทบใดๆ เพราะ RAID 5 ทนดิสก์เสียได้ถึง 3 ลูก', false, 'ผิด RAID 5 ทนดิสก์เสียได้เพียง 1 ลูกเท่านั้น', 4);
INSERT INTO public.choices VALUES ('57e57d12-95da-40c4-84de-5b0e8220d34d', 'af06e4f6-6e32-44a7-af4b-e131ce5c199f', 'เป็นไฟชี้ตำแหน่ง (Locator / Identify LED) ที่สั่งเปิดจากระบบจัดการระยะไกลเพื่อระบุตัวดิสก์ที่ถูกต้อง', true, 'ถูกต้อง ไฟสีน้ำเงินใช้สำหรับชี้เป้า (Locate) เพื่อป้องกันการดึงผิดช่อง', 1);
INSERT INTO public.choices VALUES ('caf28f8d-9e32-406d-8cb4-503ef0db9f55', 'af06e4f6-6e32-44a7-af4b-e131ce5c199f', 'แสดงว่าดิสก์ลูกนั้นมีอุณหภูมิเย็นจัดเกินไป', false, 'ผิด ไม่เกี่ยวกับอุณหภูมิ', 2);
INSERT INTO public.choices VALUES ('2cef72b5-5675-4057-861f-3a6d62114fa8', 'af06e4f6-6e32-44a7-af4b-e131ce5c199f', 'แสดงว่าดิสก์ลูกนั้นเชื่อมต่อผ่าน Bluetooth', false, 'ผิด เซิร์ฟเวอร์ไม่ใช้ Bluetooth กับฮาร์ดดิสก์', 3);
INSERT INTO public.choices VALUES ('6fa23714-158f-4d84-b728-154b7cbb82a1', 'af06e4f6-6e32-44a7-af4b-e131ce5c199f', 'แสดงว่าดิสก์ลูกนั้นเป็นดิสก์ปลอมที่ไม่ผ่านมาตรฐาน', false, 'ผิด ไฟเตือนดิสก์มีปัญหามักเป็นสีส้ม/อำพัน (Amber)', 4);
INSERT INTO public.choices VALUES ('3b9eba5f-5997-4015-b962-1ed4b7d5cf00', '9f4e6bb4-4c0d-4f17-b5f9-a5d1eb4768ec', 'เพื่อให้ระบบปฏิบัติการมองเห็นและควบคุมดิสก์แต่ละลูกได้โดยตรงโดยไม่ผ่านการรวมโวลุ่มของการ์ด RAID', true, 'ถูกต้อง HBA/Passthrough ส่งดิสก์แต่ละลูกให้ OS จัดการโดยตรง', 1);
INSERT INTO public.choices VALUES ('040061b1-ca23-4a17-a76f-dc0e5bfc4afe', '9f4e6bb4-4c0d-4f17-b5f9-a5d1eb4768ec', 'เพื่อปิดการทำงานของพัดลมระบายความร้อนในเครื่อง', false, 'ผิด ไม่เกี่ยวกับพัดลม', 2);
INSERT INTO public.choices VALUES ('10dc3631-c705-4030-a63d-4a98811e501b', '9f4e6bb4-4c0d-4f17-b5f9-a5d1eb4768ec', 'เพื่อบังคับให้ดิสก์ทำงานที่ความเร็วครึ่งเดียว', false, 'ผิด HBA ให้ความเร็วเต็มประสิทธิภาพของดิสก์', 3);
INSERT INTO public.choices VALUES ('634cfb8c-1f2b-42f5-83f8-b71287d74c23', '9f4e6bb4-4c0d-4f17-b5f9-a5d1eb4768ec', 'เพื่อให้สามารถถอดสายไฟ PSU ออกได้', false, 'ผิด ไม่เกี่ยวกับระบบไฟ', 4);
INSERT INTO public.choices VALUES ('fbb9e93a-6d48-4202-8fd7-eb887ff436f6', 'd6d47579-3742-448d-ab63-850146c740bd', 'ดิสก์เริ่มมี Bad Sector และกำลังเสื่อมสภาพ (Predictive Failure) ควรวางแผนเปลี่ยนดิสก์ลูกนั้นก่อนที่จะพังสนิท', true, 'ถูกต้อง Reallocated และ Pending Sector คือสัญญาณเตือนว่าดิสก์เริ่มเสียทางกายภาพ', 1);
INSERT INTO public.choices VALUES ('80b4bcf8-bae4-47dd-9a9f-dd9f43a7785d', 'd6d47579-3742-448d-ab63-850146c740bd', 'ดิสก์เพิ่งได้รับการจัดเรียงข้อมูล (Defragment) เสร็จสมบูรณ์', false, 'ผิด ไม่ใช่การ Defragment', 2);
INSERT INTO public.choices VALUES ('40be60e9-eede-497f-bea6-719541042080', 'd6d47579-3742-448d-ab63-850146c740bd', 'พาร์ทิชันมีไฟล์ถูกบีบอัดเป็น .gz มากเกินไป', false, 'ผิด SMART ตรวจระดับฮาร์ดแวร์ ไม่ขึ้นกับนามสกุลไฟล์', 3);
INSERT INTO public.choices VALUES ('b056a2ee-d841-4d75-be8e-8e2a7a887474', 'd6d47579-3742-448d-ab63-850146c740bd', 'สายแลนของเซิร์ฟเวอร์เกิดอาการหลวม', false, 'ผิด smartctl เป็นการตรวจดิสก์ ไม่เกี่ยวกับสายแลน', 4);
INSERT INTO public.choices VALUES ('3ca7e05c-ba80-4916-abc0-f78523b17879', '4cd3080a-83c4-4ea4-99f0-b166c7c3d551', 'CE สามารถซ่อมแซมบิตที่เพี้ยนได้อัตโนมัติโดยเครื่องยังทำงานต่อได้ ส่วน UCE ซ่อมไม่ได้และทำให้เครื่องแฮงก์หรือรีบูตทันที', true, 'ถูกต้อง CE = Single-bit ซ่อมได้, UCE = Multi-bit เครื่องดับ/แฮงก์ทันที', 1);
INSERT INTO public.choices VALUES ('c22c2a42-8832-4d1f-9ca0-dc332ada5633', '4cd3080a-83c4-4ea4-99f0-b166c7c3d551', 'CE ทำให้ฮาร์ดดิสก์พัง ส่วน UCE ทำให้การ์ดจอพัง', false, 'ผิด ทั้งคู่เป็นข้อผิดพลาดของหน่วยความจำ RAM', 2);
INSERT INTO public.choices VALUES ('7d714092-00d0-45b1-a767-6c633a11ee4b', '4cd3080a-83c4-4ea4-99f0-b166c7c3d551', 'CE เกิดเฉพาะวันหยุด ส่วน UCE เกิดเฉพาะวันทำงาน', false, 'ผิด ไม่เกี่ยวข้องกับวันเวลา', 3);
INSERT INTO public.choices VALUES ('a81832b8-f50c-4d69-8c50-9b6cf1ac36fc', '4cd3080a-83c4-4ea4-99f0-b166c7c3d551', 'UCE สามารถซ่อมได้ด้วยการล้างแคชเบราว์เซอร์', false, 'ผิด UCE เป็นปัญหาฮาร์ดแวร์ระดับกายภาพของชิปแรม', 4);
INSERT INTO public.choices VALUES ('f23ae1f5-47b5-458f-9c24-9c3294ded113', '8b74d788-98ec-4a05-8a4b-d7301a0ec4b2', 'ตัวแผงหน่วยความจำ (RAM Module) แถวนั้นชำรุด ต้องส่งเคลมเฉพาะตัวแรม', true, 'ถูกต้อง อาการเสียย้ายตามชิ้นส่วนไป แสดงว่าตัวชิ้นส่วนนั้นเสีย', 1);
INSERT INTO public.choices VALUES ('3f86e77b-63fc-4094-b04d-dab29e7b6c82', '8b74d788-98ec-4a05-8a4b-d7301a0ec4b2', 'ช่องเสียบบนเมนบอร์ด (DIMM Slot A1) ชำรุด ต้องเปลี่ยนเมนบอร์ด', false, 'ผิด ถ้าเมนบอร์ดเสีย อาการจะต้องฟ้องที่ช่อง A1 เหมือนเดิมแม้จะเปลี่ยนแรมแล้ว', 2);
INSERT INTO public.choices VALUES ('ed3e8c60-9d28-4109-b5fb-e0e6826b0150', '8b74d788-98ec-4a05-8a4b-d7301a0ec4b2', 'พัดลมระบายความร้อนหมุนกลับด้าน', false, 'ผิด ไม่เกี่ยวกับพัดลม', 4);
INSERT INTO public.choices VALUES ('de9f90ea-c16f-4f76-b7a1-67a8d077098b', '290bd7fb-a136-4e0a-8251-0315c238a1a1', 'System Event Log (SEL) ในระบบ iDRAC/iLO หรือใช้คำสั่ง ipmitool sel elist', true, 'ถูกต้อง ชิป BMC ทำงานแยกจาก OS จึงบันทึกเหตุการณ์ไฟดับ/ความร้อน/RAM พัง ลงใน SEL ได้เสมอ', 1);
INSERT INTO public.choices VALUES ('047126db-5fe6-4954-95c2-e98c399c66ab', '290bd7fb-a136-4e0a-8251-0315c238a1a1', 'ประวัติการเข้าชมเว็บไซต์ในโปรแกรม Chrome', false, 'ผิด ไม่เกี่ยวข้องกับเซิร์ฟเวอร์', 2);
INSERT INTO public.choices VALUES ('dc9657b5-6f70-49cb-b857-6da9c91b479b', '290bd7fb-a136-4e0a-8251-0315c238a1a1', 'ไฟล์ /tmp ที่ถูกล้างตอนรีบูต', false, 'ผิด /tmp มักถูกล้างเมื่อเครื่องรีบูต', 3);
INSERT INTO public.choices VALUES ('7f341e14-e4d2-44ab-b1e8-887bbb5eca29', '290bd7fb-a136-4e0a-8251-0315c238a1a1', 'ตาราง ARP Cache ของสวิตช์', false, 'ผิด ARP Cache ไม่ได้บันทึกสาเหตุฮาร์ดแวร์เซิร์ฟเวอร์ดับ', 4);
INSERT INTO public.choices VALUES ('bd4eb23c-e56b-4b8d-ad75-fbc1be69d120', '6ce08b38-2b09-43bb-b2e4-18a321887e7e', 'sudo ipmitool sdr list', true, 'ถูกต้อง SDR ย่อมาจาก Sensor Data Repository ใช้แสดงค่าเซนเซอร์ทั้งหมด', 1);
INSERT INTO public.choices VALUES ('c9254c0e-5638-4ea4-aa1a-3dd6bcb07d71', '6ce08b38-2b09-43bb-b2e4-18a321887e7e', 'sudo ipmitool chassis power off', false, 'ผิด คำสั่งนี้เป็นการสั่งตัดไฟปิดเครื่องเซิร์ฟเวอร์!', 2);
INSERT INTO public.choices VALUES ('252bb0f0-fbe5-4448-8121-b5757209065d', '6ce08b38-2b09-43bb-b2e4-18a321887e7e', 'sudo ipmitool sel clear', false, 'ผิด คำสั่งนี้ใช้ล้างประวัติ Event Log', 3);
INSERT INTO public.choices VALUES ('6f7e0807-c089-47ab-8ffb-85486f5361e8', '6ce08b38-2b09-43bb-b2e4-18a321887e7e', 'sudo ipmitool user list', false, 'ผิด คำสั่งนี้ใช้ดูรายชื่อผู้ใช้ในระบบ BMC', 4);
INSERT INTO public.choices VALUES ('152eb04d-c7f6-4a18-aa7b-5010b65b66e3', 'cb7dbfcd-a8ce-4e92-a1bb-34ba1207ff7c', 'เร่งความเร็วรอบพัดลมตัวที่เหลือทั้งหมดให้หมุนสูงสุด (100%) เพื่อชดเชยแรงลม และขึ้นไฟเตือนสีส้ม', true, 'ถูกต้อง เป็นกลไก Fail-safe มาตรฐานของเซิร์ฟเวอร์ทุกยี่ห้อ', 1);
INSERT INTO public.choices VALUES ('1390c29f-151b-45a9-ab35-a3135d958135', 'cb7dbfcd-a8ce-4e92-a1bb-34ba1207ff7c', 'สั่งหยุดพัดลมทุกตัวที่เหลือเพื่อให้เงียบลง', false, 'ผิด หากหยุดพัดลมเครื่องจะร้อนจัดจนดับทันที', 2);
INSERT INTO public.choices VALUES ('3eac5635-056c-41de-a5d2-9af57568165f', 'cb7dbfcd-a8ce-4e92-a1bb-34ba1207ff7c', 'สั่งฟอร์แมตฮาร์ดดิสก์ทั้งหมดโดยอัตโนมัติ', false, 'ผิด ไม่เกี่ยวข้องกัน', 3);
INSERT INTO public.choices VALUES ('012e4411-8147-4638-af6e-34cd0c5a096a', 'cb7dbfcd-a8ce-4e92-a1bb-34ba1207ff7c', 'เปลี่ยน IP Address ของเครื่องเป็นค่าเริ่มต้น', false, 'ผิด พัดลมเสียไม่ทำให้ IP เปลี่ยน', 4);
INSERT INTO public.choices VALUES ('aecf8a7c-32c3-4a64-8e12-cb73d08d22bc', '608b4ca0-6f74-4428-9dcc-a4d91e2e7fd6', 'Virtual Media (ภายในหน้าต่าง Virtual Console)', true, 'ถูกต้อง Virtual Media ใช้จำลองไฟล์ ISO ให้เป็นไดรฟ์บูตเสมือนระยะไกล', 1);
INSERT INTO public.choices VALUES ('a74b02e1-ba39-4ce4-92af-c8edbb0fb82f', '608b4ca0-6f74-4428-9dcc-a4d91e2e7fd6', 'SNMP Trap Receiver', false, 'ผิด SNMP ใช้ส่งการแจ้งเตือน ไม่ใช่การจำลองไดรฟ์', 2);
INSERT INTO public.choices VALUES ('43e1c591-3293-456f-a151-578f3d67a800', '608b4ca0-6f74-4428-9dcc-a4d91e2e7fd6', 'Serial over LAN (SOL) แบบข้อความล้วน', false, 'ผิด SOL ส่งเฉพาะข้อความคอนโซล ไม่ได้แนบไฟล์อิมเมจ ISO', 3);
INSERT INTO public.choices VALUES ('c14b90b7-9d8e-4944-a217-0145984fca57', '608b4ca0-6f74-4428-9dcc-a4d91e2e7fd6', 'VLAN Tagging', false, 'ผิด เป็นเรื่องของการแบ่งเครือข่ายบนสวิตช์', 4);
INSERT INTO public.choices VALUES ('ecf23490-21d6-447c-bbb4-ee74e49674bd', '3ead4a3b-6128-4695-a9f2-cbc18355084f', 'BMC Firmware (เช่น iDRAC หรือ iLO)', true, 'ถูกต้อง ชิป BMC ทำงานแยกอิสระจาก CPU หลัก จึงรีบูตเฉพาะตัว BMC ได้โดย OS ไม่ดับ', 1);
INSERT INTO public.choices VALUES ('55055591-d410-429d-9c52-fa196d1b088e', '3ead4a3b-6128-4695-a9f2-cbc18355084f', 'System BIOS / UEFI', false, 'ผิด การใช้ค่า BIOS ใหม่จำเป็นต้องรีบูตเครื่องเซิร์ฟเวอร์จริงเสมอ', 2);
INSERT INTO public.choices VALUES ('627f8a9a-ca78-4f60-ae5f-4cc7afd10228', '3ead4a3b-6128-4695-a9f2-cbc18355084f', 'RAID Controller Firmware ขณะกำลังเขียนดิสก์หนักๆ', false, 'ผิด การอัปเดต RAID Controller มักต้องรีบูตหรือหยุด I/O เพื่อความปลอดภัย', 3);
INSERT INTO public.choices VALUES ('5d5792da-737c-4177-a409-961cd6f951a7', '3ead4a3b-6128-4695-a9f2-cbc18355084f', 'การเปลี่ยนโหมด CPU Virtualization ใน BIOS', false, 'ผิด ต้องรีบูตเครื่องจึงจะมีผล', 4);
INSERT INTO public.choices VALUES ('3b8f2813-2198-4d3f-837a-f4836b156d62', '855868fc-446e-4fb2-b42c-99a6ff11a6e3', 'Kickstart file (ks.cfg)', true, 'ถูกต้อง Kickstart คือระบบ Answer File มาตรฐานของตระกูล Red Hat/Rocky Linux', 1);
INSERT INTO public.choices VALUES ('6965def2-f305-4edf-a0ac-dad55d85af18', '855868fc-446e-4fb2-b42c-99a6ff11a6e3', 'Unattend.xml', false, 'ผิด Unattend.xml เป็นของฝั่ง Windows Server', 2);
INSERT INTO public.choices VALUES ('42fe9769-755d-45a9-b214-35d701dccbe2', '855868fc-446e-4fb2-b42c-99a6ff11a6e3', 'package.json', false, 'ผิด package.json เป็นไฟล์ของโปรเจกต์ Node.js', 3);
INSERT INTO public.choices VALUES ('1c00f134-edac-40b1-8d3d-ff6137f29c8c', '855868fc-446e-4fb2-b42c-99a6ff11a6e3', 'robots.txt', false, 'ผิด robots.txt ใช้สำหรับ Search Engine บนเว็บไซต์', 4);
INSERT INTO public.choices VALUES ('c9f0bd57-c5a7-4ae6-8236-e9d97d0119e0', 'c9d0a4bf-c55e-4e83-a1dc-81e5d2b1eb32', 'สลับไปบูตจาก Backup BIOS ROM ผ่านหน้า iDRAC/iLO หรือปรับ Recovery Jumper / Switch บนเมนบอร์ด', true, 'ถูกต้อง เซิร์ฟเวอร์องค์กรมี Dual/Redundant BIOS ROM สำหรับกู้คืนโดยเฉพาะ', 1);
INSERT INTO public.choices VALUES ('ccee8129-6d8a-4823-b6eb-3b34db648fec', 'c9d0a4bf-c55e-4e83-a1dc-81e5d2b1eb32', 'เปลี่ยนสายแลนเป็นสายไฟเบอร์ออปติก', false, 'ผิด สายสัญญาณไม่เกี่ยวกับการกู้คืนชิป BIOS', 2);
INSERT INTO public.choices VALUES ('cacf7c38-21ab-4223-a628-64069e4c3c63', 'c9d0a4bf-c55e-4e83-a1dc-81e5d2b1eb32', 'ถอดฮาร์ดดิสก์ออกแล้วเขย่าเบาๆ', false, 'ผิด การเขย่าดิสก์ทำให้ดิสก์พังและไม่เกี่ยวกับ BIOS', 3);
INSERT INTO public.choices VALUES ('7311fd4a-96ae-42aa-aa38-60603c0938e2', 'c9d0a4bf-c55e-4e83-a1dc-81e5d2b1eb32', 'ไม่สามารถกู้คืนได้ทุกกรณี ต้องทุบทำลายเครื่องทิ้งเท่านั้น', false, 'ผิด สามารถกู้ผ่าน Backup ROM หรือเปลี่ยนเมนบอร์ดภายใต้ประกันได้', 4);
INSERT INTO public.choices VALUES ('f7f84af3-0fd4-4cc9-a90a-61dc1fd8c874', 'c05c4fb2-1c30-4982-93ae-6301b6464eec', 'Distribution List', false, 'ผิด Distribution List ใช้สำหรับส่งอีเมลกลุ่มเท่านั้น', 3);
INSERT INTO public.choices VALUES ('2665d60d-9e7d-480e-a06d-18f7c0329f80', '7d3b8788-3089-4c1e-bcee-d2937b6f029f', 'เพราะไฟล์ ISO มีขนาดใหญ่ การโหลดภายในวง LAN เดียวกันให้ความเร็วสูงและไม่เสี่ยงหลุดกลางคันหาก VPN ของช่างกระตุก', true, 'ถูกต้อง รวดเร็วและเสถียรกว่าการส่งผ่านเน็ตบ้านข้าม VPN มาก', 1);
INSERT INTO public.choices VALUES ('0bdb0f7c-676d-4767-adff-d3b24b526b71', '7d3b8788-3089-4c1e-bcee-d2937b6f029f', 'เพราะแล็ปท็อปทั่วไปไม่สามารถเก็บไฟล์นามสกุล .iso ได้', false, 'ผิด แล็ปท็อปเก็บไฟล์ .iso ได้ปกติ', 2);
INSERT INTO public.choices VALUES ('648e3db2-3ae7-4471-8fe0-5f31d88b6bd0', '7d3b8788-3089-4c1e-bcee-d2937b6f029f', 'เพราะ VPN จะเปลี่ยนไฟล์ Linux ให้กลายเป็น Windows', false, 'ผิด VPN ไม่ได้ดัดแปลงเนื้อหาไฟล์', 3);
INSERT INTO public.choices VALUES ('1b4cc757-652d-484e-ae8a-3f9062dfd4ba', '7d3b8788-3089-4c1e-bcee-d2937b6f029f', 'เพราะระบบ iDRAC อนุญาตให้ใช้ได้เฉพาะวันจันทร์เท่านั้น', false, 'ผิด iDRAC ใช้งานได้ตลอด 24 ชั่วโมงทุกวัน', 4);
INSERT INTO public.choices VALUES ('a9c53f1e-f7e2-4d08-93b1-3c7d436c1dfb', '35b7ef7c-568b-45f1-832d-aaa946957ac3', 'เพราะตีนตุ๊กแกไม่บีบรัดสายจนเกิดความเสียหายต่อแกนไฟเบอร์ และสามารถแกะออกเพื่อเพิ่มหรือซ่อมสายได้โดยไม่ต้องใช้คีมตัด', true, 'ถูกต้อง ป้องกัน Micro-bending และไม่ต้องเสี่ยงใช้ของมีคมตัดใกล้สายสัญญาณ', 1);
INSERT INTO public.choices VALUES ('38bbcb3c-fbbc-44dd-8362-14444baf4b9a', '35b7ef7c-568b-45f1-832d-aaa946957ac3', 'เพราะตีนตุ๊กแกช่วยเพิ่มความเร็วแสงในสายไฟเบอร์ให้เร็วขึ้น 2 เท่า', false, 'ผิด สายรัดไม่ได้เพิ่มความเร็วแสง', 2);
INSERT INTO public.choices VALUES ('925d3ea8-36db-48ee-852c-99a43d00e9bb', '35b7ef7c-568b-45f1-832d-aaa946957ac3', 'เพราะเคเบิลไทร์พลาสติกเป็นตัวนำไฟฟ้าแรงสูง', false, 'ผิด พลาสติกเป็นฉนวนไฟฟ้า แต่มีข้อเสียเรื่องแรงบีบรัด', 3);
INSERT INTO public.choices VALUES ('4b3d31af-b63a-4faa-ac94-b9b03e50547a', '35b7ef7c-568b-45f1-832d-aaa946957ac3', 'เพราะตีนตุ๊กแกสามารถกันไฟไหม้ได้นาน 24 ชั่วโมง', false, 'ผิด เหตุผลหลักคือการถนอมสายและความสะดวกในการบำรุงรักษา', 4);
INSERT INTO public.choices VALUES ('3e7cd1cc-a61a-4ba4-b158-eff78f67e7f3', '9a28af2c-2332-44f7-956d-28c33b97cbc0', 'ติดตั้งสวิตช์ไว้ประจำทุกตู้แร็ค โดยเซิร์ฟเวอร์ในตู้จะต่อสายสั้นๆ เข้ากับสวิตช์ในตู้ตัวเองก่อนส่ง Uplink ไปยังสวิตช์หลัก', true, 'ถูกต้อง ToR ช่วยลดจำนวนสายยาวที่ต้องลากข้ามตู้ได้มหาศาล', 1);
INSERT INTO public.choices VALUES ('a97ed02d-24ca-4d35-b352-3c4e2590acdc', '9a28af2c-2332-44f7-956d-28c33b97cbc0', 'วางเซิร์ฟเวอร์ไว้บนหลังคาอาคารเพื่อรับลมธรรมชาติ', false, 'ผิด ไม่ใช่การวางบนหลังคาอาคาร', 2);
INSERT INTO public.choices VALUES ('3b557cc4-f231-484a-8f22-813c84a199a4', '9a28af2c-2332-44f7-956d-28c33b97cbc0', 'ลากสายแลนจากเซิร์ฟเวอร์ทุกเครื่องในห้องไปเสียบรวมกันที่ผู้ให้บริการอินเทอร์เน็ตโดยตรง', false, 'ผิด นั่นไม่ใช่สถาปัตยกรรม ToR', 3);
INSERT INTO public.choices VALUES ('4a244d69-5ab7-4a0b-844e-8b1d667379b2', '9a28af2c-2332-44f7-956d-28c33b97cbc0', 'ห้ามติดตั้งสวิตช์ในตู้แร็คเด็ดขาด', false, 'ผิด ToR คือการมีสวิตช์อยู่ในทุกตู้แร็ค', 4);
INSERT INTO public.choices VALUES ('eff43e51-3a34-476e-8e84-b21d6cbf8bb7', 'd9a0cafa-ab7f-4017-8a74-8790c9115acd', 'ติดป้ายที่ปลายสายทั้งสองฝั่ง โดยระบุรหัสตู้ ชั้น U ชื่ออุปกรณ์ และหมายเลขพอร์ต ของทั้งฝั่งต้นทางและปลายทาง', true, 'ถูกต้อง ช่วยให้ตรวจสอบปลายทางได้ทันทีจากทั้งสองฝั่งโดยไม่ต้องดึงสาย', 1);
INSERT INTO public.choices VALUES ('9af58310-82af-44ad-ae2a-141c94670e62', 'd9a0cafa-ab7f-4017-8a74-8790c9115acd', 'เขียนแค่ชื่อเล่นของช่างที่เดินสายไว้ตรงกลางสายจุดเดียว', false, 'ผิด ไม่สามารถใช้ระบุตำแหน่งพอร์ตต้นทางและปลายทางได้', 2);
INSERT INTO public.choices VALUES ('02d903cf-c95f-45f9-963d-827581eeb031', 'd9a0cafa-ab7f-4017-8a74-8790c9115acd', 'เขียนแค่วันที่ซื้อสายไว้ที่ฝั่งเดียว', false, 'ผิด ขาดข้อมูลพอร์ตเชื่อมต่อที่จำเป็นในการแก้ปัญหา', 3);
INSERT INTO public.choices VALUES ('c1591ab3-f74d-498b-9565-ba74be825d64', 'd9a0cafa-ab7f-4017-8a74-8790c9115acd', 'ไม่ต้องติดป้ายใดๆ เพื่อประหยัดงบประมาณ', false, 'ผิด การไม่ติดป้ายทำให้ซ่อมบำรุงยากและเสี่ยงดึงสายผิดเส้น', 4);
INSERT INTO public.choices VALUES ('6b710973-2411-4ae4-8a6a-a82d95697283', '10ee6d5a-fcd8-4f5b-a1ba-bcfb8d54577e', 'ไม่มีแสงเดินทางมาถึงขารับ (Rx) ของพอร์ตเรา เช่น สายไฟเบอร์ขาด/หลุด หรืออุปกรณ์ฝั่งตรงข้ามปิดอยู่', true, 'ถูกต้อง Rx Power ต่ำถึง -39.5 dBm แปลว่าขารับไม่ได้รับแสงจากฝั่งตรงข้ามเลย', 1);
INSERT INTO public.choices VALUES ('a7887883-5fa9-4dfe-81ce-fa2ad52b7388', '10ee6d5a-fcd8-4f5b-a1ba-bcfb8d54577e', 'หัว SFP ฝั่งเรามีแสงแรงเกินไปจนทะลุพิกัด', false, 'ผิด ค่าติดลบมากๆ (-39.5 dBm) แปลว่าแสงอ่อนมากจนเกือบเป็นศูนย์ ไม่ใช่แสงแรงเกิน', 2);
INSERT INTO public.choices VALUES ('6728a3aa-578b-4efc-b070-dda69e53f902', '10ee6d5a-fcd8-4f5b-a1ba-bcfb8d54577e', 'พอร์ตกำลังทำงานด้วยความเร็วสูงสุดเป็นพิเศษ', false, 'ผิด พอร์ตขึ้น Low Alarm และลิงก์ไม่ขึ้น', 3);
INSERT INTO public.choices VALUES ('d61ef8c8-7870-445a-a434-1a356ee7f085', '10ee6d5a-fcd8-4f5b-a1ba-bcfb8d54577e', 'ตั้งค่า Default Gateway ในระบบปฏิบัติการผิด', false, 'ผิด ค่าแสงเป็นเรื่อง Layer 1 ทางกายภาพ ไม่เกี่ยวกับ Gateway', 4);
INSERT INTO public.choices VALUES ('e1d83ab5-e28d-4a7a-aba3-1f04b4a599b2', 'c05c4fb2-1c30-4982-93ae-6301b6464eec', 'Local User Account', false, 'ผิด Local User อยู่เฉพาะในเครื่องเดียว ไม่ใช่ออบเจกต์โครงสร้างบน AD', 4);
INSERT INTO public.choices VALUES ('b381319a-67d8-44f5-91a8-d0bd4fb38c0d', '997a72f5-5b33-446f-97b8-2c613c1665e6', 'เป็นฐานข้อมูลกลางบันทึกผังตู้แร็ค (Rack Elevation), ทะเบียนสินทรัพย์ฮาร์ดแวร์, เส้นทางสายเชื่อมต่อ และการจัดการ IP (IPAM)', true, 'ถูกต้อง NetBox/DCIM คือหัวใจของการทำเอกสารและคลังสินทรัพย์ใน Data Center ยุคใหม่', 1);
INSERT INTO public.choices VALUES ('f92a11da-b071-414c-9b0f-1dcef08fd046', '997a72f5-5b33-446f-97b8-2c613c1665e6', 'เป็นโปรแกรมสำหรับตัดต่อวิดีโอและตกแต่งรูปภาพ', false, 'ผิด ไม่เกี่ยวข้องกัน', 2);
INSERT INTO public.choices VALUES ('58910807-bf8e-45bf-b565-d365f767a9ab', '997a72f5-5b33-446f-97b8-2c613c1665e6', 'เป็นระบบปฏิบัติการที่ใช้แทน Linux บนเซิร์ฟเวอร์', false, 'ผิด DCIM เป็นเว็บแอปพลิเคชันจัดการฐานข้อมูลโครงสร้างพื้นฐาน', 3);
INSERT INTO public.choices VALUES ('98f68b4b-2ba1-411d-b3c4-2d5b1d77cc78', '997a72f5-5b33-446f-97b8-2c613c1665e6', 'เป็นโปรแกรมแอนตี้ไวรัสสำหรับเครื่องลูกข่าย', false, 'ผิด ไม่ใช่โปรแกรมแอนตี้ไวรัส', 4);
INSERT INTO public.choices VALUES ('e54557e2-30d6-4e5f-8c03-80411dbba0ab', '5e77e5f5-b2a6-4ef7-b604-cd1bb221d8de', 'เพราะกล่องกระดาษปล่อยฝุ่นผงเข้าไปอุดตันระบบระบายความร้อน และเป็นเชื้อเพลิงที่ติดไฟง่าย (Fire Hazard)', true, 'ถูกต้อง ทั้งเรื่องฝุ่นละอองและการป้องกันอัคคีภัยคือเหตุผลหลัก', 1);
INSERT INTO public.choices VALUES ('422f8247-18b5-4ea1-9685-fabec9e3dff3', '5e77e5f5-b2a6-4ef7-b604-cd1bb221d8de', 'เพราะสีน้ำตาลของกล่องกระดาษจะรบกวนสัญญาณ Wi-Fi', false, 'ผิด สีกล่องไม่รบกวนสัญญาณ', 2);
INSERT INTO public.choices VALUES ('ee8194af-ceb4-43a2-b6a7-3982314662f5', '5e77e5f5-b2a6-4ef7-b604-cd1bb221d8de', 'เพราะกล่องกระดาษจะดูดซับแสงจากสายไฟเบอร์ออปติก', false, 'ผิด แสงไฟเบอร์ถูกหุ้มอยู่ในสายมิดชิด', 3);
INSERT INTO public.choices VALUES ('d9d7b27d-8163-4745-a02f-be8764686b55', '5e77e5f5-b2a6-4ef7-b604-cd1bb221d8de', 'เพราะกล้องวงจรปิดไม่สามารถมองเห็นกล่องกระดาษได้', false, 'ผิด กล้องมองเห็นได้ปกติ', 4);
INSERT INTO public.choices VALUES ('53ebe6d6-c58c-4926-a165-2824314843bd', '89c6c052-d4f4-417e-b26f-b8dc659a4deb', 'สามารถปิดซ่อมบำรุงอุปกรณ์ระบบไฟหรือแอร์ตามแผนได้โดยที่เซิร์ฟเวอร์ยังทำงานต่อเนื่องไม่เกิด Downtime (Concurrently Maintainable)', true, 'ถูกต้อง นี่คือนิยามสำคัญที่สุดของ Tier III', 1);
INSERT INTO public.choices VALUES ('fc36f3d8-d769-441c-82f5-4e2bb66a6469', '89c6c052-d4f4-417e-b26f-b8dc659a4deb', 'ไม่มีการใช้เครื่องสำรองไฟ UPS เลยเพื่อประหยัดงบประมาณ', false, 'ผิด Tier III ต้องมีระบบ UPS และ Generator สำรองครบถ้วน', 2);
INSERT INTO public.choices VALUES ('c33b9c22-dd42-4b91-8a42-6d9e6a66f878', '89c6c052-d4f4-417e-b26f-b8dc659a4deb', 'ต้องปิดศูนย์ข้อมูลทั้งหมดปีละ 7 วันเพื่อทำความสะอาด', false, 'ผิด Tier III ออกแบบมาเพื่อไม่ให้ต้องปิดระบบตอนซ่อมบำรุง', 3);
INSERT INTO public.choices VALUES ('6488e201-dc1e-449a-b689-48b8bb870e58', '89c6c052-d4f4-417e-b26f-b8dc659a4deb', 'อนุญาตให้บุคคลภายนอกเดินเข้าออกได้โดยไม่ต้องแลกบัตร', false, 'ผิด ศูนย์ข้อมูลมีระบบรักษาความปลอดภัยเข้มงวด', 4);
INSERT INTO public.choices VALUES ('52b7a246-43c7-4f9b-bce2-dd37c1d30507', '8dc5b9d6-8e1f-4760-a9dd-dc4539c06fad', 'สวมสายรัดข้อมือป้องกันไฟฟ้าสถิต (ESD Wrist Strap) และหนีบเข้ากับจุดกราวด์ของโครงตู้แร็ค', true, 'ถูกต้อง ป้องกัน Electrostatic Discharge ทำลายชิปเซมิคอนดักเตอร์', 1);
INSERT INTO public.choices VALUES ('766e6f05-a0b6-4ced-a1e2-f0da1aa40b30', '8dc5b9d6-8e1f-4760-a9dd-dc4539c06fad', 'ถูมือกับพรมให้เกิดประกายไฟก่อนจับแรม', false, 'ผิด การถูกับพรมจะยิ่งสร้างไฟฟ้าสถิตทำลายแรมทันที!', 2);
INSERT INTO public.choices VALUES ('80746f07-5b4b-40de-949c-059593459729', '8dc5b9d6-8e1f-4760-a9dd-dc4539c06fad', 'พรมน้ำลงบนเมนบอร์ดเพื่อให้เย็นตัว', false, 'ผิด น้ำทำให้เกิดการลัดวงจร', 3);
INSERT INTO public.choices VALUES ('13370897-de59-4303-870c-5e2d82d9bd4d', '8dc5b9d6-8e1f-4760-a9dd-dc4539c06fad', 'สวมแว่นกันแดดสีดำขณะเปลี่ยนแรม', false, 'ผิด ไม่ช่วยป้องกันไฟฟ้าสถิต', 4);
INSERT INTO public.choices VALUES ('1e16277f-4f88-48b8-9570-801a411676bb', '3c363e7c-9f30-455c-b6db-be46fb48c093', '1.5', true, 'ถูกต้อง PUE = 1,500 / 1,000 = 1.5', 1);
INSERT INTO public.choices VALUES ('d2e4c359-8894-4159-9625-3da1ce792015', '3c363e7c-9f30-455c-b6db-be46fb48c093', '0.67', false, 'ผิด ค่า PUE ไม่มีทางต่ำกว่า 1.0 เพราะไฟรวมทั้งตึกต้องมากกว่าหรือเท่ากับไฟไอทีเสมอ', 2);
INSERT INTO public.choices VALUES ('5a568056-dee2-42b5-ae05-f2367e58bcce', '3c363e7c-9f30-455c-b6db-be46fb48c093', '500', false, 'ผิด PUE คืออัตราส่วนการหาร ไม่ใช่การลบ', 3);
INSERT INTO public.choices VALUES ('7b575f0d-0c9a-44c9-920d-539aa09a17d8', '3c363e7c-9f30-455c-b6db-be46fb48c093', '2,500', false, 'ผิด ไม่ใช่การนำมาบวกกัน', 4);
INSERT INTO public.choices VALUES ('fcf075b7-0b04-423f-9451-6de4df508ec2', '7a926c05-18f5-464f-b5ad-6fe69d1f02a7', 'Rollback Plan (แผนการย้อนกลับสู่สถานะเดิมเมื่อเกิดปัญหา)', true, 'ถูกต้อง หากไม่มี Rollback Plan จะไม่ได้รับอนุมัติให้ทำ Change บนระบบ Production', 1);
INSERT INTO public.choices VALUES ('d21942f9-155a-4e5a-9a27-41c4937fcc9a', '7a926c05-18f5-464f-b5ad-6fe69d1f02a7', 'รายชื่อร้านอาหารรอบศูนย์ข้อมูล', false, 'ผิด ไม่ใช่ส่วนประกอบทางเทคนิคของ MOP', 2);
INSERT INTO public.choices VALUES ('902df83e-82bd-471d-a46b-91307c81cc6e', '7a926c05-18f5-464f-b5ad-6fe69d1f02a7', 'ประวัติการศึกษาของผู้บริหารทั้งหมด', false, 'ผิด ไม่เกี่ยวข้องกับขั้นตอนปฏิบัติงาน', 3);
INSERT INTO public.choices VALUES ('f25d5361-8106-4c50-8a25-b8308d7c382b', '7a926c05-18f5-464f-b5ad-6fe69d1f02a7', 'ใบเสร็จค่าเช่าบ้านของช่างเทคนิค', false, 'ผิด ไม่เกี่ยวข้องกัน', 4);
INSERT INTO public.choices VALUES ('b9ac2f3f-6c65-4586-8f49-88451eac3ab8', '256f966e-df8f-4ed0-a9d3-51b607070273', 'ผู้จัดการฝ่ายบุคคลแจ้งขอสร้างบัญชีอีเมลและขอสิทธิ์เข้าโฟลเดอร์ให้พนักงานใหม่ที่จะเริ่มงานวันจันทร์หน้า', true, 'ถูกต้อง เป็นคำขอใช้บริการตามขั้นตอนมาตรฐาน (Service Request) ระบบไม่ได้เกิดความเสียหาย', 1);
INSERT INTO public.choices VALUES ('1afa156c-ee57-45c1-a211-3187ee7c2d4b', '256f966e-df8f-4ed0-a9d3-51b607070273', 'พนักงานฝ่ายขายเปิดโปรแกรม CRM แล้วขึ้นข้อความ Database Connection Error เข้าทำงานไม่ได้', false, 'ผิด นี่คือ Incident เพราะบริการขัดข้องผิดปกติ', 2);
INSERT INTO public.choices VALUES ('3bd384fa-6c39-43c9-b3da-016f5c6bf7eb', '256f966e-df8f-4ed0-a9d3-51b607070273', 'เครือข่าย Wi-Fi ที่ห้องประชุมชั้น 5 หลุดทุกๆ 10 นาทีระหว่างการประชุมผู้บริหาร', false, 'ผิด นี่คือ Incident เพราะคุณภาพบริการลดลงหรือขัดข้อง', 3);
INSERT INTO public.choices VALUES ('34ce9e9d-05da-44bf-9d86-118b45427b64', '256f966e-df8f-4ed0-a9d3-51b607070273', 'เครื่องพิมพ์ใบเสร็จที่จุดชำระเงินไฟสีแดงกะพริบและไม่ยอมดึงกระดาษ', false, 'ผิด นี่คือ Incident ด้านฮาร์ดแวร์ขัดข้อง', 4);
INSERT INTO public.choices VALUES ('72a0538f-0397-484f-967a-5a574584b42c', 'b292d3f9-fb78-417a-92da-e50ff999bc5d', 'จัดเป็นระดับ P3 หรือ P4 (Low/Medium) ตามผลกระทบจริง (Impact ต่ำเพราะกระทบ 1 คน และ Urgency ต่ำเพราะมีเครื่องสำรองใช้แทนได้) พร้อมอธิบายกรอบเวลา SLA ให้ผู้ใช้เข้าใจอย่างสุภาพ', true, 'ถูกต้อง Priority ต้องวัดจาก Impact × Urgency เชิงธุรกิจ ไม่ใช่ตั้ง P1 ตามเสียงเร่งของผู้แจ้ง', 1);
INSERT INTO public.choices VALUES ('7c4940de-84e7-4065-8c0b-06175a8a76a4', 'b292d3f9-fb78-417a-92da-e50ff999bc5d', 'ตั้งเป็น P1 (Critical) ทันทีตามที่ผู้ใช้สั่ง และปลุกทีมวิศวกรทุกคนมาประชุมด่วน', false, 'ผิด การตั้ง P1 พร่ำเพรื่อจะทำให้ทีมเสียสมาธิจากเคสระบบล่มจริง', 2);
INSERT INTO public.choices VALUES ('10391954-3582-428b-9b23-47d4c2fa2fc8', 'b292d3f9-fb78-417a-92da-e50ff999bc5d', 'กดยกเลิกใบงาน (Cancel Ticket) ทิ้งทันทีเพราะผู้ใช้งานพูดจาเร่งรัด', false, 'ผิด ต้องรับเรื่องและแก้ไขตามลำดับ SLA อย่างมืออาชีพ', 3);
INSERT INTO public.choices VALUES ('65da6570-e852-4710-8b16-47c5a26abfd1', 'b292d3f9-fb78-417a-92da-e50ff999bc5d', 'ปิดระบบเครือข่ายทั้งตึกเพื่อให้กลายเป็นเคส P1 จริงๆ', false, 'ผิด ไม่ควรทำอย่างยิ่ง!', 4);
INSERT INTO public.choices VALUES ('58852c8c-2088-473c-99aa-f2cb7209c2a6', '5ec568d1-840c-4aef-bed2-e73cb97ed488', 'Response SLA คือเวลาในการรับเรื่องและติดต่อกลับครั้งแรก ส่วน Resolution SLA คือเวลาที่ใช้แก้ไขปัญหาจนระบบกลับมาใช้งานได้ปกติ', true, 'ถูกต้อง แยกเวลารับเรื่อง (Response) ออกจากเวลาแก้จบ (Resolution) อย่างชัดเจน', 1);
INSERT INTO public.choices VALUES ('9ef25599-0891-47d8-ba47-d69e4b83c967', '5ec568d1-840c-4aef-bed2-e73cb97ed488', 'Response SLA ใช้กับวันจันทร์-ศุกร์ ส่วน Resolution SLA ใช้กับวันเสาร์-อาทิตย์', false, 'ผิด ทั้งสองตัววัดผลในทุกใบงาน', 2);
INSERT INTO public.choices VALUES ('6a612138-e5c2-47c3-8fae-6243e7f3f8bc', '5ec568d1-840c-4aef-bed2-e73cb97ed488', 'Response SLA คือเวลาที่เซิร์ฟเวอร์ตอบสนองคำสั่ง ping ส่วน Resolution SLA คือความละเอียดของหน้าจอคอมพิวเตอร์', false, 'ผิด คนละความหมายกับ SLA ในงานบริการไอที', 3);
INSERT INTO public.choices VALUES ('c8925896-315b-4a61-9bfe-7943ed30508e', '5ec568d1-840c-4aef-bed2-e73cb97ed488', 'ทั้งสองคำมีความหมายเหมือนกันทุกประการ ใช้แทนกันได้', false, 'ผิด มีความหมายและเกณฑ์เวลาต่างกันมาก', 4);
INSERT INTO public.choices VALUES ('9900dbbe-6bf1-4da0-a5b4-a70739c94c16', '06283e37-8fad-40a5-96a4-d9d0ad99807b', 'Problem (ในกระบวนการ Problem Management)', true, 'ถูกต้อง Problem คือต้นตอที่อยู่เบื้องหลัง Incident เดียวหรือหลาย Incident ที่เกิดซ้ำ', 1);
INSERT INTO public.choices VALUES ('07b1e4b7-3068-483c-9a18-55bb51f34a11', '06283e37-8fad-40a5-96a4-d9d0ad99807b', 'Service Request (คำขอใช้บริการทั่วไป)', false, 'ผิด Service Request คือคำขอสิ่งใหม่ เช่น ขอสิทธิ์หรือขออุปกรณ์', 2);
INSERT INTO public.choices VALUES ('f4a2c09a-6cff-4d11-9175-57cc62fb5176', '06283e37-8fad-40a5-96a4-d9d0ad99807b', 'Purchase Order (ใบสั่งซื้อสินค้า)', false, 'ผิด เป็นเอกสารจัดซื้อ ไม่ใช่ใบงานสืบสวนสาเหตุใน ITIL', 3);
INSERT INTO public.choices VALUES ('c6519af4-5796-42a8-be45-d183345601b9', '06283e37-8fad-40a5-96a4-d9d0ad99807b', 'User Manual (คู่มือการใช้งาน)', false, 'ผิด ไม่ใช่ประเภทใบงานในระบบ ITSM', 4);
INSERT INTO public.choices VALUES ('28a248ff-7d7a-4e66-92d9-a1ba63ca5c4a', '97328fad-ee72-4dd2-a54f-e7fe04a22cb8', 'รายละเอียดผู้ได้รับผลกระทบ วันเวลาที่เกิดเหตุ ข้อความ Error/Log จริง และรายการสิ่งที่ L1 ได้ทดสอบตัดประเด็นไปแล้ว', true, 'ถูกต้อง ช่วยให้ทีม L2 วิเคราะห์ต่อได้ทันทีโดยไม่ต้องถามซ้ำ', 1);
INSERT INTO public.choices VALUES ('f42dd6f0-4d44-4c81-b8a8-5778b45e1641', '97328fad-ee72-4dd2-a54f-e7fe04a22cb8', 'เขียนเพียงสั้นๆ ว่า "ด่วนมาก รบกวนดูให้ด้วยครับ" เพื่อให้ทีม L2 อ่านจบเร็วที่สุด', false, 'ผิด ขาดข้อมูลสำคัญทั้งหมด ทำให้ L2 ต้องเสียเวลาโทรถามใหม่', 2);
INSERT INTO public.choices VALUES ('8114d445-7c3b-40da-9f62-36a690c82e91', '97328fad-ee72-4dd2-a54f-e7fe04a22cb8', 'แนบประวัติการศึกษาของเจ้าหน้าที่ L1 ไปในใบงาน', false, 'ผิด ไม่เกี่ยวกับการแก้ปัญหาทางเทคนิค', 3);
INSERT INTO public.choices VALUES ('ba70a37c-7e73-482a-8336-62c9fb19dc75', '97328fad-ee72-4dd2-a54f-e7fe04a22cb8', 'ลบข้อความที่ลูกค้าแจ้งออกทั้งหมดแล้วเขียนใหม่ตามความรู้สึกของตัวเอง', false, 'ผิด ต้องรักษาข้อเท็จจริงและหลักฐาน Error เดิมไว้เสมอ', 4);
INSERT INTO public.choices VALUES ('c12a2e91-bc0e-4081-8672-70e0c80638c2', 'c05c4fb2-1c30-4982-93ae-6301b6464eec', 'Organizational Unit (OU)', true, 'ถูกต้อง GPO จะถูกผูก (Link) เข้ากับ Site, Domain หรือ OU เท่านั้น', 1);
INSERT INTO public.choices VALUES ('b3e549bb-ac63-471e-af62-4eabd12dfdbf', 'c05c4fb2-1c30-4982-93ae-6301b6464eec', 'Security Group', false, 'ผิด Security Group ใช้กำหนดสิทธิ์เข้าถึงไฟล์หรือใช้ทำ Security Filtering แต่ผูก GPO โดยตรงไม่ได้', 2);
INSERT INTO public.choices VALUES ('1f2e64eb-42f5-4e8b-82c1-1a0879e50c87', 'e868866f-050c-4fd4-a36a-5054d97fe0dc', 'รหัสผ่านประจำเครื่องคอมพิวเตอร์ (Machine Account Password) ที่ใช้ยืนยันตัวตนกับ Domain Controller ไม่ตรงกัน (เช่น เครื่องออฟไลน์ไปนานหรือถูกย้อน System Restore)', true, 'ถูกต้อง สามารถซ่อมได้ด้วยคำสั่ง Test-ComputerSecureChannel -Repair หรือ Re-join Domain', 1);
INSERT INTO public.choices VALUES ('920bafa5-bf8f-44d3-978d-35493a37fc17', 'e868866f-050c-4fd4-a36a-5054d97fe0dc', 'สายเมาส์และคีย์บอร์ดเสียบสลับช่อง USB กัน', false, 'ผิด ไม่เกี่ยวข้องกับการยืนยันตัวตนใน Domain', 2);
INSERT INTO public.choices VALUES ('0136431c-1b30-4f74-b325-80e57d8cfb7d', 'e868866f-050c-4fd4-a36a-5054d97fe0dc', 'หน้าจอภาพมีความละเอียดสูงเกินไป', false, 'ผิด ไม่เกี่ยวกับหน้าจอ', 3);
INSERT INTO public.choices VALUES ('347e0d47-70fa-4aa4-ac27-c2d5f7f68b36', 'e868866f-050c-4fd4-a36a-5054d97fe0dc', 'ฮาร์ดดิสก์มีพื้นที่ว่างมากกว่า 50%', false, 'ผิด พื้นที่ว่างไม่ได้ทำให้ Trust Relationship พัง', 4);
INSERT INTO public.choices VALUES ('498c823a-58ea-49ea-a781-f1cad672ba06', 'ef69e1ac-1034-4c68-af69-79ad37cabb59', 'เพราะโปรโตคอลยืนยันตัวตน Kerberos กำหนดให้เวลาของเครื่องลูกและเซิร์ฟเวอร์ห้ามคลาดเคลื่อนเกิน 5 นาทีเพื่อป้องกันการโจมตีแบบ Replay Attack', true, 'ถูกต้อง Kerberos ใช้ Timestamp ในการเข้ารหัสตั๋ว (Ticket) จึงต้องซิงก์เวลา NTP ให้ตรงกันเสมอ', 1);
INSERT INTO public.choices VALUES ('46d63482-b1ca-4b60-a33f-6fdc012a5ad4', 'ef69e1ac-1034-4c68-af69-79ad37cabb59', 'เพราะสวิตช์เครือข่ายจะตัดไฟพอร์ต LAN หากนาฬิกาเดินไม่ตรง', false, 'ผิด สวิตช์ไม่ได้ตรวจสอบเวลาของ OS ในเครื่องลูก', 2);
INSERT INTO public.choices VALUES ('1144b332-b5d0-4f37-bbc2-1e5747cbb567', 'ef69e1ac-1034-4c68-af69-79ad37cabb59', 'เพราะ Windows จะลบไดรเวอร์การ์ดแลนทิ้งเมื่อเวลาเพี้ยน', false, 'ผิด ไดรเวอร์ไม่ได้ถูกลบ', 3);
INSERT INTO public.choices VALUES ('15c4b077-a4cc-48e9-9efa-66fc58eace7d', 'ef69e1ac-1034-4c68-af69-79ad37cabb59', 'เพราะสายแลน Cat6 รองรับเฉพาะเครื่องที่ตั้งเวลาเป็นโซนยุโรปเท่านั้น', false, 'ผิด สายแลนเป็นเพียงสื่อนำสัญญาณกายภาพ', 4);
INSERT INTO public.choices VALUES ('917a0c9d-80fb-49ea-b07a-6496e78f3a7a', '4bffbea3-efde-4d90-9fe8-e8f028d932ef', 'gpupdate /force และ gpresult /r', true, 'ถูกต้อง gpupdate /force ใช้ดึงนโยบายใหม่ และ gpresult /r ใช้ตรวจผลลัพธ์ GPO', 1);
INSERT INTO public.choices VALUES ('10c0b624-d69e-404c-ac75-8e8ffb164153', '4bffbea3-efde-4d90-9fe8-e8f028d932ef', 'ipconfig /flushdns และ ping', false, 'ผิด นั่นเป็นคำสั่งล้างแคช DNS และทดสอบเครือข่าย', 2);
INSERT INTO public.choices VALUES ('03127d3c-f296-4e90-8f38-3d9ba48c07ac', '4bffbea3-efde-4d90-9fe8-e8f028d932ef', 'format c: และ chkdsk', false, 'ผิด นั่นเป็นคำสั่งฟอร์แมตและตรวจดิสก์', 3);
INSERT INTO public.choices VALUES ('81cc1fb4-2fd9-46fc-99be-ba51b3fe0d9e', '4bffbea3-efde-4d90-9fe8-e8f028d932ef', 'tasklist และ taskkill', false, 'ผิด นั่นเป็นคำสั่งจัดการโปรเซส', 4);
INSERT INTO public.choices VALUES ('c82504a0-0c60-4d74-a354-f6b3fbe0769f', '65a54171-261e-43c5-8a61-ae28af22fecd', 'มีอุปกรณ์อื่น (เช่น มือถือที่ต่อ Wi-Fi/อีเมลบริษัท) หรือ Windows Credential Manager ที่ยังจำรหัสผ่านเก่าและพยายามส่งไปล็อกอินซ้ำอัตโนมัติอยู่เบื้องหลัง', true, 'ถูกต้อง นี่คือสาเหตุอันดับ 1 ของปัญหา Account Lockout หลังเปลี่ยนรหัสผ่าน', 1);
INSERT INTO public.choices VALUES ('7e07a573-3f6e-4f62-ac97-0b7143691047', '65a54171-261e-43c5-8a61-ae28af22fecd', 'คีย์บอร์ดมีปุ่ม स्पेซบาร์ (Spacebar) เสีย', false, 'ผิด เจ้าตัวไม่ได้พิมพ์รหัสผ่านใหม่เลยแต่ถูกล็อกเองทุก 15 นาที', 2);
INSERT INTO public.choices VALUES ('7728f39d-cca1-44b0-8bd4-b2cbd726fb2a', '65a54171-261e-43c5-8a61-ae28af22fecd', 'สายไฟพาวเวอร์ซัพพลายของเซิร์ฟเวอร์หลวม', false, 'ผิด ไม่เกี่ยวข้องกับการล็อกบัญชีรายบุคคล', 3);
INSERT INTO public.choices VALUES ('cfc83df7-ecbb-4cb5-83c9-ed20c5451f74', '65a54171-261e-43c5-8a61-ae28af22fecd', 'หน้าจอคอมพิวเตอร์ตั้งค่าความสว่างไว้สูงเกินไป', false, 'ผิด ไม่เกี่ยวข้องกัน', 4);
INSERT INTO public.choices VALUES ('94aef7fd-6a55-4cc1-936c-f09e7841e7ac', 'e3ce04a7-9751-4d98-89a4-264a8629e1fb', 'Shared Mailbox พร้อมกำหนดสิทธิ์ Full Access และ Send As ให้เจ้าหน้าที่ทั้ง 3 คน', true, 'ถูกต้อง Shared Mailbox ฟรีไม่เสียค่า License (ไม่เกิน 50 GB) และมีกล่องจดหมายกลางที่ใช้ร่วมกันได้', 1);
INSERT INTO public.choices VALUES ('2ce1eac4-6edd-4287-9e0d-73dba1a1da35', 'e3ce04a7-9751-4d98-89a4-264a8629e1fb', 'User Mailbox ระดับ Enterprise E5', false, 'ผิด User Mailbox ต้องเสียเงินซื้อ License เพิ่ม', 2);
INSERT INTO public.choices VALUES ('caf49e0b-7cf9-4f4c-8c5c-54e9c30db805', 'e3ce04a7-9751-4d98-89a4-264a8629e1fb', 'Local Account บนเครื่องคอมพิวเตอร์ของแผนก HR', false, 'ผิด Local Account ไม่ใช่กล่องจดหมายบนระบบคลาวด์', 3);
INSERT INTO public.choices VALUES ('39f93fc9-000c-41a1-af23-722acc2a2fe1', 'e3ce04a7-9751-4d98-89a4-264a8629e1fb', 'สร้างโดเมนเว็บไซต์ใหม่แยกต่างหาก', false, 'ผิด ไม่จำเป็นต้องจดโดเมนใหม่', 4);
INSERT INTO public.choices VALUES ('258e6d39-d5f1-49b5-9c0e-71268d314db1', 'da4b8bc6-0a41-4f85-b707-09de5924b3db', 'SPF (Sender Policy Framework)', true, 'ถูกต้อง SPF ใช้ระบุรายการ IP/Server ที่ได้รับอนุญาตให้เป็นผู้ส่งในนามโดเมน', 1);
INSERT INTO public.choices VALUES ('4e36e206-f6f2-4a77-a7d1-d3baabc2ae41', 'da4b8bc6-0a41-4f85-b707-09de5924b3db', 'DHCP Scope', false, 'ผิด DHCP ใช้แจก IP ในเครือข่ายภายใน', 2);
INSERT INTO public.choices VALUES ('aa4738fd-4133-402a-98fb-403ec0bc00f9', 'da4b8bc6-0a41-4f85-b707-09de5924b3db', 'ARP Table', false, 'ผิด ARP ใช้แปลง IP เป็น MAC Address', 3);
INSERT INTO public.choices VALUES ('1fe1aaf7-0867-45b1-8b55-589841186311', 'da4b8bc6-0a41-4f85-b707-09de5924b3db', 'CNAME Alias สำหรับเว็บไซต์', false, 'ผิด CNAME ทั่วไปไม่ได้ประกาศรายการ IP ผู้ส่งอีเมลเหมือน SPF TXT Record', 4);
INSERT INTO public.choices VALUES ('828e529f-678f-416e-9859-2421386ea4d8', 'aa628f4a-aff3-4b5e-a6bb-de94aabf628a', 'DKIM คือลายเซ็นดิจิทัลเข้ารหัสที่แนบไปกับหัวจดหมาย ส่วน DMARC คือนโยบายกำหนดว่าจะให้ปล่อยผ่าน ย้ายเข้าถังขยะ หรือบล็อกทิ้งเมื่อตรวจ SPF/DKIM ไม่ผ่าน', true, 'ถูกต้อง DKIM = Digital Signature, DMARC = Policy (none/quarantine/reject) & Reporting', 1);
INSERT INTO public.choices VALUES ('f8a443d3-ad6d-45e0-8b29-843f7bbb72fb', 'aa628f4a-aff3-4b5e-a6bb-de94aabf628a', 'DKIM ใช้รับอีเมลขาเข้า ส่วน DMARC ใช้เปลี่ยนรหัสผ่าน Wi-Fi', false, 'ผิด ทั้งคู่เป็นมาตรฐานความปลอดภัยของระบบอีเมลขาออกและขารับ', 2);
INSERT INTO public.choices VALUES ('7c989f0c-3e43-49c7-867c-50da4ca75eb1', 'aa628f4a-aff3-4b5e-a6bb-de94aabf628a', 'DKIM ใช้บีบอัดไฟล์แนบให้เล็กลง ส่วน DMARC ใช้แปลภาษาอีเมลอัตโนมัติ', false, 'ผิด ไม่เกี่ยวกับการบีบอัดไฟล์หรือแปลภาษา', 3);
INSERT INTO public.choices VALUES ('c4db52ae-36dc-4d4d-8ea5-ca2f1a2d6853', 'aa628f4a-aff3-4b5e-a6bb-de94aabf628a', 'ทั้งสองตัวคือโปรแกรมสแกนไวรัสที่ติดตั้งลงในเครื่องลูกข่าย', false, 'ผิด ทั้งคู่เป็นมาตรฐานที่ตั้งค่าผ่าน DNS และ Mail Server', 4);
INSERT INTO public.choices VALUES ('4e298d90-3516-4689-b33b-89ed0f71681d', 'a5818f60-b037-4677-8bca-6ed90aa6506c', 'ไม่มีชื่อบัญชีอีเมลผู้รับนั้นอยู่ในเซิร์ฟเวอร์ปลายทาง (เช่น พิมพ์ชื่ออีเมลผิด หรือบัญชีผู้รับถูกลบไปแล้ว)', true, 'ถูกต้อง 550 5.1.1 คือรหัสมาตรฐานสากลสำหรับ User Unknown / Address Does Not Exist', 1);
INSERT INTO public.choices VALUES ('e8a6fbf8-c605-4660-9490-678a87228430', 'a5818f60-b037-4677-8bca-6ed90aa6506c', 'สายแลนของเครื่องผู้ส่งหลุดออกจากสวิตช์', false, 'ผิด ถ้าสายแลนหลุดจะไม่สามารถส่งเมลออกไปจนได้รับ NDR จากปลายทางได้', 2);
INSERT INTO public.choices VALUES ('a24c947e-6e76-4604-ade4-b724d3399d33', 'a5818f60-b037-4677-8bca-6ed90aa6506c', 'ฮาร์ดดิสก์ในเครื่องคอมพิวเตอร์ของผู้ส่งเต็ม', false, 'ผิด ไม่เกี่ยวกับฮาร์ดดิสก์ในเครื่องผู้ส่ง', 3);
INSERT INTO public.choices VALUES ('fac2499e-c03b-4bbb-8b78-af886988b979', 'a5818f60-b037-4677-8bca-6ed90aa6506c', 'ผู้รับตั้งค่าตอบกลับอัตโนมัติ (Out of Office) ไว้', false, 'ผิด Out of Office ไม่ใช่รหัส 550 5.1.1 Permanent Failure', 4);
INSERT INTO public.choices VALUES ('3060b3af-957e-41bd-a01f-9040eb65871d', '520d87f5-c584-4b4b-b599-fa6741ba2b2b', 'แปลงกล่องจดหมายของพนักงานคนนั้นให้เป็น Shared Mailbox (Convert to Shared Mailbox) ก่อน แล้วจึงปลด License ออกและบล็อกการล็อกอิน', true, 'ถูกต้อง วิธีนี้ช่วยเก็บรักษาอีเมลไว้ได้โดยไม่ต้องเสียค่าเช่า License รายเดือน', 1);
INSERT INTO public.choices VALUES ('1af90cf5-8540-4141-918f-653000b40e30', '520d87f5-c584-4b4b-b599-fa6741ba2b2b', 'สั่งปริ้นต์อีเมลทุกฉบับออกมาเป็นกระดาษแล้วลบแอคเคานต์ทิ้ง', false, 'ผิด ไม่สามารถทำได้จริงเมื่อมีอีเมลหลักหมื่นฉบับ', 2);
INSERT INTO public.choices VALUES ('4f653d6f-2ac7-4e00-8f17-96cfa407a0f2', '520d87f5-c584-4b4b-b599-fa6741ba2b2b', 'ปลด License ออกทันทีโดยไม่ต้องทำอะไร เพราะ Microsoft จะเก็บอีเมลไว้ให้ฟรีตลอดชีวิต', false, 'ผิด หากปลด License จาก User Mailbox ปกติโดยไม่แปลงเป็น Shared Mailbox ข้อมูลจะถูกลบถาวรหลังครบกำหนด Retention (ปกติ 30 วัน)', 3);
INSERT INTO public.choices VALUES ('e478501e-1e7f-49ad-9b6d-0abb75194b14', '520d87f5-c584-4b4b-b599-fa6741ba2b2b', 'ปล่อยรหัสผ่านเดิมทิ้งไว้ให้ใครก็ได้ล็อกอินเข้ามาดู', false, 'ผิด ผิดหลักความปลอดภัยและยังเปลืองค่า License อยู่', 4);
INSERT INTO public.choices VALUES ('d0143411-255f-45d0-89ff-f9b11a576cd7', '512ff8b7-0533-409f-8e09-f98ec0e4f245', 'สั่งหยุดบริการ Print Spooler (net stop spooler), ลบไฟล์งานค้างในโฟลเดอร์ C:\Windows\System32\spool\PRINTERS แล้วสั่งเริ่มบริการใหม่ (net start spooler)', true, 'ถูกต้อง เป็นวิธีมาตรฐานที่ล้างคิวค้างได้ 100% โดยไม่ต้องรีสตาร์ทเครื่อง', 1);
INSERT INTO public.choices VALUES ('a025fda4-3424-4cef-bcb3-edebc33d1b23', '512ff8b7-0533-409f-8e09-f98ec0e4f245', 'สั่งฟอร์แมตไดรฟ์ C: และลง Windows ใหม่ทันที', false, 'ผิด รุนแรงเกินความจำเป็น', 2);
INSERT INTO public.choices VALUES ('f1ce420c-735f-4593-961c-b313ef78c2f2', '512ff8b7-0533-409f-8e09-f98ec0e4f245', 'สั่งพิมพ์เอกสารเดิมซ้ำเข้าไปอีก 20 ครั้งเพื่อดันคิวเก่าออก', false, 'ผิด จะยิ่งทำให้คิวสะสมมากขึ้น', 3);
INSERT INTO public.choices VALUES ('2ca03611-b24a-443d-919a-f7951eed0eba', '512ff8b7-0533-409f-8e09-f98ec0e4f245', 'ถอดสายเมาส์และคีย์บอร์ดออกแล้วเสียบใหม่', false, 'ผิด ไม่เกี่ยวข้องกับบริการ Print Spooler', 4);
INSERT INTO public.choices VALUES ('20730833-e637-478c-9672-3206b2a95597', 'b1a7c889-ec7f-44a7-b4f3-badaee11adc0', 'พอร์ต TCP 9100 เพราะเชื่อมต่อตรงไปยัง IP ของเครื่องพิมพ์ได้เสถียรกว่าพอร์ต WSD ที่มักหลุดเมื่อเครื่องพิมพ์เข้าโหมดประหยัดพลังงาน', true, 'ถูกต้อง พอร์ต TCP 9100 คู่กับการล็อก Static IP/DHCP Reservation คือการตั้งค่าที่เสถียรที่สุด', 1);
INSERT INTO public.choices VALUES ('f86e1dc1-116b-4674-8354-05909c110b4d', 'b1a7c889-ec7f-44a7-b4f3-badaee11adc0', 'พอร์ต TCP 25 เพราะใช้โปรโตคอลเดียวกับการส่งอีเมล', false, 'ผิด พอร์ต 25 คือ SMTP สำหรับส่งอีเมล', 2);
INSERT INTO public.choices VALUES ('ed91efc0-8033-48ab-b04c-c03ad494f924', 'b1a7c889-ec7f-44a7-b4f3-badaee11adc0', 'พอร์ต UDP 53 เพราะเครื่องพิมพ์ทำหน้าที่เป็น DNS Server', false, 'ผิด พอร์ต 53 คือ DNS', 3);
INSERT INTO public.choices VALUES ('6e5f0ad6-e9d5-4bad-99f5-8b6ab0c1bb07', 'b1a7c889-ec7f-44a7-b4f3-badaee11adc0', 'พอร์ต TCP 3389 เพราะใช้โปรโตคอล Remote Desktop', false, 'ผิด พอร์ต 3389 คือ RDP', 4);
INSERT INTO public.choices VALUES ('b2fd645f-4134-4877-8c1b-93b1bbd5b775', '9f84eb24-f2f7-4a37-a212-cdf50df72acb', 'อ่านไฟล์ได้อย่างเดียว (Read Only) ไม่สามารถสร้างหรือแก้ไขไฟล์ได้ เพราะเมื่อนำ Share กับ NTFS มาเทียบกัน สิทธิ์ที่เข้มงวดกว่าจะชนะเสมอ', true, 'ถูกต้อง กฎเหล็กคือระหว่าง Share Permission กับ NTFS Permission ตัวที่จำกัดสิทธิ์แคบกว่า (Most Restrictive) จะเป็นผลลัพธ์สุดท้าย', 1);
INSERT INTO public.choices VALUES ('54d49221-5ce0-427e-ad1d-93c76b158dc3', '58226d42-ba11-4316-b7ed-a5926488badd', 'WPA3 Enterprise', false, 'ผิด WPA3 เป็นมาตรฐานความปลอดภัยของ Wi-Fi', 4);
INSERT INTO public.choices VALUES ('bd26fac2-1e39-4b4e-8905-5c9f90ed0d7f', '9f84eb24-f2f7-4a37-a212-cdf50df72acb', 'มีสิทธิ์เต็มที่ (Full Control) ลบและแก้ไขไฟล์ได้ทั้งหมด', false, 'ผิด แม้ NTFS จะให้ Full Control แต่ติดด่าน Share Permission ที่ให้แค่ Read', 2);
INSERT INTO public.choices VALUES ('6018ff1d-48b2-408b-bb6f-15fa844a4b5b', '9f84eb24-f2f7-4a37-a212-cdf50df72acb', 'ไม่สามารถเปิดดูโฟลเดอร์ได้เลย (Access Denied)', false, 'ผิด ทั้งสองด่านยังอนุญาตให้ Read ได้ จึงยังเปิดอ่านไฟล์ได้', 3);
INSERT INTO public.choices VALUES ('f785515c-f784-47c0-a865-7743eb3d3e3b', '9f84eb24-f2f7-4a37-a212-cdf50df72acb', 'สามารถแก้ไขไฟล์ได้เฉพาะวันจันทร์ถึงวันพุธ', false, 'ผิด ไม่เกี่ยวข้องกับวันในสัปดาห์', 4);
INSERT INTO public.choices VALUES ('35f2d699-88f5-4ba9-b0fc-6487f8cb6fa4', '5b3a90cc-98f5-4e20-84a0-4571ae4f7428', 'TCP 445', true, 'ถูกต้อง SMB Direct Hosting ใช้พอร์ต TCP 445', 1);
INSERT INTO public.choices VALUES ('d4b03ca1-58a0-4a2d-bf7c-1f593bf05220', '5b3a90cc-98f5-4e20-84a0-4571ae4f7428', 'TCP 80', false, 'ผิด พอร์ต 80 คือ HTTP', 2);
INSERT INTO public.choices VALUES ('771ca89a-4a12-4acf-a774-8566d9d5a7c5', '5b3a90cc-98f5-4e20-84a0-4571ae4f7428', 'TCP 22', false, 'ผิด พอร์ต 22 คือ SSH/SFTP', 3);
INSERT INTO public.choices VALUES ('4e55e51a-7ee8-4c67-b54d-50e6d349ed4f', '5b3a90cc-98f5-4e20-84a0-4571ae4f7428', 'UDP 161', false, 'ผิด พอร์ต 161 คือ SNMP', 4);
INSERT INTO public.choices VALUES ('8feea130-0fc2-4dcd-966b-33dd48e8a3d2', '29bbd4c8-8c53-4803-aed5-19065d230d4f', 'เครื่องของผู้ใช้งานไม่ได้ถูกตั้งค่าให้ใช้ Internal DNS Server ของบริษัทผ่าน VPN จึงไปถามชื่อโดเมนภายในกับ DNS ของอินเทอร์เน็ตบ้านแทน', true, 'ถูกต้อง เข้าด้วย IP ได้แต่เข้าด้วยชื่อไม่ได้ คือปัญหา DNS Resolution 100%', 1);
INSERT INTO public.choices VALUES ('8f8e5025-ef2a-40a6-ab90-501bdcdd970d', '29bbd4c8-8c53-4803-aed5-19065d230d4f', 'เซิร์ฟเวอร์ 10.20.1.50 ไฟดับ', false, 'ผิด ถ้าเซิร์ฟเวอร์ดับ จะต้องเข้าด้วย IP ไม่ได้ด้วย', 2);
INSERT INTO public.choices VALUES ('4ecc7f1e-56c0-42f3-b537-a49a12e816bd', '29bbd4c8-8c53-4803-aed5-19065d230d4f', 'สายแลนที่บ้านของผู้ใช้งานขาด', false, 'ผิด ผู้ใช้งานยังต่อ VPN และเข้าด้วย IP ได้ปกติ', 3);
INSERT INTO public.choices VALUES ('689b6b22-2973-4a0f-b87d-c9dfd0bebc69', '29bbd4c8-8c53-4803-aed5-19065d230d4f', 'จอภาพของพนักงานมีขนาดเล็กเกินไป', false, 'ผิด ไม่เกี่ยวข้องกัน', 4);
INSERT INTO public.choices VALUES ('fa34ac7d-624c-4b69-aa33-9952523ec315', 'ac2a6f12-d7c5-40f8-8115-75aed1a9e22a', 'มีข้อมูลอย่างน้อย 3 ชุด, เก็บบนสื่อต่างชนิดกัน 2 ประเภท, และเก็บไว้นอกสถานที่ (Offsite) อย่างน้อย 1 ชุด', true, 'ถูกต้อง 3 Copies, 2 Different Media, 1 Offsite Copy', 1);
INSERT INTO public.choices VALUES ('0f574fa0-71e1-4073-a42b-13a82dd166ea', 'ac2a6f12-d7c5-40f8-8115-75aed1a9e22a', 'ทำสำรองข้อมูลวันละ 3 ครั้ง, ใช้พนักงานดูแล 2 คน, และใช้เซิร์ฟเวอร์เพียง 1 เครื่อง', false, 'ผิด การเก็บทุกอย่างไว้ในเซิร์ฟเวอร์เครื่องเดียวเป็นจุดเสี่ยง Single Point of Failure', 2);
INSERT INTO public.choices VALUES ('83970fff-3397-42e5-942f-02c46f852d66', 'ac2a6f12-d7c5-40f8-8115-75aed1a9e22a', 'เก็บข้อมูลไว้ 3 วัน, ลบทิ้งทุก 2 สัปดาห์, และทดสอบปีละ 1 ครั้ง', false, 'ผิด ไม่ใช่นิยามของกฎ 3-2-1', 3);
INSERT INTO public.choices VALUES ('f04d22e6-ce07-4f75-91aa-f8944ea3726a', 'ac2a6f12-d7c5-40f8-8115-75aed1a9e22a', 'ตั้งรหัสผ่านยาว 3 ตัวอักษร, เปลี่ยนทุก 2 เดือน, และใช้ซ้ำได้ 1 ครั้ง', false, 'ผิด ไม่เกี่ยวข้องกับการสำรองข้อมูล', 4);
INSERT INTO public.choices VALUES ('df91c7ce-c5f1-40ef-b645-79b6fdd58ac3', '0f5d259c-9fb1-4888-8eaf-a4d4bbbeded2', 'RPO คือขอบเขตข้อมูลย้อนหลังที่ยอมให้สูญหายได้ (กำหนดความถี่ในการทำ Backup) ส่วน RTO คือระยะเวลาสูงสุดที่ต้องกู้ระบบให้กลับมาออนไลน์ใช้งานได้หลังเกิดเหตุ', true, 'ถูกต้อง RPO = ยอมเสียข้อมูลย้อนหลังได้แค่ไหน, RTO = ต้องกู้ระบบให้เสร็จภายในเวลากี่นาที/ชั่วโมง', 1);
INSERT INTO public.choices VALUES ('6f839a6d-56aa-4550-8b6d-d5f9022fe947', '0f5d259c-9fb1-4888-8eaf-a4d4bbbeded2', 'RPO คือราคาฮาร์ดดิสก์ ส่วน RTO คือราคาเครื่องสำรองไฟ UPS', false, 'ผิด ทั้งคู่เป็นตัวชี้วัดด้านเวลาและข้อมูลในแผน DR', 2);
INSERT INTO public.choices VALUES ('296c53d5-8929-491e-aa5f-03eeaff2c003', '0f5d259c-9fb1-4888-8eaf-a4d4bbbeded2', 'RPO ใช้กับระบบ Linux เท่านั้น ส่วน RTO ใช้กับระบบ Windows เท่านั้น', false, 'ผิด ใช้เป็นมาตรฐานสากลกับทุกระบบปฏิบัติการ', 3);
INSERT INTO public.choices VALUES ('a2665105-fbcb-40a6-8fc2-5ad555fe7fa5', '0f5d259c-9fb1-4888-8eaf-a4d4bbbeded2', 'RPO คือความเร็วพัดลมเซิร์ฟเวอร์ ส่วน RTO คืออุณหภูมิห้องแอร์', false, 'ผิด ไม่เกี่ยวข้องกัน', 4);
INSERT INTO public.choices VALUES ('afb90d8b-c90c-45c9-bb79-f202e23b8e8c', '7ee858e7-a270-4176-97df-b0535c488c4b', 'ต้องใช้ Full Backup ของวันอาทิตย์ ร่วมกับ Incremental Backup ของวันจันทร์, วันอังคาร และวันพุธ เรียงตามลำดับครบทุกชุด', true, 'ถูกต้อง Incremental เก็บเฉพาะส่วนต่างจากวันก่อนหน้า จึงต้องใช้ทุกก้อนเรียงต่อกันตั้งแต่ Full ล่าสุด', 1);
INSERT INTO public.choices VALUES ('0c15a8d0-5072-40c6-83f4-30aec54a1f43', '7ee858e7-a270-4176-97df-b0535c488c4b', 'ใช้เฉพาะไฟล์ Incremental Backup ของคืนวันพุธเพียงไฟล์เดียว', false, 'ผิด ไฟล์ Incremental วันพุธมีเฉพาะไฟล์ที่แก้ในวันพุธ ไม่มีข้อมูลพื้นฐานจากวันอาทิตย์-อังคาร', 2);
INSERT INTO public.choices VALUES ('931a521b-f3f5-4c26-8a17-d87c77989534', '7ee858e7-a270-4176-97df-b0535c488c4b', 'ใช้เฉพาะไฟล์ Full Backup ของวันอาทิตย์เพียงไฟล์เดียว ข้อมูลวันจันทร์-พุธจะกลับมาเอง', false, 'ผิด หากใช้แค่วันอาทิตย์ ข้อมูลที่ทำตั้งแต่วันจันทร์ถึงวันพุธจะหายทั้งหมด', 3);
INSERT INTO public.choices VALUES ('5b91a958-1760-4914-b65c-3f62b07b4ed6', '7ee858e7-a270-4176-97df-b0535c488c4b', 'ไม่ต้องใช้ไฟล์ใดเลย ระบบจะสร้างข้อมูลขึ้นมาใหม่จากอากาศ', false, 'ผิด ต้องกู้คืนจากสื่อบันทึกข้อมูลสำรอง', 4);
INSERT INTO public.choices VALUES ('1ca4f4ff-fb88-472e-826c-d98e32818f2d', '01178e2b-5bd0-469a-b6ac-eb8e42962154', 'เพราะ Ransomware มักจะวิ่งผ่านเครือข่ายไปสั่งลบหรือเข้ารหัสไฟล์ Backup ที่อยู่ใน NAS ปกติด้วย จึงต้องมีสำเนาที่ล็อกห้ามแก้ไข/ห้ามลบ (Immutable) หรือตัดขาดจากเครือข่าย (Air-Gapped)', true, 'ถูกต้อง Immutable/Air-Gapped Backup ป้องกันไม่ให้คนร้ายหรือมัลแวร์ทำลายไฟล์สำรองได้', 1);
INSERT INTO public.choices VALUES ('134bd10b-c16f-48f8-9dd2-866e0680a51b', '01178e2b-5bd0-469a-b6ac-eb8e42962154', 'เพื่อช่วยให้หน้าจอคอมพิวเตอร์แสดงผลสีสันสดใสขึ้น', false, 'ผิด ไม่เกี่ยวกับการแสดงผลหน้าจอ', 2);
INSERT INTO public.choices VALUES ('72e6b7e0-f94b-4b19-9566-65549843ba04', '01178e2b-5bd0-469a-b6ac-eb8e42962154', 'เพื่อลดค่าไฟฟ้าของเครื่องปรับอากาศในห้องเซิร์ฟเวอร์', false, 'ผิด วัตถุประสงค์หลักคือความปลอดภัยและการกู้คืนข้อมูลจาก Ransomware', 3);
INSERT INTO public.choices VALUES ('5f17d184-9998-4302-af43-5bd15146a43b', '01178e2b-5bd0-469a-b6ac-eb8e42962154', 'เพราะสายแลน Cat6 ไม่สามารถส่งไฟล์ที่มีขนาดเกิน 1 MB ได้', false, 'ผิด สายแลนส่งไฟล์ขนาดใหญ่ได้ตามปกติ', 4);
INSERT INTO public.choices VALUES ('d9b2562f-a361-4af7-8477-e87ec4be3e9b', '12b0b468-bbe8-4508-915b-2ad193586103', 'สั่งให้ดึงสาย LAN ออกและปิดการเชื่อมต่อ Wi-Fi ทันที (Isolate from Network) เพื่อหยุดการแพร่กระจายไปทำลายไฟล์ในโฟลเดอร์แชร์ขององค์กร แล้วรีบแจ้งทีม Security', true, 'ถูกต้อง การตัดเครือข่ายทันทีช่วยรักษาไฟล์บน Server กลางของบริษัทไม่ให้ถูกเข้ารหัสไปด้วย', 1);
INSERT INTO public.choices VALUES ('83bd5d1e-669f-4252-b7b7-6d0c4c070ee4', '12b0b468-bbe8-4508-915b-2ad193586103', 'สั่งให้พนักงานรีบเสียบ External Harddisk ที่มีไฟล์สำรองทั้งหมดเข้าไปที่เครื่องนั้นเพื่อก๊อปปี้ไฟล์', false, 'ผิด อันตรายมาก! หากเสียบไดรฟ์สำรองเข้าไป มัลแวร์จะเข้ารหัสทำลายไฟล์ในไดรฟ์สำรองนั้นทันที', 2);
INSERT INTO public.choices VALUES ('304b59f2-ce56-4002-9018-3a20e936cc8d', '12b0b468-bbe8-4508-915b-2ad193586103', 'สั่งให้พนักงานแชร์โฟลเดอร์ทั้งหมดในเครื่องให้เพื่อนร่วมงานช่วยกันเปิดดู', false, 'ผิด จะยิ่งทำให้มัลแวร์แพร่กระจายไปติดเครื่องเพื่อนร่วมงานเร็วขึ้น', 3);
INSERT INTO public.choices VALUES ('6c033771-73f6-452a-aad9-6e3f9e524348', '12b0b468-bbe8-4508-915b-2ad193586103', 'โอนเงิน Bitcoin ให้คนร้ายทันทีโดยไม่ต้องแจ้งหัวหน้าทีมหรือฝ่ายความปลอดภัย', false, 'ผิด ห้ามโอนเงินโดยพลการและต้องเข้าสู่กระบวนการ Incident Response ทันที', 4);
INSERT INTO public.choices VALUES ('86b8a019-1e72-426b-92df-be4e7a41bb8d', 'f03f5c64-7d5e-4964-9ad8-bff75f35a6f5', 'VFL (Visual Fault Locator / ปากกายิงแสงเลเซอร์สีแดง)', true, 'ถูกต้อง VFL ยิงแสงสีแดงที่มองเห็นได้ด้วยตาเปล่าเพื่อไล่ปลายสายและหาจุดที่สายไฟเบอร์หักงอ', 1);
INSERT INTO public.choices VALUES ('98aac425-f284-4298-8f6f-5fef613edac6', 'f03f5c64-7d5e-4964-9ad8-bff75f35a6f5', 'ไขควงเช็กไฟบ้าน 220V', false, 'ผิด สายไฟเบอร์ส่งสัญญาณแสง ไม่ใช่สายทองแดงนำไฟฟ้า', 2);
INSERT INTO public.choices VALUES ('1ea820b4-9b1e-4462-8e24-f908f2fb70e7', 'f03f5c64-7d5e-4964-9ad8-bff75f35a6f5', 'คีมย้ำหัวสายแลน RJ45 (Crimping Tool)', false, 'ผิด คีมย้ำ RJ45 ใช้สำหรับเข้าหัวสายทองแดง ไม่ใช่เครื่องมือส่องแสงไฟเบอร์', 3);
INSERT INTO public.choices VALUES ('a94a4068-ec83-4954-9cc7-dfecafc81c72', 'f03f5c64-7d5e-4964-9ad8-bff75f35a6f5', 'สายรัดข้อมือป้องกันไฟฟ้าสถิต (ESD Wrist Strap)', false, 'ผิด ESD Wrist Strap ใช้ถ่ายเทไฟฟ้าสถิตจากร่างกายลงกราวด์', 4);
INSERT INTO public.choices VALUES ('d55b4d97-c5f3-40b1-85fb-47737b02cbeb', '3f1df441-85cc-45d3-9b85-504478cb0d29', 'ตัวพอร์ตสวิตช์และโมดูล SFP+ ทำงานได้ปกติ 100% สาเหตุที่ลิงก์ไม่ขึ้นเกิดจากสายไฟเบอร์มีปัญหาหรือฝั่งปลายทางยังไม่ได้เปิดพอร์ต', true, 'ถูกต้อง การผ่าน Loopback Test พิสูจน์ว่าภาครับและภาคส่งของพอร์ตตัวเองทำงานสมบูรณ์', 1);
INSERT INTO public.choices VALUES ('8ec14888-63fb-4b75-8256-f70c74cd2706', '3f1df441-85cc-45d3-9b85-504478cb0d29', 'ตัวโมดูล SFP+ พังเสียหาย ต้องเปลี่ยนตัวใหม่ทันที', false, 'ผิด ถ้า SFP+ พัง เมื่อเสียบ Loopback ไฟพอร์ตจะต้องไม่ขึ้น', 2);
INSERT INTO public.choices VALUES ('975d13e8-7fad-4a04-bee9-baf03fa9689f', '3f1df441-85cc-45d3-9b85-504478cb0d29', 'พาวเวอร์ซัพพลายของสวิตช์จ่ายไฟไม่พอ', false, 'ผิด สวิตช์และพอร์ตยังทำงานได้ปกติ', 3);
INSERT INTO public.choices VALUES ('06753a17-3ed8-431c-b4d1-2ac2b1b3ca13', '3f1df441-85cc-45d3-9b85-504478cb0d29', 'ต้องฟอร์แมตการตั้งค่าของสวิตช์ทั้งหมด', false, 'ผิด ไม่เกี่ยวข้องกับการล้างคอนฟิก', 4);
INSERT INTO public.choices VALUES ('0cd8f17c-31f1-411e-9eb6-5db6d0a077a0', 'bc88461e-fd06-4893-8284-d9a61fcd853b', 'C13/C14 (10A-15A ขาแนวตั้ง) ใช้กับเซิร์ฟเวอร์และสวิตช์ทั่วไป ส่วน C19/C20 (16A-20A หัวสี่เหลี่ยมขาแนวนอน) ใช้กับอุปกรณ์กินไฟสูง เช่น Blade Chassis หรือ Core Switch', true, 'ถูกต้อง C19/C20 มีขนาดใหญ่กว่าและขาเป็นแนวนอนเพื่อรองรับกระแสไฟสูงถึง 16A-20A', 1);
INSERT INTO public.choices VALUES ('5586336d-0c76-413e-9874-e22c428f05a7', 'bc88461e-fd06-4893-8284-d9a61fcd853b', 'C13/C14 ใช้ส่งสัญญาณอินเทอร์เน็ต ส่วน C19/C20 ใช้ส่งสัญญาณภาพออกหน้าจอ', false, 'ผิด ทั้งสองชนิดเป็นหัวปลั๊กสายไฟกำลัง (AC Power Connectors)', 2);
INSERT INTO public.choices VALUES ('4bde56ef-4e56-4767-b870-d56533e3d89f', 'c029cd6e-d453-43e2-9215-ccfdfde2dd1a', 'Recycle Bin Node', false, 'ผิด ไม่ใช่โหนดเชื่อมต่อเครือข่าย', 4);
INSERT INTO public.choices VALUES ('0352d08c-c6cf-4985-91d3-02392e7b4c79', 'bc88461e-fd06-4893-8284-d9a61fcd853b', 'C13/C14 ใช้เฉพาะในทวีปเอเชีย ส่วน C19/C20 ใช้เฉพาะในทวีปแอฟริกา', false, 'ผิด ทั้งคู่เป็นมาตรฐานสากล IEC 60320 ที่ใช้ใน Data Center ทั่วโลก', 3);
INSERT INTO public.choices VALUES ('70115b6c-79ef-4b26-8317-cf87a8549384', 'bc88461e-fd06-4893-8284-d9a61fcd853b', 'ทั้งสองแบบมีรูปร่างและขนาดเท่ากันทุกประการ เสียบแทนกันได้เลย', false, 'ผิด รูปร่างและทิศทางขาต่างกันเพื่อป้องกันการนำสายทนกระแสต่ำไปเสียบอุปกรณ์กินไฟสูง', 4);
INSERT INTO public.choices VALUES ('98929cba-d859-4a68-af3c-dab316bf5125', '5ebf818c-bdc8-4cf2-86d7-b46f7a87c14c', 'เพื่อกั้นไม่ให้ลมร้อนจากด้านหลังตู้แร็คไหลย้อนผ่านช่องว่างวนกลับมาเข้าหน้าเครื่องเซิร์ฟเวอร์ (ป้องกัน Hot Air Recirculation)', true, 'ถูกต้อง Blanking Panel ช่วยรักษาความดันและแยกฝั่งลมเย็นหน้าตู้กับลมร้อนหลังตู้ไม่ให้ปะปนกัน', 1);
INSERT INTO public.choices VALUES ('c24b4edc-8fc7-43c2-9ab3-c0c7677ee2ad', '5ebf818c-bdc8-4cf2-86d7-b46f7a87c14c', 'เพื่อเพิ่มความเร็วของสัญญาณอินเทอร์เน็ตไร้สายในตู้แร็ค', false, 'ผิด ไม่เกี่ยวกับความเร็วสัญญาณไร้สาย', 2);
INSERT INTO public.choices VALUES ('2c19a088-16eb-4c57-beb0-7782f88722e0', '5ebf818c-bdc8-4cf2-86d7-b46f7a87c14c', 'เพื่อใช้เป็นที่วางแก้วน้ำและอาหารของช่างเทคนิค', false, 'ผิด ห้ามนำอาหารและเครื่องดื่มเข้าห้อง Data Hall เด็ดขาด', 3);
INSERT INTO public.choices VALUES ('13bf40cf-64b7-4f39-a06c-8ed24c39c51c', '5ebf818c-bdc8-4cf2-86d7-b46f7a87c14c', 'เพื่อทำให้ตู้แร็คมีน้ำหนักเบาลงเวลาเคลื่อนย้าย', false, 'ผิด การติดแผ่นปิดไม่ได้ทำให้ตู้เบาลง แต่มีไว้ควบคุมทิศทางลม', 4);
INSERT INTO public.choices VALUES ('057678c5-f552-41a4-a1ce-9948a8d30c5b', '197578ef-435e-4bf8-b842-3791da759a4c', 'Speed (Baud rate): 9600, Data bits: 8, Parity: None, Stop bits: 1, Flow control: None (9600-8-N-1)', true, 'ถูกต้อง รหัสจำง่ายคือ 9600-8-N-1 พร้อมปิด Flow control เป็น None', 1);
INSERT INTO public.choices VALUES ('168019b9-1217-40ff-832a-ab7ade0034fa', '197578ef-435e-4bf8-b842-3791da759a4c', 'Port: 80, Protocol: HTTP, Proxy: Enabled', false, 'ผิด นั่นคือการตั้งค่าเว็บเบราว์เซอร์ ไม่ใช่พอร์ต Serial Console', 2);
INSERT INTO public.choices VALUES ('f6771770-5184-40b5-8def-d4e403109a50', '197578ef-435e-4bf8-b842-3791da759a4c', 'Speed: 1,000,000, Data bits: 64, Parity: Even, Stop bits: 10', false, 'ผิด ค่าไม่ตรงมาตรฐานพอร์ต RS-232 Serial จะทำให้หน้าจอขึ้นตัวอักษรขยะอ่านไม่ออก', 3);
INSERT INTO public.choices VALUES ('5a015c8c-6bae-4ed8-b9fd-c251352d7dab', '197578ef-435e-4bf8-b842-3791da759a4c', 'ไม่ต้องตั้งค่าใดๆ เพียงแค่เสียบสายเข้าช่องพอร์ตไฟเลี้ยง PSU', false, 'ผิด ต้องเสียบที่พอร์ต CONSOLE และเปิดโปรแกรม Terminal โหมด Serial', 4);
INSERT INTO public.choices VALUES ('23bab315-b5f7-4488-a4e9-fcd365549a9b', 'a52403ec-d3a6-4da0-9422-08738063d262', 'Core Layer (ชั้นแกนหลัก)', true, 'ถูกต้อง Core Layer เน้นความเร็วสูงสุดและปราศจากกฎคัดกรองที่ซับซ้อน', 1);
INSERT INTO public.choices VALUES ('21c52dad-e7ca-4f26-9d38-bd69f976c51b', 'a52403ec-d3a6-4da0-9422-08738063d262', 'Access Layer', false, 'ผิด Access Layer เป็นจุดที่ต่อเข้ากับผู้ใช้งาน', 2);
INSERT INTO public.choices VALUES ('c274d14b-452d-44d9-9316-1836c632f105', 'a52403ec-d3a6-4da0-9422-08738063d262', 'Distribution Layer', false, 'ผิด Distribution Layer เป็นชั้นที่ทำหน้าที่คัดกรอง ACLs และ Routing', 3);
INSERT INTO public.choices VALUES ('e31905d7-0113-46a5-8e66-ae5292279a2e', 'a52403ec-d3a6-4da0-9422-08738063d262', 'Physical Layer', false, 'ผิด ไม่ใช่ชั้นสถาปัตยกรรมในโมเดล 3-Tier ของ Cisco', 4);
INSERT INTO public.choices VALUES ('a00be04b-0037-41bb-802c-e42c0c1683ad', '0c0e2c5e-3d78-42c0-b521-d904e7ee48b9', 'เพื่อรองรับปริมาณทราฟฟิกแบบ East-West (เซิร์ฟเวอร์คุยกันเอง) ที่พุ่งสูงขึ้น โดยมีระยะทางส่งข้อมูลคงที่เพียง 2 Hops เสมอ และใช้ ECMP เปิดใช้ทุกเส้นทางพร้อมกัน', true, 'ถูกต้อง Spine-Leaf ให้ความหน่วงต่ำคงที่ (Predictable Latency) และไม่พึ่งพา Spanning Tree', 1);
INSERT INTO public.choices VALUES ('5fe29135-3a5b-4418-b2dd-51b9d3bd1f5a', '0c0e2c5e-3d78-42c0-b521-d904e7ee48b9', 'เพื่อลดจำนวนเซิร์ฟเวอร์ที่ต้องติดตั้งในตู้แร็คลงครึ่งหนึ่ง', false, 'ผิด สถาปัตยกรรมเครือข่ายไม่ได้ลดจำนวนเซิร์ฟเวอร์', 2);
INSERT INTO public.choices VALUES ('885f47d3-d0f7-42d5-bd6b-44d09b177676', '0c0e2c5e-3d78-42c0-b521-d904e7ee48b9', 'เพื่อไม่ให้ต้องใช้สายไฟเบอร์ออปติกในศูนย์ข้อมูลอีกต่อไป', false, 'ผิด Spine-Leaf ใช้สายไฟเบอร์ออปติกความเร็วสูงจำนวนมาก', 3);
INSERT INTO public.choices VALUES ('5d97e39d-7ffa-4ba3-be28-7adb5a8af2b9', '0c0e2c5e-3d78-42c0-b521-d904e7ee48b9', 'เพื่ออนุญาตให้บุคคลภายนอกเข้าถึงฐานข้อมูลภายในได้โดยไม่ต้องมีรหัสผ่าน', false, 'ผิด ผิดหลักความปลอดภัยอย่างยิ่ง', 4);
INSERT INTO public.choices VALUES ('e06827a5-8ed8-4d7b-bf16-f01ac5ecaead', 'a8a4e9a3-b5ff-4059-97c5-1ea9fd24f1f4', 'VRRP (Virtual Router Redundancy Protocol)', true, 'ถูกต้อง VRRP เป็นมาตรฐานเปิดสากลสำหรับสร้าง Virtual Gateway สำรอง', 1);
INSERT INTO public.choices VALUES ('0453ed16-4f56-49dd-b344-b86cd3e73b16', 'a8a4e9a3-b5ff-4059-97c5-1ea9fd24f1f4', 'HSRP (Hot Standby Router Protocol)', false, 'ผิด HSRP เป็นโปรโตคอลเฉพาะของ Cisco (Cisco Proprietary)', 2);
INSERT INTO public.choices VALUES ('804ce591-c6fa-43b9-98d9-1514cce2c365', 'a8a4e9a3-b5ff-4059-97c5-1ea9fd24f1f4', 'SNMP (Simple Network Management Protocol)', false, 'ผิด SNMP ใช้สำหรับตรวจวัดและตรวจสอบอุปกรณ์', 3);
INSERT INTO public.choices VALUES ('3a3a220b-fb31-4769-8c11-867e0fffdb4a', 'a8a4e9a3-b5ff-4059-97c5-1ea9fd24f1f4', 'DHCP (Dynamic Host Configuration Protocol)', false, 'ผิด DHCP ใช้สำหรับแจกจ่าย IP Address', 4);
INSERT INTO public.choices VALUES ('65cb2159-27d2-4cef-a3b8-77d2cbd221a6', '58226d42-ba11-4316-b7ed-a5926488badd', 'vPC (Virtual Port Channel) หรือ Multi-Chassis Link Aggregation (MLAG)', true, 'ถูกต้อง vPC/MLAG ช่วยให้ทำ Port Channel ข้ามสองสวิตช์ได้', 1);
INSERT INTO public.choices VALUES ('ca7fd675-b414-4a3e-a0b8-7d3d00c1a4ed', '58226d42-ba11-4316-b7ed-a5926488badd', 'NAT (Network Address Translation)', false, 'ผิด NAT ใช้สำหรับแปลง IP Address', 2);
INSERT INTO public.choices VALUES ('ed14cef7-180b-4e61-b3bf-bae71bd12bd1', '58226d42-ba11-4316-b7ed-a5926488badd', 'DNS Dynamic Update', false, 'ผิด DNS ใช้แปลงชื่อโดเมนเป็น IP', 3);
INSERT INTO public.choices VALUES ('febe1126-4eee-43ee-b0b0-8a56adfb792d', '2078e3ed-e858-4d2a-b8b4-e0ee255ac29c', 'เซิร์ฟเวอร์ที่อยู่ในโซน DMZ ต้องไม่ได้รับอนุญาตให้ริเริ่มสร้างการเชื่อมต่อ (Initiate Connection) เข้าไปยังเครือข่ายภายในองค์กรโดยตรง', true, 'ถูกต้อง ป้องกันไม่ให้แฮกเกอร์ใช้เครื่องใน DMZ ที่ถูกแฮกเป็นฐานเจาะระบบหลังบ้าน', 1);
INSERT INTO public.choices VALUES ('05c660d6-8866-4345-aaed-986dbd5d9c3f', '2078e3ed-e858-4d2a-b8b4-e0ee255ac29c', 'ต้องตั้งรหัสผ่านของเครื่องใน DMZ เป็นคำว่า admin เสมอ', false, 'ผิด รหัสผ่านง่ายเกินไปและอันตรายมาก', 2);
INSERT INTO public.choices VALUES ('afcbc0e2-3e65-4e2e-a8f8-d09f4db3f235', '2078e3ed-e858-4d2a-b8b4-e0ee255ac29c', 'ต้องปิดไฟร์วอลล์ทั้งหมดของโซน DMZ เพื่อให้ทราฟฟิกวิ่งได้เร็ว', false, 'ผิด DMZ ต้องถูกควบคุมด้วยไฟร์วอลล์อย่างเข้มงวด', 3);
INSERT INTO public.choices VALUES ('ac17a637-4021-43e4-bee7-3b6354b6f1f1', '2078e3ed-e858-4d2a-b8b4-e0ee255ac29c', 'ห้ามเชื่อมต่อสายแลนเข้ากับเซิร์ฟเวอร์ใน DMZ เด็ดขาด', false, 'ผิด หากไม่ต่อสายแลน เซิร์ฟเวอร์จะไม่สามารถให้บริการเว็บได้', 4);
INSERT INTO public.choices VALUES ('2348a998-df53-489f-aa70-e440852d104a', 'a727b57c-471f-4098-baa1-0369e65a00ee', 'เป็น Network Simulator (โปรแกรมจำลองพฤติกรรม) ที่กินทรัพยากรเครื่องน้อยมาก แต่รองรับชุดคำสั่งของ Cisco IOS เพียงบางส่วน ไม่ได้รันระบบปฏิบัติการจริง', true, 'ถูกต้อง Packet Tracer เป็น Simulator ที่เขียนโค้ดเลียนแบบคำสั่ง IOS', 1);
INSERT INTO public.choices VALUES ('6ce707ca-c041-4b76-aae1-574fd3641f2e', 'a727b57c-471f-4098-baa1-0369e65a00ee', 'เป็นโปรแกรมแฮกเกอร์สำหรับดักจับรหัสผ่าน Wi-Fi ของเพื่อนบ้าน', false, 'ผิด Packet Tracer เป็นโปรแกรมเพื่อการศึกษาการออกแบบและคอนฟิกเครือข่าย', 2);
INSERT INTO public.choices VALUES ('baa22130-a214-4e91-9da8-13318008d75e', 'a727b57c-471f-4098-baa1-0369e65a00ee', 'เป็นระบบปฏิบัติการเซิร์ฟเวอร์ที่ใช้ติดตั้งบนเครื่องฮาร์ดแวร์จริง', false, 'ผิด Packet Tracer เป็นแอพพลิเคชันซิมูเลเตอร์ ไม่ใช่ OS เซิร์ฟเวอร์', 3);
INSERT INTO public.choices VALUES ('be4892df-8bc8-49dd-b293-c67cbbe2fea4', 'a727b57c-471f-4098-baa1-0369e65a00ee', 'เป็นโปรแกรมตัดต่อวิดีโอของบริษัท Cisco', false, 'ผิด ไม่เกี่ยวข้องกับงานตัดต่อวิดีโอ', 4);
INSERT INTO public.choices VALUES ('c3cc31c9-3b78-4c8c-a005-087a51fbec7c', '06567e5a-aea4-4301-889e-31d49ac89174', 'เวลาในเครือข่ายจะหยุดชั่วคราว ทำให้เห็นซองจดหมาย PDU เคลื่อนที่ทีละก้าว และสามารถคลิกอ่านข้อมูล Header ของ OSI แต่ละเลเยอร์ได้', true, 'ถูกต้อง Simulation Mode ช่วยให้เห็นการทำงานของโปรโตคอลอย่างเป็นขั้นเป็นตอน', 1);
INSERT INTO public.choices VALUES ('22c1e636-8c8e-4495-a260-0932cb898ccc', '06567e5a-aea4-4301-889e-31d49ac89174', 'ทำให้เครื่องคอมพิวเตอร์ที่บ้านเชื่อมต่อไปยังอินเทอร์เน็ตขององค์กร NASA อัตโนมัติ', false, 'ผิด ไม่เกี่ยวข้องกับการเชื่อมต่อภายนอก', 2);
INSERT INTO public.choices VALUES ('7bbc990f-92ef-4265-a0cf-b6f9c6f8171d', '06567e5a-aea4-4301-889e-31d49ac89174', 'ปิดการทำงานของพอร์ตสวิตช์ทั้งหมดในโปรแกรมอย่างถาวร', false, 'ผิด Simulation Mode ไม่ได้ปิดพอร์ต แต่หยุดเวลาเพื่อจำลองการส่งข้อมูล', 3);
INSERT INTO public.choices VALUES ('a4e06c58-47cf-4ef7-8fa5-40fb4ee330b0', '06567e5a-aea4-4301-889e-31d49ac89174', 'ใช้สำหรับส่งอีเมลจริงหาผู้ใช้งานภายนอก', false, 'ผิด เป็นเพียงการจำลองทราฟฟิกภายในโปรแกรม', 4);
INSERT INTO public.choices VALUES ('472f9cb8-fb24-4672-a1b3-9a821d8ad36f', '854a5934-7449-45be-80a5-c32b00b0208c', 'เป็นพฤติกรรมปกติของ Spanning Tree Protocol (STP) ที่กำลังฟังและเรียนรู้สถานะพอร์ต สามารถกดปุ่ม "Fast Forward Time" เพื่อเร่งเวลาให้เป็นสีเขียวทันที', true, 'ถูกต้อง STP ใช้เวลาประมาณ 30-50 วินาที และ Fast Forward Time ช่วยเร่งข้ามขั้นตอนนี้ได้', 1);
INSERT INTO public.choices VALUES ('c4b937af-c9aa-4554-a640-c715b8140070', '854a5934-7449-45be-80a5-c32b00b0208c', 'สายแลนขาดใน ต้องลบสายทิ้งแล้วลากใหม่ 10 รอบ', false, 'ผิด สายไม่ได้ขาด เป็นขั้นตอนการทำงานปกติของ STP', 2);
INSERT INTO public.choices VALUES ('21539ed4-9f5f-45c8-a16d-a9a814992a26', '854a5934-7449-45be-80a5-c32b00b0208c', 'สวิตช์กำลังถูกไวรัสโจมตี ต้องรีบูตคอมพิวเตอร์ทันที', false, 'ผิด สวิตช์ทำงานปกติ', 3);
INSERT INTO public.choices VALUES ('8a759b2a-4dc0-4d99-ae68-f7eff969ade3', '854a5934-7449-45be-80a5-c32b00b0208c', 'โปรแกรม Packet Tracer เกิดข้อผิดพลาดร้ายแรงและต้องติดตั้ง Windows ใหม่', false, 'ผิด เป็นการทำงานที่ถูกต้องตามโปรโตคอลเครือข่าย', 4);
INSERT INTO public.choices VALUES ('1e6462d7-2f38-4b3c-9dda-583a8d99a486', 'a665524c-1dcd-4cb9-af0f-3c7110e65a72', 'Console Cable (สายสีฟ้าอ่อน)', true, 'ถูกต้อง สาย Console เชื่อมระหว่างพอร์ต Serial/USB ของ PC เข้ากับพอร์ต Console ของอุปกรณ์', 1);
INSERT INTO public.choices VALUES ('55780098-80ae-4e0b-a1a2-35867d211a16', 'a665524c-1dcd-4cb9-af0f-3c7110e65a72', 'Coaxial Cable (สายเคเบิลทีวีสีดำ)', false, 'ผิด สาย Coaxial ใช้กับโมเด็มเคเบิล DOCSIS', 2);
INSERT INTO public.choices VALUES ('6e233369-f27a-4b94-8b07-715984d020ab', 'a665524c-1dcd-4cb9-af0f-3c7110e65a72', 'Fiber Optic Cable (สายไฟเบอร์สีส้ม)', false, 'ผิด สายไฟเบอร์ใช้ส่งสัญญาณแสงความเร็วสูง ไม่ใช่สายต่อเข้าพอร์ต Console', 3);
INSERT INTO public.choices VALUES ('97973753-3d11-424a-87a7-7908d2847fcf', 'a665524c-1dcd-4cb9-af0f-3c7110e65a72', 'Phone Cable (สายโทรศัพท์ 2 คอร์)', false, 'ผิด สายโทรศัพท์ใช้กับพอร์ต RJ11 โมเด็ม', 4);
INSERT INTO public.choices VALUES ('99da6faf-5756-479b-9e35-4b760cd071cd', '9f476cd4-a948-43f9-b90d-84b81fd323eb', 'เครื่องปลายทางไฟดับและฮาร์ดดิสก์พัง', false, 'ผิด filtered เกิดจากการบล็อกของอุปกรณ์ความปลอดภัย', 4);
INSERT INTO public.choices VALUES ('3e0bb80f-d9a0-4460-9b34-a7236fa1502e', '1b69be04-7692-4128-a45d-4e898b67651b', 'เป็นไฟล์แบบฝึกหัดกิจกรรม (Activity File) ที่มีระบบตรวจเช็กคะแนนความคืบหน้าอัตโนมัติ (Completion %) และล็อกหน้าต่างข้อสอบไว้', true, 'ถูกต้อง .pka ใช้สำหรับแบบฝึกหัดและข้อสอบแล็บที่มีระบบตรวจให้คะแนนอัตโนมัติ', 1);
INSERT INTO public.choices VALUES ('f50b16a4-0971-4579-b224-3eb5c63e405f', '1b69be04-7692-4128-a45d-4e898b67651b', 'เป็นไฟล์วิดีโอสอนการใช้งานที่เปิดด้วยโปรแกรม Windows Media Player', false, 'ผิด .pka ไม่ใช่ไฟล์วิดีโอ', 2);
INSERT INTO public.choices VALUES ('4fe9fabc-086e-4cd6-8646-6e6ce275d6ba', '1b69be04-7692-4128-a45d-4e898b67651b', 'เป็นไฟล์สำรองข้อมูลของระบบปฏิบัติการ Windows', false, 'ผิด ไม่เกี่ยวข้องกับ OS สำรอง', 3);
INSERT INTO public.choices VALUES ('358225b8-b065-4724-9d77-f38edf43366c', '1b69be04-7692-4128-a45d-4e898b67651b', 'เป็นไฟล์ไวรัสที่ห้ามเปิดเด็ดขาด', false, 'ผิด เป็นไฟล์มาตรฐานของ Cisco Networking Academy', 4);
INSERT INTO public.choices VALUES ('955f0de0-93c2-460b-8440-b92b77c74a65', '568dc972-faec-464f-ad31-e4e8daafcde6', 'Emulator นำระบบปฏิบัติการจริง (Real OS Image) มาบูตทำงานบนฮาร์ดแวร์จำลอง ทำให้ได้ฟังก์ชันและคำสั่งครบถ้วนเหมือนเครื่องจริง 100% ต่างจาก Simulator ที่เพียงแค่เขียนโปรแกรมเลียนแบบคำสั่งบางส่วน', true, 'ถูกต้อง Emulator รันไฟล์อิมเมจของจริง 100%', 1);
INSERT INTO public.choices VALUES ('0376c5a6-a701-47d6-a525-ea083e7b3114', '568dc972-faec-464f-ad31-e4e8daafcde6', 'Simulator สามารถรันบนมือถือได้ แต่ Emulator รันได้เฉพาะบนเครื่องคิดเลข', false, 'ผิด ไม่เกี่ยวข้องกัน', 2);
INSERT INTO public.choices VALUES ('9e4f1a96-1370-4431-a0ad-00036bcb6b79', '568dc972-faec-464f-ad31-e4e8daafcde6', 'Emulator ใช้งานได้เฉพาะเมื่อไม่มีอินเทอร์เน็ต', false, 'ผิด สามารถต่อออกเน็ตจริงผ่าน Cloud Node ได้', 3);
INSERT INTO public.choices VALUES ('89940447-32e3-4b7e-be74-d3a9a8c6c6c0', '568dc972-faec-464f-ad31-e4e8daafcde6', 'ทั้งสองแบบทำงานเหมือนกันทุกประการ ต่างกันแค่ชื่อบริษัทผู้ผลิต', false, 'ผิด สถาปัตยกรรมเบื้องหลังและการใช้ทรัพยากรต่างกันอย่างสิ้นเชิง', 4);
INSERT INTO public.choices VALUES ('6729c3c1-62ee-46c5-83b9-4c34e99e56c7', 'bab6c130-fd6a-4bcd-b882-377783f5af02', 'เพื่อลดการใช้งาน CPU ของคอมพิวเตอร์ไม่ให้พุ่งขึ้น 100% เมื่อเราเตอร์อยู่ในสถานะว่างงาน (Idle)', true, 'ถูกต้อง Idle-PC คือจุดคำนวณรอบลูปว่างเพื่อหยุดการกิน CPU สูงเกินจำเป็น', 1);
INSERT INTO public.choices VALUES ('99fcd1cf-18d7-426c-8f93-06403743789f', 'bab6c130-fd6a-4bcd-b882-377783f5af02', 'เพื่อเปลี่ยนรหัสผ่านของผู้ดูแลระบบให้เป็นค่าเริ่มต้น', false, 'ผิด ไม่เกี่ยวกับการตั้งรหัสผ่าน', 2);
INSERT INTO public.choices VALUES ('b9978f78-e770-456a-8435-bc3926561ee0', 'bab6c130-fd6a-4bcd-b882-377783f5af02', 'เพื่อเพิ่มความเร็วในการดาวน์โหลดไฟล์จากอินเทอร์เน็ตเป็น 10 Gbps', false, 'ผิด ไม่เกี่ยวข้องกับความเร็วเน็ต', 3);
INSERT INTO public.choices VALUES ('ac674a9a-9d61-4e2f-a232-febaf3f4f629', 'bab6c130-fd6a-4bcd-b882-377783f5af02', 'เพื่อสั่งปิดหน้าจอคอมพิวเตอร์เมื่อไม่ได้ขยับเมาส์', false, 'ผิด นั่นคือฟังก์ชัน Sleep ของระบบปฏิบัติการ', 4);
INSERT INTO public.choices VALUES ('211bfe3d-25a8-4b3d-928b-de9851ce1372', 'f01fc036-5329-41fe-9b18-f53eb57ef654', 'เพราะ GNS3 VM ทำงานบน Linux Kernel ที่รองรับเทคโนโลยี KVM/QEMU, IOU และ Docker ได้เสถียรและมีประสิทธิภาพสูงกว่าการรันบน Windows โดยตรง', true, 'ถูกต้อง Linux VM จัดการ IOU, QEMU และ Virtualization ได้ดีกว่า Windows มาก', 1);
INSERT INTO public.choices VALUES ('d6bc3c44-8d0e-494b-b82e-f1e16f944ea6', 'f01fc036-5329-41fe-9b18-f53eb57ef654', 'เพราะถ้าไม่ใช้ GNS3 VM โปรแกรมจะบังคับให้จ่ายเงินรายเดือน', false, 'ผิด GNS3 เป็นซอฟต์แวร์โอเพนซอร์สฟรี', 2);
INSERT INTO public.choices VALUES ('46729f53-071c-4bdc-8af5-d5c625306f7f', 'f01fc036-5329-41fe-9b18-f53eb57ef654', 'เพราะ GNS3 VM ช่วยป้องกันไม่ให้คีย์บอร์ดเสีย', false, 'ผิด ไม่เกี่ยวข้องกัน', 3);
INSERT INTO public.choices VALUES ('79d1f6a7-7b17-4996-ac10-11e5ad9c7066', 'f01fc036-5329-41fe-9b18-f53eb57ef654', 'เพราะ GNS3 VM สามารถผลิตกระแสไฟฟ้าสำรองให้คอมพิวเตอร์ได้', false, 'ผิด VM เป็นซอฟต์แวร์เสมือน ไม่ใช่ฮาร์ดแวร์จ่ายไฟ', 4);
INSERT INTO public.choices VALUES ('ec039b3b-7f23-4a46-9320-d753de2394f8', '09b67e70-88d1-4ad7-8214-29e1433c3b30', 'คลิกขวาที่เส้นสายเคเบิลแล้วเลือก "Start Capture" เพื่อเปิดโปรแกรม Wireshark ดักจับแพ็กเก็ตสดบนสายเส้นนั้นทันที', true, 'ถูกต้อง GNS3 สามารถเรียก Wireshark มาดักจับทราฟฟิกสดบนสายเชื่อมต่อได้ทันที', 1);
INSERT INTO public.choices VALUES ('0a69b4fd-ed77-415b-9191-3c7dfe9aa27f', '09b67e70-88d1-4ad7-8214-29e1433c3b30', 'ใช้กล้องถ่ายรูปส่องไปที่หน้าจอคอมพิวเตอร์', false, 'ผิด ไม่ใช่วิธีการทางเทคนิคในการดักจับแพ็กเก็ต', 2);
INSERT INTO public.choices VALUES ('08eba91b-1205-4868-add8-c95693c967d4', '09b67e70-88d1-4ad7-8214-29e1433c3b30', 'ถอดปลั๊กไฟคอมพิวเตอร์ออกแล้วเสียบใหม่', false, 'ผิด การตัดไฟไม่ช่วยตรวจสอบแพ็กเก็ต', 3);
INSERT INTO public.choices VALUES ('d8391303-5428-4e71-bdec-8f9db2550621', '09b67e70-88d1-4ad7-8214-29e1433c3b30', 'สั่งลบโฟลเดอร์ System32 ออกจากระบบ', false, 'ผิด อันตรายมากและทำให้ระบบเสียหาย', 4);
INSERT INTO public.choices VALUES ('e7a013c0-de90-41f0-8179-fe9774cbf7ca', 'c029cd6e-d453-43e2-9215-ccfdfde2dd1a', 'Cloud Node หรือ NAT Node', true, 'ถูกต้อง Cloud / NAT Node ทำหน้าที่เชื่อมต่อโลกเสมือนในแล็บเข้ากับเครือข่ายจริง', 1);
INSERT INTO public.choices VALUES ('fc6e8913-ff0c-4ee9-9558-7fab81ae6a62', 'c029cd6e-d453-43e2-9215-ccfdfde2dd1a', 'Power Supply Node', false, 'ผิด ไม่มีโหนดชนิดนี้ใน GNS3', 2);
INSERT INTO public.choices VALUES ('17944d99-cb1b-49ac-8566-29bccf610b82', 'c029cd6e-d453-43e2-9215-ccfdfde2dd1a', 'Audio Speaker Node', false, 'ผิด ไม่เกี่ยวกับการส่งต่อทราฟฟิกเครือข่าย', 3);
INSERT INTO public.choices VALUES ('a655791b-1b30-44b0-99c0-67ac45719feb', '5f156ae1-1e17-450b-8749-f9e0c3e70abd', 'Capture Filter ใช้คัดกรองตั้งแต่ก่อนบันทึกข้อมูล (ทราฟฟิกที่ไม่ตรงจะถูกทิ้งทันที) ส่วน Display Filter ใช้กรองซ่อน/แสดงผลข้อมูลหลังจากที่ดักจับมาแล้ว', true, 'ถูกต้อง Capture Filter กรองก่อนบันทึกลงไฟล์ ส่วน Display Filter กรองการแสดงผลบนหน้าจอ', 1);
INSERT INTO public.choices VALUES ('8aef92ec-ce44-4bed-af33-108dd28ad767', '5f156ae1-1e17-450b-8749-f9e0c3e70abd', 'Capture Filter ใช้บน Windows เท่านั้น ส่วน Display Filter ใช้บน Mac เท่านั้น', false, 'ผิด ทั้งสองฟิลเตอร์ใช้งานได้บนทุกระบบปฏิบัติการ', 2);
INSERT INTO public.choices VALUES ('ee66a1d3-b116-4899-8375-c6a110ec5abc', '5f156ae1-1e17-450b-8749-f9e0c3e70abd', 'Capture Filter กรองเฉพาะไวรัส ส่วน Display Filter กรองเฉพาะรูปภาพ', false, 'ผิด ทั้งสองใช้กรองแพ็กเก็ตเครือข่ายตามเงื่อนไขที่กำหนด', 3);
INSERT INTO public.choices VALUES ('2c3ab31c-beee-4120-bf5b-d01a94f327bd', '5f156ae1-1e17-450b-8749-f9e0c3e70abd', 'ทั้งสองแบบมีไวยากรณ์และหน้าที่เหมือนกันทุกประการ ใช้แทนกันได้เสมอ', false, 'ผิด ไวยากรณ์และสถาปัตยกรรมการทำงานต่างกันอย่างสิ้นเชิง', 4);
INSERT INTO public.choices VALUES ('01764999-e971-4fec-9d1c-98d5d2ceec18', '41b6c586-ddea-48bd-82a2-898b85af31b7', 'tcp.analysis.retransmission', true, 'ถูกต้อง เป็นฟิลเตอร์วิเคราะห์การส่งแพ็กเก็ตซ้ำของ Wireshark', 1);
INSERT INTO public.choices VALUES ('2ad0f938-1d25-4479-a1c8-962342f6371b', '41b6c586-ddea-48bd-82a2-898b85af31b7', 'ip.delete.all', false, 'ผิด ไม่มีคำสั่งนี้ใน Wireshark', 2);
INSERT INTO public.choices VALUES ('611b1e16-2f20-48b1-86fe-5e1fd0942862', '41b6c586-ddea-48bd-82a2-898b85af31b7', 'ping -t 8.8.8.8', false, 'ผิด นั่นเป็นคำสั่งทดสอบในคอมมานด์ไลน์', 3);
INSERT INTO public.choices VALUES ('84ef8ce6-0761-4bd8-b92c-6f42fd009ca1', '41b6c586-ddea-48bd-82a2-898b85af31b7', 'show run | include retransmit', false, 'ผิด นั่นเป็นคำสั่งบน Cisco IOS', 4);
INSERT INTO public.choices VALUES ('c15f3706-0838-4836-9268-8eab8288759c', '6d0e94d0-a2a7-44fc-9f1d-476523f2d61e', 'รวมแพ็กเก็ตทั้งหมดของเซสชันนั้นมาประกอบเป็นบทสนทนาต่อเนื่องในหน้าต่างเดียว ทำให้อ่านเนื้อหา HTTP Request/Response ได้อย่างครบถ้วน', true, 'ถูกต้อง Follow TCP Stream ช่วยให้เห็นบทสนทนาของ Application Layer ทั้งหมดได้ทันที', 1);
INSERT INTO public.choices VALUES ('48996b35-17ca-44da-bb7e-a959af7415e0', '6d0e94d0-a2a7-44fc-9f1d-476523f2d61e', 'ส่งสัญญาณเสียงไซเรนเตือนไปยังห้องผู้บริหารเมื่อเซิร์ฟเวอร์ล่ม', false, 'ผิด ไม่ใช่ฟังก์ชันเตือนภัยด้วยเสียงไซเรน', 2);
INSERT INTO public.choices VALUES ('bc752100-ffaf-4853-9b75-1160e92a4672', '6d0e94d0-a2a7-44fc-9f1d-476523f2d61e', 'สั่งเปลี่ยนรหัสผ่าน Wi-Fi ของเราเตอร์โดยอัตโนมัติ', false, 'ผิด Wireshark เป็นเครื่องมือดักจับ ไม่ใช่โปรแกรมเปลี่ยนรหัสผ่าน', 3);
INSERT INTO public.choices VALUES ('ad40e788-a67c-43c9-92e3-e8e6fb893726', '6d0e94d0-a2a7-44fc-9f1d-476523f2d61e', 'เพิ่มความเร็วแบนด์วิดท์ของสายแลนให้เป็นสองเท่า', false, 'ผิด โปรแกรมดักจับไม่ได้เพิ่มความเร็วฮาร์ดแวร์', 4);
INSERT INTO public.choices VALUES ('305db9c9-2dde-4547-ba39-0e6d23d83c24', 'd135eb3b-8119-4b9e-a8a7-d02cbe474d93', 'บัฟเฟอร์ขารับ (Receive Buffer) ของเครื่องปลายทางเต็มจนไม่สามารถรับข้อมูลเพิ่มได้ จึงสั่งให้เครื่องต้นทางหยุดส่งข้อมูลชั่วคราว', true, 'ถูกต้อง ZeroWindow แสดงว่าเครื่องฝั่งรับประมวลผลข้อมูลไม่ทันจนบัฟเฟอร์เต็ม', 1);
INSERT INTO public.choices VALUES ('5369307e-a628-4b92-bf4e-bec0a9f12738', 'd135eb3b-8119-4b9e-a8a7-d02cbe474d93', 'ระบบปฏิบัติการ Windows ถูกลบออกจากเครื่องแล้ว', false, 'ผิด ไม่เกี่ยวกับการลบ OS', 2);
INSERT INTO public.choices VALUES ('21f2e567-4c91-4000-947d-3580fb21eae5', 'd135eb3b-8119-4b9e-a8a7-d02cbe474d93', 'ความเร็วในการพิมพ์คีย์บอร์ดของช่างเทคนิคช้าเกินไป', false, 'ผิด ไม่เกี่ยวกับความเร็วการพิมพ์', 3);
INSERT INTO public.choices VALUES ('eeb058fc-b2ed-4321-ac1d-a051840c7392', 'd135eb3b-8119-4b9e-a8a7-d02cbe474d93', 'สายไฟเบอร์ออปติกถูกหนูกัดขาด', false, 'ผิด ถ้าสายขาดจะไม่สามารถส่งแพ็กเก็ต TCP แจ้งเตือนสถานะ ZeroWindow ได้', 4);
INSERT INTO public.choices VALUES ('8a02ebd3-aef7-4a6d-ae13-f68765024bf6', '6d64dc59-ddea-4533-8979-6b8ea6f9f142', 'ข้อผิดพลาดของโพรโทคอล TCP (เช่น TCP Reset, Retransmission หรือ Connection Refused)', true, 'ถูกต้อง สีดำตัวหนังสือแดงคือสัญญาณเตือนของ TCP Error ชัดเจน', 1);
INSERT INTO public.choices VALUES ('31deeac5-25a1-4e48-b820-da449bd18808', '6d64dc59-ddea-4533-8979-6b8ea6f9f142', 'แพ็กเก็ตส่งเพลง MP3 คุณภาพสูง', false, 'ผิด ไม่ใช่การระบายสีไฟล์เพลง', 2);
INSERT INTO public.choices VALUES ('b61e85f6-23cb-463c-a453-99326a9d0c7c', '6d64dc59-ddea-4533-8979-6b8ea6f9f142', 'เซิร์ฟเวอร์ได้รับโบนัสประจำปี', false, 'ผิด ไม่เกี่ยวข้องกับข้อมูลบุคคล', 3);
INSERT INTO public.choices VALUES ('144c831e-9cac-4b7b-ab78-4a0c4eaae845', '6d64dc59-ddea-4533-8979-6b8ea6f9f142', 'การเชื่อมต่อสำเร็จ 100% ปราศจากข้อผิดพลาดใดๆ', false, 'ผิด การเชื่อมต่อปกติมักเป็นสีเขียว ฟ้า หรือเทา ไม่ใช่สีดำแดง', 4);
INSERT INTO public.choices VALUES ('7cdd3339-f489-4a4e-afdb-d2299fb368c5', '9f476cd4-a948-43f9-b90d-84b81fd323eb', 'มีไฟร์วอลล์หรือกฎ ACL บล็อกทราฟฟิกไว้ ทำให้แพ็กเก็ตไปไม่ถึงหรือถูกปิดกั้นการตอบกลับ', true, 'ถูกต้อง สถานะ filtered คือสัญญาณชัดเจนว่าติด Firewall', 1);
INSERT INTO public.choices VALUES ('52ff1d9f-aa26-45b9-97e0-8419b3994059', '9f476cd4-a948-43f9-b90d-84b81fd323eb', 'พอร์ตนั้นเปิดให้บริการปกติและพร้อมรับการเชื่อมต่อ', false, 'ผิด นั่นคือนิยามของสถานะ open', 2);
INSERT INTO public.choices VALUES ('39130a8f-79f2-43a0-8622-e05f200f4e7a', '9f476cd4-a948-43f9-b90d-84b81fd323eb', 'พอร์ตนั้นไม่มีบริการใดเปิดอยู่และเครื่องปลายทางตอบกลับด้วย TCP RST', false, 'ผิด นั่นคือนิยามของสถานะ closed', 3);
INSERT INTO public.choices VALUES ('51ab3509-9b3a-450b-867d-80fde39613dc', 'e4a1fbaa-6e2c-410a-90ac-765d08fe8cac', 'ไม่ทำกระบวนการ 3-Way Handshake ให้เสร็จสมบูรณ์ (ส่ง RST ตัดทันทีเมื่อได้รับ SYN-ACK) จึงทำงานได้รวดเร็วและไม่ถูกบันทึกลง Application Log ของบริการส่วนใหญ่', true, 'ถูกต้อง SYN Scan เป็นเทคนิค Half-open ที่รวดเร็วและหลบเลี่ยงการบันทึก Log ระดับแอป', 1);
INSERT INTO public.choices VALUES ('7ab62622-4d09-4391-8697-b36473207f34', 'e4a1fbaa-6e2c-410a-90ac-765d08fe8cac', 'สามารถกู้คืนรหัสผ่านของผู้ดูแลระบบออกมาเป็นไฟล์ข้อความได้', false, 'ผิด Nmap เป็นตัวสแกนพอร์ต ไม่ใช่โปรแกรมถอดรหัสผ่าน', 2);
INSERT INTO public.choices VALUES ('7eff2f46-92c0-4dab-9ecd-474a7f610b06', 'e4a1fbaa-6e2c-410a-90ac-765d08fe8cac', 'ช่วยลดอุณหภูมิความร้อนของชิป CPU ในเครื่องเซิร์ฟเวอร์', false, 'ผิด ไม่เกี่ยวข้องกับอุณหภูมิฮาร์ดแวร์', 3);
INSERT INTO public.choices VALUES ('7a19a339-f94c-493d-af60-4ca95f14d053', 'e4a1fbaa-6e2c-410a-90ac-765d08fe8cac', 'ใช้งานได้โดยไม่ต้องมีสิทธิ์ Root หรือ Administrator', false, 'ผิด SYN Scan ต้องสร้าง Raw Socket จึงต้องใช้สิทธิ์ Root/Admin', 4);
INSERT INTO public.choices VALUES ('2484f0b2-1b0e-4664-96e6-b3d6140c5786', '73ff1c39-1bb8-4053-906a-d70a3304293d', 'เพราะ iPerf3 สร้างข้อมูลสังเคราะห์บน RAM โดยตรง จึงไม่ติดคอขวดที่ความเร็วอ่านเขียนฮาร์ดดิสก์ (Disk I/O) เหมือนการก๊อปปี้ไฟล์ทั่วไป', true, 'ถูกต้อง ขจัดคอขวดด้าน Disk I/O ทำให้เห็นประสิทธิภาพเครือข่ายที่แท้จริง', 1);
INSERT INTO public.choices VALUES ('4bcd4f75-7c4c-49d0-adb4-c5c23ccaecc5', '73ff1c39-1bb8-4053-906a-d70a3304293d', 'เพราะ iPerf3 เปลี่ยนสายแลนธรรมดาให้กลายเป็นสายเคเบิลทองคำ', false, 'ผิด ซอฟต์แวร์ไม่สามารถเปลี่ยนวัสดุทางกายภาพของสายได้', 2);
INSERT INTO public.choices VALUES ('1b77d9c6-ae3f-49ee-8eab-93bac57b04d1', '73ff1c39-1bb8-4053-906a-d70a3304293d', 'เพราะ iPerf3 บังคับให้ผู้ให้บริการอินเทอร์เน็ตลดราคาค่าบริการลง 50%', false, 'ผิด ไม่เกี่ยวกับการคิดค่าบริการ', 3);
INSERT INTO public.choices VALUES ('b3eccee7-e9a4-4bd2-b08a-69e64213d74c', '73ff1c39-1bb8-4053-906a-d70a3304293d', 'เพราะ iPerf3 วัดผลได้เฉพาะบนระบบเครือข่ายไร้สาย 5G เท่านั้น', false, 'ผิด ใช้งานได้กับเครือข่ายทุกประเภททั้งสายและไร้สาย', 4);
INSERT INTO public.choices VALUES ('74358cf5-2d86-4b22-bea7-32d28fab4f1a', 'ba52ae68-c043-400b-acaf-37a707acee39', 'ค่าความสั่นไหวของเวลาหน่วง (Jitter) และอัตราการสูญหายของแพ็กเก็ต (Packet Loss Percentage)', true, 'ถูกต้อง โหมด UDP ใน iPerf3 รายงานทั้งค่า Jitter (ms) และ Packet Loss (%)', 1);
INSERT INTO public.choices VALUES ('51fa993d-534f-4d86-b853-a048b4731481', 'ba52ae68-c043-400b-acaf-37a707acee39', 'ราคากลางของเครื่องโทรศัพท์ IP Phone ในท้องตลาด', false, 'ผิด ไม่ใช่ข้อมูลทางการค้า', 2);
INSERT INTO public.choices VALUES ('11905cca-e7ac-4a30-8ce7-47707ee29c55', 'ba52ae68-c043-400b-acaf-37a707acee39', 'หมายเลขบัตรประชาชนของพนักงานในออฟฟิศ', false, 'ผิด ไม่เกี่ยวข้องกับข้อมูลส่วนบุคคล', 3);
INSERT INTO public.choices VALUES ('238d29ef-87ea-4e00-888c-b4c77e6baa68', 'ba52ae68-c043-400b-acaf-37a707acee39', 'ความดังของเสียงเรียกเข้าลำโพง', false, 'ผิด iPerf3 วัดประสิทธิภาพระดับแพ็กเก็ตเครือข่าย', 4);
INSERT INTO public.choices VALUES ('082d5c6c-0f33-418a-b073-6a7f38fefde3', '2dabfa05-a324-432d-ae60-5c73846c9e73', 'พบค่า Loss % สูงขึ้นที่ Hop นั้น และตัวเลขการสูญหายยังคงปรากฏต่อเนื่องในทุก Hop ถัดไปจนถึงปลายทาง', true, 'ถูกต้อง Loss ที่แท้จริงต้องส่งผลกระทบต่อเนื่องไปจนถึงโหนดปลายทาง', 1);
INSERT INTO public.choices VALUES ('9b6a63ed-7d9d-42a4-8f8e-67640e1c1ed3', '2dabfa05-a324-432d-ae60-5c73846c9e73', 'ตัวเลข Hop เปลี่ยนเป็นสีชมพูทั้งหมด', false, 'ผิด โปรแกรมไม่ได้เปลี่ยนเป็นสีชมพู', 2);
INSERT INTO public.choices VALUES ('75c52e56-7225-42af-8dd9-46888abbcf07', '2dabfa05-a324-432d-ae60-5c73846c9e73', 'หน้าจอคอมพิวเตอร์ดับและเปิดไม่ติดอีกเลย', false, 'ผิด ไม่เกี่ยวข้องกับจอภาพดับ', 3);
INSERT INTO public.choices VALUES ('3812ac76-529f-4628-9109-a47e722c4214', '2dabfa05-a324-432d-ae60-5c73846c9e73', 'ค่า Worst Latency เท่ากับ 0 ms ทุกช่อง', false, 'ผิด ค่า 0 ms แปลว่าไม่มีความหน่วงเลย', 4);
INSERT INTO public.choices VALUES ('8c2f2b3d-c688-444d-b236-f815af95bc47', 'b09a3292-b282-4bd5-b1bc-9c369e87d4b5', 'ช่วยให้คำสั่งที่พิมพ์เพียงครั้งเดียวถูกส่งไปรันบนทุกแท็บเทอร์มินัลที่เปิดอยู่พร้อมกันในเวลาเดียวกัน', true, 'ถูกต้อง Multi-Execution ส่งคำสั่งออกไปทุกหน้าต่างพร้อมกัน', 1);
INSERT INTO public.choices VALUES ('85d41a91-bdfa-4f16-b3a9-48ee3bec470e', 'b09a3292-b282-4bd5-b1bc-9c369e87d4b5', 'ช่วยเพิ่มความเร็วรอบพัดลมระบายความร้อนของโน้ตบุ๊ก', false, 'ผิด ไม่เกี่ยวข้องกับพัดลมเครื่อง', 2);
INSERT INTO public.choices VALUES ('771b98c9-3511-4d4e-ab4a-b7cca22f4212', 'b09a3292-b282-4bd5-b1bc-9c369e87d4b5', 'สั่งรีสตาร์ทเราเตอร์ของบริษัทอื่นโดยไม่ต้องใส่รหัสผ่าน', false, 'ผิด ผิดทั้งหลักการทำงานและความปลอดภัย', 3);
INSERT INTO public.choices VALUES ('d89840b4-879f-4cd0-a96f-401d05793880', 'b09a3292-b282-4bd5-b1bc-9c369e87d4b5', 'เปลี่ยนภาษาของแป้นพิมพ์จากภาษาไทยเป็นภาษาอังกฤษอัตโนมัติ', false, 'ผิด ไม่ใช่ฟังก์ชันของ Multi-Execution', 4);
INSERT INTO public.choices VALUES ('e99c79cf-2e53-43d0-8d3a-f33a8e56bf20', '2a6d2840-cad2-417a-99c9-0819e078bee2', 'Device Manager (ตัวจัดการอุปกรณ์) ภายใต้หมวดหมู่ Ports (COM & LPT)', true, 'ถูกต้อง Device Manager แสดงรายการฮาร์ดแวร์และหมายเลข COM Port จริง', 1);
INSERT INTO public.choices VALUES ('92a0c784-8fdc-49ec-be50-6e0668aa1e9e', '2a6d2840-cad2-417a-99c9-0819e078bee2', 'Recycle Bin (ถังขยะของระบบ)', false, 'ผิด ถังขยะมีไว้เก็บไฟล์ที่ถูกลบ', 2);
INSERT INTO public.choices VALUES ('8bf13937-f0da-41b3-8548-a740d977f635', '2a6d2840-cad2-417a-99c9-0819e078bee2', 'โปรแกรม Paint', false, 'ผิด Paint เป็นโปรแกรมวาดภาพ', 3);
INSERT INTO public.choices VALUES ('84a3116c-2019-4981-8380-4620dc070ade', '2a6d2840-cad2-417a-99c9-0819e078bee2', 'หน้าจอแสดงภาพพักหน้าจอ (Screensaver)', false, 'ผิด ไม่เกี่ยวข้องกับฮาร์ดแวร์', 4);
INSERT INTO public.choices VALUES ('e302c3e9-3075-4604-85e8-250341d9615b', 'fbf79fd2-d9f5-4d67-ae52-1d301301aa23', 'เปิดแสดงผลหน้าต่างกราฟิก (GUI) ของแอปพลิเคชันจาก Linux Server ข้ามมาแสดงบนหน้าจอ Windows ผ่านช่องทาง SSH ได้โดยตรง', true, 'ถูกต้อง X11 Forwarding ช่วยให้เปิดโปรแกรมกราฟิกของ Linux บน Windows ได้', 1);
INSERT INTO public.choices VALUES ('e660af64-5984-497e-91a0-076ea65fc4f8', 'fbf79fd2-d9f5-4d67-ae52-1d301301aa23', 'สั่งให้สายไฟเบอร์ออปติกเปลี่ยนเป็นสายแลนทองแดง', false, 'ผิด เป็นไปไม่ได้ในทางกายภาพ', 2);
INSERT INTO public.choices VALUES ('e7a37cb0-ed21-47a2-bdf5-a08d80be4b75', 'fbf79fd2-d9f5-4d67-ae52-1d301301aa23', 'แปลงไฟล์รูปภาพให้เป็นไฟล์เสียง MP3', false, 'ผิด ไม่เกี่ยวข้องกับการแปลงไฟล์มีเดีย', 3);
INSERT INTO public.choices VALUES ('76a89b54-ded2-4054-8ce1-ef1e08ca5f32', 'fbf79fd2-d9f5-4d67-ae52-1d301301aa23', 'ปิดระบบไฟฟ้าของตึกสำนักงานจากระยะไกล', false, 'ผิด X11 เป็นระบบแสดงผลกราฟิกของระบบ Unix/Linux', 4);
INSERT INTO public.choices VALUES ('b3477c16-1455-4542-83fd-55ec832830c4', '064b4c09-3817-47a7-887d-304df38cb2a2', 'SFTP (SSH File Transfer Protocol) บนพอร์ต TCP 22', true, 'ถูกต้อง SFTP ทำงานผ่านการเข้ารหัสของ SSH พอร์ต 22', 1);
INSERT INTO public.choices VALUES ('0cfcbe6e-577c-4bc8-a243-7c40b3c7381a', '064b4c09-3817-47a7-887d-304df38cb2a2', 'HTTP ธรรมดาบนพอร์ต TCP 80', false, 'ผิด พอร์ต 80 เป็นเว็บแบบไม่เข้ารหัส', 2);
INSERT INTO public.choices VALUES ('0e5739a6-6c75-4324-8563-de05608a268a', '064b4c09-3817-47a7-887d-304df38cb2a2', 'Telnet บนพอร์ต TCP 23', false, 'ผิด Telnet เป็นข้อความธรรมดาไม่ปลอดภัย', 3);
INSERT INTO public.choices VALUES ('892342ca-8316-4972-9a7a-88c13d017efa', '064b4c09-3817-47a7-887d-304df38cb2a2', 'DNS บนพอร์ต UDP 53', false, 'ผิด พอร์ต 53 ใช้สำหรับค้นหาชื่อโดเมน', 4);
INSERT INTO public.choices VALUES ('c2ce9cba-729a-4511-8f0a-114d30be64e8', '903470ef-ea5f-4fdf-9738-2d4c4feb90fa', 'มีแถบ SFTP Browser ฝังในตัวทางด้านซ้าย ช่วยให้ลากวางไฟล์และดับเบิลคลิกแก้ไขไฟล์คอนฟิกได้ทันทีโดยไม่ต้องเปิดโปรแกรมอื่นเพิ่ม', true, 'ถูกต้อง Embedded SFTP Browser คือจุดเด่นที่สะดวกที่สุดของ MobaXterm', 1);
INSERT INTO public.choices VALUES ('6f3fa1c2-e4fc-499f-8519-10701da67450', '903470ef-ea5f-4fdf-9738-2d4c4feb90fa', 'แจกเงินคริปโตเคอร์เรนซีฟรีทุกครั้งที่ล็อกอิน', false, 'ผิด ไม่เกี่ยวข้องกับเงินคริปโต', 2);
INSERT INTO public.choices VALUES ('23aebc3c-d103-48d1-a21b-a4d076635063', '903470ef-ea5f-4fdf-9738-2d4c4feb90fa', 'ล้างประวัติอาชญากรรมของผู้ใช้งานออกจากระบบ', false, 'ผิด ไม่เกี่ยวข้องกัน', 3);
INSERT INTO public.choices VALUES ('a9e92d13-96d5-401d-8b29-cd154979d06c', '903470ef-ea5f-4fdf-9738-2d4c4feb90fa', 'บังคับให้เซิร์ฟเวอร์เปลี่ยนภาษาเครื่องเป็นภาษาเยอรมัน', false, 'ผิด ภาษาของเซิร์ฟเวอร์ขึ้นอยู่กับ locale ที่ตั้งค่าไว้', 4);


--
-- Data for Name: flashcards; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.flashcards VALUES ('d1a10001-0000-0000-0000-000000000002', 'linux:fc:journalctl-follow', 1, 'b1a10001-0000-0000-0000-000000000002', 'คำสั่งติดตาม System Log ของ Service nginx แบบ Real-time', 'journalctl -u nginx -f', 'พารามิเตอร์ -f ย่อมาจาก follow', 2, '2026-11-03 09:22:14.247234+00', '2026-11-03 09:22:14.247234+00');
INSERT INTO public.flashcards VALUES ('d1a10001-0000-0000-0000-000000000003', 'linux:fc:df-h-inode', 1, 'b1a10001-0000-0000-0000-000000000005', 'คำสั่งดูพื้นที่ดิสก์ที่เหลืออยู่แบบ Human-Readable และตรวจ Inode', 'df -h  (ดูพื้นที่ GB/MB)\ndf -i  (ดูจำนวน Inode ที่เหลือ)', 'h ย่อมาจาก Human-readable, i ย่อมาจาก Inode', 3, '2026-11-03 09:22:14.247234+00', '2026-11-03 09:22:14.247234+00');
INSERT INTO public.flashcards VALUES ('d1a10001-0000-0000-0000-000000000004', 'network:fc:refused-vs-timeout', 2, '3ff8610b-94c3-43a7-8e1f-436f27946647', 'ความแตกต่างระหว่าง Connection Refused กับ Connection Timed Out', 'Connection Refused: แพ็กเก็ตไปถึง แต่ปลายทางไม่มี Service เปิดฟัง หรือ Firewall ปฏิเสธ (TCP RST)\n\nConnection Timed Out: แพ็กเก็ตส่งไปแล้วไม่มีการตอบกลับ มักโดน Firewall ดรอปเงียบๆ หรือ Routing ขาด', 'Refused = ปลายทางปฏิเสธกลับมา, Timeout = รอจนหมดเวลา', 1, '2026-11-03 09:22:14.247234+00', '2026-11-03 09:22:14.247234+00');
INSERT INTO public.flashcards VALUES ('d1a10001-0000-0000-0000-000000000005', 'network:fc:well-known-ports', 2, '3ff8610b-94c3-43a7-8e1f-436f27946647', 'Well-known Port: DNS, SSH, HTTPS, PostgreSQL', 'DNS: 53 (UDP/TCP)\nSSH: 22\nHTTPS: 443\nPostgreSQL: 5432', 'Postgres ลงท้ายด้วย 32', 2, '2026-11-03 09:22:14.247234+00', '2026-11-03 09:22:14.247234+00');
INSERT INTO public.flashcards VALUES ('6bf81206-4699-4eff-aaf2-6484dc9497e4', 'docker:01-container-basics:fc01', 5, 'cf0d4598-1c64-4a7f-b8c9-d6a18307a0f9', 'docker ps กับ docker ps -a ต่างกันอย่างไร?', 'docker ps: แสดงเฉพาะ Container ที่กำลังรันอยู่ (Running)
docker ps -a: แสดง Container ทั้งหมด รวมทั้งตัวที่หยุดทำงานหรือแครช (Exited/Stopped)', 'Running only vs All containers', 1, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('3c9d63db-b144-4a94-8258-aac6b0460cda', 'docker:01-container-basics:fc02', 5, 'cf0d4598-1c64-4a7f-b8c9-d6a18307a0f9', 'คำสั่งใดใช้ติดตาม Log แบบ Real-time คล้ายคำสั่ง tail -f บน Linux?', 'docker logs -f <container_name>', 'docker logs -f', 2, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('74329849-ec5c-48d5-9010-f76ef0a939d8', 'docker:01-container-basics:fc03', 5, 'cf0d4598-1c64-4a7f-b8c9-d6a18307a0f9', 'ทำไมจึงไม่ควรเข้าไปแก้ไขไฟล์โค้ดถาวรด้วย docker exec?', 'เพราะ Container ถูกออกแบบให้เป็น Stateless (Ephemeral) หาก Container ถูก Restart หรือสร้างใหม่ ข้อมูลและไฟล์ที่แก้ไขไว้จะสูญหายทันที', 'Stateless / Ephemeral lifecycle', 3, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('3bbcb941-a9f6-44af-9975-7db8e0803403', 'docker:01-container-basics:fc04', 5, 'cf0d4598-1c64-4a7f-b8c9-d6a18307a0f9', 'คำสั่ง docker stats มีประโยชน์อย่างไรสำหรับสาย Support?', 'แสดงข้อมูลการใช้ทรัพยากร CPU, RAM, Network I/O ของแต่ละ Container แบบ Real-time ทำให้รู้ได้ทันทีว่า Container ไหนกำลังดึงเครื่องพัง', 'Real-time CPU/RAM resource monitor', 4, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('d1a10001-0000-0000-0000-000000000006', 'sql:fc:where-vs-having', 3, '10413c74-c724-4168-99e9-fc7c279fb980', 'ความแตกต่างระหว่าง WHERE กับ HAVING ใน SQL', 'WHERE: กรองข้อมูล "ก่อน" ทำการจัดกลุ่ม (Filter individual rows)\n\nHAVING: กรองข้อมูล "หลัง" จากจัดกลุ่มและคำนวณ Aggregate เช่น COUNT(), SUM() แล้ว', 'HAVING มักใช้คู่กับ GROUP BY', 1, '2026-11-03 09:22:14.247234+00', '2026-11-03 09:22:14.247234+00');
INSERT INTO public.flashcards VALUES ('d1a10001-0000-0000-0000-000000000007', 'sql:fc:explain-analyze', 3, '0ec2fdf6-2627-408b-9791-35963b5fe97e', 'คำสั่งดู Query Execution Plan และเวลาที่รันจริงใน PostgreSQL', 'EXPLAIN ANALYZE <sql_query>;', 'มีคีย์เวิร์ด 2 คำขึ้นต้น', 2, '2026-11-03 09:22:14.247234+00', '2026-11-03 09:22:14.247234+00');
INSERT INTO public.flashcards VALUES ('8e84e94e-31d9-4929-814a-ef2de62e9a31', 'linux:02-basics:fc02', 1, '2f157328-48ee-496e-bcef-7afd1b6a8d1f', 'คำสั่งดูรายการไฟล์ทั้งหมดรวมไฟล์ซ่อน พร้อมแสดงสิทธิ์และขนาดแบบอ่านง่าย (KB/MB/GB)', 'ls -lah

-l: แสดงรายละเอียดแบบยาว
-a: รวมไฟล์ซ่อนที่ขึ้นต้นด้วย .
-h: แสดงขนาดไฟล์แบบ Human-readable', 'ls ตามด้วย 3 ตัวเลือกยอดนิยม', 2, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('02bacb63-dee2-41cf-8e1e-288ebd8eb921', 'linux:07-disk-memory-cpu:fc04', 1, '5f86a586-91de-4a51-b749-fcf6d837849f', 'ลบไฟล์ Log ขนาดใหญ่ด้วย rm ไปแล้ว แต่ทำไม df -h พื้นที่ดิสก์ยังไม่คืน และเช็กอย่างไร?', 'เพราะยังมีโปรเซสเปิดถือไฟล์นั้นค้างอยู่ (Held open)
วิธีตรวจ: รัน lsof +L1 (หรือ lsof | grep deleted) เพื่อดูว่าโปรเซสใดถือไฟล์อยู่', 'List Open Files ที่มี link count < 1', 4, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('9a87616f-f0e2-45b5-a72e-fb6097ce0310', 'linux:07-disk-memory-cpu:fc05', 1, '5f86a586-91de-4a51-b749-fcf6d837849f', 'เวลาดูหน่วยความจำด้วยคำสั่ง free -h ควรดูที่คอลัมน์ใดเป็นหลัก?', 'ดูที่คอลัมน์ available เป็นหลัก (ไม่ใช่คอลัมน์ free)
เพราะ Linux นำ RAM ว่างไปทำ buff/cache ซึ่งพร้อมคืนให้แอปพลิเคชันได้ทันทีเมื่อจำเป็น', 'available = พร้อมให้แอปใช้งานจริง', 5, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('67389778-e704-4576-a2c3-6a81d2620fab', 'linux:07-disk-memory-cpu:fc06', 1, '5f86a586-91de-4a51-b749-fcf6d837849f', 'คำสั่งตรวจว่าเคยมีโปรเซสถูก OOM Killer ของ Kernel สั่งปิดเพราะ RAM หมดหรือไม่', 'dmesg -T | grep -i oom
(หรือ journalctl -k | grep -i oom)', 'ค้นหาคำว่า oom ใน Kernel log', 6, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('c2618586-2422-4fc5-a3bd-6627c9e3d89d', 'linux:07-disk-memory-cpu:fc07', 1, '5f86a586-91de-4a51-b749-fcf6d837849f', 'ตัวเลข Load Average 3 ค่าจากคำสั่ง uptime แทนช่วงเวลาใด?', 'ค่าเฉลี่ยโหลดย้อนหลัง 1 นาที, 5 นาที และ 15 นาที ตามลำดับ', '1, 5, 15 นาที', 7, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('6099564e-06a8-4586-891d-973bd462eca6', 'linux:07-disk-memory-cpu:fc08', 1, '5f86a586-91de-4a51-b749-fcf6d837849f', 'คำสั่งแสดงจำนวน CPU Core ของเครื่องเพื่อนำมาเทียบกับค่า Load Average', 'nproc
(หาก Load Average สูงเกินค่าจาก nproc แสดงว่าเริ่มมีงานรอคิว)', 'Number of Processing Units', 8, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('c8c43fd6-95b5-447c-9448-95151473de8c', 'linux:07-disk-memory-cpu:fc09', 1, '5f86a586-91de-4a51-b749-fcf6d837849f', 'หาก Load Average สูงมาก แต่ดู CPU Usage แล้วต่ำมาก มักเกิดจากสาเหตุใด?', 'เกิดจากปัญหา Disk I/O Wait สูง (%wa สูง และโปรเซสค้างในสถานะ D) เพราะ Linux นับโปรเซสที่รอ I/O รวมใน Load Average ด้วย', 'รอการอ่านเขียนดิสก์หรือ NFS', 9, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('495f7ae0-affd-49f9-acfc-52c32ad2ed2d', 'linux:07-disk-memory-cpu:fc10', 1, '5f86a586-91de-4a51-b749-fcf6d837849f', 'คอลัมน์ us, sy, id, wa ในคำสั่ง vmstat หรือ top หมายถึงอะไร?', '• us (user): CPU ที่ใช้รันโปรแกรมทั่วไป
• sy (system): CPU ที่ใช้ทำงานระดับ Kernel
• id (idle): CPU ที่ว่างอยู่
• wa (iowait): เวลาที่ CPU รอการอ่านเขียนดิสก์/เครือข่าย', 'User, System, Idle, Wait', 10, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('88d08759-6186-4aa2-9665-b3e9a838e6ae', 'linux:07-disk-memory-cpu:fc11', 1, '5f86a586-91de-4a51-b749-fcf6d837849f', 'คำสั่งดูสถิติ Memory, Swap, I/O และ CPU ทุก 1 วินาที จำนวน 5 ครั้ง', 'vmstat 1 5
(บรรทัดแรกคือค่าเฉลี่ยตั้งแต่เปิดเครื่อง ให้ดูตั้งแต่บรรทัดที่ 2 เป็นต้นไป)', 'Virtual Memory Statistics', 11, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('6f99cfa3-e4b6-4e8c-9ee5-151a2bc16195', 'linux:07-disk-memory-cpu:fc12', 1, '5f86a586-91de-4a51-b749-fcf6d837849f', 'กฎเหล็กของ Tier 1 เมื่อตรวจพบว่าดิสก์เซิร์ฟเวอร์ Production เต็ม', 'ห้ามลบไฟล์ด้วยตัวเองโดยไม่อยู่ใน Runbook ให้เก็บผลลัพธ์จาก df -h, df -i, du -sh และ lsof +L1 แล้วส่งต่อ (Escalate) ทันที', 'ตรวจและเก็บหลักฐาน ไม่ลบสุ่มสี่สุ่มห้า', 12, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('6027dd08-04ab-4663-986a-9ad203db4bb0', 'linux:08-remote-access:fc01', 1, '75b271d2-e3ff-464b-be92-18b9ea5a0d05', 'สิทธิ์ (Octal Permission) ที่บังคับสำหรับโฟลเดอร์ ~/.ssh และไฟล์ ~/.ssh/authorized_keys', '• ~/.ssh : 700 (drwx------)
• ~/.ssh/authorized_keys : 600 (-rw-------)
• Private Key (เช่น ~/.ssh/id_ed25519) : 600 (-rw-------)', 'โฟลเดอร์ 700, ไฟล์กุญแจ 600', 1, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('c700700d-c233-498d-af1f-ac23b3712f72', 'linux:08-remote-access:fc02', 1, '75b271d2-e3ff-464b-be92-18b9ea5a0d05', 'คำสั่งเชื่อมต่อ SSH โดยระบุพอร์ต 2222 และระบุไฟล์ Private Key', 'ssh -p 2222 -i ~/.ssh/my_key user@host

-p (พิมพ์เล็ก): ระบุพอร์ต
-i: ระบุไฟล์ Identity (Private Key)', 'ssh ใช้ -p ตัวพิมพ์เล็ก', 2, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('352b5a33-6faf-4a11-9ac0-e4b7a876e12e', 'dc:fc:smf-vs-mmf', 10, 'd610df66-7525-44ca-9e83-02b4749afe01', 'ความแตกต่างของสายไฟเบอร์ Single-Mode (OS2) กับ Multi-Mode (OM3/OM4)', '• Single-Mode (OS2): สายสีเหลือง, แกน 9µm, แสง 1310/1550nm, คู่กับหัว LR (ระยะไกล 2-40+ กม.)
• Multi-Mode (OM3/OM4): สายสีฟ้า Aqua, แกน 50µm, แสง 850nm, คู่กับหัว SR (ระยะใกล้ในห้อง Data Hall 100-400 ม.)', 'จำจากสีปลอกสาย: เหลือง = ไกล (LR), ฟ้า Aqua = ใกล้ (SR)', 1, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('600fd749-11e8-4c37-9f20-a4cb3189511f', 'dc:fc:sfp-qsfp-speeds', 10, 'd610df66-7525-44ca-9e83-02b4749afe01', 'ความเร็วของหัว Transceiver: SFP, SFP+, SFP28, QSFP+, QSFP28', '• SFP = 1 Gbps
• SFP+ = 10 Gbps
• SFP28 = 25 Gbps
• QSFP+ = 40 Gbps (4x10G)
• QSFP28 = 100 Gbps (4x25G)', 'Q ย่อมาจาก Quad (4 ช่องสัญญาณรวมกัน)', 2, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('330d010e-2f68-4757-b236-4e7a515130fe', 'dc:fc:rolling-fiber', 10, 'd610df66-7525-44ca-9e83-02b4749afe01', 'การทำ Rolling Fiber (สลับสาย Tx/Rx) คืออะไร และทำเมื่อไหร่?', 'คือการสลับตำแหน่งหัวสายไฟเบอร์ LC คู่ซ้าย-ขวาที่ปลายด้านใดด้านหนึ่ง

ทำเมื่อเสียบสายไฟเบอร์แล้วไฟ Link ไม่ติด (Link Down) เพราะขั้วส่งแสง (Tx) วิ่งไปชนกับขั้วส่งแสง (Tx) ของอีกฝั่ง แทนที่จะเข้าขั้วรับแสง (Rx)', 'Tx ต้องเข้า Rx เสมอ', 3, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('aa3fc941-c6a5-4729-83ef-6414fd7215f2', 'dc:fc:bend-radius', 10, 'd610df66-7525-44ca-9e83-02b4749afe01', 'Bend Radius ของสายไฟเบอร์คืออะไร และทำไมจึงนิยมใช้เทปตีนตุ๊กแก (Velcro) แทนเคเบิลไทร์?', 'Bend Radius คือรัศมีการโค้งงอแคบสุดที่สายไฟเบอร์รับได้โดยแสงไม่รั่วออกนอกแกนแก้ว (Attenuation Loss) หรือแกนแก้วหัก

การใช้เทป Velcro ช่วยไม่ให้รัดสายแน่นจนบีบปลอกสายและทำลายใยแก้วข้างในเหมือนพลาสติกเคเบิลไทร์', 'ห้ามพับสายหักศอก 90 องศา', 4, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('149b4883-feaa-470c-b259-5b53df77508c', 'dc:fc:t568b-color-code', 10, 'd610df66-7525-44ca-9e83-02b4749afe01', 'ลำดับสีสายแลนมาตรฐาน T568B ทั้ง 8 พิน (พิน 1 ถึง 8)', '1. ขาว-ส้ม
2. ส้ม
3. ขาว-เขียว
4. น้ำเงิน
5. ขาว-น้ำเงิน
6. เขียว
7. ขาว-น้ำตาล
8. น้ำตาล', 'ขึ้นต้นด้วยคู่ส้ม แล้วขาวเขียวคร่อมคู่น้ำเงิน', 5, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('ba6305d9-fa64-4573-bf8a-804eaadd08c3', 'dc:fc:riser-hba', 10, 'a64393d6-d903-4f53-958f-99df97e3d586', 'หน้าที่ของ Riser Card และ HBA Card ในเครื่องเซิร์ฟเวอร์', '• Riser Card: แผงแปลงสล็อต PCIe จากแนวตั้งเป็นแนวนอน เพื่อให้ใส่การ์ดในเครื่อง 1U/2U เตี้ยๆ ได้
• HBA (Host Bus Adapter): การ์ดเชื่อมต่อเซิร์ฟเวอร์เข้ากับระบบจัดเก็บข้อมูลภายนอก เช่น Fibre Channel SAN หรือ SAS Storage', 'Riser = ยกตะแคงแนวนอน, HBA = การ์ดต่อ Storage', 6, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('8f54e66a-facb-4671-9672-2ea9f6003bc9', 'linux:02-basics:fc04', 1, '2f157328-48ee-496e-bcef-7afd1b6a8d1f', 'สัญลักษณ์ . , .. และ ~ ในเส้นทาง Linux หมายถึงอะไร?', '• . = โฟลเดอร์ปัจจุบัน
• .. = โฟลเดอร์แม่ (ถอยขึ้น 1 ชั้น)
• ~ = โฟลเดอร์ Home ของผู้ใช้ปัจจุบัน', 'จุดเดียว สองจุด และตัวหนอน', 4, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('9d1351c4-681b-4384-8b0e-f3ebc14dcd43', 'dc:fc:ecc-dimm-rules', 10, 'a64393d6-d903-4f53-958f-99df97e3d586', 'ECC RAM คืออะไร และทำไมการใส่ RAM เซิร์ฟเวอร์ต้องเรียงตาม DIMM Population Rules?', '• ECC (Error-Correcting Code): แรมที่ตรวจจับและซ่อมบิตข้อมูลที่เพี้ยนเองได้ ป้องกันเครื่องแฮงค์
• DIMM Population Rules: ลำดับช่องเสียบแรมที่ระบุบนฝาเครื่อง (เช่น A1, B1, A2...) เพื่อให้ Memory Controller ทุก Channel ทำงานสมดุลกันและบูตผ่าน', 'ดูผังลำดับช่องเสียบใต้ฝาเครื่องเสมอ', 7, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('3e9f9cc8-8f5c-459c-984c-a39dc1c77578', 'dc:fc:rack-unit-1u', 10, 'a64393d6-d903-4f53-958f-99df97e3d586', 'ขนาดความสูง 1U (Rack Unit) เท่ากับกี่นิ้ว และหลักการวางน้ำหนักในตู้แร็ค 42U คืออะไร?', '• 1U = 1.75 นิ้ว (4.445 ซม.)
• อุปกรณ์ที่หนักที่สุด (เช่น ตู้แบตเตอรี่ UPS และ Storage Array) ต้องติดตั้งไว้ที่ด้านล่างสุดของตู้แร็คเสมอ เพื่อป้องกันตู้แร็คคว่ำขณะดึงรางสไลด์', 'ของหนักอยู่ล่างสุดเสมอ (Bottom-Heavy)', 8, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('112918e3-77ca-47b2-8eda-d08037f1a7c8', 'dc:fc:idrac-ilo-ipmi', 10, 'a64393d6-d903-4f53-958f-99df97e3d586', 'iDRAC, iLO, IPMI และ Redfish คืออะไร?', 'ระบบจัดการฮาร์ดแวร์เซิร์ฟเวอร์ระยะไกล (Out-of-Band Management) ผ่านชิป BMC บนเมนบอร์ด:
• iDRAC = Dell
• iLO = HPE
• IPMI = มาตรฐานคำสั่ง CLI ทั่วไป
• Redfish = มาตรฐานยุคใหม่ผ่าน RESTful HTTPS/JSON', 'ทำงานได้แม้เครื่องปิดอยู่หรือ OS ค้างสนิท (ขอแค่เสียบปลั๊กไฟ)', 9, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('a578601a-4e71-443e-8946-755d1e34af3a', 'dc:fc:uid-led', 10, 'a64393d6-d903-4f53-958f-99df97e3d586', 'ไฟ UID LED (Chassis Identify Light) สีฟ้าบนเซิร์ฟเวอร์มีประโยชน์อย่างไร?', 'ใช้สั่งให้ไฟสีฟ้ากระพริบทั้งด้านหน้าและด้านหลังของเซิร์ฟเวอร์เครื่องเป้าหมาย เพื่อช่วยให้ช่างหน้าตู้แร็คระบุตำแหน่งเครื่องได้อย่างแม่นยำ ป้องกันการถอดสายไฟหรือดึงดิสก์ผิดเครื่อง', 'เปิดไฟสีฟ้าชี้เป้าก่อนเดินไปหลังตู้แร็คเสมอ', 10, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('324ec96c-3bbe-4503-a3e6-5e634fe34bbc', 'linux:08-remote-access:fc03', 1, '75b271d2-e3ff-464b-be92-18b9ea5a0d05', 'คำสั่งเปิดโหมด Verbose ใน SSH เพื่อไล่หาสาเหตุเวลาล็อกอินไม่ผ่าน', 'ssh -v user@host
(สามารถเพิ่มเป็น -vv หรือ -vvv เพื่อดูรายละเอียดมากขึ้น)', '-v ย่อมาจาก verbose', 3, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('d877dcd5-6336-46b3-b136-5560bf98d48a', 'dc:fc:pxe-boot-flow', 10, 'a8d18af7-6692-4b1b-86b5-88a0d4fb8f9b', 'ลำดับการทำงานของ PXE Boot (การบูตติดตั้ง OS ผ่านสายแลน)', '1. การ์ดแลนส่ง DHCP Discover ขอ IP
2. DHCP Server ตอบกลับพร้อม IP + Option 66 (TFTP Server) + Option 67 (Boot file)
3. ดาวน์โหลด Bootloader และ Kernel ผ่าน TFTP (UDP 69)
4. รันตัวติดตั้ง OS อัตโนมัติ (Kickstart / Preseed / WDS)', 'DHCP แจกทาง -> TFTP ส่งไฟล์บูต', 11, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('6c24c1cd-b95c-4ea2-a82d-c5eb7a9c39ce', 'dc:fc:san-wwpn-zoning', 10, 'a8d18af7-6692-4b1b-86b5-88a0d4fb8f9b', 'WWPN, LUN และ SAN Zoning คืออะไร?', '• WWPN (World Wide Port Name): เลขที่อยู่ 64-bit ประจำพอร์ต HBA และพอร์ต Storage (เหมือน MAC Address ของ Fibre Channel)
• LUN: ก้อนดิสก์เสมือนที่แบ่งจากตู้ SAN ให้เซิร์ฟเวอร์ใช้งาน
• Zoning: การจับคู่บน SAN Switch ว่า Initiator WWPN ใดมีสิทธิ์มองเห็น Target WWPN ใด', 'Single-Initiator Zoning ป้องกันเซิร์ฟเวอร์แย่งเขียนดิสก์ทับกัน', 12, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('d342ba8d-c355-4173-aadd-8f5efcebaaf6', 'dc:fc:cisco-ucs-blade', 10, 'a8d18af7-6692-4b1b-86b5-88a0d4fb8f9b', 'จุดเด่นของ Blade Server (เช่น Cisco UCS และ HPE BladeSystem) คืออะไร?', '• รวมเซิร์ฟเวอร์หลายใบไว้ในโครง Chassis เดียว โดยแชร์ไฟ PSU, พัดลม และโมดูลสวิตช์ร่วมกัน
• Cisco UCS มี Service Profile บน Fabric Interconnect ที่ย้ายค่า MAC, WWPN และการตั้งค่า BIOS ไปยังใบ Blade ใหม่ได้ทันทีเมื่อฮาร์ดแวร์เดิมเสีย', 'ลดสายไฟหลังตู้และเปลี่ยนเครื่องทดแทนได้ไวมาก', 13, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('0d3e1aef-3344-4b0c-9b1f-e0e0752b75c9', 'dc:fc:1phase-vs-3phase', 10, '92409c70-8fd7-4575-b8c5-22e661376a62', 'ความแตกต่างของระบบไฟ 1 เฟส กับ 3 เฟส ใน Data Center', '• 1 เฟส (110V/220V): มีสาย Line 1 เส้น + N + G จ่ายเข้าตัว PSU ของเซิร์ฟเวอร์แต่ละเครื่อง
• 3 เฟส (208V/380V/400V/480V): มีสาย Line 3 เส้น (L1, L2, L3) จ่ายเข้าตู้แร็ค PDU กำลังสูง โดยต้องกระจายโหลดทั้ง 3 เฟสให้สมดุลกัน', 'สูตรกำลังไฟ P = V x I', 14, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('c5b49acf-5e6f-4cc8-9eb9-8ff2377963df', 'dc:fc:ups-ats-abfeed', 10, '92409c70-8fd7-4575-b8c5-22e661376a62', 'บทบาทของ UPS, ATS และระบบไฟคู่ A/B Power Feed', '• UPS: จ่ายไฟจากแบตเตอรี่ทันที (0ms) ประคองไฟ 5-15 นาทีระหว่างรอเครื่องปั่นไฟ
• ATS: สวิตช์สลับไฟอัตโนมัติจากไฟการไฟฟ้าไปยัง Generator
• A/B Feed: เสียบสายไฟ PSU 1 เข้า PDU ฝั่ง A และ PSU 2 เข้า PDU ฝั่ง B โดยคุมโหลดฝั่งละไม่เกิน 40-45%', 'คุมโหลดไม่เกิน 45% ต่อฝั่ง เผื่อฝั่งหนึ่งดับอีกฝั่งจะรับโหลดรวมไม่เกิน 90%', 15, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('c61d1276-8553-4d89-ad7f-ba6bd4412eb9', 'dc:fc:power-sequence', 10, '92409c70-8fd7-4575-b8c5-22e661376a62', 'ลำดับการปิด (Power-Down) และการเปิด (Power-Up) อุปกรณ์ทั้งตู้แร็ค', '• ตอนปิด: ปิด Server ก่อน -> ปิด Storage -> ปิด Network Switch หลังสุด
• ตอนเปิด: เปิด Network/SAN Switch ก่อน -> เปิด Storage รอให้พร้อม -> ค่อยทยอยเปิด Server ทีละชุด (ป้องกันไฟกระชาก Inrush current)', 'Server ต้องเห็น Storage และ Network พร้อมก่อนเสมอตอนบูต', 16, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('89bec550-7006-4d0b-960f-343032c66720', 'dc:fc:hot-cold-aisle', 10, '92409c70-8fd7-4575-b8c5-22e661376a62', 'หลักการของ Hot Aisle / Cold Aisle และแผ่น Blanking Panel', '• Cold Aisle: หน้าตู้แร็คหันเข้าหากัน รับลมเย็นจากพื้นยกเข้าหน้าเครื่อง
• Hot Aisle: หลังตู้แร็คหันชนกัน ระบายลมร้อนออกด้านหลังขึ้นเพดาน
• Blanking Panel: แผ่นปิดช่อง U ที่ว่างหน้าตู้ เพื่อกั้นไม่ให้ลมร้อนไหลวนย้อนกลับมาด้านหน้า', 'ลมเย็นเข้าหน้า ลมร้อนออกหลัง', 17, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('337a0234-9800-480e-8b67-085f0a99484e', 'dc:fc:vesda-fm200', 10, '92409c70-8fd7-4575-b8c5-22e661376a62', 'VESDA และสารดับเพลิง FM-200 / Novec 1230 คืออะไร?', '• VESDA: ระบบท่อดูดอากาศตรวจจับอนุภาคควันความไวสูงด้วยเลเซอร์ แจ้งเตือนตั้งแต่เริ่มมีกลิ่นไหม้
• FM-200 / Novec 1230: แก๊สสารสะอาดดับเพลิง (Clean Agent) ที่ดับไฟโดยไม่นำไฟฟ้าและไม่ทำลายแผงวงจรเซิร์ฟเวอร์', 'ห้ามใช้น้ำหรือถังผงเคมีแห้งฉีดใส่เซิร์ฟเวอร์', 18, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('f2f4cfe5-bc12-49c7-9318-a41774ac771a', 'dc:fc:interview-psu-spark', 10, 'e2bdf887-4d4b-4710-b6c1-8dd61f020fdc', '[สัมภาษณ์] หากเห็นประกายไฟจาก PSU ลูกหนึ่งของเซิร์ฟเวอร์ ทำไมห้ามสับเบรกเกอร์ไฟหลักของทั้งตู้แร็ค?', 'เพราะการสับไฟหลักของตู้แร็คจะทำให้เซิร์ฟเวอร์เครื่องอื่นอีก 20-40 เครื่องในตู้ดับทั้งหมด!

สิ่งที่ต้องทำคือตั้งสติ ประเมินความปลอดภัย ตรวจสอบว่าเครื่องมี Redundant PSU ลูกที่ 2 รับโหลดอยู่ ถอดเฉพาะสายไฟของลูก PSU ที่ช็อต และแจ้งหัวหน้าทีม/NOC ทันที', 'ผู้จัดการต้องการเห็นสติและการจำกัดวงผลกระทบ (Blast Radius)', 19, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('eb61db42-a4a8-462e-8fb1-62d67d0030e5', 'network:01-ip-subnetting:fc02', 2, 'd8929572-6865-40b4-bf65-a32bfcdb15a5', 'ช่วง Private IP Address ตาม RFC 1918 ทั้ง 3 Class คือช่วงใดบ้าง?', 'Class A: 10.0.0.0/8
Class B: 172.16.0.0/12 (172.16 - 172.31)
Class C: 192.168.0.0/16', '10.x, 172.16-31.x, 192.168.x', 2, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('cde2d7d3-eb58-4e18-835a-d303eb9e860a', 'dc:fc:hosting-vs-colo', 10, 'e2bdf887-4d4b-4710-b6c1-8dd61f020fdc', '[สัมภาษณ์] ความแตกต่างของคำถามสัมภาษณ์ระหว่างบริษัท Hosting กับ Colocation (เช่น Equinix)', '• บริษัท Hosting (มีเซิร์ฟเวอร์ตัวเอง): เน้นการลง OS (Linux/Windows), PXE boot, RAID, iDRAC/iLO และการแก้ปัญหาฮาร์ดแวร์/OS
• บริษัท Colocation (ให้เช่าตู้และเชื่อมสาย): เน้นงาน Smart Hands, Cross-connect สายไฟเบอร์, ชนิดหัว SFP/QSFP, การสลับสาย Tx/Rx และมาตรฐานความปลอดภัยหน้าตู้ลูกค้า', 'Hosting เน้น Server+OS, Colocation เน้น Fiber+Cross-Connect+Smart Hands', 20, '2026-11-04 15:19:45.48554+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('e1c20bdd-853d-4611-ac7a-80114172a891', 'docker:02-troubleshooting-exit-codes:fc01', 5, '13d2405e-0e29-4bf2-9f78-03f4f29d3aef', 'Exit Code 137 ใน Docker มีความหมายว่าอย่างไร?', 'คอนเทนเนอร์ถูกบังคับปิดด้วย SIGKILL (128 + 9) สาเหตุยอดนิยมคือ OOMKilled (Out of Memory - ใช้ RAM เกิน Limit)', 'SIGKILL / OOMKilled (Out of Memory)', 1, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('9d195724-f8a2-4c59-ad0b-76a753a4eada', 'docker:02-troubleshooting-exit-codes:fc02', 5, '13d2405e-0e29-4bf2-9f78-03f4f29d3aef', 'Exit Code 143 ใน Docker มีความหมายว่าอย่างไร?', 'คอนเทนเนอร์หยุดทำงานอย่างสุภาพด้วย SIGTERM (128 + 15) เช่น ได้รับคำสั่ง docker stop หรือระบบกำลัง Deploy ใหม่', 'Graceful shutdown via SIGTERM', 2, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('eacb47ac-0484-4ac4-8671-35d6743a8eb4', 'docker:02-troubleshooting-exit-codes:fc03', 5, '13d2405e-0e29-4bf2-9f78-03f4f29d3aef', 'คำสั่งใดใช้ตรวจสอบว่าคอนเทนเนอร์โดน OOMKilled หรือไม่แบบรวดเร็ว?', 'docker inspect <container> --format ''{{.State.OOMKilled}}'' หรือดูใน Kernel Log ด้วยคำสั่ง dmesg -T | grep -i oom', 'docker inspect .State.OOMKilled', 3, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('d1a10001-0000-0000-0000-000000000001', 'linux:fc:ss-listen', 1, 'b1a10001-0000-0000-0000-000000000001', 'คำสั่งตรวจสอบว่า Process ใดกำลังฟังพอร์ต (Listen) อยู่บน Linux', 'ss -tulpn หรือ netstat -tulpn

-t: TCP
-u: UDP
-l: Listening
-p: Show process/PID
-n: Numeric port', 'จำตัวย่อ TULPN', 1, '2026-11-03 09:22:14.247234+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('840b7116-6411-4d82-80a4-cf6a141a1089', 'linux:02-basics:fc01', 1, '2f157328-48ee-496e-bcef-7afd1b6a8d1f', 'คำสั่งแสดงเส้นทางเต็มของโฟลเดอร์ที่กำลังยืนอยู่ปัจจุบัน', 'pwd
(Print Working Directory)', 'ตัวย่อ 3 ตัวอักษร', 1, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('39deab3c-366f-4706-b945-93aafd794048', 'linux:02-basics:fc03', 1, '2f157328-48ee-496e-bcef-7afd1b6a8d1f', 'ความแตกต่างระหว่าง Absolute Path กับ Relative Path', '• Absolute Path: ขึ้นต้นด้วย / เสมอ (อ้างอิงจากรากสุดของระบบ เช่น /var/log/syslog)
• Relative Path: ไม่ขึ้นต้นด้วย / (อ้างอิงจากตำแหน่งปัจจุบัน เช่น ./app.log หรือ ../config)', 'ดูที่ตัวอักษรแรกของเส้นทาง', 3, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('3d65c2dd-2d36-4346-ba8b-3d6679a9f45c', 'linux:02-basics:fc05', 1, '2f157328-48ee-496e-bcef-7afd1b6a8d1f', 'คำสั่งสลับกลับไปยังโฟลเดอร์ก่อนหน้าที่เพิ่งจากมา', 'cd -', 'ใช้เครื่องหมายขีดกลาง', 5, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('7ad0de06-e939-484c-8b72-312ee902b4a0', 'linux:02-basics:fc06', 1, '2f157328-48ee-496e-bcef-7afd1b6a8d1f', 'ทำไมไม่ควรใช้ cat เปิดอ่านไฟล์ Log ขนาดใหญ่ และควรใช้คำสั่งใดแทน?', 'เพราะ cat จะแสดงเนื้อหาทั้งไฟล์รวดเดียวทำให้หน้าจอค้างและเปลือง I/O
ควรใช้:
• less <file> (อ่านทีละหน้า ค้นหาด้วย /)
• tail -n 50 <file> (ดูเฉพาะ 50 บรรทัดสุดท้าย)', 'ใช้โปรแกรมแบ่งหน้าหรือดูท้ายไฟล์', 6, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('d2027c4b-9d64-4385-afc2-cff95fd72be4', 'linux:02-basics:fc07', 1, '2f157328-48ee-496e-bcef-7afd1b6a8d1f', 'ปุ่มลัดสำคัญเมื่อเปิดอ่านไฟล์ด้วยคำสั่ง less', '• /คำค้นหา : ค้นหาข้อความไปข้างหน้า (กด n ไปจุดถัดไป)
• G (พิมพ์ใหญ่) : กระโดดไปบรรทัดสุดท้ายของไฟล์
• g (พิมพ์เล็ก) : กระโดดไปบรรทัดแรกของไฟล์
• q : ออกจากโปรแกรม less', 'คล้ายปุ่มในโปรแกรม vi', 7, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('f9deb9d2-1021-4091-b415-f793c7f810c5', 'linux:02-basics:fc08', 1, '2f157328-48ee-496e-bcef-7afd1b6a8d1f', 'คำสั่งดูเฉพาะ 20 บรรทัดแรก และ 50 บรรทัดสุดท้ายของไฟล์ app.log', '• 20 บรรทัดแรก: head -n 20 app.log
• 50 บรรทัดสุดท้าย: tail -n 50 app.log', 'ส่วนหัวและส่วนหาง', 8, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('9a3faab0-01ea-4697-a9c6-dab663ad4abd', 'linux:02-basics:fc09', 1, '2f157328-48ee-496e-bcef-7afd1b6a8d1f', 'คำสั่งคัดลอกโฟลเดอร์ทั้งก้อน และคำสั่งคัดลอกไฟล์โดยคงเวลาแก้ไขเดิม (Timestamp)', '• คัดลอกโฟลเดอร์: cp -r src_dir/ dest_dir/
• คงสิทธิ์และเวลาเดิม: cp -p file.conf file.conf.bak', '-r (recursive) และ -p (preserve)', 9, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('de014bfd-1937-45a5-8dcd-707c5d040021', 'linux:02-basics:fc10', 1, '2f157328-48ee-496e-bcef-7afd1b6a8d1f', 'ความแตกต่างของ Wildcard * กับ ? ใน Shell', '• * แทนตัวอักษรใดๆ กี่ตัวก็ได้ (รวมถึง 0 ตัว) เช่น *.log
• ? แทนตัวอักษรใดๆ เพียง 1 ตัวอักษรเท่านั้น เช่น app-0?.log', 'ดอกจัน = กี่ตัวก็ได้, ปรัศนี = 1 ตัว', 10, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('6189f2da-a0e0-4268-b1bd-9e92ea94e6e6', 'linux:02-basics:fc11', 1, '2f157328-48ee-496e-bcef-7afd1b6a8d1f', 'วิธีเปิดดูคู่มือการใช้งานคำสั่งบนเครื่อง Linux เมื่อจำ Option ไม่ได้', '• man <คำสั่ง>  (เปิดคู่มือฉบับเต็ม กด q เพื่อออก)
• <คำสั่ง> --help  (แสดงสรุป Option แบบย่อบนหน้าจอ)', 'ย่อมาจาก manual', 11, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('d7503e51-282e-40fe-bbd3-093411b79ce2', 'linux:02-basics:fc12', 1, '2f157328-48ee-496e-bcef-7afd1b6a8d1f', 'คำสั่งสร้างโฟลเดอร์ซ้อนกันหลายชั้นในครั้งเดียว (เช่น /tmp/incident/2026/logs)', 'mkdir -p /tmp/incident/2026/logs
(-p จะสร้างโฟลเดอร์แม่ที่ยังไม่มีให้อัตโนมัติ และไม่ฟ้อง Error ถ้ามีอยู่แล้ว)', 'ใช้ออปชัน -p (parents)', 12, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('b451a63f-4c91-46ec-8f74-00276b4f778f', 'linux:03-file-system:fc01', 1, 'adeaa019-95a7-4877-8d5a-94c875441152', 'ไดเรกทอรี /etc, /var/log, /opt และ /tmp ใช้เก็บข้อมูลประเภทใด?', '• /etc : ไฟล์ตั้งค่าระบบและบริการ (Config)
• /var/log : ไฟล์บันทึกเหตุการณ์ (Log)
• /opt : โปรแกรมเสริมหรือซอฟต์แวร์องค์กรที่ติดตั้งแยก
• /tmp : ไฟล์ชั่วคราว', 'มาตรฐาน FHS ของ Linux', 1, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('bebc3d31-113d-4123-ae68-37d3313d330e', 'linux:03-file-system:fc02', 1, 'adeaa019-95a7-4877-8d5a-94c875441152', 'ไฟล์ /etc/hosts และ /etc/resolv.conf ทำหน้าที่อะไร?', '• /etc/hosts : จับคู่ IP กับชื่อโดเมนภายในเครื่อง (ระบบอ่านก่อนถาม DNS)
• /etc/resolv.conf : ระบุ IP ของ DNS Server ที่เครื่องใช้แปลงชื่อโดเมน (nameserver)', 'เกี่ยวกับการแปลงชื่อโดเมนเป็น IP', 2, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('4438aa8e-f40b-459d-b308-7443ad0187e8', 'linux:03-file-system:fc03', 1, 'adeaa019-95a7-4877-8d5a-94c875441152', 'ไฟล์ /etc/fstab คืออะไร และทำไมห้ามแก้ไขเองโดยพลการ?', 'ไฟล์กำหนดรายการดิสก์และพาร์ทิชันที่จะถูก Mount อัตโนมัติตอนบูตเครื่อง
หากเขียนผิดจะทำให้เซิร์ฟเวอร์บูตไม่ขึ้นในรอบถัดไป', 'File System Table', 3, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('8c4f1562-03be-44a1-aed5-8c7463b0a885', 'linux:03-file-system:fc04', 1, 'adeaa019-95a7-4877-8d5a-94c875441152', 'คำสั่งค้นหาเฉพาะไฟล์ธรรมดาใน /var ที่มีขนาดใหญ่กว่า 100 MB', 'find /var -type f -size +100M', 'ใช้ -type f และ -size', 4, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('ca780ba0-9fb6-426a-b5e3-9b840e8f5d7b', 'linux:03-file-system:fc05', 1, 'adeaa019-95a7-4877-8d5a-94c875441152', 'คำสั่งค้นหาไฟล์ใน /etc ที่ถูกแก้ไขเนื้อหาภายใน 60 นาทีที่ผ่านมา', 'find /etc -type f -mmin -60
(หากต้องการนับเป็นวันใช้ -mtime เช่น -mtime -1 คือภายใน 24 ชม.)', 'mmin = modified minutes', 5, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('11a1ab8e-d447-410e-b10b-607099fa48c4', 'linux:03-file-system:fc06', 1, 'adeaa019-95a7-4877-8d5a-94c875441152', 'คำสั่งค้นหาไฟล์ตามชื่อแบบไม่สนใจตัวพิมพ์เล็ก-ใหญ่ (Case-insensitive)', 'find /var/log -iname "*error*.log"', 'เติมตัว i หน้าคำว่า name', 6, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('75204618-3d00-4db9-9972-c3f6acca773a', 'linux:03-file-system:fc07', 1, 'adeaa019-95a7-4877-8d5a-94c875441152', 'คำสั่งสร้าง Symbolic Link (Soft Link) และวิธีดูว่าชี้ไปที่ไหน', '• สร้างลิงก์: ln -s <พาธต้นทางจริง> <ชื่อลิงก์>
• ตรวจสอบปลายทาง: ls -l <ชื่อลิงก์> หรือ file <ชื่อลิงก์>', 'ตัวเลือก -s ย่อมาจาก symbolic', 7, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('aada3fcb-8b87-4149-abbf-b0af861c2388', 'linux:03-file-system:fc08', 1, 'adeaa019-95a7-4877-8d5a-94c875441152', 'Symbolic Link (Soft Link) ต่างจาก Hard Link อย่างไร?', '• Symbolic Link (ln -s): ชี้ไปยังชื่อพาธ ข้ามพาร์ทิชันได้ ชี้โฟลเดอร์ได้ ถ้าลบต้นทางลิงก์จะเสีย (Broken link)
• Hard Link (ln): ชี้ไปยังเลข Inode เดียวกันโดยตรง ข้ามพาร์ทิชันไม่ได้ ลบชื่อไฟล์ต้นทางข้อมูลยังอยู่', 'เปรียบเทียบการชี้ไปที่ชื่อพาธ กับ ชี้ไปที่ Inode', 8, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('35be689d-9e8c-4e04-affa-530d913bc034', 'linux:03-file-system:fc09', 1, 'adeaa019-95a7-4877-8d5a-94c875441152', 'คำสั่งดูเวลาแก้ไขไฟล์อย่างละเอียด (Access, Modify, Change) และหมายเลข Inode', 'stat <ชื่อไฟล์>', 'ย่อมาจาก status ของไฟล์', 9, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('afdbe3f9-37cd-4460-ab16-46b2ffe0b8fa', 'linux:03-file-system:fc10', 1, 'adeaa019-95a7-4877-8d5a-94c875441152', 'คำสั่งตรวจสอบชนิดที่แท้จริงของไฟล์โดยไม่ดูจากนามสกุล', 'file <ชื่อไฟล์>
(เช่นตรวจว่าไฟล์ .gz เป็น gzip จริงหรือเป็นเพียงข้อความ HTML/ASCII)', 'คำสั่งตรงตัว 4 ตัวอักษร', 10, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('f35dbd31-db88-46fb-aa53-18f7ea2df159', 'linux:03-file-system:fc11', 1, 'adeaa019-95a7-4877-8d5a-94c875441152', 'คำสั่งสรุปขนาดพื้นที่ของแต่ละโฟลเดอร์ย่อยใน /var/log แบบอ่านง่าย', 'du -sh /var/log/*

-s: สรุปรวมแต่ละรายการ (summary)
-h: หน่วยอ่านง่าย (KB, MB, GB)', 'Disk Usage', 11, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('c5098f8a-0042-4eed-a3a0-24e77966e837', 'linux:03-file-system:fc12', 1, 'adeaa019-95a7-4877-8d5a-94c875441152', 'วิธีซ่อนข้อความ Permission denied เวลาใช้คำสั่ง find ด้วยสิทธิ์ผู้ใช้ทั่วไป', 'ต่อท้ายคำสั่งด้วย 2>/dev/null
เช่น: find /var -name "*.log" 2>/dev/null', 'Redirect standard error (2) ไปทิ้งที่ /dev/null', 12, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('af41fea8-7019-43ac-b88d-67d6a3ac1081', 'linux:08-remote-access:fc04', 1, '75b271d2-e3ff-464b-be92-18b9ea5a0d05', 'ความต่างของตัวเลือกระบุพอร์ตระหว่างคำสั่ง ssh กับคำสั่ง scp', '• ssh ใช้ -p (ตัวพิมพ์เล็ก): ssh -p 2222 user@host
• scp ใช้ -P (ตัวพิมพ์ใหญ่): scp -P 2222 file.txt user@host:/tmp/', 'scp ใช้ -p พิมพ์เล็กสำหรับ preserve timestamps ไปแล้ว จึงต้องใช้ -P พิมพ์ใหญ่สำหรับพอร์ต', 4, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('2f39cad6-4153-4755-959a-dcb8bfff483c', 'linux:04-process-service:fc01', 1, 'f18ea418-7710-44cb-b1b9-4a5724a2a92b', 'ความแตกต่างระหว่างสัญญาณ SIGTERM (15) กับ SIGKILL (9)', '• SIGTERM (kill <PID> หรือ kill -15): ขอให้โปรเซสปิดตัวเองอย่างสุภาพ มีเวลาเคลียร์งานและบันทึกข้อมูล
• SIGKILL (kill -9 <PID>): บังคับตัดการทำงานทันทีที่ระดับ Kernel โปรเซสไม่มีโอกาสเคลียร์งาน', 'ควรเริ่มจาก 15 ก่อนใช้ 9 เสมอ', 1, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('848bd8fb-5429-4e2e-9a09-1c3affe92fc1', 'linux:04-process-service:fc02', 1, 'f18ea418-7710-44cb-b1b9-4a5724a2a92b', 'คำสั่งแสดงโปรเซสทั้งหมดที่กำลังทำงานอยู่ในเครื่องพร้อม %CPU, %MEM และ PID', 'ps aux
(มักใช้คู่กับ grep เช่น ps aux | grep nginx)', 'Process Status', 2, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('599b58a8-7c8e-498c-8b65-18e2abf7c384', 'linux:04-process-service:fc03', 1, 'f18ea418-7710-44cb-b1b9-4a5724a2a92b', 'ปุ่มลัดในโปรแกรม top สำหรับเรียงตามการใช้ CPU และเรียงตามการใช้ RAM', '• กด P (พิมพ์ใหญ่): เรียงตาม %CPU จากมากไปน้อย
• กด M (พิมพ์ใหญ่): เรียงตาม %MEM จากมากไปน้อย
• กด q: ออกจากโปรแกรม top', 'P = Processor, M = Memory', 3, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('cf58810a-c0c8-428f-9bcf-066976ddd16e', 'linux:04-process-service:fc04', 1, 'f18ea418-7710-44cb-b1b9-4a5724a2a92b', 'รหัสสถานะโปรเซส R, S, D, Z ในคอลัมน์ STAT ของ ps aux หมายถึงอะไร?', '• R (Running): กำลังทำงานบน CPU
• S (Sleeping): รอเหตุการณ์หรือคำขอ
• D (Uninterruptible sleep): รอ Disk/Network I/O
• Z (Zombie): โปรเซสจบแล้วแต่โปรเซสแม่ยังไม่อ่าน exit status', 'ระวังสถานะ D (I/O ค้าง) และ Z (Zombie)', 4, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('fc490c20-cf7e-447c-975b-b76c63b5f480', 'linux:04-process-service:fc05', 1, 'f18ea418-7710-44cb-b1b9-4a5724a2a92b', 'ทำไม Zombie Process (สถานะ Z / <defunct>) จึงฆ่าด้วย kill -9 ไม่ได้?', 'เพราะโปรเซสนั้นทำงานจบและคืนหน่วยความจำไปแล้ว เหลือเพียงรายการ PID ในตารางที่รอโปรเซสแม่ (PPID) มาอ่านสถานะจบงาน', 'สิ่งที่ตายไปแล้วฆ่าซ้ำไม่ได้', 5, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('99a52ea1-8de1-4248-9527-c135afa5e377', 'linux:04-process-service:fc06', 1, 'f18ea418-7710-44cb-b1b9-4a5724a2a92b', 'คำสั่งตรวจรายชื่อบริการ systemd ทั้งหมดที่อยู่ในสถานะ failed', 'systemctl list-units --failed
(หรือย่อว่า systemctl --failed)', 'ใช้ดูภาพรวมว่ามีบริการใดล่มอยู่บ้าง', 6, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('5e46fea2-ccdb-4732-aa06-8dbee689bba7', 'linux:04-process-service:fc07', 1, 'f18ea418-7710-44cb-b1b9-4a5724a2a92b', 'คำสั่งตรวจสถานะละเอียด และคำสั่งเช็กสถานะแบบสั้นของบริการ systemd', '• ดูสถานะละเอียด: systemctl status <service>
• เช็กสั้นๆ (active/failed): systemctl is-active <service>', 'status เทียบกับ is-active', 7, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('617638db-ed06-4a60-abcf-18fe318ee5cc', 'linux:04-process-service:fc08', 1, 'f18ea418-7710-44cb-b1b9-4a5724a2a92b', 'ความแตกต่างระหว่าง systemctl start กับ systemctl enable', '• systemctl start <service>: สั่งให้เริ่มทำงานทันทีในตอนนี้
• systemctl enable <service>: ตั้งค่าให้เริ่มทำงานอัตโนมัติเมื่อเปิดเครื่อง (Boot)', 'รันตอนนี้ เทียบกับ รันตอนบูต', 8, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('f1e9d281-2111-41a1-9978-ada6d508441f', 'linux:04-process-service:fc09', 1, 'f18ea418-7710-44cb-b1b9-4a5724a2a92b', 'คำสั่งดู Log ของบริการ nginx ย้อนหลัง 100 บรรทัด และติดตามแบบเรียลไทม์', 'journalctl -u nginx -n 100 -f

-u: ระบุชื่อ unit บริการ
-n 100: ย้อนหลัง 100 บรรทัด
-f: ติดตามสด (follow)', 'ใช้ journalctl คู่กับ -u, -n, -f', 9, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('0852e2dc-54ec-4a6f-b6b5-78fdaf169cca', 'linux:04-process-service:fc10', 1, 'f18ea418-7710-44cb-b1b9-4a5724a2a92b', 'คำสั่งดู Log ของบริการเฉพาะช่วงเวลา 30 นาทีล่าสุดด้วย journalctl', 'journalctl -u <service> --since "30 minutes ago"', 'ใช้ออปชัน --since', 10, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('0e275e66-e49f-4d34-85f7-5b017e2ab932', 'linux:04-process-service:fc11', 1, 'f18ea418-7710-44cb-b1b9-4a5724a2a92b', 'ชื่อบริการ Apache Web Server บน Ubuntu/Debian ต่างจาก RHEL/Rocky อย่างไร?', '• Ubuntu / Debian: apache2
• RHEL / Rocky Linux: httpd', 'จำว่าตระกูล Red Hat เรียกตามชื่อ daemon', 11, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('e123cad9-27ba-4fa1-a597-626a59cf5e2d', 'linux:04-process-service:fc12', 1, 'f18ea418-7710-44cb-b1b9-4a5724a2a92b', 'คำสั่งส่งสัญญาณปิดโปรเซสโดยระบุจากชื่อโปรแกรมแทนเลข PID', 'pkill <ชื่อโปรเซส>
(ก่อนรันควรตรวจด้วย pgrep -l <ชื่อโปรเซส> ก่อนเสมอว่าตรงกับตัวไหนบ้าง)', 'Process Kill by name', 12, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('8f06d8f5-9709-4910-90f9-d15b3f7ad21b', 'linux:05-text-tools:fc01', 1, 'f96ce3b7-1a44-4b37-b45c-aa3ee895c375', 'ความแตกต่างระหว่างเครื่องหมาย > กับ >> ในการ Redirect ผลลัพธ์', '• > : เขียนทับไฟล์เดิมทั้งหมดทันที (Overwrite)
• >> : เขียนต่อท้ายไฟล์เดิมโดยไม่ลบข้อมูลเก่า (Append)', 'ลูกศรเดียวทับ ลูกศรคู่ต่อท้าย', 1, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('433d2734-0d9f-4495-be49-7fcab61f1806', 'linux:05-text-tools:fc02', 1, 'f96ce3b7-1a44-4b37-b45c-aa3ee895c375', 'ความหมายของ 2>&1 ท้ายคำสั่ง Linux', 'รวมข้อความ Error (stderr = 2) เข้ากับช่องทางผลลัพธ์ปกติ (stdout = 1) เพื่อส่งต่อหรือบันทึกลงไฟล์เดียวกัน', '1 = stdout, 2 = stderr', 2, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('5d01c1c4-8bc4-4322-b45b-42267ee11cb3', 'linux:08-remote-access:fc12', 1, '75b271d2-e3ff-464b-be92-18b9ea5a0d05', 'ชื่อบริการ SSH Daemon บน Ubuntu/Debian เทียบกับ RHEL/Rocky Linux', '• Ubuntu / Debian: systemctl status ssh
• RHEL / Rocky Linux: systemctl status sshd', 'ssh กับ sshd', 12, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('6b76bbd4-0055-40be-a76f-a38dc56196bb', 'linux:05-text-tools:fc03', 1, 'f96ce3b7-1a44-4b37-b45c-aa3ee895c375', 'ตัวเลือก -i, -n, -r, -v ของคำสั่ง grep ทำหน้าที่อะไร?', '• -i : ไม่สนใจตัวพิมพ์เล็ก-ใหญ่ (ignore case)
• -n : แสดงเลขบรรทัด
• -r : ค้นหาทุกไฟล์ในโฟลเดอร์ย่อย (recursive)
• -v : เอาเฉพาะบรรทัดที่ไม่มีคำนั้น (invert match)', '4 ตัวเลือกที่ใช้บ่อยที่สุดของ grep', 3, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('47c155e0-ffb0-4082-b226-8ff4e7488e4a', 'linux:05-text-tools:fc04', 1, 'f96ce3b7-1a44-4b37-b45c-aa3ee895c375', 'คำสั่งค้นหาหลายคำพร้อมกัน (เช่น ERROR หรือ FATAL) ด้วย grep', 'grep -E "ERROR|FATAL" app.log', 'ใช้ออปชัน -E (Extended Regex) คู่กับเครื่องหมาย |', 4, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('da930cde-da3e-4557-9059-a8657fb332dd', 'linux:05-text-tools:fc05', 1, 'f96ce3b7-1a44-4b37-b45c-aa3ee895c375', 'คำสั่งแสดงบรรทัดก่อนหน้าและหลังบรรทัดที่ค้นพบอย่างละ 3 บรรทัดด้วย grep', 'grep -C 3 "Exception" app.log
(-B 3 = ก่อนหน้า 3 บรรทัด, -A 3 = หลัง 3 บรรทัด, -C 3 = ทั้งก่อนและหลัง)', 'C ย่อมาจาก Context', 5, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('28f0776e-a44f-4e4b-8c57-d2b698c973ba', 'linux:05-text-tools:fc06', 1, 'f96ce3b7-1a44-4b37-b45c-aa3ee895c375', 'คำสั่งนับจำนวนบรรทัดที่มีคำว่า ERROR ในไฟล์ app.log', 'grep "ERROR" app.log | wc -l
(หรือใช้ grep -c "ERROR" app.log)', 'wc -l = Word Count (lines)', 6, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('084c397a-036e-4f4f-8c12-53e85fdd86b4', 'linux:05-text-tools:fc07', 1, 'f96ce3b7-1a44-4b37-b45c-aa3ee895c375', 'คำสั่งดึงเฉพาะคอลัมน์ที่ 1 (เช่น IP Address) จากไฟล์ access.log ด้วย awk', 'awk ''{print $1}'' access.log
($1 คือคอลัมน์ที่ 1, $2 คือคอลัมน์ที่ 2 โดยแยกตามช่องว่างอัตโนมัติ)', 'ใช้เครื่องหมายดอลลาร์ตามด้วยเลขคอลัมน์ในเครื่องหมาย '' ''', 7, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('e0a3272e-204f-45d3-b8e5-57c42526aae7', 'linux:05-text-tools:fc08', 1, 'f96ce3b7-1a44-4b37-b45c-aa3ee895c375', 'ทำไมต้องใช้คำสั่ง sort ก่อนส่งข้อมูลเข้าคำสั่ง uniq -c เสมอ?', 'เพราะ uniq จะยุบรวมและนับเฉพาะบรรทัดซ้ำที่อยู่ติดกันเท่านั้น หากไม่ sort ก่อน บรรทัดที่ซ้ำแต่อยู่ห่างกันจะไม่ถูกนับรวมกัน', 'uniq ดูเฉพาะบรรทัดที่ติดกัน', 8, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('05846b42-eaa5-4d42-8618-7d888dfcc89c', 'linux:05-text-tools:fc09', 1, 'f96ce3b7-1a44-4b37-b45c-aa3ee895c375', 'สูตรคำสั่งหา Top 5 IP ที่เรียกเข้ามามากที่สุดจาก access.log', 'awk ''{print $1}'' access.log | sort | uniq -c | sort -nr | head -n 5', 'ดึงคอลัมน์ -> เรียงตัวอักษร -> นับซ้ำ -> เรียงตัวเลขมากไปน้อย -> ตัด 5 บรรทัดแรก', 9, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('d2fc1248-9566-4711-a522-5d3361cd6c91', 'linux:05-text-tools:fc10', 1, 'f96ce3b7-1a44-4b37-b45c-aa3ee895c375', 'คำสั่งตัดข้อความคอลัมน์ที่ 1 โดยใช้เครื่องหมาย : เป็นตัวคั่น (เช่นใน /etc/passwd)', 'cut -d'':'' -f1 /etc/passwd

-d'':'' : กำหนดตัวคั่น (delimiter)
-f1 : เลือกฟิลด์ที่ 1', 'cut คู่กับ -d และ -f', 10, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('f2511c96-66e6-46a9-afe6-6e32ba001c02', 'linux:05-text-tools:fc11', 1, 'f96ce3b7-1a44-4b37-b45c-aa3ee895c375', 'คำสั่งแสดงผลลัพธ์ออกหน้าจอพร้อมกับบันทึกเขียนลงไฟล์ในเวลาเดียวกัน', '<คำสั่ง> | tee output.log
(หากต้องการเขียนต่อท้ายไฟล์เดิมใช้ tee -a output.log)', 'ชื่อเหมือนข้อต่อท่อรูปตัว T', 11, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('c15e6db1-9d58-42e2-9052-38eb6bb28660', 'linux:05-text-tools:fc12', 1, 'f96ce3b7-1a44-4b37-b45c-aa3ee895c375', 'คำสั่งติดตามไฟล์ Log แบบสดๆ พร้อมกรองเฉพาะบรรทัดที่มีคำว่า ERROR', 'tail -f /var/log/app.log | grep "ERROR"', 'tail -f ส่งผ่าน pipe ไปยัง grep', 12, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('4260033d-4d9e-461d-9eca-2d20d20be6fa', 'linux:06-log-reading:fc01', 1, 'b5b35ad3-068d-4e04-b07b-670f9697aea3', 'ไฟล์ System Log หลักของ Ubuntu/Debian เทียบกับ RHEL/Rocky Linux', '• Ubuntu / Debian: /var/log/syslog
• RHEL / Rocky Linux: /var/log/messages', 'syslog กับ messages', 1, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('f944411f-0ff0-45d4-bbcd-8abed54872d3', 'linux:06-log-reading:fc02', 1, 'b5b35ad3-068d-4e04-b07b-670f9697aea3', 'ไฟล์เก็บประวัติการล็อกอิน SSH และ sudo ของ Ubuntu เทียบกับ RHEL', '• Ubuntu / Debian: /var/log/auth.log
• RHEL / Rocky Linux: /var/log/secure', 'auth.log กับ secure', 2, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('8dc97648-f2c7-4c72-879e-c1cd944384c3', 'linux:06-log-reading:fc03', 1, 'b5b35ad3-068d-4e04-b07b-670f9697aea3', 'คำสั่งกรอง Log ของบริการด้วย journalctl เฉพาะช่วงเวลาที่กำหนด', 'journalctl -u <service> --since "2026-11-03 10:00:00" --until "2026-11-03 10:30:00"', 'ใช้ --since และ --until', 3, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('82308232-8ded-4de8-ab16-37edd7424333', 'linux:06-log-reading:fc04', 1, 'b5b35ad3-068d-4e04-b07b-670f9697aea3', 'คำสั่งดูเฉพาะ Log ระดับ Error ขึ้นไปของรอบการบูตปัจจุบันด้วย journalctl', 'journalctl -p err -b
(-p err จะแสดงระดับ err, crit, alert, emerg)', '-p ย่อมาจาก priority, -b ย่อมาจาก boot', 4, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('b855b981-8633-4bbd-ac09-103864a0d598', 'linux:06-log-reading:fc05', 1, 'b5b35ad3-068d-4e04-b07b-670f9697aea3', 'คำสั่งดูบันทึกของ Kernel (เช่น OOM Killer หรือ Disk Error) พร้อมแสดงเวลาที่อ่านง่าย', 'dmesg -T
(หรือกรองด้วย dmesg -T | grep -iE "oom|error")', '-T แปลงเวลาวินาทีเป็นวันที่และเวลา', 5, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('d2342cf1-94a3-4bc3-bca7-70cbb09820ac', 'linux:06-log-reading:fc06', 1, 'b5b35ad3-068d-4e04-b07b-670f9697aea3', 'คำสั่งค้นหาข้อความและเปิดอ่านไฟล์ Log ที่ถูกบีบอัดเป็น .gz โดยไม่ต้องแตกไฟล์', '• ค้นหาข้อความ: zgrep "ERROR" /var/log/app.log.1.gz
• เปิดอ่านทีละหน้า: zless /var/log/app.log.1.gz
• แสดงเนื้อหา: zcat /var/log/app.log.1.gz', 'เติมตัว z นำหน้าคำสั่งปกติ', 6, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('b6e52805-54ee-432d-a299-62abdaa0a6f1', 'linux:06-log-reading:fc07', 1, 'b5b35ad3-068d-4e04-b07b-670f9697aea3', 'logrotate ทำหน้าที่อะไรในระบบ Linux?', 'ตัดรอบไฟล์ Log เก่าตามเวลาหรือขนาดที่กำหนด เปลี่ยนชื่อต่อท้าย และบีบอัดเป็น .gz พร้อมลบไฟล์เก่าเกินกำหนดเพื่อป้องกันดิสก์เต็ม', 'ป้องกันไม่ให้ไฟล์ Log ไฟล์เดียวโตจนดิสก์เต็ม', 7, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('8137c128-a719-4254-8c4e-8139f8493473', 'linux:06-log-reading:fc08', 1, 'b5b35ad3-068d-4e04-b07b-670f9697aea3', 'คำสั่งตรวจสอบเวลาปัจจุบันและ Timezone ของเครื่องเซิร์ฟเวอร์', 'timedatectl หรือ date', 'ต้องเช็กเสมอก่อนเทียบเวลา Log กับเวลาที่ผู้ใช้แจ้ง', 8, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('178af316-ec5a-4daa-b6b3-f99b9a3fb790', 'linux:08-remote-access:fc05', 1, '75b271d2-e3ff-464b-be92-18b9ea5a0d05', 'คำสั่งสร้างคู่กุญแจ SSH แบบ Ed25519 และคำสั่งส่ง Public Key ไปยังเซิร์ฟเวอร์', '• สร้างกุญแจ: ssh-keygen -t ed25519
• ส่ง Public Key: ssh-copy-id user@host', 'สร้างด้วย ssh-keygen ส่งด้วย ssh-copy-id', 5, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('98ac57fe-20c6-4022-94c2-44ccd0fa2dfb', 'network:01-ip-subnetting:fc05', 2, 'd8929572-6865-40b4-bf65-a32bfcdb15a5', 'คำสั่งใดบน Linux ใช้ตรวจสอบ Routing Table และ Default Gateway?', 'ip route show หรือ ip route', 'ip route', 5, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('0ca50cdf-cc23-4db0-8a81-bdbe6db62445', 'linux:06-log-reading:fc09', 1, 'b5b35ad3-068d-4e04-b07b-670f9697aea3', 'หากเครื่องเซิร์ฟเวอร์ตั้งเวลาเป็น UTC แล้วผู้ใช้แจ้งว่าเกิดปัญหาเวลา 14:00 น. (เวลาไทย) ต้องดู Log เวลาใด?', 'เวลา 07:00 UTC
(เวลาไทย GMT+7 เร็วกว่า UTC 7 ชั่วโมง ดังนั้นต้องลบออก 7 ชั่วโมง)', 'UTC + 7 = เวลาไทย', 9, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('12f3d939-a6a2-415c-98af-7dee18272d41', 'linux:06-log-reading:fc10', 1, 'b5b35ad3-068d-4e04-b07b-670f9697aea3', 'ไฟล์ access.log กับ error.log ของ Web Server (เช่น Nginx) เก็บข้อมูลต่างกันอย่างไร?', '• access.log: บันทึกทุก HTTP Request ที่เรียกเข้ามา (IP, URL, HTTP Status 200/404/500, เวลาตอบสนอง)
• error.log: บันทึกข้อผิดพลาดของตัว Web Server หรือการเชื่อมต่อ Upstream ไม่สำเร็จ', 'ประวัติการเข้าชม เทียบกับ ข้อผิดพลาดของระบบ', 10, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('44eb1f52-f82a-4234-994d-c0d529e7f28f', 'linux:06-log-reading:fc11', 1, 'b5b35ad3-068d-4e04-b07b-670f9697aea3', 'หากโปรเซสฐานข้อมูลดับไปเองโดยไม่มี Error ในไฟล์ Log ของแอปเลย ควรตรวจที่ไหน?', 'ตรวจ Kernel Log ด้วยคำสั่ง:
dmesg -T | grep -iE "oom|killed"
เพราะอาจถูก Kernel OOM Killer ส่ง SIGKILL ตัดการทำงานกะทันหัน', 'โปรเซสไม่มีโอกาสเขียน Log ของตัวเองเพราะถูก Kernel ตัดทันที', 11, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('ccf5d047-49e1-4669-99c1-a6e1abfc011d', 'linux:06-log-reading:fc12', 1, 'b5b35ad3-068d-4e04-b07b-670f9697aea3', 'สิ่งที่ต้องแนบเมื่อส่งต่อ (Escalate) ปัญหาจาก Log ให้ทีม Tier 2', '1. ชื่อเครื่อง (Hostname) และพาธไฟล์ Log
2. ช่วงเวลาที่เกิดเหตุพร้อมระบุ Timezone (เช่น UTC หรือ +07)
3. ข้อความ Error พร้อมบริบทรอบข้าง (grep -C)
4. Request ID / Transaction ID ที่เกี่ยวข้อง', 'ครบ 4 องค์ประกอบหลัก', 12, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('42da51ab-d158-4e4e-ba98-8e30a1f609d2', 'linux:07-disk-memory-cpu:fc01', 1, '5f86a586-91de-4a51-b749-fcf6d837849f', 'ความแตกต่างระหว่างคำสั่ง df -h กับ df -i', '• df -h : ตรวจสอบความจุพื้นที่ดิสก์ในหน่วย KB/MB/GB (Use%)
• df -i : ตรวจสอบจำนวน Inode หรือสารบัญไฟล์ที่ใช้ไป (IUse%)', 'h = human-readable size, i = inodes', 1, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('26d84fd4-7648-4065-8e4e-9680b9ffcb07', 'linux:07-disk-memory-cpu:fc02', 1, '5f86a586-91de-4a51-b749-fcf6d837849f', 'ทำไมระบบถึงฟ้อง No space left on device ทั้งที่ df -h ยังมีพื้นที่ว่างเหลือหลาย GB?', 'เพราะจำนวน Inode เต็ม 100% (ตรวจด้วย df -i) มักเกิดจากการมีไฟล์ขนาดเล็กจำนวนมหาศาลอยู่ในพาร์ทิชันนั้น', '1 ไฟล์ต้องใช้ 1 Inode เสมอ', 2, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('560beb43-e745-4547-a44c-ebef41a5b522', 'linux:07-disk-memory-cpu:fc03', 1, '5f86a586-91de-4a51-b749-fcf6d837849f', 'คำสั่งเรียงลำดับขนาดโฟลเดอร์ย่อยจากน้อยไปมากในหน่วยอ่านง่าย', 'du -sh * | sort -h
(-h ใน sort ช่วยให้เรียงลำดับหน่วย K, M, G ได้ถูกต้อง)', 'du -sh คู่กับ sort -h', 3, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('705dd8ec-e528-4203-add1-7d65d409e7c9', 'linux:08-remote-access:fc06', 1, '75b271d2-e3ff-464b-be92-18b9ea5a0d05', 'เมื่อเซิร์ฟเวอร์ปลายทางถูกลง OS ใหม่แล้วขึ้น REMOTE HOST IDENTIFICATION HAS CHANGED แก้ด้วยคำสั่งใด?', 'ssh-keygen -R <hostname_หรือ_IP>
(ต้องยืนยันกับทีม Infra ก่อนเสมอว่ามีการ Rebuild เครื่องจริง)', '-R = Remove host key จาก known_hosts', 6, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('a3365071-d8b4-41f0-9ead-7f7fe9de4e5f', 'linux:08-remote-access:fc07', 1, '75b271d2-e3ff-464b-be92-18b9ea5a0d05', 'เมื่อรัน ssh แล้วขึ้น Permission denied (publickey) เกิดจากสาเหตุใดได้บ้าง?', '1. ใช้ชื่อ user ผิด หรือระบุไฟล์กุญแจ (-i) ผิดดอก
2. ยังไม่ได้นำ Public Key ไปใส่ใน ~/.ssh/authorized_keys ของปลายทาง
3. สิทธิ์ของ ~/.ssh (ต้อง 700) หรือ authorized_keys (ต้อง 600) เปิดกว้างเกินไป', 'ตรวจทั้งฝั่งเรากับฝั่งปลายทางด้วย ssh -v', 7, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('7420622e-a39b-4c0e-8c0c-ed68d3709e50', 'linux:08-remote-access:fc08', 1, '75b271d2-e3ff-464b-be92-18b9ea5a0d05', 'ความแตกต่างระหว่าง scp กับ rsync -avz ในการโอนไฟล์', '• scp: คัดลอกไฟล์ทั้งหมดตั้งแต่ต้นใหม่ทุกครั้ง เหมาะกับไฟล์เดียวขนาดไม่ใหญ่
• rsync -avz: เปรียบเทียบและส่งเฉพาะส่วนที่ต่างกัน บีบอัดข้อมูลระหว่างส่ง (-z) และต่อไฟล์ที่ค้างได้', 'rsync เหมาะกับโฟลเดอร์ใหญ่หรือการซิงก์ซ้ำ', 8, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('6e9042d4-7e39-42fa-9147-9b7eb8049f65', 'linux:08-remote-access:fc09', 1, '75b271d2-e3ff-464b-be92-18b9ea5a0d05', 'ตัวเลือก -a, -v, -z ในคำสั่ง rsync -avz หมายถึงอะไร?', '• -a (archive): คัดลอกทั้งโฟลเดอร์ย่อยพร้อมคงสิทธิ์ เจ้าของ และเวลาเดิม
• -v (verbose): แสดงรายชื่อไฟล์ที่กำลังโอน
• -z (compress): บีบอัดข้อมูลระหว่างส่งผ่านเครือข่าย', 'Archive, Verbose, Compress', 9, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('ae602e48-6182-4dc2-8cb0-3686b0a02c3e', 'linux:08-remote-access:fc10', 1, '75b271d2-e3ff-464b-be92-18b9ea5a0d05', 'คำสั่งพื้นฐานของ tmux: สร้างเซสชันใหม่, ดูรายการเซสชัน และกลับเข้าเซสชันเดิม', '• สร้างเซสชัน: tmux new -s <ชื่อ>
• ดูรายการเซสชัน: tmux ls
• กลับเข้าเซสชันเดิม: tmux attach -t <ชื่อ> (หรือ tmux a -t <ชื่อ>)', 'new, ls, attach', 10, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('2f4f3eb9-5e6a-4f10-9dc7-7bbbee8b397e', 'linux:08-remote-access:fc11', 1, '75b271d2-e3ff-464b-be92-18b9ea5a0d05', 'ปุ่มลัดสำหรับถอยออกจากหน้าจอ tmux (Detach) โดยปล่อยให้โปรแกรมทำงานต่อเบื้องหลัง', 'กด Ctrl + b (แล้วปล่อยมือ) จากนั้นกดปุ่ม d', 'd ย่อมาจาก detach', 11, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('98baeaf2-62c1-4b29-93f8-830fce9d4995', 'linux:09-cron-schedule:fc01', 1, '5a93786b-3b53-4b51-8232-c77e8324453b', 'ลำดับความหมายของเวลา 5 ฟิลด์ใน Crontab (* * * * *)', '1. นาที (0 - 59)
2. ชั่วโมง (0 - 23)
3. วันที่ในเดือน (1 - 31)
4. เดือน (1 - 12)
5. วันในสัปดาห์ (0 - 7 โดย 0 และ 7 คือวันอาทิตย์)', 'นาที -> ชั่วโมง -> วันที่ -> เดือน -> วันในสัปดาห์', 1, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('a37022a7-a410-4084-9ebd-81a52ba2324a', 'linux:09-cron-schedule:fc02', 1, '5a93786b-3b53-4b51-8232-c77e8324453b', 'รูปแบบเวลา Crontab สำหรับรันทุกๆ 15 นาที และรันทุกวันเวลา 02:30 น.', '• ทุกๆ 15 นาที: */15 * * * *
• ทุกวันเวลา 02:30 น.: 30 2 * * *', 'ใช้ */15 ในฟิลด์นาที', 2, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('8dd4b8d8-4072-40e0-9442-397afb9f0a34', 'linux:09-cron-schedule:fc03', 1, '5a93786b-3b53-4b51-8232-c77e8324453b', 'ความหมายของคำย่อ @reboot และ @daily ใน Crontab', '• @reboot : รัน 1 ครั้งหลังจากเครื่องบูตเสร็จ
• @daily (หรือ @midnight) : รันวันละครั้งตอนเวลา 00:00 น. (เทียบเท่า 0 0 * * *)', 'ใช้แทนตัวเลข 5 ฟิลด์ได้', 3, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('c3b5afcf-5f60-4207-aef3-ca1dd84296eb', 'linux:09-cron-schedule:fc04', 1, '5a93786b-3b53-4b51-8232-c77e8324453b', 'คำสั่งดูรายการ Crontab ของตัวเอง และคำสั่งดูของ user อื่น (เช่น appuser)', '• ของตัวเอง: crontab -l
• ของผู้ใช้คนอื่น: sudo crontab -u appuser -l', '-l = list, -u = user', 4, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('da0f36ae-5349-4e00-9c62-219a069a1983', 'linux:09-cron-schedule:fc05', 1, '5a93786b-3b53-4b51-8232-c77e8324453b', 'ทำไมห้ามเผลอพิมพ์คำสั่ง crontab -r เด็ดขาด?', 'เพราะ -r (remove) จะลบตาราง Crontab ทั้งหมดของผู้ใช้นั้นทิ้งทันทีโดยไม่ถามยืนยัน (ให้ใช้เฉพาะ crontab -l ในการตรวจสอบ)', 'ปุ่ม r อยู่ติดกับปุ่ม e บนคีย์บอร์ด', 5, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('175022d6-d009-4c14-b8ca-0380f124eaa4', 'linux:10-health-check:fc10', 1, '9ed1b0db-122c-4d06-9d9c-bd4613afd6dd', 'curl exit code 6, 7, 28 และ 60 หมายถึงอะไร', '• 6: Resolve host ไม่ได้ (DNS)
• 7: Connect ไม่ได้ (refused)
• 28: Timeout
• 60: ปัญหาใบรับรอง SSL', 'DNS, Connect, Timeout, Cert', 10, '2026-11-03 16:05:54.729798+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('3ba2ea29-42d9-4b7d-9915-be7d6c9341aa', 'linux:09-cron-schedule:fc06', 1, '5a93786b-3b53-4b51-8232-c77e8324453b', 'ความต่างระหว่างบรรทัดใน User Crontab (crontab -e) กับไฟล์ใน /etc/cron.d/', '• User Crontab: มี 5 ฟิลด์เวลา ตามด้วยคำสั่งทันที
• /etc/cron.d/ และ /etc/crontab: ต้องระบุชื่อผู้ใช้ (username) แทรกเป็นคอลัมน์ที่ 6 ก่อนคำสั่งเสมอ', 'ระดับระบบต้องระบุว่ารันในสิทธิ์ของ user ใด', 6, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('6c116e09-ffcb-4488-9149-3d65500f6c71', 'linux:09-cron-schedule:fc07', 1, '5a93786b-3b53-4b51-8232-c77e8324453b', 'ชื่อบริการและตำแหน่งไฟล์ Log ของ Cron บน Ubuntu เทียบกับ RHEL', '• Ubuntu / Debian:
  - บริการ: systemctl status cron
  - Log: grep CRON /var/log/syslog
• RHEL / Rocky Linux:
  - บริการ: systemctl status crond
  - Log: /var/log/cron', 'cron/syslog เทียบกับ crond/cron', 7, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('146c6b20-16cd-440d-85ef-877c6b1f1178', 'network:01-ip-subnetting:fc01', 2, 'd8929572-6865-40b4-bf65-a32bfcdb15a5', 'Subnet Mask มีหน้าที่อะไรในระบบเครือข่าย?', 'แยกแยะว่าส่วนใดของ IP Address คือ Network ID (บอกเครือข่าย) และส่วนใดคือ Host ID (บอกเครื่องปลายทาง)', 'Network ID vs Host ID', 1, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('976e621c-2cf8-4f2f-9bbd-76ca176d48cc', 'linux:09-cron-schedule:fc08', 1, '5a93786b-3b53-4b51-8232-c77e8324453b', 'ทำไมสคริปต์ที่รันด้วยมือผ่านปกติ พอนำไปใส่ใน Cron แล้วมักฟ้อง command not found?', 'เพราะสภาพแวดล้อมของ Cron มีค่าตัวแปร PATH จำกัดมาก (มักมีแค่ /usr/bin:/bin)
วิธีแก้: ต้องระบุ Absolute Path เต็มของทุกคำสั่งและทุกไฟล์ในสคริปต์', 'ปัญหาเรื่องตัวแปร PATH', 8, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('cc9db3aa-bc16-4649-bfd8-e1105124e65c', 'linux:09-cron-schedule:fc09', 1, '5a93786b-3b53-4b51-8232-c77e8324453b', 'ทำไมควรต่อท้ายบรรทัด Crontab ด้วย >> /var/log/app/job.log 2>&1 เสมอ?', 'เพื่อบันทึกทั้งผลลัพธ์ปกติ (stdout) และข้อความ Error (stderr) ลงไฟล์ Log มิฉะนั้นเมื่อสคริปต์รันพังจะไม่มีข้อความ Error เก็บไว้ตรวจสอบ', 'Log ของระบบ Cron บอกแค่ว่าสั่งรันหรือยัง แต่ไม่บอก Error ข้างในสคริปต์', 9, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('1d598216-9d11-4f56-ad77-c685f1a5efc6', 'linux:09-cron-schedule:fc10', 1, '5a93786b-3b53-4b51-8232-c77e8324453b', 'ข้อควรระวังเมื่อใช้เครื่องหมาย % (เช่น date +%Y%m%d) ในบรรทัด Crontab', 'ใน Crontab เครื่องหมาย % จะถูกตีความเป็นการขึ้นบรรทัดใหม่ (Newline)
ต้องใส่ Backslash นำหน้าเป็น \% ทุกตัว (เช่น date +\%Y\%m\%d) หรือย้ายคำสั่งเข้าไฟล์ .sh', 'ต้อง Escape เครื่องหมาย % ด้วย \', 10, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('b786df76-a5a5-49ea-a1f2-6a991a39dc67', 'linux:09-cron-schedule:fc11', 1, '5a93786b-3b53-4b51-8232-c77e8324453b', 'คำสั่งตรวจสอบรายการงานตั้งเวลาที่ทำงานผ่าน systemd timer', 'systemctl list-timers --all', 'ใช้เมื่อหาใน crontab ไม่เจอ', 11, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('c59aadac-dc44-4217-890f-8c2113444ba5', 'linux:09-cron-schedule:fc12', 1, '5a93786b-3b53-4b51-8232-c77e8324453b', 'หากตั้งเวลาใน Cron เป็น 02:00 น. แต่งานกลับรันตอน 09:00 น. เวลาไทย เกิดจากอะไร?', 'Timezone ของเครื่องเซิร์ฟเวอร์ตั้งเป็น UTC (+0000) ซึ่งช้ากว่าเวลาไทย 7 ชั่วโมง (02:00 UTC = 09:00 เวลาไทย)
ตรวจด้วยคำสั่ง timedatectl', 'Cron ยึดเวลาตาม Timezone ของเครื่อง', 12, '2026-11-03 10:24:40.983748+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('2ba0b4e4-9657-4e28-9e90-13d8186bb930', 'linux:10-health-check:fc01', 1, '9ed1b0db-122c-4d06-9d9c-bd4613afd6dd', 'ลำดับตรวจเมื่อระบบเข้าไม่ได้', '1. Service รันไหม: systemctl is-active
2. Port ฟังไหม: ss -tulpn
3. ต่อจากภายนอกได้ไหม: nc -zv
4. HTTP ตอบไหม: curl -I', 'ล่างขึ้นบน หยุดที่ชั้นแรกที่ผิด', 1, '2026-11-03 16:05:54.729798+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('cf489d3f-447a-4d33-9f76-15acc0793050', 'linux:10-health-check:fc02', 1, '9ed1b0db-122c-4d06-9d9c-bd4613afd6dd', 'systemctl is-active กับ is-enabled ต่างกันอย่างไร', '• is-active: ตอนนี้รันอยู่ไหม (active/inactive/failed)
• is-enabled: เริ่มอัตโนมัติตอนบูตไหม (enabled/disabled)', 'ตอนนี้ เทียบกับ ตอนบูต', 2, '2026-11-03 16:05:54.729798+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('11133e98-a7ed-4af2-b8ec-1b1eb3e18d66', 'linux:10-health-check:fc03', 1, '9ed1b0db-122c-4d06-9d9c-bd4613afd6dd', 'คำสั่งดูทุก Port ที่ฟังอยู่พร้อมชื่อ Process', 'sudo ss -tulpn

t TCP, u UDP, l Listening, p Process, n ตัวเลข', 'จำคำว่า tulpn', 3, '2026-11-03 16:05:54.729798+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('126de0c0-1b25-416d-a498-2add15fd11be', 'linux:10-health-check:fc04', 1, '9ed1b0db-122c-4d06-9d9c-bd4613afd6dd', 'คำสั่งกรองเฉพาะ Port 8080 ที่ฟังอยู่', 'sudo ss -ltnp ''sport = :8080''', 'ใช้ตัวกรอง sport', 4, '2026-11-03 16:05:54.729798+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('6253bf44-ca86-4e47-88bb-f4afecd8582f', 'linux:10-health-check:fc05', 1, '9ed1b0db-122c-4d06-9d9c-bd4613afd6dd', 'Local Address 127.0.0.1:8080 กับ 0.0.0.0:8080 ต่างกันอย่างไร', '• 127.0.0.1:8080: รับเฉพาะการเชื่อมต่อในเครื่องตัวเอง
• 0.0.0.0:8080: ฟังทุก Interface เครื่องอื่นต่อเข้ามาได้ (ถ้า Firewall ไม่บล็อก)', 'ดูว่ารับจากใคร', 5, '2026-11-03 16:05:54.729798+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('0d7f0e7d-b852-4cd3-888f-4f08df94675c', 'linux:10-health-check:fc06', 1, '9ed1b0db-122c-4d06-9d9c-bd4613afd6dd', 'คำสั่งหาว่า Process ไหนใช้ Port 8080', 'sudo lsof -i :8080
(หรือ sudo ss -ltnp ''sport = :8080'')', 'List Open Files แบบ Network', 6, '2026-11-03 16:05:54.729798+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('44006424-587f-4f05-ac5c-8cd9c38c8560', 'linux:10-health-check:fc07', 1, '9ed1b0db-122c-4d06-9d9c-bd4613afd6dd', 'คำสั่งทดสอบต่อ TCP Port ปลายทางโดยไม่ส่งข้อมูล', 'nc -zv <host> <port>

z = สแกนเฉยๆ, v = แสดงผล', 'netcat', 7, '2026-11-03 16:05:54.729798+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('3b3477ab-2f44-4fad-8b51-b5dccc6d89c0', 'linux:10-health-check:fc08', 1, '9ed1b0db-122c-4d06-9d9c-bd4613afd6dd', 'ถ้าไม่มี nc จะทดสอบต่อ Port ได้อย่างไร', 'timeout 3 bash -c ''</dev/tcp/<host>/<port>'' && echo open', 'ใช้ bash ต่อ TCP เอง', 8, '2026-11-03 16:05:54.729798+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('3f6ab51f-3ba8-49e3-a7bc-b8e82126ed74', 'linux:10-health-check:fc09', 1, '9ed1b0db-122c-4d06-9d9c-bd4613afd6dd', 'curl พิมพ์เฉพาะ Status Code กับเวลาที่ใช้', 'curl -sS -o /dev/null -w "%{http_code} %{time_total}s\n" --max-time 10 <URL>', '-w กำหนดรูปแบบผลลัพธ์', 9, '2026-11-03 16:05:54.729798+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('c8ed3813-155e-4a0a-951d-9ce8a41ed015', 'linux:10-health-check:fc11', 1, '9ed1b0db-122c-4d06-9d9c-bd4613afd6dd', 'HTTP 502, 503 และ 504 ต่างกันอย่างไร', '• 502: Backend ตอบไม่ถูกต้องหรือต่อไม่ได้
• 503: Service ไม่พร้อม (ล้น/ปิดปรับปรุง)
• 504: Backend ตอบช้าจนเกิน Timeout', 'Bad Gateway, Unavailable, Gateway Timeout', 11, '2026-11-03 16:05:54.729798+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('8c2b9041-e64e-4df8-a6dd-2b4c6daad929', 'linux:10-health-check:fc12', 1, '9ed1b0db-122c-4d06-9d9c-bd4613afd6dd', 'ข้อควรระวังเรื่อง curl -k และการใส่ข้อมูลลับในคำสั่ง', '• -k ข้ามการตรวจใบรับรอง ใช้แยกปัญหาเท่านั้น และต้องบอกใน Ticket
• ห้ามใส่ Token หรือรหัสผ่านจริงในคำสั่งที่จะแปะ Ticket', 'ความปลอดภัยก่อนความสะดวก', 12, '2026-11-03 16:05:54.729798+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('0b61972f-aeae-4d8f-8e60-191816dfa9c1', 'network:01-ip-subnetting:fc03', 2, 'd8929572-6865-40b4-bf65-a32bfcdb15a5', 'ทำไม Subnet /24 (256 IP) จึงใช้งานเป็น Host ได้จริงเพียง 254 IP?', 'เพราะต้องหักออก 2 ค่าเสมอ คือ:
1. Network IP (IP แรก เช่น .0)
2. Broadcast IP (IP สุดท้าย เช่น .255)', 'Network ID และ Broadcast ID', 3, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('9f3bef19-c8be-4f69-ae1f-71e74a187881', 'network:01-ip-subnetting:fc04', 2, 'd8929572-6865-40b4-bf65-a32bfcdb15a5', 'IP ขึ้นต้นด้วย 169.254.x.x คืออะไรและเกิดขึ้นเมื่อใด?', 'APIPA (Automatic Private IP Addressing) เกิดขึ้นเมื่อเครื่องขอ IP จาก DHCP Server ไม่สำเร็จ หรือสาย LAN ไม่เชื่อมต่อ', 'DHCP Request Failed', 4, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('73f46202-06f4-41de-ab9e-7fe66c90b186', 'network:02-dns-resolution:fc01', 2, '04cb05e0-09ef-4ee4-8cf5-1ed7d502bbfe', 'ลำดับแรกที่ระบบปฏิบัติการ Linux ตรวจสอบเมื่อ Resolve โดเมนคือที่ใด?', 'ไฟล์ Local Hosts (`/etc/hosts`)', '/etc/hosts', 1, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('fac22337-965c-4ad4-b1b7-4250c59e0635', 'network:02-dns-resolution:fc02', 2, '04cb05e0-09ef-4ee4-8cf5-1ed7d502bbfe', 'A Record กับ CNAME Record ต่างกันอย่างไร?', 'A Record แมปชื่อโดเมนเข้ากับ IPv4 Address โดยตรง
CNAME (Canonical Name) เป็นชื่อ Alias ที่ชี้ไปยังอีกชื่อโดเมนหนึ่ง', 'IP vs Alias domain', 2, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('e001504d-31c9-4ca0-9f91-398a4bd8159e', 'network:02-dns-resolution:fc03', 2, '04cb05e0-09ef-4ee4-8cf5-1ed7d502bbfe', 'คำสั่ง dig ใดใช้บังคับ query ไปยัง DNS 1.1.1.1 เพื่อดึงค่า A record แบบสั้น?', 'dig @1.1.1.1 domain.com +short', 'dig @server +short', 3, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('2bf91248-71bd-4299-b83a-ebead45cca65', 'network:02-dns-resolution:fc04', 2, '04cb05e0-09ef-4ee4-8cf5-1ed7d502bbfe', 'DNS TTL (Time-To-Live) ส่งผลต่อการเปลี่ยน IP อย่างไร?', 'Resolver จะจำ IP เดิมไว้จนกว่าเวลา TTL จะนับถอยหลังหมดลง จึงเกิดช่วงหน่วงที่เรียกว่า DNS Propagation Delay', 'Caching expiration time', 4, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('4e21aa5c-b4bc-44ce-b486-92abff7e4c5d', 'network:02-dns-resolution:fc05', 2, '04cb05e0-09ef-4ee4-8cf5-1ed7d502bbfe', 'ไฟล์คอนฟิกใดบน Linux ที่เก็บรายชื่อ DNS Nameserver ของระบบ?', '/etc/resolv.conf (ระบุด้วยบรรทัด nameserver X.X.X.X)', '/etc/resolv.conf', 5, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('bf58d304-b4a1-4065-bb9b-eb58c5d08183', 'network:03-routing-latency:fc01', 2, '240e3caf-58b9-4b37-9d41-8d7a2830fe79', 'คำสั่ง ping ใช้โปรโตคอลใดในการส่งข้อความตรวจสอบเครือข่าย?', 'ICMP (Internet Control Message Protocol) โดยส่ง Echo Request (Type 8) และรอรับ Echo Reply (Type 0)', 'ICMP', 1, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('be70769c-efa1-4867-b0ff-b8d52a94bcf9', 'network:03-routing-latency:fc02', 2, '240e3caf-58b9-4b37-9d41-8d7a2830fe79', 'traceroute ใช้กลไกใดของ IP Packet ในการระบุแต่ละ Hop ตลอดเส้นทาง?', 'ตั้งค่า TTL (Time-To-Live) เริ่มจาก 1 แล้วเพิ่มทีละ 1 เพื่อให้เราเตอร์ส่ง ICMP Time Exceeded กลับมา', 'TTL (Time-To-Live)', 2, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('b2fe5397-a5d5-4aac-b4bf-234a9cb68486', 'network:03-routing-latency:fc03', 2, '240e3caf-58b9-4b37-9d41-8d7a2830fe79', 'เครื่องมือ mtr มีข้อดีเหนือกว่า traceroute ทั่วไปอย่างไร?', 'รวมความสามารถของ ping และ traceroute เข้าด้วยกัน โดยส่งแพ็กเก็ตทดสอบต่อเนื่องแบบ Real-time และสรุปค่า Packet Loss/Latency ของแต่ละ Hop ได้แม่นยำ', 'Real-time + Packet Loss per Hop', 3, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('69424af8-2aa7-4acd-8cc1-ba54691d16ba', 'network:03-routing-latency:fc04', 2, '240e3caf-58b9-4b37-9d41-8d7a2830fe79', 'ทำไมการรัน traceroute จึงควรใส่แฟล็ก -n?', 'เพื่อไม่ให้เสียเวลา Reverse DNS แปลง IP เป็นชื่อโฮสต์ ทำให้แสดงผลได้เร็วขึ้นทันที', 'Numeric output (No DNS lookup)', 4, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('107c306f-d618-47aa-8fed-492f0b3937c3', 'network:04-tcp-ports-firewall:fc01', 2, '3ff8610b-94c3-43a7-8e1f-436f27946647', 'ขั้นตอน 3 ลำดับของ TCP 3-Way Handshake มีอะไรบ้าง?', '1. Client ส่ง SYN
2. Server ตอบ SYN-ACK
3. Client ส่ง ACK ยืนยัน
(จากนั้นเข้าสู่สถานะ ESTABLISHED)', 'SYN -> SYN-ACK -> ACK', 1, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('db65ec84-9021-416c-8e8d-93994de26344', 'network:04-tcp-ports-firewall:fc02', 2, '3ff8610b-94c3-43a7-8e1f-436f27946647', 'เมื่อใดที่เซิร์ฟเวอร์จะส่งแพ็กเก็ต TCP RST กลับมายัง Client?', 'เมื่อมี Client พยายามเชื่อมต่อมาที่พอร์ตที่ไม่มีแอปพลิเคชันใดเปิดรับ (LISTEN) อยู่ ทำให้ Client ได้รับข้อความ Connection Refused', 'ไม่มีใครฟังพอร์ต หรือ Service ปลายทางดับ', 2, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('e82de9db-c95c-47f3-b499-05d0623ce250', 'network:04-tcp-ports-firewall:fc03', 2, '3ff8610b-94c3-43a7-8e1f-436f27946647', 'คำสั่งใดบน Linux ใช้ตรวจสอบพอร์ต TCP/UDP ที่เปิดฟังอยู่พร้อมระบุ Process Name?', 'sudo ss -tulpn
(-t: TCP, -u: UDP, -l: Listen, -p: Process, -n: Numeric)', 'ss -tulpn', 3, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('ae2a7eff-24d3-44a1-90be-6aadb4f57cc2', 'network:04-tcp-ports-firewall:fc04', 2, '3ff8610b-94c3-43a7-8e1f-436f27946647', 'หากแอปพลิเคชัน bind อยู่ที่ 127.0.0.1 ต่างจาก 0.0.0.0 อย่างไร?', '127.0.0.1 รับการเชื่อมต่อเฉพาะภายในเครื่องตัวเอง (Localhost) เท่านั้น
0.0.0.0 รับการเชื่อมต่อจากทุก Network Interface (เปิดให้ภายนอกเข้าถึงได้)', 'Localhost only vs All interfaces', 4, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('73cb0262-ede6-4151-8fbf-580bf1295eaa', 'network:04-tcp-ports-firewall:fc05', 2, '3ff8610b-94c3-43a7-8e1f-436f27946647', 'ทำไม Firewall ปลายทางแบบ DROP จึงทำให้เกิดอาการ Connection Timed Out?', 'เพราะนโยบาย DROP จะทิ้งแพ็กเก็ต SYN เงียบๆ โดยไม่ส่งคำตอบใดๆ กลับมา ทำให้ Client ต้องรอจนกว่าจะหมดเวลา Timeout', 'DROP = Silent drop without reply', 5, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('d6ad8ddb-d0d0-4669-b63e-ad14cb5a5aa2', 'sql:01-queries-joins:fc01', 3, '5a3d9602-fb56-4f50-b4fa-c231d799a302', 'INNER JOIN กับ LEFT JOIN ให้ผลลัพธ์ต่างกันอย่างไร?', 'INNER JOIN คืนเฉพาะแถวที่เงื่อนไขตรงกันทั้ง 2 ฝั่ง
LEFT JOIN คืนแถวจากตารางฝั่งซ้ายทั้งหมด หากฝั่งขวาไม่มีคู่จะแสดงเป็น NULL', 'Intersection vs Left Table All', 1, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('dec48697-569c-461d-93eb-501ae8029dd9', 'sql:01-queries-joins:fc02', 3, '5a3d9602-fb56-4f50-b4fa-c231d799a302', 'เทคนิค Anti-Join ใช้สำหรับอะไรในงาน Support?', 'ใช้ค้นหาข้อมูลที่ไม่มีคู่หรือตกหล่น เช่น หาผู้ใช้ที่ไม่มีประวัติสั่งซื้อ ด้วยรูปแบบ: LEFT JOIN ... WHERE right_table.id IS NULL', 'LEFT JOIN + WHERE IS NULL', 2, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('d106a2a8-9116-47e1-ad1e-dd82caf8de73', 'sql:01-queries-joins:fc03', 3, '5a3d9602-fb56-4f50-b4fa-c231d799a302', 'ทำไมการเช็ค NULL ด้วย ''WHERE col = NULL'' จึงผิดเสมอ?', 'เพราะ NULL คือ Unknown ไม่สามารถเปรียบเทียบด้วยเครื่องหมาย = ได้ ต้องใช้ไวยากรณ์ ''IS NULL'' หรือ ''IS NOT NULL'' เท่านั้น', 'ต้องใช้ IS NULL', 3, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('65108b55-db1f-46c1-a46b-a95523c8df34', 'sql:01-queries-joins:fc04', 3, '5a3d9602-fb56-4f50-b4fa-c231d799a302', 'ฟังก์ชัน COALESCE(val1, val2, ...) มีหน้าที่อะไร?', 'คืนค่าแรกในพารามิเตอร์ที่ไม่ใช่ค่า NULL (มักใช้กำหนดค่าเริ่มต้น หรือ Default fallback)', 'Return first non-null value', 4, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('583427e1-09ed-42c1-a16c-ba606a1e13fa', 'sql:01-queries-joins:fc05', 3, '5a3d9602-fb56-4f50-b4fa-c231d799a302', 'ทำไมงาน Support จึงควร Query ข้อมูลบน Read Replica แทน Master Database?', 'เพื่อไม่ให้ Query ที่ซับซ้อนหรือดึงข้อมูลจำนวนมากไปรบกวนทรัพยากร CPU, RAM หรือทำให้เกิด Lock ขัดขวาง Transaction การเขียนของผู้ใช้งานในระบบจริง', 'ป้องกัน Database Lock และ CPU Overload บนระบบหลัก', 5, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('9f8511af-e26e-43ae-99e4-0711a0ac7dce', 'sql:02-aggregations-grouping:fc01', 3, '10413c74-c724-4168-99e9-fc7c279fb980', 'COUNT(*) กับ COUNT(column_name) ต่างกันอย่างไร?', 'COUNT(*) นับจำนวนแถวทั้งหมด รวมทั้งแถวที่มีค่า NULL
COUNT(column) นับเฉพาะแถวที่คอลัมน์นั้นมีค่า (ละเว้นแถวที่เป็น NULL)', 'นับทุกแถว vs นับเฉพาะไม่เป็น NULL', 1, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('df62d97c-c021-4a57-aa41-377bb79161f7', 'sql:02-aggregations-grouping:fc02', 3, '10413c74-c724-4168-99e9-fc7c279fb980', 'WHERE กับ HAVING ต่างกันอย่างไรในคำสั่ง SQL?', 'WHERE กรองแถวก่อนนำไปจัดกลุ่ม (ห้ามใช้ฟังก์ชัน Aggregate)
HAVING กรองผลลัพธ์หลังจากรวมกลุ่ม GROUP BY แล้ว (ใช้กับ Aggregate เช่น COUNT > 10 ได้)', 'ก่อนจัดกลุ่ม vs หลังจัดกลุ่ม', 2, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('2e3637bf-4cae-469f-8b2b-85c620f6fff1', 'sql:02-aggregations-grouping:fc03', 3, '10413c74-c724-4168-99e9-fc7c279fb980', 'คำสั่งใดใน PostgreSQL ใช้ปัดเศษ Timestamp ให้เป็นระดับชั่วโมงเพื่อนำมา GROUP BY?', 'DATE_TRUNC(''hour'', created_at)', 'DATE_TRUNC(''hour'', ...)', 3, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('9304b707-8bc1-4469-bba7-b224a82ee7d9', 'sql:02-aggregations-grouping:fc04', 3, '10413c74-c724-4168-99e9-fc7c279fb980', 'ลำดับการประมวลผล (Execution Order) ของ WHERE, GROUP BY, HAVING คืออะไร?', '1. WHERE (กรองแถว)
2. GROUP BY (รวมกลุ่ม)
3. HAVING (กรองกลุ่ม)', 'WHERE -> GROUP BY -> HAVING', 4, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('8ad69d11-b681-4f03-b04c-f9b6b284565b', 'sql:03-indexes-performance:fc01', 3, '0ec2fdf6-2627-408b-9791-35963b5fe97e', 'Sequential Scan กับ Index Scan ต่างกันอย่างไร?', 'Sequential Scan: กวาดอ่านข้อมูลทุกแถวตั้งแต่ต้นจนจบตาราง (ช้ามากบนตารางใหญ่)
Index Scan: ใช้ B-Tree ค้นหาตำแหน่งแถวที่ต้องการอย่างรวดเร็ว (ความเร็วระดับ O(log N))', 'Full table scan vs Binary search tree', 1, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('30dffb0f-f033-4619-9217-6d95df2efe1b', 'sql:03-indexes-performance:fc02', 3, '0ec2fdf6-2627-408b-9791-35963b5fe97e', 'คำสั่ง EXPLAIN กับ EXPLAIN ANALYZE ต่างกันอย่างไร?', 'EXPLAIN แสดงเฉพาะแผนการทำงาน (Estimate cost/rows) โดยไม่ได้รันคำสั่งจริง
EXPLAIN ANALYZE จะสั่งรันคำสั่งจริงและแสดงเวลาการทำงานจริง (Actual time) ของแต่ละขั้นตอน', 'Estimate plan vs Actually execute & measure time', 2, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('bb12cd67-1c94-4d46-ad1b-49df8a84efc8', 'sql:03-indexes-performance:fc03', 3, '0ec2fdf6-2627-408b-9791-35963b5fe97e', 'คำสั่งใดใน PostgreSQL ใช้ตรวจสอบ Query ที่กำลังรันอยู่แบบ Real-time?', 'SELECT * FROM pg_stat_activity WHERE state != ''idle'';', 'pg_stat_activity', 3, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('63ed67c7-7cc9-4a11-aa03-d4ba35a7f26d', 'sql:03-indexes-performance:fc04', 3, '0ec2fdf6-2627-408b-9791-35963b5fe97e', 'ความแตกต่างระหว่าง pg_cancel_backend() กับ pg_terminate_backend() คืออะไร?', 'pg_cancel_backend(pid): พยายามยกเลิกเฉพาะ Query ที่กำลังรันอยู่ แต่ยังคง Session การเชื่อมต่อไว้
pg_terminate_backend(pid): บังคับตัดการเชื่อมต่อของ Client ทิ้งทันที (Kill connection)', 'Cancel current query vs Terminate entire connection', 4, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('8bef37d2-7e3e-449e-bd5e-e673965f6da4', 'network:08-cli:fc05', 2, 'c349c769-a0a4-4287-a5dd-73daeaa0f3a8', 'การตั้งค่า Serial Connection พอร์ต Console ของอุปกรณ์เครือข่ายมีค่ามาตรฐานสากลอย่างไร?', 'Baud Rate: 9600
Data Bits: 8
Parity: None
Stop Bits: 1
Flow Control: None
(เรียกย่อว่า 9600 8-N-1)', '9600 8-N-1', 5, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('c62cc901-2845-4c71-ab69-f3c13a116552', 'troubleshooting:01-incident-triage-methodology:fc01', 6, '11fc305a-c347-452a-8cbb-f81491cb8cae', 'ความแตกต่างระหว่าง Sev 1 กับ Sev 3 ตามมาตรฐาน ITIL คืออะไร?', 'Sev 1 (Critical): ระบบหลักล่มทั้งระบบ กระทบผู้ใช้ทุกคน ธุรกิจเสียหายรุนแรง
Sev 3 (Medium): ฟังก์ชันย่อยมีปัญหา แต่ยังมีวิธีเลี่ยง (Workaround Available) ธุรกิจยังดำเนินการต่อได้', 'All down vs Minor feature with workaround', 1, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('3399914c-18d5-4b99-a434-d2a1eb0b126c', 'troubleshooting:01-incident-triage-methodology:fc02', 6, '11fc305a-c347-452a-8cbb-f81491cb8cae', 'ทำไมคำถาม ''What Changed?'' จึงเป็นหัวใจสำคัญของการ Triage?', 'เพราะกว่า 80-90% ของ Incident เกิดจากการเปลี่ยนแปลง เช่น การดีพลอยเวอร์ชันใหม่, การเปลี่ยนคอนฟิก, หรือการแก้ไขระบบเครือข่าย', '80-90% of issues stem from recent changes', 2, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('7da96f65-5675-408c-9b4b-0fc13ab6e7e3', 'troubleshooting:01-incident-triage-methodology:fc03', 6, '11fc305a-c347-452a-8cbb-f81491cb8cae', 'MTTR ย่อมาจากอะไรและมีความสำคัญอย่างไรใน Incident Management?', 'Mean Time to Recovery (หรือ Mean Time to Resolve) คือเวลาเฉลี่ยที่ใช้ในการกู้คืนระบบให้กลับมาใช้งานได้ ยิ่งค่านี้น้อย ยิ่งแสดงถึงประสิทธิภาพของทีม Support', 'Mean Time to Recovery', 3, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('596ba80a-0190-4ff3-a86e-dfcb854990c2', 'troubleshooting:02-root-cause-escalation:fc01', 6, '782f94c6-acb3-408b-b091-a093bf7d0c40', 'เทคนิค 5 Whys มีเป้าหมายเพื่ออะไรในการแก้ปัญหา?', 'การถามว่า ''ทำไม'' ซ้ำๆ เพื่อก้าวข้ามผ่านแค่อาการที่เห็นภายนอก (Symptom) ไปสู่ต้นตอที่แท้จริงของระบบหรือกระบวนการ (Root Cause)', 'Identify true underlying root cause', 1, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('e288bdc8-b7b6-430d-bb22-c6173bdc2e9f', 'troubleshooting:02-root-cause-escalation:fc02', 6, '782f94c6-acb3-408b-b091-a093bf7d0c40', 'ข้อมูล 4 อย่างที่ควรมีเสมอใน Ticket ส่งต่อเคส (Escalation Handover) คืออะไร?', '1. ขอบเขตและผลกระทบ (Scope & Impact)
2. เวลาที่เริ่มพบและสิ่งที่เปลี่ยนแปลงล่าสุด (When & What Changed)
3. หลักฐานทางเทคนิค (Error Log, Request ID, Status Code)
4. สิ่งที่ทีม Tier 1 ได้คัดกรองไปแล้ว (What''s already ruled out)', 'Scope, Timeline, Evidence, Ruled out', 2, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('a09618b3-a844-470c-a162-cf53c083cc17', 'troubleshooting:02-root-cause-escalation:fc03', 6, '782f94c6-acb3-408b-b091-a093bf7d0c40', 'ทำไมองค์กรเทคโนโลยีชั้นนำจึงยึดถือหลักการ Blameless Post-Mortem?', 'เพราะการไม่กล่าวโทษบุคคลจะส่งเสริมความโปร่งใส ทำให้ทีมกล้าเปิดเผยปัญหาเพื่อนำไปสู่การปรับปรุงระบบและกระบวนการป้องกันอย่างยั่งยืน', 'Encourages transparency & system-level improvements', 3, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('433b290e-85b2-4a43-ae2a-a6df11ff3635', 'web-api:01-http-status-codes:fc01', 4, '8cd3f8e6-7571-47ca-bd5b-cd313f6179c6', 'ความแตกต่างระหว่าง HTTP Status Code หมวด 4xx และ 5xx คืออะไร?', '4xx: Client Error (ความผิดพลาดจากฝั่งผู้เรียก เช่น ส่งข้อมูลผิด, ไม่ได้ล็อกอิน)
5xx: Server Error (ความผิดพลาดจากฝั่งระบบ/เซิร์ฟเวอร์ เช่น แอปแครช, DB ล่ม, Proxy Timeout)', 'Client Error vs Server Error', 1, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('37d15e3a-82c7-4191-bf77-6f10b9b0a39e', 'web-api:01-http-status-codes:fc02', 4, '8cd3f8e6-7571-47ca-bd5b-cd313f6179c6', '502 Bad Gateway เกิดขึ้นจากสาเหตุใดในระบบที่มี Reverse Proxy?', 'Reverse Proxy (เช่น Nginx) ไม่สามารถเชื่อมต่อกับ Upstream Backend ได้ เนื่องจาก Backend แครชล่ม, ดับอยู่ หรือพอร์ตไม่ตรง (Connection Refused)', 'Upstream Backend ตายหรือไม่เปิดพอร์ต', 2, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('85e15288-35a6-4b99-9aef-b9d51f8c9803', 'web-api:01-http-status-codes:fc03', 4, '8cd3f8e6-7571-47ca-bd5b-cd313f6179c6', '504 Gateway Timeout ต่างจาก 502 Bad Gateway อย่างไร?', '502: Backend ดับ/ตายสนิทเชื่อมต่อไม่ติดทันที
504: Backend ยังรันอยู่ แต่ประมวลผลนานเกินกำหนด (มักติด Slow Query ใน Database) จน Proxy ตัดการเชื่อมต่อไปก่อน', 'ตายสนิท vs ตอบกลับช้าจนเกินเวลา', 3, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('dc2af395-32b3-4026-ad84-baa410aff45b', 'web-api:01-http-status-codes:fc04', 4, '8cd3f8e6-7571-47ca-bd5b-cd313f6179c6', '401 Unauthorized กับ 403 Forbidden ต่างกันอย่างไร?', '401: ไม่พบข้อมูลยืนยันตัวตน (ยังไม่ได้ Login หรือ Token ผิด/หมดอายุ)
403: ยืนยันตัวตนแล้วแต่ไม่มีสิทธิ์เข้าถึงทรัพยากรนั้น (Permission Denied)', 'Authentication vs Authorization', 4, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('047fc3f8-a440-48ca-af37-7621f56e6b34', 'web-api:01-http-status-codes:fc05', 4, '8cd3f8e6-7571-47ca-bd5b-cd313f6179c6', 'HTTP Status Code 429 มีความหมายว่าอย่างไร?', 'Too Many Requests (ผู้ใช้ส่ง Request ถี่เกินโควตาที่กำหนดและโดน Rate Limiter บล็อกไว้)', 'Rate limit exceeded', 5, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('383bb10f-727a-4735-9e7f-b0b3b237868d', 'web-api:02-curl-api-testing:fc01', 4, 'cfa14627-c168-4b14-9e7b-15eb4f7e1ead', 'แฟล็ก -i กับ -I ใน curl ต่างกันอย่างไร?', '-I (ตัวใหญ่): ส่ง HEAD request เพื่อแสดงเฉพาะ HTTP Response Header เท่านั้น
-i (ตัวเล็ก): ส่ง request ปกติแต่ให้แสดงผลลัพธ์ทั้ง Headers และ Body', 'HEAD only vs Headers + Body', 1, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('08c99096-636c-40a2-b226-3774925c9f4b', 'web-api:02-curl-api-testing:fc02', 4, 'cfa14627-c168-4b14-9e7b-15eb4f7e1ead', 'แฟล็ก -k หรือ --insecure ใน curl มีประโยชน์อะไรและมีความเสี่ยงอย่างไร?', 'ประโยชน์: สั่งให้ข้ามการตรวจสอบใบรับรอง SSL/TLS (ใช้ทดสอบ Self-signed cert ภายใน)
ความเสี่ยง: เสี่ยงต่อการถูกดักข้อมูลแบบ Man-in-the-Middle ห้ามใช้บน Production สคริปต์', 'Bypass SSL certificate check', 2, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('cf8119ce-0f24-4120-a0c5-bdabcf4966c6', 'web-api:02-curl-api-testing:fc03', 4, 'cfa14627-c168-4b14-9e7b-15eb4f7e1ead', 'แฟล็ก -w ใน curl ใช้สำหรับทำอะไรในงาน Support?', 'ใช้จัดรูปแบบแสดงค่า Latency Breakdown (เวลา Resolve DNS, เวลา TCP Handshake, เวลาต่อ SSL, และ Time to First Byte)', 'Latency & timing breakdown metrics', 3, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('f57ad89b-f81c-4eb9-86b1-3a15aa6ce90b', 'web-api:03-ssl-tls-certificates:fc01', 4, 'c1527b50-8bf1-4171-95ce-52bd25ee35f4', 'ห่วงโซ่ความเชื่อถือ (Chain of Trust) ของ SSL/TLS ประกอบด้วยอะไรบ้าง?', '1. Root CA (ฝังอยู่ใน OS/เบราว์เซอร์)
2. Intermediate CA (ผู้ออกใบรับรองระดับกลาง)
3. Server / Leaf Certificate (ใบรับรองของเว็บไซต์เรา)', 'Root -> Intermediate -> Leaf', 1, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('02445f8e-4ff1-4848-8c83-104f852d6c50', 'web-api:03-ssl-tls-certificates:fc02', 4, 'c1527b50-8bf1-4171-95ce-52bd25ee35f4', 'ทำไมเบราว์เซอร์จึงขึ้นเตือน ''unable to get local issuer certificate''?', 'เกิดจากเว็บเซิร์ฟเวอร์ส่งเฉพาะ Leaf Cert แต่ไม่ได้ใส่ไฟล์ Intermediate CA Bundle ลงไปด้วย ทำให้เบราว์เซอร์ต่อสายโซ่กลับไปยัง Root CA ไม่ได้', 'Missing intermediate CA bundle (Fullchain)', 2, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('8842cda8-8a11-464f-b14f-84888daecf11', 'web-api:03-ssl-tls-certificates:fc03', 4, 'c1527b50-8bf1-4171-95ce-52bd25ee35f4', 'หลังเปลี่ยนไฟล์ SSL Certificate บน Nginx หรือ Apache ต้องทำสิ่งใดเป็นขั้นตอนสุดท้ายเสมอ?', 'สั่ง Reload หรือ Restart เว็บเซิร์ฟเวอร์ (เช่น sudo systemctl reload nginx) เพื่อให้อ่านไฟล์ใบรับรองใหม่เข้า RAM', 'systemctl reload nginx', 3, '2026-11-04 10:43:13.16724+00', '2026-11-04 15:19:45.48554+00');
INSERT INTO public.flashcards VALUES ('2c040024-c24c-437f-918b-26fc9f1ccf78', 'network:05-osi:fc01', 2, '6b461aa2-fd34-427d-8b52-fe4455276c56', 'เรียงลำดับชื่อชั้นของโมเดล OSI ทั้ง 7 ชั้น จากล่างสุด (Layer 1) ไปบนสุด (Layer 7)', '1. Physical
2. Data Link
3. Network
4. Transport
5. Session
6. Presentation
7. Application
(จำ: Please Do Not Throw Sausage Pizza Away)', 'เริ่มต้นจาก Physical สิ้นสุดที่ Application', 1, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('ae981477-a6aa-473a-88f5-064aca9f66c0', 'network:05-osi:fc02', 2, '6b461aa2-fd34-427d-8b52-fe4455276c56', 'หน่วยข้อมูล (PDU) ในแต่ละชั้นของโมเดล OSI มีชื่อเรียกอย่างไรบ้าง (Layer 1 ถึง 4)?', 'Layer 1 = Bits
Layer 2 = Frame
Layer 3 = Packet
Layer 4 = Segment (TCP) หรือ Datagram (UDP)', 'Bits, Frame, Packet, Segment', 2, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('efe69abe-d128-49e3-959c-7a7357045439', 'network:05-osi:fc03', 2, '6b461aa2-fd34-427d-8b52-fe4455276c56', 'การวิเคราะห์ปัญหาแบบ ''Divide-and-Conquer'' ในเครือข่ายมักเริ่มต้นทดสอบที่ชั้นใด และใช้คำสั่งอะไร?', 'เริ่มต้นที่ Layer 3 ด้วยคำสั่ง ping (เพื่อดูว่า IP และเส้นทางสื่อสารได้ไหม) หากปิงติดจะตัดปัญหา Layer 1-3 ทิ้งได้ทันที แล้วไปโฟกัสที่ Port/Firewall (Layer 4) หรือ Service (Layer 7)', 'Layer 3 (คำสั่ง ping)', 3, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('ecb09fe6-2a8a-4e70-bf16-7b963276f6fc', 'network:05-osi:fc04', 2, '6b461aa2-fd34-427d-8b52-fe4455276c56', 'Switch Layer 2 และ Router แตกต่างกันอย่างไรในแง่ของชั้น OSI และการส่งต่อข้อมูล?', 'Switch L2 ทำงานที่ Layer 2 (Data Link) ส่งต่อข้อมูลโดยอ่าน MAC Address
Router ทำงานที่ Layer 3 (Network) ส่งต่อข้อมูลโดยอ่าน IP Address และค้นหาเส้นทางข้ามเครือข่าย', 'Layer 2 (MAC) vs Layer 3 (IP)', 4, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('816e5137-d9a0-4bf5-8142-eae8f3100ead', 'network:05-osi:fc05', 2, '6b461aa2-fd34-427d-8b52-fe4455276c56', 'หาก ping 8.8.8.8 ติด แต่ ping google.com ไม่ได้ แสดงว่าเกิดปัญหาที่ชั้นใดในโมเดล OSI?', 'Layer 7 (Application Layer) เนื่องจากเกิดจากโปรโตคอล DNS ไม่สามารถแปลงชื่อ Hostname เป็น IP Address ได้ ทั้งที่เครือข่ายเชื่อมต่อออกสู่อินเทอร์เน็ตได้ปกติ', 'DNS อยู่ใน Layer 7', 5, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('0839b777-bee3-437f-ab1a-bd257a31577e', 'network:06-vlan:fc01', 2, 'd297f4f2-4aec-41db-b324-a8e4ae10ea05', 'อธิบายความแตกต่างระหว่าง Access Port และ Trunk Port บน Switch', 'Access Port: เชื่อมต่อเครื่องลูกข่าย/เซิร์ฟเวอร์ รองรับเพียง 1 VLAN และส่งเฟรมแบบไม่มี Tag (Untagged)
Trunk Port: เชื่อมต่อระหว่าง Switch-to-Switch หรือ Switch-to-Router รองรับหลาย VLAN พร้อมกัน และแปะ Tag ตามมาตรฐาน 802.1Q', 'Untagged 1 VLAN vs Tagged หลาย VLAN', 1, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('35f3115b-6786-4a63-ba2e-410c6c5c668f', 'network:06-vlan:fc02', 2, 'd297f4f2-4aec-41db-b324-a8e4ae10ea05', 'โปรโตคอล ARP (Address Resolution Protocol) ทำหน้าที่อะไรในระบบเครือข่าย?', 'ทำหน้าที่แปลงจาก IP Address (Layer 3) เป็น MAC Address (Layer 2) เพื่อให้การ์ดแลนสามารถสร้าง Ethernet Frame ส่งไปยังเครื่องเป้าหมายในวง LAN ได้ถูกต้อง', 'แปลง IP เป็น MAC', 2, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('9f7691b8-11e7-428f-bd29-40f544a48b70', 'network:06-vlan:fc03', 2, 'd297f4f2-4aec-41db-b324-a8e4ae10ea05', 'สวิตช์ Layer 2 มีขั้นตอนการสร้างและอัปเดต MAC Address Table อย่างไร?', 'สวิตช์จะตรวจสอบ ''Source MAC Address'' ของทุก Frame ที่วิ่งเข้ามาที่พอร์ต แล้วจดบันทึกลงในตารางคู่กับหมายเลขพอร์ตและ VLAN นั้นๆ (Learning phase)', 'ดู Source MAC ของเฟรมขาเข้า', 3, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('a9e481c3-6d72-435e-8f95-80a1f63df8a4', 'network:06-vlan:fc04', 2, 'd297f4f2-4aec-41db-b324-a8e4ae10ea05', 'Native VLAN บนพอร์ต Trunk คืออะไร และมีความพิเศษอย่างไร?', 'คือ VLAN พิเศษประจำพอร์ต Trunk ที่รองรับเฟรมแบบ ''ไม่มี Tag'' (Untagged Frame) หากมีเฟรมธรรมดาวิ่งเข้ามาที่พอร์ต Trunk สวิตช์จะส่งเข้า Native VLAN อัตโนมัติ (ค่าเริ่มต้นมักเป็น VLAN 1)', 'VLAN สำหรับ Untagged Frame บน Trunk', 4, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('5005b6d2-7152-4300-8cd4-e901da1a0fdb', 'network:06-vlan:fc05', 2, 'd297f4f2-4aec-41db-b324-a8e4ae10ea05', 'หากต้องการให้เครื่องที่อยู่ต่าง VLAN กันสามารถสื่อสารกันได้ ต้องใช้อุปกรณ์ใด และเรียกกระบวนการนี้ว่าอะไร?', 'ต้องใช้อุปกรณ์ Layer 3 เช่น Router หรือ Layer 3 Switch โดยเรียกกระบวนการส่งต่อข้อมูลข้ามวงนี้ว่า ''Inter-VLAN Routing'' (เช่น วิธี Router-on-a-Stick หรือใช้ SVI บน L3 Switch)', 'Router / L3 Switch (Inter-VLAN Routing)', 5, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('5dc6d13d-6fc8-48f1-8a2a-9c29e0f1e3f7', 'network:07-dhcp:fc01', 2, '11100691-a71e-441a-abe3-ba9a1d4ba021', 'ขั้นตอน DORA ของโปรโตคอล DHCP ย่อมาจากอะไร และทำงานอย่างไร?', 'D = Discover (เครื่องลูกข่ายส่ง Broadcast ถามหา DHCP)
O = Offer (DHCP Server เสนอหมายเลข IP ให้)
R = Request (เครื่องลูกข่ายตอบรับเพื่อขอยืนยันใช้ IP นั้น)
A = Acknowledge (DHCP Server ส่งการยืนยันสัญญา Lease Time กลับมา)', 'Discover -> Offer -> Request -> Acknowledge', 1, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('8abbe3e2-3331-4f98-b663-e4ee7dddf871', 'network:07-dhcp:fc02', 2, '11100691-a71e-441a-abe3-ba9a1d4ba021', 'เมื่อเครื่องคอมพิวเตอร์ได้รับไอพีในกลุ่ม 169.254.x.x (APIPA) มีความหมายว่าอย่างไรในเชิงเทคนิค?', 'หมายความว่าเครื่องไม่สามารถติดต่อขอ IP จาก DHCP Server ได้สำเร็จ (เช่น สายแลนหลุด, พอร์ตสวิตช์ผิด VLAN, DHCP Server ดับ หรือ Pool ไอพีเต็ม) ระบบปฏิบัติการจึงสุ่มไอพี Link-Local มาให้ชั่วคราว', 'ขอ DHCP ไม่ผ่าน (APIPA)', 2, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('fb67ab4c-a060-47b6-bfc3-f4974ab8a11a', 'network:07-dhcp:fc03', 2, '11100691-a71e-441a-abe3-ba9a1d4ba021', 'DHCP Relay Agent (ip helper-address) มีบทบาทสำคัญอย่างไรในระบบเครือข่ายที่มีหลาย VLAN?', 'เนื่องจากแพ็กเก็ต DHCP Discover ส่งแบบ Broadcast ซึ่งไม่สามารถวิ่งข้าม Router ได้ ฟังก์ชัน DHCP Relay จะช่วยดักจับ Broadcast ใน Subnet นั้น แล้วแปลงเป็น Unicast ส่งตรงไปยัง DHCP Server ที่อยู่ต่างวง Subnet ให้', 'ส่งต่อ Broadcast ข้าม Router ไปยัง DHCP Server', 3, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('a491a290-c10e-49d0-b077-f05e58a8cdfc', 'network:07-dhcp:fc04', 2, '11100691-a71e-441a-abe3-ba9a1d4ba021', 'PAT (Port Address Translation) หรือ NAT Overload แตกต่างจาก Static NAT อย่างไร?', 'Static NAT: แปลง 1 Private IP คู่กับ 1 Public IP แบบ 1-to-1 ถาวร (เหมาะกับ Web/Mail Server)
PAT (NAT Overload): อนุญาตให้อุปกรณ์จำนวนมากใช้ Public IP เดียวกันพร้อมกันได้ โดยใช้ Port Number ในการแยกเซสชันของแต่ละเครื่อง', '1-to-1 vs Many-to-1 โดยใช้ Port', 4, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('d79e76fe-cd60-4b57-be86-655fa5e5c599', 'network:07-dhcp:fc05', 2, '11100691-a71e-441a-abe3-ba9a1d4ba021', 'โปรโตคอล DHCP ทำงานบน Transport Layer ด้วย Protocol และ Port ใด?', 'ทำงานบน UDP (User Datagram Protocol):
- พอร์ต 67 สำหรับ DHCP Server
- พอร์ต 68 สำหรับ DHCP Client', 'UDP พอร์ต 67 และ 68', 5, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('ed34b488-64b2-4209-b2dc-fef1025d0399', 'network:08-cli:fc01', 2, 'c349c769-a0a4-4287-a5dd-73daeaa0f3a8', 'คำสั่ง ''show ip interface brief'' บน Cisco Switch มีประโยชน์หลักในการตรวจสอบอะไร?', 'ใช้สรุปรายการ Interface ทั้งหมดของอุปกรณ์ในตารางเดียว เพื่อดูว่าพอร์ตใดมี IP Address, พอร์ตใดมีไฟ Link ติดทางกายภาพ (Status: up) และพอร์ตใดพร้อมส่งข้อมูลที่ระดับ Layer 2 (Protocol: up)', 'สรุปสถานะพอร์ตและไอพีในหน้าเดียว', 1, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('0a0e4704-2d23-4eb4-88d4-ef9b831e1f2e', 'network:08-cli:fc02', 2, 'c349c769-a0a4-4287-a5dd-73daeaa0f3a8', 'สถานะ ''up / down'' ในคำสั่ง show ip interface brief บอกอะไรเกี่ยวกับชั้นของโมเดล OSI?', 'Status: up ➔ Layer 1 (Physical) ทำงานปกติ มีสัญญาณไฟฟ้าหรือแสงเข้ามา
Protocol: down ➔ Layer 2 (Data Link) มีปัญหา เช่น ไม่ได้รับ Keepalive, Duplex Mismatch หรือตั้งค่า Encapsulation ผิด', 'L1 (Status) ผ่าน แต่ L2 (Protocol) มีปัญหา', 2, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('af4f0dea-e97c-4f6e-b48c-625fa22c2132', 'network:08-cli:fc03', 2, 'c349c769-a0a4-4287-a5dd-73daeaa0f3a8', 'หากพบค่า ''CRC errors'' เพิ่มขึ้นเรื่อยๆ ในคำสั่ง show interfaces <port> ควรตรวจสอบจุดใดเป็นอันดับแรก?', 'ตรวจสอบ Layer 1 ทางกายภาพทันที: สายสัญญาณแลน/ไฟเบอร์ชำรุด, หัวต่อเข้าหัวไม่แน่นหรือมีฝุ่นสกปรก, สายพาดผ่านแหล่งกำเนิดสัญญาณรบกวนแม่เหล็กไฟฟ้า (EMI/Noise) หรือระยะสายเกิน 100 เมตร', 'สายสัญญาณ ฮาร์ดแวร์ และสัญญาณรบกวน (Layer 1)', 3, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('e4525244-4b77-4ccc-b413-79650bc93a51', 'network:08-cli:fc04', 2, 'c349c769-a0a4-4287-a5dd-73daeaa0f3a8', 'คำสั่งใดใช้ตรวจสอบสถานะการทำงานของพอร์ต Trunk บน Cisco Switch?', '''show interfaces trunk'' เพื่อดูว่าพอร์ตใดกำลังทำหน้าที่เป็น Trunk, ค่า Native VLAN คืออะไร และมี VLAN ใดบ้างที่ได้รับอนุญาตให้ส่งผ่านสายเส้นนี้ (Allowed VLANs)', 'show interfaces trunk', 4, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('dbddf3f2-9219-4d00-bfa2-87543cf486c5', 'network:09-l1l2:fc01', 2, 'ff620473-be72-44d1-bbee-3112ba85188d', 'Duplex Mismatch (ข้างหนึ่ง Full อีกข้างเป็น Half) แสดงอาการผิดปกติอย่างไรในระบบเครือข่าย?', 'การเชื่อมต่อจะขึ้น UP และปิงขนาดเล็กผ่านได้ปกติ แต่เมื่อมี Traffic ปริมาณมาก (โหลด/อัปโหลดไฟล์) ความเร็วจะตกต่ำมากและเกิด Late Collisions กับ Packet Loss สูงจนระบบใช้งานแทบไม่ได้', 'ปิงผ่านแต่โหลดไฟล์ช้ามาก + Late Collisions', 1, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('ccf62ab7-550d-4826-b55a-cd87af418c27', 'network:09-l1l2:fc02', 2, 'ff620473-be72-44d1-bbee-3112ba85188d', 'ทำไม Switching Loop ถึงทำให้ระบบเครือข่ายล่มได้อย่างรวดเร็วในระดับ Broadcast Storm?', 'เพราะ Ethernet Frame ใน Layer 2 ไม่มีฟิลด์ TTL (Time-to-Live) เมื่อเฟรมบรอดคาสต์วิ่งวนเป็นลูป สวิตช์จะส่งกระจายทวีคูณวนไปมาไม่สิ้นสุดจนกระทั่งกินแบนด์วิดท์และ CPU เต็ม 100%', 'Layer 2 ไม่มีฟิลด์ TTL', 2, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('58e8ad49-75fe-4cd1-af0c-6996ae4937fc', 'network:09-l1l2:fc03', 2, 'ff620473-be72-44d1-bbee-3112ba85188d', 'อาการ Port Flapping คืออะไร และมีสาเหตุทั่วไปมาจากอะไร?', 'คืออาการที่พอร์ตสลับสถานะ UP และ DOWN วนลูปต่อเนื่องหลายครั้งต่อนาที สาเหตุหลักมักมาจากสายสัญญาณหลวมหรือหักใน, หัวต่อสกปรก, สัญญาณแสงไฟเบอร์อ่อน (Low Rx Optical Power) หรือโมดูล SFP ร้อนจัด/เสีย', 'พอร์ตติดๆ ดับๆ วนลูป (สายหลวม / แสงไฟเบอร์อ่อน)', 3, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('d7fc826b-f19a-498b-9e3d-962eee81ee91', 'network:09-l1l2:fc04', 2, 'ff620473-be72-44d1-bbee-3112ba85188d', 'Spanning Tree Protocol (STP) และ RSTP มีหน้าที่หลักอะไรในระบบสวิตช์?', 'ตรวจจับเส้นทางสำรองที่ทำให้เกิด Loop แล้วสั่งบล็อกพอร์ตนั้นไว้ (Blocking state) และเมื่อสายหลักขาด จะปลดบล็อกพอร์ตสำรองกลับมาส่งข้อมูลอัตโนมัติ (Forwarding state) โดย RSTP สลับสายได้ใน 1-2 วินาที', 'ตรวจจับและบล็อกเส้นทาง Loop อัตโนมัติ', 4, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('4f0e98af-cae9-4b3d-b904-2f4182a92b9a', 'network:09-l1l2:fc05', 2, 'ff620473-be72-44d1-bbee-3112ba85188d', 'โปรโตคอล LACP (Link Aggregation Control Protocol) ช่วยแก้ปัญหาอะไร?', 'ช่วยรวมพอร์ตทางกายภาพหลายพอร์ต (เช่น 2x 1Gbps) ให้ทำงานเสมือนเป็นพอร์ตเดียว (Port-Channel 2Gbps) เพิ่ม Bandwidth และสำรองสายโดยไม่ถูกโปรโตคอล STP สั่งบล็อกทิ้ง', 'รวมสายเพิ่มแบนด์วิดท์และสำรองลิงก์ (IEEE 802.3ad)', 5, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('6b3e73fa-757a-49da-b1a4-455dca06c7a7', 'network:10-pcap:fc01', 2, '7c93ea29-3948-44d5-a0bb-77f87d3fedcd', 'ประโยชน์ของแฟล็ก ''-nn'' ในคำสั่ง tcpdump คืออะไร?', 'สั่งให้ tcpdump ไม่ต้องพยายามแปลง IP Address เป็น Hostname (-n) และไม่ต้องแปลง Port เป็นชื่อ Protocol (-nn) ช่วยให้ผลลัพธ์แสดงได้รวดเร็วทันที ไม่กระตุกจาก DNS Lookup และไม่สร้าง DNS Traffic รบกวน', 'ไม่ Resolve ทั้ง IP และ Port', 1, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('998f1bdf-e774-40e5-8b53-1befa140a1a9', 'network:10-pcap:fc02', 2, '7c93ea29-3948-44d5-a0bb-77f87d3fedcd', 'ถอดรหัส TCP Flags ใน tcpdump: [S], [S.], [.], [P], [F], [R] มีความหมายอย่างไร?', '[S] = SYN (ขอเชื่อมต่อ)
[S.] = SYN-ACK (ตอบรับและขอเชื่อมต่อกลับ)
[.] = ACK (ยืนยันสำเร็จ ESTABLISHED)
[P] = PUSH (ส่งข้อมูลแอปพลิเคชัน)
[F] = FIN (ขอปิดเซสชันแบบปกติ)
[R] = RST (Reset / ปฏิเสธการเชื่อมต่อทันที)', 'SYN, SYN-ACK, ACK, PUSH, FIN, RST', 2, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('e37404d0-4d44-42d5-bbdc-70ea0a9199df', 'network:10-pcap:fc03', 2, '7c93ea29-3948-44d5-a0bb-77f87d3fedcd', 'หากเห็นแพ็กเก็ตส่ง Flags [S] ออกไปซ้ำๆ แต่ไม่มีใครตอบกลับมาเลย แสดงว่าเกิดอะไรขึ้น?', 'แพ็กเก็ตถูกทิ้งเงียบๆ (DROP) โดย Firewall / Security Group ระหว่างทาง หรือเครื่องปลายทางปิดเครื่องอยู่ ทำให้เกิดอาการ Connection Timed Out', 'ติด Firewall หรือปลายทางไม่ตอบ (Connection Timed Out)', 3, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('e2756d10-6745-435e-a2c7-9a944dd2124e', 'network:10-pcap:fc04', 2, '7c93ea29-3948-44d5-a0bb-77f87d3fedcd', 'หากส่ง Flags [S] แล้วได้รับ Flags [R] (RST) สวนกลับมาทันที แสดงว่าเกิดอะไรขึ้น?', 'เครือข่ายเชื่อมต่อไปถึงเครื่องปลายทางได้ปกติ (Layer 1-3 สมบูรณ์) แต่ไม่มี Service/Application รันรองรับอยู่ที่พอร์ตนั้น (Connection Refused)', 'เครือข่ายปกติ แต่ไม่มีแอปเปิดฟังพอร์ตนั้น (Connection Refused)', 4, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('3ac99d71-ec5e-4079-a8b3-790a299fc67f', 'network:10-pcap:fc05', 2, '7c93ea29-3948-44d5-a0bb-77f87d3fedcd', 'คำสั่งใดใช้บันทึกแพ็กเก็ตจาก tcpdump เป็นไฟล์ .pcap เพื่อนำไปเปิดใน Wireshark?', 'ใช้แฟล็ก ''-w <filename.pcap>'' เช่น: sudo tcpdump -nn -i eth0 port 80 -c 100 -w /tmp/capture.pcap และสามารถนำกลับมาอ่านด้วยแฟล็ก ''-r''', 'แฟล็ก -w (Write) และ -r (Read)', 5, '2026-11-10 11:59:34.484964+00', '2026-11-10 11:59:34.484964+00');
INSERT INTO public.flashcards VALUES ('3f78c093-4633-4481-a91a-6dc665aad309', 'datacenter:06-raid:fc01', 10, '75403d93-f9e9-4644-9d96-62d933af29b7', 'เปรียบเทียบจำนวนดิสก์ที่ทนเสียได้พร้อมกันและสูตรคำนวณความจุของ RAID 5, RAID 6 และ RAID 10', 'RAID 5: ความจุ = N - 1 ลูก (ทนเสียได้ 1 ลูก)
RAID 6: ความจุ = N - 2 ลูก (ทนเสียได้ 2 ลูก)
RAID 10: ความจุ = N / 2 ลูก (ทนเสียได้ฝั่งละ 1 ลูกในแต่ละคู่ Mirror)', 'N-1, N-2, N/2', 1, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.flashcards VALUES ('aaf70700-02ba-458c-979e-ed5a5eed9741', 'datacenter:06-raid:fc02', 10, '75403d93-f9e9-4644-9d96-62d933af29b7', 'สีไฟสถานะบนถาดดิสก์ (Drive Caddy): สีเขียว, สีส้ม/อำพัน (Amber) และสีน้ำเงิน มีความหมายอย่างไร?', 'สีเขียว: ดิสก์ทำงานปกติ (Online/Activity)
สีส้ม/อำพัน: ดิสก์เสียหรือมีปัญหา (Fault/Predictive Failure)
สีน้ำเงิน: ไฟชี้ตำแหน่ง (Locator LED) ที่แอดมินสั่งเปิดเพื่อระบุตัวดิสก์ให้ช่างถอดไม่ผิดลูก', 'เขียว=ปกติ, ส้ม=เสีย, น้ำเงิน=ชี้เป้า', 2, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.flashcards VALUES ('3adad30c-1f7f-40d4-92df-b93579cdb0f6', 'datacenter:06-raid:fc03', 10, '75403d93-f9e9-4644-9d96-62d933af29b7', 'HBA Mode (IT Mode / Passthrough) แตกต่างจาก Hardware RAID Mode อย่างไร?', 'Hardware RAID: การ์ดรวมดิสก์เป็นก้อนเดียวแล้วส่งให้ OS เห็นเป็น Logical Volume
HBA Mode: การ์ดส่งดิสก์ทุกลูกแยกกันให้ OS เห็นโดยตรง เหมาะสำหรับทำ Software RAID เช่น ZFS หรือ Ceph', 'การ์ดรวมดิสก์เอง vs ส่งดิสก์ตรงให้ OS', 3, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.flashcards VALUES ('3e5c9d95-67df-449c-8e89-6e2cf21ffd33', 'datacenter:06-raid:fc04', 10, '75403d93-f9e9-4644-9d96-62d933af29b7', 'คำสั่งใดบน Linux ใช้ตรวจสอบค่าสุขภาพ S.M.A.R.T. ของฮาร์ดดิสก์?', 'ใช้คำสั่ง "smartctl -H /dev/sdX" เพื่อดูผลสรุปสุขภาพ (PASSED/FAILED) และ "smartctl -a /dev/sdX" เพื่อดูตารางค่าสถิติทั้งหมด เช่น Reallocated_Sector_Ct', 'smartctl -a /dev/sdX', 4, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.flashcards VALUES ('7a60c4f6-9060-44ce-87ad-f889b0605eef', 'datacenter:06-raid:fc05', 10, '75403d93-f9e9-4644-9d96-62d933af29b7', 'หากดูไฟล์ /proc/mdstat บน Linux แล้วเห็นสัญลักษณ์ [UU] กับ [U_] มีความหมายต่างกันอย่างไร?', '[UU] หมายถึงดิสก์ในโวลุ่ม Software RAID ทั้ง 2 ลูกทำงานปกติครบถ้วน
[U_] หมายถึงดิสก์ลูกที่สองหลุดหรือเสียไป 1 ลูก โวลุ่มกำลังอยู่ในสถานะ Degraded', 'U = Up, _ = Down/Missing', 5, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.flashcards VALUES ('697f7554-3c14-419d-9ff9-c7f1d5237d2d', 'datacenter:07-sel:fc01', 10, 'c64810d8-bf76-49f4-aadd-3cd45d92d14b', 'Correctable ECC Error (CE) กับ Uncorrectable ECC Error (UCE) ของหน่วยความจำ RAM ต่างกันอย่างไร?', 'CE (Single-bit): บิตเพี้ยน 1 บิต ชิป ECC แก้ไขได้อัตโนมัติ เครื่องไม่ดับ (แต่ถ้าเกิดถี่ควรวางแผนเปลี่ยน)
UCE (Multi-bit): บิตเพี้ยนหลายบิตเกินกว่าจะซ่อมได้ เครื่องจะแฮงก์ (Kernel Panic) หรือรีบูตทันที', 'Single-bit ซ่อมได้ vs Multi-bit เครื่องแฮงก์', 1, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.flashcards VALUES ('9088a4bf-1207-459e-86ff-f612902c9bc3', 'datacenter:07-sel:fc02', 10, 'c64810d8-bf76-49f4-aadd-3cd45d92d14b', 'อธิบายวิธีทำ Memory Swap Test เมื่อพบแจ้งเตือนแรมมีปัญหาที่ช่อง DIMM_A1', 'สลับนำแรมจากช่อง DIMM_A1 ไปใส่ช่องอื่น (เช่น DIMM_B1)
- ถ้า Error ย้ายตามไปเกิดที่ DIMM_B1 ➔ ตัวแผง RAM เสีย
- ถ้า Error ยังเกิดที่ DIMM_A1 ที่เดิม ➔ สล็อตบน Mainboard หรือ CPU Socket เสีย', 'สลับช่องดูว่า Error ย้ายตามแรมหรืออยู่ที่สล็อตเดิม', 2, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.flashcards VALUES ('834e7f0d-8a92-4d80-bbde-8be64c89bb44', 'datacenter:07-sel:fc03', 10, 'c64810d8-bf76-49f4-aadd-3cd45d92d14b', 'System Event Log (SEL) คืออะไร และเก็บอยู่ที่ไหน?', 'คือบันทึกเหตุการณ์ระดับฮาร์ดแวร์ (ไฟดับ, ความร้อนเกิน, พัดลมตาย, แรมเพี้ยน) ที่จัดเก็บอยู่ในหน่วยความจำ NVRAM ของชิป BMC (iDRAC/iLO) สามารถเปิดดูได้แม้ OS จะล่มหรือบูตไม่ขึ้น', 'บันทึกฮาร์ดแวร์ในชิป BMC (iDRAC/iLO)', 3, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.flashcards VALUES ('3f360749-0da5-4b79-8320-fd3bed33b425', 'datacenter:07-sel:fc04', 10, 'c64810d8-bf76-49f4-aadd-3cd45d92d14b', 'คำสั่ง ipmitool ใดใช้อ่านบันทึก SEL และคำสั่งใดใช้อ่านค่าเซนเซอร์อุณหภูมิ/พัดลม?', '- อ่านบันทึกเหตุการณ์ฮาร์ดแวร์: sudo ipmitool sel elist
- อ่านค่าเซนเซอร์อุณหภูมิ/พัดลม/ไฟ: sudo ipmitool sdr list', 'sel elist และ sdr list', 4, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.flashcards VALUES ('c97ff6fb-793e-4c29-8bce-f6a6e068f5b8', 'datacenter:07-sel:fc05', 10, 'c64810d8-bf76-49f4-aadd-3cd45d92d14b', 'ทำไมเซิร์ฟเวอร์ที่มีพัดลมเสียไปเพียง 1 ตัว ถึงส่งเสียงดังเหมือนเครื่องบินเจ็ต?', 'เพราะชิป BMC เข้าสู่โหมด Fail-safe โดยสั่งเร่งความเร็วรอบพัดลมตัวที่เหลือทั้งหมดให้หมุนที่ 100% เพื่อชดเชยปริมาณลมระบายความร้อนไม่ให้ CPU ร้อนเกินพิกัด', 'BMC เร่งพัดลมตัวที่เหลือเป็น 100%', 5, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.flashcards VALUES ('2ce6f3b1-abd7-417a-80c0-1e17d3e10869', 'datacenter:08-fw:fc01', 10, 'a20fa558-7295-4a2a-bbf2-0700729e95e9', 'Virtual Media บนระบบ iDRAC / iLO คืออะไร และช่วยงานช่าง Data Center อย่างไร?', 'คือฟีเจอร์จำลองไฟล์อิมเมจ .iso จากระยะไกลให้เซิร์ฟเวอร์มองเห็นเสมือนเป็นแผ่น CD/DVD หรือ USB เสียบอยู่ที่ตัวเครื่อง ช่วยให้ติดตั้ง OS หรือบูตแผ่นซ่อมแซมได้โดยไม่ต้องเดินไปเสียบแฟลชไดรฟ์หน้าตู้แร็ค', 'จำลองไฟล์ .iso เป็นไดรฟ์บูตระยะไกล', 1, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.flashcards VALUES ('4ba68195-94d8-4d8e-8fcb-c7387b7f27f2', 'datacenter:08-fw:fc02', 10, 'a20fa558-7295-4a2a-bbf2-0700729e95e9', 'ไฟล์ Answer File สำหรับติดตั้ง OS อัตโนมัติ (Unattended Install) ของ RHEL/Rocky, Ubuntu ยุคใหม่ และ Windows Server มีชื่อเรียกว่าอะไรตามลำดับ?', '- RHEL / Rocky Linux: Kickstart (ks.cfg)
- Ubuntu Server (20.04+): Autoinstall / Cloud-Init (user-data)
- Windows Server: Unattend.xml (ร่วมกับ WDS)', 'Kickstart, Cloud-Init, Unattend.xml', 2, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.flashcards VALUES ('7250a1a2-259d-4b27-8a55-d07cf63f32e3', 'datacenter:08-fw:fc03', 10, 'a20fa558-7295-4a2a-bbf2-0700729e95e9', 'การอัปเดต BMC Firmware (iDRAC/iLO) มีข้อได้เปรียบด้าน Downtime อย่างไรเมื่อเทียบกับการอัปเดต System BIOS?', 'การอัปเดต BMC (iDRAC/iLO) สามารถรีสตาร์ทเฉพาะชิปจัดการได้โดยไม่ต้องรีบูตเครื่องเซิร์ฟเวอร์หลัก (Zero OS Downtime) ในขณะที่การอัปเดต BIOS บังคับต้องรีบูตเครื่องเซิร์ฟเวอร์จริงเสมอ', 'BMC รีสตาร์ทตัวเองได้โดย OS ไม่ดับ', 3, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.flashcards VALUES ('763820ad-0527-436f-8263-c931d26584d7', 'datacenter:08-fw:fc04', 10, 'a20fa558-7295-4a2a-bbf2-0700729e95e9', 'เรียงลำดับการอัปเดต Firmware ในเซิร์ฟเวอร์ที่ปลอดภัยตามมาตรฐานผู้ผลิต', '1. BMC Firmware (iDRAC / iLO)
2. System BIOS / UEFI
3. RAID Controller / HBA Firmware
4. Network Card (NIC) Firmware
5. Drive Firmware (HDD / SSD)', 'BMC -> BIOS -> RAID/NIC -> Drive', 4, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.flashcards VALUES ('50e163e0-2dcf-4a9c-8846-361a7bd96ddd', 'datacenter:08-fw:fc05', 10, 'a20fa558-7295-4a2a-bbf2-0700729e95e9', 'หากเกิดเหตุไฟดับขณะกำลัง Flash BIOS จนเซิร์ฟเวอร์บูตไม่ขึ้น จะสามารถกู้คืนได้อย่างไร?', 'ใช้ฟีเจอร์ Dual/Redundant BIOS ROM โดยสั่งสลับไปบูตจาก Backup BIOS Bank ผ่านหน้าเว็บ iDRAC/iLO หรือปรับพิน System Maintenance Switch / Recovery Jumper บนเมนบอร์ด', 'สลับไปใช้ Backup BIOS ROM', 5, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.flashcards VALUES ('fe78c77f-9966-4801-83d4-4ee1f0c5e358', 'datacenter:09-dcim:fc01', 10, '14d01b82-65c5-4700-b72d-d0b9e1d84c75', 'เปรียบเทียบการวางสวิตช์แบบ Top-of-Rack (ToR) กับ End-of-Row (EoR)', 'ToR: มีสวิตช์ติดอยู่บนสุดของทุกตู้แร็ค เซิร์ฟเวอร์ใช้สายสั้นต่อขึ้นหัวตู้ตัวเองแล้วลากเฉพาะสาย Uplink ออกไป
EoR: ลากสายจากเซิร์ฟเวอร์ทุกตู้ผ่าน Patch Panel ไปรวมที่ตู้สวิตช์หลักที่อยู่ปลายแถว', 'สวิตช์ประจำทุกตู้ vs สวิตช์รวมที่ปลายแถว', 1, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.flashcards VALUES ('094ace9f-74d6-4460-a08c-1902b98e0873', 'datacenter:09-dcim:fc02', 10, '14d01b82-65c5-4700-b72d-d0b9e1d84c75', 'ทำไมใน Data Center จึงห้ามใช้สายรัดพลาสติก (Zip Tie) กับมัดสายไฟเบอร์และสายแลน แต่ให้ใช้ตีนตุ๊กแก (Velcro)?', 'เพราะ Zip Tie บีบรัดสายแน่นเกินไปจนแกนไฟเบอร์เกิด Micro-bending (แสงรั่ว) และตอนเอาออกต้องใช้คีมตัดซึ่งเสี่ยงตัดโดนสายข้างเคียงขาด ส่วน Velcro ไม่บีบสายและแกะปรับปรุงซ้ำได้ปลอดภัย', 'ป้องกันการบีบสายและไม่ต้องใช้คีมตัด', 2, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.flashcards VALUES ('ffe2ee8c-3caf-43c1-81db-36a5bad18910', 'datacenter:09-dcim:fc03', 10, '14d01b82-65c5-4700-b72d-d0b9e1d84c75', 'ฟีเจอร์ DOM / DDM ในหัว Transceiver SFP มีประโยชน์อย่างไรในการแก้ปัญหาหน้างาน?', 'ช่วยอ่านค่าความเข้มแสงขาออก (Tx Power) และขาเข้า (Rx Power) เป็นหน่วย dBm รวมถึงอุณหภูมิหัว SFP ได้แบบเรียลไทม์ผ่าน CLI ช่วยให้รู้ทันทีว่าแสงอ่อน สายหักงอ หรือสายขาดโดยไม่ต้องถอดสายมาวัด', 'วัดค่าความเข้มแสง Tx/Rx Power (dBm) ผ่าน CLI', 3, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.flashcards VALUES ('fca02f1f-e6fb-4f86-b63c-b09168a44db0', 'datacenter:09-dcim:fc04', 10, '14d01b82-65c5-4700-b72d-d0b9e1d84c75', 'ห้อง MMR (Meet-Me Room) และสาย Cross-Connect ในศูนย์ข้อมูล Colocation คืออะไร?', 'MMR คือห้องชุมสายกลางที่รวมจุดเชื่อมต่อของผู้ให้บริการโครงข่าย (ISP/Carriers) และลูกค้าภายในศูนย์ข้อมูล โดยการเชื่อมสายระหว่างกันจะทำผ่านแผงกระจายสายในห้องนี้ เรียกว่า Cross-Connect', 'ห้องชุมสายกลางเชื่อมต่อระหว่าง ISP และตู้ลูกค้า', 4, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.flashcards VALUES ('dde9fd6a-c6ee-4e47-8817-3daf787dbf86', 'datacenter:09-dcim:fc05', 10, '14d01b82-65c5-4700-b72d-d0b9e1d84c75', 'ระบบ DCIM (เช่น NetBox) เก็บข้อมูลสำคัญอะไรบ้าง?', '1. ผังการจัดวางอุปกรณ์ในตู้แร็คแต่ละชั้น U (Rack Elevation)
2. ทะเบียนสินทรัพย์และ Serial Number
3. ตารางการเชื่อมต่อสายแลน/ไฟเบอร์/สายไฟ (Cable Trace)
4. การจัดสรร IP Address และ VLAN (IPAM)', 'Rack Elevation + Asset + Cable Trace + IPAM', 5, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.flashcards VALUES ('545c826b-7bcb-4146-807b-05518a9e6810', 'datacenter:10-ops:fc01', 10, '4239ddec-0437-4d0e-9b43-7cf2d26d3c23', 'เอกสาร MOP (Method of Procedure) คืออะไร และต้องมีองค์ประกอบหลัก 4 ส่วนอะไรบ้าง?', 'คือคู่มือขั้นตอนการปฏิบัติงานสำหรับการเปลี่ยนแปลงใน Data Center ประกอบด้วย:
1. Pre-checks (ตรวจก่อนทำ)
2. Execution Steps (ขั้นตอนลงมือทำ)
3. Post-checks (ตรวจยืนยันผลหลังทำ)
4. Rollback Plan (แผนย้อนกลับเมื่อล้มเหลว)', 'Pre-check, Execution, Post-check, Rollback', 1, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.flashcards VALUES ('f4b3620e-e118-403d-a1ed-5287d6d38e1a', 'datacenter:10-ops:fc02', 10, '4239ddec-0437-4d0e-9b43-7cf2d26d3c23', 'ประตู Mantrap (Airlock) ในศูนย์ข้อมูลทำหน้าที่ป้องกันความเสี่ยงด้านความปลอดภัยใด?', 'ป้องกันการเดินตามหลังกันเข้าไปโดยไม่ผ่านการยืนยันตัวตน (Anti-Tailgating / Piggybacking) โดยบังคับให้ประตูบานแรกต้องปิดล็อกก่อน ประตูบานที่สองจึงจะเปิดได้', 'ป้องกัน Tailgating (เดินตามกันเข้าประตู)', 2, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.flashcards VALUES ('847d2bad-fcbe-4508-8291-db1467fef999', 'datacenter:10-ops:fc03', 10, '4239ddec-0437-4d0e-9b43-7cf2d26d3c23', 'ทำไมห้ามนำกล่องกระดาษลูกฟูก (Cardboard) เข้าไปในห้อง Data Hall และทำไมต้องจัดการฮาร์ดดิสก์เสียก่อนส่งเคลม RMA?', '- กล่องกระดาษ: ปล่อยฝุ่นเยื่อกระดาษอุดตันพัดลม และเป็นเชื้อเพลิงติดไฟง่าย
- ดิสก์ส่งเคลม RMA: ต้องทำ Secure Wipe, Degauss (ล้างแม่เหล็ก) หรือบดทำลาย (Shredding) เพื่อป้องกันข้อมูลความลับของลูกค้ารั่วไหล', 'ฝุ่น/ไฟไหม้ และป้องกันข้อมูลรั่วไหล (Data Security)', 3, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.flashcards VALUES ('36c302fc-8541-460e-a6eb-f399f2a24a9a', 'datacenter:10-ops:fc04', 10, '4239ddec-0437-4d0e-9b43-7cf2d26d3c23', 'สรุปความแตกต่างของมาตรฐาน Uptime Institute: Tier I, Tier II, Tier III และ Tier IV', '- Tier I (N): ไม่มีระบบสำรอง
- Tier II (N+1): มีอุปกรณ์สำรอง แต่สายส่งเส้นเดียว
- Tier III (N+1, 2 เส้นทาง): ซ่อมบำรุงได้โดยไม่ต้องดับระบบ (Concurrently Maintainable)
- Tier IV (2N): ทนทานต่ออุบัติเหตุรุนแรงโดยระบบไม่สะดุดเลย (Fault Tolerant)', 'N, N+1, Concurrently Maintainable, Fault Tolerant (2N)', 4, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.flashcards VALUES ('f849a0ee-c1f7-42f4-a9d1-201c61f1d422', 'datacenter:10-ops:fc05', 10, '4239ddec-0437-4d0e-9b43-7cf2d26d3c23', 'สูตรคำนวณค่า PUE (Power Usage Effectiveness) คืออะไร และค่าที่ดีควรเป็นเท่าใด?', 'PUE = พลังงานไฟฟ้าทั้งหมดที่อาคารใช้ (Total Facility Power) / พลังงานที่อุปกรณ์ไอทีใช้จริง (IT Equipment Power)
ค่าอุดมคติคือ 1.0 (ยิ่งใกล้ 1.0 ยิ่งประหยัดพลังงานแอร์และระบบไฟ)', 'Total Facility Power / IT Equipment Power (ยิ่งใกล้ 1.0 ยิ่งดี)', 5, '2026-11-10 12:41:13.45737+00', '2026-11-10 12:41:13.45737+00');
INSERT INTO public.flashcards VALUES ('35442cc5-c412-48b8-ac73-0467c0f3b493', 'troubleshooting:03-itil-sla:fc01', 6, '20d9ad57-bea5-4819-889f-9ff3841bb039', 'ตามมาตรฐาน ITIL คำว่า "Incident" กับ "Service Request" ต่างกันอย่างไร?', '- Incident: เหตุขัดข้องที่ไม่ได้วางแผนไว้ ทำให้บริการที่เคยใช้งานได้ปกติหยุดชะงักหรือช้าลง (เช่น เน็ตหลุด, เข้าโปรแกรมไม่ได้)
- Service Request: คำขอรับบริการมาตรฐานที่ระบบไม่ได้พัง (เช่น ขอสร้าง User ใหม่, ขอสิทธิ์เข้าโฟลเดอร์, ขอลงโปรแกรม)', 'ของพัง/สะดุด vs ขอรับบริการใหม่ตามมาตรฐาน', 1, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.flashcards VALUES ('ef22eb82-6951-4e95-8761-570151dcf80b', 'troubleshooting:03-itil-sla:fc02', 6, '20d9ad57-bea5-4819-889f-9ff3841bb039', 'สมการคำนวณระดับความสำคัญของใบงาน (Priority Matrix) ใน ITIL ใช้ 2 ปัจจัยใดคูณกัน?', 'Priority = Impact (ขอบเขตผลกระทบต่อผู้ใช้หรือธุรกิจ) × Urgency (ความเร่งด่วนที่ธุรกิจรอไม่ได้)', 'Impact × Urgency', 2, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.flashcards VALUES ('2418de3d-76a2-4df8-9253-630638a0bc93', 'troubleshooting:03-itil-sla:fc03', 6, '20d9ad57-bea5-4819-889f-9ff3841bb039', 'Response SLA กับ Resolution SLA ต่างกันอย่างไร?', '- Response SLA: เวลาตั้งแต่เปิด Ticket จนถึงเจ้าหน้าที่รับเรื่องและตอบกลับผู้แจ้งครั้งแรก
- Resolution SLA: เวลาตั้งแต่เปิด Ticket จนถึงแก้ไขปัญหาเสร็จสมบูรณ์และบริการกลับมาใช้งานได้', 'เวลาตอบรับครั้งแรก vs เวลาแก้ปัญหาจนจบ', 3, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.flashcards VALUES ('5147596b-3c77-4196-b203-206d93b44e86', 'troubleshooting:03-itil-sla:fc04', 6, '20d9ad57-bea5-4819-889f-9ff3841bb039', 'ในกรอบ ITIL คำว่า "Problem" แตกต่างจาก "Incident" อย่างไร?', 'Incident คืออาการขัดข้องที่เกิดขึ้นตรงหน้า (เน้นกู้คืนให้เร็วที่สุด) ส่วน Problem คือ "ต้นตอสาเหตุ (Root Cause)" ที่ทำให้เกิด Incident รุนแรงหรือเกิดซ้ำๆ (เน้นสืบหา RCA เพื่อแก้ถาวร)', 'อาการที่เกิด vs ต้นตอสาเหตุที่ทำให้เกิดซ้ำ', 4, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.flashcards VALUES ('9e7ff220-6792-4716-9acf-fdccb8d3a5e2', 'troubleshooting:03-itil-sla:fc05', 6, '20d9ad57-bea5-4819-889f-9ff3841bb039', 'องค์ประกอบสำคัญที่ต้องเขียนใน Escalation Note ก่อนส่งเคสให้ทีม L2/L3 มีอะไรบ้าง?', '1. Who (ใคร/กี่คนได้รับผลกระทบ)
2. What & Where (อาการและระบบ/IP ปลายทาง)
3. When (เวลาที่เริ่มเกิดเหตุ)
4. Evidence (ภาพ Error / Log / ผล ping-tracert)
5. What has been tested (สิ่งที่ L1 ทดสอบและตัดประเด็นไปแล้ว)', '5W + Evidence + สิ่งที่ทดสอบไปแล้ว', 5, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.flashcards VALUES ('6bd9deec-fe04-417e-afcb-8dabaa340503', 'troubleshooting:04-ad-gpo:fc01', 6, 'db3e3c4d-8da3-45fd-99a6-c07212788dff', 'ใน Active Directory ความแตกต่างระหว่าง Organizational Unit (OU) กับ Security Group คืออะไร?', '- OU (Organizational Unit): โฟลเดอร์จัดโครงสร้างแผนก/สาขา ใช้สำหรับผูก Group Policy (GPO) และมอบหมายสิทธิ์ดูแลระบบ
- Security Group: กลุ่มรวมผู้ใช้เพื่อนำไปกำหนดสิทธิ์เข้าถึงทรัพยากร (เช่น สิทธิ์อ่าน/เขียนโฟลเดอร์แชร์)', 'OU ใช้ผูก GPO vs Security Group ใช้ให้สิทธิ์ Permission', 1, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.flashcards VALUES ('bd1df22f-8754-4ffe-bd8e-4d5707aa2318', 'troubleshooting:04-ad-gpo:fc02', 6, 'db3e3c4d-8da3-45fd-99a6-c07212788dff', 'อาการ "The trust relationship between this workstation and the primary domain failed" เกิดจากอะไร และใช้คำสั่ง PowerShell ใดซ่อมได้โดยไม่ต้องถอดโดเมน?', 'เกิดจากรหัสผ่านประจำเครื่องลูก (Machine Account Password) ไม่ตรงกับที่ Domain Controller จำไว้
ซ่อมด้วยคำสั่ง: Test-ComputerSecureChannel -Repair -Credential (Get-Credential)', 'Machine Password ไม่ตรงกับ DC / Test-ComputerSecureChannel -Repair', 2, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.flashcards VALUES ('495ef380-0c88-4b2e-8eb0-2f218c102193', 'troubleshooting:04-ad-gpo:fc03', 6, 'db3e3c4d-8da3-45fd-99a6-c07212788dff', 'ทำไมนาฬิกาของเครื่องคอมพิวเตอร์ที่เพี้ยนเกิน 5 นาที ถึงทำให้ล็อกอินเข้า Active Directory ไม่ได้?', 'เพราะโปรโตคอล Kerberos ใช้เวลาประทับ (Timestamp) ในการป้องกัน Replay Attack โดยอนุญาตให้เวลาคลาดเคลื่อน (Clock Skew) ได้สูงสุดไม่เกิน 5 นาที', 'Kerberos ป้องกัน Replay Attack (Clock Skew <= 5 นาที)', 3, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.flashcards VALUES ('1513ce53-028a-45ab-b967-d2ed5276450b', 'troubleshooting:04-ad-gpo:fc04', 6, 'db3e3c4d-8da3-45fd-99a6-c07212788dff', 'คำสั่งบังคับอัปเดต Group Policy ทันที และคำสั่งตรวจสอบว่าเครื่องได้รับ GPO ตัวไหนบ้างคืออะไร?', '- บังคับอัปเดตทันที: gpupdate /force
- ตรวจสอบผลลัพธ์ GPO: gpresult /r (หรือส่งออกเป็นเว็บด้วย gpresult /h report.html)', 'gpupdate /force และ gpresult /r', 4, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.flashcards VALUES ('3acd1379-b7b1-4fdc-b3b2-47067c1978a5', 'troubleshooting:04-ad-gpo:fc05', 6, 'db3e3c4d-8da3-45fd-99a6-c07212788dff', 'เมื่อผู้ใช้งานเปลี่ยนรหัสผ่าน AD แล้วเจอปัญหา Account Locked Out ซ้ำทุกไม่กี่นาที ควรตรวจสอบจุดใดเป็นอันดับแรก?', '1. มือถือ/แท็บเล็ตที่ต่อ Wi-Fi องค์กรหรือผูกอีเมลไว้ด้วยรหัสผ่านเก่า
2. รหัสผ่านเก่าที่จำค้างใน Windows Credential Manager หรือ Mapped Drive
3. เซสชัน Remote Desktop (RDP) ที่ล็อกอินค้างไว้บนเครื่องอื่น', 'มือถือ (Wi-Fi/Mail), Credential Manager, RDP ค้าง', 5, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.flashcards VALUES ('50112021-36c9-4534-bf5f-7cbda0a7e900', 'troubleshooting:05-m365-email:fc01', 6, 'b4c768d7-eb4b-47f6-8044-356dd03f07cc', 'Shared Mailbox ใน Microsoft 365 มีข้อดีอย่างไรเมื่อเทียบกับ User Mailbox?', 'Shared Mailbox ไม่ต้องใช้ License เสียเงิน (ฟรีสำหรับขนาดไม่เกิน 50 GB) เหมาะสำหรับทำอีเมลกลางของแผนก (เช่น support@, hr@) โดยกำหนดสิทธิ์ให้พนักงานที่มีบัญชีอยู่แล้วเปิดอ่านและส่งในนามอีเมลกลางได้', 'ฟรีไม่เสีย License (สูงสุด 50 GB) เหมาะทำอีเมลแผนก', 1, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.flashcards VALUES ('66e4410f-c81a-49ea-b19a-cf0b51c0e6e8', 'troubleshooting:05-m365-email:fc02', 6, 'b4c768d7-eb4b-47f6-8044-356dd03f07cc', 'อธิบายหน้าที่ของระเบียน MX, SPF, DKIM และ DMARC แบบสั้นกระชับ', '- MX: ระบุเซิร์ฟเวอร์รับอีเมลขาเข้าของโดเมน
- SPF: ระบุรายการ IP/Server ที่ได้รับอนุญาตให้ส่งเมลออกในนามโดเมน
- DKIM: ลายเซ็นดิจิทัลเข้ารหัสใน Header ยืนยันว่าเมลไม่ถูกปลอมหรือแก้กลางทาง
- DMARC: นโยบายสั่งการ (none/quarantine/reject) เมื่อตรวจ SPF/DKIM ไม่ผ่าน', 'MX=ขารับ, SPF=IP ผู้ส่ง, DKIM=ลายเซ็นดิจิทัล, DMARC=นโยบายลงโทษ', 2, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.flashcards VALUES ('3c4051a5-bc39-4baf-a49a-c535c182c702', 'troubleshooting:05-m365-email:fc03', 6, 'b4c768d7-eb4b-47f6-8044-356dd03f07cc', 'ในระเบียน SPF ค่า "~all" (SoftFail) กับ "-all" (HardFail) ต่างกันอย่างไร?', '- ~all (SoftFail): หากเมลส่งมาจาก IP นอกรายการ ให้รับไว้แต่ตีตราว่าน่าสงสัย (มักเข้าโฟลเดอร์ Spam/Junk)
- -all (HardFail): หากส่งมาจาก IP นอกรายการ ให้ปฏิเสธหรือบล็อกทิ้งทันที', '~all เข้า Spam vs -all บล็อกทิ้ง', 3, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.flashcards VALUES ('a2da7e96-7da0-43e0-bd62-6ec0ea4908f8', 'troubleshooting:05-m365-email:fc04', 6, 'b4c768d7-eb4b-47f6-8044-356dd03f07cc', 'รหัสอีเมลตีกลับ (NDR) "550 5.1.1" และ "550 5.7.1" หมายถึงอะไร?', '- 550 5.1.1 (User Unknown): ไม่มีที่อยู่อีเมลผู้รับนี้ในระบบปลายทาง (สะกดผิดหรือถูกลบแล้ว)
- 550 5.7.1 (Relay Denied / Blocked): ถูกปฏิเสธด้วยเหตุผลด้านความปลอดภัย เช่น ติด Blacklist หรือไม่ผ่านเกณฑ์ SPF/DMARC', '5.1.1 = ไม่มีชื่อผู้รับนี้, 5.7.1 = ติดสิทธิ์/ถูกบล็อก Spam', 4, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.flashcards VALUES ('22d90dd2-2a0d-4f28-b872-302f48c4da97', 'troubleshooting:05-m365-email:fc05', 6, 'b4c768d7-eb4b-47f6-8044-356dd03f07cc', 'เมื่อพนักงานลาออก ต้องทำอย่างไรใน Microsoft 365 เพื่อเก็บอีเมลเก่าไว้โดยไม่ต้องเสียค่า License รายเดือน?', 'สั่งแปลงกล่องจดหมายจาก User Mailbox เป็น "Shared Mailbox" (Convert to Shared Mailbox) ก่อน จากนั้นค่อยถอด License ออกและบล็อกการ Sign-in', 'Convert to Shared Mailbox แล้วถอด License', 5, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.flashcards VALUES ('2d3bc423-01a6-469e-837f-b5cbcd17c0b4', 'troubleshooting:06-printer-smb:fc01', 6, '36390028-97e0-4e57-b0db-c9c4f778cb68', 'ขั้นตอนการล้างคิวงานพิมพ์ที่ค้างตาย (Stuck Print Job) บน Windows ผ่าน Command Prompt ต้องทำอย่างไร?', '1. net stop spooler (หยุดบริการ Print Spooler)
2. ลบไฟล์ค้างใน C:\Windows\System32\spool\PRINTERS
3. net start spooler (เปิดบริการกลับมาใหม่)', 'หยุด spooler ➔ ลบไฟล์ในโฟลเดอร์ PRINTERS ➔ เปิด spooler', 1, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.flashcards VALUES ('094be667-5974-47a6-89e5-dfb732a567fc', 'troubleshooting:06-printer-smb:fc02', 6, '36390028-97e0-4e57-b0db-c9c4f778cb68', 'พอร์ตมาตรฐานของ Network Printer แบบ Standard TCP/IP (RAW) คือพอร์ตใด และทำไมจึงดีกว่า WSD Port?', 'พอร์ต TCP 9100
ดีกว่า WSD เพราะเชื่อมต่อตรงไปยัง Static IP ของเครื่องพิมพ์ ไม่หลุดเป็น Offline ง่ายเวลาเครื่องพิมพ์เข้าโหมด Sleep เหมือน WSD', 'TCP 9100 เชื่อมต่อตรงด้วย IP ไม่หลุดง่ายเหมือน WSD', 2, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.flashcards VALUES ('9f8a0976-99dc-4e0d-9d15-65472857a5e6', 'troubleshooting:06-printer-smb:fc03', 6, '36390028-97e0-4e57-b0db-c9c4f778cb68', 'เมื่อนำสิทธิ์ Share Permission มาคิดร่วมกับ NTFS Permission บน Windows File Share สิทธิ์ใดจะเป็นฝ่ายชนะ?', 'สิทธิ์ที่ "เข้มงวดที่สุด (Most Restrictive)" จะเป็นฝ่ายชนะเสมอ (เช่น Share = Read แต่ NTFS = Full Control ผลลัพธ์เมื่อเข้าผ่านเครือข่ายจะได้แค่ Read)', 'Most Restrictive Wins (ตัวที่เข้มงวดกว่าชนะ)', 3, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.flashcards VALUES ('90db626f-195f-4daf-8811-f615127a20ad', 'troubleshooting:06-printer-smb:fc04', 6, '36390028-97e0-4e57-b0db-c9c4f778cb68', 'การแชร์ไฟล์แบบ SMB (\\server\share) ใช้พอร์ตใด และใช้คำสั่งใดล้างการเชื่อมต่อที่จำรหัสผ่านค้างไว้?', '- ใช้พอร์ต TCP 445
- คำสั่งล้างการเชื่อมต่อที่ค้าง: net use * /delete', 'TCP 445 และ net use * /delete', 4, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.flashcards VALUES ('16942b4e-8af8-4b30-9f6b-458d1df3a405', 'troubleshooting:06-printer-smb:fc05', 6, '36390028-97e0-4e57-b0db-c9c4f778cb68', 'Full Tunnel VPN กับ Split Tunnel VPN ต่างกันอย่างไร?', '- Full Tunnel: ทราฟฟิกทั้งหมด (รวมถึงเว็บทั่วไป) วิ่งเข้าอุโมงค์ VPN ไปออกเน็ตที่บริษัท
- Split Tunnel: เฉพาะทราฟฟิกที่ไปวงแลนภายในบริษัทเท่านั้นที่วิ่งเข้า VPN ส่วนเว็บทั่วไปออกทางเน็ตบ้านโดยตรง', 'วิ่งเข้าบริษัททั้งหมด vs แยกเฉพาะวงภายในเข้า VPN', 5, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.flashcards VALUES ('84b7b888-d67d-4747-935e-c10f6611db70', 'troubleshooting:07-backup-dr:fc01', 6, 'efdde8b7-94d1-4638-bb7d-cc05c37f6634', 'กฎเหล็กการสำรองข้อมูล "3-2-1-1-0 Backup Rule" คืออะไร?', '- 3 ชุดข้อมูล (1 ตัวจริง + 2 สำรอง)
- 2 สื่อบันทึกข้อมูลต่างชนิดกัน
- 1 ชุดเก็บนอกสถานที่ (Offsite/Cloud)
- 1 ชุดเป็น Immutable (ล็อกห้ามลบ/แก้) หรือ Air-Gapped (ตัดจากเน็ต)
- 0 ข้อผิดพลาดจากการซ้อมกู้คืนจริง (Restore Testing)', '3 ชุด, 2 สื่อ, 1 นอกสถานที่, 1 Immutable/Offline, 0 Error ตอนเทสต์กู้คืน', 1, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.flashcards VALUES ('0de53113-3ec4-4e68-954d-112ca7641033', 'troubleshooting:07-backup-dr:fc02', 6, 'efdde8b7-94d1-4638-bb7d-cc05c37f6634', 'RPO (Recovery Point Objective) กับ RTO (Recovery Time Objective) ต่างกันอย่างไร?', '- RPO (มองย้อนหลัง): ปริมาณข้อมูลที่ธุรกิจยอมให้สูญหายย้อนหลังได้นานแค่ไหน (เป็นตัวกำหนดความถี่ในการทำ Backup)
- RTO (มองไปข้างหน้า): เวลาสูงสุดที่ระบบต้องใช้ในการกู้คืนจนกลับมาเปิดใช้งานได้หลังเกิดเหตุล่ม', 'RPO = ข้อมูลหายย้อนหลังได้แค่ไหน, RTO = ต้องกู้เสร็จภายในเวลาเท่าใด', 2, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.flashcards VALUES ('4fc5334d-f0a1-42e0-b623-601fbeae8d9f', 'troubleshooting:07-backup-dr:fc03', 6, 'efdde8b7-94d1-4638-bb7d-cc05c37f6634', 'Incremental Backup กับ Differential Backup ต่างกันอย่างไรตอนบันทึกและตอนกู้คืน (Restore)?', '- Incremental: เก็บเฉพาะส่วนต่างจาก Backup ครั้งล่าสุด (เร็วและเล็กที่สุด แต่ตอนกู้ต้องใช้ Full + Incremental ทุกวันเรียงกัน)
- Differential: เก็บส่วนต่างสะสมนับจาก Full ล่าสุด (ไฟล์ใหญ่ขึ้นทุกวัน แต่ตอนกู้ใช้แค่ Full ล่าสุด + Differential ก้อนล่าสุดเพียง 2 ก้อน)', 'Incremental เร็วแต่ต้องใช้ทุกก้อนตอนกู้ vs Differential ใช้แค่ 2 ก้อนตอนกู้', 3, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.flashcards VALUES ('e6d5e2da-6240-4372-8235-b90bb6cfbd5e', 'troubleshooting:07-backup-dr:fc04', 6, 'efdde8b7-94d1-4638-bb7d-cc05c37f6634', 'Immutable Backup (WORM) คืออะไร และช่วยป้องกัน Ransomware ได้อย่างไร?', 'คือการสำรองข้อมูลแบบ Write Once, Read Many ที่ล็อกห้ามแก้ไขและห้ามลบไฟล์ภายในระยะเวลาที่กำหนด ต่อให้คนร้ายขโมยสิทธิ์ Admin ไปได้ ก็ไม่สามารถสั่งลบหรือเข้ารหัสทับไฟล์ Backup ชุดนี้ได้', 'Write Once Read Many ล็อกห้ามลบห้ามแก้', 4, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.flashcards VALUES ('e88c2021-e6df-49bf-ae1c-bdaf00fa4e59', 'troubleshooting:07-backup-dr:fc05', 6, 'efdde8b7-94d1-4638-bb7d-cc05c37f6634', '3 ขั้นตอนแรกที่ต้องทำทันทีเมื่อพบเครื่องผู้ใช้งานติดไวรัสเรียกค่าไถ่ (Ransomware) คืออะไร?', '1. Isolate: ดึงสาย LAN ออกและปิด Wi-Fi ทันทีเพื่อหยุดการลามไปหา File Share (SMB)
2. Do NOT connect backup drives: ห้ามเสียบ USB/External Drive สำรองเข้าเครื่องนั้นเด็ดขาด
3. Escalate & Disable Account: แจ้งทีม Security/SOC และระงับสิทธิ์บัญชี AD ของเครื่องนั้นทันที', 'ดึงสายแลน/ปิด Wi-Fi ➔ ห้ามเสียบไดรฟ์สำรอง ➔ แจ้ง SOC & ระงับบัญชี AD', 5, '2026-11-10 12:53:16.618762+00', '2026-11-10 12:53:16.618762+00');
INSERT INTO public.flashcards VALUES ('7ebf91de-4d49-4007-9fb9-240e33da44fe', 'datacenter:11-equip:fc01', 10, '681252fc-9293-40e3-9100-c19b27e9f69c', 'เครื่องมือ "VFL (Visual Fault Locator)" และ "One-Click Fiber Cleaner" ใช้ทำอะไรในงาน Data Center?', '- VFL (ปากกายิงแสงเลเซอร์สีแดง 650nm): ใช้ส่องหาปลายสายไฟเบอร์ในแผง ODF และตรวจหาจุดที่สายไฟเบอร์หักงอหรือขาด
- One-Click Cleaner: ปากกากดทำความสะอาดคราบฝุ่นและไขมันที่ปลายหัวไฟเบอร์ (LC/SC) และในช่อง SFP', 'VFL ยิงแสงแดงหาจุดสายหัก/ปลายสาย, One-Click ทำความสะอาดหัวไฟเบอร์', 1, '2026-11-10 13:22:20.548088+00', '2026-11-10 13:22:20.548088+00');
INSERT INTO public.flashcards VALUES ('e814b93c-50f8-4eb8-8e76-6f68c2ca8980', 'datacenter:11-equip:fc02', 10, '681252fc-9293-40e3-9100-c19b27e9f69c', 'หัวอุด "Loopback Plug" (Fiber / RJ45 Loopback) มีประโยชน์อย่างไรในการวิเคราะห์ปัญหาหน้างาน?', 'ใช้วนสัญญาณขาส่ง (Tx) กลับเข้าขารับ (Rx) ของพอร์ตตัวเอง เพื่อพิสูจน์แยกแยะปัญหา: หากเสียบ Loopback แล้วไฟพอร์ตขึ้นสีเขียว แปลว่าพอร์ตสวิตช์และตัว SFP ทำงานปกติ ปัญหาเกิดจากสายเคเบิลหรืออุปกรณ์ปลายทาง', 'วน Tx เข้า Rx ตัวเอง เพื่อพิสูจน์ว่าพอร์ต/SFP ไม่ได้เสีย', 2, '2026-11-10 13:22:20.548088+00', '2026-11-10 13:22:20.548088+00');
INSERT INTO public.flashcards VALUES ('7da3c17e-7fc3-4315-95d9-9662721d3c0f', 'datacenter:11-equip:fc03', 10, '681252fc-9293-40e3-9100-c19b27e9f69c', 'หัวปลั๊กไฟมาตรฐาน IEC C13/C14 กับ IEC C19/C20 ต่างกันอย่างไร?', '- IEC C13/C14: หัวมาตรฐานขาแนวตั้ง รองรับกระแส 10A-15A ใช้กับเซิร์ฟเวอร์ 1U/2U และสวิตช์ทั่วไป
- IEC C19/C20: หัวสี่เหลี่ยมใหญ่ขาแนวนอน รองรับกระแสสูง 16A-20A ใช้กับ Blade Chassis, GPU Server, Core Switch และ PDU', 'C13/C14 (10-15A ขาตั้ง) vs C19/C20 (16-20A หัวใหญ่ขานอน)', 3, '2026-11-10 13:22:20.548088+00', '2026-11-10 13:22:20.548088+00');
INSERT INTO public.flashcards VALUES ('db4ee3f8-e37e-471f-8437-3a400b48a372', 'datacenter:11-equip:fc04', 10, '681252fc-9293-40e3-9100-c19b27e9f69c', 'Cage Nut และ Blanking Panel ในตู้แร็ค 42U คืออะไรและมีหน้าที่อะไร?', '- Cage Nut: น็อตตัวเมียในกรงสปริงสี่เหลี่ยมสำหรับบีบใส่รูสี่เหลี่ยมของเสาตู้แร็คเพื่อยึดรางหรือหูเครื่อง
- Blanking Panel: แผ่นปิดช่องว่าง U ด้านหน้าตู้แร็ค เพื่อกั้นไม่ให้ลมร้อนจากหลังตู้ไหลย้อนกลับมาเข้าหน้าเครื่อง (ป้องกัน Hot Air Recirculation)', 'Cage Nut ยึดรูสี่เหลี่ยมเสาแร็ค, Blanking Panel ปิดช่องว่างกั้นลมร้อนไหลย้อน', 4, '2026-11-10 13:22:20.548088+00', '2026-11-10 13:22:20.548088+00');
INSERT INTO public.flashcards VALUES ('f1a28a48-5fb3-429e-8b1c-c0b21ac4175d', 'datacenter:11-equip:fc05', 10, '681252fc-9293-40e3-9100-c19b27e9f69c', 'ค่ามาตรฐานสากลในการตั้งค่าโปรแกรม PuTTY (โหมด Serial) เมื่อต่อสาย Console เข้ากับ Switch/Router คืออะไร?', 'รหัสมาตรฐาน "9600-8-N-1":
- Speed (Baud rate): 9600
- Data bits: 8
- Parity: None
- Stop bits: 1
- Flow control: None', '9600-8-N-1 (Flow control = None)', 5, '2026-11-10 13:22:20.548088+00', '2026-11-10 13:22:20.548088+00');
INSERT INTO public.flashcards VALUES ('7683d542-475f-43f6-a276-fd38d4caa810', 'network:11-design:fc01', 2, '3e090998-8642-4e35-af78-02f95246485a', 'โมเดล 3-Tier ของ Cisco ประกอบด้วย 3 ชั้นใดบ้าง และ Core Layer มีกฎเหล็กสำคัญอย่างไร?', '1. Core Layer: ทางด่วนส่งข้อมูลความเร็วสูง (กฎเหล็ก: ห้ามใส่ ACLs/Packet Filter ซับซ้อน เพื่อรักษาความเร็วสูงสุด)
2. Distribution Layer: ชั้นควบคุมนโยบาย, ACLs, Inter-VLAN Routing
3. Access Layer: ชั้นเชื่อมต่ออุปกรณ์ปลายทาง (PC, AP, Printer)', 'Core (เร็วสุด ห้ามใส่ ACL), Distribution (กรองและ Routing), Access (ต่อผู้ใช้)', 1, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('5128d77c-b804-44b6-aff1-5c7535ac976c', 'network:11-design:fc02', 2, '3e090998-8642-4e35-af78-02f95246485a', 'ทำไม Data Center ยุคใหม่จึงเปลี่ยนมาใช้ Spine-Leaf Architecture แทน 3-Tier?', 'เพราะทราฟฟิกใน Data Center ยุคใหม่เป็นแบบ East-West (Server คุยกับ Server) สูงเกิน 80%
Spine-Leaf ทำให้ทุกคู่ตู้แร็คมีระยะทางคงที่ 2 Hops เสมอ และใช้ ECMP (Layer 3) วิ่งพร้อมกันทุกเส้นโดยไม่ถูก Spanning Tree บล็อก', 'รองรับ East-West traffic, ระยะทางคงที่ 2 Hops, ใช้ ECMP แทน STP', 2, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('a90046e8-a276-4d2e-af77-0b2423d8512d', 'network:11-design:fc03', 2, '3e090998-8642-4e35-af78-02f95246485a', 'HSRP กับ VRRP คืออะไร และต่างกันอย่างไร?', 'คือโปรโตคอลสร้าง Virtual Default Gateway สำรอง (FHRP) ระหว่างสวิตช์/เราเตอร์ 2 ตัว:
- HSRP: ลิขสิทธิ์เฉพาะของ Cisco (แบ่งเป็น Active / Standby)
- VRRP: มาตรฐานเปิดสากล ใช้ได้กับทุกยี่ห้อ (แบ่งเป็น Master / Backup)', 'Virtual Gateway สำรอง: HSRP = Cisco, VRRP = มาตรฐานเปิดสากล', 3, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('91ca31f3-3a23-4f3c-8cbb-9c99625fa1c2', 'network:11-design:fc04', 2, '3e090998-8642-4e35-af78-02f95246485a', 'vPC (Virtual Port Channel) หรือ MLAG มีประโยชน์อย่างไรในการต่อเซิร์ฟเวอร์เข้าตู้แร็ค?', 'ช่วยให้เซิร์ฟเวอร์สามารถต่อสายแลน 2 เส้นด้วย LACP แยกไปยังสวิตช์คนละตู้ได้ โดยสวิตช์คู่มองเห็นเป็น Port Channel เดียวกัน ทำให้ไม่มีจุดล้มเหลวเดี่ยว (SPOF) ระดับตู้สวิตช์', 'ทำ LACP ข้ามสวิตช์ 2 ตัว ป้องกันสวิตช์ตัวใดตัวหนึ่งพัง', 4, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('51aa221e-7791-48e1-bbca-98e904040fba', 'network:11-design:fc05', 2, '3e090998-8642-4e35-af78-02f95246485a', 'DMZ (Demilitarized Zone) คืออะไร และมีกฎเหล็กความปลอดภัยอย่างไร?', 'โซนเครือข่ายตรงกลางระหว่างอินเทอร์เน็ตกับวงภายใน ใช้ตั้งเซิร์ฟเวอร์สาธารณะ (Web/Proxy)
กฎเหล็ก: เครื่องใน DMZ ต้องไม่สามารถริเริ่มสร้างการเชื่อมต่อ (Initiate Connection) เข้าสู่วงภายในองค์กรได้โดยตรง เพื่อป้องกันคนร้ายทะลุเข้าหาฐานข้อมูล', 'โซนคั่นกลางเซิร์ฟเวอร์สาธารณะ ห้ามเริ่มต่อสายเข้าสู่วงภายใน', 5, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('1c42edd3-cded-4007-94d0-2483c90ab243', 'tools:01-packet-tracer:fc01', 11, '93a91167-81c5-4497-a769-3930c59a54b1', 'Cisco Packet Tracer จัดเป็นซอฟต์แวร์ประเภทใด และมีข้อดี-ข้อจำกัดอย่างไร?', 'เป็น "Network Simulator" (จำลองพฤติกรรมและคำสั่ง)
- ข้อดี: กินทรัพยากรน้อยมาก ทำแล็บขนาดใหญ่บนโน้ตบุ๊กทั่วไปได้สบาย
- ข้อจำกัด: รองรับคำสั่ง IOS เฉพาะชุดที่กำหนดไว้ ไม่สามารถรันฟีเจอร์ระดับสูงของจริงได้ทั้งหมด', 'Network Simulator กินสเปกน้อย แต่คำสั่งไม่ครบ 100% เหมือนของจริง', 1, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('e441f420-50c9-4627-bc41-cf24400a5c86', 'tools:01-packet-tracer:fc02', 11, '93a91167-81c5-4497-a769-3930c59a54b1', 'Realtime Mode กับ Simulation Mode ใน Packet Tracer ต่างกันอย่างไร?', '- Realtime Mode: เครือข่ายทำงานตามเวลาจริง (ไฟส้ม STP รอ 30-50 วินาที มีปุ่ม Fast Forward Time ช่วยเร่งเวลา)
- Simulation Mode: เวลาหยุดนิ่ง เห็นซองจดหมาย PDU วิ่งทีละก้าว และกดดู Header ของ OSI Model แต่ละชั้นได้', 'เวลาจริง (เร่งเวลาได้) vs เวลาหยุดนิ่ง (แกะดู PDU ทีละก้าว)', 2, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('d999d8ef-305d-4761-8b50-ebeea107ec9f', 'tools:01-packet-tracer:fc03', 11, '93a91167-81c5-4497-a769-3930c59a54b1', 'ปุ่มลัดใดใน Packet Tracer ใช้เร่งเวลา (Fast Forward Time) ข้ามช่วงรอไฟพอร์ตสีส้มของ Spanning Tree?', 'กดปุ่ม "Alt + D" หรือคลิกปุ่มลูกศรคู่ >> ด้านล่างข้างรูปนาฬิกา', 'Alt + D (Fast Forward Time)', 3, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('42ec9f6a-cbc9-46cb-b669-4c5127e70c3f', 'tools:01-packet-tracer:fc04', 11, '93a91167-81c5-4497-a769-3930c59a54b1', 'PDU Inspector ใน Simulation Mode ช่วยแสดงข้อมูลอะไรบ้างในการวิเคราะห์เครือข่าย?', '1. OSI Model View: แสดงขั้นตอนการประมวลผลของ Layer 1 ถึง Layer 7 (ทั้ง Inbound และ Outbound)
2. PDU Details: ผ่าดูข้อมูลโครงสร้าง Header จริง เช่น MAC Address, IP Header, TCP/UDP พอร์ต และ ICMP Type', 'OSI 7 Layers ขั้นตอนการคิด + ไส้ใน Packet Header จริง', 4, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('cc942bce-ae78-48a1-9a39-5be2b890b208', 'tools:01-packet-tracer:fc05', 11, '93a91167-81c5-4497-a769-3930c59a54b1', 'ไฟล์แล็บ ".pkt" กับ ".pka" ของ Packet Tracer ต่างกันอย่างไร?', '- .pkt: ไฟล์บันทึกผังเครือข่ายและคอนฟิกทั่วไป (บันทึกและแก้ไขได้อิสระ)
- .pka: ไฟล์ Activity โจทย์แบบฝึกหัด มีระบบตรวจคะแนนอัตโนมัติ (Completion %) และล็อกหน้าต่างคำสั่งไว้', '.pkt = ไฟล์ผังทั่วไป, .pka = ไฟล์โจทย์สอบตรวจคะแนนอัตโนมัติ', 5, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('5bbc3786-0d90-4a5f-b7a6-d2232ca29821', 'tools:02-gns3:fc01', 11, '9a90cb58-d93b-420d-b47b-7cb59fd88ba0', 'Network Simulator (Packet Tracer) กับ Network Emulator (GNS3/EVE-NG) ต่างกันอย่างไร?', '- Simulator: เขียนโปรแกรมเลียนแบบคำสั่ง กินสเปกน้อย แต่คำสั่งไม่ครบ 100%
- Emulator: จำลองฮาร์ดแวร์เสมือนแล้วนำ "ระบบปฏิบัติการจริง (Real OS)" มาบูต สมจริง 100% รองรับหลายยี่ห้อ แต่กิน RAM/CPU สูง', 'จำลองคำสั่งบางส่วน (กินสเปกน้อย) vs บูต OS จริง 100% (กิน RAM/CPU สูง)', 1, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('0e9a1fb1-e2fb-413f-b353-576da58e5256', 'tools:02-gns3:fc02', 11, '9a90cb58-d93b-420d-b47b-7cb59fd88ba0', 'สถาปัตยกรรม GNS3 GUI ทำงานคู่กับ GNS3 VM อย่างไร?', 'GNS3 GUI ติดตั้งบนเครื่องหลักเพื่อวาดผังและควบคุม ส่วน GNS3 VM รันบน VMware/VirtualBox (Linux) เพื่อรันระบบปฏิบัติการเสมือน (QEMU/KVM, IOU, Docker) ให้มีประสิทธิภาพและเสถียรภาพสูงสุด', 'GUI วาดผังบนโฮสต์ + VM (Linux) เป็นตัวรันอุปกรณ์เสมือน', 2, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('e9117e23-44f5-47fe-8477-04fa3feab391', 'tools:02-gns3:fc03', 11, '9a90cb58-d93b-420d-b47b-7cb59fd88ba0', 'ค่า "Idle-PC" ใน GNS3 คืออะไร และจำเป็นต้องตั้งค่าเมื่อใด?', 'คือค่าที่คำนวณรอบลูปว่างของเราเตอร์ Dynamips เพื่อสั่งหยุดการหมุน CPU คอมพิวเตอร์ตอนเราเตอร์ว่างงาน ป้องกันไม่ให้ CPU ของเครื่องโฮสต์พุ่งขึ้น 100%', 'สั่งหยุดรอบ CPU ตอนเราเตอร์ว่างงาน ป้องกัน CPU วิ่ง 100%', 3, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('9314cd4a-d91f-4b23-9e7a-771dce0dc332', 'tools:02-gns3:fc04', 11, '9a90cb58-d93b-420d-b47b-7cb59fd88ba0', 'อิมเมจชนิดใดใน GNS3 ที่กินทรัพยากรน้อยมากแต่รองรับคำสั่ง Layer 2/3 Cisco ได้สมบูรณ์แบบ?', 'Cisco IOU / IOL (IOS on Linux) ซึ่งกิน RAM เพียง 256–512 MB ต่อตัว และรองรับการทำสวิตชิ่งขั้นสูงอย่างสมบูรณ์', 'Cisco IOU (IOS on Linux)', 4, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('435e9281-4de0-4be0-b8b6-c4db13d7761b', 'tools:02-gns3:fc05', 11, '9a90cb58-d93b-420d-b47b-7cb59fd88ba0', 'การทำ Packet Capture ใน GNS3 เชื่อมโยงกับโปรแกรมใด และมีขั้นตอนอย่างไร?', 'เชื่อมโยงกับ Wireshark ในตัว เพียงแค่คลิกขวาที่เส้นสายเคเบิลที่ต้องการ แล้วเลือก "Start Capture" โปรแกรม Wireshark จะเปิดขึ้นมาแสดงแพ็กเก็ตสดที่วิ่งผ่านสายเส้นนั้นทันที', 'คลิกขวาที่สาย ➔ Start Capture ➔ Wireshark เปิดขึ้นมาอัตโนมัติ', 5, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('6e3f7ca6-b56c-40cf-b6a4-c613cecc131b', 'tools:03-wireshark:fc01', 11, 'e0a4cdec-9071-4a41-bc6a-0aa782e85680', 'หน้าต่าง 3 ช่องหลัก (Three Panes) ของโปรแกรม Wireshark มีอะไรบ้างและแสดงข้อมูลอะไร?', '1. Top Pane (Packet List): รายการแพ็กเก็ตเรียงตามเวลา พร้อมสีเตือน
2. Middle Pane (Packet Details): ผ่าโครงสร้าง Header ตามชั้น OSI (Ethernet -> IP -> TCP/UDP -> App)
3. Bottom Pane (Packet Bytes): ข้อมูลดิบแบบ Hex Dump และ ASCII', 'Packet List, Packet Details (OSI Layers), Packet Bytes (Hex Dump)', 1, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('0566fc6c-0d26-43c7-a4df-004b26d91381', 'tools:03-wireshark:fc02', 11, 'e0a4cdec-9071-4a41-bc6a-0aa782e85680', 'Capture Filter กับ Display Filter ใน Wireshark ต่างกันอย่างไร?', '- Capture Filter (BPF): กรองก่อนบันทึกจริง ไม่ตรงเงื่อนไขจะทิ้งทันที ประหยัด RAM/Disk (เช่น "port 80")
- Display Filter: ดักจับข้อมูลทั้งหมดมาก่อน แล้วค่อยพิมพ์ซ่อน/แสดงบนหน้าจอ เปลี่ยนมุมมองได้ตลอดข้อมูลดิบไม่หาย (เช่น "tcp.flags.reset == 1")', 'กรองก่อนจับทิ้งทันที (BPF) vs ดักจับหมดแล้วค่อยกรองมุมมองหน้าจอ', 2, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('a9d2f8e5-a691-401c-9dba-8ad983370927', 'tools:03-wireshark:fc03', 11, 'e0a4cdec-9071-4a41-bc6a-0aa782e85680', 'Display Filter สำหรับกรองหาแพ็กเก็ตที่ถูกส่งซ้ำ (Retransmission) และการตัดการเชื่อมต่อ (TCP Reset) คืออะไร?', '- แพ็กเก็ตส่งซ้ำ (Packet Loss): tcp.analysis.retransmission
- ตัดการเชื่อมต่อ / Refused: tcp.flags.reset == 1', 'tcp.analysis.retransmission และ tcp.flags.reset == 1', 3, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('0cfe80a3-135c-4b51-bd3b-75a5f77c484a', 'tools:03-wireshark:fc04', 11, 'e0a4cdec-9071-4a41-bc6a-0aa782e85680', 'Follow TCP Stream ใน Wireshark มีหน้าที่อะไร?', 'รวบรวมแพ็กเก็ตทั้งหมดของเซสชัน TCP นั้นมาต่อกันเป็นบทสนทนาต่อเนื่องในหน้าต่างเดียว ทำให้อ่านข้อความที่คุยกันได้ง่าย (ข้อความสีแดง = ฝั่งส่ง Client, ข้อความสีน้ำเงิน = ฝั่งตอบ Server)', 'ประกอบข้อความแชต/HTTP ระหว่าง Client (สีแดง) และ Server (สีน้ำเงิน)', 4, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('94ee5873-f6e0-49c1-a912-91b2190f139b', 'tools:03-wireshark:fc05', 11, 'e0a4cdec-9071-4a41-bc6a-0aa782e85680', 'TCP ZeroWindow หมายถึงอะไรในมุมมองการวิเคราะห์ปัญหาเครือข่าย?', 'หมายถึง บัฟเฟอร์ขารับ (Receive Buffer) ของเครื่องปลายทางเต็ม ไม่สามารถรับข้อมูลเพิ่มได้ จึงบอกให้เครื่องต้นทางหยุดส่งข้อมูลชั่วคราว มักสะท้อนว่าเครื่องปลายทาง CPU สูง หรือดิสก์เขียนข้อมูลไม่ทัน', 'Receive Buffer ของเครื่องปลายทางเต็ม สั่งต้นทางหยุดส่งชั่วคราว', 5, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('2e05c459-9791-491f-959d-a5a71246aef1', 'tools:04-nmap-iperf:fc01', 11, '3b325ae8-b7e2-4b0a-b86d-8e2bef22bd87', 'ผลลัพธ์สถานะพอร์ต "open", "closed" และ "filtered" ของ Nmap ต่างกันอย่างไร?', '- open: พอร์ตเปิด มีแอปพลิเคชันดักฟังและรับการเชื่อมต่อ
- closed: แพ็กเก็ตถึงเครื่อง แต่ไม่มีแอปพลิเคชันเปิดฟัง (เครื่องตอบ TCP RST กลับมา)
- filtered: แพ็กเก็ตถูกบล็อกโดย Firewall หรือ ACL กลางทาง ไม่มีทางตอบกลับ', 'open=มีคนฟัง, closed=ไม่มีคนฟังแต่เครื่องตอบ RST, filtered=โดน Firewall บล็อก', 1, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('8c0000be-4bee-4312-89a0-506ed3d5c820', 'tools:04-nmap-iperf:fc02', 11, '3b325ae8-b7e2-4b0a-b86d-8e2bef22bd87', 'คำสั่ง Nmap สำหรับสแกนแบบ Stealth SYN Scan และสแกน Service Version คืออะไร?', '- Stealth SYN Scan: sudo nmap -sS <เป้าหมาย>
- Service Version Detection: nmap -sV <เป้าหมาย>
- ตรวจระบบปฏิบัติการ (OS): sudo nmap -O <เป้าหมาย>', '-sS (SYN scan), -sV (Version), -O (OS detection)', 2, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('adfd87af-e898-455b-aa86-b936cad787ee', 'tools:04-nmap-iperf:fc03', 11, '3b325ae8-b7e2-4b0a-b86d-8e2bef22bd87', 'ทำไม iPerf3 ถึงวัดความเร็วท่อเครือข่ายได้แม่นยำกว่าการก๊อปปี้ไฟล์?', 'เพราะ iPerf3 สร้างข้อมูลสังเคราะห์บนหน่วยความจำ RAM โดยตรงแล้วยิงอัดผ่านท่อเน็ตเวิร์ก จึงไม่ติดคอขวดที่ความเร็วการอ่านเขียนของฮาร์ดดิสก์ (Disk I/O) ทำให้เห็นสมรรถนะจริงของเครือข่าย 100%', 'สร้างทราฟฟิกบน RAM โดยตรง ไม่ติดคอขวด Disk I/O', 3, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('cc80026d-3518-49c7-a349-c5c5e5e16032', 'tools:04-nmap-iperf:fc04', 11, '3b325ae8-b7e2-4b0a-b86d-8e2bef22bd87', 'คำสั่งรัน iPerf3 ฝั่ง Server และฝั่ง Client ในโหมด TCP ปกติ กับโหมด UDP คืออะไร?', '- ฝั่ง Server: iperf3 -s
- ฝั่ง Client (TCP): iperf3 -c <server_ip>
- ฝั่ง Client (UDP วัด Jitter/Loss): iperf3 -c <server_ip> -u -b 100M', 'iperf3 -s (server) และ iperf3 -c <ip> (client) เพิ่ม -u สำหรับ UDP', 4, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('49041708-a4f3-4060-a5b6-db546120f26a', 'tools:04-nmap-iperf:fc05', 11, '3b325ae8-b7e2-4b0a-b86d-8e2bef22bd87', 'WinMTR (หรือ MTR) รวมความสามารถของคำสั่งใดเข้าด้วยกัน และช่วยวิเคราะห์ปัญหาอย่างไร?', 'รวม "ping" และ "traceroute" เข้าด้วยกัน โดยส่งแพ็กเก็ตต่อเนื่องไปยังทุก Hop บนเส้นทาง ทำให้เห็นค่า Loss % และ Latency (Avg/Worst) ของแต่ละช่วงชุมสายได้แบบเรียลไทม์', 'ping + traceroute ต่อเนื่อง เห็น Loss % และ Latency แต่ละ Hop', 5, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('0ccc7841-9cb5-4c85-bbec-60fa17092db0', 'tools:05-mobaxterm:fc01', 11, '57df0d37-2e95-4e42-9185-f2ba49596293', 'จุดเด่นหลักของโปรแกรม MobaXterm เมื่อเทียบกับ PuTTY คืออะไร?', '1. มี Embedded SFTP Browser ฝังตัวด้านซ้าย ลากวางไฟล์และแก้ Text ได้ทันที
2. รองรับ Multi-Execution พิมพ์ครั้งเดียวรันทุกแท็บพร้อมกัน
3. มี X11 Server ในตัว เปิดโปรแกรม GUI ของ Linux บน Windows ได้
4. รองรับ Tabbed interface จัดการหลายเซสชันสะดวก', 'SFTP ในตัว, Multi-Execution รันทุกแท็บ, X11 Server, แท็บหลายหน้าต่าง', 1, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('ee81d453-7b77-4597-9af2-67325da89d81', 'tools:05-mobaxterm:fc02', 11, '57df0d37-2e95-4e42-9185-f2ba49596293', 'Multi-Execution Mode ใน MobaXterm ใช้ทำงานอย่างไร?', 'เปิดเซสชัน SSH หลายเครื่องพร้อมกัน แล้วกดปุ่ม MultiExec ข้อความหรือคำสั่งทุกตัวที่พิมพ์จะถูกส่งไปประมวลผลบนทุกแท็บในวินาทีเดียวกัน', 'พิมพ์ครั้งเดียว คำสั่งส่งไปรันบนทุกเซิร์ฟเวอร์พร้อมกัน', 2, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('bc554664-986c-4272-b4d4-49acc6303b5c', 'tools:05-mobaxterm:fc03', 11, '57df0d37-2e95-4e42-9185-f2ba49596293', 'X11 Forwarding ใน SSH คืออะไร และช่วยงานอะไร?', 'การส่งผ่านหน้าต่างกราฟิก (GUI) ของโปรแกรมที่รันบน Linux Server ข้ามมาแสดงผลบนหน้าจอ Windows ของเครื่องลูกข่าย เช่น เปิดตัวติดตั้ง Oracle หรือโปรแกรมจำลอง', 'ส่งหน้าต่างโปรแกรม GUI ของ Linux มาเปิดบน Windows ผ่าน SSH', 3, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('010324d3-7a5a-41af-825d-b3a11ac4bce2', 'tools:05-mobaxterm:fc04', 11, '57df0d37-2e95-4e42-9185-f2ba49596293', 'ค่าคอนฟิก Serial พอร์ตสำหรับต่อสาย Console เข้าสวิตช์หน้าตู้แร็คตามมาตรฐานสากลคืออะไร?', 'มาตรฐาน "9600-8-N-1":
- Speed (Baud): 9600
- Data bits: 8
- Parity: None
- Stop bits: 1
- Flow Control: None (ตรวจหมายเลข COM Port ได้จาก Device Manager)', '9600-8-N-1 (Flow Control = None)', 4, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');
INSERT INTO public.flashcards VALUES ('fc062af8-8626-4c80-b370-c590968ed79e', 'tools:05-mobaxterm:fc05', 11, '57df0d37-2e95-4e42-9185-f2ba49596293', 'WinSCP ใช้โปรโตคอลและพอร์ตใดในการโอนย้ายไฟล์ความปลอดภัยสูง?', 'ใช้โปรโตคอล SFTP (SSH File Transfer Protocol) ผ่านพอร์ตมาตรฐาน TCP 22 มีฟังก์ชัน Resume และ Directory Synchronization', 'SFTP ผ่านพอร์ต TCP 22', 5, '2026-11-12 08:26:05.561698+00', '2026-11-12 08:26:05.561698+00');


--
-- Data for Name: lesson_progress; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.lesson_progress VALUES ('d610df66-7525-44ca-9e83-02b4749afe01', '2026-11-05 03:49:48.215665+00');


--
-- Data for Name: quiz_sessions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.quiz_sessions VALUES ('7571bf0c-0ae7-4810-9108-51213de7c566', 1, 'all', 5, 3, 60.00, 178, true, '2026-11-04 07:17:42.645449+00', '2026-11-04 07:20:41.409499+00');
INSERT INTO public.quiz_sessions VALUES ('6674bd76-8b42-4af3-89c8-fbf7936ab56f', NULL, 'all', 5, 0, 0.00, 0, false, '2026-11-04 10:43:30.412302+00', NULL);
INSERT INTO public.quiz_sessions VALUES ('f5c75795-3eb2-4381-ad9f-55282b74d00d', NULL, 'all', 5, 0, 0.00, 0, false, '2026-11-04 10:43:39.672117+00', NULL);


--
-- Data for Name: quiz_session_answers; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.quiz_session_answers VALUES ('a3e368c3-e706-4a41-b116-5441f455c133', '7571bf0c-0ae7-4810-9108-51213de7c566', '1ac01c44-5005-4ecb-88fc-c771eb4dae59', NULL, true, '2026-11-04 07:20:41.409499+00');
INSERT INTO public.quiz_session_answers VALUES ('ac35cba6-ce27-4c0e-94b2-9116f40d3ede', '7571bf0c-0ae7-4810-9108-51213de7c566', '1fabb88c-d4d0-4b99-b096-f544592a7eae', NULL, true, '2026-11-04 07:20:41.409499+00');
INSERT INTO public.quiz_session_answers VALUES ('3420d263-0ff4-46a7-be38-760c234ac7de', '7571bf0c-0ae7-4810-9108-51213de7c566', '26fe4415-b506-49a7-90b7-1aff3eeabb25', NULL, false, '2026-11-04 07:20:41.409499+00');
INSERT INTO public.quiz_session_answers VALUES ('30ee2422-531f-42cd-9ff1-346dca871020', '7571bf0c-0ae7-4810-9108-51213de7c566', 'a2110b46-0e41-4ae6-898e-582052248f0b', NULL, true, '2026-11-04 07:20:41.409499+00');
INSERT INTO public.quiz_session_answers VALUES ('6f77e269-652a-4250-8ebd-eaddca549553', '7571bf0c-0ae7-4810-9108-51213de7c566', 'd18c78fa-edc9-4d07-bcee-55e19d3afd37', NULL, false, '2026-11-04 07:20:41.409499+00');


--
-- Data for Name: study_activity; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.study_activity VALUES ('361ec8ba-a717-4315-afb0-f8573722b1ac', 'lesson', 'b1a10001-0000-0000-0000-000000000001', '2026-11-04', '2026-11-04 10:41:53.044441+00');
INSERT INTO public.study_activity VALUES ('bc655e2d-7f4c-44cb-bf8e-b3e2a9157363', 'flashcard', 'd1a10001-0000-0000-0000-000000000001', '2026-11-04', '2026-11-04 13:06:34.69043+00');
INSERT INTO public.study_activity VALUES ('d6027f00-54d5-464d-ba47-572878ad091e', 'lesson', 'd610df66-7525-44ca-9e83-02b4749afe01', '2026-11-05', '2026-11-05 03:49:48.222839+00');


--
-- Name: topics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.topics_id_seq', 11, true);


--
-- PostgreSQL database dump complete
--


