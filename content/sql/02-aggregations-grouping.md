---
slug: sql-aggregations-grouping
title: วิเคราะห์สถิติและเหตุการณ์ผิดปกติด้วย GROUP BY และ HAVING
summary: เข้าใจฟังก์ชัน Aggregate, ความต่างระหว่าง WHERE vs HAVING, การจัดกลุ่มเวลาด้วย DATE_TRUNC และสูตร Query วิเคราะห์ Log
read_time_minutes: 8
difficulty: intermediate
display_order: 2
---

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
WHERE action = 'LOGIN_FAILED'
  AND created_at >= NOW() - INTERVAL '15 minutes'
GROUP BY ip_address
HAVING COUNT(*) >= 5
ORDER BY failed_attempts DESC;
```

### 3) การสรุปยอดตามช่วงเวลาด้วย `DATE_TRUNC` ใน PostgreSQL
```sql
-- นับสถิติคำสั่งซื้อแยกตามชั่วโมง
SELECT 
    DATE_TRUNC('hour', created_at) AS log_hour,
    COUNT(*) AS order_count
FROM orders
WHERE created_at >= NOW() - INTERVAL '24 hours'
GROUP BY DATE_TRUNC('hour', created_at)
ORDER BY log_hour ASC;
```
