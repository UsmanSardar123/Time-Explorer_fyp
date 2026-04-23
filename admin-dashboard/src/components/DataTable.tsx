"use client";
import { Search, ChevronLeft, ChevronRight, MoreVertical, Edit2, Trash2 } from "lucide-react";

interface DataTableProps {
  title: string;
  columns: { key: string; label: string }[];
  data: any[];
  onEdit?: (item: any) => void;
  onDelete?: (id: string) => void;
  onAdd?: () => void;
}

export default function DataTable({ title, columns, data, onEdit, onDelete, onAdd }: DataTableProps) {
  return (
    <div className="bg-white rounded-3xl border border-slate-100 shadow-xl overflow-hidden hover:shadow-2xl transition-all duration-500 animate-in fade-in slide-in-from-bottom-8 duration-700">
      <div className="p-8 border-b border-slate-50 flex flex-col sm:flex-row sm:items-center justify-between gap-6 bg-slate-50/10">
        <div className="space-y-1">
          <h2 className="text-2xl font-bold text-slate-900 tracking-tight">{title}</h2>
          <p className="text-slate-400 text-sm font-medium">Manage and monitor {title.toLowerCase()} from one place</p>
        </div>
        <div className="flex items-center gap-4">
          <div className="relative group">
            <Search className="w-5 h-5 absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 group-focus-within:text-indigo-500 transition-colors" />
            <input 
              type="text" 
              placeholder="Search data..." 
              className="pl-12 pr-6 py-3 bg-white border border-slate-200 rounded-2xl text-sm focus:outline-none focus:ring-4 focus:ring-indigo-500/10 focus:border-indigo-500 transition-all w-full sm:w-64 font-medium shadow-sm"
            />
          </div>
          <button 
            onClick={onAdd}
            className="px-6 py-3 bg-indigo-600 text-white rounded-2xl font-bold text-sm hover:bg-indigo-700 active:scale-95 transition-all shadow-lg shadow-indigo-200 flex items-center gap-2 group whitespace-nowrap"
          >
            <span className="text-xl leading-none group-hover:rotate-90 transition-transform">+</span> Add New {title.slice(0, -1)}
          </button>
        </div>
      </div>

      <div className="overflow-x-auto p-4 sm:p-8">
        <table className="w-full text-left border-collapse">
          <thead>
            <tr className="bg-slate-50/50 rounded-2xl">
              {columns.map(col => (
                <th key={col.key} className="px-6 py-5 text-xs font-bold text-slate-400 uppercase tracking-widest border-b border-slate-100">{col.label}</th>
              ))}
              <th className="px-6 py-5 text-xs font-bold text-slate-400 uppercase tracking-widest border-b border-slate-100 text-right">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-50 font-medium">
            {data.map((item, idx) => (
              <tr key={idx} className="hover:bg-slate-50/50 transition-all cursor-default group">
                {columns.map(col => (
                  <td key={col.key} className="px-6 py-5">
                    {col.key === 'role' ? (
                      <span className={`px-4 py-1.5 rounded-full text-xs font-bold tracking-tight border-2 ${
                        item[col.key] === 'Teacher' ? 'bg-indigo-50 text-indigo-600 border-indigo-100' : 'bg-amber-50 text-amber-600 border-amber-100'
                      }`}>
                        {item[col.key]}
                      </span>
                    ) : (
                      <div className="text-slate-600 group-hover:text-slate-900 transition-colors">{item[col.key]}</div>
                    )}
                  </td>
                ))}
                <td className="px-6 py-5 text-right">
                  <div className="flex items-center justify-end gap-2 opacity-0 group-hover:opacity-100 transition-all duration-300 transform translate-x-4 group-hover:translate-x-0">
                    <button 
                      onClick={() => onEdit?.(item)}
                      className="p-2.5 text-slate-500 hover:text-indigo-600 hover:bg-indigo-50 rounded-xl transition-all active:scale-90"
                    >
                      <Edit2 className="w-5 h-5" />
                    </button>
                    <button 
                      onClick={() => onDelete?.(item.id || item.uid)}
                      className="p-2.5 text-slate-500 hover:text-rose-600 hover:bg-rose-50 rounded-xl transition-all active:scale-90"
                    >
                      <Trash2 className="w-5 h-5" />
                    </button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      <div className="p-8 border-t border-slate-50 bg-slate-50/5 flex items-center justify-between">
        <p className="text-sm font-medium text-slate-400">Showing 1-10 of {data.length} results</p>
        <div className="flex items-center gap-4">
          <button className="p-3 border border-slate-200 rounded-xl text-slate-400 hover:bg-white hover:text-slate-600 hover:border-slate-300 transition-all active:scale-95 shadow-sm bg-white/50">
            <ChevronLeft className="w-5 h-5" />
          </button>
          <div className="flex items-center gap-1.5">
            {[1, 2, 3].map(p => (
              <button key={p} className={`w-10 h-10 rounded-xl font-bold text-sm transition-all shadow-sm ${p === 1 ? 'bg-indigo-600 text-white shadow-indigo-200' : 'bg-white border border-slate-200 text-slate-500 hover:border-slate-300 active:scale-95'}`}>
                {p}
              </button>
            ))}
          </div>
          <button className="p-3 border border-slate-200 rounded-xl text-slate-400 hover:bg-white hover:text-slate-600 hover:border-slate-300 transition-all active:scale-95 shadow-sm bg-white/50">
            <ChevronRight className="w-5 h-5" />
          </button>
        </div>
      </div>
    </div>
  );
}
