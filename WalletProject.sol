// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.5.13;

contract WalletProject {
    
    uint public nonOwnerWithdrawAllowance;
    
    address public owner;
    
    mapping(address => uint) public tokenBalance;
    
    event TokensDeposited(address indexed _from, uint _amount);
    
    event TokensWithdrawn(address indexed _from, address indexed _to, uint _amount);
    
    event TokensTransferred(address indexed _from, address indexed _to, uint _amount);
    
    event FallbackFunctionExecuted(address indexed _from, uint _msg_value);
    
    constructor() public {
        owner = msg.sender;
        nonOwnerWithdrawAllowance = 100;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not authorized to take this action");
        _;
    }
    
    function setOtherPersonsWithdrawalAllowance(uint _allowanceAmount) public onlyOwner returns (bool) {
        require(_allowanceAmount >= 0, "The allowance must be greater than or equal to 0");
        nonOwnerWithdrawAllowance = _allowanceAmount;
    }
    
    function depositTokens() public payable returns (bool) {
        tokenBalance[msg.sender] += msg.value;
        
        emit TokensDeposited(msg.sender, msg.value);
        
        return true;
    }
    
    function withdrawTokens(address payable _to, uint _amount) public returns (bool) {
        
        require(_amount > 0, "You can only withdraw amounts greater than 0");
        require(tokenBalance[msg.sender] >= _amount, "Your account balance does not have enough tokens to withdraw this amount");
        
        if (owner != msg.sender)
        {
            // Case 2: Owner is withdrawing someone else's tokens
            require(_amount <= nonOwnerWithdrawAllowance, "You can not withdraw that much in a single transaction");
        }
        else
        {
            // Case 1: Owner is withdrawing own tokens
        }
        
        _to.transfer(_amount);
        tokenBalance[msg.sender] -= _amount;
        
        emit TokensWithdrawn(msg.sender, _to, _amount);
    }
    
    function transferTokensBetweenAccounts(address _to, uint _amount) public returns (bool) {
        
        require(_amount > 0, "You can only withdraw amounts greater than 0");
        require(tokenBalance[msg.sender] >= _amount, "Your account balance does not have enough tokens to withdraw this amount");
        
        if (msg.sender != owner)
        {
            // Case 2: Owner is transferring someone else's tokens
            require(_amount <= nonOwnerWithdrawAllowance, "You are not allowed to transfer that much between accounts");
        }
        else
        {
            // Case 1: Owner is transferring own tokens
        }
        
        assert(tokenBalance[_to] + _amount >= tokenBalance[_to]);
        assert(tokenBalance[msg.sender] - _amount <= tokenBalance[msg.sender]);
        
        tokenBalance[_to] += _amount;
        tokenBalance[msg.sender] -= _amount;
        
        emit TokensTransferred(msg.sender, _to, _amount);
        
        return true;
    }
    
    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }
    
    // Deposit funds with fallback function
    function() external payable {
        depositTokens();
        
        emit FallbackFunctionExecuted(msg.sender, msg.value);
    }
    
    function receive() external payable {
        depositTokens();
        
        emit FallbackFunctionExecuted(msg.sender, msg.value);
    }
    
    
}