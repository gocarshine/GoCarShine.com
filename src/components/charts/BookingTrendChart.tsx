import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, Area, ComposedChart } from 'recharts';

interface BookingTrendChartProps {
  data: { month: string; bookings: number; revenue: number }[];
}

export default function BookingTrendChart({ data }: BookingTrendChartProps) {
  if (data.length === 0) {
    return (
      <div className="flex items-center justify-center h-80 text-gray-500">
        No booking data available
      </div>
    );
  }

  return (
    <div className="w-full h-80">
      <ResponsiveContainer width="100%" height="100%">
        <ComposedChart
          data={data}
          margin={{ top: 20, right: 30, left: 20, bottom: 5 }}
        >
          <defs>
            <linearGradient id="revenueGradient" x1="0" y1="0" x2="0" y2="1">
              <stop offset="5%" stopColor="#3b82f6" stopOpacity={0.3}/>
              <stop offset="95%" stopColor="#3b82f6" stopOpacity={0}/>
            </linearGradient>
          </defs>
          <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" />
          <XAxis
            dataKey="month"
            tick={{ fill: '#6b7280', fontSize: 12 }}
            axisLine={{ stroke: '#d1d5db' }}
          />
          <YAxis
            yAxisId="left"
            tick={{ fill: '#6b7280', fontSize: 12 }}
            axisLine={{ stroke: '#d1d5db' }}
            label={{ value: 'Bookings', angle: -90, position: 'insideLeft', style: { fill: '#6b7280' } }}
          />
          <YAxis
            yAxisId="right"
            orientation="right"
            tick={{ fill: '#6b7280', fontSize: 12 }}
            axisLine={{ stroke: '#d1d5db' }}
            tickFormatter={(value) => `₹${(value / 1000).toFixed(0)}k`}
            label={{ value: 'Revenue', angle: 90, position: 'insideRight', style: { fill: '#6b7280' } }}
          />
          <Tooltip
            formatter={(value: number, name: string) => {
              if (name === 'Revenue') {
                return [`₹${value.toLocaleString()}`, name];
              }
              return [value, name];
            }}
            contentStyle={{
              backgroundColor: 'rgba(255, 255, 255, 0.95)',
              border: '1px solid #e5e7eb',
              borderRadius: '0.5rem',
              padding: '0.75rem'
            }}
          />
          <Legend
            wrapperStyle={{ paddingTop: '20px' }}
            formatter={(value) => <span className="text-sm text-gray-700">{value}</span>}
          />
          <Area
            yAxisId="right"
            type="monotone"
            dataKey="revenue"
            fill="url(#revenueGradient)"
            stroke="#3b82f6"
            strokeWidth={0}
            name="Revenue"
          />
          <Line
            yAxisId="left"
            type="monotone"
            dataKey="bookings"
            stroke="#10b981"
            strokeWidth={3}
            dot={{ fill: '#10b981', r: 5 }}
            activeDot={{ r: 7 }}
            name="Bookings"
          />
        </ComposedChart>
      </ResponsiveContainer>
    </div>
  );
}
