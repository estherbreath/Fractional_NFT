// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

abstract contract FractionalNFTPlatform is ERC721Enumerable, Ownable {
    string private _baseTokenURI;
    uint256 private _nextTokenId = 1;
    uint256 public fractionPrice = 0.5 ether;
    uint256 public platformFeePercentage = 10; // 0.1%

    struct NFTDetails {
        uint256 totalFractions;
        address owner;
    }

    mapping(uint256 => NFTDetails) public nftDetails;
    mapping(uint256 => uint256) public fractionToNFT; // Maps fraction to original NFT ID

   constructor(string memory _name, string memory _symbol, string memory baseTokenURI) ERC721(_name, _symbol) {
    _baseTokenURI = baseTokenURI;
}

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string memory baseTokenURI) external onlyOwner {
        _baseTokenURI = baseTokenURI;
    }

    function mintNFT(address to) external onlyOwner {
        _safeMint(to, _nextTokenId);
        nftDetails[_nextTokenId] = NFTDetails(1, to);
        _nextTokenId++;
    }

    function tokenizeNFT(uint256 nftId, uint256 fractions) external onlyOwner {
        require(fractions > 0, "Fractions must be greater than 0");
        require(fractions <= _nextTokenId, "Cannot tokenize more fractions than available NFTs");
        
        nftDetails[nftId].totalFractions += fractions;

        for (uint256 i = 0; i < fractions; i++) {
            fractionToNFT[_nextTokenId] = nftId;
            _safeMint(msg.sender, _nextTokenId);
            nftDetails[nftId].owner = msg.sender;
            _nextTokenId++;
        }
    }

    function purchaseFraction(uint256 fractionId) external payable {
        require(msg.value >= fractionPrice, "Insufficient payment for fraction");
        require(ownerOf(fractionId) == address(this), "Fraction is not available for purchase");

        // Calculate platform fee
        uint256 platformFee = (msg.value * platformFeePercentage) / 100;
        uint256 paymentToNFTOwner = msg.value - platformFee;

        // Transfer funds
        payable(nftDetails[fractionToNFT[fractionId]].owner).transfer(paymentToNFTOwner);
        payable(owner()).transfer(platformFee);

        // Transfer the fraction to the buyer
        _transfer(ownerOf(fractionId), msg.sender, fractionId);
    }

    function transferFraction(uint256 fractionId, address to) external {
        require(ownerOf(fractionId) == msg.sender, "You do not own this fraction");
        _transfer(msg.sender, to, fractionId);
    }
}



