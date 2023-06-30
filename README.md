Stable Coin ( nUSD )
Important: Make sure since this coin is deployed on BNB so token will be minted according to the price of BNB in USD ( for Eg: 1BNB = 233.59 USD currently)
🏹 Deployed Contract Address
BscTestnet : 0x435FB040d6f905c28997F87d9b9F8c13181F1Df4

Try Out React App:
App URL :
https://main--rococo-dieffenbachia-b8d89c.netlify.app/

Step:1 Run these commands in terminal to run locally
git clone https://github.com/007aryansaini/Stable-Coin.git
cd Stable-Coin
cd front-end
Step:2 Install node modules in the current directory
npm i
Step:3 Start react app
npm start
Try Out Blockchain commands:
This is a Stable Coin which is minted based on the price of ETH/BNB that is fetched from oracle. It allows users to deposit ETH/BNB and receive 50% of its value in nUSD. The amount of nUSD required to convert to ETH is double the value.

Some important Steps before running below commands
Change the directory to blockchain folder
cd ..
cd blockchain
Install node modules required for this project
npm i
Make sure to have .env file with 3 variables that hold your privateKey, BscScan Api key and Coin Market Cap api key with name same as below:

BSCSCAN_API = "Your_API_Key"
COINMARTKETCAP_API = "Your_API_Key"
DEPLOYER_PRIVATE_KEY = "Your_API_Key"
To Compile smart contract
npx hardhat compile
To Deploy smart Contract on bscTestnet
npx hardhat run --network bscTestnet scripts/deploy.js
To Run testing script for smart contract
npx hardhat test
