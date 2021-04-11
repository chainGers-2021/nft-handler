# **How to setup chainlink node**

## Setting up the `.env` file

- `mkdir ~/.chainlink-kovan`
- `touch .env`

- Put this inside your `~/.chainlink-kovan/.env` file:

```
    ROOT=/chainlink
    LOG_LEVEL=debug
    ETH_CHAIN_ID=42
    MIN_OUTGOING_CONFIRMATIONS=2
    LINK_CONTRACT_ADDRESS=0xa36085F69e2889c224210F603D836748e7dC0088
    CHAINLINK_TLS_PORT=0
    SECURE_COOKIES=false
    GAS_UPDATER_ENABLED=true
    ALLOW_ORIGINS=*
    ETH_URL=CHANGEME
```

## Set the local `postgres` DATABASE_URL Config

- `sudo -i -u postgres`
- `psql`
- `ALTER USER postgres PASSWORD '12345678'`
- **Postges setup**:

```
    username: postgres
    password: postgres
    server: localhost
    port: 5432
    database: postgres
```

- Add these to your `~/.chainlink-kovan/.env` file:

```
    DATABASE_URL=postgresql://postgres:postgres@localhost:5432/postgres
    DATABASE_TIMEOUT=0
```

## Helpful resources

- https://docs.chain.link/docs/running-a-chainlink-node
- https://docs.chain.link/docs/fulfilling-requests
- https://docs.chain.link/docs/job-specifications#config

# **How to start chainlink node?**

- `cd ~/.chainlink-kovan`
- `docker run --name chainlink-kovan --network host -p 6688:6688 -v ~/.chainlink-kovan:/chainlink -it --env-file=.env smartcontract/chainlink:0.10.3 local n`
- [Visit in browser: localhost:6688](http://localhost:6688/) and sign in with your credentials
- `docker network ls`: make sure host is there.

# Stopping & deleting container:

- `docker stop chainlink-kovan && docker container rm chainlink-kovan`

## Screenshots

- <img src="./help/1.png" width="800" />
- <img src="./help/3.png" width="800" />
- <img src="./help/2.png" width="800" />

# **How to deploy APIConsumer**

- Assuming that you have successfully setup the chainlink node.
- `truffle compile`
- `truffle migrate --reset --network kovan`/`truffle migrate --f 3 --network kovan`(If you update APIConsumer only.)
- `yarn verify`
- `truffle exec scripts/1_fund_link.js --network kovan`
- Needs to be done for the first time:

  - `truffle exec scripts/2_add_permission.js --network kovan`
  - Add a new job from the NODE UI, with [job spec](https://docs.chain.link/docs/job-specifications#config) from: `job_specs/eth=>bool.json` & **don't forget to copy Oracle address into job_spec**

- `truffle exec scripts/3_request.js --network kovan`
- You can see a job assingned in the node operator browser window:
  - as it will succeed, check the transaction hash for any errors
- `truffle exec scripts/4_read_val.js --network kovan`

- `node help/postgres.check.js`: Check postgres connection & NODE funds

# **How to run local express server**

- `yarn server`: Start in _dev_ mode
- `yarn start`: Start in _prod_ mode
- Open a query like: [http://localhost:5000/check/nft/0xcfdf8fffaa4dd7d777d448cf93dd01a45e97d782/LINK](http://localhost:5000/check/nft/0xcfdf8fffaa4dd7d777d448cf93dd01a45e97d782/LINK)

## **ENV** variables for the project

A template of `.env` file is already given as `.env.example`, set them accordingly:

```
LINK_CONTRACT_ADDRESS="..."
RPC_URL="..."
MNEMONIC="..."
NODE_ADDRESS="..."
JOB_ID="..."
ETHERSCAN_API_KEY="..."
```

## Directory structure

```
pam@g3:~/cl-node$ tree -I 'node_modules|build'
.
├── contracts
│   ├── Distributor
│   │   ├── APIConsumer.sol
│   │   └── TokenHandler.sol
│   ├── ERC1155
│   │   └── Token.sol
│   └── Migrations.sol
├── help
│   ├── node.info.js
│   ├── postgres.check.js
│   └── query.js
├── index.js
├── job_specs
│   └── eth=>bool.json
├── migrations
│   ├── 1_initial_migration.js
│   ├── 2_oracle.js
│   ├── 3_token.js
│   └── 4_testnet_consumer.js
├── package.json
├── README.md
├── scripts
│   ├── 1_fund_link.js
│   ├── 2_add_permission.js
│   ├── 3_request.js
│   └── 4_read_val.js
├── truffle-config.js
└── yarn.lock

7 directories, 21 files
```

## Deployments

- [**Verified Oracle**](https://kovan.etherscan.io/address/0x67890F4627D46E099fE490fF9D8ac1Cf5290b1F0#contracts)
- [**Verified APIConsumer**](https://kovan.etherscan.io/address/0x20750a5ae430225B41789e03a8b5889b5c9d5E70#contracts)
- [**Verified Token**](https://kovan.etherscan.io/address/0x95BeFa7cf8801b1db372e2B1908FbEBB7D5810E1#contracts)
- [**Node address: `0xBcabE53a3cd718bc48137831f6F788C8AB35D10a`**](https://kovan.etherscan.io/address/0xBcabE53a3cd718bc48137831f6F788C8AB35D10a)
<<<<<<< Updated upstream:index.md
- [JobId: `0f79687897bc48b8928bd133a52042e2`](./job_specs/eth=>bool.json)
  
=======
- [**JobId: `0f79687897bc48b8928bd133a52042e2`**](./job_specs/eth=>bool.json)
  
>>>>>>> Stashed changes:README.md
