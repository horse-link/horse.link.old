// SPDX-License-Identifier: MIT
pragma solidity =0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../IMintable.sol";
import "../IBurnable.sol";

struct Rewards {
    uint256 balance;
    uint256 start;
}

contract Pool is Ownable {
    // Rewards
    mapping(address => Reward) private _rewards;
    uint256 private constant REWARDS_PER_BLOCK;

    // Wages
    uint256 private _supplied; // total added to the contract from LPs
    uint256 private _inPlay;

    address private immutable _lpToken;
    address private immutable _rewardsToken;
    address private immutable _underlying;

    uint256 private constant PRECISSION = 1_000;

    function getUnderlying() external view returns (address) {
        return _underlying;
    }

    function getUnderlyingBalance() public view returns (uint256) {
        return IERC20(_underlying).balanceOf(address(this));;
    }

    function getPoolPerformance() external returns (int256) {
        uint256 underlyingBalance = IERC20(_underlying).balanceOf(address(this));
        return _supplied / underlyingBalance;
    }

    function getLPTokenAddress() external view returns (address) {
        return _lpToken;
    }

    function supplied() external view returns (uint256) {
        return _supplied;
    }

    function totalReserves() external view returns (uint256) {
        return _tlv - _inPlay;
    }

    constructor(address lpToken, address underlying) {
        require(token != address(0) && underlying != address(0), "Invalid address");
        _lpToken = lpToken;
        _underlying = underlying;
    }

    // Tokens added to the pool
    function supply(uint256 amount) external {
        require(amount > 0, "Value must be greater than 0");

        IERC20(_token).transferFrom(msg.sender, address(this), amount);
        IMintable(_lpToken).mintTo(msg.sender,amount);

        _supplied += amount;

        emit Supplied(msg.sender, amount);
    }

    function exit(uint256 amount) external {
        require(amount > IERC20(_lpToken).balanceOf(msg.sender), "You must have a balance to exit");

        // Burn the LP Token
        IBurnable(_lpToken).burnFrom(msg.sender, amount);
        _supplied -= amount;

        emit Exited(msg.sender, amount);
    }

    event Exited(address indexed who, uint256 value);
    event Supplied(address indexed owner, uint256 value);
}