'use client';

import React, { useState, useRef, useEffect } from 'react';
import { Lab, World } from '@/lib/labs/types';
import { completeInput } from '@/lib/labs/engine';

export interface TerminalLogItem {
  id: string;
  prompt: string;
  command: string;
  stdout: string;
  stderr: string;
  exitCode: number;
}

interface TerminalProps {
  lab: Lab;
  world: World;
  logs: TerminalLogItem[];
  onExecute: (cmd: string) => void;
  onClear: () => void;
  onReset: () => void;
}

export default function Terminal({
  lab,
  world,
  logs,
  onExecute,
  onClear,
  onReset,
}: TerminalProps) {
  const [input, setInput] = useState('');
  const [historyIndex, setHistoryIndex] = useState<number>(-1);
  const [suggestions, setSuggestions] = useState<string[]>([]);

  const logContainerRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  const displayCwd =
    world.cwd === world.env.HOME
      ? '~'
      : world.cwd.startsWith(world.env.HOME + '/')
      ? '~' + world.cwd.slice(world.env.HOME.length)
      : world.cwd;

  const promptStr = `${world.user}@${world.hostname}:${displayCwd}$`;

  useEffect(() => {
    const el = logContainerRef.current;
    if (el) {
      el.scrollTop = el.scrollHeight;
    }
  }, [logs, suggestions]);

  const focusInput = () => {
    // Do not steal focus if user is selecting text
    const sel = window.getSelection();
    if (sel && sel.toString().length > 0) return;
    inputRef.current?.focus();
  };

  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.ctrlKey && (e.key === 'l' || e.key === 'L')) {
      e.preventDefault();
      setSuggestions([]);
      onClear();
      return;
    }

    if (e.ctrlKey && (e.key === 'c' || e.key === 'C')) {
      // Only cancel input if user has no text selected
      const sel = window.getSelection();
      if (!sel || sel.toString().length === 0) {
        e.preventDefault();
        setInput('');
        setHistoryIndex(-1);
        setSuggestions([]);
      }
      return;
    }

    if (e.key === 'Enter') {
      e.preventDefault();
      const cmd = input;
      setInput('');
      setHistoryIndex(-1);
      setSuggestions([]);
      onExecute(cmd);
      return;
    }

    if (e.key === 'Tab') {
      e.preventDefault();
      const res = completeInput(world, input);
      setInput(res.completed);
      if (res.suggestions.length > 1) {
        setSuggestions(res.suggestions);
      } else {
        setSuggestions([]);
      }
      return;
    }

    if (e.key === 'ArrowUp') {
      e.preventDefault();
      const cmdHistory = world.history.map((h) => h.command);
      if (cmdHistory.length === 0) return;
      const nextIdx =
        historyIndex === -1
          ? cmdHistory.length - 1
          : Math.max(0, historyIndex - 1);
      setHistoryIndex(nextIdx);
      setInput(cmdHistory[nextIdx] || '');
      setSuggestions([]);
      return;
    }

    if (e.key === 'ArrowDown') {
      e.preventDefault();
      const cmdHistory = world.history.map((h) => h.command);
      if (historyIndex === -1) return;
      if (historyIndex + 1 >= cmdHistory.length) {
        setHistoryIndex(-1);
        setInput('');
      } else {
        const nextIdx = historyIndex + 1;
        setHistoryIndex(nextIdx);
        setInput(cmdHistory[nextIdx] || '');
      }
      setSuggestions([]);
      return;
    }
  };

  return (
    <div className="flex flex-col h-full rounded-xl overflow-hidden border border-[var(--color-border)] bg-[#090d14] shadow-2xl shadow-black/50">
      {/* Header Bar with Traffic Light Dots */}
      <div className="flex items-center justify-between px-4 py-2.5 border-b border-[var(--color-border)] bg-[#101520] text-xs font-mono select-none">
        <div className="flex items-center gap-3">
          <div className="flex items-center gap-1.5" aria-hidden="true">
            <span className="w-3 h-3 rounded-full bg-[#ff5f56]/85 border border-[#e0443e]/40 shadow-sm" />
            <span className="w-3 h-3 rounded-full bg-[#ffbd2e]/85 border border-[#dea123]/40 shadow-sm" />
            <span className="w-3 h-3 rounded-full bg-[#27c93f]/85 border border-[#1aab29]/40 shadow-sm" />
          </div>

          <div className="flex items-center gap-2 pl-2 border-l border-white/10 text-xs">
            <span className="inline-block w-2 h-2 rounded-full bg-emerald-400 shadow-sm shadow-emerald-400/50 animate-pulse" />
            <span className="font-semibold text-slate-200">
              {world.user}@{world.hostname}
            </span>
            <span className="text-slate-500">:~ $</span>
            <span className="text-[11px] text-cyan-400 font-medium px-1.5 py-0.5 rounded bg-cyan-500/10 border border-cyan-500/20">
              bash
            </span>
          </div>
        </div>

        <div className="flex items-center gap-2">
          <button
            type="button"
            onClick={() => {
              setSuggestions([]);
              onClear();
              inputRef.current?.focus();
            }}
            className="px-2.5 py-1 rounded-md border border-white/10 bg-white/[0.04] text-slate-300 hover:bg-white/[0.08] hover:text-white hover:border-white/20 text-xs transition-colors"
          >
            ล้างจอ (Ctrl+L)
          </button>
          <button
            type="button"
            onClick={() => {
              setInput('');
              setHistoryIndex(-1);
              setSuggestions([]);
              onReset();
              inputRef.current?.focus();
            }}
            className="px-2.5 py-1 rounded-md border border-white/10 bg-white/[0.04] text-slate-300 hover:bg-white/[0.08] hover:text-white hover:border-white/20 text-xs transition-colors"
          >
            เริ่มใหม่
          </button>
        </div>
      </div>

      {/* Output Log Area */}
      <div
        ref={logContainerRef}
        role="log"
        aria-live="polite"
        aria-label={`ผลลัพธ์เทอร์มินัลของแล็บ ${lab.title}`}
        onClick={focusInput}
        className="flex-1 p-4 overflow-y-auto font-mono text-sm leading-relaxed cursor-text select-text space-y-3 text-[var(--color-text)]"
      >
        {/* Welcome banner */}
        <div className="pb-2 border-b border-[var(--color-border)] text-xs space-y-1 text-[var(--color-text-muted)]">
          <div>
            SupportLab Sandbox Environment — โฮสต์:{' '}
            <span style={{ color: '#58a6ff' }}>{lab.host.hostname}</span> (Ticket:{' '}
            <span style={{ color: '#f2cc60' }}>{lab.ticket.id}</span>)
          </div>
          <div>
            พิมพ์ <code style={{ color: '#79c0ff' }}>help</code> เพื่อดูคำสั่งที่รองรับ, กด{' '}
            <code style={{ color: '#79c0ff' }}>Tab</code> เพื่อเติมคำอัตโนมัติ, หรือกด{' '}
            <code style={{ color: '#79c0ff' }}>↑/↓</code> เพื่อเรียกคำสั่งก่อนหน้า
          </div>
        </div>

        {/* Command Output Entries */}
        {logs.map((entry) => (
          <div key={entry.id} className="space-y-1">
            <div className="flex flex-wrap items-baseline gap-2">
              <span className="font-semibold select-none" style={{ color: '#3fb950' }}>
                {entry.prompt}
              </span>
              <span className="whitespace-pre-wrap break-all" style={{ color: '#f0f6fc' }}>
                {entry.command}
              </span>
            </div>

            {entry.stdout && (
              <pre
                className="whitespace-pre-wrap break-words font-mono text-sm m-0"
                style={{ color: '#d2dae2' }}
              >
                {entry.stdout}
              </pre>
            )}

            {entry.stderr && (
              <pre
                className="whitespace-pre-wrap break-words font-mono text-sm m-0 pl-2 border-l-2"
                style={{
                  color: '#ffa198',
                  borderColor: '#f85149',
                }}
              >
                {entry.stderr}
              </pre>
            )}
          </div>
        ))}

        {/* Tab suggestions */}
        {suggestions.length > 1 && (
          <div className="py-1.5 px-3 rounded-md text-xs flex flex-wrap gap-3 bg-[var(--color-surface-2)] text-[var(--color-accent)] border border-[var(--color-border)]">
            {suggestions.map((s) => (
              <span key={s}>{s}</span>
            ))}
          </div>
        )}

        {/* Active Prompt Input Line */}
        <div className="flex items-center gap-2 pt-1">
          <label
            htmlFor="sandbox-terminal-input"
            className="font-semibold select-none shrink-0 text-sm flex items-center gap-0.5"
          >
            <span className="text-emerald-400 font-bold">{world.user}@{world.hostname}</span>
            <span className="text-slate-400">:</span>
            <span className="text-sky-400 font-semibold">{displayCwd}</span>
            <span className="text-slate-200 font-bold">$</span>
          </label>
          <input
            id="sandbox-terminal-input"
            ref={inputRef}
            type="text"
            value={input}
            onChange={(e) => setInput(e.target.value)}
            onKeyDown={handleKeyDown}
            autoComplete="off"
            autoCorrect="off"
            autoCapitalize="off"
            spellCheck={false}
            aria-label="ป้อนคำสั่ง Linux"
            placeholder="พิมพ์คำสั่งที่นี่..."
            className="flex-1 bg-transparent border-none outline-none font-mono text-sm text-slate-100 caret-cyan-400 placeholder:text-slate-600"
          />
        </div>
      </div>
    </div>
  );
}
