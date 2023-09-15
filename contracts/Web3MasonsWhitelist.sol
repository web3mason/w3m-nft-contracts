// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

//2023-09/w3m-nft-contracts/node_modules/
contract Web3MasonsWhitelist is Ownable {
    using Address for address payable;

    uint256 public immutable MAX_SPOTS_FREE;
    uint256 public immutable MAX_SPOTS_PAID;

    uint256 public immutable BONUS;
    uint256 public immutable BONUS_MINT;

    uint256 public immutable STEP;

    uint256 public SPOTS_FREE;
    uint256 public SPOTS_PAID;

    struct AccountData {
        uint256 id;
        uint256 deposited;
        bool getTokens;
    }
    mapping(address => AccountData) private _accountData;
    address[] private _accounts;

    constructor() public {
        MAX_SPOTS_FREE = 100_000;
        MAX_SPOTS_PAID = 100_000;

        BONUS = 10_000 * 10 ** 18; // 10,000 W3M tokens
        BONUS_MINT = 1_000_000 * 10 ** 18; // 1,000,000 W3M tokens

        STEP = 0.01 ether;
    }

    function getAccountId(
        address account
    ) public view returns (uint256 accountId) {
        accountId = _accountData[account].id;
    }

    function joinFree() external {
        // isContract()
        // require(msg.sender == tx.orign)

        uint256 accountId = getAccountId(msg.sender);
        require(accountId == 0, "Already joined");
        _accounts.push(msg.sender);
        accountId = _accounts.length;
        _accountData[account].id = accountId;

        SPOTS_FREE++;
    }

    function join(bool getTokensAnyWay) external payable {
        // isContract()
        // require(msg.sender == tx.orign)

        uint256 accountId = getAccountId(msg.sender);
        if (accountId == 0) {
            _accounts.push(msg.sender);
            accountId = _accounts.length;
            _accountData[account].id = accountId;
            _accountData[account].getTokens = getTokensAnyWay;
            MAX_SPOTS_PAID++;
        } else if (accountId != 0 && _accountData[account].deposited == 0) {
            SPOTS_FREE--;
            MAX_SPOTS_PAID++;
            _accountData[account].getTokens = getTokensAnyWay;
        }

        _accountData[account].deposited += msg.value;
    }

    function mint() external {
        // signature
    }

    function withdraw() external {
        address payable receiver = payable(_msgSender());
        receiver.sendValue(_accountData[_msgSender()].deposited);
        _accountData[_msgSender()].deposited = 0;
    }
}
