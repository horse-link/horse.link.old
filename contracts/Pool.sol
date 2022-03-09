// SPDX-License-Identifier: MIT
pragma solidity =0.8.6;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Pool is Ownable {

    mapping(address => uint256) private balances;
    uint256 private _tlv;
    uint256 private _inPlay;
    address private immutable _token;

    function balanceOf(address who) external view returns (uint256) {
        return balances[who];
    }

    function getTokenAddress() external view returns (address) {
        return _token;
    }

    function getTLV() external view returns (uint256) {
        return _tlv;
    }

    constructor(address token) {
        require(token != address(0), "Address must be set");
        _token = token;
    }

    function supply(uint256 value) external {
        require(value > 0, "Value must be greater than 0");

        IERC20(_token).transferFrom(msg.sender, address(this), value);
        balances[msg.sender] += value;
        _tlv += value;

        emit Supplied(msg.sender, value);
    }

    function exit() external {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "You must have a balance to exit");

        IERC20(_token).approve(msg.sender, amount);
        IERC20(_token).transferFrom(msg.sender, address(this), amount);
        balances[msg.sender] = 0;
        _tlv -= balances[msg.sender];

        emit Exited(msg.sender, amount);
    }

    event Exited(address indexed who, uint256 value);
    event Supplied(address indexed owner, uint256 value);
}