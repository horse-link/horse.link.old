const axios = require("axios");

const getTodaysRaces = async () => {
    const today = new Date();
    const dd = String(today.getDate()).padStart(2, "0");
    const mm = String(today.getMonth() + 1).padStart(2, "0"); //January is 0!
    const yyyy = today.getFullYear();

    console.log(`${yyyy}-${mm}-${dd}`);

    const result = await axios.get(`https://api.beta.tab.com.au/v1/tab-info-service/racing/dates/${yyyy}-${mm}-${dd}/meetings?jurisdiction=QLD`);

    console.log(result);
}



// const config = {
//   method: "get",
//   url: "https://api.beta.tab.com.au/v1/tab-info-service/racing/dates/2021-07-03/meetings?jurisdiction=QLD",
//   headers: {},
// };

getTodaysRaces();
