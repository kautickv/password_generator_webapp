import React from "react";
import { SnackbarProvider } from 'notistack'; 
import Home from "./components/Home";
import Login from "./components/Login"
import Portfolio from "./components/Portfolio"
import MultiTabOpener from "./components/MultiTabOpener"
import { AuthProvider } from './context/AuthContext';
import Formatter from "./components/Formatter"
import CssBaseline from '@mui/material/CssBaseline';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { ThemeProvider, createTheme } from '@mui/material/styles';

// Create the theme
const theme = createTheme({
  breakpoints: {
    values: {
      xs: 0,
      sm: 600,
      md: 900,
      lg: 1200,
      xl: 1536,
    },
  },
  palette: {
    primary: {
      main: '#ef6c00',
    },
    secondary: {
      main: '#ffe0b2',
    },
    third:{
      main: '#fdfbe2'
    }
  },
});

function App() {
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <SnackbarProvider maxSnack={3}> {/* Configure the SnackbarProvider here */}
        <AuthProvider>
          <BrowserRouter>
            <Routes>
              <Route exact path='/login' element={<Login />} />
              <Route path='/home' element={<Home />} />
              <Route path='/link-manager' element={<MultiTabOpener />} />
              <Route path='/formatter' element={<Formatter />} />
              <Route path='/portfolio' element={<Portfolio />} />
              <Route exact path='/' element={<Home />} />
            </Routes>
          </BrowserRouter>
        </AuthProvider>
      </SnackbarProvider>
    </ThemeProvider>
  );
}

export default App;
