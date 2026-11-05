---
slug: network-routing-latency
title: วิเคราะห์เส้นทางและ Latency ด้วย ping, traceroute และ mtr
summary: เข้าใจโปรโตคอล ICMP, การอ่านผล Packet Loss, วิธีแกะรอยปัญหาเครือข่ายด้วย traceroute และการใช้ mtr แบบมืออาชีพ
read_time_minutes: 8
difficulty: beginner
display_order: 3
---

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
