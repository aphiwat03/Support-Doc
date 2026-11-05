'use client';

import React from 'react';
import { Flame } from 'lucide-react';

interface StreakVisualProps {
  days: number;
  state?: 'active' | 'at-risk' | 'lost';
  size?: 'sm' | 'md' | 'lg';
  className?: string;
}

/**
 * คอมโพเนนต์แสดงภาพ/เอฟเฟกต์ไฟ Streak
 * ออกแบบโครงสร้างแยกเป็นโมดูลกลาง เพื่อให้ในอนาคตสามารถสลับเป็น 3D Canvas / WebP / Lottie VFX ได้สะดวก
 */
export const StreakVisual: React.FC<StreakVisualProps> = ({
  days,
  state = 'active',
  size = 'md',
  className = '',
}) => {
  const sizeMap = {
    sm: { icon: 'h-6 w-6', container: 'h-10 w-10 text-sm' },
    md: { icon: 'h-10 w-10', container: 'h-16 w-16 text-lg' },
    lg: { icon: 'h-20 w-20', container: 'h-32 w-32 text-3xl' },
  };

  const currentSize = sizeMap[size];

  // Visual Styling depending on state
  const isStudied = state === 'active' && days > 0;

  return (
    <div className={`relative flex items-center justify-center ${className}`}>
      {/* Background Ambient Glow */}
      {isStudied && (
        <div 
          className="absolute inset-0 rounded-full blur-2xl opacity-60 bg-gradient-to-tr from-amber-500 via-orange-500 to-rose-500 animate-pulse pointer-events-none"
        />
      )}

      {/* Main Container */}
      <div 
        className={`relative flex items-center justify-center rounded-2xl border transition-all duration-300 ${currentSize.container} ${
          isStudied
            ? 'bg-gradient-to-b from-amber-500/20 via-orange-500/10 to-transparent border-orange-500/40 shadow-lg shadow-orange-500/20 text-orange-400'
            : 'bg-[var(--color-surface)] border-[var(--color-border)] text-[var(--color-text-muted)]'
        }`}
      >
        <Flame 
          className={`${currentSize.icon} ${
            isStudied 
              ? 'fill-orange-400 text-amber-300 animate-bounce' 
              : 'opacity-40'
          }`} 
        />
      </div>
    </div>
  );
};
