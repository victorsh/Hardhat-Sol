pragma solidity ^0.8.7;

contract AddressBook {
  mapping(address => address[]) private addresses;
  mapping(address => mapping(address => string)) aliases;

  function getAddressArray(address addr) public view returns (address[] memory) {
    return addresses[addr];
  }

  function addAddress(address addr, string memory _alias) public {
    addresses[msg.sender].push(addr);
    aliases[msg.sender][addr] = _alias;
  }

  function removeAddress(address addr) public {
    uint256 length = addresses[msg.sender].length;
    for (uint256 i = 0; i < length; i++) {
      if (addr == addresses[msg.sender][i]) {
        if (1 < addresses[msg.sender].length && i < length - 1) {
          addresses[msg.sender][i] = addresses[msg.sender][length-1];
        }
        addresses[msg.sender].pop();
        delete aliases[msg.sender][addr];
        break;
      }
    }
  }

  function getAlias(address addrOwner, address addr) public view returns (string memory) {
    return aliases[addrOwner][addr];
  }
}