// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@chainlink/contracts/src/v0.6/Oracle.sol";
import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.6/vendor/Ownable.sol";
import "./TokenHandler.sol";

/// @title APIConsumer+NFT(Holder & Distributor)
/// @notice This contract handles all NFT related tasks such as:
///         minting new NFTs, claimingNFT requests, fullfillingNFT requests
/// @dev ChainlinkClient Inheritance: to create and
///        fullfull requests through chainlink oracle
///      Ownable
contract APIConsumer is ChainlinkClient, Ownable, TokenHandler {
    struct claimInfo {
        address claimant;
        string tokenSymbol;
    }
    uint256 private constant ORACLE_PAYMENT = 1 * LINK;
    mapping(bytes32 => claimInfo) public claimRecord;

    /// @notice Event emitted to successful token transfer
    event RequestNFTClaimFullfilled(
        bytes32 indexed requestId,
        bool indexed _result,
        address winner
    );

    /// @notice NODE is initialized, only NODE can invoke fulfillNFTClaim()
    constructor(address _tokenAddr) public Ownable() TokenHandler(_tokenAddr) {
        setPublicChainlinkToken();
    }

    /// @notice Can be only called from admin
    function mintTokens(string memory _tokenSymbol) public onlyOwner {
        _mintTokens(_tokenSymbol);
    }

    /// @notice NFT claim initiated by user
    function requestNFTClaim(
        address _oracle,
        string memory _jobId,
        string memory _tokenSymbol
    ) public {
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

        req.add(
            "get",
            string(
                abi.encodePacked(
                    "https://glacial-bayou-75167.herokuapp.com/check/nft/",
                    addressToString(msg.sender),
                    "/",
                    _tokenSymbol
                )
            )
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
        if (_result) {
            _rewardNFT(
                claimRecord[_requestId].tokenSymbol,
                claimRecord[_requestId].claimant
            );
            emit RequestNFTClaimFullfilled(
                _requestId,
                _result,
                claimRecord[_requestId].claimant
            );
        }
    }

    /// @notice helper funtion to convert string to bytes32
    function stringToBytes32(string memory source)
        internal
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

    /// @notice helper function to convert address to string
    /// take from: https://ethereum.stackexchange.com/a/88201/64382
    function addressToString(address _addr)
        internal
        pure
        returns (string memory)
    {
        bytes32 _bytes = bytes32(uint256(_addr));
        bytes memory HEX = "0123456789abcdef";
        bytes memory _string = new bytes(42);
        _string[0] = "0";
        _string[1] = "x";
        for (uint256 i = 0; i < 20; i++) {
            _string[2 + i * 2] = HEX[uint8(_bytes[i + 12] >> 4)];
            _string[3 + i * 2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
        }
        return string(_string);
    }
}
