pragma solidity ^0.4.11;
contract timelock {

// global vars
    uint public releaseTime = 1496423100;       //stores the unix encoded timestamp of release


//mapping
    mapping (address => uint) public lockers;

//events
    event Locked(address indexed locker, uint indexed amount);
    event Released(address indexed locker, uint indexed amount);

//functions
    function() payable {
        lockers[msg.sender] += msg.value;
        Locked(msg.sender, msg.value);
    }

    function withdraw() {
        require (block.timestamp > releaseTime && lockers[msg.sender] > 0);
        uint value = lockers[msg.sender];
        lockers[msg.sender] = 0;
        msg.sender.transfer(value);
        Released(msg.sender, value);
    }

    function reset(uint _releaseTime) {
        require (block.timestamp > releaseTime);
        releaseTime = _releaseTime;
    }

// safety features


// abi and contract ipfs
    bool isLocked;
    string public ipfsAbi;
    string public ipfsContract;
    string public ipfsByte;

    function regipfs(string _ipfsAbi, string _ipfsContract, string _ipfsByte) {
        if(isLocked){throw;}
        isLocked=true;
        ipfsAbi = _ipfsAbi;
        ipfsContract = _ipfsContract;
        ipfsByte = _ipfsByte;
    }
}
