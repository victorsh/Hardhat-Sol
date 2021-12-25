//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

import {SafeMath} from "./SafeMath.sol";

interface ERC20 {
  function totalSupply() external view returns (uint _totalSupply);
  function balanceOf(address _owner) external view returns (uint balance);
  function transfer(address _to, uint256 _value) external returns (bool success);
  function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
  function approve(address _spender, uint256 _value) external returns (bool success);
  function allowance(address _owner, address _spender) external view returns (uint256 remaining);
  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract VictorToken is ERC20 {
  using SafeMath for uint256;
  string public constant SYMBOL = "VCTR";
  string public constant NAME = "VictorToken";
  uint8 public constant DECIMALS = 18;

  uint256 private constant TOTAL_SUPPLY = 1 * 10 ** DECIMALS;

  mapping(address => uint256) private __balanceOf;
  mapping(address => mapping(address => uint256)) private __allowances;

  constructor() {
    __balanceOf[msg.sender] = TOTAL_SUPPLY;
  }

  function totalSupply() external pure override returns (uint _totalSupply) {
    _totalSupply = TOTAL_SUPPLY;
  }

  function balanceOf(address _owner) external view override returns (uint balance) {
    balance = __balanceOf[_owner];
  }

  function transfer(address _to, uint256 _value) external override returns (bool success) {
    require(_value > 0, "Amount to send is zero");
    require(_value > __balanceOf[msg.sender], "Not enough tokens to send");
    __balanceOf[_to] = __balanceOf[_to].add(_value);
    __balanceOf[msg.sender] = __balanceOf[msg.sender].sub(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  function transferFrom(address _from, address _to, uint256 _value) external override returns (bool success) {
    require(_value > 0, "Amount to send is zero");
    require(__allowances[_from][msg.sender] >= _value, "Not enough allowance");
    require(!isContract(_to), "Address cannot be a contract");
    __balanceOf[_from] = __balanceOf[_from].sub(_value);
    __balanceOf[_to] = __balanceOf[_to].add(_value);
    emit Transfer(_from, _to, _value);
    return true;
  }

  function approve(address _spender, uint256 _value) external override returns (bool success) {
    __allowances[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }
  
  function allowance(address _owner, address _spender) external view override returns (uint256 remaining) {
    remaining = __allowances[_owner][_spender];
  }

  function isContract(address _addr) internal view returns(bool){
    uint codeSize;
    assembly {
      codeSize := extcodesize(_addr)
    }
    return codeSize > 0;
  }
}
