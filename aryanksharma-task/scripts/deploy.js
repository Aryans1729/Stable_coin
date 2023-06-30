const hre = require("hardhat");

const BNB_USD_priceFeed_address = "0x2514895c72f50D8bd4B4F9b1110F0D6bD2c97526";

const deploy = async () => {
  const contract = await hre.ethers.deployContract("StableCoin", [
    BNB_USD_priceFeed_address,
  ]);
  await contract.waitForDeployment();
  console.log(
    `Contract deployed on '${hre.network.name}' at: ${contract.target}`
  );
};

deploy().catch((e) => console.log(e));
