pragma solidity ^0.4.11;
// Mining forward contract
// Timelocked transferable mining contract, to be filled over time and payout to current owner
// @authors:
// Cody Burns <dontpanic@codywburns.com>
// license: Apache 2.0

// usage:
// A miner deploys the contract and updates the pool information(a url to the pool account) and a list price
// A buyer pays the list price and becomes owner
// the owner can relist or wait until maturity and withdraw

contract minelock {

////////////////
//Global VARS//////////////////////////////////////////////////////////////////////////
//////////////

    uint public deliveryDate;                    // stores the unix encoded timestamp of release
    uint public termOfTrade;                     // final contract goal
    bool public metToT;                         // did contract close
    uint public listPrice;                      // allow for dynamic pricing
    address public owner = msg.sender;          // person who is currently able to withdraw
    address public sponsor = msg.sender;        // person who is putting reputation on the line
    string public pool;                         // pool url the contract can be viewed at
    string public version = "v0.2.1";           // version

///////////
//MAPPING/////////////////////////////////////////////////////////////////////////////
///////////


///////////
//EVENTS////////////////////////////////////////////////////////////////////////////
//////////
    event Funded(address indexed locker, uint indexed amount);      // announce when new funds arrive
    event Released(address indexed locker, uint indexed amount);    // announce when minelock pays out
    event Priced(uint latestPrice);                                 // announce when the price changes
    event Pooled(string newPoolLink);                               // announce when the sponsor changes pools

/////////////
//MODIFIERS////////////////////////////////////////////////////////////////////
////////////

    modifier onlyOwner {if (msg.sender != owner) throw; _; }        // things only the current owner can do
    modifier onlySponsor {if (msg.sender != sponsor) throw; _; }    // things only the sponsor can do

//////////////
//Operations////////////////////////////////////////////////////////////////////////
//////////////

/* init */
  function minelock(uint _deliveryDate, uint _termsOfTrade, uint _listPrice, string _pool){
   deliveryDate = _deliveryDate;
   termOfTrade = _termsOfTrade;
   listPrice = _listPrice;
   pool = _pool;
  }


/* public */

    //payable
    function() payable {                                            // allow for funding
    Funded(msg.sender, msg.value);
    if(this.balance + msg.value > termOfTrade){       // stop accepting funds after contract is at the term of trade
       sponsor.transfer(msg.value);
       }
    }

    function trade() payable{                                       //allow the contract to be owner traded
        if(msg.value < listPrice){throw;}
        uint value = msg.value;
        uint returned = value - listPrice;
                                                //assign a new owner
        owner.transfer(value);                                      //buy out the previous owner
        value = 0;
        msg.sender.transfer(returned);                              //returns any excess funds to sender
        owner = msg.sender;
    }

/* only owner */
    function withdraw() onlyOwner{                                  // owner (person who paid the list price last) can withdraw after maturity
        if(block.timestamp < deliveryDate){throw;}
        if(this.balance>= termOfTrade){metToT = true;}
        msg.sender.transfer(this.balance);
        }

        //allows for dynamic pricing
    function setPrice(uint _newPrice) onlyOwner{                    // owner can change list price to find a buyer
        listPrice = _newPrice;
        Priced(listPrice);
    }

/* admin/group functions */

//allow sponsor to update the pool website. This is a string that represents the url to view the current hashrate of the mining contract. A "blind" forward is possible if this is blank
    function newPool(string _newPool) onlySponsor{
        pool = _newPool;
        Pooled(pool);
    }

////////////
//OUTPUTS///////////////////////////////////////////////////////////////////////
//////////

////////////
//SAFETY ////////////////////////////////////////////////////////////////////
//////////

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
  //        .   |           |	        88    d8888888b 88 `888 88 88   ,  `"
  //            |           | 	      88    88     8b 88  `88 88  T888P  88
  /////////////////////////////////////////////////////////////////////////
