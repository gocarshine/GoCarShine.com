import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';

interface RevenueExpenseBarChartProps {
  data: { month: string; revenue: number; expenses: number }[];
}

export default function RevenueExpenseBarChart({ data }: RevenueExpenseBarChartProps) {
  if (data.length === 0) {
    return (
      <div className="flex items-center justify-center h-80 text-gray-500">
        No financial data available
      </div>
    );
  }

  return (
    <div className="w-full h-80">
      <ResponsiveContainer width="100%" height="100%">
        <BarChart
          data={data}
          margin={{ top: 20, right: 30, left: 20, bottom: 5 }}
        >
          <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" />
          <XAxis
            dataKey="month"
            tick={{ fill: '#6b7280', fontSize: 12 }}
            axisLine={{ stroke: '#d1d5db' }}
          />
          <YAxis
            tick={{ fill: '#6b7280', fontSize: 12 }}
            axisLine={{ stroke: '#d1d5db' }}
            tickFormatter={(value) => `₹${(value / 1000).toFixed(0)}k`}
          />
          <Tooltip
            formatter={(value: number) => `₹${value.toLocaleString()}`}
            contentStyle={{
              backgroundColor: 'rgba(255, 255, 255, 0.95)',
              border: '1px solid #e5e7eb',
              borderRadius: '0.5rem',
              padding: '0.75rem'
            }}
            cursor={{ fill: 'rgba(59, 130, 246, 0.1)' }}
          />
          <Legend
            wrapperStyle={{ paddingTop: '20px' }}
            formatter={(value) => <span className="text-sm text-gray-700">{value}</span>}
          />
          <Bar
            dataKey="revenue"
            fill="#10b981"
            radius={[8, 8, 0, 0]}
            name="Revenue"
            maxBarSize={60}
          />
          <Bar
            dataKey="expenses"
            fill="#ef4444"
            radius={[8, 8, 0, 0]}
            name="Expenses"
            maxBarSize={60}
          />
        </BarChart>
      </ResponsiveContainer>
    </div>
  );
}
