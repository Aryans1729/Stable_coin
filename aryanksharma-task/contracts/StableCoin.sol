/// @title nUSD StableCoin
// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

/// @dev Importing Chainlink Aggregator V3 Interface to fetch price
import "./Interfaces/AggregatorV3Interface.sol";
import "./Interfaces/IERC20.sol";

import "hardhat/console.sol";

contract StableCoin is IERC20 {
    ///@dev defining the contract

    ///@dev @param name:Name of the coin
    string public name = "StableCoin";
    ///@dev @param symbol = Symbol of the coin
    string public symbol = "nUSD";
    ///@dev @param decimals =  Decimals of the coin
    uint public decimals = 6;

    /// @dev priceFeed : To get the latest price
    AggregatorV3Interface priceFeed;

    /// @dev Events
    /**
     * `nUsdBought` will be emitted when someone buy nUSD after providing ETH.
     * @param _lender: The address of the wallet who purchased.
     * @param _nUSDAmount: The amount of nUSD received after purchasing.
     */
    event nUsdpaidfor(address indexed _lender, uint256 _nUSDAmount);

    /**
     * `Redeemed` will be emitted reedem ETH back after providing nUSD
     * @param _lender: The address of the wallet who redeemed.
     * @param _EthAmountRedeemed: The amount of ETH received after redeem.
     */
    event Redeemed(address indexed _lender, uint256 _EthAmountRedeemed);
    /**
     * `Approval` will be emitted when a user will be approved on spending amount.
     * @param owner: The owner of the coin
     * @param spender: The spender of the coin
     * @param value: value or amount
     */
    event Approval(address owner, address spender, uint256 value);
    /**
     * `Transfer` will be emitted when tokens being transferr from one address to another.
     * @param _from: The address of the user
     * @param _to: The address of the user which needs to send tokens
     * @param tokens: uint in no of tokens
     */
    event Transfer(address _from, address _to, uint tokens);

    // address public founder;
    mapping(address => uint) balances;
    // balances[0x1111...] = 100;

    //@dev mapping (address => uint) : To track the amount spent by the allowed person in the coin
    mapping(address => mapping(address => uint)) allowed;

    ///@dev TotalSupply of the coin which will be given at the compile time
    uint _totalSupply;
    ///@dev @params Owner of the deployed contract
    address owner;

    /// @dev Initializing the contract
    constructor(address _addressOFBNB_USD) {
        owner = msg.sender;
        /// @dev Initializing the price Feed aggregator
        priceFeed = AggregatorV3Interface(_addressOFBNB_USD);
    }

    /**
     * (PUBLIC)
     * @dev Function that Returns the amount of tokens owned by account.
     * @param tokenOwner:The address of the user whos balance is to fetched
     */

    function balanceOf(
        address tokenOwner
    ) public view override returns (uint balance) {
        return balances[tokenOwner];
    }

    /**
     * (PUBLIC)
     * @dev Function Moves amount tokens from the caller’s account to recipient. Returns a boolean value indicating whether the operation succeeded.
     * @param to:The address of the user to be transferred
     * @param tokens: Amount of tokens to be transferred
     */

    function transfer(
        address to,
        uint256 tokens
    ) public override returns (bool success) {
        require(balances[msg.sender] >= tokens);
        balances[msg.sender] -= tokens;
        balances[to] += tokens;

        emit Transfer(msg.sender, to, tokens);

        return true;

        /**
         * (PUBLIC)
         * @dev Function returns the total Supply of the token.
         */
    }

    function totalSupply() public view override returns (uint) {
        return _totalSupply;
    }

    /**
     * (PUBLIC)
     * @dev Function Returns the amount which spender is still allowed to withdraw from _owner
     * @param tokenOwner:The address of the tokenOwner
     * @param spender: The address of the spender who will be given the allowance
     */

    function allowance(
        address tokenOwner,
        address spender
    ) public view override returns (uint) {
        return allowed[tokenOwner][spender];
    }

    /**
     * (PUBLIC)
     * @dev Function  Sets amount as the allowance of spender over the caller’s tokens
     * @param spender:The address of the spender
     * @param tokens: The amount of tokens which spender is allowed to spend
     */

    // Returns a boolean value indicating whether the operation succeeded. Emits an Approval event.
    function approve(
        address spender,
        uint tokens
    ) public override returns (bool success) {
        require(balances[msg.sender] >= tokens);
        require(tokens > 0);

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    /**
     * (PUBLIC)
     * @dev Function that transfer tokens on the behalf of tokenowner and it will be called by spender
     * @param from:The address of the spender
     * @param to: The address of the user whom tokens need to be transferred
     * @param tokens: Amount to be transferred
     */

    function transferFrom(
        address from,
        address to,
        uint tokens
    ) public override returns (bool success) {
        require(allowed[from][msg.sender] >= tokens); //allowance function is called to check for remaing tokens
        require(balances[from] >= tokens);

        balances[from] -= tokens;
        allowed[from][msg.sender] -= tokens;
        balances[to] += tokens;

        emit Transfer(from, to, tokens);

        return true;
    }

    /**
     * (PUBLIC)
     * @dev Function that mints the specified quantity in the total SUpply of token
     * @param _qty : AMount of token to be minted
     */

    function mint(address lender, uint _qty) private returns (uint) {
        _totalSupply += _qty;
        balances[lender] += _qty;
        return _totalSupply;
    }

    /**
     * (PUBLIC)
     * @dev Function that mints the specified quantity in the total SUpply of token
     * @param _qty : AMount of token to be minted
     */
    function burn(address lender, uint _qty) private returns (uint) {
        require(balances[lender] >= _qty);
        _totalSupply -= _qty;
        balances[msg.sender] -= _qty;
        return _totalSupply;
    }

    /**
     * @dev Function to get the latest price of ETH/BNB in USD
     * @return price The price of ETH/BNB in USD
     */

    function getPriceOfETHBNB() public view returns (uint) {
        /// @dev Fetching the price
        (, int _fetchedPrice, , , ) = priceFeed.latestRoundData();

        return uint(_fetchedPrice);
    }

    /**
     * @dev Function to buy the stable coin (nUSD) by providing ETH/BNB
     */

    function buy() external payable {
        uint256 price = getPriceOfETHBNB();

        /// @dev Validation
        require(msg.value != 0, " Please enter Valid Amount");

        /// @dev Calculating the amount of nUSD to mint based on the input ETH/BNB value
        uint256 tokensToMint = (price * msg.value) / 1 ether;
        tokensToMint = tokensToMint / 2;

        /// @dev Validation
        require(tokensToMint != 0, "Insufficient Amount");
        /// @dev Minting the nUSD tokens to the address
        mint(msg.sender, tokensToMint);

        /// @dev emitting the event
        emit nUsdpaidfor(msg.sender, tokensToMint);
    }

    /**
     * @dev Function to redeem ETH/BNB back after providing nUSD.
     * @param nUsdAmountToReedem : The amount of nUSD person wants to redeem
     */

    function redeem(uint256 nUsdAmountToReedem) external {
        /// @dev Validations
        require(nUsdAmountToReedem != 0, "Invalid Amount");

        /// @dev Gatting the price
        uint256 price = getPriceOfETHBNB();

        ///@dev Doubling the price due to required exchange rule
        uint256 priceDouble = price * 2;

        /// @dev Calculating the ETH/BNB received after swapping from nUSD
        uint256 etherReceivedAfterSwap = (1 ether * nUsdAmountToReedem) /
            priceDouble;

        /// @dev Burning the amount of nUSD that user will swap in ETH/BNB
        burn(msg.sender, nUsdAmountToReedem);

        ///@dev Transfering ETH/BNB to account
        (bool success, ) = msg.sender.call{value: etherReceivedAfterSwap}("");
        require(success, "Eth Transferred Failed");
        /// @dev Emitting event
        emit Redeemed(msg.sender, etherReceivedAfterSwap);
    }
}
