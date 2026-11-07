# Support Knowledge Review App

Web Application สำหรับทบทวนความรู้สาย Technical Support (Linux, Network, SQL และหัวข้อเสริม)

## Tech Stack
- **Frontend**: Next.js (App Router), React, Tailwind CSS, Zustand, Lucide Icons
- **Backend**: NestJS, Swagger API (`@nestjs/swagger`)
- **Database**: PostgreSQL (Raw SQL connection ด้วย `pg` และ `@types/pg` — ไม่ใช้ ORM)
- **Container**: Docker Compose (PostgreSQL 16)

## โครงสร้างโปรเจกต์
```
Support Applications/
├── frontend/             # Next.js + React + Tailwind + Zustand
├── backend/              # NestJS + Swagger + Raw SQL (pg)
├── db/
│   └── init/
│       └── 01-init.sql   # Raw SQL schema & seed script
├── docker-compose.yml    # PostgreSQL container service
├── .env.example          # Environment variables template
├── .env                  # Local environment configuration
└── package.json          # Root scripts
```

## คำสั่งเริ่มต้น (Quick Start สำหรับเครื่องใหม่ที่เพิ่ง Clone)

### 1. ตั้งค่า Environment Variables
ไฟล์ `.env` จะถูกละเว้นไม่ขึ้น Git ให้สร้างจากตัวอย่าง:
```bash
cp .env.example .env
```

### 2. เริ่มต้น Database และข้อมูล (มีให้เลือก 2 วิธี)
* **วิธีที่ 1 (แนะนำ ผ่าน Docker)**: 
  ```bash
  npm run db:up
  ```
  *(เมื่อ Container สร้างเสร็จ ระบบจะนำเข้า Schema และ Seed ข้อมูลทั้งหมดจาก `db/init/` ให้แบบอัตโนมัติทันที)*
* **วิธีที่ 2 (ผ่าน Local PostgreSQL หรือต้องการโหลดข้อมูลซ้ำ)**:
  ```bash
  npm run db:init
  ```
  *(หรือใช้ไฟล์ Full Dump ได้ที่ `db/dump.sql`)*

### 3. รันระบบ Dev
* **Terminal 1 (Backend)**: `npm run dev:backend`
* **Terminal 2 (Frontend)**: `npm run dev:frontend`
* เปิดบราวเซอร์ที่: `http://localhost:3000`

### 4. คำสั่งจัดการ Database เพิ่มเติม
* `npm run db:dump`: สแกนเนื้อหาใน `content/` ทั้งหมดแล้วอัปเดตไฟล์ Dump/Seed SQL (`db/dump.sql` และ `db/init/02-seed.sql`)
* `npm run db:seed`: ซิงค์เนื้อหาจาก `content/` เข้า Database โดยตรง (ไม่ต้องเริ่ม DB ใหม่)
