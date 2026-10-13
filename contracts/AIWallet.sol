// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AIWallet {
    address public owner;
    address public aiAgent;
    uint256 public dailyLimit;
    uint256 public spentToday;
    uint256 public lastResetTime;

    modifier onlyOwner() { require(msg.sender == owner, "Not owner"); _; }
    modifier onlyAgent() { require(msg.sender == aiAgent, "Not agent"); _; }

    constructor(address _aiAgent, uint256 _dailyLimit) {
        owner = msg.sender;
        aiAgent = _aiAgent;
        dailyLimit = _dailyLimit;
        lastResetTime = block.timestamp;
    }

    function executeTransaction(address payable to, uint256 amount) external onlyAgent {
        if (block.timestamp >= lastResetTime + 1 days) {
            spentToday = 0;
            lastResetTime = block.timestamp;
        }
        require(spentToday + amount <= dailyLimit, "Daily limit exceeded");
        spentToday += amount;
        to.transfer(amount);
    }
    
    function updateDailyLimit(uint256 _newLimit) external onlyOwner {
        dailyLimit = _newLimit;
    }
    
    receive() external payable {}
}
