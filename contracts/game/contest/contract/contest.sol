pragma solidity ^0.4.11;

contract owned{
  function owned () {owner = msg.sender;}
  address owner;
  modifier onlyOwner {
          if (msg.sender != owner)
              throw;
          _;
      }
}

contract contest is owned{

//variables
  string public title;          // name of the event
  address public official;      // who gets the final say
  uint public endDate;          // timestamp when auction ends

  uint public voteCost;         // the cost to vote, goes to
  uint public submitCost;       // cost to make a submission

  uint submissionCount;         //  count the submissions
  address public winner;        //  declare the winners number

  address public charity;       // an address a portion of the winnings can go to
  uint public cPercent;         // how much of total to give to charity(whole number of percentage 20 = 20%)

 // open submissions+ address of submitter +link to the image+ count of votes
 struct submit {
   address payTo;string img; uint voteCount;
 }

//mapping
mapping (address => uint) balances;
mapping(uint => submit) contestList;


//events

event submitUpdate(string comment); // alert when a new submission arrives

//init state set who is the official, what the event is, and when it is over
  function setup(string _title, address _official, uint _hours, uint _voteCost, uint _submitCost, address _charity, uint _cPercent) onlyOwner{
        title = _title;
        official = _official;
        endDate = now + (_hours *3600) ;
        charity = _charity;
        cPercent = _cPercent;
        submitCost = _submitCost;
        voteCost = _voteCost;

    //zeroize the contrcat
        submissionCount = 0;
       }

//is the contest complete? The official needs to declare the winner and payout
  function winner() public {
    if(now < endDate){throw;}
    if(msg.sender == official){
        uint a = 0;
	uint b = 0;
	for (uint i = 0; i < submissionCount; ++i){
	b = a; //store old value
	a = max(a, contestList[i].voteCount);
	 if(a != b){winner = contestList[i].payTo;}
	}
        submitUpdate("The winner has been selected! Awaiting final approvial.");
    }

  }

  function finalWinner() public {
    if(now < endDate){throw;}
    if(msg.sender == official){
        payOut();
    }
  }

//payOut should only be called internally but may need to be called with other conditions in the future
  function payOut() internal {
    uint char = this.balance * (cPercent/100);
    if(charity.send(char)) balances[charity] = 0;
    if(winner.send(this.balance)) balances[winner] = 0;
  }


//Allow voting
  function vote(uint _voteFor) payable{
    if(msg.value < voteCost){throw;}             //reject votes less than the the vote cost
    contestList[_voteFor].voteCount += 1;       //nolist of donors is kept, dont screw this up official

  }

//new submission
  function submission(string _img) payable{
    if(msg.value < submitCost){throw;}             //reject submission less than the the submit cost
    uint id = submissionCount;
    submit s = contestList[id];
    s.payTo = msg.sender;
    s.img = _img;
    s.voteCount = 0;
    submissionCount ++;
  }


//outputs

//return address for id
function submitaddr(uint _id) constant returns(address){
	return contestList[_id].payTo;
}

//return link for id
function submitimg(uint _id) constant returns(string){
	return contestList[_id].img;
}


  function() { throw; }

  function max(uint a, uint b) private returns (uint) {
        return a > b ? a : b;
    }

 function kill() onlyOwner{
      selfdestruct(owner);
      //kills contract
  }
 }
