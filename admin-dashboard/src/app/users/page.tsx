"use client";
import DataTable from "@/components/DataTable";
import { useState } from "react";

export default function UsersPage() {
  const [users, setUsers] = useState([
    { uid: "1", name: "Ahmed Khan", email: "ahmed@example.com", role: "Student", progress: "85%" },
    { uid: "2", name: "Sara Ali", email: "sara@example.com", role: "Teacher", progress: "N/A" },
    { uid: "3", name: "John Doe", email: "john@example.com", role: "Student", progress: "42%" },
    { uid: "4", name: "Jane Smith", email: "jane@example.com", role: "Student", progress: "100%" },
  ]);

  const columns = [
    { key: "name", label: "Full Name" },
    { key: "email", label: "Email Address" },
    { key: "role", label: "Account Role" },
    { key: "progress", label: "Learning Progress" },
  ];

  const handleDelete = (id: string) => {
    setUsers(users.filter(u => u.uid !== id));
  };

  const handleAdd = () => {
    alert("Open Create User Modal");
  };

  return (
    <div className="space-y-8 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 animate-in fade-in duration-1000">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-6 mb-8 group">
        <div>
          <h1 className="text-4xl font-extrabold text-slate-900 tracking-tight group-hover:text-indigo-600 transition-colors drop-shadow-sm">Account Management</h1>
          <p className="text-slate-400 font-medium text-lg mt-2 flex items-center gap-2">
            <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span>
            Total students and educators registered
          </p>
        </div>
        <div className="flex items-center gap-4">
          <div className="px-5 py-2.5 rounded-2xl bg-indigo-50 border border-indigo-100 text-indigo-600 flex items-center gap-3 shadow-sm hover:shadow-md transition-all">
            <span className="font-black text-xl tracking-tighter">1,284</span>
            <span className="text-sm font-bold text-indigo-400 uppercase tracking-widest">Active Users</span>
          </div>
        </div>
      </div>
      
      <DataTable 
        title="Users" 
        columns={columns} 
        data={users} 
        onDelete={handleDelete}
        onAdd={handleAdd}
      />
    </div>
  );
}
