"use client";
import DataTable from "@/components/DataTable";
import { useState } from "react";

export default function PersonalitiesPage() {
  const [personalities, setPersonalities] = useState([
    { id: "1", name: "Julius Caesar", role: "General/Statesman", bio: "Leader of Ancient Rome", location: "Ancient Rome" },
    { id: "2", name: "Cleopatra", role: "Queen", bio: "Pharaoh of Ancient Egypt", location: "Ancient Egypt" },
    { id: "3", name: "Da Vinci", role: "Polymath", bio: "Renaissance Genius", location: "Medieval Europe" },
    { id: "4", name: "Oda Nobunaga", role: "Daimyo", bio: "Unifer of Japan", location: "Feudal Japan" },
  ]);

  const columns = [
    { key: "name", label: "Figure Name" },
    { key: "role", label: "Historical Role" },
    { key: "location", label: "Associated Place" },
  ];

  return (
    <div className="space-y-8 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 animate-in fade-in duration-1000">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-6 mb-8 group">
        <div>
          <h1 className="text-4xl font-extrabold text-slate-900 tracking-tight group-hover:text-indigo-600 transition-colors drop-shadow-sm">Historical Figures</h1>
          <p className="text-slate-400 font-medium text-lg mt-2 flex items-center gap-2">
            <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span>
            Manage famous personalities per era
          </p>
        </div>
        <div className="flex items-center gap-4">
          <div className="px-5 py-2.5 rounded-2xl bg-indigo-50 border border-indigo-100 text-indigo-600 flex items-center gap-3 shadow-sm hover:shadow-md transition-all">
            <span className="font-black text-xl tracking-tighter">156</span>
            <span className="text-sm font-bold text-indigo-400 uppercase tracking-widest">Personalities</span>
          </div>
        </div>
      </div>
      
      <DataTable 
        title="Personalities" 
        columns={columns} 
        data={personalities} 
      />
    </div>
  );
}
