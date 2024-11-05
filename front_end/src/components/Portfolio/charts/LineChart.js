import React from "react";
import { Line } from "react-chartjs-2";
import { Chart as ChartJS, CategoryScale, LinearScale, PointElement, LineElement, Tooltip, Legend } from "chart.js";

// Register necessary scales, elements, and plugins
ChartJS.register(CategoryScale, LinearScale, PointElement, LineElement, Tooltip, Legend);

function LineChart({ data }) {
  const chartData = {
    labels: data.map((entry) => entry.date),
    datasets: [
      {
        label: "Portfolio Value Over Time",
        data: data.map((entry) => entry.value),
        fill: false,
        borderColor: "#42A5F5",
        tension: 0.1,
      },
    ],
  };

  return <Line data={chartData} />;
}

export default LineChart;
