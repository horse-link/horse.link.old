require("dotenv");
const axios = require("axios");
const Web3 = require("web3");
const HDWalletProvider = require("@truffle/hdwallet-provider");

const json = require("./build/contracts/Horse.json");

const getCount = async () => {
  const projectID = process.env.PROJECT_ID;
  const web3 = new Web3(`https://kovan.infura.io/v3/${projectID}`);
  const contract = new web3.eth.Contract(json.abi, "0x95f7594Dc262bb6A969Aeb42E4D9E4BedA94FAa0");
  
  const count = await contract.methods.count().call();
  console.log(count);
}

const addResult = async (track, year, month, day, race, first, second, third, forth) => {
  // 
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

  const contract = new web3.eth.Contract(json.abi, "0x95f7594Dc262bb6A969Aeb42E4D9E4BedA94FAa0");
  const count = await contract.methods.addResult(track, year, month, day, race, [first, second, third, forth]).send({ from: accounts[0]}); // , gas: 50000, gasPrice: 10e9
  console.log(count);
}

const getTodaysRaces = async () => {
  const today = new Date();
  const dd = String(today.getDate()).padStart(2, "0");
  const mm = String(today.getMonth() + 1).padStart(2, "0"); //January is 0!
  const yyyy = today.getFullYear();

  console.log(`${yyyy}-${mm}-${dd}`);

  const result = await axios.get(
    `https://api.beta.tab.com.au/v1/tab-info-service/racing/dates/${yyyy}-${mm}-${dd}/meetings?jurisdiction=QLD`
  );

  result.data.meetings.forEach((element) => {
    element.races.forEach((race) => {
      if (race.results && race.results.length > 0) {
        console.log(`${element.meetingDate} ${element.meetingName} ${element.venueMnemonic}`);
        console.log(`${race.raceNumber} ${race.raceName}`);
        console.log(race.results);

        // let sha = element.filter(x => x.venueMnemonic > "SHA");
      }
    });
  });
};

getCount();
getTodaysRaces();

//2021-07-04 SHA TIN SHA
// 2 THE PURVES QUAICH TURF
// [ [ 12 ], [ 4 ], [ 8 ], [ 11 ] ]
// addResult("0x534841", 2021, 7, 4, 2, 12, 4, 8, 11);