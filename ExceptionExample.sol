pragma solidity ^0.8.3;

contract ExceptionExample {
    
    
    //require will return remaining gas
    //assert will NOT return remaining gas
    
    
    mapping (address => uint64) public balanceReceived;
    
    address payable public owner;
    
    constructor() {
        owner = payable(msg.sender);
    }
    
    function destroySmartContract() public {
        require(msg.sender == owner, "You are not the owner");
        selfdestruct(owner);
    }
    
    function getOwner() public view returns(address) { 
        return owner;
    }
    
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
    
    function receiveMoney() public payable {
        assert(msg.value == uint64(msg.value));
        balanceReceived[msg.sender] += uint64(msg.value);
        assert(balanceReceived[msg.sender] >= uint64(msg.value));
    }
    
    function withdrawMoney(address payable to, uint64 amount) public { 
        require(amount <= balanceReceived[msg.sender], "Can't withdraw more than you've deposited");
        require(balanceReceived[msg.sender] >= balanceReceived[msg.sender] - amount);
        balanceReceived[msg.sender] -= amount;
        to.transfer(amount);
    }
    
    receive() external payable {
        receiveMoney();
    }
}