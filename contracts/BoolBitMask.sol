//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

contract BoolBitMask {
  function getBoolean(uint256 _packedBools, uint256 _boolNumber) public pure returns(bool) {
    uint256 flag = (_packedBools >> _boolNumber) & uint256(1);
    return (flag == 1 ? true : false);
  }

  function setBoolean(uint256 _packedBools, uint256 _boolNumber, bool _value) public pure returns(uint256) {
    if (_value) {
      return _packedBools | uint256(1) << _boolNumber;
    } else {
      return _packedBools & ~(uint256(1) << _boolNumber);
    }
  }
}
