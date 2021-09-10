require("dotenv").config();
const axios = require("axios");
const Web3 = require("web3");
const bytes32 = require("bytes32");
const HDWalletProvider = require("@truffle/hdwallet-provider");

const Horse = require("./build/contracts/Horse.json");

const getCount = async () => {
  const projectID = process.env.PROJECT_ID;
  const web3 = new Web3(`https://kovan.infura.io/v3/${projectID}`);
  const contract = new web3.eth.Contract(Horse.abi, process.env.CONTRACT_ADDRESS);
  
  const count = await contract.methods.count().call();
  console.log(count);
}

const addResult = (result) => {
  _addResult(result.track, result.year, result.month, result.day, result.number, result.first, result.second, result.third, result.forth);
}

const addResultAsync = async(result) => {
  await _addResultAsync(result.track, result.year, result.month, result.day, result.number, result.first, result.second, result.third, result.forth);
}

const _addResultAsync = async (track, year, month, day, race, first, second, third, forth) => {
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

  const contract = new web3.eth.Contract(Horse.abi, process.env.CONTRACT_ADDRESS);
  const _nm = bytes32({ input: track });
  const result = await contract.methods.addResult(_nm, year, month, day, race, [first, second, third, forth]).send({ from: accounts[0]}); // , gas: 50000, gasPrice: 10e9
  console.log(result);
}

const _addResult = (track, year, month, day, race, first, second, third, forth) => {
  const projectID = process.env.PROJECT_ID;
  const privateKey = process.env.PRIVATE_KEY;
  const provider = new HDWalletProvider({
    mnemonic: {
      phrase: process.env.MNEMONIC
    },
    providerOrUrl: `https://kovan.infura.io/v3/${projectID}`
  });

  const web3 = new Web3(provider);
  const contract = new web3.eth.Contract(Horse.abi, process.env.CONTRACT_ADDRESS);
  const _nm = bytes32({ input: track });
  contract.methods.addResult(_nm, year, month, day, race, [first, second, third, forth]).send({ from: accounts[0]}); // , gas: 50000, gasPrice: 10e9
}

const getTodaysRaces = async () => {
  const today = new Date();
  const dd = String(today.getDate()).padStart(2, "0");
  const mm = String(today.getMonth() + 1).padStart(2, "0"); // January is 0!
  const yyyy = today.getFullYear();

  console.log(`${yyyy}-${mm}-${dd}`);
  await getRaces(yyyy, mm, dd);
};

const getRaces = async (yyyy, mm, dd) => {
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
  await addResultAsync(todaysResults[1]);
  //addResult(todaysResults[1]);
  console.log("done!");
}

const getAndAddTodaysRaces2 = async () => {
  const todaysResults = await getTodaysRaces();
  addResult(todaysResults[0]);
}

getCount();
getAndAddTodaysRaces();

