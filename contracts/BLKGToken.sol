pragma solidity ^0.4.18;


import "./StandardToken.sol";
import "./SafeMath.sol";

contract BLKGToken is StandardToken {
    using SafeMath for uint256;

    // metadata
    string public constant name = "Blockagram Token";
    string public constant symbol = "BLKG";
    uint256 public constant decimals = 18;
    string public version = "1.0";

    uint256 public constant INITIAL_SUPPLY = 1500000000 * (10 ** uint256(decimals));

    // constructor
    function BLKGToken() public {
        totalSupply = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
    }
}