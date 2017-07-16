// simple faucet
//
// @authors:
// Cody Burns <dontpanic@codywburns.com>
// license: Apache 2.0
// version: 0.1.0
// deployed at: 0xae9b1CfCEC5F1d45a9a87E0B63AC5ABb59565433
pragma solidity ^0.4.10;

// Intended use:
// Sends a small amount of ether to whomever calls the default function
// Status: functional
// still needs:
// submit pr and issues to https://github.com/realcodywburns/tank-Farm

contract owned{
  function owned () {owner = msg.sender;}
  address owner;
  modifier onlyOwner {
          if (msg.sender != owner)
              throw;
          _;
          }
  }

contract faucet is owned{

////////////////
//Global VARS//////////////////////////////////////////////////////////////////////////
//////////////

/* int */

    uint public lastDrip;
    uint public dripRate;
    uint public dropValue;
    uint public runningCount;
    uint public nextPayout;

///////////
//MAPPING/////////////////////////////////////////////////////////////////////////////
///////////


///////////
//EVENTS////////////////////////////////////////////////////////////////////////////
//////////

    event Payouts(address rewarded, uint drip);
    event DripSet(uint dripset);
    event Donation(address coolperson, uint paid);

/////////////
//MODIFIERS////////////////////////////////////////////////////////////////////
////////////

//////////////
//Operations////////////////////////////////////////////////////////////////////////
//////////////
/* init */
function faucet(uint _dropValue, uint _dripRate){
    dropValue = _dropValue;
    dripRate = _dripRate;
    runningCount = 0;
    lastDrip = block.number;
}

/* public */
function () payable{
    Donation(msg.sender, msg.value);
}

function getETC(){
    require(block.number-lastDrip >= dripRate);
    lastDrip = block.number; // prevent any more withdrawls
    msg.sender.transfer(dropValue);
    runningCount += dropValue;
    nextPayout = lastDrip + dripRate;
    Payouts(msg.sender, dropValue);    
    }

/* onlyOwner */

function dripSet (uint _dropValue, uint _dripRate) onlyOwner{
    dropValue = _dropValue;
    dripRate = _dripRate;
    DripSet(dropValue);
}
////////////
//OUTPUTS///////////////////////////////////////////////////////////////////////
//////////

/* public */

////////////
//SAFETY ////////////////////////////////////////////////////////////////////
//////////
//safety switches consider removing for production
//clean up after contract is no longer needed

function killshot() onlyOwner {selfdestruct(owner);}
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
//        .   |           |         88    d8888888b 88 `888 88 88   ,  `"	.
//            |           |         88    88     8b 88  `88 88  T888P  88
/////////////////////////////////////////////////////////////////////////
