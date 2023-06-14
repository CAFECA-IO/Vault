// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/USDT.sol";
import "../src/Vault.sol";

contract VaultScript is Script {
    function setUp() public {}

    function run() public {
        // vm.broadcast();
        vm.startBroadcast();
        VaultUSDT usdt = new VaultUSDT();
        new Vault(usdt, "Vault USDT", "vUSDT");

        vm.stopBroadcast();
    }
}
