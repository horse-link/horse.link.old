pragma solidity 0.7.0;

struct Result {
    uint first;
    uint second;
    uint third;
    uint forth;
}

contract Horse {

    address private _owner;

    mapping(bytes32 => mapping(uint => mapping(uint => mapping(uint => mapping(uint => uint[]))))) public results;

    constructor() {
        _owner = msg.sender;
    }

    function addResult(bytes32 mnemonic, uint year, uint month, uint day, uint race, uint[] memory _results) public {
        results[mnemonic][year][month][day][race].push(_results);
    }

    event Result();
}