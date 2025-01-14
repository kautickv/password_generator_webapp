import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import Box from "@mui/material/Box";
import Typography from "@mui/material/Typography";
import LinearProgress from "@mui/material/LinearProgress";
import Divider from "@mui/material/Divider";

// Import components
import SlackChannel from "./SlackChannel";
import AlertComponent from "../common/AlertComponent";
// Import scripts
import { getSlackData } from "../../utils/homeUtils";
import { checkLocalStorageForJWTToken } from "../../utils/util";

function SlackMetrics() {
  const navigate = useNavigate();
  const [slackData, setSlackData] = useState(null);
  const [isError, setIsError] = useState(false);
  // Alerts state
  const [alerts, setAlerts] = React.useState([]);
  
  useEffect(() => {
    // Fetch slack data
    async function fetchSlackData() {
      try {
        let jwtToken = checkLocalStorageForJWTToken();
        if (jwtToken !== "") {
          let response = await getSlackData(jwtToken);
          response = JSON.parse(response);
          //for (let key in response) {
          // for (let msg in response[key]) {
          // console.log(response[key][msg]["text"]);
          // }
          //}
          setSlackData(response);
        } else {
          // User credentials not valid
          navigate("/login");
        }
      } catch (err) {
        setIsError(true);
        console.log(`Error fetching slack data: ${err}`);
        addAlert(
          "error",
          "An error occurred while getting slack data. Please try again later."
        );
      }
    }

    // Trigger fetch data
    fetchSlackData();
  }, [navigate]);

  if (!slackData) {
    return <LinearProgress />;
  }

  if (isError) {
    return "Error";
  }

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
  
  function handleClose(id) {
    setAlerts(function (prevAlerts) {
      return prevAlerts.filter(function (alert) {
        return alert.id !== id;
      });
    });
  }

  return (
    <>
      <Box sx={{ p: 2 }}>
        <Typography variant="h6" gutterBottom>
          Slack Metrics
        </Typography>
        {Object.entries(slackData).map(([channel, messages], index, arr) => (
          <React.Fragment key={channel}>
            <SlackChannel channel={channel} messages={messages} />
            {index !== arr.length - 1 && <Divider sx={{ my: 2 }} />}
          </React.Fragment>
        ))}
      </Box>
      {alerts.map((alert) => (
        <AlertComponent
          key={alert.id}
          open={true}
          severity={alert.severity}
          message={alert.message}
          handleClose={() => handleClose(alert.id)}
        />
      ))}
    </>
  );
}

export default SlackMetrics;
