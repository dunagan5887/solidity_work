// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.1;

contract RolloverExample {
    uint8 public myUint8;
    
    function incrementMyUint8() public {
        myUint8++;
    }
    
    function decrementMyUint8() public {
        myUint8--;
    }
    
    function setMyUint8 (uint8 valueToSet) public {
        myUint8 = valueToSet;
    }
}