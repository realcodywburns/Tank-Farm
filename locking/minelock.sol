contract minelock {
    
// global vars
    uint public releaseTime = 1496423100;   //stores the unix encoded timestamp of release 
    uint public listPrice;                  //allow for dynamic pricing
    address public owner = msg.sender;      // person who is currently able to withdraw
    address public sponsor = msg.sender;    // person who is putting reputation on the line
    string public pool;                     // pool url the contract can be viewed at 
    string version = "v0.0.1";              //version
//mapping    

//events
    event Funded(address indexed locker, uint indexed amount);      // announce when new funds arrive
    event Released(address indexed locker, uint indexed amount);    // announce when minelock pays out
    event Priced(uint latestPrice);                                 // announce when the price changes
    event Pooled(string newPoolLink);                               // announce when the sponsor changes pools
    
//modifiers
    modifier onlyOwner {if (msg.sender != owner) throw; _; }        // things only the current owner can do
    modifier onlySponsor {if (msg.sender != sponsor) throw; _; }    // things only the sponsor can do

//functions    
    
    //payable
    function() payable {Funded(msg.sender, msg.value);}             // allow for funding
    
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
    
    //only Owner
    function withdraw() onlyOwner{                                  // owner can withdraw after maturity
        require (block.timestamp > releaseTime);
        msg.sender.transfer(this.balance);
        }
    
        //allows for dynamic pricing
    function setPrice(uint _newPrice) onlyOwner{                    // owner can change list price
        listPrice = _newPrice;
        Priced(listPrice);
    }
    
    //only Sponsor
                                                    //allow sponsor to update the pool website
    function newPool(string _newPool) onlySponsor{
        pool = _newPool;
        Pooled(pool);                   
    }
            
    

// safety features - remove for production -
    
    //allow for reloading during testing
    function reset(uint _releaseTime) {
        require (block.timestamp > releaseTime);
        releaseTime = _releaseTime;
    }
    
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
