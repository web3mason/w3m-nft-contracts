// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import "erc721a-upgradeable/contracts/ERC721AUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Web3Masons is ERC721AUpgradeable, OwnableUpgradeable {
    uint256 private _MAX_SUPPLY;

    //string public PROVENANCE = "hash";
    //uint256 public startingIndex;

    function initialize() public initializerERC721A initializer {
        __ERC721A_init("Web3Masons", "W3M");
        __Ownable_init();
        _MAX_SUPPLY = 10_000;
    }

    function mint(address to, uint256 quantity) external onlyOwner {
        require(_totalMinted() + quantity <= _MAX_SUPPLY, "MAX SUPPLY");
        _mint(to, quantity);
    }

    // The following functions are overrides required by Solidity.
    function _startTokenId() internal view override returns (uint256) {
        return 1;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        if (!_exists(tokenId)) revert URIQueryForNonexistentToken();

        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length != 0
                ? string(abi.encodePacked(baseURI, _toString(tokenId)))
                : "";
    }
}
