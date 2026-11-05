import React from 'react';
import { AlertTriangle, Lightbulb } from 'lucide-react';

interface CalloutProps {
  type: 'warning' | 'tip' | 'quote';
  children: React.ReactNode;
}

export const Callout: React.FC<CalloutProps> = ({ type, children }) => {
  if (type === 'warning') {
    return (
      <aside className="my-5 rounded-r-md border-l-[3px] border-[var(--color-warn)] bg-[var(--color-warn-bg)] p-3.5 sm:p-4 text-sm text-[var(--color-text)]">
        <div className="flex items-center gap-2 font-semibold text-[var(--color-warn)] mb-1 text-xs uppercase tracking-wider">
          <AlertTriangle className="h-4 w-4 shrink-0" />
          <span>คำเตือนความปลอดภัย (Warning)</span>
        </div>
        <div className="leading-relaxed [&>p]:mb-0 [&>p]:leading-relaxed">{children}</div>
      </aside>
    );
  }

  if (type === 'tip') {
    return (
      <aside className="my-5 rounded-r-md border-l-[3px] border-[var(--color-accent)] bg-[rgba(34,211,238,0.06)] p-3.5 sm:p-4 text-sm text-[var(--color-text)]">
        <div className="flex items-center gap-1.5 font-semibold text-[var(--color-accent)] mb-1 text-xs uppercase tracking-wider">
          <Lightbulb className="h-4 w-4 shrink-0" />
          <span>Support Tip</span>
        </div>
        <div className="leading-relaxed [&>p]:mb-0 [&>p]:leading-relaxed">{children}</div>
      </aside>
    );
  }

  return (
    <blockquote className="my-5 rounded-r-md border-l-[3px] border-[var(--color-border)] bg-[var(--color-surface)] p-3.5 sm:p-4 text-sm text-[var(--color-text-muted)] italic leading-relaxed [&>p]:mb-0">
      {children}
    </blockquote>
  );
};
