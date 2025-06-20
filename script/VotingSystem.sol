// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract VotingSystem {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    address public admin;
    uint public candidatesCount;
    bool public votingOpen;

    mapping(uint => Candidate) public candidates;
    mapping(address => bool) public hasVoted;

    event Voted(address indexed voter, uint indexed candidateId);
    event VotingStatusChanged(bool newStatus);

    constructor() {
        admin = msg.sender;
        votingOpen = true;
    }

    function addCandidate(string memory _name) public {
        require(msg.sender == admin, "Only admin can add candidates");
        require(votingOpen, "Voting has ended");
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function vote(uint _candidateId) public {
        require(votingOpen, "Voting is closed");
        require(!hasVoted[msg.sender], "You have already voted");
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate");

        hasVoted[msg.sender] = true;
        candidates[_candidateId].voteCount++;

        emit Voted(msg.sender, _candidateId);
    }

    function endVoting() public {
        require(msg.sender == admin, "Only admin can end voting");
        votingOpen = false;
        emit VotingStatusChanged(false);
    }

    function getCandidate(uint _id) public view returns (string memory name, uint voteCount) {
        Candidate memory candidate = candidates[_id];
        return (candidate.name, candidate.voteCount);
    }
}
