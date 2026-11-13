import { create } from 'zustand';

interface AppState {
  isSidebarOpen: boolean;
  toggleSidebar: () => void;
  setSidebarOpen: (open: boolean) => void;
  activeTopicSlug: string | null;
  setActiveTopicSlug: (slug: string | null) => void;
  completedLessonIds: Set<string>;
  toggleCompletedLessonId: (id: string) => void;
  setCompletedLessonIds: (ids: string[]) => void;
  streakDays: number;
  studiedToday: boolean;
  setStreakInfo: (days: number, studiedToday: boolean) => void;
}

export const useAppStore = create<AppState>((set) => ({
  isSidebarOpen: false,
  toggleSidebar: () => set((state) => ({ isSidebarOpen: !state.isSidebarOpen })),
  setSidebarOpen: (open) => set({ isSidebarOpen: open }),
  activeTopicSlug: null,
  setActiveTopicSlug: (slug) => set({ activeTopicSlug: slug }),
  completedLessonIds: new Set<string>(),
  toggleCompletedLessonId: (id) =>
    set((state) => {
      const next = new Set(state.completedLessonIds);
      if (next.has(id)) {
        next.delete(id);
      } else {
        next.add(id);
      }
      return { completedLessonIds: next };
    }),
  setCompletedLessonIds: (ids) => set({ completedLessonIds: new Set(ids) }),
  streakDays: 0,
  studiedToday: false,
  setStreakInfo: (days, studiedToday) => set({ streakDays: days, studiedToday }),
}));
