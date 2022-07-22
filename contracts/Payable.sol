// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract Payable {
    uint256 public price = 2 ether;
    address public contractOwner;
    address public contractAddress;

    constructor() {
        contractOwner = msg.sender;
        contractAddress = address(this);
        // createTask("test", price);
    }

    function getBalance() public view returns (uint256) {
        return contractAddress.balance;
    }

    receive() external payable {}
}
