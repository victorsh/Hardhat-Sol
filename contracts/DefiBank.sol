//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import {SafeMath} from "./SafeMath.sol";

interface IERC20 {
  function totalSupply() external view returns (uint _totalSupply);
  function balanceOf(address _owner) external view returns (uint balance);
  function transfer(address _to, uint256 _value) external returns (bool success);
  function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
  function approve(address _spender, uint256 _value) external returns (bool success);
  function allowance(address _owner, address _spender) external view returns (uint256 remaining);
  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract DefiBank is ReentrancyGuard {
  string public name = "DefiBank";
  address public usdc;
  address public bankToken;

  address[] public stakers;
  mapping(address => uint) public stakingBalance;
  mapping(address => bool) public hasStaked;
  mapping(address => bool) public isStaking;

  constructor(address _usdc, address _bankToken) {
    usdc = _usdc;
    bankToken = _bankToken;
  }

  function stakeTokens(uint _amount) public {
    IERC20(usdc).transferFrom(msg.sender, address(this), _amount);
    stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

    if(!hasStaked[msg.sender]) {
      stakers.push(msg.sender);
    }

    isStaking[msg.sender] = true;
    hasStaked[msg.sender] = true;
  }

  function unstakeTokens() public nonReentrant {
    uint balance = stakingBalance[msg.sender];
    require(balance > 0, "staking balance can not be 0");
    IERC20(usdc).transfer(msg.sender, balance);
    stakingBalance[msg.sender] = 0;
    isStaking[msg.sender] = false;
  }

  function issueInterestToken() public {
    for (uint i = 0; i < stakers.length; i++) {
      address recipient = stakers[i];
      uint balance = stakingBalance[recipient];
      if(balance > 0) {
        IERC20(bankToken).transfer(recipient, balance);
      }
    }
  }
}