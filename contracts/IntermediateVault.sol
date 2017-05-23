pragma solidity ^0.4.8;

/**
 * TODO
 *
 * Time-locked token vault of money being transferred into team multisig.
 *
 * Add 4 weeks delay to the transfer to the team multisig wallet.
 *
 * The owning party can reset the timer.
 *
 */
contract IntermediateVault  {

  /** Interface flag to determine if address is for a real contract or not */
  bool public isIntermediateVault = true;

  /** Address that can claim tokens */
  address public teamMultisig;

  /** UNIX timestamp when tokens can be claimed. */
  uint256 public unlockedAt;

  event Unlocked();
  event Paid(address sender, uint amount);

  function IntermediateVault(address _teamMultisig, uint _unlockedAt) {

    teamMultisig = _teamMultisig;
    unlockedAt = _unlockedAt;

    // Sanity check
    if (teamMultisig == 0x0) throw;
  }

  /// @notice Transfer locked tokens to Lunyr's multisig wallet
  function unlock() public {
    // Wait your turn!
    if (now < unlockedAt) throw;

    // StandardToken will throw in the case of transaction fails
    if(!teamMultisig.send(address(this).balance)) throw;

    Unlocked();
  }

  function () public payable {
    // Collect deposits from the crowdsale
    Paid(msg.sender, msg.value);
  }

}