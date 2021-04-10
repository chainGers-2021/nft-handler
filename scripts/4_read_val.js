const Token = artifacts.require("Token");

require("dotenv").config();

module.exports = async function (callback) {
  const accounts = await web3.eth.getAccounts();

  const con = await Token.deployed();

  for (t = 1; t < 4; t++) {
    ids = Array.from({ length: 10 }, (v, i) => t);
    result = await con.balanceOfBatch(accounts, ids);
    for (i = 0; i < result.length; i++) {
      if (parseInt(result[i]) == 1) {
        console.log(accounts[i], " has 1 token of ", i + 1);
      }
    }
  }

  callback("Finished.");
};
