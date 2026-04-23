"use client";
import DataTable from "@/components/DataTable";
import { useState } from "react";

export default function PlacesPage() {
  const [places, setPlaces] = useState([
    { id: "1", name: "Ancient Rome", era: "Classical Antiquity", coordinates: "41.8902° N, 12.4922° E" },
    { id: "2", name: "Ancient Egypt", era: "Bronze Age", coordinates: "29.9792° N, 31.1342° E" },
    { id: "3", name: "Medieval Europe", era: "Middle Ages", coordinates: "48.8566° N, 2.3522° E" },
    { id: "4", name: "Feudal Japan", era: "Sengoku Period", coordinates: "35.6762° N, 139.6503° E" },
  ]);

  const columns = [
    { key: "name", label: "Location Name" },
    { key: "era", label: "Time Period / Era" },
    { key: "coordinates", label: "Coordinates (GPS)" },
  ];

  return (
    <div className="space-y-8 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 animate-in fade-in duration-1000">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-6 mb-8 group">
        <div>
          <h1 className="text-4xl font-extrabold text-slate-900 tracking-tight group-hover:text-indigo-600 transition-colors drop-shadow-sm">Eras & Locations</h1>
          <p className="text-slate-400 font-medium text-lg mt-2 flex items-center gap-2">
            <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span>
            Manage historical world locations
          </p>
        </div>
        <div className="flex items-center gap-4">
          <div className="px-5 py-2.5 rounded-2xl bg-indigo-50 border border-indigo-100 text-indigo-600 flex items-center gap-3 shadow-sm hover:shadow-md transition-all">
            <span className="font-black text-xl tracking-tighter">48</span>
            <span className="text-sm font-bold text-indigo-400 uppercase tracking-widest">Places</span>
          </div>
        </div>
      </div>
      
      <DataTable 
        title="Places" 
        columns={columns} 
        data={places} 
      />
    </div>
  );
}
