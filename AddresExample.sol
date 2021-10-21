// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.1;

contract AddressExample {
    address public myAddress;
    bytes public msgBytes;
    
    function setAddress(address addressToSet) public {
        myAddress = addressToSet;
    }
    
    function getBalanceOfAddress() public view returns (uint) {
        return myAddress.balance;
    }
    
    function setAddressToSender() public {
        myAddress = msg.sender;
    }
    
    function setSenderData() public {
        msgBytes = msg.sig;
    }
}