// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


import "../src/FractionalNFT.sol";

contract FractionalNFT is Test{

   FractionalNFT fNFT;

   string private _baseTokenURI;
   uint256 private _nextTokenId = 1;
   uint256 public fractionPrice = 0.5 ether;
   uint256 public platformFeePercentage = 10; 
   
    uint256 totalFractions;
    address owner;

    
       
      function setUp() public {
       fNFT = new  FractionalNFT();
}

    function testNFTGreaterThanZero() public {
    vm.expectRevert("Fractions must be greater than 0");
     FractionalNFT.tokenizeNFT(1, 0.1); 
    } 
    function testValueNotGReaterThanFractionPrice() public {
    vm.expectRevert("Insufficient payment for fraction");
      fNFT.purchaseFraction(1);
    } 

  function testFractionOwnerEqualToContractOwner() public {
     vm.expectRevert("You do not own this fraction");
      fNFT.tranferFraction(1, "0x97C1A26482099363cb055f0F3Ca1D6057Fe55447");
  } 

    function testFractionIdEqualsAddress() public {
    vm.expectRevert("Fraction is not available for purchase");
      fNFT.purchaseFraction(1);
    } 






}

