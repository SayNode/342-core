pragma solidity ^0.8.10;

import "./Tree.sol";

contract TreeFactory {

    string public constant UNAUTHORIZED = "019001";

    address public owner;

    mapping(address => Tree[]) public treeOwners;
    mapping(address => bool) whitelist;

    Tree[] public trees;

    event TreeCreated(address indexed owner, address indexed treeAddress);
    event AddedToWhitelist(address indexed account);
    event RemovedFromWhitelist(address indexed account);


    constructor() {
        owner = msg.sender;
        whitelist[msg.sender] = true;
    }


    function createTree(string memory name) public  onlyWhitelisted {
        Tree tree = new Tree(name);
        treeOwners[msg.sender].push(tree);
        trees.push(tree);

        emit TreeCreated(msg.sender, address(tree));
    }




    /* WHITELIST */

    function add(address _address) public onlyOwner {
        whitelist[_address] = true;
        emit AddedToWhitelist(_address);
    }

    function remove(address _address) public onlyOwner {
        whitelist[_address] = false;
        emit RemovedFromWhitelist(_address);
    }

    function isWhitelisted(address _address) public view returns(bool) {
        return whitelist[_address];
    }

    modifier onlyWhitelisted() {
        require(isWhitelisted(msg.sender));
        _;
    }

    modifier onlyOwner() {
        require (msg.sender == owner, UNAUTHORIZED);
        _;
    }







}