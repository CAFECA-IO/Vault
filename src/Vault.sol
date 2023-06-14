// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/extensions/ERC4626.sol";

contract Vault is ERC4626 {
    ERC20 private immutable _vUSDT;

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
}
