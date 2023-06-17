// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/extensions/ERC4626.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract Vault is ERC4626 {
    // Deprecate: remove the vUSDT contract (20230617 - tzuhan)
    // Info: create your variables and immutables (20230615 - tzuhan)
    // ERC20 private immutable _vUSDT;

    IERC20 public usdt;

    // Deprecate: 不需要 mapping 持有 vUSDT 我們直接認定他持有 shares 即可 (20230617 - tzuhan)
    // Info: a mapping that checks if a user has deposited (20230615 - tzuhan)
    // mapping(address => uint256) public shareHolder;

    // Info: call_code to the ERC20 contract (要使用別人的智能合約的話只要知道 interface 及 contract address 即可) (20230616 - tzuhan)
    constructor(address _usdtAddress, string memory _name, string memory _symbol)
        ERC4626(IERC20(_usdtAddress))
        ERC20(_name, _symbol)
    {
        usdt = IERC20(_usdtAddress);
    }

    // Info: returns total number of assets (20230615 - tzuhan)
    function totalAssets() public view override returns (uint256) {

        return usdt.balanceOf(address(this));
    }

    // Info: returns total balance of user (20230615 - tzuhan)
    function totalAssetsOfUser(address _user) public view returns (uint256) {
        return usdt.balanceOf(_user);
    }

    function totalShares() public view returns (uint256) {
        return this.balanceOf(address(this));
    }

    function totalSharesOfUser(address _user) public view returns (uint256) {
        return this.balanceOf(_user);
    }

    // Info: a deposit function that receives assets from users (20230615 - tzuhan)
    function deposit(uint256 assets) public {
        // Info: checks that the deposit is higher than 0 (20230615 - tzuhan)
        require(assets > 0, "Deposit less than Zero");

        usdt.transferFrom(msg.sender, address(this), assets);

        uint256 shares = assets;

        _mint(msg.sender, shares);

        emit Deposit(msg.sender, msg.sender, assets, shares);
    }

    // Info: users to return shares and get thier token back before they can withdraw, and requires that the user has a deposit (20230615 - tzuhan)
    function _redeem(uint256 shares) internal returns (uint256 assets) {
        uint256 haveShares = totalSharesOfUser(msg.sender);
        require(haveShares > 0, "Not a share holder");
        require(haveShares >= shares, "Have less shares than required");

        // Info: can give a user a percentage of the total assets as a reward for returning their shares (20230615 - tzuhan)
        /**
         * Info: disabled for now (20230615 - tzuhan)
         *      uint256 percetange =  (10 * shares) / 100;
         */

        _burn(msg.sender, shares);

        assets = shares; // + percetange; // Info: disabled for now (20230615 - tzuhan)

        emit Withdraw(msg.sender, msg.sender, msg.sender, assets, shares);
        return assets;
    }

    // Info:  allow msg.sender to withdraw his deposit plus interest (20230615 - tzuhan)
    function withdraw(uint256 shares) public {
        uint256 payout = _redeem(shares);
        usdt.transfer(msg.sender, payout);
    }

    function transferShares(uint256 shares, address receiver) public {
        _transfer(msg.sender, receiver, shares);
    }
}
