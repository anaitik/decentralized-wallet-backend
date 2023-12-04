// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract MultiTokenWallet {
    using SafeERC20 for IERC20;

    mapping(address => mapping(address => uint256)) public tokenBalances;
    mapping(address => bool) public hasAccount;

    event Deposit(address indexed account, address indexed token, uint256 amount);
    event Withdrawal(address indexed account, address indexed token, uint256 amount);
    event Transfer(address indexed sender, address indexed recipient, address indexed token, uint256 amount);

    function createAccount() external {
        require(!hasAccount[msg.sender], "Account already exists");
        hasAccount[msg.sender] = true;
    }

    function deposit(address _token, uint256 _amount) external {
        require(hasAccount[msg.sender], "Account does not exist");
        require(_amount > 0, "Deposit amount must be greater than 0");

        IERC20 token = IERC20(_token);
        token.safeTransferFrom(msg.sender, address(this), _amount);
        tokenBalances[msg.sender][_token] += _amount;

        emit Deposit(msg.sender, _token, _amount);
    }

    function withdraw(address _token, uint256 _amount) external {
        require(hasAccount[msg.sender], "Account does not exist");
        require(_amount > 0, "Withdrawal amount must be greater than 0");
        require(_amount <= tokenBalances[msg.sender][_token], "Insufficient balance");

        IERC20 token = IERC20(_token);
        tokenBalances[msg.sender][_token] -= _amount;
        token.safeTransfer(msg.sender, _amount);

        emit Withdrawal(msg.sender, _token, _amount);
    }

    function transfer(address _recipient, address _token, uint256 _amount) external {
        require(hasAccount[msg.sender], "Account does not exist");
        require(_amount > 0, "Transfer amount must be greater than 0");
        require(_amount <= tokenBalances[msg.sender][_token], "Insufficient balance");
        require(_recipient != address(0), "Invalid recipient address");

        IERC20 token = IERC20(_token);
        tokenBalances[msg.sender][_token] -= _amount;
        tokenBalances[_recipient][_token] += _amount;

        emit Transfer(msg.sender, _recipient, _token, _amount);
    }

    function getTokenBalance(address _account, address _token) external view returns (uint256) {
        return tokenBalances[_account][_token];
    }
}
