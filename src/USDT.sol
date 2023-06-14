// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract VaultUSDT is ERC20 {

    constructor() ERC20("Vault USDT", "vUSDT") {
        this;
    }

    // function mint(address recipient, uint256 amount) external {
    //     _mint(recipient, amount);
    // }

    function mint(address to, uint256 amount) public virtual {
        _mint(to, amount);
    }

    function burn(address form, uint256 amount) public virtual {
        _burn(form, amount);
    }
}
