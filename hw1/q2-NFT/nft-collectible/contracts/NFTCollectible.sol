//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";


contract NFTCollectible is ERC721Enumerable, Ownable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    uint public constant MAX_SUPPLY = 30;
    uint public constant PRICE = 0.1 ether;
    uint public constant MAX_PER_MINT = 5;

    string public baseTokenURI;

    constructor(string memory baseURI) ERC721("NFT Collectible", "NFTC") {
        setBaseURI(baseURI);
    }

    // write an function to allow for owners to mint some NFT for free
    function reserveNFTs() public onlyOwner {
        uint totalMinted = _tokenIds.current();
        // make sure the total amount of right 
        require(
            totalMinted.add(10) < MAX_SUPPLY, "Not enough NFTs"
        );

        for (uint i = 0; i < 10; i++) {
            _mintSingleNFT();
        }
    }

    function _baseURI() internal 
                        view 
                        virtual 
                        override 
                        returns (string memory) {
                            return baseTokenURI;
                        }

    function setBaseURI(string memory _baseTokenURI) public onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    // the main functions that allows users to mint NFT 
    function mintNFTs(uint _count) public payable {
        uint totalMinted = _tokenIds.current();
        require(
            totalMinted.add(_count) <= MAX_SUPPLY, "Not enough NFTs!"
        );
        require(
            _count > 0 && _count <= MAX_PER_MINT, 
            "Cannot mint specified number of NFTs."
        );
        require(
            msg.value >= PRICE.mul(_count), 
            "Not enough ether to purchase NFTs."
        );
        for (uint i = 0; i < _count; i++) {
            _mintSingleNFT();
        }
    }

    // mint one NFT for the caller 
    function _mintSingleNFT() private {
        uint newTokenID = _tokenIds.current();
        _safeMint(msg.sender, newTokenID);
        _tokenIds.increment();
    }

    function tokensOfOwner(address _owner) 
         external 
         view 
         returns (uint[] memory) {
     uint tokenCount = balanceOf(_owner);
     uint[] memory tokensId = new uint256[](tokenCount);
     for (uint i = 0; i < tokenCount; i++) {
          tokensId[i] = tokenOfOwnerByIndex(_owner, i);
     }

     return tokensId;
}

}











