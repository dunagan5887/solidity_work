pragma solidity ^0.8.1;


contract SendMoneyExampleV8 {
    uint public balanceReceived;
    
    uint public timestaked;
    
    function receiveMoney() public payable {
        balanceReceived += msg.value;
        
        timestaked = block.timestamp;
    }
    
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
    
    function withdrawMoney() public {
        
        uint lapse = block.timestamp - timestaked;
        require(lapse >= 1 minutes, "Must wait at least 1 minute before withdrawing money you greedy sweatboy");
        
        address payable to = payable(msg.sender);
        to.transfer(getBalance());
    }
    
    function withdrawMoneyTo(address payable _to) public {
        _to.transfer(getBalance());
    }
}