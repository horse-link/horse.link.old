// SPDX-License-Identifier: MIT
pragma solidity =0.8.6;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import "./ERC721.sol";

struct Track {
    bytes32 name;
    bytes32 mnemonic;
    int8 timezone;
    address owner;
}

contract Track721 is ERC721, Ownable {

    mapping(bytes32 => uint256) private _tracks_to_index;
    mapping(uint256 => Track) private _tracks;

    constructor() ERC721("HorseLink", "NFT") {
    }

    function mintTrack(bytes32 name, bytes32 mnemonic, int8 timezone) public onlyOwner returns (uint256) {
        // require(msg.sender == address(this));
        uint256 tokenId = _tracks_to_index[name];
        require(!_exists(tokenId), "ERC721: token already minted");

        
        _mint(msg.sender, _totalSupply);
        _tracks_to_index[mnemonic] = _totalSupply;
        _tracks[_totalSupply] = Track(name, mnemonic, timezone, msg.sender);

        _totalSupply++;
        return _totalSupply;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return "https://horse.link/tracks/";
    }
}