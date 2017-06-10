pragma solidity ^0.4.11;


// pricing a contract
// @authors:
// Cody Burns <dontpanic@codywburns.com>
// license: Apache 2.0

// usage:
// requires: a price. reject if below price

contract priced {
    modifier costs(uint price) {
        if (msg.value >= price) {
            _;
        }
    }
}
