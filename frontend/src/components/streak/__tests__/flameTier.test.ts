import { describe, it, expect } from 'vitest';
import { getFlameTier } from '../flameTier';

describe('Phase 9 — getFlameTier(days) Pure Function', () => {
  it('returns cold tier for 0 days', () => {
    const tier = getFlameTier(0);
    expect(tier.id).toBe('cold');
    expect(tier.emberCount).toBe(0);
    expect(tier.scale).toBeLessThan(0.5);
  });

  it('returns spark tier for 1-2 days', () => {
    expect(getFlameTier(1).id).toBe('spark');
    expect(getFlameTier(2).id).toBe('spark');
    expect(getFlameTier(1).emberCount).toBeGreaterThan(0);
  });

  it('returns warm tier for 3-6 days', () => {
    expect(getFlameTier(3).id).toBe('warm');
    expect(getFlameTier(6).id).toBe('warm');
    expect(getFlameTier(3).scale).toBeGreaterThan(getFlameTier(2).scale);
  });

  it('returns blazing tier for 7-29 days', () => {
    expect(getFlameTier(7).id).toBe('blazing');
    expect(getFlameTier(14).id).toBe('blazing');
    expect(getFlameTier(29).id).toBe('blazing');
  });

  it('returns blue-core tier for 30-99 days', () => {
    expect(getFlameTier(30).id).toBe('blue-core');
    expect(getFlameTier(99).id).toBe('blue-core');
    expect(getFlameTier(30).glowHex).toBe('#38bdf8');
  });

  it('returns legendary tier for 100+ days', () => {
    const t100 = getFlameTier(100);
    const t365 = getFlameTier(365);
    expect(t100.id).toBe('legendary');
    expect(t365.id).toBe('legendary');
    expect(t100.emberCount).toBeLessThanOrEqual(48);
  });

  it('handles negative numbers, NaN, and Infinity safely by falling back to cold (0)', () => {
    expect(getFlameTier(-5).id).toBe('cold');
    expect(getFlameTier(Number.NaN).id).toBe('cold');
    expect(getFlameTier(Number.POSITIVE_INFINITY).id).toBe('cold');
  });
});
