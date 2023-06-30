/// @title : nUSD-ETH-Contract
// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.15;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint tokens) external returns (bool);

    function allowance(
        address tokenOwner,
        address spender
    ) external view returns (uint);

    function approve(
        address spender,
        uint tokens
    ) external returns (bool success);

    function transferFrom(
        address from,
        address to,
        uint tokens
    ) external returns (bool success);
}
