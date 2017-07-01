pragma solidity ^0.4.11;


// Disaster relief 
// crowd funding for specific events
// @authors:
// Cody Burns <dontpanic@codywburns.com>
// license: Apache 2.0

// usage:
// 
// This managing contract is a general purpose refund contract. Sponsors send money, beneficiries  can receive it after a set amount of time
// If the contrct is reversed payments can be returned to the sponsors
// 
// submit pr and issues to https://github.com/realcodywburns/tank-farm


contract owned{
  function owned () {owner = msg.sender;}
  address owner;
  modifier onlyOwner {
          if (msg.sender != owner)
              throw;
          _;
        }
  }

contract publicRefund is owned {
////////////////
//Global vars////////////////////////////////////////////////////////////////////////// 
//////////////
 /* administrative */

    uint public fundingGoal;
    uint public totalFunds;
    bool public paySponsors;
  
  struct bene {
	address oldAddr;
	uint amount;
	address newAddr;
	}

///////////
//MAPPING/////////////////////////////////////////////////////////////////////////////
///////////
    mapping (address => bytes32) paidOut;
    mapping (address => uint) sponsorPay;
   
///////////
//EVENTS////////////////////////////////////////////////////////////////////////////
//////////
  	event newDonation(address _newSpon, uint _amount);

//////////////
//Operations////////////////////////////////////////////////////////////////////////
//////////////

/* public functions */

// when someone sends funds, this logs thier information in case of future payback
  function () payable{
	address newSponsor = msg.sender;
	uint amount = msg.value; 
	sponsorPay[newSponsor] = sponsorPay[newSponsor] + amount;
	totalFunds += amount;
	newDonation(newSponsor, amount);
}

/* only owner */

//loads information into the contract about accounts
function load(address oldAddr, uint amount, bytes32 verification) onlyOwner{
            paidOut[oldAddr] = verification;
            fundingGoal += amount;
        }



////////////
//OUTPUTS///////////////////////////////////////////////////////////////////////
//////////

function testCode(address _oldAddress,uint _amount, address _withdrawlAddress) constant returns (bytes32){
    bytes32 _hash = sha3(_oldAddress, _amount,_withdrawlAddress);
    return _hash;
}		

function reversFlow() onlyOwner returns (bool) {
	if(paySponsors = true){paySponsors = false;
		}else{
	paySponsors = true;}
	return paySponsors;
}


/////////////
//MODIFIERS////////////////////////////////////////////////////////////////////
////////////

////////////
//SAFETY //
//////////

//reset

function reset() onlyOwner{
    fundingGoal = 0;
    totalFunds = 0 ;
    paySponsors = false;
}
//clean up after contract is no longer needed
  function killShot() public onlyOwner {selfdestruct(owner);}

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
//            |           | 	    88    88     8b 88  `88 88  T888P  88 
/////////////////////////////////////////////////////////////////////////                   _
