pragma solidity ^0.5.13;

contract SendMoneyExample {
    
    uint public balanceReceived;
    
    uint public stakedReceived;
    
    function receiveMoney() public payable {
        balanceReceived += msg.value;
    }
    
    function receiveStake() public payable {
        stakedReceived += msg.value;
    }
    
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
    
    function getBalanceReceived() public view returns(uint) {
        return balanceReceived;
    }
    
    function withdrawMoney() public {
        address payable to = msg.sender;
        
        to.transfer(this.getBalance());
    }
}