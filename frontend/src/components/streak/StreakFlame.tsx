'use client';

import React, { useEffect, useState } from 'react';
import dynamic from 'next/dynamic';
import { getFlameTier } from './flameTier';
import { StreakVisual } from './StreakVisual';

const FlameScene = dynamic(() => import('./FlameScene'), {
  ssr: false,
  loading: () => (
    <div className="w-full h-full flex items-center justify-center">
      <StreakVisual days={1} size="lg" />
    </div>
  ),
});

interface StreakFlameProps {
  days: number;
}

function detectWebGLAvailable(): boolean {
  if (typeof window === 'undefined') return false;
  try {
    const canvas = document.createElement('canvas');
    const gl =
      canvas.getContext('webgl2') ||
      canvas.getContext('webgl') ||
      canvas.getContext('experimental-webgl');
    return !!gl;
  } catch {
    return false;
  }
}

export default function StreakFlame({ days }: StreakFlameProps) {
  const tier = getFlameTier(days);
  const [canRender3D, setCanRender3D] = useState(false);

  useEffect(() => {
    const mediaQuery = window.matchMedia('(prefers-reduced-motion: reduce)');
    const updateCapability = () => {
      if (mediaQuery.matches) {
        setCanRender3D(false);
        return;
      }
      setCanRender3D(detectWebGLAvailable());
    };

    updateCapability();
    mediaQuery.addEventListener('change', updateCapability);
    return () => mediaQuery.removeEventListener('change', updateCapability);
  }, []);

  return (
    <div className="flex flex-col items-center">
      {/* Screen-reader accessible status */}
      <span className="sr-only">
        เรียนต่อเนื่อง {days} วัน — สถานะเปลวไฟ: {tier.label}
      </span>

      {/* Fixed-size container (220px mobile, 260px desktop) for zero layout shift */}
      <div
        className="relative w-[220px] h-[220px] sm:w-[260px] sm:h-[260px] flex items-center justify-center rounded-2xl border overflow-hidden"
        style={{
          background: 'rgba(13, 17, 23, 0.55)',
          borderColor: 'var(--border)',
        }}
        aria-hidden="true"
      >
        {canRender3D ? (
          <FlameScene days={days} tier={tier} />
        ) : (
          <StreakVisual days={days} size="lg" />
        )}
      </div>

      {/* Tier Caption */}
      <div
        className="mt-2.5 text-xs font-semibold font-mono text-center"
        style={{ color: tier.glowHex }}
      >
        {tier.label}
      </div>
    </div>
  );
}
