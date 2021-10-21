pragma solidity ^0.8.1;

contract StartStopUpdateExample {
    
    uint public balance;
    
    function stakeMoney() public payable {
        balance += msg.value;
    }
    
    function selfDestructContract(address payable sendMoneyTo) public {
        selfdestruct(sendMoneyTo);
    }
    
    function getAddressBalance() public view returns (uint){
        return address(this).balance;
    }
}