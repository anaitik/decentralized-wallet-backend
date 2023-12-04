// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract SimpleWallet {
    mapping(address => uint256) public balances;
    mapping(address => bool) public hasAccount;

    event Deposit(address indexed depositor, uint256 amount);
    event Withdrawal(address indexed beneficiary, uint256 amount);
    event Transfer(address indexed sender, address indexed recipient, uint256 amount);

    function createAccount() external {
        require(!hasAccount[msg.sender], "Account already exists");
        
        // You can use a more sophisticated method to generate a unique address
        // For simplicity, we'll use the sender's address as the unique identifier
        hasAccount[msg.sender] = true;
        emit Transfer(address(0), msg.sender, 0); // This can be used as a signal for the account creation
    }

    function deposit() external payable {
        require(hasAccount[msg.sender], "Account does not exist");
        require(msg.value > 0, "Deposit amount must be greater than 0");

        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) external {
        require(hasAccount[msg.sender], "Account does not exist");
        require(_amount > 0, "Withdrawal amount must be greater than 0");
        require(_amount <= balances[msg.sender], "Insufficient balance");

        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
        emit Withdrawal(msg.sender, _amount);
    }

    function transfer(address _recipient, uint256 _amount) external {
        require(hasAccount[msg.sender], "Account does not exist");
        require(_amount > 0, "Transfer amount must be greater than 0");
        require(_amount <= balances[msg.sender], "Insufficient balance");
        require(_recipient != address(0), "Invalid recipient address");

        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        emit Transfer(msg.sender, _recipient, _amount);
    }

    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
}
