// SPDX-License-Identifier: MIT
pragma solidity =0.8.6;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

struct Result {
    uint256 first;
    uint256 second;
    uint256 third;
    uint256 forth;
    uint256 timestamp;
}

contract Horse is Ownable {

    uint256 public count;

    mapping(bytes32 => mapping(uint256 => mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256[]))))) public results;

    function addResult(bytes32 mnemonic, uint256 year, uint256 month, uint256 day, uint256 race, uint256[] memory _results) public {
        require(results[mnemonic][year][month][day][race].timestamp = 0, "Already set");
        results[mnemonic][year][month][day][race] = _results;
        count++;
        emit ResultAdded(msg.sender, block.timestamp, mnemonic, year, month, day, race);
    }

    event ResultAdded(address indexed who, uint256 timestamp, bytes32 mnemonic, uint year, uint month, uint day, uint race);
}