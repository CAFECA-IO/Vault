// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/extensions/ERC4626.sol";

contract Vault is ERC4626 {
    // create your variables and immutables
    ERC20 private immutable _vUSDT;

    // a mapping that checks if a user has deposited
    mapping(address => uint256) public shareHolder;

    constructor(ERC20 _asset, string memory _name, string memory _symbol) ERC4626(_asset) ERC20(_name, _symbol) {
        _vUSDT = _asset;
    }

    // returns total number of assets
    function totalAssets() public view override returns (uint256) {
        return _vUSDT.balanceOf(address(this));
    }

    // returns total balance of user
    function totalAssetsOfUser(address _user) public view returns (uint256) {
        return _vUSDT.balanceOf(_user);
    }

    // a deposit function that receives assets from users
    function deposit(uint256 assets) public {
        // checks that the deposit is higher than 0
        require(assets > 0, "Deposit less than Zero");

        _vUSDT.transferFrom(msg.sender, address(this), assets);

        // checks the value of assets the holder has
        shareHolder[msg.sender] += assets;
        // mints the reciept(shares)
        _mint(msg.sender, assets);

        emit Deposit(msg.sender, address(this), assets, shareHolder[msg.sender]);
    }
}
