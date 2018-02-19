pragma solidity ^0.4.18;

contract Lottery {

    mapping (address => uint256) public winnings;
    address[] public tickets;

    string public name = "Lottery";
    string public symbol = "LOT";
    uint256 public maxTickets = 100;
    uint256 public remainingTickets = 0;
    uint public ticketCount = 0;
    uint256 public randomNum = 0;
    address public latestWinner;

    function Lottery(string tokenName, string tokenSymbol, uint256 maximumTickets) public payable {

        name = tokenName;
        symbol = tokenSymbol;
        maxTickets = maximumTickets;
        remainingTickets = maxTickets;

    }

    function Buy() public payable {

        //require(balanceOf[msg.sender] + val >= balanceOf[msg.sender]); // Check for overflows
        uint256 val = msg.value / 1000000000000000;

        require(remainingTickets - val <= remainingTickets);
        remainingTickets -= val; // Remove from unspent supply

        for (uint i = 0; i < val; i++) {
            tickets.push(msg.sender);
            ticketCount++;
        }

        //balanceOf[msg.sender] += val; // Add the same to the recipient

    }

    function Withdraw() public {

        require(winnings[msg.sender] > 0);

        uint256 amountToWithdraw = winnings[msg.sender];

        winnings[msg.sender] = 0;

        // Converted into Wei
        amountToWithdraw *= 1000000000000000;

        // Transfered in Wei
        msg.sender.transfer(amountToWithdraw);

    }

    function chooseWinner() public {

        if (ticketCount > 0) {
            randomNum = uint(block.blockhash(block.number-1)) % ticketCount;
        }

        latestWinner = tickets[randomNum];

        winnings[latestWinner] = ticketCount;
        ticketCount = 0;
        remainingTickets = maxTickets;

        delete tickets;


    }

}
