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
│   └── init/
│       └── 01-init.sql   # Raw SQL schema & seed script
├── docker-compose.yml    # PostgreSQL container service
├── .env.example          # Environment variables template
├── .env                  # Local environment configuration
├── pnpm-workspace.yaml   # pnpm monorepo workspace config
├── pnpm-lock.yaml        # pnpm lockfile
└── package.json          # Root scripts
```

## คำสั่งเริ่มต้น (Quick Start)
- **Install Dependencies**: `pnpm install`
- **Database**: `pnpm db:up` (หรือ `docker compose up -d postgres`)
- **Init & Seed Database**: `pnpm db:init` และ `pnpm db:seed`
- **Frontend Dev**: `pnpm dev:frontend`
- **Backend Dev**: `pnpm dev:backend`
- **Build All**: `pnpm build:frontend` และ `pnpm build:backend`
