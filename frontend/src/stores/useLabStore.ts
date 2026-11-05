import { create } from 'zustand';

export interface LabProgressRecord {
  completed: boolean;
  commandsUsed: number;
  hintsUsed: number;
  completedAt?: string;
}

interface LabProgressState {
  progress: Record<string, LabProgressRecord>;
  hydrated: boolean;
  hydrate: () => void;
  recordCompletion: (slug: string, commandsUsed: number, hintsUsed: number) => void;
  recordHintUsed: (slug: string, count: number) => void;
  resetLabProgress: (slug: string) => void;
}

const STORAGE_KEY = 'support_lab_progress_v1';

function loadFromStorage(): Record<string, LabProgressRecord> {
  if (typeof window === 'undefined') return {};
  try {
    const raw = window.localStorage.getItem(STORAGE_KEY);
    if (!raw) return {};
    const parsed = JSON.parse(raw);
    if (parsed && typeof parsed === 'object' && !Array.isArray(parsed)) {
      return parsed as Record<string, LabProgressRecord>;
    }
  } catch {
    // Ignore storage read errors (Private mode / quota exceeded)
  }
  return {};
}

function saveToStorage(progress: Record<string, LabProgressRecord>): void {
  if (typeof window === 'undefined') return;
  try {
    window.localStorage.setItem(STORAGE_KEY, JSON.stringify(progress));
  } catch {
    // Ignore storage write errors (Private mode / quota exceeded)
  }
}

export const useLabStore = create<LabProgressState>((set, get) => ({
  progress: {},
  hydrated: false,

  hydrate: () => {
    if (get().hydrated) return;
    const loaded = loadFromStorage();
    set({ progress: loaded, hydrated: true });
  },

  recordCompletion: (slug, commandsUsed, hintsUsed) => {
    const current = get().progress[slug];
    const nextRecord: LabProgressRecord = {
      completed: true,
      commandsUsed:
        current?.completed && current.commandsUsed > 0
          ? Math.min(current.commandsUsed, commandsUsed)
          : commandsUsed,
      hintsUsed:
        current?.completed
          ? Math.min(current.hintsUsed, hintsUsed)
          : hintsUsed,
      completedAt: current?.completedAt || new Date().toISOString(),
    };
    const nextProgress = { ...get().progress, [slug]: nextRecord };
    saveToStorage(nextProgress);
    set({ progress: nextProgress });
  },

  recordHintUsed: (slug, count) => {
    const current = get().progress[slug] || {
      completed: false,
      commandsUsed: 0,
      hintsUsed: 0,
    };
    const nextRecord: LabProgressRecord = {
      ...current,
      hintsUsed: Math.max(current.hintsUsed, count),
    };
    const nextProgress = { ...get().progress, [slug]: nextRecord };
    saveToStorage(nextProgress);
    set({ progress: nextProgress });
  },

  resetLabProgress: (slug) => {
    const nextProgress = { ...get().progress };
    delete nextProgress[slug];
    saveToStorage(nextProgress);
    set({ progress: nextProgress });
  },
}));
