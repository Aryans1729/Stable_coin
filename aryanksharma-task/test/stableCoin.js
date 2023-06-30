const { ethers, network } = require("hardhat");
const { expect } = require("chai");

const BNB_USD_priceFeed_address = "0x2514895c72f50D8bd4B4F9b1110F0D6bD2c97526";

describe("Testing scripts", () => {
  let Contract;
  let owner;
  let addr1;
  let earlierTotalSupply;
  let price;
  before(async () => {
    [owner, addr1] = await ethers.getSigners();
    Contract = await ethers.deployContract("StableCoin", [
      BNB_USD_priceFeed_address,
    ]);
    await Contract.waitForDeployment();
  });

  it("Should successfully deploy the stable coin (nUSD)", async () => {
    expect(Contract.target);
  });

  it("Should return the price of BNB in USD", async () => {
    console.log(await Contract.getPriceOfETHBNB());
  });

  it("Should allow the user to  buy nUSD", async () => {
    earlierTotalSupply = await Contract.totalSupply();
    await Contract.buy({ value: ethers.parseEther("1") });
    price = await Contract.getPriceOfETHBNB();
  });

  it("Should increase the totalSupply", async () => {
    const currentTotalSupply = await Contract.totalSupply();
    expect(currentTotalSupply - earlierTotalSupply).to.be.equal(price / 2n);
  });

  it("Should allow users to redeem ETH after giving nUSD token", async () => {
    const tokensToRedeem = await Contract.balanceOf(owner.address);
    await Contract.redeem(tokensToRedeem.toString());
  });
});
