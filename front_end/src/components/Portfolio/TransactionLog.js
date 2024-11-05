import React from "react";
import { Paper, Typography, List, ListItem, ListItemText, Divider } from "@mui/material";

function TransactionLog({ transactions }) {
  return (
    <Paper elevation={1} sx={{ p: 2, borderRadius: 2 }}>
      <Typography variant="h6" gutterBottom>Transaction History</Typography>
      <List>
        {transactions.map((transaction) => (
          <React.Fragment key={transaction.id}>
            <ListItem>
              <ListItemText
                primary={`${transaction.type} - ${transaction.crypto}`}
                secondary={`Amount: ${transaction.amount} | Price: $${transaction.price} | Date: ${transaction.date}`}
              />
            </ListItem>
            <Divider />
          </React.Fragment>
        ))}
      </List>
    </Paper>
  );
}

export default TransactionLog;
