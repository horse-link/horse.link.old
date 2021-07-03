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

    mapping(address => mapping(bytes32 => mapping(uint => mapping(uint => mapping(uint => mapping(uint => uint[])))))) public results;

    function addResult(bytes32 mnemonic, uint year, uint month, uint day, uint race, uint[] memory _results) public {
        results[msg.sender][mnemonic][year][month][day][race] = _results;

        emit ResultAdded(msg.sender, block.timestamp, mnemonic, year, month, day, race);
    }

    event ResultAdded(address indexed who, uint256 timestamp, bytes32 mnemonic, uint year, uint month, uint day, uint race);
}