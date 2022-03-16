// SPDX-License-Identifier: MIT
pragma solidity =0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Pool is Ownable {

    mapping(address => uint256) private balances;
    uint256 private _tlv;
    uint256 private _inPlay;
    address private immutable _underlying;
    address private immutable _self;

    mapping(address => bool) public oracles;

    function balanceOf(address who) external view returns (uint256) {
        return balances[who];
    }

    function getUnderlying() external view returns (address) {
        return _underlying;
    }

    function getTLV() external view returns (uint256) {
        return _tlv;
    }

    constructor(address underlying, address[] memory _oracles) {
        require(underlying != address(0), "Address must be set");
        _underlying = underlying;
        
        for (uint256 i; i < _oracles.length; i++) {
            require(_oracles[i] != address(0), "Address must be set");
            oracles[_oracles[i]] = true;
        }

        _self = address(this);
    }

    function supply(uint256 value) external {
        require(value > 0, "Value must be greater than 0");

        IERC20(_underlying).transferFrom(msg.sender, _self, value);
        balances[msg.sender] += value;
        _tlv += value;

        emit Supplied(msg.sender, value);
    }

    function exit() external {
        // get the amount of tokens that the user has proportionate to the pool
        uint256 amount = _tlv / balances[msg.sender];
        require(amount > 0, "You must have a balance to exit");

        IERC20(_underlying).transfer(msg.sender, amount);

        balances[msg.sender] = 0;
        _tlv -= amount;

        emit Exited(msg.sender, amount);
    }

    event Exited(address indexed who, uint256 value);
    event Supplied(address indexed owner, uint256 value);
}