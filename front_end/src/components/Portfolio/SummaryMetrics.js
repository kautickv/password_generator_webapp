import React from "react";
import { Paper, Typography } from "@mui/material";

// Helper functions
function calculateTotalInvestment(data) {
  return data.reduce((acc, crypto) => acc + crypto.amount * crypto.buyPrice, 0).toFixed(2);
}

function calculateProfit(data) {
  const totalInvestment = calculateTotalInvestment(data);
  const currentValue = data.reduce((acc, crypto) => acc + crypto.amount * crypto.currentPrice, 0);
  return (((currentValue - totalInvestment) / totalInvestment) * 100).toFixed(2);
}

function calculateAnnualizedReturn(data) {
  const profit = calculateProfit(data);
  const yearsHeld = 1; // Replace with actual holding period if available
  return (profit / yearsHeld).toFixed(2);
}

function SummaryMetrics({ data }) {
  return (
    <Paper elevation={1} sx={{ p: 2, borderRadius: 2 }}>
      <Typography variant="h6" gutterBottom>Summary Metrics</Typography>
      <Typography variant="body1">Total Investment: ${calculateTotalInvestment(data)}</Typography>
      <Typography variant="body1">Average Profit: {calculateProfit(data)}%</Typography>
      <Typography variant="body1">Annualized Return: {calculateAnnualizedReturn(data)}%</Typography>
    </Paper>
  );
}

export default SummaryMetrics;
