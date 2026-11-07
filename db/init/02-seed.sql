-- ====================================================================
-- Comprehensive Initial Seed Data for Support Knowledge Review
-- Core Topics: Linux, Network, SQL + Extended Topics
-- ====================================================================

-- --------------------------------------------------------------------
-- 1. TOPICS
-- --------------------------------------------------------------------
INSERT INTO topics (id, slug, title, description, icon, color, display_order) VALUES
(1, 'linux', 'Linux Administration', 'คำสั่งพื้นฐาน, การจัดการสิทธิ์ไฟล์, Process, Service systemctl และการวิเคราะห์ Log', 'Terminal', 'from-amber-500 to-orange-600', 1),
(2, 'network', 'Network Troubleshooting', 'TCP/IP, IP/Subnet, DNS, Routing, Port, Firewall และเครื่องมือวิเคราะห์เครือข่าย', 'Network', 'from-blue-500 to-cyan-600', 2),
(3, 'sql', 'SQL & Database Essentials', 'PostgreSQL Query, JOIN, Aggregations, Index, Performance และการตรวจสอบปัญหา DB', 'Database', 'from-emerald-500 to-teal-600', 3),
(4, 'web-api', 'Web & HTTP/API', 'HTTP Status Codes, Headers, REST API, curl, SSL/TLS Handshake และ Web Server', 'Globe', 'from-purple-500 to-indigo-600', 4),
(5, 'docker', 'Docker & Containers', 'Docker Command, Container Lifecycle, Log, Networking และการแก้ปัญหา Container ล่ม', 'Container', 'from-sky-500 to-blue-600', 5),
(6, 'troubleshooting', 'Incident & Troubleshooting', 'ขั้นตอนวิเคราะห์ Root Cause, วิธีการไล่ปัญหาอย่างเป็นระบบ (Methodology) และ ITIL', 'Wrench', 'from-rose-500 to-pink-600', 6)
ON CONFLICT (slug) DO UPDATE 
SET title = EXCLUDED.title, description = EXCLUDED.description, icon = EXCLUDED.icon;

-- --------------------------------------------------------------------
-- 2. LESSONS (Core Topics: Linux, Network, SQL)
-- --------------------------------------------------------------------

-- Linux Lesson 1: Permissions
INSERT INTO lessons (id, topic_id, slug, title, summary, read_time_minutes, difficulty, display_order, content_md) VALUES
('b1a10001-0000-0000-0000-000000000001', 1, 'linux-permissions', 'การจัดการสิทธิ์และ Permission ไฟล์ (chmod, chown, umask)', 
'เจาะลึกระบบสิทธิ์ rwx บน Linux การคำนวณเลข Octal และกรณีศึกษาที่พบบ่อยในงาน Support', 7, 'beginner', 1, 
'# การจัดการสิทธิ์ไฟล์และโฟลเดอร์บน Linux

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

> **Support Tip**: สิทธิ์ `x` (Execute) บนโฟลเดอร์หมายถึง "สิทธิ์ในการ cd เข้าไปข้างใน" หากโฟลเดอร์มีแค่ `r` แต่อยากเปิดอ่านไฟล์ข้างใน ระบบจะแจ้ง *Permission Denied* ทันที')
ON CONFLICT (topic_id, slug) DO UPDATE SET content_md = EXCLUDED.content_md, summary = EXCLUDED.summary;

-- Linux Lesson 2: Services & Logs
INSERT INTO lessons (id, topic_id, slug, title, summary, read_time_minutes, difficulty, display_order, content_md) VALUES
('b1a10001-0000-0000-0000-000000000002', 1, 'linux-services-and-systemctl', 'การจัดการ Service ด้วย systemctl และสืบค้น Log ด้วย journalctl', 
'คู่มือการสั่งการ Systemd Services การตรวจสอบสถานะ Failed และการกรอง System Log เมื่อระบบมีปัญหา', 6, 'beginner', 2, 
'# การจัดการ Systemd Service และการวิเคราะห์ Log

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

> **Support Tip**: หากรัน `systemctl restart nginx` แล้วแจ้งเตือนว่า "Job for nginx.service failed" ให้ทดสอบคอนฟิกด้วย `nginx -t` ทันที มักเกิดจากเครื่องหมายเซมิโคลอน `;` หาย หรือพอร์ตชน')
ON CONFLICT (topic_id, slug) DO UPDATE SET content_md = EXCLUDED.content_md, summary = EXCLUDED.summary;

-- Linux Lesson 3: Process & Resource Monitoring
INSERT INTO lessons (id, topic_id, slug, title, summary, read_time_minutes, difficulty, display_order, content_md) VALUES
('b1a10001-0000-0000-0000-000000000005', 1, 'linux-process-and-resources', 'การตรวจวัด CPU, RAM, Disk และจัดการ Process (ps, top, kill, df, free)', 
'วิธีวิเคราะห์เมื่อ Server อืด Disk เต็ม หรือแอปพลิเคชันเกิด Zombie / Deadlock Process', 8, 'intermediate', 3, 
'# การตรวจสอบ Process และ System Resources

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
หากลบไฟล์ Log ขนาด 50GB ไปแล้วแต่ `df -h` ยังฟ้องว่าเต็ม 100% มักเกิดจาก **โปรแกรมยังคงเปิดไฟล์นั้นค้างอยู่ (Held open)** ให้รัน `lsof | grep deleted` เพื่อหาว่า Process ไหนถือไฟล์อยู่ แล้วสั่ง reload หรือ restart Service นั้น')
ON CONFLICT (topic_id, slug) DO UPDATE SET content_md = EXCLUDED.content_md, summary = EXCLUDED.summary;

-- Network Lesson 1: Troubleshooting Tools
INSERT INTO lessons (id, topic_id, slug, title, summary, read_time_minutes, difficulty, display_order, content_md) VALUES
('b1a10001-0000-0000-0000-000000000003', 2, 'network-troubleshooting-tools', 'เครื่องมือวิเคราะห์ปัญหา Network สำหรับสาย Support', 
'ลำดับการทดสอบเชื่อมต่อตั้งแต่ Layer 3 ถึง Layer 7 ด้วย ping, traceroute, ss, curl และ nslookup', 8, 'intermediate', 1, 
'# เครื่องมือวิเคราะห์ปัญหา Network สำหรับสาย Support

เมื่อลูกค้าหรือ Developer แจ้งว่า **"เชื่อมต่อ Server ไม่ได้"** เรามีลำดับการตัดปัญหา (Troubleshooting Workflow) ดังนี้:

---

## 1. ขั้นตอนการไล่ปัญหา (Step-by-Step)
1. **Layer 3 (IP/ICMP)**: `ping 8.8.8.8` หรือ `ping api.example.com`
   - เช็คว่า Gateway ตอบสนองไหม และ DNS ทำงานแปลง IP ได้หรือไม่
2. **Layer 3/4 Path (Routing)**: `traceroute -n 1.1.1.1` หรือ `mtr 1.1.1.1`
   - เช็คว่าเส้นทาง Drop หรือ Time out ที่ Hop ไหน
3. **Layer 4 (Transport / Port)**:
   - ทดสอบต่อพอร์ตปลายทาง: `nc -zv 10.0.0.5 443` หรือ `telnet 10.0.0.5 443`
   - ตรวจสอบพอร์ตในเครื่องเราว่ากำลัง LISTEN อยู่ไหม: `ss -tulpn | grep :80`
4. **Layer 7 (Application)**:
   - ทดสอบ HTTP Response: `curl -Iv https://api.example.com/health`

---

## 2. เปรียบเทียบ Error ยอดนิยม
- **Connection Refused**: แพ็กเก็ตไปถึงปลายทาง แต่ที่ปลายทาง**ไม่มีโปรแกรมเปิดฟังพอร์ตนั้นอยู่** หรือถูก Local Firewall (iptables/nftables) ปฏิเสธ
- **Connection Timed Out**: แพ็กเก็ตส่งไปแล้วไม่มีการตอบกลับ มักเกิดจาก **Network Firewall / Security Group ดรอปแพ็กเก็ตเงียบๆ** หรือ routing ขาด')
ON CONFLICT (topic_id, slug) DO UPDATE SET content_md = EXCLUDED.content_md, summary = EXCLUDED.summary;

-- Network Lesson 2: DNS & Subnetting
INSERT INTO lessons (id, topic_id, slug, title, summary, read_time_minutes, difficulty, display_order, content_md) VALUES
('b1a10001-0000-0000-0000-000000000006', 2, 'network-ip-subnetting-dns', 'ทำความเข้าใจ IP, Subnet Mask, Gateway และกระบวนการ DNS', 
'คำนวณ Subnet CIDR (/24, /28) และเทคนิคเจาะลึกปัญหา DNS ด้วย dig และ nslookup', 7, 'beginner', 2, 
'# IP Address, Subnetting และการสืบค้น DNS

ระบบเครือข่ายพื้นฐานที่สาย Support ต้องแม่นยำเพื่อคุยกับทีม Network และ Cloud ได้อย่างถูกต้อง

---

## 1. การคำนวณ Subnet CIDR ยอดนิยม
- `/24` (Subnet Mask `255.255.255.0`): มีทั้งหมด 256 IP ใช้งานได้จริง **254 IP** (หัก Network IP และ Broadcast IP)
- `/28` (Subnet Mask `255.255.255.240`): มีทั้งหมด 16 IP ใช้งานได้จริง **14 IP** (มักใช้ใน VPC Subnet ขนาดเล็ก)
- `/30` (Subnet Mask `255.255.255.252`): มี 4 IP ใช้งานได้จริง **2 IP** (ใช้สำหรับ Point-to-Point link ระหว่างเราเตอร์ 2 ตัว)

---

## 2. ลำดับการ Resolve โดเมนของระบบ (DNS Resolution)
เมื่อเครื่องพยายามเรียก `api.internal.company`:
1. ตรวจสอบไฟล์ Local Hosts ก่อน (`/etc/hosts` บน Linux หรือ `C:\Windows\System32\drivers\etc\hosts`)
2. ตรวจสอบ DNS Cache ในเครื่อง
3. ส่งคำขอไปยัง DNS Nameserver ที่ตั้งค่าไว้ใน `/etc/resolv.conf`

---

## 3. คำสั่งสืบค้น DNS
```bash
# สืบค้น A Record ผ่าน DNS เริ่มต้นของระบบ
nslookup api.example.com

# บังคับสืบค้นผ่าน Google DNS (8.8.8.8) โดยตรงเพื่อตรวจว่า Record อัปเดตหรือยัง
dig @8.8.8.8 api.example.com A +short

# ตรวจสอบ MX Record (Mail Server)
dig example.com MX +short
```')
ON CONFLICT (topic_id, slug) DO UPDATE SET content_md = EXCLUDED.content_md, summary = EXCLUDED.summary;

-- SQL Lesson 1: Joins
INSERT INTO lessons (id, topic_id, slug, title, summary, read_time_minutes, difficulty, display_order, content_md) VALUES
('b1a10001-0000-0000-0000-000000000004', 3, 'sql-joins-and-relationships', 'Master รูปแบบ SQL JOIN และการประยุกต์ใช้งานจริง', 
'ทำความเข้าใจ INNER, LEFT, RIGHT, FULL OUTER JOIN และกรณีศึกษาดึงข้อมูลในฐานข้อมูล Support', 7, 'beginner', 1, 
'# ทำความเข้าใจ SQL JOIN และการเชื่อมโยงข้อมูล

ในฐานข้อมูลเชิงสัมพันธ์ (Relational DB) เช่น PostgreSQL ข้อมูลถูกแยกเก็บในหลายตารางเพื่อ Normalization การดึงข้อมูลที่มีความเกี่ยวข้องกันจำเป็นต้องใช้ **JOIN**

---

## 1. ประเภทของ JOIN
- **INNER JOIN**: ดึงเฉพาะแถวที่เงื่อนไขตรงกันทั้ง 2 ตารางเท่านั้น
- **LEFT JOIN (LEFT OUTER JOIN)**: ดึงข้อมูลจากตารางฝั่งซ้ายทั้งหมด แม้ฝั่งขวาจะไม่มีข้อมูลตรงกัน (ค่าฝั่งขวาจะเป็น `NULL`)
- **RIGHT JOIN**: ดึงข้อมูลจากตารางฝั่งขวาทั้งหมด
- **FULL OUTER JOIN**: ดึงข้อมูลของทั้งสองตาราง หากไม่มีคู่ของอีกฝั่งจะขึ้นเป็น `NULL`

---

## 2. ตัวอย่างคำสั่งที่พบบ่อยในงาน Support
```sql
-- ค้นหาคำถามทั้งหมด พร้อมชื่อหมวดหมู่ แม้บางคำถามจะยังไม่ได้ผูกหมวด
SELECT 
    q.id,
    q.question_text,
    COALESCE(t.title, ''Unassigned'') AS topic_title
FROM questions q
LEFT JOIN topics t ON q.topic_id = t.id;

-- ค้นหาหัวข้อ (Topics) ที่ยังไม่มีคำถามเลยแม้แต่ข้อเดียว (Anti-join)
SELECT t.id, t.title
FROM topics t
LEFT JOIN questions q ON t.id = q.topic_id
WHERE q.id IS NULL;
```

> **Support Tip**: เมื่อ Query มีข้อมูลนับแสนแถวแล้วช้าลง ให้ตรวจสอบว่าคอลัมน์ที่นำมาใช้ในเงื่อนไข `ON t.id = q.topic_id` มีการสร้าง **INDEX** ไว้แล้วหรือไม่')
ON CONFLICT (topic_id, slug) DO UPDATE SET content_md = EXCLUDED.content_md, summary = EXCLUDED.summary;

-- SQL Lesson 2: Indexes & Performance
INSERT INTO lessons (id, topic_id, slug, title, summary, read_time_minutes, difficulty, display_order, content_md) VALUES
('b1a10001-0000-0000-0000-000000000007', 3, 'sql-indexes-and-performance', 'การจูน Index และอ่าน EXPLAIN ANALYZE เพื่อแก้ปัญหา Database ช้า', 
'ทำความเข้าใจ Sequential Scan vs Index Scan และแนวทางการสร้าง B-Tree Index ที่ถูกต้อง', 9, 'intermediate', 2, 
'# SQL Index และการวิเคราะห์ Query Performance

ปัญหาอันดับหนึ่งของ Database บน Production คือ **Slow Query** ซึ่งดึง CPU และ I/O ของ Database Server จนค้าง

---

## 1. Index ทำงานอย่างไร?
Index เปรียบเสมือนดัชนีท้ายเล่มของหนังสือ หากไม่มี Index เมื่อเราสั่ง `WHERE customer_id = 100` ฐานข้อมูลจะต้องอ่านข้อมูลทีละแถวตั้งแต่แถวแรกจนถึงแถวสุดท้าย เรียกว่า **Sequential Scan (Full Table Scan)**

เมื่อมี **B-Tree Index** ระบบจะค้นหาแบบ Binary Search ด้วยความเร็วระดับ $O(\log N)$

---

## 2. การสร้าง Index ใน PostgreSQL
```sql
-- สร้าง Index พื้นฐาน
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- สร้าง Composite Index (เมื่อมี WHERE หลายเงื่อนไขร่วมกัน)
CREATE INDEX idx_orders_cust_status ON orders(customer_id, status);
```

---

## 3. การอ่านผล `EXPLAIN ANALYZE`
```sql
EXPLAIN ANALYZE 
SELECT * FROM orders 
WHERE customer_id = 5020;
```
- **Seq Scan on orders**: แสดงว่า Query นี้ไม่ได้ใช้ Index (อาจยังไม่มี Index หรือตารางมีขนาดเล็กมากจน Engine มองว่า Scan ตรงไวกว่า)
- **Index Scan using idx_orders_customer_id**: ใช้ Index ในการดึงทั้งตัวชี้ตำแหน่งและอ่านข้อมูลจากตาราง
- **Index Only Scan**: ดีที่สุด! คอลัมน์ทั้งหมดที่ต้องการอยู่ใน Index อยู่แล้ว ไม่ต้องเข้าถึงตารางหลักเลย
- **Execution Time**: เวลาที่ใช้รัน Query จริงในหน่วย millisecond')
ON CONFLICT (topic_id, slug) DO UPDATE SET content_md = EXCLUDED.content_md, summary = EXCLUDED.summary;

-- --------------------------------------------------------------------
-- 3. QUESTIONS & CHOICES (มี seed_key ป้องกันข้อมูลซ้ำ)
-- --------------------------------------------------------------------

-- Linux Question 1
INSERT INTO questions (id, seed_key, topic_id, lesson_id, question_text, scenario_text, difficulty, question_type, explanation, tags) VALUES
('c1a10001-0000-0000-0000-000000000001', 'linux:permissions:q01', 1, 'b1a10001-0000-0000-0000-000000000001', 
'หากต้องการกำหนดสิทธิ์ไฟล์ `deploy.sh` ให้ "เจ้าของสามารถ อ่าน-เขียน-รันได้" ส่วน "กลุ่มและผู้อื่น อ่านและรันได้เท่านั้น" ต้องใช้คำสั่ง chmod ตัวเลขใด?',
NULL, 'easy', 'multiple_choice',
'คำนวณสิทธิ์ตามเลข Octal:
- Owner (rwx) = 4 + 2 + 1 = 7
- Group (r-x) = 4 + 0 + 1 = 5
- Others (r-x) = 4 + 0 + 1 = 5
ดังนั้นคำตอบคือ chmod 755 deploy.sh',
ARRAY['chmod', 'linux', 'permissions'])
ON CONFLICT (seed_key) DO UPDATE 
SET question_text = EXCLUDED.question_text, explanation = EXCLUDED.explanation, updated_at = CURRENT_TIMESTAMP;

DELETE FROM choices WHERE question_id = 'c1a10001-0000-0000-0000-000000000001';
INSERT INTO choices (question_id, choice_text, is_correct, display_order) VALUES
('c1a10001-0000-0000-0000-000000000001', 'chmod 755 deploy.sh', TRUE, 1),
('c1a10001-0000-0000-0000-000000000001', 'chmod 644 deploy.sh', FALSE, 2),
('c1a10001-0000-0000-0000-000000000001', 'chmod 777 deploy.sh', FALSE, 3),
('c1a10001-0000-0000-0000-000000000001', 'chmod 764 deploy.sh', FALSE, 4);

-- Linux Question 2 (Scenario)
INSERT INTO questions (id, seed_key, topic_id, lesson_id, question_text, scenario_text, difficulty, question_type, explanation, tags) VALUES
('c1a10001-0000-0000-0000-000000000002', 'linux:services:q02', 1, 'b1a10001-0000-0000-0000-000000000002',
'คุณได้รับแจ้งว่า Service เว็บ Nginx บน Production เกิด Crash สตาร์ทไม่ขึ้น และเมื่อรัน systemctl start nginx พบข้อความ "Job for nginx.service failed". ในฐานะ Support ขั้นตอนแรกที่ดีที่สุดในการตรวจสอบสาเหตุคืออะไร?',
'# systemctl start nginx
Job for nginx.service failed because the control process exited with error code.
See "systemctl status nginx.service" and "journalctl -xeu nginx.service" for details.',
'medium', 'scenario',
'เมื่อ Nginx สตาร์ทไม่ติด สาเหตุอันดับ 1 มักเกิดจาก Syntax ผิดพลาดในไฟล์ nginx.conf หรือพอร์ต 80/443 ชนกับโปรเซสอื่น การรัน `nginx -t` จะตรวจสอบความถูกต้องของ Configuration ทันที หรือใช้ `journalctl -xeu nginx.service` เพื่อดู Error ล่าสุด',
ARRAY['nginx', 'systemctl', 'journalctl', 'troubleshooting'])
ON CONFLICT (seed_key) DO UPDATE 
SET question_text = EXCLUDED.question_text, explanation = EXCLUDED.explanation, updated_at = CURRENT_TIMESTAMP;

DELETE FROM choices WHERE question_id = 'c1a10001-0000-0000-0000-000000000002';
INSERT INTO choices (question_id, choice_text, is_correct, display_order) VALUES
('c1a10001-0000-0000-0000-000000000002', 'รัน `nginx -t` เพื่อตรวจสอบ Syntax คอนฟิก และตรวจ `journalctl -xeu nginx.service`', TRUE, 1),
('c1a10001-0000-0000-0000-000000000002', 'รีบูตเซิร์ฟเวอร์ทันทีด้วยคำสั่ง `reboot`', FALSE, 2),
('c1a10001-0000-0000-0000-000000000002', 'ลบโฟลเดอร์ `/etc/nginx` แล้วติดตั้งใหม่', FALSE, 3),
('c1a10001-0000-0000-0000-000000000002', 'เปลี่ยนสิทธิ์ทั้งระบบเป็น `chmod 777 -R /`', FALSE, 4);

-- Linux Question 3 (Disk Full / lsof deleted)
INSERT INTO questions (id, seed_key, topic_id, lesson_id, question_text, scenario_text, difficulty, question_type, explanation, tags) VALUES
('c1a10001-0000-0000-0000-000000000006', 'linux:disk:q03', 1, 'b1a10001-0000-0000-0000-000000000005',
'เกิดปัญหา Disk /var เต็ม 100% คุณได้สั่งลบไฟล์ log ขนาด 50GB ด้วยคำสั่ง `rm /var/log/app.log` ไปแล้ว แต่เมื่อเช็คคำสั่ง `df -h` ปรากฏว่าพื้นที่ยังคงเต็ม 100% เหมือนเดิม สาเหตุเกิดจากอะไรและแก้ปัญหาอย่างไร?',
'# df -h /var
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda3       100G  100G     0 100% /var',
'hard', 'scenario',
'เมื่อรัน `rm` บน Linux ตัว Pointer ใน Directory จะถูกลบออก แต่หากยังมี Process (เช่น Java/Node.js) เปิดเขียนไฟล์นั้นค้างอยู่ (File descriptor open) พื้นที่จริงใน Disk จะยังไม่ถูกคืน (Held open) วิธีตรวจสอบคือใช้ `lsof +L1` หรือ `lsof | grep deleted` และทำการ reload/restart process นั้น หรือแทนที่จะใช้ `rm` ให้ใช้คำสั่งเคลียร์เนื้อหาไฟล์แทน เช่น `> /var/log/app.log` (truncate)',
ARRAY['linux', 'disk', 'lsof', 'storage'])
ON CONFLICT (seed_key) DO UPDATE 
SET question_text = EXCLUDED.question_text, explanation = EXCLUDED.explanation, updated_at = CURRENT_TIMESTAMP;

DELETE FROM choices WHERE question_id = 'c1a10001-0000-0000-0000-000000000006';
INSERT INTO choices (question_id, choice_text, is_correct, display_order) VALUES
('c1a10001-0000-0000-0000-000000000006', 'ยังมีโปรเซสเปิดไฟล์นั้นค้างอยู่ ให้รัน `lsof | grep deleted` และรีสตาร์ทโปรเซสนั้นเพื่อปล่อยพื้นที่', TRUE, 1),
('c1a10001-0000-0000-0000-000000000006', 'Linux ติดไวรัส Ransomware ต้องฟอร์แมตดิสก์', FALSE, 2),
('c1a10001-0000-0000-0000-000000000006', 'คำสั่ง rm ใช้งานไม่ได้บนไดรฟ์ประเภท ext4', FALSE, 3),
('c1a10001-0000-0000-0000-000000000006', 'ต้องรอครบ 24 ชั่วโมง Linux จึงจะรัน Garbage Collection', FALSE, 4);

-- Network Question 1
INSERT INTO questions (id, seed_key, topic_id, lesson_id, question_text, scenario_text, difficulty, question_type, explanation, tags) VALUES
('c1a10001-0000-0000-0000-000000000003', 'network:tools:q01', 2, 'b1a10001-0000-0000-0000-000000000003',
'เมื่อใช้คำสั่ง `curl -v http://192.168.1.50:8080` แล้วได้รับผลลัพธ์ว่า `curl: (7) Failed to connect to 192.168.1.50 port 8080: Connection refused` ข้อใดคือสาเหตุที่เป็นไปได้มากที่สุด?',
NULL, 'medium', 'multiple_choice',
'Connection Refused หมายความว่า แพ็กเก็ต TCP SYN เดินทางไปถึงโฮสต์ปลายทางเรียบร้อยแล้ว แต่โฮสต์ปลายทางตอบกลับด้วย TCP RST (Reset) ซึ่งแปลว่า "ไม่มี Process/Application ใดเปิดฟัง (Listening) อยู่ที่พอร์ต 8080" หรือถูกปฏิเสธโดย Local Firewall แบบ reject (ต่างจาก Timeout ที่แพ็กเก็ตโดนดรอปเงียบๆ)',
ARRAY['network', 'tcp', 'curl', 'ports'])
ON CONFLICT (seed_key) DO UPDATE 
SET question_text = EXCLUDED.question_text, explanation = EXCLUDED.explanation, updated_at = CURRENT_TIMESTAMP;

DELETE FROM choices WHERE question_id = 'c1a10001-0000-0000-0000-000000000003';
INSERT INTO choices (question_id, choice_text, is_correct, display_order) VALUES
('c1a10001-0000-0000-0000-000000000003', 'เครื่องปลายทางไม่ได้เปิดโปรแกรมหรือ Service รับการเชื่อมต่อที่พอร์ต 8080', TRUE, 1),
('c1a10001-0000-0000-0000-000000000003', 'สาย LAN ขาด หรือสัญญาณ Wi-Fi หลุด', FALSE, 2),
('c1a10001-0000-0000-0000-000000000003', 'Domain Name หมดอายุ', FALSE, 3),
('c1a10001-0000-0000-0000-000000000003', 'RAM ของเครื่องลูกข่ายไม่เพียงพอ', FALSE, 4);

-- Network Question 2 (502 Bad Gateway vs 504 Gateway Timeout)
INSERT INTO questions (id, seed_key, topic_id, lesson_id, question_text, scenario_text, difficulty, question_type, explanation, tags) VALUES
('c1a10001-0000-0000-0000-000000000007', 'network:http:q02', 2, NULL,
'ผู้ใช้แจ้งว่าเข้าเว็บแล้วพบหน้าขาวพร้อมข้อความ "HTTP 504 Gateway Timeout" จากมุมมองของ Reverse Proxy (เช่น Nginx หรือ Cloudflare) ปัญหานี้เกิดขึ้นจากอะไร?',
'# curl -I https://api.mycompany.com/checkout
HTTP/1.1 504 Gateway Timeout
Server: nginx/1.24.0',
'medium', 'multiple_choice',
'HTTP 504 Gateway Timeout หมายถึง ตัว Reverse Proxy สามารถเชื่อมต่อไปยัง Upstream / Backend Server ได้ แต่ Upstream ทำงานช้าเกินไปจนเกินเวลา timeout (เช่น `proxy_read_timeout`) ยังไม่ยอมส่ง Response กลับมา (ต่างจาก 502 Bad Gateway ที่ Upstream ตัดการเชื่อมต่อทันที หรือล่มไปแล้ว)',
ARRAY['http', 'nginx', 'status-codes', 'proxy'])
ON CONFLICT (seed_key) DO UPDATE 
SET question_text = EXCLUDED.question_text, explanation = EXCLUDED.explanation, updated_at = CURRENT_TIMESTAMP;

DELETE FROM choices WHERE question_id = 'c1a10001-0000-0000-0000-000000000007';
INSERT INTO choices (question_id, choice_text, is_correct, display_order) VALUES
('c1a10001-0000-0000-0000-000000000007', 'Backend / Upstream Server ทำงานช้าจนหมดเวลา timeout ไม่ยอมส่งคำตอบกลับมายัง Proxy', TRUE, 1),
('c1a10001-0000-0000-0000-000000000007', 'ผู้ใช้พิมพ์ URL ผิด หน้าเว็บไม่มีอยู่จริง', FALSE, 2),
('c1a10001-0000-0000-0000-000000000007', 'ผู้ใช้ใส่รหัสผ่านผิดระบบจึงไม่อนุญาต', FALSE, 3),
('c1a10001-0000-0000-0000-000000000007', 'ใบรับรอง SSL/TLS ของเว็บไซต์หมดอายุ', FALSE, 4);

-- SQL Question 1
INSERT INTO questions (id, seed_key, topic_id, lesson_id, question_text, scenario_text, difficulty, question_type, explanation, tags) VALUES
('c1a10001-0000-0000-0000-000000000004', 'sql:joins:q01', 3, 'b1a10001-0000-0000-0000-000000000004',
'คำสั่ง SQL ใดใช้สำหรับค้นหาข้อมูลพนักงานทุกคน พร้อมชื่อแผนก โดยต้องการแสดงพนักงานแม้ว่าจะยังไม่ได้ถูกจัดให้อยู่แผนกใดก็ตาม (Department เป็น NULL)?',
NULL, 'easy', 'multiple_choice',
'LEFT JOIN จะคงข้อมูลของตารางฝั่งซ้าย (employees) ไว้ทั้งหมด แม้จะไม่มีคู่ที่ตรงกันในตารางขวา (departments) ซึ่งคอลัมน์ของแผนกจะแสดงเป็นค่า NULL เหมาะสมกับโจทย์นี้',
ARRAY['sql', 'join', 'database'])
ON CONFLICT (seed_key) DO UPDATE 
SET question_text = EXCLUDED.question_text, explanation = EXCLUDED.explanation, updated_at = CURRENT_TIMESTAMP;

DELETE FROM choices WHERE question_id = 'c1a10001-0000-0000-0000-000000000004';
INSERT INTO choices (question_id, choice_text, is_correct, display_order) VALUES
('c1a10001-0000-0000-0000-000000000004', 'SELECT e.name, d.dept_name FROM employees e LEFT JOIN departments d ON e.dept_id = d.id', TRUE, 1),
('c1a10001-0000-0000-0000-000000000004', 'SELECT e.name, d.dept_name FROM employees e INNER JOIN departments d ON e.dept_id = d.id', FALSE, 2),
('c1a10001-0000-0000-0000-000000000004', 'SELECT e.name, d.dept_name FROM employees e RIGHT JOIN departments d ON e.dept_id = d.id', FALSE, 3),
('c1a10001-0000-0000-0000-000000000004', 'SELECT e.name, d.dept_name FROM employees e CROSS JOIN departments d', FALSE, 4);

-- SQL Question 2
INSERT INTO questions (id, seed_key, topic_id, lesson_id, question_text, scenario_text, difficulty, question_type, explanation, tags) VALUES
('c1a10001-0000-0000-0000-000000000005', 'sql:explain:q02', 3, 'b1a10001-0000-0000-0000-000000000007',
'ใน PostgreSQL เมื่อพบว่า Query `SELECT * FROM orders WHERE customer_id = 45000 AND status = ''PENDING''` ทำงานช้ามากบนตารางที่มี 10,000,000 แถว คำสั่งใดที่ช่วยแสดง Execution Plan เพื่อดูว่า Query ใช้วิธี Sequential Scan หรือ Index Scan?',
NULL, 'hard', 'multiple_choice',
'`EXPLAIN ANALYZE` เป็นคำสั่งสำคัญของ PostgreSQL ที่จะรัน Query จริงและรายงาน Query Planner Plan พร้อมเวลาที่ใช้จริงในแต่ละ Node (Cost, Actual Time, Rows, Index Scan vs Seq Scan)',
ARRAY['sql', 'postgresql', 'performance', 'explain'])
ON CONFLICT (seed_key) DO UPDATE 
SET question_text = EXCLUDED.question_text, explanation = EXCLUDED.explanation, updated_at = CURRENT_TIMESTAMP;

DELETE FROM choices WHERE question_id = 'c1a10001-0000-0000-0000-000000000005';
INSERT INTO choices (question_id, choice_text, is_correct, display_order) VALUES
('c1a10001-0000-0000-0000-000000000005', 'EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 45000 AND status = ''PENDING'';', TRUE, 1),
('c1a10001-0000-0000-0000-000000000005', 'OPTIMIZE TABLE orders;', FALSE, 2),
('c1a10001-0000-0000-0000-000000000005', 'SHOW PROFILE FOR QUERY 1;', FALSE, 3),
('c1a10001-0000-0000-0000-000000000005', 'REINDEX DATABASE postgres;', FALSE, 4);

-- --------------------------------------------------------------------
-- 4. FLASHCARDS (มี seed_key ป้องกันข้อมูลซ้ำ)
-- --------------------------------------------------------------------
INSERT INTO flashcards (id, seed_key, topic_id, lesson_id, front_text, back_text, hint, display_order) VALUES
('d1a10001-0000-0000-0000-000000000001', 'linux:fc:ss-listen', 1, 'b1a10001-0000-0000-0000-000000000001', 
 'คำสั่งตรวจสอบว่า Process ใดกำลังฟังพอร์ต (Listen) อยู่บน Linux', 
 'ss -tulpn หรือ netstat -tulpn\n\n-t: TCP\n-u: UDP\n-l: Listening\n-p: Show process/PID\n-n: Numeric port', 
 'จำตัวย่อ TULPN', 1),

('d1a10001-0000-0000-0000-000000000002', 'linux:fc:journalctl-follow', 1, 'b1a10001-0000-0000-0000-000000000002', 
 'คำสั่งติดตาม System Log ของ Service nginx แบบ Real-time', 
 'journalctl -u nginx -f', 
 'พารามิเตอร์ -f ย่อมาจาก follow', 2),

('d1a10001-0000-0000-0000-000000000003', 'linux:fc:df-h-inode', 1, 'b1a10001-0000-0000-0000-000000000005', 
 'คำสั่งดูพื้นที่ดิสก์ที่เหลืออยู่แบบ Human-Readable และตรวจ Inode', 
 'df -h  (ดูพื้นที่ GB/MB)\ndf -i  (ดูจำนวน Inode ที่เหลือ)', 
 'h ย่อมาจาก Human-readable, i ย่อมาจาก Inode', 3),

('d1a10001-0000-0000-0000-000000000004', 'network:fc:refused-vs-timeout', 2, 'b1a10001-0000-0000-0000-000000000003', 
 'ความแตกต่างระหว่าง Connection Refused กับ Connection Timed Out', 
 'Connection Refused: แพ็กเก็ตไปถึง แต่ปลายทางไม่มี Service เปิดฟัง หรือ Firewall ปฏิเสธ (TCP RST)\n\nConnection Timed Out: แพ็กเก็ตส่งไปแล้วไม่มีการตอบกลับ มักโดน Firewall ดรอปเงียบๆ หรือ Routing ขาด', 
 'Refused = ปลายทางปฏิเสธกลับมา, Timeout = รอจนหมดเวลา', 1),

('d1a10001-0000-0000-0000-000000000005', 'network:fc:well-known-ports', 2, 'b1a10001-0000-0000-0000-000000000006', 
 'Well-known Port: DNS, SSH, HTTPS, PostgreSQL', 
 'DNS: 53 (UDP/TCP)\nSSH: 22\nHTTPS: 443\nPostgreSQL: 5432', 
 'Postgres ลงท้ายด้วย 32', 2),

('d1a10001-0000-0000-0000-000000000006', 'sql:fc:where-vs-having', 3, 'b1a10001-0000-0000-0000-000000000004', 
 'ความแตกต่างระหว่าง WHERE กับ HAVING ใน SQL', 
 'WHERE: กรองข้อมูล "ก่อน" ทำการจัดกลุ่ม (Filter individual rows)\n\nHAVING: กรองข้อมูล "หลัง" จากจัดกลุ่มและคำนวณ Aggregate เช่น COUNT(), SUM() แล้ว', 
 'HAVING มักใช้คู่กับ GROUP BY', 1),

('d1a10001-0000-0000-0000-000000000007', 'sql:fc:explain-analyze', 3, 'b1a10001-0000-0000-0000-000000000007', 
 'คำสั่งดู Query Execution Plan และเวลาที่รันจริงใน PostgreSQL', 
 'EXPLAIN ANALYZE <sql_query>;', 
 'มีคีย์เวิร์ด 2 คำขึ้นต้น', 2)
ON CONFLICT (seed_key) DO UPDATE 
SET front_text = EXCLUDED.front_text, back_text = EXCLUDED.back_text, hint = EXCLUDED.hint, updated_at = CURRENT_TIMESTAMP;

-- Synchronize sequence
SELECT setval('topics_id_seq', (SELECT MAX(id) FROM topics));
