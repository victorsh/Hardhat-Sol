// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MultiSigWallet {
  address private _owner;
  mapping(address => uint8) private _owners;

  uint constant MIN_SIGNATURES = 2;

  uint private _transactionIdx;

  struct Transaction {
    address from;
    address to;
    uint amount;
    uint8 signatureCount;
    mapping (address => uint8) signatures;
  }

  Transaction public top_tnx;
  mapping (uint => Transaction) private _transactions;
  uint[] private _pendingTransactions;

  modifier isOwner() {
    require(msg.sender == _owner, "Sender must be owner");
    _;
  }

  modifier isValidOwner() {
    require(msg.sender == _owner || _owners[msg.sender] == 1, "Sender must be an owner");
    _;
  }

  event DepositFunds(address from, uint amount);
  event WithdrawFunds(address from, uint amount);
  event TransferFunds(address from, address to, uint amount);
  event TransactionSigned(address by, uint transactionId);

  constructor() {
    _owner = msg.sender;
  }

  function addOwner(address owner) isOwner public {
    _owners[owner] = 1;
  }

  function removeOwner(address owner) isOwner public {
    _owners[owner] = 0;
  }

  receive() external payable {
    emit DepositFunds(msg.sender, msg.value);
  }

  fallback() external payable {
    emit DepositFunds(msg.sender, msg.value);
  }

  function transferTo(address to, uint amount) isValidOwner public {
    require(address(this).balance >= amount);
    uint transactionId = _transactionIdx++;
    Transaction storage transaction = top_tnx;
    transaction.from = msg.sender;
    transaction.to = to;
    transaction.amount = amount;
    transaction.signatureCount = 0;
  }
}