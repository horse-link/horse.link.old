// SPDX-License-Identifier: MIT
pragma solidity =0.8.6;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./IPool.sol";

struct Bet {
    bytes32 id;
    uint256 amount;
    uint256 payout;
    uint256 payoutDate;
    bool claimed;
    address owner;
}

contract Market is Ownable {

    address private immutable _pool;
    // mapping(address => Bet[]) private _bets;

    Bet[] private _bets;
 
    function getPoolAddress() external view returns (address) {
        return _pool;
    }

    constructor(address pool, uint256 maxSlippage) {
        _pool = pool;
    }

    function getBet(uint256 index) external view returns (uint256, uint256, uint256, bool, address) {
        return (_bets[index].amount, _bets[index].payout, _bets[index].payoutDate, _bets[index].claimed, _bets[index].owner);
    }

    function back(bytes32 id, uint256 amount, uint256 odds, uint256 start, uint256 end, bytes32 calldata signature) external returns (uint256) {
        require(start < block.timestamp, "Betting start time has not passed");
        return _bets.length;
    }

    function recoverSigner(bytes32 message, bytes memory signature)
        internal
        pure
        returns (address)
    {
        uint8 v;
        bytes32 r;
        bytes32 s;

        (v, r, s) = splitSignature(signature);

        return ecrecover(message, v, r, s);
    }

    function splitSignature(bytes memory signature)
        internal
        pure
        returns (uint8, bytes32, bytes32)
    {
        require(signature.length == 65);

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            // first 32 bytes, after the length prefix
            r := mload(add(signature, 32))
            // second 32 bytes
            s := mload(add(signature, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(signature, 96)))
        }

        return (v, r, s);
    }
}