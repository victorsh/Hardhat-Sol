pragma solidity ^0.8.7;

/*
  The miner will manipulate the system to win the Ether in the contract
  - Call the spin function and submit 1 ether
  - Then submit a block timestamp for the next block that is divisible by 7
*/

contract Roulette {
  uint public pastBlockTime;
  constructor() payable {}

  function spin() external payable {
    require(msg.value == 1 ether);
    require(block.timestamp != pastBlockTime);
    pastBlockTime = block.timestamp;

    if (block.timestamp % 7 == 0) {
      (bool sent, ) = msg.sender.call{value: address(this).balance}("");
      require(sent, "Faield to send Ether");
    }
  }
}
