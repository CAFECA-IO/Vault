// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/extensions/ERC4626.sol";

contract Vault is ERC4626 {
    // Info: create your variables and immutables (20230615 - tzuhan)
    ERC20 private immutable _vUSDT;

    // Info: a mapping that checks if a user has deposited (20230615 - tzuhan)
    mapping(address => uint256) public shareHolder;

    event TransferShares(address indexed from, address indexed to, uint256 value);

    constructor(ERC20 _asset, string memory _name, string memory _symbol) ERC4626(_asset) ERC20(_name, _symbol) {
        _vUSDT = _asset;
    }

    // Info: returns total number of assets (20230615 - tzuhan)
    function totalAssets() public view override returns (uint256) {
        return _vUSDT.balanceOf(address(this));
    }

    // Info: returns total balance of user (20230615 - tzuhan)
    function totalAssetsOfUser(address _user) public view returns (uint256) {
        return _vUSDT.balanceOf(_user);
    }

    function totalShares() public view returns (uint256) {
        return this.balanceOf(address(this));
    }

    function totalSharesOfUser(address _user) public view returns (uint256) {
        // return this.balanceOf(_user);
        return shareHolder[_user];
    }

    // Info: a deposit function that receives assets from users (20230615 - tzuhan)
    function deposit(uint256 assets) public {
        // Info: checks that the deposit is higher than 0 (20230615 - tzuhan)
        require(assets > 0, "Deposit less than Zero");

        _vUSDT.transferFrom(msg.sender, address(this), assets);

        // Info: checks the value of assets the holder has (20230615 - tzuhan)
        shareHolder[msg.sender] += assets;
        // Info: mints the reciept(shares) (20230615 - tzuhan)
        _mint(msg.sender, assets);

        emit Deposit(msg.sender, msg.sender, assets, shareHolder[msg.sender]);
    }

    // Info: users to return shares and get thier token back before they can withdraw, and requires that the user has a deposit (20230615 - tzuhan)
    function _redeem(uint256 shares) internal returns (uint256 assets) {
        require(shareHolder[msg.sender] > 0, "Not a share holder");
        shareHolder[msg.sender] -= shares;

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
        _vUSDT.transfer(msg.sender, payout);
    }

    // function transferShares(uint256 shares, address receiver) public {
    //     _transfer(msg.sender, receiver, shares);

    //     shareHolder[msg.sender] -= shares;
    //     shareHolder[receiver] += shares;

    //     emit TransferShares(msg.sender, receiver, shares);
    // }

    function transfer(address receiver, uint256 shares) public virtual override returns (bool) {
        _transfer(msg.sender, receiver, shares);

        shareHolder[msg.sender] -= shares;
        shareHolder[receiver] += shares;

        emit TransferShares(msg.sender, receiver, shares);

        return true;
    }
}
