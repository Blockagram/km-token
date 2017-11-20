pragma solidity ^0.4.18;
import "./StandardToken.sol";
import "./SafeMath.sol";

contract KMToken is StandardToken, SafeMath {

    // metadata
    string public constant NAME = "KoinMail Token";
    string public constant SYMBOL = "KM";
    uint256 public constant DECIMALS = 18;
    string public version = "1.0";

    // contracts
    address public ethFundDeposit;  // deposit address for ETH for KoinMail
    address public kmFundDeposit;  // deposit address for KoinMail use and KM User Fund

    // crowdsale parameters
    bool public isFinalized;  // switched to true in operational state
    uint256 public fundingStartBlock;
    uint256 public fundingEndBlock;
    uint256 public constant KM_FUND = 900 * (10**6) * 10**DECIMALS;  // 900m KM reserved for KoinMail use (60%)
    uint256 public constant TOKEN_EXHANGE_RATE = 4000;  // 4000 KM tokens per 1 ETH (approx US$0.10 per KM at time of initialization)
    uint256 public constant TOKEN_CREATION_CAP = 1500 * (10**6) * 10**DECIMALS;
    uint256 public constant TOKEN_CREATION_MIN = 1000 * (10**6) * 10**DECIMALS;


    // events
    event LogRefund(address indexed _to, uint256 _value);
    event CreateKM(address indexed _to, uint256 _value);

    // constructor
    function KMToken(
        address _ethFundDeposit,
        address _kmFundDeposit,
        uint256 _fundingStartBlock,
        uint256 _fundingEndBlock) public
    {
      isFinalized = false;  //controls pre through crowdsale state
      ethFundDeposit = _ethFundDeposit;
      kmFundDeposit = _kmFundDeposit;
      fundingStartBlock = _fundingStartBlock;
      fundingEndBlock = _fundingEndBlock;
      totalSupply = KM_FUND;
      balances[kmFundDeposit] = KM_FUND;  // Deposit KoinMail share
      CreateKM(kmFundDeposit, KM_FUND);  // logs KoinMail fund
    }

    /// @dev Accepts ether and creates new KM tokens.
    function createTokens() payable external {
      if (isFinalized) {
        revert();
      }
      if (block.number < fundingStartBlock) {
          revert();
      }
      if (block.number > fundingEndBlock) {
          revert();
      }
      if (msg.value == 0) {
          revert();
      }

      uint256 tokens = safeMult(msg.value, TOKEN_EXHANGE_RATE);  // check that we're not over totals
      uint256 checkedSupply = safeAdd(totalSupply, tokens);

      // return money if something goes wrong
      if (TOKEN_CREATION_CAP < checkedSupply) {
          revert();  // odd fractions won't be found
      }

      totalSupply = checkedSupply;
      balances[msg.sender] += tokens;  // safeAdd not needed; bad semantics to use here
      CreateKM(msg.sender, tokens);  // logs token creation
    }

    /// @dev Ends the funding period and sends the ETH home
    function finalize() external {
      if (isFinalized) {
          revert();
      }
      if (msg.sender != ethFundDeposit) {  // locks finalize to the ultimate ETH owner
          revert();
      }
      if (totalSupply < TOKEN_CREATION_MIN) {  // have to sell minimum to move to operational
          revert();
      }
      if (block.number <= fundingEndBlock && totalSupply != TOKEN_CREATION_CAP) {
          revert();
      }
      // move to operational
      isFinalized = true;
      if (!ethFundDeposit.send(this.balance)) {  // send the eth to KoinMail
          revert();
      }
    }

    /// @dev Allows contributors to recover their ether in the case of a failed funding campaign.
    function refund() external {
      if (isFinalized) {  // prevents refund if operational
          revert();
      }
      if (block.number <= fundingEndBlock) {  // prevents refund until sale period is over
        revert();
      }
      if (totalSupply >= TOKEN_CREATION_MIN) {  // no refunds if we sold enough
        revert();
      }
      if (msg.sender == kmFundDeposit) {  // KoinMail not entitled to a refund
        revert();
      }
      uint256 kmVal = balances[msg.sender];
      if (kmVal == 0) {
          revert();
      }
      balances[msg.sender] = 0;
      totalSupply = safeSubtract(totalSupply, kmVal);  // extra safe
      uint256 ethVal = kmVal / TOKEN_EXHANGE_RATE;  // should be safe; previous throws covers edges
      LogRefund(msg.sender, ethVal);  // log it
      if (!msg.sender.send(ethVal)) {  // if you're using a contract; make sure it works with .send gas limits
          revert();
      }
    }

}