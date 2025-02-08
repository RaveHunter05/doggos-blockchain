// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// FIRST ATTEMPT

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DoggosRegistry is ERC721Burnable, Ownable, ERC721Enumerable {

    struct Dog {
        string name;
        string breed;
        string color;
        uint256 age;
        string birthdate;
        uint256 vaccinesList;
        string surgeries;
        string status;
        address owner; //check this address of the dog's owner
    }

    struct Owner {
        string name;
        uint256 age;
        string sex;
        string locationAddress;
        string country;
        string telephone;
        string badge;
    }

    mapping(uint256 => Dog) _dogs;
    mapping(address => Owner) private_owners; 
    mapping(uint => address) private_dogOwnership;

    event DogMinted(uint256 tokenId, string name, address owner);
    event DogTransferred(uint256 tokenId, address from, address to);
    event OwnerAdded(address ownerAddress, string name, uint256 age, string sex, string locationAddress, string country, string telephone, string badge);


    constructor(address initialOwner) 
    ERC721("DogNFT", "DOG") 
    Ownable(initialOwner)
    {}

    function initializeOwners() public onlyOwner {
       addOwner(address(0x5B38Da6e701c54C6A904294973C74D7212EA988F), "EM", 37, "Male", "Managua", "Nicaragua", "112345678", "Good Owner"); // info examples address should be modified
       addOwner(address(0xA51c91A92871f3bEa7919277C2b915432B740977), "LM", 25, "Male", "Managua", "Nicaragua", "112345677", "Good Owner");
       addOwner(address(0xCf7Ed3Ac5DD4F458C878D942194169986348547F), "FS", 25, "Male", "Managua", "Nicaragua", "112345679", "Good Owner"); 
    }

    function mintDog(
        uint256 tokenId,
        string memory name,
        string memory breed,
        string memory color,
        uint256 age,
        uint256 poundsWeight,
        string memory sex,
        string memory birthDate,
        uint256[] memory vaccinesList,
        string memory surgeries,
        string memory status,
        address owner  // need the address for minting
    )
    public onlyOwner{
        _mint(owner, tokenId); //this will mint to the right owner

        _dogs[tokenId] = Dog({
            name: name, 
            breed: breed, 
            color: color,
            age: age,
            pounds: pounds,
            sex: sex,
            birthdate: birthdate,
            vaccineList: vaccineList,
            surgeries: surgeries,
            status: status,
            owner: owner
        });

        _dogOwnership[tokenId] = owner; // set the dog's owner

        emit DogMinted(tokenId, name, owner);
    } 

    function transferDog(uint256 tokenId, address newOwner) public {
        require(_dogOwnership[tokenId] == msg.sender || owner() == msg.sender, "You are not the owner of this dog"); // in these way current owner or contract owner can transfer
        _transfer(msg.sender, newOwner, tokenId);
        _dogOwnership[tokenId] = newOwner; // Update ownership 
        _dogs[tokenId].owner = newOwner; // Update owner in Dog struct
        emit DogTransferred(tokenId, msg.sender, newOwner);     
    }


    function getDog(uint256 tokenId) public view returns (Dog memory) {
        require(_exists(tokenId), "Dog does not exist");
        return _dogs[tokenId];
    }

    function addOwner(
        address ownerAddress,
        string memory name,
        uint256 age,
        string memory sex,
        string locationAddress,
        string memory country,
        string memory telephone,
        string memory badge) 
    public onlyOwner {
        _owners[ownerAddress] = Owner({
            name: name,
            age: age,
            sex: sex,
            locationAddress: locationAddress,
            country: country,
            telephone: telephone,
            badge: badge
        });

        emit OwnerAdded(ownerAddress, name, age, sex, address, country, telephone, badge);

    }

    function getOwner(address ownerAddress) public view returns (Owner memory) {
        return _owners[ownerAddress];
    }

    function setDogStatus(uint256 tokenId, string memory newStatus) public {
        require(_dogOwnership[tokenId] == msg.sender || owner() == msg.sender, "You are not the owner of this dog");
        _dogs[tokenId].status = newStatus;
    }

    function setDogSurgeries(uint256 tokenId, string memory newSurgeries) public {
        require(_dogOwnership[tokenId] == msg.sender || owner() == msg.sender, "You are not the owner of this dog");
        _dogs[tokenId].surgeries = newSurgeries;
        setDogStatus(tokenId, "OPERATED");
    }

    function addToVaccineList(uint256 tokenId, uint256 vaccineId) public {
        require(_dogOwnership[tokenId] == msg.sender || owner() == msg.sender, "You are not the owner of this dog");
        _dogs[tokenId].vaccineList.push(vaccineId);
    }

    function burnDog(uint256 tokenId) public {
    require(_exists(tokenId), "Token does not exist"); // Use _exists from ERC721

    address owner = _dogOwnership[tokenId]; // Get the owner before burning
    require(msg.sender == owner || owner() == msg.sender, "You are not the owner of this dog"); // Only owner or contract owner can burn

    delete _dogs[tokenId]; // Correct mapping name
    delete _dogOwnership[tokenId]; // Clean up the ownership mapping

    _burn(tokenId); // Use _burn from ERC721Burnable
}

}
