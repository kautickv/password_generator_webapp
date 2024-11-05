import React from "react";
import { Pie } from "react-chartjs-2";
import { Chart as ChartJS, ArcElement, Tooltip, Legend } from "chart.js";

// Register necessary elements and plugins
ChartJS.register(ArcElement, Tooltip, Legend);

function PieChart({ data }) {
  const chartData = {
    labels: data.map((crypto) => crypto.name),
    datasets: [
      {
        label: "Crypto Holdings",
        data: data.map((crypto) => crypto.amount * crypto.currentPrice),
        backgroundColor: [
          "#FF6384",
          "#36A2EB",
          "#FFCE56",
          "#4BC0C0",
          "#9966FF",
          "#FF9F40",
        ],
        hoverBackgroundColor: [
          "#FF6384",
          "#36A2EB",
          "#FFCE56",
          "#4BC0C0",
          "#9966FF",
          "#FF9F40",
        ],
      },
    ],
  };

  return <Pie data={chartData} />;
}

export default PieChart;
