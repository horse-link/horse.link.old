// SPDX-License-Identifier: MIT
pragma solidity =0.8.6;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "./IOracle.sol";

contract TabClient is ChainlinkClient, IOracle {
    using Chainlink for Chainlink.Request;

    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    /**
     * Network: Kovan
     * Oracle: 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8 (Chainlink Devrel   
     * Node)
     * Job ID: d5270d1c311941d0b08bead21fea7747
     * Fee: 0.1 LINK
     */
    constructor() {
        setPublicChainlinkToken();
        oracle = 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8;
        jobId = "d5270d1c311941d0b08bead21fea7747";
        fee = 0.1 * 10 ** 18; // (Varies by network and job)
    }

    function getResult(bytes32 track, uint256 year, uint256 month, uint256 day, uint8 race, uint8 position) external override returns (uint8) {
        return 0;
    }
}