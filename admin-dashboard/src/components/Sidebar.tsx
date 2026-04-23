"use client";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { 
  Users, 
  MapPin, 
  History, 
  LayoutDashboard, 
  Settings, 
  LogOut,
  Clock
} from "lucide-react";

const Sidebar = () => {
  const pathname = usePathname();

  const links = [
    { name: "Dashboard", icon: LayoutDashboard, href: "/" },
    { name: "Users", icon: Users, href: "/users" },
    { name: "Places (Eras)", icon: MapPin, href: "/places" },
    { name: "Personalities", icon: History, href: "/personalities" },
  ];

  return (
    <div className="w-64 h-full bg-slate-900 text-slate-100 flex flex-col border-r border-slate-800">
      <div className="p-6 flex items-center gap-3">
        <Clock className="w-8 h-8 text-indigo-500" />
        <span className="text-xl font-bold tracking-tight">Time Explorer</span>
      </div>
      
      <nav className="flex-1 px-4 py-6 space-y-2">
        {links.map((link) => {
          const Icon = link.icon;
          const isActive = pathname === link.href;
          return (
            <Link
              key={link.name}
              href={link.href}
              className={`flex items-center gap-3 px-4 py-2 rounded-lg transition-all ${
                isActive 
                  ? "bg-indigo-500 text-white shadow-lg shadow-indigo-500/20" 
                  : "text-slate-400 hover:text-slate-100 hover:bg-slate-800/50"
              }`}
            >
              <Icon className="w-5 h-5" />
              <span className="font-medium">{link.name}</span>
            </Link>
          );
        })}
      </nav>

      <div className="p-4 border-t border-slate-800 space-y-1">
        <button className="w-full flex items-center gap-3 px-4 py-2 text-slate-400 hover:text-slate-100 hover:bg-slate-800/50 rounded-lg transition-all">
          <Settings className="w-5 h-5" />
          <span className="font-medium">Settings</span>
        </button>
        <button className="w-full flex items-center gap-3 px-4 py-2 text-red-400 hover:text-red-300 hover:bg-red-500/10 rounded-lg transition-all">
          <LogOut className="w-5 h-5" />
          <span className="font-medium">Logout</span>
        </button>
      </div>
    </div>
  );
};

export default Sidebar;
