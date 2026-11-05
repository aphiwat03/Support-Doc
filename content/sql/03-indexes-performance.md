---
slug: sql-indexes-performance
title: การจูน Index, อ่าน EXPLAIN ANALYZE และจัดการ Slow Query
summary: ทำความเข้าใจ B-Tree Index, Sequential Scan vs Index Scan, ถอดรหัส EXPLAIN ANALYZE และคำสั่งปลดล็อกคิวรีที่ค้างด้วย pg_stat_activity
read_time_minutes: 9
difficulty: intermediate
display_order: 3
---

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
> Composite Index `(customer_id, status)` จะทำงานได้ก็ต่อเมื่อ Query มีเงื่อนไขของคอลัมน์แรก (`customer_id`) เสมอ (เรียกว่า Leftmost Prefix Rule) หาก Query ด้วย `WHERE status = 'PAID'` ตัวเดียว Engine จะไม่สามารถใช้ Index ตัวนี้ได้

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
WHERE state != 'idle'
  AND now() - query_start > INTERVAL '5 seconds'
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
