// Import the Firebase SDK for Google Cloud Functions.
const functions = require("firebase-functions");

// Import other required modules (e.g., Firebase Admin SDK).
const admin = require("firebase-admin");
admin.initializeApp();
// const {Timestamp} = admin.firestore;


// Example of an HTTP Cloud Function.
exports.helloWorld = functions.https.onRequest((request, response) => {
  response.send("Hello from Firebase!");
});

exports.getDataPoints = functions.https.onRequest(async (request, response) => {
  // getDataPoints(user, startDateTime, endDateTime, x_axis, y_axis)
  /**
   * Converts a time string in HH:MM:SSZ or ISO 8601 format to milliseconds.
   *
   * @param {string} timeString - The time string to convert
   * @return {number} The time represented in milliseconds.
   */
  function cvrtMilli(timeString) {
    const test = timeString.match(/T(\d{2}):(\d{2}):(\d{2})Z/);
    const hours = test[1];
    const minutes = test[2];
    const seconds = test[3];
    // Convert the components to integers
    const hoursInt = parseInt(hours, 10) || 0;
    const minutesInt = parseInt(minutes, 10) || 0;
    const secondsInt = parseInt(seconds, 10) || 0;
    // Calculate the total milliseconds
    let milliseconds = (hoursInt * 60 * 60);
    milliseconds = (milliseconds + (minutesInt * 60) + secondsInt) * 1000;
    return milliseconds;
  }
  // Function to categorize a timestamp
  /**
   * Gets time of day category.
   *
   * @param {Object} timestamp - Timestamp.
   * @return {string} The JSON response containing data points.
   */
  function categorizeTime(timestamp) {
    const morningStart = cvrtMilli("T06:00:00Z");
    const morningEnd = cvrtMilli("T11:59:59Z");

    const afternoonStart = cvrtMilli("T12:00:00Z");
    const afternoonEnd = cvrtMilli("T17:59:59Z");

    const eveningStart = cvrtMilli("T18:00:00Z");
    // console.log("morningStart: "+morningStart);
    // console.log("afternoonStart: "+afternoonStart);
    // console.log("eveningStart: " + eveningStart);
    // console.log("afternoonEnd: " + afternoonEnd);

    if (timestamp >= morningStart && timestamp <= morningEnd) {
      return "Morning";
    } else if (timestamp >= afternoonStart && timestamp <= afternoonEnd) {
      return "Afternoon";
    } else if (timestamp >= eveningStart) {
      return "Evening";
    } else {
      return "Undefined"; // Timestamp doesn't fall into any defined range
    }
  }
  const {user, startDateTime, endDateTime, xAxis, yAxis} = request.query;

  if (xAxis!="time_of_day") {
    return response.status(400).json({error: "Missing or invalid parameters"});
  }
  if (yAxis!="game_success_rate") {
    return response.status(400).json({error: "Missing or invalid parameters"});
  }
  // run the query
  const firestore = admin.firestore();
  const querySnapshot = await firestore.collection("quiz_results")
      .where("user", "==", user)
      .where("timestamp", ">=", startDateTime)
      .where("timestamp", "<=", endDateTime)
      .get();
  const dataPts = [];
  querySnapshot.forEach((doc) => {
    const data = doc.data();
    // dataPoints.push(data);
    dataPts.push([categorizeTime(cvrtMilli(data["timestamp"])), data[yAxis]]);
    // break
  });
  const dataByTimeOfDay = {};
  // Iterate through the dataPoints array and group by timeOfDay
  dataPts.forEach((data) => {
    if (!dataByTimeOfDay[data[0]]) {
      dataByTimeOfDay[data[0]] = [];
    }

    dataByTimeOfDay[data[0]].push(data[1]);
  });

  // Calculate the average for each timeOfDay and store it in newDataPoints
  const newDataPoints = {};

  for (const [timeOfDay, values] of Object.entries(dataByTimeOfDay)) {
    const sum = values.reduce((acc, currentValue) => acc + currentValue, 0);
    const average = sum / values.length;

    newDataPoints[timeOfDay]= average;
  }
  // response.send("This is my user: "+request.query['user']);
  response.send(newDataPoints);
});
