// BatchSend Master
// 1 to n send function
// @authors:
// Cody Burns <dontpanic@codywburns.com>
// license: Apache 2.0
// version:

pragma solidity ^0.4.19;

// Intended use: one party sending to mutiple parties. 
//
// Status: functional
// still needs:
// submit pr and issues to https://github.com/realcodywburns/
//version 0.1.0

contract replayblocked {

////////////////
//Global VARS//////////////////////////////////////////////////////////////////////////
//////////////
  
  //uncomment the chain deploying to  
  
   address ethaddress = 0xbaaffC2f4074863bf0ceD1dC61E5410fAD075ceC;    // eth
 //address ethaddress = 0x8EfCE6E8f95cF74340c8c836Fca8e16894490183;    // etc


/////////////
//MODIFIERS////////////////////////////////////////////////////////////////////
////////////

    modifier replayProtected() {
         require(ethaddress.balance > 0);
        _;
    }
}

contract batchsender is replayblocked {

///////////
//EVENTS////////////////////////////////////////////////////////////////////////////
//////////

    event NewTx(address indexed sender, uint indexed count);


//////////////
//Operations////////////////////////////////////////////////////////////////////////
//////////////

/* public functions */
    
function () public { assert(0>0);}

function multiSend(address[] recipients, uint[] amounts) public payable replayProtected {
    
    //test to see if the number of receivers equals the amounts
    require(recipients.length == amounts.length);
    
    //store the total amount sent for later
    uint totalAmount = msg.value;
    address multiSender = msg.sender;
    
    // cycle through the list of receivers and send them funds
    
    for (uint i = 0; i < recipients.length; i++){
        recipients[i].transfer(amounts[i]);
        totalAmount = totalAmount - amounts[i];
    }
    // send the excess back to the sender
    multiSender.transfer(totalAmount);
    
    NewTx(multiSender, amounts.length);
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
//        .   |           |         88    d8888888b 88 `888 88 88   ,  `"	.
//            |           |         88    88     8b 88  `88 88  T888P  88
/////////////////////////////////////////////////////////////////////////
