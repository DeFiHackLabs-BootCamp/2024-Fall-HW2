// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

import {Test, console2} from "forge-std/Test.sol";
import {DeFiHackLabsToken} from "src/DeFiHackLabsVault/DeFiHackLabsToken.sol";
import {DeFiHackLabsVault} from "src/DeFiHackLabsVault/DeFiHackLabsVault.sol";

/**
 * DO NOT MODIFY THIS FILE, OR YOU WILL GET ZERO POINTS FROM THIS CHALLENGE
 */
contract DeFiHackLabsVaultBaseTest is Test {
    address internal player = makeAddr("player");

    address internal wallet = makeAddr("SlowMistWallet");
    address internal alex = makeAddr("Alex");
    address internal alice = makeAddr("Alice");
    address internal louis = makeAddr("Louis");
    address internal bill = makeAddr("Bill");
    address internal sun = makeAddr("Sun");

    DeFiHackLabsToken internal deFiHackLabsToken;
    DeFiHackLabsVault internal deFiHackLabsVault;

    modifier checkSolved() {
        _;

        voteByDeFiHackLabsMember();
        vm.warp(block.timestamp + 1 weeks);
        deFiHackLabsVault.execute(0);

        _isSolved();
    }

    function setUp() public virtual {
        vm.startPrank(sun);
        deFiHackLabsToken = new DeFiHackLabsToken();
        deFiHackLabsToken.mint(sun, 0, 1, "");
        deFiHackLabsToken.mint(alex, 1, 1, "");
        deFiHackLabsToken.mint(louis, 1, 1, "");
        deFiHackLabsToken.mint(alice, 1, 1, "");
        deFiHackLabsToken.mint(bill, 1, 1, "");
        deFiHackLabsToken.mint(player, 1, 1, "");

        deFiHackLabsVault = new DeFiHackLabsVault(address(deFiHackLabsToken));
        vm.deal(address(deFiHackLabsVault), 5 ether);
        vm.stopPrank();

        vm.deal(address(sun), 1 ether);
        vm.deal(address(alex), 1 ether);
        vm.deal(address(alice), 1 ether);
        vm.deal(address(louis), 1 ether);
        vm.deal(address(bill), 1 ether);
        vm.deal(address(player), 1 ether);
    }

    function voteByDeFiHackLabsMember() private {
        vm.startPrank(sun);
        DeFiHackLabsVault.Proposal memory proposal;
        proposal.receiver = wallet;
        proposal.amount = 2 ether;
        uint256 id = deFiHackLabsVault.createProposal{value: 1 ether}(proposal);
        vm.stopPrank();

        vm.startPrank(alex);
        deFiHackLabsVault.vote(id);
        vm.stopPrank();

        vm.startPrank(alice);
        deFiHackLabsVault.vote(id);
        vm.stopPrank();

        vm.startPrank(louis);
        deFiHackLabsVault.vote(id);
        vm.stopPrank();

        vm.startPrank(bill);
        deFiHackLabsVault.vote(id);
        vm.stopPrank();
    }

    function _isSolved() private view {
        assertEq(address(deFiHackLabsVault).balance, 0);
        assertEq(player.balance, 7 ether);
    }
}
