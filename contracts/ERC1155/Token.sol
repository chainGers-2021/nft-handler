// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract Token is ERC1155 {
    uint256 public collectibleId;
    address public admin;

    constructor(string memory _tokenURI) public ERC1155(_tokenURI) {
        collectibleId = 1;
        admin = msg.sender;
    }

    function mint(address _receiver, uint256 amount) public {
        require(tx.origin == admin);
        _mint(_receiver, collectibleId, amount, "");
        collectibleId++;
    }
}
