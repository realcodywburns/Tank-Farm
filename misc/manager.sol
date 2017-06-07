pragma solidity ^0.4.11;


// Managed registery
// a registery for tracking items that an admin can prune as required
// @authors:
// Cody Burns <dontpanic@codywburns.com>
// license: Apache 2.0

// usage:
// NOT PRODUCTION READY! DO NOT USE THIS FOR REAL WORLD YET! (or do it wroks okay)
// This managing contract is a general purpose token. Users can register the token address, symbol. decimal, type, and icon location(url for a set fee)
// It needs an owner, should be able to register with a category contract, and handle comments, and allow for some data to be hidden unless paid for(in the future)


contract owned{
  function owned () {owner = msg.sender;}
  address owner;
  modifier onlyOwner {
          if (msg.sender != owner)
              throw;
          _;
          }
  }
contract priced {
    // Modifiers can receive arguments:
    modifier costs(uint price) {
        if (msg.value >= price) {
            _;
        }
    }
}

contract smartmanager is priced, owned {

//Global vars

  string public nameTag;                // public contract name
  uint aCount;                          // running account check
  uint public pendingReturns;           //  returns for
  uint public adminCount;               // check count of admins
  uint public price;                    // the cost of each ticket is n ether.

  struct admin {
    address adminAddr;
    string aName;
   }

   struct token{
      address tAddr;
      string tName;
      string tSymbol;
      uint tDecimal;
      string tType;
      string tIcon;
      uint tGas;
      uint dateChanged;
      address changedBy;
      string changeReason;
    }

//mapping
  mapping(uint => token) tokens;
  mapping(uint => admin) adminList;

//events
  event newCommit(address newUser);
  event newToken(string );

// functions


function register(address _tAddr, string _tName, string _tSymbol, uint _tDecimal, string _tType, string _tIcon, uint _tGas) public payable costs(price){
    uint id = aCount++;
    token t = tokens[id];
    t.tAddr = _tAddr;
    t.tName = _tName;
    t.tSymbol = _tSymbol;
    t.tDecimal = _tDecimal;
    t.tType =  _tType;
    t.tIcon = _tIcon;
    t.tGas = _tGas;
    t.dateChanged = now;
    pendingReturns += msg.value;
}


// only owner

function withdraw() onlyOwner returns (bool) {
    var amount = pendingReturns;
    if (amount > 0) {
      pendingReturns = 0;
      if (!msg.sender.send(amount)) {
            pendingReturns = amount;
            return false;
        }
    }
    return true;
  }

function modAdmin(address _admin, uint _action, uint _index) onlyOwner{
//options are 1 add, 2 del, 3 mod
    if (_action == 1){
      uint id = adminCount++;
      adminList[id].adminAddr = _admin;
    }
    if (_action == 2){
      delete adminList[_index].adminAddr;
      adminCount = adminCount -1;
    }
    if (_action == 3){
      adminList[_index].adminAddr = _admin;
    }
  }

// admin management
  //manage the list in case something goes wrong (1)add (2)delete (3)change (4) ticketPrice (5) change the nametag

function modCategory(uint _index, uint _action,address _tAddr, string _tName, string _tSymbol, uint _tDecimal, string _tType, string _tIcon, uint _tGas, string _reason, uint _reprice, string _newName) {

//check to see if the sender is an approved admin
  uint adminCheck = 0;
  for(uint i; i < adminCount; i ++){
    if (msg.sender == adminList[i].adminAddr){
      adminCheck = 1;
    }
  if (adminCheck != 1){
    throw;
  }
}
//this is the function adds contracts from the list for free
     if (_action == 1){
       uint id = aCount++;
       token t = tokens[id];
       t.tAddr = _tAddr;
       t.tName = _tName;
       t.tSymbol = _tSymbol;
       t.tDecimal = _tDecimal;
       t.tType =  _tType;
       t.tIcon = _tIcon;
       t.tGas = _tGas;
       t.dateChanged = now;
       t.dateChanged = now;
       t.changedBy = msg.sender;
       }

//this is the function removes contracts from the list
     if (_action == 2){
       aCount = aCount-1;
       t = tokens[_index];
       delete t.tAddr;
       delete t.tName;
       delete t.tSymbol;
       delete t.tDecimal;
       delete t.tType;
       delete t.tIcon;
       delete t.tGas;
       delete t.dateChanged;
        t.dateChanged = now;
        t.changedBy = msg.sender;
       }

//this is the function allows to change a specific field in a contract from the list
     if (_action == 3){
      t = tokens[_index];
      t.tAddr = _tAddr;
      t.dateChanged = now;
      t.changedBy = msg.sender;
      t.changeReason = _reason;
      }

//this is the function sets the listing price
    if (_action == 4){
      price = _reprice;
    }

//this is the function labels the Manager contract
    if (_action == 5){
      nameTag = _newName;
    }
}



//Outputs

function Count() constant returns (uint){
return aCount;
}
function aList(uint _index) constant returns (address){
  return tokens[_index].tAddr;
  }
function returnCheck() constant returns (uint){
  return pendingReturns;
}
function ownerCheck() constant returns(address){
  return owner;
}


//safety switches consider removing for production
//clean up after contract is no longer needed

function kill() public onlyOwner {selfdestruct(owner);}

}
