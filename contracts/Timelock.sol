//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

import {SafeMath} from "./SafeMath.sol";

contract Timelock {
  using SafeMath for uint;
  mapping(address => uint) public balances;
  mapping(address => uint) public lockTime;

  function deposit() external payable {
    balances[msg.sender] += msg.value;
    lockTime[msg.sender] = block.timestamp + 1 weeks;
  }

  function increaseLockTime(uint _seconds) public {
    lockTime[msg.sender] = lockTime[msg.sender].add(_seconds);
  }

  function withdraw() public {
    require(balances[msg.sender] > 0, "No funds are locked");
    require(block.timestamp > lockTime[msg.sender], "lock time has not expired");
    uint amount = balances[msg.sender];
    balances[msg.sender] = 0;
    (bool sent, ) = msg.sender.call{value: amount}("");
    require(sent, "Failed to send transaction");
  }
}