import { 
  Users, 
  MapPin, 
  History, 
  TrendingUp,
  ArrowUpRight,
  ArrowDownRight
} from "lucide-react";

const StatsCard = ({ title, value, icon: Icon, trend, trendValue }: any) => (
  <div className="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm hover:shadow-md transition-all">
    <div className="flex items-start justify-between">
      <div>
        <p className="text-sm font-medium text-slate-500">{title}</p>
        <h3 className="text-3xl font-bold mt-2 text-slate-900">{value}</h3>
      </div>
      <div className={`p-3 rounded-xl ${trend === 'up' ? 'bg-emerald-50 text-emerald-600' : 'bg-rose-50 text-rose-600'}`}>
        <Icon className="w-6 h-6" />
      </div>
    </div>
    <div className="mt-4 flex items-center gap-2">
      <span className={`flex items-center text-sm font-semibold ${trend === 'up' ? 'text-emerald-600' : 'text-rose-600'}`}>
        {trend === 'up' ? <ArrowUpRight className="w-4 h-4" /> : <ArrowDownRight className="w-4 h-4" />}
        {trendValue}%
      </span>
      <span className="text-xs text-slate-400">vs last month</span>
    </div>
  </div>
);

export default function Home() {
  return (
    <div className="space-y-8 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 animate-in fade-in duration-1000">
      <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
        <StatsCard 
          title="Total Students" 
          value="1,284" 
          icon={Users} 
          trend="up" 
          trendValue="12.5" 
        />
        <StatsCard 
          title="Historical Places" 
          value="48" 
          icon={MapPin} 
          trend="up" 
          trendValue="4.2" 
        />
        <StatsCard 
          title="Personalities" 
          value="156" 
          icon={History} 
          trend="down" 
          trendValue="2.1" 
        />
      </div>

      <div className="bg-white rounded-3xl border border-slate-100 shadow-xl shadow-slate-200/40 p-8 hover:shadow-2xl transition-all duration-500 transform hover:-translate-y-1">
        <div className="flex items-center justify-between mb-8">
          <div>
            <h3 className="text-2xl font-bold text-slate-900 tracking-tight">Recent Activity</h3>
            <p className="text-slate-500 mt-1">Real-time system updates and modifications</p>
          </div>
          <button className="px-6 py-2.5 rounded-xl border-2 border-slate-100 text-slate-600 font-semibold hover:bg-slate-50 hover:border-slate-200 transition-all active:scale-95">View Report</button>
        </div>
        
        <div className="overflow-x-auto rounded-xl border border-slate-50 bg-slate-50/20">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-slate-50/50">
                <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-widest border-b border-slate-100">User</th>
                <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-widest border-b border-slate-100">Action</th>
                <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-widest border-b border-slate-100">Location</th>
                <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-widest border-b border-slate-100">Time</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-50 font-medium">
              {[1,2,3,4,5].map((i) => (
                <tr key={i} className="hover:bg-white transition-colors cursor-pointer group">
                  <td className="px-6 py-5 flex items-center gap-4">
                    <div className="w-10 h-10 rounded-xl bg-slate-100 flex items-center justify-center text-slate-600 group-hover:bg-indigo-50 group-hover:text-indigo-600 transition-all font-bold">
                      U{i}
                    </div>
                    <div>
                      <div className="text-slate-900">Student User {i}</div>
                      <div className="text-sm text-slate-400">student{i}@example.com</div>
                    </div>
                  </td>
                  <td className="px-6 py-5">
                    <span className="px-3 py-1 bg-amber-50 text-amber-600 rounded-full text-xs font-bold ring-1 ring-amber-100">Updated Profile</span>
                  </td>
                  <td className="px-6 py-5 text-slate-500">Ancient Rome</td>
                  <td className="px-6 py-5 text-slate-400 text-sm">2 mins ago</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
