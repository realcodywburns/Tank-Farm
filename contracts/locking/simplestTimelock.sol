pragma solidity ^0.4.11;
// Simplest Time locking contract
// @authors:
// Cody Burns <dontpanic@codywburns.com>
// license: Apache 2.0

// usage:
// Set the time before you send the contract. any funds will be locked until that time.
// After the lock has expired any contract that sends to it will get all funds



contract simplestTimelock {

// global vars
    uint public releaseTime = 1496423100;       //stores the unix encoded timestamp of release, nothing will be released until this time
//mapping

//events

//functions

    //when the lock has expired sending anything to the contract will get all funds sent to whom ever sends first
    function() payable {
        require (block.timestamp > releaseTime);
        msg.sender.transfer(this.balance);
    }

// safety features

// abi and contract ipfs
    bool isLocked;
    string public ipfsAbi;

    function regipfs(string _ipfsAbi) {
        if(isLocked){throw;}
        isLocked=true;
        ipfsAbi = _ipfsAbi;
    }
}
