pragma solidity ^0.8.10;

contract Tree {

    struct Message {
        address owner;
        string x;
        string y;
        string message;
    }

    string public constant UNAUTHORIZED = "019001";

    address public owner;
    mapping(address => Message[]) public addressToMessages;
    Message[] public messages;
    uint public currentMessageCount;

    string name;

    event MessageAdded(uint messageId, address indexed ownerAddress, Message message);
    event MessageDeleted(uint messageId, address ownerAddress);

    constructor(string memory _name){
        name = _name;
        currentMessageCount = 0;
        owner = msg.sender;
    }


    function addMessage(string memory x, string memory y, string memory message) public {
        Message memory _message;
        _message.owner = msg.sender;
        _message.x = x;
        _message.y = y;
        _message.message = message;
        messages.push(_message);
        addressToMessages[msg.sender].push(_message);

        currentMessageCount ++;

        emit MessageAdded(messages.length - 1, msg.sender, _message);
    }

    function deleteMessage(uint messageId) public onlyMessageOwner(messageId) {
        delete messages[messageId];
        delete addressToMessages[msg.sender][messageId];

        currentMessageCount --;

        emit MessageDeleted(messageId, msg.sender);
    }

    modifier onlyMessageOwner(uint messageId) {
        address messageOwner = messages[messageId].owner;
        require(msg.sender == messageOwner, UNAUTHORIZED);
        _;
    }


}