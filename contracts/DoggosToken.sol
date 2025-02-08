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
    // bytes32 public constant VETERINARY_ROLE = keccak256("VETERINARY_ROLE"); // Enhancement for the future
    // bytes32 public constant PET_OWNER_ROLE = keccak256("PET_OWNER_ROLE");
    uint256 private _nextTokenId;

    struct Pet {
        string name;
        string breed;
        string color;
        uint256 age;
        string sex;
        string birthdate;
        uint256[] vaccinesList; /// Frontend should has JSON list of this
        uint256 weight; /// Frontend should multiply by 100 i.e. 4550 (45.50 * 100)
        uint256[] surgeries; /// Frontend should has JSON list of this
        string status;
        address owner;
        address veterinaryAddressRef; /// Reference the veterinary active in charge of this pet
    }

    // struct Owner {
    //     string name;
    //     uint256 age;
    //     string sex;
    //     string locationAddress;
    //     string country;
    //     string telephone;
    //     uint256[] badge; /// FRONTEND SHOULD HAVE the list of this
    //     string addressRef; // String representation of the address of the owner.
    // }

    mapping(uint256 => Pet) petList;
    // mapping(address => Owner) ownerList;
    mapping(uint256 => address) public petOwnership;
    mapping(uint256 => address) public petToVeterinary;

    event PetSafeMinted(uint256 tokenId, string name, address owner);
    event OwnerInfoAdded(address ownerAddress, string name, uint256 age, string sex, string locationAddress, string country, string telephone, uint256 badge);
    event DogTransferred(uint256 tokenId, address from, address to);

    constructor(address _defaultAdmin) ERC721("DoggosToken", "DOGT") {
        _grantRole(DEFAULT_ADMIN_ROLE, _defaultAdmin); // Only set the default admin in constructor
    }

    function grantMinterRole(address _minter) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(MINTER_ROLE, _minter);
    }

    function revokeMinterRole(address _minter) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _revokeRole(MINTER_ROLE, _minter);
    }

    function grantPauserRole(address _pauser) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(PAUSER_ROLE, _pauser);
    }

    function revokePauserRole(address _pauser) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _revokeRole(PAUSER_ROLE, _pauser);
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
        uint256[] memory surgeries, 
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
            owner: owner,
            veterinaryAddressRef: address(0)
        });

        petOwnership[tokenId] = owner;
    }

    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    // @description: When veterinary is going to perform the surgery to the pet.
    // onlyRole(Veterinary)
    function setPetInSurgery(uint256 tokenId) public onlyRole(DEFAULT_ADMIN_ROLE) {
        require(petList[tokenId].veterinaryAddressRef == msg.sender, "You are not the owner of this dog");
        petList[tokenId].status = "IN_SURGERY";
    }

    function unassignVeterinary(uint256 tokenId) public onlyRole (DEFAULT_ADMIN_ROLE) {
        petList[tokenId].veterinaryAddressRef = address(0);
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
