# **How to setup chainlink node**

## Setting up the `.env` file

```
    mkdir ~/.chainlink-kovan
    touch .env
```

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

```
    sudo -i -u postgres
    psql
    ALTER USER postgres PASSWORD '12345678'
```

- Postges setup:

```
    username: postgres
    password: postgres
    server: localhost
    port: 5432
    database: postgres
```

- Add these to your `~/.chainlink-kovan/.env` file

```
    DATABASE_URL=postgresql://postgres:postgres@localhost:5432/postgres
    DATABASE_TIMEOUT=0
```

## Resources

- https://docs.chain.link/docs/running-a-chainlink-node
- https://docs.chain.link/docs/fulfilling-requests
- https://docs.chain.link/docs/job-specifications#config

# **How to start chainlink node?**

```
    cd ~/.chainlink-kovan
    docker run --name chainlink-kovan --network host -p 6688:6688 -v ~/.chainlink-kovan:/chainlink -it --env-file=.env smartcontract/chainlink:0.10.3 local n

    Visit: http://localhost:6688/
```

- Stopping & deleting container:

```
    docker stop chainlink-kovan && docker container rm chainlink-kovan
```

- `docker network ls`: make sure host is there.

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
- `truffle exec scripts/4_read_val.js --network kovan`

- `node main.js`: Check postgres connection & NODE funds

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

```
$ truffle run verify Oracle APIConsumer Token --network kovan --license MIT
Verifying Oracle
Contract source code already verified: https://kovan.etherscan.io/address/0xa4B3F31cED36617A454F660Be10B97456922cbE0#contracts
Verifying APIConsumer
Pass - Verified: https://kovan.etherscan.io/address/0xBdC3FcC0BEd515F09221dB7FA1B161052D8a3F23#contracts
Verifying Token
Pass - Verified: https://kovan.etherscan.io/address/0xFE96C2094A3dF1ec1B7C3d42B92Fe7DB6cFd4e66#contracts
Successfully verified 3 contract(s).
Done in 29.99s.
```

- [Node address: `0xBcabE53a3cd718bc48137831f6F788C8AB35D10a`](https://kovan.etherscan.io/address/0xBcabE53a3cd718bc48137831f6F788C8AB35D10a)
- Job address: `68e165d25145484b9effc50925d09889`

# **How to run local express server**
- `yarn server`: Start in *dev* mode
- `yarn start`: Start in *prod* mode