pragma solidity ^0.4.19;

contract ConferenceTicketSale {
    struct ConferenceTicket {
        uint16 number;
        address owner;
    }
    
    address private organiser;
    uint public available;
    uint public price; // wei
    ConferenceTicket[] private tickets;
    
    constructor(uint _availableTickets, uint pricePerTicket) public {
        organiser = msg.sender;
        available = _availableTickets;
        price = pricePerTicket;
    }
    
    function purchaseTicket() public payable returns (uint16) {
        if (available > 0 && msg.sender.balance > price) {
            msg.sender.transfer(price); // Transfer ether to organiser
            return issueTicket();
        }
        return 0; // Conference sold out or insufficient balance in users account
    }

    function issueTicket() private returns (uint16) {
        uint16 ticketNumber = (uint16)(tickets.length) + 1;
        ConferenceTicket memory ticket = ConferenceTicket(
            {number: ticketNumber,owner: msg.sender});
        tickets.push(ticket);
        available--;
        return ticket.number;
    }

    function validateTicket(uint16 number, address ticketHolder) view public returns (bool) {
        for (uint i = 0; i < tickets.length; ++i) {
            if(tickets[i].number == number && tickets[i].owner == ticketHolder) {
                return true;
            }
        }
        return false;
    }

    function purchaseTickets(uint numberOfTickets) public payable
    returns (uint16 firstTicketNumber, uint16 lastTicketNumber) {
        uint total = price * numberOfTickets;
        
        if(numberOfTickets > 9) {
            total = total - (total / 100 * 10); // deduct 10%
        }
        
        if (available - numberOfTickets > 0 &&
            msg.sender.balance > total) {
            msg.sender.transfer(price); // Transfer ether to organiser

            for (uint i = 0; i < numberOfTickets; ++i) {
                uint16 ticketNumber = issueTicket();
                if(i == 0) {
                    firstTicketNumber = ticketNumber;
                }
                else {
                    lastTicketNumber = ticketNumber;
                }
            }
        }
    }
}
