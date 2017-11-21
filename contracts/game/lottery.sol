pragma solidity ^0.4.18;

// Simple Lottery
//
// @authors:
// Cody Burns <dontpanic@codywburns.com>
// license: Apache 2.0
// version: 0.1.0


// Intended use:
// lottery that also pays charity 
// Status: functional
// still needs:
// submit pr and issues to https://github.com/realcodywburns/


contract Lottery {

////////////////
//Global VARS//////////////////////////////////////////////////////////////////////////
//////////////

/* administrative information */

/* Booleans */
    bool public lotteryEnded;
    bool public ownerSet = false; // start out w owner not set
/* Integers */
    uint public ticketsIssued;
    uint public contractBalance;
    uint public lotteryStart;         //latest start date
    uint8 public lotteryDuration;     // in hours
    uint8 public nextLotteryDuration; // in hours
    uint public totalETCWon;          // just for fun
    
    uint8 public charityAmount; // as a percentage
    uint public charityBalance;
    
/* Address */
    address public winner;
    address public charity;
    address public owner;

/* Arrays */
    address[] public hodlers;
    address[] public prevWinners;
    

/* Strings */
/* STRUCTS/ENUMS */
  
    struct TicketHolder {
        address _holderAddress;
        uint _numTickets;
    }

///////////
//MAPPING/////////////////////////////////////////////////////////////////////////////
///////////
    
    mapping (address => uint) ticketHolders;    
    
///////////
//EVENTS////////////////////////////////////////////////////////////////////////////
//////////
    event TicketsBought(address indexed _from, uint _quantity);
    event AwardWinnings(address _to, uint _winnings);
    event CharityPayout(address _to, uint _payout);
    event ResetLottery();

/////////////
//MODIFIERS////////////////////////////////////////////////////////////////////
////////////

    modifier lotteryOngoing() {
        require(now < lotteryStart + lotteryDuration);
        _;
    }

    // Checks if lottery has finished
    modifier lotteryFinished() {
        require(now > lotteryStart + lotteryDuration);
        _;
    }
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
//////////////
//Operations////////////////////////////////////////////////////////////////////////
//////////////

/* public functions */
    function init() public {
        require (ownerSet == false);
        ownerSet = true;
        nextLotteryDuration = 1;
        owner = msg.sender;
        resetLottery();
    }
    
    function () payable public {
        buyTickets();
    }
    
    function buyTickets() payable lotteryOngoing public returns (bool success) {
        ticketHolders[msg.sender] = msg.value / (10**15);
        ticketsIssued += ticketHolders[msg.sender];
        hodlers.push(msg.sender);
        uint tempBalance = msg.value;
        charityBalance +=  tempBalance * (charityAmount / 100);
        contractBalance += tempBalance - charityBalance;
        TicketsBought(msg.sender, ticketHolders[msg.sender]);
        return true;
    }
    
    //Generate the winners by random using tickets bought as weight
    function generateWinners() lotteryFinished public returns (uint winningTicket) {
        uint randNum = uint(block.blockhash(block.number - 1)) % ticketsIssued + 1;
        winner = hodlers[randNum];
        prevWinners.push(winner);
        awardCharity();
        awardWinnings(winner);
        return randNum;
    }


/* admin/group/internal functions */

    
    function awardCharity() internal returns (bool success) {
        charity.transfer(charityBalance);
        CharityPayout(charity, charityBalance);
        charityBalance = 0;
        return true;
    }
    
    function awardWinnings(address _winner) internal returns (bool success) {
        _winner.transfer(contractBalance);
        AwardWinnings(_winner, contractBalance);
        contractBalance = 0;
        resetLottery();
        return true;
    }

    function resetLottery() lotteryFinished internal returns (bool success) {
        lotteryEnded = false;
        lotteryStart = now;
        ticketsIssued = 0;
        lotteryDuration = nextLotteryDuration;
        ResetLottery();
        return true;
    }
    
/* only owner */

    function setCharity(address _charity) onlyOwner public {
     charity = _charity;
    }
    function setDuration(uint8 _newTime) onlyOwner public {
        nextLotteryDuration = _newTime;
    }
    
    function changeOwner(address _newOwner) onlyOwner public {
        owner = _newOwner;
    }
    
////////////
//OUTPUTS///////////////////////////////////////////////////////////////////////
//////////

/* public */

    function getTicketBalance(address _account) constant public returns (uint balance) {
        return ticketHolders[_account];
    }

/* admin/group functions */

/* only owner */

////////////
//SAFETY ////////////////////////////////////////////////////////////////////
//////////
//safety switches consider removing for production
//clean up after contract is no longer needed

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
