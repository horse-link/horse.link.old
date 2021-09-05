// require("dotenv");
require('dotenv').config();
const axios = require("axios");
const Web3 = require("web3");
const bytes32 = require("bytes32");
const HDWalletProvider = require("@truffle/hdwallet-provider");

const json = require("./build/contracts/Horse.json");

const getCount = async () => {
  const projectID = process.env.PROJECT_ID;
  const web3 = new Web3(`https://kovan.infura.io/v3/${projectID}`);
  const contract = new web3.eth.Contract(json.abi, process.env.CONTRACT_ADDRESS);
  
  const count = await contract.methods.count().call();
  console.log(count);
}

const addResult = async(result) => {
  await _addResult(result.track, result.year, result.month, result.day, result.number, result.first, result.second, result.third, result.forth);
}

const _addResult = async (track, year, month, day, race, first, second, third, forth) => {
  const projectID = process.env.PROJECT_ID;
  const privateKey = process.env.PRIVATE_KEY;
  const provider = new HDWalletProvider({
    mnemonic: {
      phrase: process.env.MNEMONIC
    },
    providerOrUrl: `https://kovan.infura.io/v3/${projectID}`
  });

  const web3 = new Web3(provider);
  const accounts = await web3.eth.getAccounts();
  console.log(accounts[0]);

  const contract = new web3.eth.Contract(json.abi, process.env.CONTRACT_ADDRESS);
  const _nm = bytes32({ input: track });
  const result = await contract.methods.addResult(_nm, year, month, day, race, [first, second, third, forth]).send({ from: accounts[0]}); // , gas: 50000, gasPrice: 10e9
  console.log(result);
}

const getTodaysRaces = async () => {
  const today = new Date();
  const dd = String(today.getDate()).padStart(2, "0");
  const mm = String(today.getMonth() + 1).padStart(2, "0"); // January is 0!
  const yyyy = today.getFullYear();

  console.log(`${yyyy}-${mm}-${dd}`);

  const result = await axios.get(
    `https://api.beta.tab.com.au/v1/tab-info-service/racing/dates/${yyyy}-${mm}-${dd}/meetings?jurisdiction=QLD`
  );

  let results = [];
  result.data.meetings.forEach(async (element) => {
    element.races.forEach(async (race) => {
      if (race.results && race.results.length > 0) {
        console.log(`${element.meetingDate} ${element.meetingName} ${element.venueMnemonic}`);
        console.log(`${race.raceNumber} ${race.raceName}`);
        console.log(race.results);

        const _result = {
          track: element.venueMnemonic,
          year: yyyy,
          month: mm,
          day: dd,
          number: race.raceNumber,
          first: race.results[0], 
          second: race.results[1], 
          third: race.results[2], 
          forth: race.results[3]
        }

        results.push(_result);
      }
    });
  });

  return results;
};

const getAndAddTodaysRaces = async () => {
  const todaysResults = await getTodaysRaces();
  await addResult(todaysResults[2]);
  console.log("done!");
}

getCount();
getAndAddTodaysRaces();


//2021-07-04 SHA TIN SHA
// 2 THE PURVES QUAICH TURF
// [ [ 12 ], [ 4 ], [ 8 ], [ 11 ] ]
// addResult("CSO", 2021, 9, 2, 11, 6, 2, 5, 9);
