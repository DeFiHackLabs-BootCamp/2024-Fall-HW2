// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

import {Test, console2} from "forge-std/Test.sol";
import {SimpleToken} from "src/SimpleToken/SimpleToken.sol";

/**
 * DO NOT MODIFY THIS FILE, OR YOU WILL GET ZERO POINTS FROM THIS CHALLENGE
 */
contract SimpleTokenBaseTest is Test {
    address internal player = makeAddr("player");
    address internal louis = makeAddr("Louis");

    SimpleToken internal simpleToken;

    modifier checkSolved() {
        vm.startPrank(player, player);
        _;
        vm.stopPrank();
        _isSolved();
    }

    function setUp() public virtual {
        simpleToken = new SimpleToken();
    }

    function _isSolved() private view {
        assertEq(simpleToken.balanceOf(louis), 0);
        assertEq(simpleToken.balanceOf(player), 100 ether);
    }
}
