'use client';

import React, { useEffect, useState } from 'react';
import Link from 'next/link';
import { 
  Flame, 
  Trophy, 
  Calendar, 
  CheckCircle2, 
  BookOpen, 
  HelpCircle, 
  Layers, 
  ArrowRight,
  TrendingUp,
  Sparkles,
  Lock,
  Award
} from 'lucide-react';
import { api } from '@/lib/api';
import { useAppStore } from '@/stores/useAppStore';
import StreakFlame from '@/components/streak/StreakFlame';

interface StreakSummary {
  current_streak: number;
  longest_streak: number;
  studied_today: boolean;
  total_study_days: number;
}

interface ActivityItem {
  date: string;
  count: number;
  lessons: number;
  quizzes: number;
  flashcards: number;
}

interface TopicProgressItem {
  id: number;
  slug: string;
  title: string;
  icon: string;
  color: string;
  total_lessons: number;
  completed_lessons: number;
  percentage: number;
}

export default function StreakPage() {
  const { setStreakInfo } = useAppStore();
  const [summary, setSummary] = useState<StreakSummary>({
    current_streak: 0,
    longest_streak: 0,
    studied_today: false,
    total_study_days: 0,
  });
  const [activities, setActivities] = useState<ActivityItem[]>([]);
  const [topics, setTopics] = useState<TopicProgressItem[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    Promise.all([
      api.getStreakSummary().catch(() => ({
        current_streak: 0,
        longest_streak: 0,
        studied_today: false,
        total_study_days: 0,
      })),
      api.getStreakActivity(35).catch(() => []),
      api.getTopicProgress().catch(() => []),
    ])
      .then(([summaryData, activityData, topicData]) => {
        if (summaryData) {
          setSummary(summaryData);
          setStreakInfo(summaryData.current_streak, summaryData.studied_today);
        }
        if (Array.isArray(activityData)) setActivities(activityData);
        if (Array.isArray(topicData)) setTopics(topicData);
      })
      .finally(() => setLoading(false));
  }, [setStreakInfo]);

  // Calculate day names for the past 7 days (Week Strip)
  const past7Days = Array.from({ length: 7 }, (_, i) => {
    const d = new Date();
    d.setDate(d.getDate() - (6 - i));
    const isoDate = d.toISOString().split('T')[0];
    const thaiDays = ['อา.', 'จ.', 'อ.', 'พ.', 'พฤ.', 'ศ.', 'ส.'];
    const dayName = thaiDays[d.getDay()];
    const isToday = i === 6;
    const hasActivity = activities.some((a) => a.date === isoDate && a.count > 0);
    return { isoDate, dayName, isToday, hasActivity };
  });

  // Calculate maximum count for SVG chart scaling
  const maxActivityCount = Math.max(...activities.map((a) => a.count), 5);

  // 35-day Heatmap Grid (5 weeks x 7 days)
  const heatmapDays = Array.from({ length: 35 }, (_, i) => {
    const d = new Date();
    d.setDate(d.getDate() - (34 - i));
    const isoDate = d.toISOString().split('T')[0];
    const act = activities.find((a) => a.date === isoDate);
    return {
      date: isoDate,
      count: act ? act.count : 0,
      lessons: act ? act.lessons : 0,
      quizzes: act ? act.quizzes : 0,
      flashcards: act ? act.flashcards : 0,
    };
  });

  // Achievements / Badges system
  const badges = [
    {
      id: 'first_step',
      title: 'ก้าวแรกสู่วงการ Support',
      desc: 'อ่านและบันทึกจบบทเรียนแรก',
      icon: Sparkles,
      color: 'from-amber-400 to-orange-500',
      unlocked: topics.some((t) => t.completed_lessons > 0) || summary.total_study_days > 0,
    },
    {
      id: 'streak_3',
      title: 'ไฟติดเครื่อง 3 วันติด',
      desc: 'รักษาวินัยการเรียนต่อเนื่อง 3 วันขึ้นไป',
      icon: Flame,
      color: 'from-orange-500 to-rose-500',
      unlocked: summary.longest_streak >= 3,
    },
    {
      id: 'streak_7',
      title: 'Streak Master 7 วัน',
      desc: 'เรียนรู้ต่อเนื่องครบ 1 สัปดาห์เต็ม',
      icon: Trophy,
      color: 'from-yellow-400 to-amber-500',
      unlocked: summary.longest_streak >= 7,
    },
    {
      id: 'linux_scholar',
      title: 'เซียน Linux Administration',
      desc: 'อ่านครบทุกบทเรียนในหมวด Linux',
      icon: BookOpen,
      color: 'from-cyan-400 to-blue-500',
      unlocked: topics.some((t) => t.slug === 'linux' && t.percentage >= 100),
    },
    {
      id: 'sql_pro',
      title: 'ผู้ชำนาญการ SQL Database',
      desc: 'อ่านครบทุกบทเรียนในหมวด SQL & Database',
      icon: TrendingUp,
      color: 'from-emerald-400 to-teal-500',
      unlocked: topics.some((t) => t.slug === 'sql' && t.percentage >= 100),
    },
    {
      id: 'network_master',
      title: 'ยอดฝีมือ Network & Firewall',
      desc: 'อ่านครบทุกบทเรียนในหมวด Network Troubleshooting',
      icon: Layers,
      color: 'from-violet-400 to-purple-500',
      unlocked: topics.some((t) => t.slug === 'network' && t.percentage >= 100),
    },
    {
      id: 'datacenter_ops',
      title: 'วิศวกรปฏิบัติการ Data Center',
      desc: 'อ่านครบทุกบทเรียนในหมวด Data Center & Hardware Ops',
      icon: Award,
      color: 'from-orange-400 to-amber-500',
      unlocked: topics.some((t) => t.slug === 'datacenter' && t.percentage >= 100),
    },
  ];

  return (
    <main className="flex-1 mx-auto w-full max-w-4xl p-4 sm:p-6 lg:p-10 space-y-8">
      {/* Page Header */}
      <div>
        <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold bg-orange-500/10 text-orange-400 border border-orange-500/20 mb-3">
          <Sparkles className="h-3.5 w-3.5" />
          <span>ระบบติดตามวินัยการเรียนรู้ (Daily Streak & Badges)</span>
        </div>
        <h1 className="font-heading text-2xl sm:text-3xl font-bold text-[var(--color-text)]">
          สถิติและความคืบหน้าการฝึกฝน
        </h1>
        <p className="font-body text-sm text-[var(--color-text-muted)] mt-1">
          รักษาเปลวไฟการเรียนรู้สะสมวันต่อเนื่อง เตรียมความพร้อมสู่อาชีพ Application Support & NOC
        </p>
      </div>

      {/* Hero Visual Card */}
      <div className="rounded-2xl border border-[var(--color-border)] bg-gradient-to-b from-[var(--color-surface)] to-[var(--color-surface-2)] p-6 sm:p-8 flex flex-col md:flex-row items-center justify-between gap-6 shadow-xl relative overflow-hidden">
        {/* Glow backdrop */}
        <div className="absolute -top-24 -left-24 w-72 h-72 bg-orange-500/10 rounded-full blur-3xl pointer-events-none" />

        <div className="flex-1 text-center md:text-left z-10 space-y-3">
          <div className="inline-flex items-center gap-2 text-xs font-semibold px-2.5 py-1 rounded-md bg-[var(--color-surface)] border border-[var(--color-border)] text-[var(--color-text-muted)]">
            <Calendar className="h-3.5 w-3.5 text-orange-400" />
            <span>วันนี้: {summary.studied_today ? 'เรียนแล้ว (+1 วัน)' : 'ยังไม่ได้บันทึกกิจกรรม'}</span>
          </div>

          <div className="flex items-baseline justify-center md:justify-start gap-3">
            <span className="font-heading text-5xl sm:text-6xl font-extrabold text-[var(--color-text)] tracking-tight">
              {summary.current_streak}
            </span>
            <span className="font-heading text-xl sm:text-2xl font-bold text-orange-400">
              วันต่อเนื่อง (Streak)
            </span>
          </div>

          <p className="text-xs sm:text-sm text-[var(--color-text-muted)] max-w-md">
            {summary.studied_today
              ? 'สุดยอดมาก! คุณรักษาวินัยการเรียนรู้ประจำวันสำเร็จแล้ว เปลวไฟกำลังลุกโชน 🔥'
              : 'อ่านบทเรียนสัก 1 บท หรือทำควิซด่วนเพื่อจุดไฟ Streak ของคุณวันนี้เลย!'}
          </p>
        </div>

        {/* 3D WebGL Flame (with 2D Fallback) */}
        <div className="z-10 flex flex-col items-center">
          <StreakFlame days={summary.current_streak} />
        </div>
      </div>

      {/* 3 Metric Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div className="p-5 rounded-2xl border border-[var(--color-border)] bg-[var(--color-surface)] flex items-center gap-4">
          <div className="p-3 rounded-xl bg-orange-500/10 text-orange-400 shrink-0">
            <Flame className="h-6 w-6" />
          </div>
          <div>
            <div className="text-xs text-[var(--color-text-muted)] font-medium">Streak ปัจจุบัน</div>
            <div className="font-heading text-2xl font-bold text-[var(--color-text)]">
              {summary.current_streak} วัน
            </div>
          </div>
        </div>

        <div className="p-5 rounded-2xl border border-[var(--color-border)] bg-[var(--color-surface)] flex items-center gap-4">
          <div className="p-3 rounded-xl bg-amber-500/10 text-amber-400 shrink-0">
            <Trophy className="h-6 w-6" />
          </div>
          <div>
            <div className="text-xs text-[var(--color-text-muted)] font-medium">สถิติสูงสุดที่ทำได้</div>
            <div className="font-heading text-2xl font-bold text-[var(--color-text)]">
              {summary.longest_streak} วัน
            </div>
          </div>
        </div>

        <div className="p-5 rounded-2xl border border-[var(--color-border)] bg-[var(--color-surface)] flex items-center gap-4">
          <div className="p-3 rounded-xl bg-emerald-500/10 text-emerald-400 shrink-0">
            <CheckCircle2 className="h-6 w-6" />
          </div>
          <div>
            <div className="text-xs text-[var(--color-text-muted)] font-medium">จำนวนวันที่เข้ามาเรียน</div>
            <div className="font-heading text-2xl font-bold text-[var(--color-text)]">
              {summary.total_study_days} วัน
            </div>
          </div>
        </div>
      </div>

      {/* Week Activity Strip */}
      <div className="rounded-2xl border border-[var(--color-border)] bg-[var(--color-surface)] p-6">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 mb-4">
          <h2 className="font-heading text-base font-semibold text-[var(--color-text)] flex items-center gap-2">
            <Calendar className="h-4 w-4 text-orange-400" />
            <span>ความต่อเนื่องในสัปดาห์นี้ (7 วันล่าสุด)</span>
          </h2>
          <span className="text-xs text-[var(--color-text-muted)]">
            {summary.studied_today ? '✓ เข้าเรียนครบตามเป้าวันนี้' : '○ รอการเรียนรู้วันนี้'}
          </span>
        </div>

        <div className="grid grid-cols-7 gap-2 sm:gap-3">
          {past7Days.map((day) => (
            <div
              key={day.isoDate}
              className={`p-3 rounded-xl border text-center transition-all flex flex-col items-center justify-center gap-1.5 ${
                day.hasActivity
                  ? 'border-orange-500/40 bg-gradient-to-b from-orange-500/10 to-orange-500/5 text-orange-400 shadow-sm'
                  : day.isToday
                  ? 'border-[var(--color-accent)]/50 bg-[var(--color-surface-2)] text-[var(--color-accent)] animate-pulse'
                  : 'border-[var(--color-border)] bg-[var(--color-surface-2)] text-[var(--color-text-muted)]'
              }`}
            >
              <span className="text-[11px] font-medium">{day.dayName}</span>
              <div
                className={`w-7 h-7 rounded-full flex items-center justify-center text-xs font-semibold ${
                  day.hasActivity
                    ? 'bg-orange-500 text-slate-950 font-bold shadow-md shadow-orange-500/30'
                    : 'bg-[var(--color-surface)] text-[var(--color-text-muted)] border border-[var(--color-border)]'
                }`}
              >
                {day.hasActivity ? '🔥' : '○'}
              </div>
              <span className="text-[10px] font-mono">
                {day.isoDate.slice(8)}
              </span>
            </div>
          ))}
        </div>
      </div>

      {/* GitHub-style Contribution Heatmap Grid (35 Days) */}
      <div className="rounded-2xl border border-[var(--color-border)] bg-[var(--color-surface)] p-6">
        <div className="flex items-center justify-between mb-4">
          <div>
            <h2 className="font-heading text-base font-semibold text-[var(--color-text)] flex items-center gap-2">
              <TrendingUp className="h-4 w-4 text-[var(--color-accent)]" />
              <span>ประวัติการเรียนรู้แบบ Heatmap (35 วันย้อนหลัง)</span>
            </h2>
            <p className="text-xs text-[var(--color-text-muted)] mt-0.5">
              แสดงความถี่ของการอ่านบทเรียน, ทำควิซ และทบทวนแฟลชการ์ด
            </p>
          </div>
          <div className="hidden sm:flex items-center gap-1.5 text-[11px] text-[var(--color-text-muted)]">
            <span>น้อย</span>
            <span className="w-3 h-3 rounded-sm bg-[var(--color-surface-2)] border border-[var(--color-border)]" />
            <span className="w-3 h-3 rounded-sm bg-emerald-500/30 border border-emerald-500/40" />
            <span className="w-3 h-3 rounded-sm bg-emerald-500/60 border border-emerald-500/70" />
            <span className="w-3 h-3 rounded-sm bg-emerald-400 border border-emerald-300 shadow-sm" />
            <span>มาก</span>
          </div>
        </div>

        <div className="grid grid-cols-7 sm:grid-cols-7 gap-2 pt-2">
          {heatmapDays.map((day) => {
            let bgClass = 'bg-[var(--color-surface-2)] border-[var(--color-border)] text-[var(--color-text-muted)]';
            if (day.count === 1) bgClass = 'bg-emerald-500/30 border-emerald-500/40 text-emerald-300 font-semibold';
            else if (day.count === 2) bgClass = 'bg-emerald-500/60 border-emerald-500/70 text-emerald-100 font-bold';
            else if (day.count >= 3) bgClass = 'bg-emerald-400 border-emerald-300 text-slate-950 font-extrabold shadow-[0_0_8px_rgba(52,211,153,0.4)]';

            return (
              <div
                key={day.date}
                title={`${day.date}: ${day.count} กิจกรรม (บทเรียน: ${day.lessons}, ควิซ: ${day.quizzes}, การ์ด: ${day.flashcards})`}
                className={`p-2 rounded-lg border text-center transition-all flex flex-col items-center justify-center gap-1 cursor-pointer hover:scale-105 ${bgClass}`}
              >
                <span className="text-[10px] font-mono opacity-80">{day.date.slice(5)}</span>
                <span className="text-xs font-mono">{day.count > 0 ? day.count : '·'}</span>
              </div>
            );
          })}
        </div>
      </div>

      {/* Badges & Achievements Section */}
      <div className="rounded-2xl border border-[var(--color-border)] bg-[var(--color-surface)] p-6">
        <div className="flex items-center justify-between mb-5">
          <div>
            <h2 className="font-heading text-base font-semibold text-[var(--color-text)] flex items-center gap-2">
              <Award className="h-4 w-4 text-amber-400" />
              <span>เหรียญรางวัลและความสำเร็จ (Achievements)</span>
            </h2>
            <p className="text-xs text-[var(--color-text-muted)] mt-0.5">
              ปลดล็อกเหรียญตราเกียรติยศเมื่อบรรลุเป้าหมายการฝึกฝน
            </p>
          </div>
          <span className="text-xs font-mono font-medium text-amber-400 bg-amber-400/10 px-2.5 py-1 rounded-full border border-amber-400/20">
            ปลดล็อกแล้ว {badges.filter((b) => b.unlocked).length} / {badges.length}
          </span>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {badges.map((badge) => {
            const Icon = badge.icon;
            return (
              <div
                key={badge.id}
                className={`p-4 rounded-xl border transition-all flex items-start gap-3.5 ${
                  badge.unlocked
                    ? 'border-amber-400/30 bg-gradient-to-br from-amber-400/5 via-[var(--color-surface)] to-[var(--color-surface-2)] shadow-md shadow-amber-400/5'
                    : 'border-[var(--color-border)] bg-[var(--color-surface-2)]/50 opacity-60'
                }`}
              >
                <div
                  className={`p-2.5 rounded-xl shrink-0 transition-transform ${
                    badge.unlocked
                      ? `bg-gradient-to-br ${badge.color} text-slate-950 shadow-md`
                      : 'bg-[var(--color-surface)] text-[var(--color-text-muted)] border border-[var(--color-border)]'
                  }`}
                >
                  {badge.unlocked ? <Icon className="h-5 w-5" /> : <Lock className="h-5 w-5" />}
                </div>

                <div className="flex-1 min-w-0">
                  <div className="flex items-center justify-between gap-2">
                    <span className="font-heading text-xs font-bold text-[var(--color-text)] truncate">
                      {badge.title}
                    </span>
                    {badge.unlocked && (
                      <span className="text-[10px] font-semibold text-emerald-400 shrink-0">
                        ✓ ปลดล็อก
                      </span>
                    )}
                  </div>
                  <p className="text-[11px] text-[var(--color-text-muted)] mt-1 leading-snug">
                    {badge.desc}
                  </p>
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* Topic Mastery Progress Cards */}
      <div className="rounded-2xl border border-[var(--color-border)] bg-[var(--color-surface)] p-6">
        <h2 className="font-heading text-base font-semibold text-[var(--color-text)] mb-4">
          ความคืบหน้ารายหมวดหมู่ (Topic Mastery)
        </h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          {topics.map((t) => (
            <Link
              key={t.id}
              href={`/learn/${t.slug}`}
              className="group p-4 rounded-xl border border-[var(--color-border)] bg-[var(--color-surface-2)] hover:border-[var(--color-accent)] transition-colors"
            >
              <div className="flex items-center justify-between mb-2">
                <span className="font-heading text-sm font-semibold text-[var(--color-text)] group-hover:text-[var(--color-accent)] transition-colors">
                  {t.title}
                </span>
                <span className="text-xs font-mono font-medium text-[var(--color-text-muted)]">
                  {t.completed_lessons} / {t.total_lessons} บท
                </span>
              </div>

              {/* Progress Bar */}
              <div className="w-full h-2 rounded-full bg-[var(--color-surface)] overflow-hidden">
                <div
                  style={{ width: `${t.percentage}%` }}
                  className="h-full rounded-full bg-gradient-to-r from-cyan-400 to-blue-500 transition-all duration-500"
                />
              </div>

              <div className="mt-2 text-right text-[11px] font-mono text-[var(--color-accent)]">
                {t.percentage}% สำเร็จ
              </div>
            </Link>
          ))}
        </div>
      </div>

      {/* Action Shortcuts */}
      <div className="flex flex-col sm:flex-row items-center justify-between gap-4 p-5 rounded-2xl border border-[var(--color-border)] bg-[var(--color-surface-2)]">
        <div>
          <div className="font-heading text-sm font-semibold text-[var(--color-text)]">
            พร้อมสะสม Streak ต่อหรือยัง?
          </div>
          <div className="text-xs text-[var(--color-text-muted)]">
            เลือกโหมดที่ต้องการทบทวนวันนี้เพื่อรักษาระดับไฟของคุณ
          </div>
        </div>
        <div className="flex items-center gap-2.5 w-full sm:w-auto">
          <Link
            href="/learn"
            className="flex-1 sm:flex-none inline-flex items-center justify-center gap-1.5 px-4 py-2 rounded-lg bg-[var(--color-accent)] text-slate-950 font-semibold text-xs hover:bg-[var(--color-accent-hover)] transition-colors"
          >
            <BookOpen className="h-4 w-4" />
            <span>อ่านบทเรียน</span>
          </Link>
          <Link
            href="/quiz"
            className="flex-1 sm:flex-none inline-flex items-center justify-center gap-1.5 px-4 py-2 rounded-lg border border-[var(--color-border)] bg-[var(--color-surface)] text-[var(--color-text)] font-semibold text-xs hover:bg-[var(--color-surface-2)] transition-colors"
          >
            <HelpCircle className="h-4 w-4 text-emerald-400" />
            <span>ทำแบบทดสอบ</span>
          </Link>
        </div>
      </div>
    </main>
  );
}
