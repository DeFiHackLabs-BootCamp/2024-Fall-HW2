// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

contract DeFiHackLabsVault {
    uint256 public constant DURATION = 1 weeks;
    uint256 public constant MAXIMUMVOTE = 8;

    uint256 public immutable DEADLINE;
    address public immutable votingToken;

    struct Proposal {
        address receiver;
        uint256 amount;
    }

    mapping(address account => bool) public isVoted;
    mapping(uint256 proposalId => uint256 votes) public votingAccount;
    mapping(uint256 proposalId => Proposal) public proposalInfo;

    uint256 public proposalId;
    uint256 public hightestVote;

    error InvalidMsgValue();
    error ZeroAddress();
    error ZeroAmount();
    error NotEnoughToken();
    error UnknownProposal();
    error FailToSendETH();
    error VotingNotClose();
    error IsVoted();

    constructor(address _votingToken) {
        DEADLINE = block.timestamp + DURATION;
        votingToken = _votingToken;
    }

    function createProposal(Proposal calldata proposal) external payable returns (uint256) {
        if (msg.value != 1 ether) revert InvalidMsgValue();
        if (proposal.receiver == address(0)) revert ZeroAddress();
        if (proposal.amount == 0) revert ZeroAmount();

        uint256 count = IERC1155(votingToken).balanceOf(msg.sender, 0) * 3;
        count += IERC1155(votingToken).balanceOf(msg.sender, 1);
        if (count == 0) revert NotEnoughToken();

        votingAccount[proposalId] += count;
        proposalInfo[proposalId] = proposal;
        hightestVote = hightestVote < votingAccount[proposalId] ? votingAccount[proposalId] : hightestVote;

        return proposalId++;
    }

    function vote(uint256 id) external {
        if (votingAccount[id] == 0) revert UnknownProposal();
        if (isVoted[msg.sender]) revert IsVoted();

        uint256 count = IERC1155(votingToken).balanceOf(msg.sender, 0) * 3;
        count += IERC1155(votingToken).balanceOf(msg.sender, 1);

        votingAccount[id] += count;
        hightestVote = hightestVote < votingAccount[id] ? votingAccount[id] : hightestVote;
    }

    function execute(uint256 id) external {
        Proposal memory p = proposalInfo[id];

        if (votingAccount[id] == MAXIMUMVOTE) {
            uint256 amount = address(this).balance > p.amount ? p.amount : address(this).balance;
            (bool success,) = p.receiver.call{value: amount}("");
            if (!success) revert FailToSendETH();
        } else {
            if (block.timestamp < DEADLINE) revert VotingNotClose();
            uint256 amount = address(this).balance > p.amount ? p.amount : address(this).balance;
            (bool success,) = p.receiver.call{value: amount}("");
            if (!success) revert FailToSendETH();
        }
    }
}
