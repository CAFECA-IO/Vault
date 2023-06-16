// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Vault.sol";
// import "../src/USDT.sol";

contract VaultTest is Test {
    // USDT public usdt;
    Vault public vault;

    function setUp() public {
        // usdt = new USDT("TideBit USDT", "tbUSDT");
        vault = new Vault(address(0x6e642065B9976FbDF94aB373a4833A48F040BfF3), "Vault USDT", "vUSDT");
    }

    // function testTotalAssets() public {
    //     emit log_named_uint("the vault totalAssets", vault.totalAssets());
    //     assertEq(vault.totalAssets(), 0);
    // }

    // function testTotalAssetsOfUser(address user) public {
    //     assertEq(vault.totalAssetsOfUser(user), 0);
    // }

    // function testMint() public {
    //     usdt.mint(address(this), 100);
    //     assertEq(usdt.balanceOf(address(this)), 100);
    // }

    // function testDeposit() public {
    //     usdt.mint(address(this), 100);
    //     usdt.approve(address(vault), 100);
    //     vault.deposit(100);
    //     assertEq(vault.totalAssets(), 100);
    //     assertEq(vault.totalAssetsOfUser(address(this)), 100);
    //     emit log_named_uint("the vault totalAssets", vault.totalAssets());
    // }

    function testWithdraw() public {
        // usdt.mint(address(this), 100);
        // usdt.approve(address(vault), 100);
        vault.deposit(100);
        assertEq(vault.totalAssets(), 100);
        assertEq(vault.totalSharesOfUser(address(this)), 100);
        assertEq(vault.totalAssetsOfUser(address(this)), 0);
        vault.withdraw(100);
        assertEq(vault.totalSharesOfUser(address(this)), 0);
        assertEq(vault.totalAssetsOfUser(address(this)), 100);
        assertEq(vault.totalAssets(), 0);
    }
}

