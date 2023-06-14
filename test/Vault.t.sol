// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Vault.sol";
import "../src/USDT.sol";

contract VaultTest is Test {
    Vault public vault;
    USDT public usdt;

    function setUp() public {
        usdt = new USDT();
        vault = new Vault(usdt, 'Vault USDT', 'vUSDT');
    }

    function testTotalAssets() public {
        emit log_named_uint("the vault totalAssets", vault.totalAssets());
        assertEq(vault.totalAssets(), 0);
    }

    function testTotalAssetsOfUser(address user) public {
        assertEq(vault.totalAssetsOfUser(user), 0);
    }

    function testDeposit() public {
        usdt.mint(address(this), 100);
        usdt.approve(address(vault), 100);
        vault.deposit(100);
        assertEq(vault.totalAssets(), 100);
        emit log_named_uint("the vault totalAssets", vault.totalAssets());
    }
}
