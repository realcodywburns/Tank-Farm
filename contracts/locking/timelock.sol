// Timelock
// lock withdrawal for a set time period
// @authors:
// Cody Burns <dontpanic@codywburns.com>
// license: Apache 2.0
// version:

pragma solidity ^0.4.11;

// Intended use: lock withdrawal for a set time period
//
// Status: functional
// still needs:
// submit pr and issues to https://github.com/realcodywburns/


contract timelock {

////////////////
//Global VARS//////////////////////////////////////////////////////////////////////////
//////////////
    uint public releaseTime = 1496423100;       //stores the unix encoded timestamp of release

///////////
//MAPPING/////////////////////////////////////////////////////////////////////////////
///////////

    mapping (address => uint) public lockers;

///////////
//EVENTS////////////////////////////////////////////////////////////////////////////
//////////

    event Locked(address indexed locker, uint indexed amount);
    event Released(address indexed locker, uint indexed amount);

/////////////
//MODIFIERS////////////////////////////////////////////////////////////////////
////////////

//////////////
//Operations////////////////////////////////////////////////////////////////////////
//////////////

/* public functions */
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
////////////
//OUTPUTS///////////////////////////////////////////////////////////////////////
//////////

////////////
//SAFETY ////////////////////////////////////////////////////////////////////
//////////

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
