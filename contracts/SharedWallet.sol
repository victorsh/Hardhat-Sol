//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

contract SharedWallet {
  address private _owner;

  mapping(address => uint8) private _owners;

  modifier isOwner() {
    require(msg.sender == _owner, "Not owner");
    _;
  }

  modifier validOwner() {
    require(msg.sender == _owner || _owners[msg.sender] == 1, "Not an owner");
    _;
  }

  event DepositFunds(address from, uint256 amount);
  event WithdrawFunds(address from, uint256 amount);
  event TransferFunds(address from, address to, uint256 amount);

  constructor() {
    _owner = msg.sender;
  }

  function addOwner(address newOwner) isOwner external {
    _owners[newOwner] = 1;
  }

  function removeOwner(address oldOwner) isOwner external {
    _owners[oldOwner] = 0;
    delete _owners[oldOwner];
  }

  fallback() external payable {
    emit DepositFunds(msg.sender, msg.value);
  }

  receive() external payable {
    emit DepositFunds(msg.sender, msg.value);
  }

  function withdraw(uint256 amount) external validOwner returns(bool) {
    require(address(this).balance > amount, "Not enough funds in contract");
    (bool sent, ) = address(this).call{value: amount}("");
    return sent;
  }

  function transferTo(address payable to, uint256 amount) external validOwner {
    require(address(this).balance > amount, "Not enough funds in contract");
    to.call{value: amount}("");
    emit TransferFunds(address(this), to, amount);
  }
}