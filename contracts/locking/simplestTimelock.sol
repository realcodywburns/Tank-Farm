pragma solidity ^0.4.11;
// Simplest Time locking contract
// @authors:
// Cody Burns <dontpanic@codywburns.com>
// license: Apache 2.0

// usage:
// Set the time before you send the contract. any funds will be locked until that time.
// After the lock has expired any contract that sends to it will get all funds
// Status: functional
// still needs:
// submit pr and issues to https://github.com/realcodywburns/Tank-farm


contract simplestTimelock {

////////////////
//Global VARS//////////////////////////////////////////////////////////////////////////
///////////////

    uint public releaseTime = 1496423100;       //stores the unix encoded timestamp of release, nothing will be released until this time

////////////
//MAPPING/////////////////////////////////////////////////////////////////////////////
///////////


///////////
//EVENTS////////////////////////////////////////////////////////////////////////////
//////////

/////////////
//MODIFIERS////////////////////////////////////////////////////////////////////
////////////

//////////////
//Operations////////////////////////////////////////////////////////////////////////
//////////////

/* public functions */

    //when the lock has expired sending anything to the contract will get all funds sent to whom ever sends first
    function() payable {
        require (block.timestamp > releaseTime);
        msg.sender.transfer(this.balance);
    }

////////////
//SAFETY ////////////////////////////////////////////////////////////////////
//////////
// abi and contract ipfs
    bool isLocked;
    string public ipfsAbi;

    function regipfs(string _ipfsAbi) {
        if(isLocked){throw;}
        isLocked=true;
        ipfsAbi = _ipfsAbi;
    }
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
//            |           | 	      88    88     8b 88  `88 88  T888P  88
/////////////////////////////////////////////////////////////////////////
