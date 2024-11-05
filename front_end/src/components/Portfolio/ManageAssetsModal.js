import React, { useState } from "react";
import {
  Modal,
  Box,
  Typography,
  TextField,
  Button,
  IconButton,
  Divider,
  Grid,
} from "@mui/material";
import { Close } from "@mui/icons-material";

const modalStyle = {
  position: "absolute",
  top: "50%",
  left: "50%",
  transform: "translate(-50%, -50%)",
  width: 500,
  bgcolor: "background.paper",
  borderRadius: 2,
  boxShadow: 24,
  p: 4,
};

function ManageAssetsModal({ open, onClose, cryptoData, setCryptoData, setTransactionHistory }) {
  const [newAsset, setNewAsset] = useState("");
  const [newTag, setNewTag] = useState("");
  const [transactionType, setTransactionType] = useState("buy");
  const [amount, setAmount] = useState("");
  const [price, setPrice] = useState("");

  const handleAddAsset = () => {
    if (newAsset) {
      setCryptoData([...cryptoData, { name: newAsset, tags: [], balanceOverTime: [] }]);
      setNewAsset("");
    }
  };

  const handleAddTag = (assetName) => {
    setCryptoData((prevData) =>
      prevData.map((crypto) =>
        crypto.name === assetName
          ? { ...crypto, tags: [...crypto.tags, newTag] }
          : crypto
      )
    );
    setNewTag("");
  };

  const handleAddTransaction = () => {
    const transaction = {
      id: new Date().getTime(),
      type: transactionType,
      crypto: newAsset,
      amount: parseFloat(amount),
      price: parseFloat(price),
      date: new Date().toLocaleDateString(),
    };
    setTransactionHistory((prevHistory) => [...prevHistory, transaction]);
    setAmount("");
    setPrice("");
  };

  return (
    <Modal open={open} onClose={onClose}>
      <Box sx={modalStyle}>
        <Box display="flex" justifyContent="space-between" alignItems="center">
          <Typography variant="h6">Manage Crypto Assets</Typography>
          <IconButton onClick={onClose}>
            <Close />
          </IconButton>
        </Box>
        <Divider sx={{ my: 2 }} />

        {/* Add New Asset */}
        <Typography variant="body1" sx={{ mb: 1 }}>Add New Asset</Typography>
        <TextField
          label="Asset Name"
          fullWidth
          value={newAsset}
          onChange={(e) => setNewAsset(e.target.value)}
          sx={{ mb: 2 }}
        />
        <Button variant="contained" fullWidth onClick={handleAddAsset} sx={{ mb: 3 }}>
          Add Asset
        </Button>

        {/* Tagging Assets */}
        <Typography variant="body1" sx={{ mb: 1 }}>Tag Asset</Typography>
        <Grid container spacing={1} alignItems="center" sx={{ mb: 2 }}>
          <Grid item xs={8}>
            <TextField
              label="Tag"
              fullWidth
              value={newTag}
              onChange={(e) => setNewTag(e.target.value)}
            />
          </Grid>
          <Grid item xs={4}>
            <Button variant="outlined" onClick={() => handleAddTag(newAsset)}>Add Tag</Button>
          </Grid>
        </Grid>

        {/* Transaction Section */}
        <Typography variant="body1" sx={{ mb: 1 }}>Add Transaction</Typography>
        <TextField
          select
          label="Transaction Type"
          value={transactionType}
          onChange={(e) => setTransactionType(e.target.value)}
          SelectProps={{ native: true }}
          fullWidth
          sx={{ mb: 2 }}
        >
          <option value="buy">Buy</option>
          <option value="sell">Sell</option>
        </TextField>
        <TextField
          label="Amount"
          fullWidth
          type="number"
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
          sx={{ mb: 2 }}
        />
        <TextField
          label="Price per Unit"
          fullWidth
          type="number"
          value={price}
          onChange={(e) => setPrice(e.target.value)}
          sx={{ mb: 2 }}
        />
        <Button variant="contained" fullWidth onClick={handleAddTransaction}>
          Add Transaction
        </Button>
      </Box>
    </Modal>
  );
}

export default ManageAssetsModal;
