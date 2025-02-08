// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

/// CURRENT WORKING

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Burnable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721Pausable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

/// @custom:security-contact exra2mp@gmail.com, luisangelmarcia@gmail.com
contract DoggosToken is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Pausable, AccessControl, ERC721Burnable {
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    uint256 private _nextTokenId;

    struct Pet {
        string name;
        string breed;
        string color;
        uint256 age;
        string sex;
        string birthdate;
        uint256[] vaccinesList;
        uint256 weight; /// Frontend should multiply by 100 i.e. 4550 (45.50 * 100)
        string[] surgeries;
        string status;
        address owner;
    }

    struct Owner {
        string name;
        uint256 age;
        string sex;
        string locationAddress;
        string country;
        string telephone;
        uint256[] badge;
        string addressRef; // String representation of the address of the owner.
    }

    mapping(uint256 => Pet) petList;
    mapping(address => Owner) ownerList;
    mapping(uint => address) petOwnership;

    event PetSafeMinted(uint256 tokenId, string name, address owner);
    event OwnerInfoAdded(address ownerAddress, string name, uint256 age, string sex, string locationAddress, string country, string telephone, uint256 badge);
    event DogTransferred(uint256 tokenId, address from, address to);

    constructor(address defaultAdmin, address pauser, address minter)
        ERC721("DoggosToken", "DOGT")
    {
        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
        _grantRole(PAUSER_ROLE, pauser);
        _grantRole(MINTER_ROLE, minter);
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function safeMint(
        address owner, 
        string memory uri, 
        string memory name, 
        string memory breed, 
        string memory color, 
        uint256 age, 
        uint256 weight, 
        string memory sex, 
        string memory birthdate, 
        uint256[] memory vaccinesList, 
        string[] memory surgeries, 
        string memory status
    ) public onlyRole(MINTER_ROLE) {
        uint256 tokenId = _nextTokenId++;
        _safeMint(owner, tokenId);
        _setTokenURI(tokenId, uri);

        petList[tokenId] = Pet({
            name: name,
            breed: breed,
            color: color,
            age: age,
            weight: weight,
            sex: sex,
            birthdate: birthdate,
            vaccinesList: vaccinesList,
            surgeries: surgeries,
            status: status,
            owner: owner
        });
    }

    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
