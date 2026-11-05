'use client';

import React, { useState, useMemo } from 'react';
import { Check, Copy, Terminal as TerminalIcon, Code2 } from 'lucide-react';
import hljs from 'highlight.js';
import { toast } from 'sonner';

interface CodeBlockProps {
  language?: string;
  code: string;
}

export const CodeBlock: React.FC<CodeBlockProps> = ({ language, code }) => {
  const [copied, setCopied] = useState(false);

  const cleanLang = (language || '').toLowerCase().trim();
  const isTerminal = useMemo(() => {
    if (['bash', 'sh', 'shell', 'zsh', 'terminal', 'console', 'cli'].includes(cleanLang)) {
      return true;
    }
    // Auto-detect terminal prompt lines like "$ command"
    const lines = code.trim().split('\n');
    return lines.some((l) => l.trim().startsWith('$ ') || l.trim().startsWith('curl ') || l.trim().startsWith('docker '));
  }, [cleanLang, code]);

  const handleCopy = async () => {
    try {
      // If code contains $ prompt, also offer clean command copy
      await navigator.clipboard.writeText(code);
      setCopied(true);
      toast.success('คัดลอกคำสั่งเรียบร้อยแล้ว', { duration: 1800 });
      setTimeout(() => setCopied(false), 2000);
    } catch (err) {
      console.error('Failed to copy code:', err);
      toast.error('ไม่สามารถคัดลอกได้');
    }
  };

  // Format terminal output with authentic prompt, comments, and colored outputs
  const terminalLines = useMemo(() => {
    if (!isTerminal) return null;

    const lines = code.split('\n');
    return lines.map((line, idx) => {
      const trimmed = line.trim();

      // Empty line
      if (!trimmed) {
        return <div key={idx} className="h-4" />;
      }

      // Comment line e.g. "# 1. ตรวจสอบ..."
      if (trimmed.startsWith('#')) {
        return (
          <div key={idx} className="text-slate-400 italic select-none py-0.5 font-normal">
            {line}
          </div>
        );
      }

      // Shell Command line starting with "$ "
      if (trimmed.startsWith('$ ')) {
        const cmdText = line.replace(/^\s*\$\s/, '');
        return (
          <div key={idx} className="flex items-start gap-2 py-0.5">
            <span className="text-cyan-400 font-bold select-none shrink-0">$</span>
            <span className="text-slate-100 font-semibold font-mono tracking-tight">{cmdText}</span>
          </div>
        );
      }

      // Root Command line starting with "# "
      if (line.startsWith('# ') && !trimmed.startsWith('# 1.') && !trimmed.startsWith('# 2.')) {
        const cmdText = line.slice(2);
        return (
          <div key={idx} className="flex items-start gap-2 py-0.5">
            <span className="text-rose-400 font-bold select-none shrink-0">#</span>
            <span className="text-slate-100 font-semibold font-mono tracking-tight">{cmdText}</span>
          </div>
        );
      }

      // Output Lines with intelligent status highlighting
      let outputClass = 'text-slate-300 font-normal py-0.5 leading-relaxed';
      if (/permission denied|failed|error|fatal|down|refused|timed out/i.test(line)) {
        outputClass = 'text-rose-400/90 font-medium py-0.5 leading-relaxed';
      } else if (/100%|connection established|active \(running\)|up \d|success/i.test(line)) {
        outputClass = 'text-emerald-400/90 font-medium py-0.5 leading-relaxed';
      } else if (/debug\d?:|info:|notice:/i.test(line)) {
        outputClass = 'text-slate-400 py-0.5 leading-relaxed';
      } else if (/warning|warn/i.test(line)) {
        outputClass = 'text-amber-400/90 py-0.5 leading-relaxed';
      }

      return (
        <div key={idx} className={outputClass}>
          {line}
        </div>
      );
    });
  }, [code, isTerminal]);

  // Standard Highlight.js for programming languages (SQL, Python, etc.)
  const highlightedCode = useMemo(() => {
    if (isTerminal || !code) return '';
    if (!cleanLang) {
      try {
        return hljs.highlightAuto(code).value;
      } catch {
        return '';
      }
    }
    if (hljs.getLanguage(cleanLang)) {
      try {
        return hljs.highlight(code, { language: cleanLang, ignoreIllegals: true }).value;
      } catch {
        return '';
      }
    }
    try {
      return hljs.highlightAuto(code).value;
    } catch {
      return '';
    }
  }, [code, cleanLang, isTerminal]);

  return (
    <div className="my-6 rounded-xl border border-[var(--color-border)] bg-[#090d14] shadow-2xl shadow-black/50 overflow-hidden transition-all hover:border-[var(--color-border)]/80">
      {/* Terminal Window Header Bar */}
      <div className="flex items-center justify-between px-4 py-2.5 border-b border-[var(--color-border)] bg-[#101520] text-xs font-mono select-none">
        {/* Left: Window Traffic Light Dots + Title Badge */}
        <div className="flex items-center gap-3">
          <div className="flex items-center gap-1.5" aria-hidden="true">
            <span className="w-3 h-3 rounded-full bg-[#ff5f56]/85 border border-[#e0443e]/40 shadow-sm" />
            <span className="w-3 h-3 rounded-full bg-[#ffbd2e]/85 border border-[#dea123]/40 shadow-sm" />
            <span className="w-3 h-3 rounded-full bg-[#27c93f]/85 border border-[#1aab29]/40 shadow-sm" />
          </div>

          <div className="flex items-center gap-1.5 pl-1.5 border-l border-white/10 text-[var(--color-text-muted)] text-[11.5px]">
            {isTerminal ? (
              <TerminalIcon className="h-3.5 w-3.5 text-cyan-400" />
            ) : (
              <Code2 className="h-3.5 w-3.5 text-amber-400" />
            )}
            <span className="font-semibold tracking-wider uppercase text-slate-300">
              {cleanLang || (isTerminal ? 'bash' : 'code')}
            </span>
            <span className="text-slate-600 font-light">•</span>
            <span className="text-[11px] text-slate-400 lowercase">
              {isTerminal ? 'terminal session' : 'syntax'}
            </span>
          </div>
        </div>

        {/* Right: Modern Copy Button */}
        <button
          onClick={handleCopy}
          aria-label={copied ? 'คัดลอกเรียบร้อยแล้ว' : 'คัดลอกโค้ด'}
          className={`flex items-center gap-1.5 px-2.5 py-1 rounded-md text-[11.5px] font-medium transition-all ${
            copied
              ? 'bg-emerald-500/15 text-emerald-400 border border-emerald-500/30 shadow-sm shadow-emerald-500/10'
              : 'border border-white/10 bg-white/[0.04] text-slate-300 hover:bg-white/[0.08] hover:text-white hover:border-white/20 active:scale-95'
          }`}
        >
          {copied ? (
            <>
              <Check className="h-3.5 w-3.5 text-emerald-400" />
              <span>คัดลอกแล้ว</span>
            </>
          ) : (
            <>
              <Copy className="h-3.5 w-3.5 text-slate-400" />
              <span>คัดลอก</span>
            </>
          )}
        </button>
      </div>

      {/* Code / Terminal Output Area */}
      <div className="p-4 sm:p-5 overflow-x-auto text-[13.5px] sm:text-[14px] font-mono leading-[1.7] text-[var(--color-text)]">
        {isTerminal && terminalLines ? (
          <div className="space-y-0.5">{terminalLines}</div>
        ) : highlightedCode ? (
          <pre className="m-0 p-0 overflow-visible bg-transparent font-mono">
            <code
              dangerouslySetInnerHTML={{ __html: highlightedCode }}
              className={`hljs ${cleanLang ? `language-${cleanLang}` : ''}`}
            />
          </pre>
        ) : (
          <pre className="m-0 p-0 overflow-visible bg-transparent font-mono">
            <code>{code}</code>
          </pre>
        )}
      </div>
    </div>
  );
};
