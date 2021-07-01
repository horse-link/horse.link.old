// SPDX-License-Identifier: MIT
pragma solidity =0.8.6;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

struct Result {
    uint first;
    uint second;
    uint third;
    uint forth;
}

contract Horse is Ownable {

    mapping(address => mapping(bytes32 => mapping(uint => mapping(uint => mapping(uint => mapping(uint => uint[])))))) public results;

    function addResult(bytes32 mnemonic, uint year, uint month, uint day, uint race, uint[] memory _results) public {
        results[msg.sender][mnemonic][year][month][day][race] = _results;

        emit ResultAdded(msg.sender, mnemonic, year, month, day, race);
    }

    event ResultAdded(address indexed who, bytes32 mnemonic, uint year, uint month, uint day, uint race);
}