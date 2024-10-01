// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

import {Test, console2} from "forge-std/Test.sol";
import {MagicWallet} from "src/MagicWallet/MagicWallet.sol";

/**
 * DO NOT MODIFY THIS FILE, OR YOU WILL GET ZERO POINTS FROM THIS CHALLENGE
 */
contract MagicWalletBaseTest is Test {
    address internal player = makeAddr("player");

    MagicWallet internal magicWallet;

    modifier checkSolved() {
        vm.startPrank(player, player);
        _;
        vm.stopPrank();
        _isSolved();
    }

    function setUp() public virtual {
        vm.deal(player, 1 ether);
        magicWallet = new MagicWallet{value: 1337 ether}();
    }

    function _isSolved() private view {
        assertEq(address(magicWallet).balance, 0);
        assertEq(player.balance, 1338 ether);
    }
}
