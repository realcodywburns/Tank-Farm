pragma solidity ^0.4.18;

// Hash lock Box
//
// @authors:
// Cody Burns <dontpanic@codywburns.com>
// license: Apache 2.0
// version: 0.1.0


// Intended use:
// Holds ether and only lets it out when it gets the preimage. use once and destroy
// Status: functional
// still needs:
// submit pr and issues to https://github.com/realcodywburns/


contract HashLock {

////////////////
//Global VARS//////////////////////////////////////////////////////////////////////////
//////////////


    bytes32 public  hashLock = 0x760a6ca4365c18feb18b068adf7eb26e8f2d0ecbf97e0827c5bc171cd88ed4a0;
  
//////////////
//Operations////////////////////////////////////////////////////////////////////////
//////////////

/* public functions */
    

    function claim(string _WhatIsTheMagicKey) public {
        require(sha256(_WhatIsTheMagicKey) == hashLock);
        selfdestruct(msg.sender);
    }

    function () payable public{}
    
}

/////////////////////////////////////////////////////////////////////////////
// 88888b   d888b  88b  88 8 888888         _.-----._
// 88   88 88   88 888b 88 P   88   \)|)_ ,'         `. _))|)
// 88   88 88   88 88`8b88     88    );-'/             \`-:(
// 88   88 88   88 88 `888     88   //  :               :  \\   .
// 88888P   T888P  88  `88     88  //_,'; ,.         ,. |___\\
//    .           __,...,--.       `---':(  `-.___.-'  );----'
//              ,' :    |   \            \`. `'-'-'' ,'/
//             :   |    ;   ::            `.`-.,-.-.','
//     |    ,-.|   :  _//`. ;|              ``---\` :
//   -(o)- (   \ .- \  `._// |    *               `.'       *
//     |   |\   :   : _ |.-  :              .        .
//     .   :\: -:  _|\_||  .-(    _..----..
//         :_:  _\\_`.--'  _  \,-'      __ \
//         .` \\_,)--'/ .'    (      ..'--`'          ,-.
//         |.- `-'.-               ,'                (///)
//         :  ,'     .            ;             *     `-'
//   *     :         :           /
//          \      ,'         _,'   88888b   888    88b  88 88  d888b  88
//           `._       `-  ,-'      88   88 88 88   888b 88 88 88   `  88
//            : `--..     :        *88888P 88   88  88`8b88 88 88      88
//        .   |           |	        88    d8888888b 88 `888 88 88   ,  `"	.
//            |           |        88    88     8b 88  `88 88  T888P  88
/////////////////////////////////////////////////////////////////////////
