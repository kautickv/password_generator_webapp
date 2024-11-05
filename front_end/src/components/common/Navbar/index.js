import React, { useState } from "react";
import AppBar from "@mui/material/AppBar";
import Toolbar from "@mui/material/Toolbar";
import Typography from "@mui/material/Typography";
import IconButton from "@mui/material/IconButton";
import SettingsIcon from "@mui/icons-material/Settings";
import MenuItem from "@mui/material/MenuItem";
import Menu from "@mui/material/Menu";
import { Box, Hidden, Drawer, List, ListItem, ListItemText } from "@mui/material";
import { useTheme } from "@mui/material/styles";
import { useNavigate } from "react-router-dom";
import LogoutIcon from "@mui/icons-material/Logout";
import AccountCircle from "@mui/icons-material/AccountCircle";
import MenuIcon from '@mui/icons-material/Menu';
import { logout } from "../../../utils/util";
import AlertComponent from "../AlertComponent";

const Navbar = () => {
  const navigate = useNavigate();
  const [anchorEl, setAnchorEl] = useState(null);
  const [mobileOpen, setMobileOpen] = useState(false);
  const open = Boolean(anchorEl);
  const [alerts, setAlerts] = React.useState([]);
  const theme = useTheme();

  const handleDrawerToggle = () => {
    setMobileOpen(!mobileOpen);
  };

  const handleMenu = (event) => {
    setAnchorEl(event.currentTarget);
  };

  const handleClose = () => {
    setAnchorEl(null);
  };

  const handleNavigation = (path) => {
    navigate(path);
    setMobileOpen(false);
  };

  const handleLogout = async () => {
    let jwtToken = localStorage.getItem("JWT_Token");

    if (jwtToken === "" || jwtToken === undefined) {
      navigate("/login");
    } else {
      let response = await logout(jwtToken);
      console.log(response);
      if (response !== 200) {
        localStorage.setItem("JWT_Token", "");
        addAlert("error", "An internal server error occurred. Please try again later.");
      }
      navigate("/login");
    }
  };

  const drawer = (
    <div>
      <List>
        {["Home", "Link Manager", "Formatter", "Portfolio"].map((text, index) => (
          <ListItem button key={text} onClick={() => handleNavigation(`/${text.toLowerCase().replace(" ", "-")}`)}>
            <ListItemText primary={text} />
          </ListItem>
        ))}
      </List>
    </div>
  );

  function addAlert(severity, message) {
    const newAlert = {
      id: new Date().getTime(),
      severity,
      message,
    };
    setAlerts(function (prevAlerts) {
      return [...prevAlerts, newAlert];
    });
  }

  function handleCloseAlert(id) {
    setAlerts(function (prevAlerts) {
      return prevAlerts.filter(function (alert) {
        return alert.id !== id;
      });
    });
  }

  return (
    <>
    <AppBar position="static" sx={{ backgroundColor: theme.palette.primary.main, marginLeft: 0, marginRight: 0, marginTop: 0 }}>
      <Toolbar>
        <Hidden mdUp implementation="css">
          <IconButton
            color="inherit"
            aria-label="open drawer"
            edge="start"
            onClick={handleDrawerToggle}
            sx={{ mr: 2 }}
          >
            <MenuIcon />
          </IconButton>
        </Hidden>
        <Typography variant="h6" component="div" sx={{ flexGrow: 1 }} style={{ color: theme.palette.primary.contrastText }}>
          Utility Hub
        </Typography>
        <Hidden mdDown implementation="css">
          <Box
            sx={{ flexGrow: 1, display: "flex", justifyContent: "center" }}
            style={{ color: theme.palette.primary.contrastText }}
          >
            {["Home", "Link Manager", "Formatter", "Portfolio"].map((text, index) => (
              <Typography
                key={index}
                variant="body1"
                component="div"
                style={{ cursor: "pointer", margin: "0 20px" }}
                onClick={() => handleNavigation(`/${text.toLowerCase().replace(" ", "-")}`)}
              >
                {text}
              </Typography>
            ))}
          </Box>
        </Hidden>
        <Hidden mdUp implementation="css">
          <Drawer
            container={window !== undefined ? () => window.document.body : undefined}
            variant="temporary"
            anchor={theme.direction === "rtl" ? "right" : "left"}
            open={mobileOpen}
            onClose={handleDrawerToggle}
            ModalProps={{
              keepMounted: true, // Better open performance on mobile.
            }}
          >
            {drawer}
          </Drawer>
        </Hidden>
        <IconButton
          edge="end"
          color="inherit"
          aria-label="settings"
          aria-controls="menu-appbar"
          aria-haspopup="true"
          onClick={handleMenu}
        >
          <SettingsIcon />
        </IconButton>
        <Menu
          id="menu-appbar"
          anchorEl={anchorEl}
          anchorOrigin={{
            vertical: "top",
            horizontal: "right",
          }}
          keepMounted
          transformOrigin={{
            vertical: "top",
            horizontal: "right",
          }}
          open={open}
          onClose={handleClose}
        >
          <MenuItem onClick={() => handleNavigation("/profile-setting")}>
            <AccountCircle style={{ marginRight: "8px" }} />
            Profile Setting
          </MenuItem>
          <MenuItem onClick={handleLogout}>
            <LogoutIcon style={{ marginRight: "8px" }} />
            Logout
          </MenuItem>
        </Menu>
      </Toolbar>
    </AppBar>
    {alerts.map((alert) => (
        <AlertComponent
          key={alert.id}
          open={true}
          severity={alert.severity}
          message={alert.message}
          handleClose={() => handleCloseAlert(alert.id)}
        />
      ))}
    </>
  );
};

export default Navbar;
