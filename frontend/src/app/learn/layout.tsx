import React from 'react';
import { DocsSidebar } from '@/components/DocsSidebar';

export default function LearnLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="flex-1 mx-auto w-full max-w-7xl flex items-start">
      {/* Left Navigation for Documentation */}
      <DocsSidebar />

      {/* Main Content Area */}
      <div className="flex-1 min-w-0 flex flex-col">
        {children}
      </div>
    </div>
  );
}
