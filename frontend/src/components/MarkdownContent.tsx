'use client';

import React, { useState, useMemo, useCallback } from 'react';
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import rehypeRaw from 'rehype-raw';
import { Hash, Image as ImageIcon, Maximize2, X } from 'lucide-react';
import { CodeBlock } from './CodeBlock';
import { Callout } from './Callout';
import { slugifyHeading } from './OnThisPage';

interface MarkdownContentProps {
  content: string;
}

function getNodeText(node: any): string {
  if (!node) return '';
  if (typeof node === 'string') return node;
  if (Array.isArray(node)) return node.map(getNodeText).join('');
  if (node.props?.children) return getNodeText(node.props.children);
  return '';
}

// Global cache for images that 404 to avoid layout flicker/thrashing across renders
const brokenImageCache = new Set<string>();

interface MarkdownImageFigureProps {
  src?: string;
  alt?: string;
  onZoom: (src: string, alt: string) => void;
}

const MarkdownImageFigure = React.memo<MarkdownImageFigureProps>(({ src, alt, onZoom }) => {
  const [hasError, setHasError] = useState(() => (src ? brokenImageCache.has(src) : false));

  if (!src) return null;

  const fileName = src.split('/').pop() || src;

  const handleError = () => {
    if (src) brokenImageCache.add(src);
    setHasError(true);
  };

  if (hasError) {
    return (
      <span className="block my-6 rounded-xl border border-dashed border-amber-500/40 bg-[var(--color-surface)] p-5 text-left min-h-[96px]">
        <span className="flex items-start gap-3.5">
          <span className="p-2.5 rounded-lg bg-amber-500/10 text-amber-400 border border-amber-500/20 shrink-0">
            <ImageIcon className="h-5 w-5" />
          </span>
          <span className="space-y-1.5 min-w-0 flex-1">
            <span className="block font-heading text-sm font-semibold text-[var(--color-text)]">
              {alt || 'ภาพประกอบบทเรียน'}
            </span>
            <span className="block text-xs text-[var(--color-text-muted)] leading-relaxed">
              วางไฟล์รูปภาพชื่อ{' '}
              <code className="px-1.5 py-0.5 rounded bg-[var(--color-surface-2)] text-amber-400 font-mono border border-[var(--color-border)]">
                {fileName}
              </code>{' '}
              ไว้ที่โฟลเดอร์{' '}
              <code className="px-1.5 py-0.5 rounded bg-[var(--color-surface-2)] text-[var(--color-accent)] font-mono border border-[var(--color-border)]">
                frontend/public{src.substring(0, src.lastIndexOf('/') + 1)}
              </code>{' '}
              แล้วรีเฟรชหน้านี้เพื่อแสดงภาพ
            </span>
          </span>
        </span>
      </span>
    );
  }

  return (
    <span className="block my-6 rounded-xl overflow-hidden border border-[var(--color-border)] bg-[var(--color-surface)] shadow-md min-h-[140px]">
      <span
        role="button"
        tabIndex={0}
        onClick={() => onZoom(src, alt || fileName)}
        onKeyDown={(e) => {
          if (e.key === 'Enter' || e.key === ' ') {
            e.preventDefault();
            onZoom(src, alt || fileName);
          }
        }}
        className="group relative block w-full bg-slate-950/60 cursor-zoom-in overflow-hidden"
      >
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img
          src={src}
          alt={alt || fileName}
          onError={handleError}
          className="w-full max-h-[440px] object-contain mx-auto transition-transform duration-300 group-hover:scale-[1.015]"
        />
        <span className="absolute top-3 right-3 p-1.5 rounded-lg bg-slate-900/80 border border-white/10 text-slate-200 opacity-0 group-hover:opacity-100 transition-opacity">
          <Maximize2 className="h-4 w-4" />
        </span>
      </span>
      {alt && (
        <span className="block px-4 py-2.5 text-xs text-[var(--color-text-muted)] border-t border-[var(--color-border)] bg-[var(--color-surface-2)]/50 text-center">
          {alt}
        </span>
      )}
    </span>
  );
});

MarkdownImageFigure.displayName = 'MarkdownImageFigure';

export const MarkdownContent = React.memo<MarkdownContentProps>(({ content }) => {
  const [zoomedImage, setZoomedImage] = useState<{ src: string; alt: string } | null>(null);

  const handleZoom = useCallback((src: string, alt: string) => {
    setZoomedImage({ src, alt });
  }, []);

  // บังคับให้ icon ⚠️ ตัดขึ้นบรรทัดใหม่เสมอ (New Line Break)
  const formattedContent = useMemo(() => {
    return content
      .split('\n')
      .map((line) => {
        if (
          line.includes('⚠️') &&
          !line.trim().startsWith('⚠️') &&
          !line.trim().startsWith('> ⚠️') &&
          !line.trim().startsWith('```')
        ) {
          return line.replace(/\s*(⚠️[^\n]*)/g, '\n\n$1');
        }
        return line;
      })
      .join('\n');
  }, [content]);

  const components = useMemo(
    () => ({
      h1: ({ children }: any) => {
        const text = getNodeText(children);
        const id = slugifyHeading(text);
        return (
          <h1
            id={id}
            className="font-heading text-2xl sm:text-3xl font-bold text-[var(--color-text)] mt-8 mb-4 scroll-mt-20 leading-[1.35]"
          >
            {children}
          </h1>
        );
      },
      h2: ({ children }: any) => {
        const text = getNodeText(children);
        const id = slugifyHeading(text);
        return (
          <h2
            id={id}
            className="group font-heading text-xl sm:text-2xl font-semibold text-[var(--color-text)] mt-10 mb-3 pt-6 border-t border-[var(--color-border)] scroll-mt-20 leading-[1.4] flex items-center gap-2"
          >
            <span>{children}</span>
            <a
              href={`#${id}`}
              aria-label={`ลิงก์ตรงไปยัง ${text}`}
              className="opacity-0 group-hover:opacity-100 text-[var(--color-text-muted)] hover:text-[var(--color-accent)] transition-opacity p-1"
            >
              <Hash className="h-4 w-4" />
            </a>
          </h2>
        );
      },
      h3: ({ children }: any) => {
        const text = getNodeText(children);
        const id = slugifyHeading(text);
        return (
          <h3
            id={id}
            className="font-heading text-lg font-semibold text-[var(--color-text)] mt-6 mb-2 scroll-mt-20 leading-[1.45]"
          >
            {children}
          </h3>
        );
      },
      p: ({ children }: any) => {
        return (
          <p className="font-body text-[16px] text-[var(--color-text)] leading-[1.75] mb-4 max-w-[44rem] [text-wrap:pretty]">
            {children}
          </p>
        );
      },
      img: ({ src, alt }: any) => (
        <MarkdownImageFigure
          src={typeof src === 'string' ? src : undefined}
          alt={typeof alt === 'string' ? alt : undefined}
          onZoom={handleZoom}
        />
      ),
      ul: ({ children }: any) => (
        <ul className="list-disc pl-5 mb-4 space-y-2 text-[15px] sm:text-[16px] text-[var(--color-text)] max-w-[44rem] marker:text-[var(--color-text-muted)]">
          {children}
        </ul>
      ),
      ol: ({ children }: any) => (
        <ol className="list-decimal pl-5 mb-4 space-y-2 text-[15px] sm:text-[16px] text-[var(--color-text)] max-w-[44rem] marker:text-[var(--color-text-muted)]">
          {children}
        </ol>
      ),
      li: ({ children }: any) => (
        <li className="leading-[1.75] pl-1">{children}</li>
      ),
      code: ({ className, children }: any) => {
        const isCodeBlock = className && className.startsWith('language-');
        if (isCodeBlock) {
          const language = className.replace(/^language-/, '');
          const rawCode = String(children).replace(/\n$/, '');
          return <CodeBlock language={language} code={rawCode} />;
        }

        // Inline code
        const raw = String(children);
        if (!raw.includes('\n')) {
          return (
            <code className="bg-[var(--color-surface-2)] text-[var(--color-accent)] px-1.5 py-0.5 rounded text-[0.9em] font-mono border border-[var(--color-border)]">
              {children}
            </code>
          );
        }

        return <CodeBlock code={raw} />;
      },
      blockquote: ({ children }: any) => {
        const textContent = getNodeText(children);

        if (textContent.includes('⚠️')) {
          return <Callout type="warning">{children}</Callout>;
        }

        if (textContent.includes('Support Tip')) {
          return <Callout type="tip">{children}</Callout>;
        }

        return <Callout type="quote">{children}</Callout>;
      },
      table: ({ children }: any) => (
        <div className="overflow-x-auto my-6 rounded-lg border border-[var(--color-border)] shadow-sm bg-[var(--color-surface)]">
          <table className="w-full text-left text-sm text-[var(--color-text)] border-collapse">
            {children}
          </table>
        </div>
      ),
      thead: ({ children }: any) => (
        <thead className="bg-[var(--color-surface-2)] border-b border-[var(--color-border)] text-[var(--color-text)] font-heading">
          {children}
        </thead>
      ),
      tbody: ({ children }: any) => (
        <tbody className="divide-y divide-[var(--color-border)]">
          {children}
        </tbody>
      ),
      tr: ({ children }: any) => (
        <tr className="hover:bg-[var(--color-surface-2)]/50 transition-colors">
          {children}
        </tr>
      ),
      th: ({ children }: any) => (
        <th className="px-4 py-3 font-semibold text-xs uppercase tracking-wider text-[var(--color-text-muted)]">
          {children}
        </th>
      ),
      td: ({ children }: any) => (
        <td className="px-4 py-3 leading-relaxed text-sm text-[var(--color-text)] align-top">
          {children}
        </td>
      ),
      a: ({ href, children }: any) => (
        <a
          href={href}
          className="text-[var(--color-accent)] hover:underline underline-offset-2 transition-colors font-medium"
          target={href?.startsWith('http') ? '_blank' : undefined}
          rel={href?.startsWith('http') ? 'noopener noreferrer' : undefined}
        >
          {children}
        </a>
      ),
      hr: () => (
        <hr className="my-8 border-t border-[var(--color-border)]" />
      ),
    }),
    [handleZoom]
  );

  return (
    <div className="prose prose-invert max-w-none text-[var(--color-text)]">
      <ReactMarkdown
        remarkPlugins={[remarkGfm]}
        rehypePlugins={[rehypeRaw]}
        components={components}
      >
        {formattedContent}
      </ReactMarkdown>

      {/* Lightbox Modal for Zooming Images */}
      {zoomedImage && (
        <div
          role="dialog"
          aria-modal="true"
          aria-label={zoomedImage.alt}
          onClick={() => setZoomedImage(null)}
          className="fixed inset-0 z-50 flex items-center justify-center bg-black/85 backdrop-blur-sm p-4 sm:p-8 cursor-zoom-out"
        >
          <div
            onClick={(e) => e.stopPropagation()}
            className="relative max-w-5xl w-full rounded-2xl overflow-hidden border border-[var(--color-border)] bg-[var(--color-surface)] shadow-2xl cursor-default"
          >
            <div className="flex items-center justify-between px-4 py-3 border-b border-[var(--color-border)] bg-[var(--color-surface-2)]">
              <span className="font-heading text-xs sm:text-sm font-semibold text-[var(--color-text)] truncate pr-4">
                {zoomedImage.alt}
              </span>
              <button
                type="button"
                onClick={() => setZoomedImage(null)}
                aria-label="ปิดภาพขยาย"
                className="p-1.5 rounded-lg text-[var(--color-text-muted)] hover:text-[var(--color-text)] hover:bg-[var(--color-surface)] transition-colors"
              >
                <X className="h-4 w-4" />
              </button>
            </div>
            <div className="p-4 bg-slate-950 flex items-center justify-center">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img
                src={zoomedImage.src}
                alt={zoomedImage.alt}
                className="max-h-[80vh] w-auto object-contain"
              />
            </div>
          </div>
        </div>
      )}
    </div>
  );
});

MarkdownContent.displayName = 'MarkdownContent';
