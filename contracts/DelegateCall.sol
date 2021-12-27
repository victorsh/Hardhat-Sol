//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

import "hardhat/console.sol";

contract Satellite1 {
  uint256 public num;
  address public sender;
  uint public value;
  address payable owner;

  constructor() { owner = payable(msg.sender); }

  function setVars(uint256 _num) public payable {
    console.log("set vars: %s", _num);
    num = _num;
    sender = msg.sender;
    value = msg.value;
  }

  function getVars() public view returns(uint256 ret){
    console.log("get vars: %s", num);
    ret = num;
  }
  function destruct() public {
    selfdestruct(owner);
  }
}

contract Satellite2 {
  uint256 public num;
  address public sender;
  uint public value;
  address payable owner;

  constructor() { owner = payable(msg.sender); }

  function setVars(uint256 _num) public payable {
    num = 2 * _num;
    sender = msg.sender;
    value = msg.value;
  }

  function getVars() public view returns(uint256 ret){
    ret = num;
  }

  function destruct() public {
    selfdestruct(owner);
  }
}

contract DelegateCall {
  uint public num;
  address public sender;
  uint public value;

  function setVars(address _contract, uint _num) public payable {
    (bool success, bytes memory data) = _contract.delegatecall(
      abi.encodeWithSignature("setVars(uint256)", _num)
    );
  }

  function getVars(address _contract) public returns(uint256) {
    (bool success, bytes memory data) = _contract.delegatecall(
      abi.encodeWithSignature("getVars()")
    );
    return abi.decode(data, (uint256));
  }
}