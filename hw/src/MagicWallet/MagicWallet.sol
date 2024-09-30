// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

contract MagicWallet {
    mapping(address account => uint256) public balances;
    mapping(address account => mapping(address spender => uint256)) public allowances;

    error InsufficientBalance();
    error InsufficientAllowance();
    error FailToSendETH();

    constructor() payable {}

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        if (amount > balances[msg.sender]) revert InsufficientBalance();

        balances[msg.sender] -= amount;
        (bool success,) = msg.sender.call{value: amount}("");

        if (!success) revert FailToSendETH();
    }

    function approve(address recipient, uint256 amount) external {
        allowances[msg.sender][recipient] += amount;
    }

    function transfer(address recipient, uint256 amount) external {
        if (amount > balances[msg.sender]) revert InsufficientBalance();

        balances[msg.sender] -= amount;
        balances[recipient] += amount;
    }

    function transferFrom(address from, address to, uint256 amount) external {
        uint256 allowance = allowances[from][msg.sender];
        uint256 fromBalance = balances[from];
        uint256 toBalance = balances[to];

        if (amount > fromBalance) revert InsufficientBalance();
        if (amount > allowance) revert InsufficientAllowance();

        balances[from] = fromBalance - amount;
        balances[to] = toBalance + amount;
        allowances[from][msg.sender] = allowance - amount;
    }
}
