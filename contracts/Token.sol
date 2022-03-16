// SPDX-License-Identifier: MIT
pragma solidity =0.8.10;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20, Ownable {

    address private _pool;

    constructor() ERC20("Horse Link Pool Tokens", "HORSE") {

    }
    
    function setPool(address pool) external onlyOwner {
        require(pool != address(0), "Invalid pool address");
        _pool = pool;
    }

    function mintTo(address to, uint256 amount) external onlyPool {
        require(to != address(0), "Invalid recipient address");
        require(amount > 0, "Invalid amount");
        _mint(to, amount);
    }

    modifier onlyPool {
        require(msg.sender == _pool, "Only the pool can call this function");
        _;
    }
}