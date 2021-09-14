// SPDX-License-Identifier: MIT
pragma solidity =0.8.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Pool {

    mapping(address => uint256) public balances;
    mapping(address => uint256) public poolBalances;

    function createPool() public {
        poolBalances[msg.sender] = 0;
    }

    function stake(address token, uint256 value) external {
        require(value > 0, "Value must be greater than 0");
        require(token != address(0), "Token must not be the zero address");

        IERC20(token).transferFrom(msg.sender, address(this), value);
        balances[msg.sender] += value;
    }
}