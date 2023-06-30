#Stable Coin 
Important: Make sure since this coin is deployed on BNB so token will be minted according to the price of BNB in USD ( for Eg: 1BNB = 233.59 USD currently)
🏹 Deployed Contract Address
BscTestnet : 0x5f7d6213bd251559808386Ee083C357a1Ef43792

#Try Out React App:
App URL : https://stablecointask.netlify.app/

#Step:1 Run these commands in terminal to run locally
link : https://github.com/Aryans1729/Stable_coin
cd Stable-Coin
cd front-end
#Step:2 Install node modules in the current directory
npm i
#Step:3 Start react app
npm start


#Some important Steps before running below commands
#Change the directory to blockchain folder
cd ..
cd blockchain
#Install node modules required for this project
npm i
Make sure to have .env file with 3 variables that hold your privateKey, BscScan Api key and Coin Market Cap api key with name same as below:


#To Compile smart contract
npx hardhat compile
#To Deploy smart Contract on bscTestnet
npx hardhat run --network bscTestnet scripts/deploy.js
#To Run testing script for smart contract
npx hardhat test
