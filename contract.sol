//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.15;
contract Eventcontract{
    struct Event{
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
    }
    mapping(uint=>Event) public events;
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public nextID;
    function createEvent(string memory _name , uint _date , uint _price , uint _ticketCount) external {
        require(_date>block.timestamp,"You can organize event for future");
        require(_ticketCount>0,"You can organize event when you have ticketcount more than 0 ");
        events[nextID]=Event(msg.sender,_name , _date , _price , _ticketCount,_ticketCount);
        nextID++;
    }
    function buyTicket(uint id , uint quantity) external payable
    {
        require(events[id].date!=0,"Event not exist");
        require(block.timestamp<events[id].date,"Event does not exist");
        require(msg.value>=((events[id].price)*quantity),"Ethers are not enough");
        require(events[id].ticketRemain>=quantity,"No enough tickets");
        events[id].ticketRemain=events[id].ticketRemain-quantity;
        tickets[msg.sender][id]+=quantity;
        


    }
    function transferTicket(uint id , uint quantity , address to) external
    {
        require(events[id].date!=0,"Event not exist");
        require(block.timestamp<events[id].date,"Event does not exist");
        require(tickets[msg.sender][id]>=quantity,"You do not have enough ticket");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;

    } 
}
