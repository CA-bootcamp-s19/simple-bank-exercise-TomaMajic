pragma solidity ^0.5.0;

contract SimpleBank {

    //
    // State variables
    //

    mapping (address => uint) private balances;
    mapping (address => bool) public enrolled;
    address public owner;

    //
    // Events - publicize actions to external listeners
    //

    event LogEnrolled(address accountAddress);
    event LogDepositMade(address indexed accountAddress, uint amount);
    event LogWithdrawal(address indexed accountAddress, uint withdrawAmount, uint newBalance);

    //
    // Functions
    //

    constructor() public {
        owner = msg.sender;
    }

    function() external payable {
        revert();
    }

    /// @notice Get balance
    /// @return The balance of the user
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    function enroll() public returns (bool){
        if(enrolled[msg.sender]) {
            return false;
        } else {
            enrolled[msg.sender] = true;
            emit LogEnrolled(msg.sender);
            return true;
        }
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    function deposit() public payable returns (uint) {
        /* Add the amount to the user's balance, call the event associated with a deposit,
          then return the balance of the user */
        uint balance = balances[msg.sender];
        uint newBalance = balance + msg.value;
        balances[msg.sender] = newBalance;
        emit LogDepositMade(msg.sender, newBalance);
        return newBalance;
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param _withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    function withdraw(uint _withdrawAmount) public returns (uint) {
        uint balance = balances[msg.sender];
        require(balance >= _withdrawAmount);

        uint newBalance = balance - _withdrawAmount;
        msg.sender.transfer(_withdrawAmount);
        balances[msg.sender] = newBalance;
        emit LogWithdrawal(msg.sender, _withdrawAmount, newBalance);
        return newBalance;
    }
}
