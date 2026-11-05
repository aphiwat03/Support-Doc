'use client';

import React, { useEffect, useState } from 'react';

export interface TOCItem {
  id: string;
  text: string;
  level: number;
}

export function slugifyHeading(text: string): string {
  return text
    .toLowerCase()
    .replace(/[^\w\u0E00-\u0E7F]+/g, '-')
    .replace(/^-+|-+$/g, '');
}

export function extractHeadings(content: string): TOCItem[] {
  const lines = content.split('\n');
  const headings: TOCItem[] = [];

  for (const line of lines) {
    const trimmed = line.trim();
    if (trimmed.startsWith('## ') && !trimmed.startsWith('### ')) {
      const text = trimmed.replace(/^##\s+/, '').trim();
      headings.push({ id: slugifyHeading(text), text, level: 2 });
    } else if (trimmed.startsWith('### ')) {
      const text = trimmed.replace(/^###\s+/, '').trim();
      headings.push({ id: slugifyHeading(text), text, level: 3 });
    }
  }

  return headings;
}

interface OnThisPageProps {
  headings: TOCItem[];
}

export const OnThisPage: React.FC<OnThisPageProps> = ({ headings }) => {
  const [activeId, setActiveId] = useState<string>('');

  useEffect(() => {
    if (headings.length === 0) return;

    const observer = new IntersectionObserver(
      (entries) => {
        const visibleEntries = entries.filter((e) => e.isIntersecting);
        if (visibleEntries.length > 0) {
          setActiveId(visibleEntries[0].target.id);
        }
      },
      {
        rootMargin: '-80px 0px -60% 0px',
        threshold: 0,
      }
    );

    headings.forEach((h) => {
      const el = document.getElementById(h.id);
      if (el) observer.observe(el);
    });

    return () => observer.disconnect();
  }, [headings]);

  if (headings.length === 0) return null;

  return (
    <nav
      aria-label="ในหน้านี้"
      className="w-56 shrink-0 self-start sticky top-14 max-h-[calc(100vh-3.5rem)] overflow-y-auto p-4 hidden xl:block text-xs"
    >
      <div className="font-heading font-semibold text-[var(--color-text)] uppercase tracking-wider mb-3 text-[11px]">
        ในหน้านี้
      </div>

      <div className="space-y-1.5 border-l border-[var(--color-border)] pl-3">
        {headings.map((h) => {
          const isActive = activeId === h.id;

          return (
            <a
              key={h.id}
              href={`#${h.id}`}
              className={`block leading-snug transition-colors ${
                h.level === 3 ? 'pl-2 text-[11px]' : ''
              } ${
                isActive
                  ? 'text-[var(--color-accent)] font-medium -ml-[13px] pl-[11px] border-l-2 border-[var(--color-accent)]'
                  : 'text-[var(--color-text-muted)] hover:text-[var(--color-text)]'
              }`}
            >
              {h.text}
            </a>
          );
        })}
      </div>
    </nav>
  );
};
