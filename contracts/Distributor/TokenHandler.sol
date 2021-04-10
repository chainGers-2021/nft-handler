// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155Holder.sol";
import "./../ERC1155/Token.sol";

abstract contract TokenHandler is ERC1155Holder {
    // Symbol of token => collectibleId
    mapping(string => uint256) public tokenSymbolToCollectibleId;
    // Address of claimant => Symbol of token => roundId (or collectible id ?)
    mapping(address => mapping(string => uint256)) public claims;

    address public tokenAddr;

    constructor(address _tokenAddr) public {
        tokenAddr = _tokenAddr;
    }

    /// @notice Token minting can only be done by admins
    function mintTokens(string calldata _tokenSymbol) external {
        Token(tokenAddr).mint(address(this), 5);
        tokenSymbolToCollectibleId[_tokenSymbol] =
            Token(tokenAddr).collectibleId() -
            1;
    }

    /// @notice Oracle node is supposed to fullfill this transaction
    function rewardNFT(string memory _tokenSymbol, address _claimant) virtual internal {
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
