import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import Sidebar from "@/components/Sidebar";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "Admin Dashboard | Time Explorer",
  description: "Secure Admin Management System for Time Explorer",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="h-full bg-slate-50">
      <body className={`${inter.className} h-full flex`}>
        <Sidebar />
        <main className="flex-1 h-full overflow-y-auto">
          <header className="h-16 px-8 border-b border-slate-200 flex items-center justify-between bg-white/80 backdrop-blur-md sticky top-0 z-10 shadow-sm transition-all duration-300 ease-in-out">
            <h1 className="text-xl font-bold text-slate-800 tracking-tight leading-none drop-shadow-sm hover:text-indigo-600 transition-colors cursor-default">Dashboard Overview</h1>
            <div className="flex items-center gap-4">
              <div className="w-10 h-10 rounded-full bg-indigo-600 flex items-center justify-center text-white font-bold shadow-lg shadow-indigo-200">
                A
              </div>
            </div>
          </header>
          <div className="p-8 animate-in fade-in slide-in-from-bottom-4 duration-700">
            {children}
          </div>
        </main>
      </body>
    </html>
  );
}
