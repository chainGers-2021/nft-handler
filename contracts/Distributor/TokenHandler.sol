// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155Holder.sol";
import "./../ERC1155/Token.sol";

contract TokenHandler is ERC1155Holder {
    address public tokenAddr;
    mapping(string => uint256) public tokenSymbolToCollectibleId;
    mapping(address => mapping(string => uint256)) public claims;

    constructor(address _tokenAddr) public {
        tokenAddr = _tokenAddr;
    }

    /// @notice Token minting can only be done by admins
    function _mintTokens(string memory _tokenSymbol) virtual internal {
        Token(tokenAddr).mint(address(this), 5);
        tokenSymbolToCollectibleId[_tokenSymbol] =
            Token(tokenAddr).collectibleId() -
            1;
    }

    /// @notice Oracle node is supposed to fullfill this transaction
    function _rewardNFT(string memory _tokenSymbol, address _claimant)
        internal
        virtual
    {
        // require(msg.sender == address(this));
        require(
            claims[_claimant][_tokenSymbol] !=
                tokenSymbolToCollectibleId[_tokenSymbol], // collectibleId of the token,
            "NFT already claimed for the token symbol !"
        );
        // TODO: Send the NFT of the corresponding token symbol to the claimant
        claims[_claimant][_tokenSymbol] = tokenSymbolToCollectibleId[
            _tokenSymbol
        ]; // collectibleId of the token

        Token(tokenAddr).safeTransferFrom(
            address(this),
            _claimant,
            tokenSymbolToCollectibleId[_tokenSymbol],
            1,
            ""
        );
    }
}
