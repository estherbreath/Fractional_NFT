// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {FractionNFT} from "../src/FractionalNFT.sol";
import "./Helpers.sol";

contract FractionalNFT is Test{

   FractionalNFT fNFT;

   
    uint256 totalFractions;
     address owner;
       
    address addrA;
    address addrB;

    uint256 privKeyA;
    uint256 privKeyB;


     FractionalNFT.nftDetails l;

      function setUp() public {
        mPlace = new NFTMarket();

          (addrA, privKeyA) = mkaddr("ADDRA");
        (addrB, privKeyB) = mkaddr("ADDRB");

}
}

