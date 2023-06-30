import React, { useState } from "react";
import "./App.css";
import abi from "./ABI.json";
import { ethers } from "ethers";

const CONTRACT_ADDRESS = "0x5f7d6213bd251559808386Ee083C357a1Ef43792";

const App = () => {
  const [contract, setContract] = useState(null);
  const [balance, setBalance] = useState(0);
  const [userAddress, setUserAddress] = useState("");
  const [isMetamaskConnected, setIsMetamaskConnected] = useState(false);
  const [totalSupply, setTotalSupply] = useState(0);
  const [nUSD, setnUsdBal] = useState(0);
  const [bnbAmount, setBNBAmount] = useState("");
  const [nUSDAmount, setnUSDAmount] = useState("");

  const handleChange = (event) => {
    setBNBAmount(event.target.value);
  };

  const handleChangeNUSD = (event) => {
    setnUSDAmount(event.target.value);
  };
  const onConnectHandler = async () => {
    try {
      if (window.ethereum) {
        const provider = new ethers.BrowserProvider(window.ethereum);
        const accounts = await provider.send("eth_requestAccounts", []);
        const network = await provider.getNetwork();
        const chainId = network.chainId;

        if (chainId !== 97n) {
          alert("Please switch to Bsc Testnet in Metamask and then connect");
          return;
        }

        let balanceOfUser = await window.ethereum.request({
          method: "eth_getBalance",
          params: [accounts[0], "latest"],
        });
        balanceOfUser = parseInt(balanceOfUser, 16).toString();
        balanceOfUser = ethers.formatEther(balanceOfUser);
        balanceOfUser = parseFloat(balanceOfUser).toFixed(2);

        const signer = await provider.getSigner();
        let contract = new ethers.Contract(CONTRACT_ADDRESS, abi, signer);

        let TS = await contract.totalSupply();
        TS = ethers.formatUnits(TS, 8);

        let NUSDBAL = await contract.balanceOf(accounts[0]);
        NUSDBAL = ethers.formatUnits(NUSDBAL, 8);

        setContract(contract);
        setnUsdBal(NUSDBAL.toString());
        setTotalSupply(TS.toString());
        setUserAddress(accounts[0]);
        setBalance(balanceOfUser);
        setIsMetamaskConnected(true);
      } else {
        alert("You need to install metamask first");
        return;
      }
    } catch (error) {
      alert(error.meaage);
    }
  };

  const onBuy = async (e) => {
    try {
      e.preventDefault();
      const _amount = bnbAmount.toString();
      let amount = ethers.parseEther(_amount);

      if (amount === 0n) {
        alert("Enter valid amount");
        return;
      }

      setBNBAmount("");
      const tx = await contract.buy({ value: amount });
      const receipt = await tx.wait();

      if (receipt.status === 1) {
        let _newTS = await contract.totalSupply();
        let _newBal = await contract.balanceOf(userAddress);

        _newTS = ethers.formatUnits(_newTS, 8);
        _newBal = ethers.formatUnits(_newBal, 8);

        setTotalSupply(_newTS.toString());
        setnUsdBal(_newBal.toString());
        alert("Tx Successful");
        return;
      }
    } catch (error) {
      alert(error.message);
    }
  };

  const redeem = async (e) => {
    try {
      e.preventDefault();
      const _amount = nUSDAmount.toString();

      const amount = ethers.parseUnits(_amount, 6);

      if (amount === 0n) {
        alert("Enter valid amount");
        return;
      }

      setnUSDAmount("");
      const tx = await contract.redeem(amount);
      const receipt = await tx.wait();

      if (receipt.status === 1) {
        let _newTS = await contract.totalSupply();
        let _newBal = await contract.balanceOf(userAddress);

        _newTS = ethers.formatUnits(_newTS, 8);
        _newBal = ethers.formatUnits(_newBal, 8);

        setTotalSupply(_newTS.toString());
        setnUsdBal(_newBal.toString());
        alert("Tx Successful");
        return;
      }
    } catch (error) {
      alert(error.message);
    }
  };

  return (
    <div className="main-container">
      <div className="wallet-container">
        <div className="user-detail">{userAddress}</div>
        <div className="user-detail">
          {balance} <span> </span>tBNB
        </div>

        <button className="wallet-button" onClick={onConnectHandler}>
          {isMetamaskConnected ? "Connected" : "Connect Wallet"}
        </button>
      </div>

      <div className="NUSD-details">
        <div className="nusd">{`Total Supply of nUSD : ${totalSupply} nUSD`}</div>
        <div className="nusd">{`Your nUSD token balance : ${nUSD} nUSD`}</div>
      </div>

      <div className="form-container">
        <form className="form" onSubmit={onBuy}>
          <input
            type="number"
            name="amountBNB"
            placeholder="BNB amount"
            value={bnbAmount}
            onChange={handleChange}
          />
          <button type="submit">Buy nUSD</button>
        </form>

        <form className="form" onSubmit={redeem}>
          <input
            type="number"
            name="nUSdAmount"
            placeholder="nUSD token amount"
            value={nUSDAmount}
            onChange={handleChangeNUSD}
          />
          <button type="submit">Redeem BNB</button>
        </form>
      </div>
    </div>
  );
};

export default App;
