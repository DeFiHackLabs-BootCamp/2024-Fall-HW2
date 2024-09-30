// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.25;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SimpleToken is ERC20 {
    constructor() ERC20("SimpleToken", "STK") {
        address louis = 0xa5a079898693Fe14Ac2d61c367224B228E230160;
        _mint(louis, 100 ether);
    }

    function approve(address owner, address spender, uint256 amount) public returns (bool) {
        _approve(owner, spender, amount);
        return true;
    }
}
