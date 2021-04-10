// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@chainlink/contracts/src/v0.6/Oracle.sol";
import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.6/vendor/Ownable.sol";
import "./TokenHandler.sol";

contract APIConsumer is ChainlinkClient, Ownable, TokenHandler {
    struct claimInfo {
        address claimant;
        string tokenSymbol;
    }
    uint256 private constant ORACLE_PAYMENT = LINK/10;
    mapping(bytes32 => claimInfo) public claimRecord;

    event RequestNFTClaimFullfilled(
        bytes32 indexed requestId,
        bool indexed _result,
        address winner
    );

    /// @notice NODE is initialized, only NODE can invoke fulfillNFTClaim()
    constructor(address  _tokenAddr)
        public
        Ownable()
        TokenHandler(_tokenAddr)
    {
        setPublicChainlinkToken();
    }

    /// @notice NFT claim initiated by user
    function requestNFTClaim(
        address _oracle,
        string memory _jobId,
        string memory _tokenSymbol
    ) public onlyOwner {
        require(
            claims[msg.sender][_tokenSymbol] !=
                tokenSymbolToCollectibleId[_tokenSymbol], // collectibleId of the token,
            "NFT already claimed for the token symbol !"
        );

        Chainlink.Request memory req =
            buildChainlinkRequest(
                stringToBytes32(_jobId),
                address(this),
                this.fulfillNFTClaim.selector
            );

        // Turned off for testing purposes
        // req.add(
        //     "get",
        //     string(abi.encodePacked(abi.encodePacked(msg.sender), _tokenSymbol))
        // );
        req.add(
            "get",
            "https://immense-mesa-34535.herokuapp.com/check/nft/0xcfdf8fffaa4dd7d777d448cf93dd01a45e97d782/LINK"
        );
        req.add("path", "result");
        bytes32 requestId =
            sendChainlinkRequestTo(_oracle, req, ORACLE_PAYMENT);
        claimRecord[requestId] = claimInfo(msg.sender, _tokenSymbol);
    }

    /// @notice request fullfilled by NODE
    function fulfillNFTClaim(bytes32 _requestId, bool _result)
        public
        recordChainlinkFulfillment(_requestId)
    {
        // if (_result) {
        rewardNFT(
            claimRecord[_requestId].tokenSymbol,
            claimRecord[_requestId].claimant
        );
        emit RequestNFTClaimFullfilled(
            _requestId,
            _result,
            claimRecord[_requestId].claimant
        );
        // }
    }

    /// @notice helper funtion to convert string to bytes32
    function stringToBytes32(string memory source)
        private
        pure
        returns (bytes32 result)
    {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            // solhint-disable-line no-inline-assembly
            result := mload(add(source, 32))
        }
    }
}
