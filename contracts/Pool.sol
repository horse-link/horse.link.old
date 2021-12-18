// SPDX-License-Identifier: MIT
pragma solidity =0.8.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Pool {

    mapping(address => mapping(address => uint256)) public balances;
    mapping(address => uint256) public tlv;
    address public immutable markets;

    constructor(address _markets) public {
        markets = _markets;
    }

    function createPool() public {
        tlv[msg.sender] = 0;
    }

    function stake(address token, address pool, uint256 value) external {
        require(value > 0, "Value must be greater than 0");
        require(token != address(0), "Token must not be the zero address");
        require(pool != address(0), "Pool must not be the zero address");

        IERC20(token).transferFrom(msg.sender, address(this), value);
        balances[pool][msg.sender] += value;
        tlv[pool] += value;

        emit Staked(msg.sender, pool, value);
    }

    event Staked(address indexed owner, address indexed pool, uint256 value);
}