pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";
import "hardhat/console.sol";

contract Vendor is Ownable {
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

    YourToken public yourToken;
    uint256 public constant tokensPerEth = 100;

    constructor(address tokenAddress) {
        yourToken = YourToken(tokenAddress);
    }

    // ToDo: create a payable buyTokens() function:
    function buyTokens() public payable {
        require(msg.value > 0, "Please send some money");
        uint amountToTransfer = msg.value * tokensPerEth;
        yourToken.transfer(msg.sender, amountToTransfer);
        emit BuyTokens(msg.sender, msg.value, amountToTransfer);
    }

    // ToDo: create a withdraw() function that lets the owner withdraw ETH
    function withdraw() public onlyOwner {
        address ownerAddress = owner();
        (bool sent, bytes memory data) = ownerAddress.call{
            value: address(this).balance
        }("");
        require(sent, "Failed to send Ether");
    }

    // ToDo: create a sellTokens(uint256 _amount) function:
    function sellTokens(uint256 _amount) public {
        console.log(_amount);
        yourToken.transferFrom(msg.sender, address(this), _amount);
        (bool sent, bytes memory data) = msg.sender.call{
            value: _amount / tokensPerEth
        }("");
    }
}
