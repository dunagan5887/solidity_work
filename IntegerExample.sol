// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.1;

contract IntegerExample {
    uint public myUint;
    
    function setMyUint(uint myUintToSet) public {
        myUint = myUintToSet;
    }
}