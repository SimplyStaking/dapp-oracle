# Setup Guide

This is a step-by-step guide explaining how to set up a Chainlink node and an oracle on Agoric

## Requirements

Make sure you have the following requirements before starting:
1. node (Minimum version 14.15.0)
2. docker
3. docker-compose

## Step 1: Installing Agoric CLI

``` bash
node --version # 14.15.0 or higher
npm install --global yarn
git clone https://github.com/Agoric/agoric-sdk
cd agoric-sdk
yarn install
yarn build
yarn link-cli ~/bin/agoric
echo "export PATH=$PATH:$HOME/bin" >> ~/.profile
source ~/.profile
agoric --version
```

## Step 2: Change Network Config File

Change the IP in the file found in <b>chainlink-agoric/etc/network-config.json</b>

```json
{
  "chainName": "agoric",
  "gci": "http://<ip>:26657/genesis",
  "rpcAddrs": [
    "<ip>:26657"
  ]
}
```

## Step 3: Start a local chain

Before the setup, we have to start a local chain.

```bash
#run this in the root directory of this project
agoric start local-chain &> chain.log &
```

## Step 4: Run setup script

The next step involves running the script found at <b>chainlink-agoric/setup</b>.

```bash
#run this in the root directory of this project
cd chainlink-agoric
./setup
```

This setup script does the following:
1. Starts docker containers via <b>chainlink-agoric/internal-scripts/common.sh</b> for:
    - Postgres DB Instance
    - Chainlink Node
    - Agoric local solo node to interact with the chain started in Step 3
    - Chainlink Agoric External Adapter
    - Chainlink Agoric External Initiator
2. Creates an Oracle with a dApp via <b>chainlink-agoric/internal-scripts/add-dapp-oracle.sh</b> which does the following:
    - Transferscoins to the ag-solo node
    - Installs the dapp-oracle contract
    - Adds the dapp-oracle to theAgoric nod
3. Adds the external initiator to the Chainlin knode via <b>chainlink-agoric/internal-scripts/add-ei.sh</b>
4. Adds the external adapter to the bridges section of the Chainlink node via <b>chainlink-agoric/internal-scripts/add-bridge.sh</b>
5. Adds a jobspec tot he Chainlink node via <b>chainlink-agoric/internal-scripts/add-jobspec.sh</b>

## Step 5: Record the output

The setup script from the previous step returns an output of this format

```
board:<board_num> jobId:"<job_id>" ?API_URL=http://localhost:6891 CL=http://localhost:6691
```

Store this somewhere but if it is lost, this can be obtained by running

```bash
#run this in the root directory of this project
cd chainlink-agoric
node show-jobs.js
```


## Step 6: Log in the Chainlink node

1. Head to either:
    - <b>http://localhost:6691</b> (If from the same VM)
    - <b>http://<vm_ip>:6691</b> (If remotely)
2. Login with
```
Email: notreal@fakeemail.ch
Password: twochains
```

### Step 6A: Confirm that a job exists

a) Head to Jobs
b) Make sure there is a job

<img src="jobs.png"></img>

### Step 6B: Confirm there is a bridge

a) Head to Bridges
b) Make sure there is a bridge

<img src="bridges.png"></img>

## Step 7: Start Oracle dApp UI

```bash
#run this in the root directory of this project
cd ui
yarn install
yarn start
```

Check the UI at either
    - <b>http://localhost:3000?API_URL=http://<ag_solo_ip>:6891</b> (If from the same VM)
    - <b>http://<vm_ip>:3000?API_URL=http://<ag_solo_ip>:6891</b> (If remotely)

<img src="ui.png"></img>

## Step 7A: Change board

Change the board number to the board number obtained from Step 5

<img src="board.png"></img>

## Step 7A: Change jobId 

Change jobId from the job ID obtained from Step 5

<img src="jobid.png"></img>
