// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract StreamingPayment {
    mapping(bytes32 => Stream) public streams;
    
    struct Stream {
        address sender;
        address recipient;
        uint256 deposit;
        uint256 startTime;
        uint256 stopTime;
        uint256 ratePerSecond;
    }
    
    function createStream(address recipient, uint256 deposit, uint256 startTime, uint256 stopTime) external payable returns (bytes32) {
        require(msg.value == deposit, "Incorrect deposit");
        require(stopTime > startTime, "Invalid time range");
        
        uint256 ratePerSecond = deposit / (stopTime - startTime);
        bytes32 streamId = keccak256(abi.encodePacked(msg.sender, recipient, startTime));
        
        streams[streamId] = Stream({
            sender: msg.sender,
            recipient: recipient,
            deposit: deposit,
            startTime: startTime,
            stopTime: stopTime,
            ratePerSecond: ratePerSecond
        });
        
        return streamId;
    }
}
