'use client';

import React, { useEffect, useState } from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { 
  ChevronDown, 
  ChevronRight, 
  HelpCircle, 
  Layers, 
  ExternalLink,
  X,
  Check 
} from 'lucide-react';
import { useAppStore } from '@/stores/useAppStore';
import { Topic, Lesson } from '@/types';
import { api } from '@/lib/api';

const topicColorMap: Record<string, string> = {
  linux: 'bg-amber-400',
  network: 'bg-cyan-400',
  sql: 'bg-emerald-400',
  'web-api': 'bg-violet-400',
  docker: 'bg-sky-400',
  troubleshooting: 'bg-rose-400',
  datacenter: 'bg-orange-400',
};

/**
 * ปรับชื่อหัวข้อใน Sidebar ให้สั้น กระชับ อ่านง่าย และไม่ถูกตัดตกหล่น (...)
 * สไตล์เดียวกับ Linux Administration
 */
export function formatSidebarTitle(title: string): string {
  if (!title) return '';
  const trimmed = title.trim();

  const cleanMap: Record<string, string> = {
    // Linux
    'การจัดการสิทธิ์และ Permission ไฟล์ (chmod, chown, umask)': 'สิทธิ์และ Permission ไฟล์',
    'การจัดการสิทธิ์ไฟล์และโฟลเดอร์บน Linux': 'สิทธิ์ไฟล์ & โฟลเดอร์',
    'การจัดการ Service ด้วย systemctl และสืบค้น Log ด้วย journalctl': 'Service & journalctl Log',
    'พื้นฐาน Linux และการใช้งาน Terminal (pwd, ls, cd, cp, mv, rm, cat, less)': 'พื้นฐาน Terminal & Shell',
    'พื้นฐาน Linux และการใช้งาน Terminal': 'พื้นฐาน Terminal & Shell',
    'การตรวจวัด CPU, RAM, Disk และจัดการ Process (ps, top, kill, df, free)': 'ตรวจ CPU, RAM, Process',
    'โครงสร้างไดเรกทอรีและการจัดการไฟล์ (find, stat, file, ln -s, du)': 'โครงสร้างไดเรกทอรี & ไฟล์',
    'โครงสร้างไดเรกทอรีและการจัดการไฟล์บน Linux': 'โครงสร้างไดเรกทอรี & ไฟล์',
    'การจัดการ Process และ systemd Service (ps, top, kill, systemctl, journalctl)': 'Process & systemd Service',
    'การจัดการ Process และ systemd Service': 'Process & systemd Service',
    'การค้นหาและกรองข้อความจากไฟล์ Log (grep, pipe, awk, sort, uniq, wc)': 'ค้นหา & กรอง Log',
    'การค้นหาและกรองข้อความจากไฟล์ Log': 'ค้นหา & กรอง Log',
    'การอ่านและวิเคราะห์ System & Application Log (journalctl, dmesg, zgrep, logrotate)': 'อ่านและวิเคราะห์ Log',
    'การอ่านและวิเคราะห์ System & Application Log': 'อ่านและวิเคราะห์ Log',
    'การตรวจทรัพยากรเครื่อง Disk, Memory และ CPU (df, du, free, uptime, lsof, vmstat)': 'ตรวจ Disk, RAM, CPU',
    'การตรวจทรัพยากรเครื่อง (Disk, Memory, CPU)': 'ตรวจ Disk, RAM, CPU',
    'การเข้าถึงระยะไกลด้วย SSH, การโอนไฟล์ (scp, rsync) และ tmux พื้นฐาน': 'SSH & โอนไฟล์ (tmux)',
    'การตรวจสอบงานตั้งเวลาด้วย Cron และ Crontab (crontab -l, /etc/cron.d, Cron Log)': 'งานตั้งเวลา Cron & Crontab',
    'การตรวจสอบงานตั้งเวลาด้วย Cron (Scheduled Jobs)': 'งานตั้งเวลา Cron Jobs',
    'เช็กสถานะ Service, Port และ Endpoint (systemctl, ss, nc, curl)': 'เช็ก Service, Port & curl',
    'เช็กสถานะ Service, Port และ Endpoint': 'เช็ก Service, Port & curl',

    // Network
    'เครื่องมือวิเคราะห์ปัญหา Network สำหรับสาย Support': 'เครื่องมือตรวจ Network',
    'ทำความเข้าใจ IP, Subnet Mask, Gateway และกระบวนการ DNS': 'IP, Subnet & DNS',
    'ทำความเข้าใจ IP, Subnet Mask และ CIDR สำหรับงาน Support': 'IP, Subnet Mask & CIDR',
    'การทำงานของระบบ DNS และเทคนิคการสืบค้น (dig, nslookup)': 'ระบบ DNS & dig',
    'วิเคราะห์เส้นทางและ Latency ด้วย ping, traceroute และ mtr': 'เส้นทาง & Latency (mtr)',
    'TCP Handshake, สถานะพอร์ต และความต่าง Connection Refused vs Timed Out': 'TCP Handshake & Port',
    'โมเดล OSI/TCP-IP และการวิเคราะห์ปัญหาเครือข่ายทีละชั้น (OSI & Layered Troubleshooting)': 'OSI 7 Layers & วิเคราะห์ทีละชั้น',
    'การทำงานของ Switch, ARP, VLAN และ Trunk 802.1Q (Switching & VLANs)': 'Switch, ARP, VLAN & Trunk',
    'ระบบแจกไอพี DHCP และการแปลงแอดเดรส NAT/PAT (DHCP & Network Address Translation)': 'ระบบ DHCP & NAT/PAT',
    'คำสั่งสำรวจและตรวจสอบเครือข่าย Cisco/Network CLI (Show Commands & Diagnostics)': 'คำสั่ง Cisco CLI & Show',
    'ถอดรหัสปัญหา Layer 1 และ Layer 2 หน้างาน (L1/L2 Troubleshooting & Storms)': 'ปัญหา L1/L2, STP & LACP',
    'การดักจับและวิเคราะห์แพ็กเก็ตด้วย tcpdump และ Wireshark (Packet Capture & Analysis)': 'Packet Capture (tcpdump)',

    // SQL
    'Master รูปแบบ SQL JOIN และการประยุกต์ใช้งานจริง': 'รูปแบบ SQL JOIN',
    'Master รูปแบบ SQL JOIN และการประยุกต์ใช้งานจริงในงาน Support': 'SQL JOIN & Anti-join',
    'วิเคราะห์สถิติและเหตุการณ์ผิดปกติด้วย GROUP BY และ HAVING': 'สถิติ GROUP BY & HAVING',
    'การจูน Index และอ่าน EXPLAIN ANALYZE เพื่อแก้ปัญหา Database ช้า': 'จูน Index & EXPLAIN',
    'การจูน Index, อ่าน EXPLAIN ANALYZE และจัดการ Slow Query': 'จูน Index & Slow Query',

    // Web & HTTP/API
    'ผ่าโครงสร้าง HTTP Status Codes สำหรับวิเคราะห์ปัญหา Web & API': 'HTTP Status Codes',
    'การใช้คำสั่ง curl ทดสอบ REST API และวัด Response Time': 'ทดสอบ API ด้วย curl',
    'การตรวจสอบใบรับรอง SSL/TLS และการแก้ปัญหา Certificate หมดอายุ': 'ตรวจใบรับรอง SSL/TLS',

    // Docker
    'คำสั่ง Docker พื้นฐานและการจัดการ Container ในงาน Support': 'คำสั่ง Docker พื้นฐาน',
    'ถอดรหัส Exit Codes และการแก้ปัญหา Container ดับ (OOMKilled 137)': 'Exit Codes & OOMKilled',

    // Incident & Troubleshooting
    'ลำดับการ Triage ปัญหาและระเบียบวิธีวิเคราะห์ Incident เชิงระบบ': 'ลำดับ Triage & Sev Matrix',
    'เทคนิค 5 Whys, การทำ RCA และการส่งต่อเคส (Escalation) อย่างมือโปร': 'เทคนิค 5 Whys & RCA',
    'กระบวนการทำงาน IT Support มืออาชีพ: ITIL, SLA, การเขียน Ticket และ Escalation (ITIL & SLA Operations)': 'ITIL, SLA & การเขียน Ticket',
    'การจัดการ Windows Domain เบื้องต้น: Active Directory, GPO และแก้ปัญหา Login ในองค์กร (Active Directory & GPO)': 'Windows AD, GPO & Domain',
    'การดูแลระบบอีเมลองค์กร Microsoft 365 และตรวจสอบ SPF, DKIM, DMARC (M365 & Email Authentication)': 'M365 & อีเมล SPF/DKIM/DMARC',
    'การแก้ปัญหา Network Printer, Print Spooler, SMB Share และ VPN ในสำนักงาน (Office IT & Endpoint Troubleshooting)': 'แก้ปัญหา Printer, SMB & VPN',
    'กลยุทธ์การสำรองข้อมูล (3-2-1 Backup Rule), RTO vs RPO และการรับมือเหตุการณ์ Ransomware (Backup, DR & Incident Response)': 'กฎ 3-2-1 Backup, RTO/RPO & DR',

    // Data Center & Hardware Ops
    'ระบบสายสัญญาณ ไฟเบอร์ออปติก และ Transceiver (Cabling, Fiber & Optics)': 'สายสัญญาณ & Fiber Optics',
    'ฮาร์ดแวร์เซิร์ฟเวอร์ การเข้าตู้แร็ค และระบบจัดการระยะไกล (Server Hardware & OOB)': 'Server Hardware & iDRAC/iLO',
    'เครือข่าย OOB, กระบวนการ PXE Boot, ระบบ SAN Zoning และ Blade Server': 'PXE Boot, SAN & Blade',
    'ระบบไฟฟ้า 1/3 เฟส, UPS/ATS, การจัดการลมร้อน-ลมเย็น และระบบดับเพลิง DC': 'ระบบไฟ UPS & Hot/Cold Aisle',
    'ระบบจัดเก็บข้อมูลเซิร์ฟเวอร์: RAID, Hot-Swap และ SMART Diagnostics (Storage, RAID & SMART)': 'ระบบ RAID, Hot-Swap & SMART',
    'การวินิจฉัยฮาร์ดแวร์เซิร์ฟเวอร์เสีย และอ่าน System Event Log (Hardware Troubleshooting & SEL)': 'วินิจฉัย Hardware & SEL Log',
    'การติดตั้ง OS ระยะไกล และการอัปเดต Firmware เซิร์ฟเวอร์อย่างปลอดภัย (OS Provisioning & Firmware Lifecycle)': 'ติดตั้ง OS & อัปเดต Firmware',
    'มาตรฐานการเดินสายสัญญาณ, ป้ายกำกับ และการจัดการสินทรัพย์ DCIM (Structured Cabling, Labeling & DCIM)': 'มาตรฐานจัดสาย, Label & DCIM',
    'กระบวนการปฏิบัติงาน, ความปลอดภัยทางกายภาพ และมาตรฐาน Tier (DC Operations, Safety & Tier Standards)': 'ปฏิบัติงาน DC, Safety & Tier',
    'อุปกรณ์ประจำตู้แร็ค หัวปลั๊กไฟ IEC และเครื่องมือช่างหน้างาน Data Center (DC Equipment, Power Connectors & Field Toolkit)': 'อุปกรณ์ตู้แร็ค, ปลั๊ก IEC & เครื่องมือช่าง',
    'ทัศนคติ ความปลอดภัย และเทคนิคพิชิตสัมภาษณ์งาน Data Center (Hosting vs Colocation)': 'เทคนิคสัมภาษณ์ & Mindset',
  };

  if (cleanMap[trimmed]) {
    return cleanMap[trimmed];
  }

  // Regex Smart Matching สำหรับชื่อใหม่หรือชื่อที่อาจมีความคลาดเคลื่อนเล็กน้อย
  if (/ip.*subnet/i.test(trimmed)) return 'IP, Subnet & CIDR';
  if (/dns/i.test(trimmed) && /(dig|nslookup|สืบค้น)/i.test(trimmed)) return 'ระบบ DNS & dig';
  if (/(latency|ping|traceroute|mtr)/i.test(trimmed)) return 'เส้นทาง & Latency (mtr)';
  if (/tcp.*handshake/i.test(trimmed) || /refused.*timed out/i.test(trimmed)) return 'TCP Handshake & Port';
  if (/network/i.test(trimmed) && /เครื่องมือ/i.test(trimmed)) return 'เครื่องมือตรวจ Network';
  if (/sql.*join/i.test(trimmed)) return 'รูปแบบ SQL JOIN';
  if (/group by|having/i.test(trimmed)) return 'สถิติ GROUP BY & HAVING';
  if (/explain|slow query|จูน index/i.test(trimmed)) return 'จูน Index & EXPLAIN';
  if (/http status/i.test(trimmed)) return 'HTTP Status Codes';
  if (/curl.*(api|rest)/i.test(trimmed) || /rest.*api/i.test(trimmed)) return 'ทดสอบ API ด้วย curl';
  if (/ssl|tls|certificate/i.test(trimmed)) return 'ตรวจใบรับรอง SSL/TLS';
  if (/docker/i.test(trimmed)) return 'คำสั่ง Docker พื้นฐาน';
  if (/exit code|oomkilled/i.test(trimmed)) return 'Exit Codes & OOMKilled';
  if (/triage|incident/i.test(trimmed)) return 'ลำดับ Triage & Sev Matrix';
  if (/5 whys|rca|escalation/i.test(trimmed)) return 'เทคนิค 5 Whys & RCA';

  // Fallback: ตัดข้อความในวงเล็บ (เช่น รายการคำสั่งยาวๆ) ออก
  return trimmed.replace(/\s*\([^)]*\)/g, '').trim();
}

interface DocsSidebarProps {
  initialTopics?: Topic[];
  initialLessons?: Lesson[];
}

export const DocsSidebar: React.FC<DocsSidebarProps> = ({
  initialTopics,
  initialLessons,
}) => {
  const pathname = usePathname();
  const { isSidebarOpen, setSidebarOpen, completedLessonIds } = useAppStore();

  const [topics, setTopics] = useState<Topic[]>(initialTopics || []);
  const [lessons, setLessons] = useState<Lesson[]>(initialLessons || []);
  const [expandedTopics, setExpandedTopics] = useState<Record<string, boolean>>({});

  // Detect current topicSlug and lessonSlug from pathname
  // Routes: /learn/[topicSlug] or /learn/[topicSlug]/[lessonSlug]
  const pathParts = pathname.split('/').filter(Boolean);
  const currentTopicSlug = pathParts[0] === 'learn' ? pathParts[1] : undefined;
  const currentLessonSlug = pathParts[0] === 'learn' ? pathParts[2] : undefined;

  useEffect(() => {
    if (topics.length === 0 || lessons.length === 0) {
      Promise.all([api.getTopics(), api.getLessons()])
        .then(([topicsData, lessonsData]) => {
          setTopics(topicsData);
          setLessons(lessonsData);
        })
        .catch((err) => {
          console.error('Failed to load docs sidebar data:', err);
        });
    }
  }, [topics.length, lessons.length]);

  // Automatically expand the topic that contains the current active lesson or active topic
  useEffect(() => {
    if (currentTopicSlug) {
      setExpandedTopics((prev) => ({
        ...prev,
        [currentTopicSlug]: true,
      }));
    }
  }, [currentTopicSlug]);

  // Handle ESC key to close drawer on mobile
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape' && isSidebarOpen) {
        setSidebarOpen(false);
      }
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [isSidebarOpen, setSidebarOpen]);

  // Close drawer on path navigation
  useEffect(() => {
    setSidebarOpen(false);
  }, [pathname, setSidebarOpen]);

  const toggleTopicExpand = (slug: string) => {
    setExpandedTopics((prev) => ({
      ...prev,
      [slug]: !prev[slug],
    }));
  };

  const content = (
    <div className="flex flex-col h-full justify-between">
      {/* Top: Section Header & Topics/Lessons tree */}
      <div className="space-y-4">
        {/* Mobile Close Button */}
        <div className="flex items-center justify-between pb-3 border-b border-[var(--color-border)] lg:hidden">
          <span className="font-heading text-sm font-semibold text-[var(--color-text)]">
            สารบัญบทเรียน
          </span>
          <button
            onClick={() => setSidebarOpen(false)}
            aria-label="ปิดเมนูนำทาง"
            className="p-1.5 text-[var(--color-text-muted)] hover:text-[var(--color-text)] rounded-md hover:bg-[var(--color-surface)]"
          >
            <X className="h-4 w-4" />
          </button>
        </div>

        {/* Topics List */}
        <nav aria-label="สารบัญบทเรียน" className="space-y-1">
          {topics.map((topic) => {
            const isExpanded = expandedTopics[topic.slug] ?? (topic.slug === currentTopicSlug);
            const topicLessons = lessons
              .filter((l) => l.topic_id === topic.id || l.topic_slug === topic.slug)
              .sort((a, b) => a.display_order - b.display_order);

            const dotColor = topicColorMap[topic.slug] || 'bg-cyan-400';
            const isTopicActive = currentTopicSlug === topic.slug && !currentLessonSlug;
            const completedCount = topicLessons.filter((l) => completedLessonIds.has(l.id)).length;
            const isAllCompleted = topicLessons.length > 0 && completedCount === topicLessons.length;

            return (
              <div key={topic.id} className="text-sm">
                {/* Topic Header Row */}
                <div className="flex items-center justify-between group rounded-md hover:bg-[var(--color-surface)] transition-colors">
                  <Link
                    href={`/learn/${topic.slug}`}
                    className={`flex-1 flex items-center gap-2 py-1.5 px-2 font-medium transition-colors ${
                      isTopicActive
                        ? 'text-[var(--color-accent)] font-semibold'
                        : 'text-[var(--color-text)] hover:text-[var(--color-accent)]'
                    }`}
                  >
                    <span className={`h-2 w-2 rounded-full shrink-0 ${dotColor}`} />
                    <span className="leading-snug">{topic.title}</span>
                  </Link>

                  <div className="flex items-center gap-1 pr-1">
                    {topicLessons.length > 0 && (
                      <span 
                        title={`อ่านจบแล้ว ${completedCount} จาก ${topicLessons.length} บทเรียน`}
                        className={`text-[10px] font-mono px-1.5 py-0.5 rounded-full border transition-colors ${
                          isAllCompleted
                            ? 'border-emerald-500/40 text-emerald-400 bg-emerald-500/10 font-medium'
                            : 'border-[var(--color-border)] text-[var(--color-text-muted)] bg-[var(--color-surface-2)]'
                        }`}
                      >
                        {completedCount}/{topicLessons.length}
                      </span>
                    )}

                    {topicLessons.length > 0 && (
                      <button
                        onClick={() => toggleTopicExpand(topic.slug)}
                        aria-label={`${isExpanded ? 'พับ' : 'ขยาย'} ${topic.title}`}
                        className="p-1.5 text-[var(--color-text-muted)] hover:text-[var(--color-text)] transition-colors"
                      >
                        {isExpanded ? (
                          <ChevronDown className="h-3.5 w-3.5" />
                        ) : (
                          <ChevronRight className="h-3.5 w-3.5" />
                        )}
                      </button>
                    )}
                  </div>
                </div>

                {/* Sub-lessons list */}
                {isExpanded && topicLessons.length > 0 && (
                  <div className="ml-3 pl-3 border-l border-[var(--color-border)] my-1 space-y-0.5">
                    {topicLessons.map((lesson) => {
                      const isCurrentLesson = currentLessonSlug === lesson.slug;
                      const isCompleted = completedLessonIds.has(lesson.id);

                      return (
                        <Link
                          key={lesson.id}
                          href={`/learn/${topic.slug}/${lesson.slug}`}
                          title={lesson.title}
                          className={`flex items-center justify-between py-1.5 px-2.5 rounded-md text-xs leading-snug transition-colors ${
                            isCurrentLesson
                              ? 'border-l-2 -ml-[13px] pl-[11px] border-[var(--color-accent)] bg-[var(--color-surface-2)] text-[var(--color-accent)] font-medium'
                              : 'text-[var(--color-text-muted)] hover:text-[var(--color-text)] hover:bg-[var(--color-surface)]'
                          }`}
                        >
                          <span className="truncate">{formatSidebarTitle(lesson.title)}</span>
                          {isCompleted && (
                            <Check className="h-3 w-3 text-emerald-400 shrink-0 ml-1.5" />
                          )}
                        </Link>
                      );
                    })}
                  </div>
                )}
              </div>
            );
          })}
        </nav>
      </div>

      {/* Bottom Footer Actions */}
      <div className="pt-4 mt-6 border-t border-[var(--color-border)] space-y-2 text-xs">
        <Link
          href="/quiz"
          className="flex items-center gap-2 py-1.5 px-2 text-[var(--color-text-muted)] hover:text-[var(--color-text)] hover:bg-[var(--color-surface)] rounded-md transition-colors"
        >
          <HelpCircle className="h-3.5 w-3.5 text-[var(--color-accent)]" />
          <span>สุ่มข้อสอบด่วน</span>
        </Link>
        <Link
          href="/flashcards"
          className="flex items-center gap-2 py-1.5 px-2 text-[var(--color-text-muted)] hover:text-[var(--color-text)] hover:bg-[var(--color-surface)] rounded-md transition-colors"
        >
          <Layers className="h-3.5 w-3.5 text-amber-400" />
          <span>ทบทวนแฟลชการ์ด</span>
        </Link>
        <a
          href="http://localhost:4000/api/docs"
          target="_blank"
          rel="noopener noreferrer"
          className="flex items-center justify-between py-1.5 px-2 text-[11px] text-[var(--color-text-muted)] hover:text-[var(--color-text)] hover:bg-[var(--color-surface)] rounded-md transition-colors"
        >
          <span>Swagger API (Docs)</span>
          <ExternalLink className="h-3 w-3" />
        </a>
      </div>
    </div>
  );

  return (
    <>
      {/* Mobile Drawer Backdrop */}
      {isSidebarOpen && (
        <div
          className="fixed inset-0 z-40 bg-black/60 lg:hidden"
          onClick={() => setSidebarOpen(false)}
        />
      )}

      {/* Mobile Drawer (Left Slide-in) */}
      <aside
        className={`fixed top-0 bottom-0 left-0 z-50 w-72 bg-[var(--color-bg)] border-r border-[var(--color-border)] p-4 overflow-y-auto transition-transform duration-200 ease-in-out lg:hidden ${
          isSidebarOpen ? 'translate-x-0' : '-translate-x-full'
        }`}
      >
        {content}
      </aside>

      {/* Desktop Sticky Left Nav */}
      <aside className="hidden lg:block w-64 xl:w-72 shrink-0 self-start sticky top-14 h-[calc(100vh-3.5rem)] overflow-y-auto border-r border-[var(--color-border)] p-4 bg-[var(--color-bg)]">
        {content}
      </aside>
    </>
  );
};
