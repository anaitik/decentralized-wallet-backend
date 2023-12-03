// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract SimpleWallet {
    mapping(address => uint256) public balances;

    event Deposit(address indexed depositor, uint256 amount);
    event Withdrawal(address indexed beneficiary, uint256 amount);

    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");

        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) external {
        require(_amount > 0, "Withdrawal amount must be greater than 0");
        require(_amount <= balances[msg.sender], "Insufficient balance");

        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
        emit Withdrawal(msg.sender, _amount);
    }

    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
}

