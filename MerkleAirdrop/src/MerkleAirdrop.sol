// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.26;

import  {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {Errors} from "./libary/Error.sol";
import {Event} from "./libary/Event.sol";
contract  Airdrop{

    using SafeERC20  for  IERC20;
// errors


//storage

    mapping (address => bool)  s_account;
    bytes32 private  immutable i_merkleRoot;

    IERC20 private immutable i_airdroptoken;
   

    constructor(bytes32 merkleRoot, IERC20 airdrop_token) {

        i_merkleRoot = merkleRoot;

        i_airdroptoken = airdrop_token;
        
    }

    function claim(address account, uint256 amount, bytes32[] calldata merkelProof) external{

        if(s_account[account]){
            revert Errors.ALREADY_CLAIMED_AIRDROP();
        }

        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account,amount))));

        if (!MerkleProof.verify(merkelProof, i_merkleRoot, leaf))
        {

            revert Errors.LEAF_NOT_IN_AIRDROP();
        }


        emit Event.Claim(account, amount);

        i_airdroptoken.safeTransfer(account, amount);



    }
    


}