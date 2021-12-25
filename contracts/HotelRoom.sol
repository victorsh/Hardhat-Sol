//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

contract HotelRoom {
  enum Statuses {Vacant, Occupied}
  Statuses currentStatus;
  event Occupy(address _occupant, uint _value);
  address payable public owner;
  address occupant;

  constructor() {
    owner = payable(msg.sender);
    currentStatus = Statuses.Vacant;
  }

  function checkout() external {
    require(currentStatus == Statuses.Occupied, "The room is vacant");
    require(msg.sender == occupant, "Only the current occupant can checkout");
    currentStatus = Statuses.Vacant;
    occupant = address(0x0);
  }

  modifier onlyWhileVacant {
    require(currentStatus == Statuses.Vacant, "Currenlty Occupied");
    _;
  }

  modifier costs (uint256 _amount) {
    require(msg.value >= _amount, "Not enough funds provided");
    _;
  }

  receive() external payable onlyWhileVacant costs(2 ether) {
    currentStatus = Statuses.Occupied;
    owner.transfer(msg.value);
    occupant = msg.sender;
    emit Occupy(msg.sender, msg.value);
  }
}