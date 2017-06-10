pragma solidity ^0.4.11;


// owned
// allow for owner
// @authors:
// Cody Burns <dontpanic@codywburns.com>
// license: Apache 2.0

// usage:
// assigns owner and only allows them to call the function 

contract owned{
  function owned () {owner = msg.sender;}
  address owner;
  modifier onlyOwner {
          if (msg.sender != owner)
              throw;
          _;
          }
  }
