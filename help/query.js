const { default: axios } = require("axios");
const assert = require("assert");

// async function main() {
//   url = `https://query2.finance.yahoo.com/v10/finance/quoteSummary/tsla?modules=price`;
//   res = await axios.get(url);
//   console.log(res.data.quoteSummary.result);
// }
// main();

async function main() {
  returnStatus = false;
  url = `https://api.thegraph.com/subgraphs/name/sksuryan/baby-shark`;
  query = {
    query: `{ symbols(orderBy: totalDeposit, orderDirection: desc, first: 5, where: {symbol: "LINK"}) { id totalDeposit symbol user eligibleForNFT } }`,
  };
  res = (await axios.post(url, query)).data.data.symbols;
  userAddress = `0xcfdf8fffaa4dd7d777d448cf93dd01a45e97d782`;

  assert(res.length <= 5 && res.length >= 1);

  for (i = 0; i < res.length; i++) {
    if (res[i].user == userAddress) {
      returnStatus = true;
      break;
    }
  }

  console.log("Status: ", returnStatus);
}
main();
