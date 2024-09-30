// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.25;

import {MagicWalletBaseTest} from "test/MagicWallet/MagicWalletBase.t.sol";
import {AttackMagicWallet} from "src/MagicWallet/AttackMagicWallet.sol";

contract MagicWalletTest is MagicWalletBaseTest {
    AttackMagicWallet private attackMagicWallet;

    function testMagicWalletExploit() public checkSolved {
        attackMagicWallet = new AttackMagicWallet(address(magicWallet));

        attackMagicWallet.exploit{value: 1 ether}();
    }
}
