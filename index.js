const express = require("express");
const assert = require("assert");
const axios = require("axios");
var cors = require('cors');
const app = express();

app.use(express.static('public'))
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(cors({credentials: true, origin: true})); // Use this after the variable declaration

app.get("/status", (req, res) => {
  res.send({ status: "OK" });
});

// Click this for testing: http://localhost:5000/check/nft/0xcfdf8fffaa4dd7d777d448cf93dd01a45e97d782/LINK
app.get("/check/nft/:user/:tokenSymbol", async (req, res) => {
  const user = req.params.user;
  const tokenSymbol = req.params.tokenSymbol;

  returnStatus = false;
  url = `https://api.thegraph.com/subgraphs/name/sksuryan/baby-shark`;
  query = {
    query:
      `{ symbols(orderBy: totalDeposit, orderDirection: desc, first: 5, where: {symbol: "` +
      tokenSymbol +
      `"}) { id totalDeposit symbol user eligibleForNFT } }`,
  };
  winnerArray = (await axios.post(url, query)).data.data.symbols;

  assert(winnerArray.length <= 5 && winnerArray.length >= 0);

  for (i = 0; i < winnerArray.length; i++) {
    if (winnerArray[i].user == user) {
      returnStatus = true;
      break;
    }
  }

  res.send({ result: returnStatus });
});

app.listen(process.env.PORT || 5000, () => {
  console.log(`Server started at http://localhost:${5000}`);
});
