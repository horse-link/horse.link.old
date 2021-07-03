const axios = require("axios");

const getTodaysRaces = async () => {
  const today = new Date();
  const dd = String(today.getDate()).padStart(2, "0");
  const mm = String(today.getMonth() + 1).padStart(2, "0"); //January is 0!
  const yyyy = today.getFullYear();

  console.log(`${yyyy}-${mm}-${dd}`);

  const result = await axios.get(
    `https://api.beta.tab.com.au/v1/tab-info-service/racing/dates/${yyyy}-${mm}-${dd}/meetings?jurisdiction=QLD`
  );

  // console.log(result.data?.meetings);

  result.data?.meetings.forEach((element) => {
    //if (element.results) {
    // console.log(element);
    //}

    element.races.forEach((race) => {
      if (race.results && race.results.length > 0) {
        console.log(element.meetingName);
        console.log(element.venueMnemonic);
        console.log(race.raceName);
        console.log(race.results);
      }
    });
  });
};

getTodaysRaces();
