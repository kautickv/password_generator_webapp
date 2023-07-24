import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import Card from "@mui/material/Card";
import CardContent from "@mui/material/CardContent";
import Button from "@mui/material/Button";
import Typography from "@mui/material/Typography";
import CardActions from "@mui/material/CardActions";
import Dialog from "@mui/material/Dialog";
import DialogTitle from "@mui/material/DialogTitle";
import DialogContent from "@mui/material/DialogContent";
import DialogContentText from "@mui/material/DialogContentText";
import DialogActions from "@mui/material/DialogActions";
import List from "@mui/material/List";
import ListItem from "@mui/material/ListItem";
import Link from "@mui/material/Link";
import TextField from "@mui/material/TextField";
import AddBoxIcon from "@mui/icons-material/AddBox";
import DeleteIcon from "@mui/icons-material/Delete";
import IconButton from "@mui/material/IconButton";
import Grid from "@mui/material/Grid";
import Paper from "@mui/material/Paper";
import Divider from "@mui/material/Divider";
import { styled } from "@mui/system";

import {sendPostToMultitabBackend } from "../../utils/multitabUtil";

const StyledCard = styled(Card)({
  maxWidth: 345,
  "& .MuiCardContent-root": {
    "& .MuiTypography-root": {
      // ⚠️ object-fit is not supported by IE11.
      objectFit: "cover",
    },
  },
});

function Tile(props) {
  const [configureOpen, setConfigureOpen] = useState(false);
  const [deleteOpen, setDeleteOpen] = useState(false);

  const [urls, setUrls] = useState(props.urls);
  const [newUrl, setNewUrl] = useState({ urlTitle: "", url: "" });

  const navigate = useNavigate();

  function handleConfigureOpen() {
    setConfigureOpen(true);
  }

  function handleConfigureClose() {
    setConfigureOpen(false);
  }

  function handleDeleteOpen() {
    setDeleteOpen(true);
  }

  function handleDeleteClose() {
    setDeleteOpen(false);
  }

  function handleConfigureSave() {
    console.log("Configuration saved");

    handleConfigureClose();
  }

  function handleDelete() {
    console.log("Tile has been deleted.");

    handleDeleteClose();
  }

  function handleOpenAll() {
    console.log(props.urls);
    props.urls.forEach((urlObj) => {
      window.open(urlObj.url, "_blank");
    });
  }
  function handleUrlChange(e) {
    setNewUrl({ ...newUrl, [e.target.name]: e.target.value });
  }

  async function handleAddUrl() {
    setUrls([...urls, newUrl]);
    setNewUrl({ urlTitle: "", url: "" });

    // Send API call to backend to save config
    await postNewConfigToBackend()
  }

  async function handleDeleteUrl(index) {
    // This function gets triggered when a URL gets deleted.
    const newUrls = [...urls];
    newUrls.splice(index, 1);
    setUrls(newUrls);

    // Send API call to backend to save config
    await postNewConfigToBackend()
  }

  async function postNewConfigToBackend() {
    // This function will perform an API call to backend to save current config

    try{
      // Get the JWTToken
      let jwtToken = localStorage.getItem("JWT_Token");
      if (jwtToken !== null && jwtToken !== "undefined") {
        let httpCode = await sendPostToMultitabBackend(jwtToken, urls);

        if (httpCode === 200){
          //Pass
        }else if(httpCode === 401){
          alert('Credentials Expired. Please login again')
          navigate('/login')
        }else if(httpCode === 500){
          alert("AN error occurred while saving. Please try again later")
        }else{
          alert("An unknown error occurred. Please try again later.")
        }
      }else{
        // User JWT token is not valid or expired
        localStorage.removeItem("JWT_Token");
        navigate("/login");
      }
    }
    catch(err){
      console.log(err);
      alert('An error ocurred saving urls. Please try again later')
    }
  }

  return (
    <StyledCard>
      <CardContent>
        <Typography gutterBottom variant="h5" component="div">
          {props.title}
        </Typography>
        <Typography variant="body2" color="text.secondary">
          {props.description}
        </Typography>
      </CardContent>
      <CardActions>
        <Button size="small" onClick={handleConfigureOpen}>
          Configure
        </Button>
        <Button size="small" onClick={handleDeleteOpen}>
          Delete
        </Button>
        <Button size="medium" onClick={handleOpenAll}>
          Open All
        </Button>
      </CardActions>

      <Dialog
        open={configureOpen}
        onClose={handleConfigureClose}
        fullWidth
        maxWidth="md"
      >
        <DialogTitle>{props.title}</DialogTitle>
        <DialogContent>
          <List>
            {urls.map((item, index) => (
              <ListItem key={index}>
                <Grid container spacing={2}>
                  <Grid item xs={12} md={5}>
                    <Paper elevation={1} style={{ padding: "10px" }}>
                      <Typography variant="subtitle1">
                        {item.urlTitle}
                      </Typography>
                    </Paper>
                  </Grid>
                  <Grid item xs={12} md={5}>
                    <Paper elevation={1} style={{ padding: "10px" }}>
                      <Link href={item.url} target="_blank" rel="noopener">
                        {item.url}
                      </Link>
                    </Paper>
                  </Grid>
                  <Grid item xs={12} md={2}>
                    <IconButton
                      edge="end"
                      aria-label="delete"
                      onClick={() => handleDeleteUrl(index)}
                    >
                      <DeleteIcon />
                    </IconButton>
                  </Grid>
                </Grid>
                <Divider style={{ margin: "10px 0" }} />
              </ListItem>
            ))}
            <ListItem>
              <Grid container spacing={2}>
                <Grid item xs={12} md={5}>
                  <TextField
                    label="Title"
                    variant="outlined"
                    name="urlTitle"
                    value={newUrl.urlTitle}
                    onChange={handleUrlChange}
                    fullWidth
                  />
                </Grid>
                <Grid item xs={12} md={5}>
                  <TextField
                    label="URL"
                    variant="outlined"
                    name="url"
                    value={newUrl.url}
                    onChange={handleUrlChange}
                    fullWidth
                  />
                </Grid>
                <Grid item xs={12} md={2}>
                  <IconButton
                    edge="end"
                    aria-label="add"
                    onClick={handleAddUrl}
                  >
                    <AddBoxIcon />
                  </IconButton>
                </Grid>
              </Grid>
            </ListItem>
          </List>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleConfigureClose}>Cancel</Button>
          <Button onClick={handleConfigureSave}>Save</Button>
        </DialogActions>
      </Dialog>

      <Dialog open={deleteOpen} onClose={handleDeleteClose}>
        <DialogTitle>{'Delete "' + props.title + '"'}</DialogTitle>
        <DialogContent>
          <DialogContentText>
            Are you sure you want to delete this tile?
          </DialogContentText>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleDeleteClose}>Cancel</Button>
          <Button onClick={handleDelete}>Delete</Button>
        </DialogActions>
      </Dialog>
    </StyledCard>
  );
}

export default Tile;