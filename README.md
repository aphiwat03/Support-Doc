# Support Knowledge Review App

Web Application สำหรับทบทวนความรู้สาย Technical Support (Linux, Network, SQL และหัวข้อเสริม)

## Tech Stack
- **Package Manager**: pnpm (Workspaces)
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
│   ├── dumps/
│   │   ├── support_knowledge_db_full.sql  # Full Database Dump (Schema + Data)
│   │   └── support_knowledge_db_data.sql  # Data-only Dump
│   └── init/
│       ├── 01-init.sql                    # Raw SQL DDL schema
│       ├── 02-seed.sql                    # Complete initial seed data
│       └── 03-progress-streak.sql         # Progress & streak tables
├── docker-compose.yml    # PostgreSQL container service
├── .env.example          # Environment variables template
├── .env                  # Local environment configuration
├── pnpm-workspace.yaml   # pnpm monorepo workspace config
├── pnpm-lock.yaml        # pnpm lockfile
└── package.json          # Root scripts
```

## คำสั่งเริ่มต้น (Quick Start สำหรับเครื่องใหม่ที่เพิ่ง Clone)

### 1. ติดตั้ง Dependencies (เมื่อต้องการรันแบบ Local Dev)
```bash
pnpm install
```

### 2. ตั้งค่า Environment Variables
ไฟล์ `.env` จะถูกละเว้นไม่ขึ้น Git ให้สร้างจากตัวอย่าง:
```bash
cp .env.example .env
```

### 3. เริ่มต้น Database และข้อมูล (มีให้เลือก 2 วิธี)
* **วิธีที่ 1 (แนะนำ ผ่าน Docker)**: 
  ```bash
  pnpm db:up
  ```
  *(เมื่อ Container สร้างเสร็จ ระบบจะนำเข้า Schema และ Seed ข้อมูลทั้งหมดจาก `db/init/` ให้แบบอัตโนมัติทันที)*
* **วิธีที่ 2 (ผ่าน Local PostgreSQL หรือต้องการโหลดข้อมูลซ้ำ)**:
  ```bash
  pnpm db:init
  ```
  *(หรือใช้ไฟล์ Full Dump ได้ที่ `db/dumps/support_knowledge_db_full.sql`)*

### 4. รันระบบ Dev
* **Frontend Dev**: `pnpm dev:frontend`
* **Backend Dev**: `pnpm dev:backend`
* เปิดบราวเซอร์ที่: `http://localhost:3000` (Swagger API ที่ `http://localhost:4000/api/docs`)

### 5. คำสั่งจัดการ Database เพิ่มเติม
* `pnpm db:dump`: ตรวจสอบและสร้างไฟล์ Dump/Seed SQL (`db/dumps/` และ `db/init/02-seed.sql`)
* `pnpm db:seed`: ซิงค์เนื้อหาจาก `content/` เข้า Database โดยตรง (ไม่ต้องเริ่ม DB ใหม่)
* `pnpm build:frontend` / `pnpm build:backend`: ทดสอบ Build ทั้งสองโปรเจกต์
