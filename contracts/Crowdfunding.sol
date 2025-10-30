// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CrowdFund {
    address public owner;
    uint public goal;
    uint public deadline;
    uint public totalFunds;
    mapping(address => uint) public contributions;
    bool public goalReached;

    constructor(uint _goal, uint _durationInDays) {
        owner = msg.sender;
        goal = _goal;
        deadline = block.timestamp + (_durationInDays * 1 days);
        goalReached = false;
    }

    // Function to contribute to the campaign
    function contribute() public payable {
        require(block.timestamp < deadline, "Crowdfunding ended");
        require(msg.value > 0, "Contribution must be greater than 0");

        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;
    }

    // Function to check if the funding goal has been reached
    function checkGoalReached() public returns (bool) {
        require(block.timestamp >= deadline, "Campaign still active");
        if (totalFunds >= goal) {
            goalReached = true;
        }
        return goalReached;
    }

    // Function for the owner to withdraw funds if goal reached
    function withdrawFunds() public {
        require(msg.sender == owner, "Only owner can withdraw");
        require(goalReached, "Goal not reached");
        payable(owner).transfer(totalFunds);
    }
}

