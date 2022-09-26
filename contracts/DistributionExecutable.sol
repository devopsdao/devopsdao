//SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import { AxelarExecutable } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/executables/AxelarExecutable.sol';
import { IAxelarGateway } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol';
import { IERC20 } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IERC20.sol';
import { IAxelarGasService } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol';

import { StringToAddress, AddressToString } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/StringAddressUtils.sol';


contract DistributionExecutable is AxelarExecutable {
    IAxelarGasService public immutable gasReceiver;

    using AddressToString for address;

    event Logs(address contractAdr, string message);

    event LogsValue(address contractAdr, string message, uint value);

    constructor(address gateway_, address gasReceiver_) AxelarExecutable(gateway_) {
        gasReceiver = IAxelarGasService(gasReceiver_);
    }

    function addressToString(address address_) external pure returns (string memory) {
        return address_.toString();
    }

    function uint2str(
        uint256 _i
      )
        internal
        pure
        returns (string memory str)
      {
        if (_i == 0)
        {
          return "0";
        }
        uint256 j = _i;
        uint256 length;
        while (j != 0)
        {
          length++;
          j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        j = _i;
        while (j != 0)
        {
          bstr[--k] = bytes1(uint8(48 + j % 10));
          j /= 10;
        }
        str = string(bstr);
      }

    function sendToMany(
        string memory destinationChain,
        string memory destinationAddress,
        address[] calldata destinationAddresses,
        string memory symbol,
        uint256 amount
    ) external payable {
        emit Logs(address(this), string.concat("sendToMany", symbol, " to ", destinationChain, "address:",this.addressToString(destinationAddresses[0])));
        address tokenAddress = gateway.tokenAddresses(symbol);
        IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount);
        IERC20(tokenAddress).approve(address(gateway), amount);
        bytes memory payload = abi.encode(destinationAddresses);
        emit LogsValue(address(this), "payNativeGasForContractCallWithToken: ", msg.value);
        if (msg.value > 0) {
            gasReceiver.payNativeGasForContractCallWithToken{ value: msg.value }(
                address(this),
                destinationChain,
                destinationAddress,
                payload,
                symbol,
                amount,
                msg.sender
            );
        }
        emit Logs(address(this), string.concat("callContractWithToken", symbol, "amount:", uint2str(amount), " to ", destinationChain, "contractaddr:", destinationAddress, "address:",this.addressToString(destinationAddresses[0])));
        gateway.callContractWithToken(destinationChain, destinationAddress, payload, symbol, amount);
    }

    function _executeWithToken(
        string calldata,
        string calldata,
        bytes calldata payload,
        string calldata tokenSymbol,
        uint256 amount
    ) internal override {
        address[] memory recipients = abi.decode(payload, (address[]));
        address tokenAddress = gateway.tokenAddresses(tokenSymbol);

        uint256 sentAmount = amount / recipients.length;
        for (uint256 i = 0; i < recipients.length; i++) {
            IERC20(tokenAddress).transfer(recipients[i], sentAmount);
        }
    }
}
