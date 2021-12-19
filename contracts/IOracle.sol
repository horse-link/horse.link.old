// SPDX-License-Identifier: MIT
pragma solidity =0.8.6;

// Horse.Link oracle interface
interface IOracle {
    function getResult(bytes32 track, uint256 year, uint256 month, uint256 day, uint8 race, uint8 position) external returns (uint8);
}