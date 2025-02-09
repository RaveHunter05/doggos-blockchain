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

    mapping(uint256 => string[]) public petLogs;
    mapping(uint256 => Pet) public petList;
    // mapping(address => Owner) ownerList;
    mapping(uint256 => address) public petOwnership;
    mapping(uint256 => address) public petToVeterinary;

    event PetSafeMinted(uint256 tokenId, string name, address owner);
    event OwnerInfoAdded(address ownerAddress, string name, uint256 age, string sex, string locationAddress, string country, string telephone, uint256 badge);
    event DogTransferred(uint256 tokenId, address from, address to);
    event LogAdded(uint256 tokenId, string logType, string description, uint256 timestamp); 
    event PetRemoved(uint256 tokenId, address owner);
    event PetTransferred(uint256 indexed tokenId, address indexed from, address indexed to);

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
        uint256[] memory surgeries
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
            status: "LIVING",
            owner: owner,
            veterinaryAddressRef: address(0)
        });

        petOwnership[tokenId] = owner;

         // Log the initial minting.  Use an event for efficient off-chain indexing.
        _addLog(tokenId, "MINT", "Pet minted", block.timestamp);
        emit PetSafeMinted(tokenId, name, owner);
    }

    function _addLog(uint256 tokenId, string memory logType, string memory description, uint256 timestamp) internal {
        petLogs[tokenId].push(string(abi.encodePacked(logType, "|", description, "|", Strings.toString(timestamp))));
        emit LogAdded(tokenId, logType, description, timestamp);
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
         _addLog(tokenId, "SURGERY", "Pet put in surgery", block.timestamp); // Log the surgery
    }

    function unassignVeterinary(uint256 tokenId) public onlyRole (DEFAULT_ADMIN_ROLE) {
        petList[tokenId].veterinaryAddressRef = address(0);
        _addLog(tokenId, "VET_UNASSIGNED", "Veterinary unassigned", block.timestamp);
    }

    function getPetLogs(uint256 tokenId)public view returns (string[] memory logs){
        require(petList[tokenId].owner != address(0), "pet has not been minted yet");
        return petLogs[tokenId];
    }

    function getPetInfo(uint256 tokenId) public view returns (Pet memory) {
    require(petOwnership[tokenId] == msg.sender, "You are not the owner of this pet");
    return petList[tokenId];
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

    function removePet(uint256 tokenId) public onlyRole(DEFAULT_ADMIN_ROLE) {  
        require(_ownerOf(tokenId) != address(0), "Pet does not exist"); 
        address owner = petOwnership[tokenId];
        delete petOwnership[tokenId];
        delete petLogs[tokenId]; //Check if need something else
        _burn(tokenId);
        emit PetRemoved(tokenId, owner);
    }

    function updatePetInfo (
        uint256 tokenId,
        string memory newName,
        string memory newBreed,
        string memory newColor, 
        string memory newSex,
        string memory newBirthDate, 
        uint256 newAge,
        uint256 newWeight,  /* Frontend should multiply by 100 i.e. 4550 (45.50 * 100) */
        uint256[] memory newVaccinesList, /// Frontend should has JSON list of this
        uint256[] memory newSurgeries
        ) public onlyRole (DEFAULT_ADMIN_ROLE){
            require(_ownerOf(tokenId) != address(0), "Pet does not exist"); // Check if the owner owns a pet, otherwise no need to update info 
             petList[tokenId].name = newName;
             petList[tokenId].breed = newBreed;
             petList[tokenId].color = newColor;
             petList[tokenId].age = newAge;
             petList[tokenId].sex = newSex; //TODO: Frontend will have this option. 
             petList[tokenId].birthdate = newBirthDate;
             petList[tokenId].weight = newWeight /100 ;/// Frontend should multiply by 100 i.e. 4550 (45.50 * 100)  
             petList[tokenId].vaccinesList = newVaccinesList;// Check if the new vaccines list is empty or not?
             petList[tokenId].surgeries = newSurgeries;
    
        _addLog(tokenId, "UPDATE_PET", "Pet info updated", block.timestamp);
        }

    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    function _addressToString(address addr) internal pure returns (string memory) {
    bytes memory str = new bytes(42);
    str[0] = '0';
    str[1] = 'x';
    for (uint i = 0; i < 20; i++) {
        uint8 b = uint8(uint256(uint160(addr)) / (2**(4*(19 - i))) & 0xf); // Convertir b a uint8
        bytes1 upper = bytes1(b >> 4); // b ya es uint8, no necesita conversión
        bytes1 lower = bytes1(b & uint8(0xf)); // b ya es uint8, no necesita conversión
        str[2+i*2] = _HEX_SYMBOLS[uint8(upper)];
        str[3+i*2] = _HEX_SYMBOLS[uint8(lower)];
    }
    return string(str);
    }

    function transferPet(uint256 tokenId, address newOwner) public {
    require(_ownerOf(tokenId) == msg.sender, "You are not the owner of this pet");

    address previousOwner = _ownerOf(tokenId);

    transferFrom(msg.sender, newOwner, tokenId);

    _addLog(tokenId,
        "TRANSFER",
        string(abi.encodePacked("Pet transferred to ", _addressToString(newOwner))), // Concatenación correcta
        block.timestamp); // Reutilizar _addLog

    emit PetTransferred(tokenId, previousOwner, newOwner);
    }

    function getVaccinesList(uint256 tokenId) public view returns (uint256[] memory) {
    require(_ownerOf(tokenId) != address(0), "Pet does not exist");
    require(petOwnership[tokenId] == msg.sender, "You are not the owner of this pet");
    return petList[tokenId].vaccinesList;
    }

    function getPetsByOwner(address owner) public view returns (Pet[] memory) {
    Pet[] memory petArray = new Pet[](0); // start an empty array
    uint256 petCount = 0;
    uint256 totalTokens = totalSupply();

    for (uint256 i = 0; i < totalTokens; i++) {
        uint256 tokenId = tokenByIndex(i);
        if (_ownerOf(tokenId) == owner) {
            petCount++;
            Pet[] memory temp = new Pet[](petCount);
            for (uint256 j = 0; j < petCount - 1; j++) {
                temp[j] = petArray[j];
            }
            temp[petCount - 1] = petList[tokenId]; // Asign struct Pet directly
            petArray = temp;
        }
    }

    return petArray;
   }

}

 library Strings {
        bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

        function toString(uint256 value) internal pure returns (string memory) {
            if (value == 0) {
                return "0";
            }
            uint256 temp = value;
            uint256 digits;
            while (temp != 0) {
                digits++;
                temp /= 10;
            }
            bytes memory buffer = new bytes(digits);
            while (value != 0) {
                digits -= 1;
                buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
                value /= 10;
            }
            return string(buffer);
        }
    }