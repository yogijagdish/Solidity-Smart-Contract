//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Task{

    address payable owner;


    struct donorDetail {
        string name;
        uint8 age;
        uint256 amount;
    }

    mapping (address => donorDetail) donor;

    event TransactionOccurred(address indexed from, address indexed to, uint256 amount);

    constructor() {
        owner = payable (msg.sender);
    }

    modifier isAmountZero {
        require(msg.value > 0, "Amount must be greater than zero");
        _;
    }

// modifier that checks if the one that calls the function is a owner or not
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
// function to donate amount from the address that calls the function to a particular donor address
    function donateEth( string memory donorName, uint8 donorAge) public payable isAmountZero  {
        donor[msg.sender].name = donorName;
        donor[msg.sender].age = donorAge;
        donor[msg.sender].amount += msg.value;
        owner.transfer(msg.value);
        emit TransactionOccurred(msg.sender, owner, msg.value);
    }

// function to get the details of the address that makes the donation
    function getDonorDetail(address _address) public view  returns (string memory name, uint8 age, uint256 amount) {
        donorDetail memory donorData = donor[_address];
        return (donorData.name, donorData.age, donorData.amount);
    }

// function to withdraw amount from the donation address to the admin address
    function withDrawAmount(address payable AdminAddress) public payable onlyOwner isAmountZero {
        AdminAddress.transfer(msg.value);
        emit TransactionOccurred(owner, AdminAddress, msg.value);
    }
}