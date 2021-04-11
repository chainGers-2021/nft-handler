const APIConsumer = artifacts.require("APIConsumer");
const Token = artifacts.require("Token");
const assert = require("assert");

contract("TokenHolder", async (addresses) => {
  var con;
  const [admin, user1, user2, _] = addresses;

  before(async () => {
    token = await Token.new("");
    con = await APIConsumer.new(token.address);
  });

  it("can mints tokens.", async () => {
    await con.mintTokens("X1");
    await con.mintTokens("X2");
    await con.mintTokens("X3");
    await con.mintTokens("X4");
    await con.mintTokens("X5");
  });

  it("can distribute tokens successfully.", async () => {
    for (i = 0; i < 5; i++) {
      await con.requestNFTClaim(
        admin,
        "",
        "X1",
        web3.utils.sha3(i.toString()),
        {
          from: addresses[i],
        }
      );
      await con.fulfillNFTClaim(web3.utils.sha3(i.toString()), true);
    }
    for (i = 0; i < 5; i++) {
      await con.requestNFTClaim(
        admin,
        "",
        "X2",
        web3.utils.sha3(i.toString()),
        {
          from: addresses[i],
        }
      );
      await con.fulfillNFTClaim(web3.utils.sha3(i.toString()), true);
    }
    for (i = 0; i < 5; i++) {
      await con.requestNFTClaim(
        admin,
        "",
        "X3",
        web3.utils.sha3(i.toString()),
        {
          from: addresses[i],
        }
      );
      await con.fulfillNFTClaim(web3.utils.sha3(i.toString()), true);
    }
    for (i = 0; i < 5; i++) {
      await con.requestNFTClaim(
        admin,
        "",
        "X4",
        web3.utils.sha3(i.toString()),
        {
          from: addresses[i],
        }
      );
      await con.fulfillNFTClaim(web3.utils.sha3(i.toString()), true);
    }
    for (i = 0; i < 5; i++) {
      await con.requestNFTClaim(
        admin,
        "",
        "X5",
        web3.utils.sha3(i.toString()),
        {
          from: addresses[i],
        }
      );
      await con.fulfillNFTClaim(web3.utils.sha3(i.toString()), true);
    }
  });
});
