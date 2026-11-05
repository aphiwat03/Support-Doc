# คู่มือสถาปัตยกรรมและโครงสร้างโปรเจกต์ฉบับสมบูรณ์ (Project Architecture & Specification Guide)

เอกสารฉบับนี้รวบรวมโครงสร้างโดยรวมของระบบ **Support Knowledge Review Hub** ตั้งแต่การจัดวางโฟลเดอร์, การแบ่งพื้นที่หน้าจอ (Layout), ระบบธีมและฟอนต์ (Themes & Typography), การจัดหมวดหมู่เนื้อหา (Topic Space), โครงสร้างฐานข้อมูล Raw SQL ไปจนถึงขั้นตอนการเพิ่มเนื้อหาใหม่

---

## 1. ภาพรวมเทคโนโลยี (Tech Stack Summary)

| ส่วนระบบ | เทคโนโลยีที่ใช้ | รายละเอียดเพิ่มเติม |
|---|---|---|
| **Frontend Framework** | Next.js 16 (App Router) + React 19 | รองรับทั้ง Static และ Dynamic Rendering |
| **Styling & Theme** | Tailwind CSS v4 | Dark Tech Theme (`slate-950`) พร้อม Custom Typography |
| **State Management** | Zustand 5 | แยกเป็น `useAppStore` (UI/Bookmark) และ `useQuizStore` (ระบบสอบ) |
| **Markdown Engine** | `react-markdown` | Custom Component Parser รองรับ Code Block, Table และกฎการแสดงผลพิเศษ |
| **Icons** | `lucide-react` | ไอคอนสื่อความหมายสาย Technical Support |
| **Backend Framework** | NestJS 12 (ESM / NodeNext) | โครงสร้าง Modular แยกตาม Domain |
| **API Documentation** | Swagger / OpenAPI (`@nestjs/swagger`) | เปิดให้ทดสอบสดที่ `/api/docs` |
| **Database & Driver** | PostgreSQL 16 + `pg` (`node-postgres`) | **Native Raw SQL 100%** (ไม่ใช้ ORM) ผ่าน Connection Pool |
| **Infrastructure** | Docker & Docker Compose | รองรับทั้งการรันเฉพาะ DB และการรัน Full-stack Container |

---

## 2. โครงสร้างโฟลเดอร์โดยรวมของโปรเจกต์ (Directory Structure)

```text
d:\Projects\Support Applications\
├── content/                                # [พื้นที่เก็บเนื้อหาแบบ File-Based สำหรับ Seed เข้า DB]
│   ├── linux/
│   │   ├── _topic.json                     # ข้อมูลหมวดหมู่ (slug, title, icon, color, display_order)
│   │   ├── 01-permissions.md               # บทเรียน (Frontmatter + Markdown Body)
│   │   ├── 01-permissions.questions.json   # โจทย์คำถามประจำบท + ตัวเลือก + เฉลย + seed_key
│   │   └── 01-permissions.flashcards.json  # แฟลชการ์ดประจำบท + คำใบ้ + seed_key
│   ├── network/                            # (ขยายเพิ่มตามหมวดหมู่)
│   └── sql/
│
├── db/                                     # [โครงสร้างฐานข้อมูลและข้อมูลเริ่มต้นระดับ SQL]
│   └── init/
│       ├── 01-init.sql                     # Raw SQL DDL (Tables, Foreign Keys, CHECK, Partial/GIN Indexes)
│       └── 02-seed.sql                     # ข้อมูล Seed พื้นฐานพร้อม Natural Key (seed_key)
│
├── backend/                                # [NestJS Backend API Server - Port 4000]
│   ├── scripts/
│   │   ├── init-db.mjs                     # สคริปต์รัน 01-init.sql และ 02-seed.sql อัตโนมัติ
│   │   └── seed-content.mjs                # สคริปต์อ่านโฟลเดอร์ content/ แล้ว Upsert เข้า DB ใน 1 Transaction
│   ├── src/
│   │   ├── main.ts                         # ตั้งค่า Global Prefix (/api), CORS, ValidationPipe, Swagger (/api/docs)
│   │   ├── app.module.ts                   # Root Module
│   │   ├── database/                       # Global DatabaseModule (pg.Pool Connection & Query Wrapper)
│   │   ├── topics/                         # API หมวดหมู่วิชาชีพ (/api/topics)
│   │   ├── lessons/                        # API บทเรียนและสารบัญนำทาง (/api/lessons)
│   │   ├── questions/                      # API คลังคำถามและสุ่มโจทย์ (/api/questions)
│   │   ├── quiz/                           # API เริ่มสอบ ตรวจคำตอบ และสรุปผลคะแนน (/api/quiz)
│   │   ├── flashcards/                     # API แฟลชการ์ดทบทวนด่วน (/api/flashcards)
│   │   └── bookmarks/                      # API บันทึกรายการโปรด (/api/bookmarks)
│   ├── Dockerfile
│   └── package.json
│
├── frontend/                               # [Next.js Frontend Web App - Port 3000]
│   ├── src/
│   │   ├── app/
│   │   │   ├── layout.tsx                  # Root Layout (โหลดฟอนต์ Kanit + IBM Plex Sans Thai + Navbar)
│   │   │   ├── globals.css                 # Tailwind v4 @theme config และ Base Typography
│   │   │   ├── page.tsx                    # หน้าแรก Dashboard (Hero + Topic Grid + RightSidebar)
│   │   │   ├── learn/
│   │   │   │   ├── page.tsx                # หน้ารวมบทเรียนทั้งหมดแยกตามหมวดหมู่
│   │   │   │   └── [topicSlug]/
│   │   │   │       ├── page.tsx            # หน้ารายการบทเรียนในหมวดนั้นๆ
│   │   │   │       └── [lessonSlug]/
│   │   │   │           └── page.tsx        # หน้าอ่านบทเรียน (Markdown ตรงกลาง + สารบัญ TOC ด้านขวา)
│   │   │   ├── quiz/
│   │   │   │   └── page.tsx                # หน้าทำข้อสอบจับเวลา + หน้าสรุปผลคะแนนและเฉลยละเอียด
│   │   │   ├── flashcards/
│   │   │   │   └── page.tsx                # หน้าการ์ดพลิก 3D ทบทวนคำสั่งด่วน
│   │   │   └── bookmarks/
│   │   │       └── page.tsx                # หน้ารายการที่บันทึกไว้ทบทวนซ้ำ
│   │   ├── components/
│   │   │   ├── Navbar.tsx                  # แถบเมนูด้านบน + ลิงก์ Swagger + ปุ่มเปิด/ปิด Sidebar
│   │   │   ├── RightSidebar.tsx            # แถบเมนูด้านขวา (สารบัญ TOC, หมวดหมู่, Quick Actions)
│   │   │   ├── TopicCard.tsx               # การ์ดแสดงหมวดหมู่และสถิติจำนวนบทเรียน/ข้อสอบ
│   │   │   └── MarkdownContent.tsx         # ตัวแปลง Markdown พร้อมกฎจัดรูปแบบพิเศษ
│   │   ├── stores/
│   │   │   ├── useAppStore.ts              # Zustand Store สำหรับ UI, Sidebar และ Bookmarks
│   │   │   └── useQuizStore.ts             # Zustand Store สำหรับควบคุม Session การสอบและเวลา
│   │   ├── lib/
│   │   │   └── api.ts                      # HTTP Client เชื่อมต่อ Backend API
│   │   └── types/
│   │       └── index.ts                    # TypeScript Interfaces ทั้งระบบ
│   ├── Dockerfile
│   └── package.json
│
├── docker-compose.yml                      # Orchestration สำหรับ Postgres, Backend และ Frontend
├── .env / .env.example                     # ตัวแปรสภาพแวดล้อม
├── ARCHITECTURE.md                         # เอกสารสถาปัตยกรรมฉบับนี้
└── package.json                            # Root Scripts สำหรับสั่งรันทั้งโปรเจกต์
```

---

## 3. การแบ่งพื้นที่หน้าจอ (UI Layout & Space Allocation)

ระบบถูกออกแบบโดยยึดหลัก **"เนื้อหาหลักอยู่ตรงกลาง (Main Content Center) และแถบนำทางอยู่ด้านขวา (Right Sidebar)"** เพื่อให้อ่านบทเรียนและทำโจทย์ได้อย่างมีสมาธิ

```text
+-----------------------------------------------------------------------------------+
| TOP NAVBAR (Sticky Top, h-16, Backdrop Blur)                                      |
| [Logo: SupportHub]   [หน้าหลัก | บทเรียน | แบบทดสอบ | แฟลชการ์ด | บุ๊กมาร์ก]   [Swagger] |
+---------------------------------------------------------+-------------------------+
|                                                         | RIGHT SIDEBAR           |
| MAIN CONTENT AREA (ตรงกลาง: flex-1 min-w-0)              | (ด้านขวา: w-80 / w-88)  |
|                                                         | Sticky top-16           |
| - แสดงเนื้อหาตามหน้าที่เปิดอยู่:                              |                         |
|   1. หน้าแรก: Hero Banner + การ์ดหมวดหมู่ 3 คอลัมน์          | 1. สารบัญบทเรียน (TOC)   |
|   2. หน้าอ่านบทเรียน: Breadcrumb + หัวข้อเรื่อง +             |    (แสดงเฉพาะตอนอ่านบทเรียน|
|      เนื้อหา Markdown + ปุ่มบทก่อนหน้า/ถัดไป                  |     พร้อมไฮไลต์บทปัจจุบัน)  |
|   3. หน้า Quiz: ตั้งค่าข้อสอบ -> ตัวข้อสอบพร้อม Log ->        |                         |
|      วงกลมสรุปคะแนน + เฉลย Root Cause รายข้อ             | 2. รายการหมวดหมู่วิชาชีพ   |
|   4. หน้า Flashcards: การ์ดพลิกหน้า-หลัง + คำใบ้ (Hint)     |    (สลับหมวดได้ทันที)      |
|                                                         |                         |
|                                                         | 3. Quick Actions        |
|                                                         |    - เริ่มสุ่มข้อสอบด่วน     |
|                                                         |    - ทบทวนแฟลชการ์ด      |
|                                                         |                         |
|                                                         | 4. ลิงก์ด่วน               |
|                                                         |    - Open Swagger API   |
|                                                         |    - รายการ Bookmarks    |
+---------------------------------------------------------+-------------------------+
```

### พฤติกรรม Responsive (Desktop vs Mobile)
* **หน้าจอขนาดใหญ่ (`lg:` ขึ้นไป)**: แสดงผลคู่กัน (Main Content ตรงกลาง + Right Sidebar ยึดติดด้านขวาตลอดเวลา)
* **หน้าจอมือถือ/แท็บเล็ต (`< lg`)**: Main Content ขยายเต็มจอ และ Right Sidebar จะซ่อนตัวกลายเป็น **Slide-over Drawer** ที่สไลด์เปิดจากขอบขวาเมื่อกดปุ่มมุมขวาบนของ Navbar

---

## 4. ระบบธีม ฟอนต์ และกฎการแสดงผล (Themes, Typography & Formatting Rules)

### 4.1 ฟอนต์ประจำระบบ (Typography - สไตล์โมเดิร์น/ทันสมัย)
ตั้งค่าผ่าน `next/font/google` ใน `layout.tsx` และผูกเข้ากับ Tailwind CSS v4 ใน `globals.css`:
1. **ฟอนต์หัวข้อ (`--font-kanit` / `font-heading`)**:
   * ใช้ฟอนต์ **Kanit** (น้ำหนัก 400, 500, **600 SemiBold**, **700 Bold**)
   * บังคับใช้อัตโนมัติกับแท็ก `h1`, `h2`, `h3`, `h4`, `h5`, `h6` รวมถึงปุ่มสำคัญและตัวเลขสถิติ
2. **ฟอนต์เนื้อหา (`--font-ibm-plex-sans-thai` / `font-body`)**:
   * ใช้ฟอนต์ **IBM Plex Sans Thai** (น้ำหนัก **400 Regular** เป็นหลัก และ 300, 500, 600, 700)
   * บังคับใช้อัตโนมัติกับ `body`, ย่อหน้าบทเรียน (`p`), ตาราง, รายการตัวเลือกข้อสอบ และคำอธิบายเฉลย เพื่อให้อ่านข้อความยาวๆ ได้สบายตาที่สุด

### 4.2 โทนสีหลักและสีประจำหมวดหมู่ (Color Palette & Topic Accents)
* **พื้นหลังหลัก (Base Background)**: Deep Slate (`#0f172a` / `bg-slate-950`) ช่วยลดแสงสะท้อนเวลาอ่านโค้ดและ Log
* **การ์ดและพื้นผิวรอง (Surface)**: `bg-slate-900/60` พร้อมขอบ `border-slate-800` และ `backdrop-blur`
* **สีเน้นหลักของระบบ (Primary Accent)**: Cyan (`cyan-400` / `cyan-500`) ถึง Blue (`blue-600`)
* **สีประจำหมวดหมู่วิชาชีพ (Topic Theme Colors)**:
  * 🟠 **Linux Administration**: Amber to Orange (`from-amber-500 to-orange-600` / `text-amber-400`) — ไอคอน `Terminal`
  * 🔵 **Network Troubleshooting**: Blue to Cyan (`from-blue-500 to-cyan-600` / `text-cyan-400`) — ไอคอน `Network`
  * 🟢 **SQL & Database Essentials**: Emerald to Teal (`from-emerald-500 to-teal-600` / `text-emerald-400`) — ไอคอน `Database`
  * 🟣 **Web & HTTP/API**: Purple to Indigo (`from-purple-500 to-indigo-600` / `text-purple-400`) — ไอคอน `Globe`
  * 🔷 **Docker & Containers**: Sky to Blue (`from-sky-500 to-blue-600` / `text-sky-400`) — ไอคอน `Container`
  * 🔴 **Incident & Troubleshooting**: Rose to Pink (`from-rose-500 to-pink-600` / `text-rose-400`) — ไอคอน `Wrench`

### 4.3 กฎการจัดรูปแบบพิเศษในเนื้อหา (`MarkdownContent.tsx`)

⚠️ **ไอคอนนี้ต้องแสดงบนบรรทัดใหม่เสมอ**

* ใน `MarkdownContent.tsx` มีตัวกรอง (Pre-processor) ตรวจสอบทุกบรรทัด: หากพบสัญลักษณ์ `⚠️` อยู่กลางประโยค ระบบจะสั่งตัดขึ้นบรรทัดใหม่ (`\n\n⚠️`) โดยอัตโนมัติ
* หากเขียนในรูปแบบ Blockquote (`> ⚠️ ...`) ระบบจะเปลี่ยนสีกล่องข้อความจากสีฟ้า (`cyan`) เป็น **กล่องแจ้งเตือนสีเหลืองอำพัน (`border-amber-500 bg-amber-950/30 text-amber-200`)** ทันที

---

## 5. การแบ่งพื้นที่หัวข้อและเนื้อหา (Topic & Content Space Organization)

โครงสร้างเนื้อหาถูกแบ่งออกเป็น 3 ระดับ (3-Tier Hierarchy) เพื่อให้ขยายหัวข้อได้ไม่จำกัดโดยไม่ต้องแก้โครงสร้างฐานข้อมูล:

1. **ระดับ 1: Topic (หมวดวิชา)** เช่น `linux`, `network`, `sql`
2. **ระดับ 2: Lesson (บทเรียน)** เช่น `01-permissions`, `02-services`
3. **ระดับ 3: Sections ภายใน Markdown (`##`) + ชุดข้อสอบ (`.questions.json`) + ชุดแฟลชการ์ด (`.flashcards.json`)**

### มาตรฐานโครงสร้างเนื้อหาในแต่ละบทเรียน (`.md` Content Template)
ทุกบทเรียนในโฟลเดอร์ `content/<topic>/<หมายเลข>-<slug>.md` จะประกอบด้วย:
1. **YAML Frontmatter**:
   ```yaml
   ---
   slug: linux-permissions
   title: การจัดการสิทธิ์และ Permission ไฟล์ (chmod, chown, umask)
   summary: เจาะลึกระบบสิทธิ์ rwx บน Linux การคำนวณเลข Octal และกรณีศึกษาที่พบบ่อยในงาน Support
   read_time_minutes: 7
   difficulty: beginner
   display_order: 1
   ---
   ```
2. **โครงสร้างหัวข้อภายในบทเรียน**:
   * `# ชื่อเรื่องหลัก` + เกริ่นนำความสำคัญต่อสายงาน Support
   * `## 1. แนวคิดและโครงสร้างพื้นฐาน` (อธิบายทฤษฎีแบบกระชับเข้าใจง่าย)
   * `## 2. ตารางสรุป / คำสั่งที่ใช้งานจริง` (พร้อม Code block ตัวอย่างคำสั่งและพารามิเตอร์)
   * `## 3. กรณีศึกษาและวิธีแก้ปัญหาหน้างาน (Troubleshooting)`
   * บล็อกคำเตือน (ขึ้นบรรทัดใหม่ด้วย `> ⚠️ ...`) และบล็อกเคล็ดลับ (`> **Support Tip**: ...`)

### มาตรฐานโครงสร้างไฟล์ `.questions.json`
เก็บเป็น JSON Array ของชุดคำถามประจำบทเรียน (เช่น `content/linux/01-permissions.questions.json`):

```json
[
  {
    "seed_key": "linux:permissions:q01",
    "lesson_slug": "linux-permissions",
    "question_text": "หากต้องการกำหนดสิทธิ์ไฟล์ `deploy.sh` ให้ 'เจ้าของสามารถ อ่าน-เขียน-รันได้' ส่วน 'กลุ่มและผู้อื่น อ่านและรันได้เท่านั้น' ต้องใช้คำสั่ง chmod ตัวเลขใด?",
    "scenario_text": null,
    "difficulty": "easy",
    "question_type": "multiple_choice",
    "explanation": "คำนวณสิทธิ์ตามเลข Octal:\n- Owner (rwx) = 4 + 2 + 1 = 7\n- Group (r-x) = 4 + 0 + 1 = 5\n- Others (r-x) = 4 + 0 + 1 = 5\nดังนั้นคำตอบคือ chmod 755 deploy.sh",
    "tags": ["chmod", "linux", "permissions"],
    "choices": [
      {
        "choice_text": "chmod 755 deploy.sh",
        "is_correct": true,
        "explanation": "ถูกต้อง: 7 (rwx) สำหรับ Owner และ 5 (r-x) สำหรับ Group/Others"
      },
      {
        "choice_text": "chmod 644 deploy.sh",
        "is_correct": false,
        "explanation": "ผิด: 644 ไม่มีสิทธิ์รัน (Execute) สำหรับไฟล์สคริปต์"
      },
      {
        "choice_text": "chmod 777 deploy.sh",
        "is_correct": false
      },
      {
        "choice_text": "chmod 764 deploy.sh",
        "is_correct": false
      }
    ]
  }
]
```

| ฟิลด์ใน `.questions.json` | ชนิดข้อมูล | บังคับ | คำอธิบาย |
|---|---|---|---|
| `seed_key` | `string` | ✅ | Natural Key ไม่ซ้ำกันทั่วระบบ เช่น `<topic>:<lesson>:q01` ใช้ทำ Upsert |
| `lesson_slug` | `string \| null` | ❌ | `slug` ของบทเรียนที่ผูกด้วย (หากเป็น `null` จะผูกกับหมวดหมู่หลักโดยตรง) |
| `question_text` | `string` | ✅ | โจทย์คำถาม |
| `scenario_text` | `string \| null` | ❌ | ข้อความ Terminal Log หรือสถานการณ์จำลอง (แสดงในกล่องโค้ด) |
| `difficulty` | `string` | ✅ | `'easy'` \| `'medium'` \| `'hard'` |
| `question_type` | `string` | ✅ | `'multiple_choice'` \| `'scenario'` \| `'true_false'` |
| `explanation` | `string` | ✅ | เฉลยละเอียดและวิธีวิเคราะห์ Root Cause |
| `tags` | `string[]` | ❌ | รายการแท็กสำหรับค้นหาและจัดกลุ่ม |
| `choices` | `Array` | ✅ | ตัวเลือกคำตอบ โดยใน 1 ข้อต้องมี `"is_correct": true` เพียงตัวเลือกเดียว |

---

### มาตรฐานโครงสร้างไฟล์ `.flashcards.json`
เก็บเป็น JSON Array ของแฟลชการ์ดประจำบทเรียน (เช่น `content/linux/01-permissions.flashcards.json`):

```json
[
  {
    "seed_key": "linux:fc:ss-listen",
    "lesson_slug": "linux-permissions",
    "front_text": "คำสั่งตรวจสอบว่า Process ใดกำลังฟังพอร์ต (Listen) อยู่บน Linux",
    "back_text": "ss -tulpn หรือ netstat -tulpn\n\n-t: TCP\n-u: UDP\n-l: Listening\n-p: Show process/PID\n-n: Numeric port",
    "hint": "จำตัวย่อ TULPN",
    "display_order": 1
  }
]
```

| ฟิลด์ใน `.flashcards.json` | ชนิดข้อมูล | บังคับ | คำอธิบาย |
|---|---|---|---|
| `seed_key` | `string` | ✅ | Natural Key ไม่ซ้ำกันทั่วระบบ เช่น `<topic>:fc:<short-name>` |
| `lesson_slug` | `string \| null` | ❌ | `slug` ของบทเรียนที่ผูกด้วย (ใส่ `null` ได้หากเป็นการ์ดทั่วไปของหมวด) |
| `front_text` | `string` | ✅ | ข้อความด้านหน้าการ์ด (คำถาม / โจทย์ / ชื่อคำสั่ง) |
| `back_text` | `string` | ✅ | ข้อความด้านหลังการ์ดเมื่อพลิกดูเฉลย (รองรับการขึ้นบรรทัดใหม่ด้วย `\n`) |
| `hint` | `string \| null` | ❌ | คำใบ้เพิ่มเติมเมื่อผู้ใช้กดปุ่มดูคำใบ้ |
| `display_order` | `number` | ❌ | ลำดับการแสดงผลของการ์ด (ค่าเริ่มต้น `0`) |

---

## 6. ขั้นตอนการเพิ่มหัวข้อหรือบทเรียนใหม่ (Content Addition Workflow)

เมื่อต้องการเพิ่มบทเรียนหรือหัวข้อใหม่ในหมวดใดก็ตาม มีขั้นตอนมาตรฐานดังนี้:

1. **สร้างหรืออัปเดตไฟล์ใน `content/<topic_slug>/`**:
   * `_topic.json`: กำหนดรายละเอียดหมวดหมู่ (หากเป็นหมวดใหม่)
   * `XX-lesson-name.md`: เนื้อหาบทเรียน
   * `XX-lesson-name.questions.json`: ข้อสอบพร้อม `seed_key` (เช่น `"linux:ssh:q01"`)
   * `XX-lesson-name.flashcards.json`: แฟลชการ์ดพร้อม `seed_key` (เช่น `"linux:fc:ssh-keygen"`)
2. **รันคำสั่ง Sync เข้าฐานข้อมูล**:
   ```bash
   npm run db:seed
   ```
3. **กลไกการทำงานของ `seed-content.mjs`**:
   * เปิด Database Transaction (`BEGIN ... COMMIT`)
   * ค้นหา `topic_id` จาก `slug` แบบอัตโนมัติ (ไม่ยึดติดกับเลข ID)
   * ทำการ `UPSERT` (`ON CONFLICT DO UPDATE`) ทั้งบทเรียน คำถาม และแฟลชการ์ดโดยอ้างอิงจาก `slug` และ `seed_key` ทำให้รันซ้ำกี่ครั้งข้อมูลก็ไม่เบิ้ล
   * อัปเดตตัวเลือกคำตอบ (`choices`) ภายใต้ `question_id` เดิมอย่างปลอดภัย

---

## 7. สรุปโครงสร้างฐานข้อมูลและกฎความถูกต้อง (Database Integrity)

ระบบใช้ตารางหลัก 8 ตารางใน PostgreSQL (`db/init/01-init.sql`):
1. `topics`: หมวดหมู่วิชาชีพ (`slug` UNIQUE)
2. `lessons`: บทเรียน (`UNIQUE(topic_id, slug)`, `CHECK difficulty IN ('beginner','intermediate','advanced')`)
3. `questions`: โจทย์ข้อสอบ (`seed_key` UNIQUE, `CHECK difficulty`, `CHECK question_type`, `GIN INDEX` บน `tags`)
4. `choices`: ตัวเลือกคำตอบ พร้อม Partial Unique Index `uq_choices_one_correct` บังคับให้มีข้อถูก (`is_correct = TRUE`) ได้เพียงข้อเดียวต่อคำถาม
5. `flashcards`: การ์ดคำศัพท์/คำสั่ง (`seed_key` UNIQUE)
6. `quiz_sessions`: ประวัติการทำข้อสอบ คะแนน เปอร์เซ็นต์ และเวลาที่ใช้
7. `quiz_session_answers`: รายละเอียดคำตอบรายข้อในแต่ละรอบสอบ
8. `bookmarks`: รายการที่ผู้ใช้กดบันทึกไว้ (`UNIQUE(item_type, item_id)`)

---

## 8. รวมคำสั่งจัดการระบบ (Command Reference)

| คำสั่ง (รันที่ Root Folder) | หน้าที่การทำงาน |
|---|---|
| `npm run db:up` | สั่งเปิด Container `postgres` บน Docker |
| `npm run db:down` | สั่งปิด Container บน Docker |
| `npm run db:init` | สร้างตารางทั้งหมดใหม่จาก `01-init.sql` และลงข้อมูลตั้งต้นจาก `02-seed.sql` |
| `npm run db:seed` | ซิงค์เนื้อหาจากโฟลเดอร์ `content/` เข้าสู่ฐานข้อมูลแบบ Idempotent (ไม่ลบข้อมูลเดิม) |
| `npm run dev:backend` | รัน NestJS Backend แบบ Watch Mode ที่ `http://localhost:4000/api` (Swagger: `/api/docs`) |
| `npm run dev:frontend` | รัน Next.js Frontend ที่ `http://localhost:3000` |
| `npm run build:backend` | ทดสอบ Build โค้ด Backend TypeScript |
| `npm run build:frontend` | ทดสอบ Build โค้ด Frontend Next.js |
