// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract Balance is Ownable {
    
    using SafeMath for uint;
    
    mapping(address => uint) public tokenBalance;
    
    event TokensDeposited(address indexed _from, uint _amount, uint _newBalance);
    
    event TokensWithdrawn(address indexed _from, address indexed _to, uint _amount, uint _newBalance);
    
    event TokensTransferred(address indexed _from, address indexed _to, uint _amount, uint _newFromBalance, uint _newToBalance);
    
    event FallbackFunctionExecuted(address indexed _from, uint _msg_value);
    
    function depositBalance() public payable {
        tokenBalance[msg.sender].add(msg.value);
        
        emit TokensDeposited(msg.sender, msg.value, tokenBalance[msg.sender]);
    }
    
    modifier notGreaterThanBalance(uint _amount) {
        require(tokenBalance[msg.sender] >= _amount, "Your account balance is too low to take that action");
        _;
    }
    
    modifier amountGreaterThanZero(uint _amount) { 
        require(_amount > 0, "Amount must be greater than 0");
        _;
    }
    
    modifier amountNotGreaterThanContractBalance(uint _amount) {
        require(_amount <= getContractBalance(), "The balance in the contract is too low to support this action");
        _;
    }
    
    function withdrawBalance(address payable _to, uint _amount) public notGreaterThanBalance(_amount) amountGreaterThanZero(_amount) amountNotGreaterThanContractBalance(_amount) {
        _to.transfer(_amount);
        tokenBalance[msg.sender].sub(_amount);
        
        emit TokensWithdrawn(msg.sender, _to, _amount, tokenBalance[msg.sender]);
    }
    
    function transferBalanceBetweenAccounts(address _to, uint _amount) public notGreaterThanBalance(_amount) amountGreaterThanZero(_amount) {
        
        tokenBalance[_to].add(_amount);
        tokenBalance[msg.sender].sub(_amount);
        
        emit TokensTransferred(msg.sender, _to, _amount, tokenBalance[msg.sender], tokenBalance[_to]);
    }
    
    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }
    
    receive() external payable {
        depositBalance();
        
        emit FallbackFunctionExecuted(msg.sender, msg.value);
    }
}

contract UdemyWalletProject is Balance {
    
    uint public nonOwnerWithdrawAllowance;
    
    constructor()  {
        nonOwnerWithdrawAllowance = 100;
    }
    
    function setOtherPersonsWithdrawalAllowance(uint _allowanceAmount) public onlyOwner {
        require(_allowanceAmount >= 0, "The allowance must be greater than or equal to 0");
        nonOwnerWithdrawAllowance = _allowanceAmount;
    }
    
    function withdrawTokens(address payable _to, uint _amount) public {
        
        if (owner() != msg.sender)
        {
            // Case 2: Owner is withdrawing someone else's tokens
            require(_amount <= nonOwnerWithdrawAllowance, "You can not withdraw that much in a single transaction");
        }
        else
        {
            // Case 1: Owner is withdrawing own tokens
        }
        
        withdrawBalance(_to, _amount);
    }
    
    function transferTokensBetweenAccounts(address _to, uint _amount) public {
        
        if (msg.sender != owner())
        {
            // Case 2: Owner is transferring someone else's tokens
            require(_amount <= nonOwnerWithdrawAllowance, "You are not allowed to transfer that much between accounts");
        }
        else
        {
            // Case 1: Owner is transferring own tokens
        }
        
        transferBalanceBetweenAccounts(_to, _amount);
    }
    
    function renounceOwnership() public virtual onlyOwner override{
        revert("Renouncing ownership is not allowed");
    }
    
    // Deposit funds with fallback function
    /*
    function() external payable {
        depositTokens();
        
        emit FallbackFunctionExecuted(msg.sender, msg.value);
    }*/
}