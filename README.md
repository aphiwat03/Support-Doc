# Support Knowledge Review App

Web Application สำหรับทบทวนความรู้สาย Technical Support (Linux, Network, SQL, Data Center และหัวข้อเสริม)

## Tech Stack
- **Package Manager**: pnpm (Workspaces)
- **Frontend**: Next.js (App Router), React, Tailwind CSS, Zustand, Lucide Icons
- **Backend**: NestJS, Swagger API (`@nestjs/swagger`)
- **Database**: PostgreSQL (Raw SQL connection ด้วย `pg` และ `@types/pg` — ไม่ใช้ ORM, เก็บข้อมูลทั้งหมดใน DB เป็น Source of Truth)
- **Container**: Docker Compose (PostgreSQL 16)

## โครงสร้างโปรเจกต์
```
Support Applications/
├── frontend/             # Next.js + React + Tailwind + Zustand
├── backend/              # NestJS + Swagger + Raw SQL (pg)
├── db/
│   ├── dumps/
│   │   ├── support_knowledge_db_full.sql  # Full Database Dump (Schema + Data)
│   │   └── support_knowledge_db_data.sql  # Data-only Dump (Source of Truth)
│   └── init/
│       ├── 01-init.sql                    # Raw SQL DDL schema
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
  *(เมื่อ Container สร้างใหม่ ระบบจะนำเข้า Schema จาก `db/init/` และข้อมูลทั้งหมดจาก `db/dumps/support_knowledge_db_data.sql` ให้แบบอัตโนมัติทันที)*
* **วิธีที่ 2 (ผ่าน Local PostgreSQL หรือต้องการกู้คืนข้อมูลล่าสุดจาก Git)**:
  ```bash
  pnpm db:restore
  ```
  *(หรือ `pnpm db:init` ซึ่งจะรัน Schema และ Restore ข้อมูลจาก `db/dumps/`)*

### 4. รันระบบ Dev
* **Frontend Dev**: `pnpm dev:frontend`
* **Backend Dev**: `pnpm dev:backend`
* เปิดบราวเซอร์ที่: `http://localhost:3000` (Swagger API ที่ `http://localhost:4000/api/docs`)

### 5. คำสั่งจัดการ Database เพิ่มเติม (DB-First Workflow)
* เมื่อเพิ่มหรือแก้ไขบทเรียน/ข้อสอบ/แฟลชการ์ดใน PostgreSQL โดยตรง ให้รัน:
  ```bash
  pnpm db:dump
  ```
  เพื่อส่งออกข้อมูลจาก PostgreSQL ลงไฟล์ `db/dumps/support_knowledge_db_full.sql` และ `db/dumps/support_knowledge_db_data.sql` สำหรับ Commit ขึ้น Git
* `pnpm db:restore`: กู้คืนข้อมูลจาก `db/dumps/` เข้าสู่ PostgreSQL
* `pnpm build:frontend` / `pnpm build:backend`: ทดสอบ Build ทั้งสองโปรเจกต์
