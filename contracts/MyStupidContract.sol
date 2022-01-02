// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "hardhat/console.sol";

contract MyStupidContract {
  struct Item {
    uint256 spec;
    string message;
  }

  Item[] public items;
  uint256 itemsCount;
  uint256 public aNum;
  uint256[] public aNums;
  
  string private str;
  mapping(uint256 => uint256) private uintAddr;
  mapping(uint256 => uint256) private uintAddrIndex;
  uint256 uintAddrCount;

  constructor() {
    aNum = 0;
    aNums.push(0);

    str = "hi";
    // 
    uintAddrCount = 0;
    for (uint256 i = 0; i < 10; i++) {
      uint256 key = (uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)))/(i+1)) % 189;
      console.log(key);
      uintAddrIndex[i] = key;
      uintAddr[key] = i;
      uintAddrCount++;
    }
    console.log("|---|");
    for (uint256 i = 0; i < uintAddrCount; i++) {
      console.log(uintAddr[i]);
    }

    // add
    uint256 key2 = getKey(uintAddrCount);
    uintAddrCount++;
    uintAddrIndex[uintAddrCount];
    uintAddr[uintAddrCount] = key2;

    // remove
    uintAddrIndex[3] = uintAddrIndex[uintAddrCount];

    Item memory _item = Item(5, "hi");
    items.push(_item);
    itemsCount++;

  }

  function getKey(uint256 i) internal view returns (uint256 key) {
    key = (uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)))/(i+1)) % 189;
  }
}