import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import Grid from "@mui/material/Grid";
import Paper from "@mui/material/Paper";
import Box from "@mui/material/Box";
import Typography from "@mui/material/Typography";
import Avatar from "@mui/material/Avatar";
import Stack from "@mui/material/Stack";
// Import scripts
import { sendVerifyAPIToAuthenticationServer } from "../../utils/util";
import {checkLocalStorageForJWTToken} from "../../utils/homeUtils"

// Import components
import LoadingSpinner from "../common/LoadingSpinner";
import Navbar from "../common/Navbar";
import SlackMetrics from "./SlackMetrics";

function Home() {
  const navigate = useNavigate();
  const [userFirstName, setUserFirstName] = useState("");
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    // Check if JWT token exists
    const verifyIfUserLoggedIn = async () => {
      let jwtToken = checkLocalStorageForJWTToken();
      if (jwtToken) {
        // Check if JWT token is valid and if user is logged in
        let verifyResponse = await sendVerifyAPIToAuthenticationServer(
          jwtToken
        );

        if (verifyResponse.status === 200) {
          // User is already logged in
          let userInfo = await verifyResponse.json();
          let userName = userInfo["token_details"]["username"];
          setUserFirstName(userName.split(" ")[0]); // Get the first Name

          setIsLoading(false);
        } else if (verifyResponse.status === 401) {
          // User JWT token is not valid or expired
          localStorage.removeItem("JWT_Token");
          navigate("/login");
        } else {
          console(
            `An error has occurred. Verify Path returns ${verifyResponse}`
          );
          alert("An error has occurred. Please try again later");
        }
      } else {
        //Token not found.
        localStorage.removeItem("JWT_Token");
        navigate("/login");
      }
    };

    setIsLoading(true);
    verifyIfUserLoggedIn();
  }, [navigate]);


  if (isLoading) {
    return <LoadingSpinner description="Please wait ..." />;
  }

  return (
    <>
      <Navbar />
      <Box sx={{ flexGrow: 1, m: 2 }}>
        <Grid container spacing={2}>
          <Grid item xs={12}>
            <Paper elevation={2} sx={{ padding: 1, marginBottom: 2 }}>
              <Stack
                direction="row"
                justifyContent="flex-start"
                alignItems="center"
                spacing={2}
              >
                <Avatar sx={{ width: 30, height: 30, fontSize: "1rem" }}>
                  {userFirstName.charAt(0)}
                </Avatar>
                <Typography variant="h6" component="div">
                  Hello, {userFirstName}
                </Typography>
              </Stack>
            </Paper>
          </Grid>
          <Grid item xs={12} sm={6}>
            <Paper>{/* Insert Jira tickets component here */}</Paper>
          </Grid>
          <Grid item xs={12} sm={6}>
            <Paper>
              <SlackMetrics />
            </Paper>
          </Grid>
          {/* More grid items as needed */}
        </Grid>
      </Box>
    </>
  );
}

export default Home;
