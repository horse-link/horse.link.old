// SPDX-License-Identifier: MIT
pragma solidity =0.8.6;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import "./BokkyPooBahsDateTimeLibrary.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

struct Result {
    uint256[] results;
    uint256 timestamp;
}

contract HorseLink is Ownable {
    using BokkyPooBahsDateTimeLibrary for uint;
    uint256 public count;
    address public token;

    mapping(address => uint256) public rewards;

    // mapping(bytes32 => mapping(uint256 => mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256[]))))) public results;
    mapping(bytes32 => mapping(uint256 => mapping(uint256 => mapping(uint256 => mapping(uint256 => Result))))) public results;

    constructor(address _token) {
        token = _token;
    }

    function addResult(bytes32 mnemonic, uint256 year, uint256 month, uint256 day, uint256 race, uint256[] memory _results) public {
        require(year >= 1970, "Too far in the past");
        require(BokkyPooBahsDateTimeLibrary.isValidDate(year, month, day), "Invalid date");
        require(BokkyPooBahsDateTimeLibrary.timestampFromDate(year, month, day) < block.timestamp, "Cannot add results of future events");
        require(results[mnemonic][year][month][day][race].timestamp == 0, "Results have already added");
        require(_results.length <= 4, "Too many results");
        
        results[mnemonic][year][month][day][race] = Result(_results, block.timestamp);
        count++;
        rewards[msg.sender]++;

        emit ResultAdded(msg.sender, block.timestamp, mnemonic, year, month, day, race, _results.length);
    }

    function claim() public {
        require(rewards[msg.sender] > 0, "No rewards earned");
        IERC20(token).transferFrom(address(this), msg.sender, rewards[msg.sender]);
        rewards[msg.sender] = 0;
    }

    event ResultAdded(address indexed who, uint256 timestamp, bytes32 mnemonic, uint256 year, uint256 month, uint256 day, uint256 race, uint256 total);
}