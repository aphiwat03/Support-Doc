export type FlameTierId = 'cold' | 'spark' | 'warm' | 'blazing' | 'blue-core' | 'legendary';

export interface FlameTierConfig {
  id: FlameTierId;
  label: string;
  scale: number;
  speed: number;
  emberCount: number;
  coreColor: [number, number, number]; // RGB 0..1
  midColor: [number, number, number]; // RGB 0..1
  tipColor: [number, number, number]; // RGB 0..1
  glowHex: string;
  glowIntensity: number;
}

function hexToRgbNormalized(hex: string): [number, number, number] {
  const clean = hex.replace('#', '');
  const num = parseInt(clean, 16);
  const r = ((num >> 16) & 255) / 255;
  const g = ((num >> 8) & 255) / 255;
  const b = (num & 255) / 255;
  return [
    Math.round(r * 1000) / 1000,
    Math.round(g * 1000) / 1000,
    Math.round(b * 1000) / 1000,
  ];
}

/**
 * Pure function mapping streak days to 3D flame visual parameters
 * per ROADMAP_PHASE_9_10.md Section 9.3.
 */
export function getFlameTier(daysInput: number): FlameTierConfig {
  const safeDays =
    typeof daysInput === 'number' && Number.isFinite(daysInput) && daysInput > 0
      ? Math.floor(daysInput)
      : 0;

  if (safeDays === 0) {
    return {
      id: 'cold',
      label: 'เริ่มบทเรียนวันนี้เพื่อจุดไฟ',
      scale: 0.35,
      speed: 0.4,
      emberCount: 0,
      coreColor: hexToRgbNormalized('#64748b'),
      midColor: hexToRgbNormalized('#475569'),
      tipColor: hexToRgbNormalized('#334155'),
      glowHex: '#475569',
      glowIntensity: 0.15,
    };
  }

  if (safeDays <= 2) {
    return {
      id: 'spark',
      label: 'ประกายไฟเริ่มต้น',
      scale: 0.55,
      speed: 0.85,
      emberCount: 8,
      coreColor: hexToRgbNormalized('#fde047'),
      midColor: hexToRgbNormalized('#f59e0b'),
      tipColor: hexToRgbNormalized('#ea580c'),
      glowHex: '#f59e0b',
      glowIntensity: 0.45,
    };
  }

  if (safeDays <= 6) {
    return {
      id: 'warm',
      label: 'กำลังก่อไฟต่อเนื่อง',
      scale: 0.75,
      speed: 1.05,
      emberCount: 16,
      coreColor: hexToRgbNormalized('#fef08a'),
      midColor: hexToRgbNormalized('#f97316'),
      tipColor: hexToRgbNormalized('#dc2626'),
      glowHex: '#f97316',
      glowIntensity: 0.65,
    };
  }

  if (safeDays <= 29) {
    return {
      id: 'blazing',
      label: 'วินัยระดับไฟลุกโชน',
      scale: 0.9,
      speed: 1.25,
      emberCount: 28,
      coreColor: hexToRgbNormalized('#ffffff'),
      midColor: hexToRgbNormalized('#fb923c'),
      tipColor: hexToRgbNormalized('#e11d48'),
      glowHex: '#fb923c',
      glowIntensity: 0.8,
    };
  }

  if (safeDays <= 99) {
    return {
      id: 'blue-core',
      label: 'แกนไฟสีฟ้าความร้อนสูง',
      scale: 1.0,
      speed: 1.45,
      emberCount: 40,
      coreColor: hexToRgbNormalized('#38bdf8'),
      midColor: hexToRgbNormalized('#fde047'),
      tipColor: hexToRgbNormalized('#f97316'),
      glowHex: '#38bdf8',
      glowIntensity: 0.95,
    };
  }

  return {
    id: 'legendary',
    label: 'เปลวไฟระดับตำนาน 100+ วัน',
    scale: 1.08,
    speed: 1.65,
    emberCount: 48,
    coreColor: hexToRgbNormalized('#e0f2fe'),
    midColor: hexToRgbNormalized('#6366f1'),
    tipColor: hexToRgbNormalized('#f59e0b'),
    glowHex: '#818cf8',
    glowIntensity: 1.0,
  };
}
