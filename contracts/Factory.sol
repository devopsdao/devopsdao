// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import { IDistributionExecutable } from './IDistributionExecutable.sol';


import { AxelarExecutable } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/executables/AxelarExecutable.sol';
import { IAxelarGateway } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol';
import { IERC20 } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IERC20.sol';
import { IAxelarGasService } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol';

contract Factory {
    IAxelarGateway public immutable gateway;


    Job[] public jobArray;
    // address contractOwner;
    uint256 public countNew = 0;
    uint256 countAgreed = 0;
    uint256 countProgress = 0;
    uint256 countReview = 0;
    uint256 countCompleted = 0;
    uint256 countCanceled = 0;
    string stateNew = "new";
    string stateAgreed = "agreed";
    string stateProgress = "progress";
    string stateReview = "review";
    string stateCompleted = "completed";
    string stateCanceled = "canceled";

    event OneEventForAll(address contractAdr, uint256 index);

    event JobContractCreated(
        address jobAddress,
        address jobOwner,
        string nanoId,
        string title,
        string description,
        string symbol,
        uint256 amount
    );


    constructor() {
        address gateway_ = 0x5769D84DD62a6fD969856c75c7D321b84d455929;
        gateway = IAxelarGateway(gateway_);
    }

    // initial: new, contractor choosed: agreed, work in progress: progress, completed: completed, canceled

    // function indexCalculation(string memory _state) public returns (uint256) {}

    function createJobContract(string memory _title, string memory _description, string memory _symbol, uint256 _amount, string memory _nanoId)
    external
    payable
    {
        Job job = new Job{value: msg.value}(
            _nanoId,
            _title,
            _description,
            _symbol,
            jobArray.length,
            msg.sender
        );

        address tokenAddress = gateway.tokenAddresses(_symbol);
        // amount = IERC20(tokenAddress).balanceOf(contractAddress);
        IERC20(tokenAddress).transferFrom(msg.sender, address(job), _amount);
        // IERC20(tokenAddress).approve(address(gateway), _amount);

        jobArray.push(job);
        countNew++;
        emit JobContractCreated(address(job), msg.sender, _nanoId, _title, _description, _symbol, _amount);
        emit OneEventForAll(address(job), job.index());
    }

    // function findJobs(uint256 _myIndex) external view returns (address) {
    //     return address(jobArray[_myIndex]);
    // }

    function allJobs() external view returns (Job[] memory _jobs) {
        _jobs = new Job[](jobArray.length);
        uint256 count;
        for (uint256 i = 0; i < jobArray.length; i++) {
            _jobs[count] = jobArray[i];
            count++;
        }
    }


    function jobParticipate(Job job) external {
        jobArray[job.index()].jobParticipate(msg.sender);
        emit OneEventForAll(address(job), job.index());
    }


    function jobStateChange(
        Job job,
        address payable _participantAddress,
        string memory _state
    ) external {
        jobArray[job.index()].jobStateChange(_participantAddress, _state);

        // if (keccak256(bytes(_state)) == keccak256(bytes("agreed"))) {
        //     countAgreed++;
        // } else if (keccak256(bytes(_state)) == keccak256(bytes("progress"))) {
        //     countProgress++;
        // } else if (keccak256(bytes(_state)) == keccak256(bytes("review"))) {
        //     countReview++;
        // } else if (keccak256(bytes(_state)) == keccak256(bytes("completed"))) {
        //     countCompleted++;
        // } else if (keccak256(bytes(_state)) == keccak256(bytes("canceled"))) {
        //     countCanceled++;
        // }

        emit OneEventForAll(address(job), job.index());
    }

    // function jobReview(Job job, address _participantAddress) external {
    //     jobArray[job.index()].jobReview(_participantAddress);
    //     countProgress++;
    // }

    // function jobConfimation(Job job, address _participantAddress) external {
    //     jobArray[job.index()].jobConfimation(_participantAddress);
    //     countReview++;
    // }

    function transferToaddress(Job job, address payable addressToSend)
    external
    payable
    {
        // addressToSend.transfer(0.5 ether);
        jobArray[job.index()].transferToaddress(addressToSend);
        emit OneEventForAll(address(job), job.index());
    }

    function transferToaddressChain(Job job, address payable addressToSend, string memory chain)
    external
    payable
    {
        jobArray[job.index()].transferToaddressChain(addressToSend, chain);
        emit OneEventForAll(address(job), job.index());
    }

    function transferToaddressChain2(Job job, address payable addressToSend, string memory chain)
    external
    payable
    {
        jobArray[job.index()].transferToaddressChain2(addressToSend, chain);
        emit OneEventForAll(address(job), job.index());
    }


    // function jobCanceled(Job job) external {
    //     jobArray[job.index()].jobCanceled();
    //     countCanceled++;
    // }

    // function getContractAdr(uint256 _classIndex)
    //     external
    //     view
    //     returns (address)
    // {
    //     Job _retBal = Job(payable(address(jobArray[_classIndex])));
    //     return _retBal.returnContractAddress();
    // }

    function getBalance(uint256 _classIndex) external view returns (uint256) {
        Job _retBal = Job(payable(address(jobArray[_classIndex])));
        return _retBal.getBalance();
    }

    // function thisContract() external view returns (address) {
    //     address thisConr = address(this);
    //     return thisConr;
    // }

    function getJobInfo(uint256 _classIndex)
    external
    view
    returns (
        string memory,
        string memory,
        address,
        address,
        address,
        uint256,
        uint256,
        string memory,
        address[] memory,
        address,
        string memory,
        string memory
        
    )
    {
        Job _retBal = Job(payable(address(jobArray[_classIndex])));
        return _retBal.getJob();
    }

    // receive() external payable {}
}

contract Job {
    IDistributionExecutable public immutable distributor;

    IAxelarGateway public immutable gateway;


    address[] public Participants;
    // uint256 public data;
    string public nanoId;
    string public title;
    string public description;
    string public jobState;
    uint256 public index;

    string public name;
    uint256 public price;
    address public contractParent;
    address public contractAddress;
    address public contractOwner;
    address payable public participantAddress;
    uint256 public createTime;
    address[] public _destinationAddresses;
    string public symbol;
    uint256 amount;

    constructor(
        string memory _nanoId,
        string memory _title,
        string memory _description,
        string memory _symbol,
        uint256 _index,
        address _contractOwner
    ) payable {
        // data = _data;
        nanoId = _nanoId;
        distributor = IDistributionExecutable(_contractOwner);
        title = _title;
        jobState = "new";
        contractAddress = address(this);
        contractParent = msg.sender;
        contractOwner = _contractOwner;
        createTime = block.timestamp;
        index = _index;
        description = _description;
        symbol = _symbol;

        address gateway_ = 0x5769D84DD62a6fD969856c75c7D321b84d455929;
        gateway = IAxelarGateway(gateway_);
        // balance = contractAddress.balance;
        // createJob(_content, _index);
        // myStruct = jobStructData(
        //     _data,
        //     true,
        //     address(this),
        //     msg.sender,
        //     block.timestamp,
        //     _index
        // );
    }

    // event OneEventForAll2(address contractAdr);

    // function createJob(string memory _content, uint256 _index) public {
    //     jobStructDataArray.push();

    //     jobStructData(
    //         _content,
    //         true,
    //         address(this),
    //         msg.sender,
    //         block.timestamp
    //     );
    //     emit jobCreated(_content, _index);
    // }

    function getJob()
    public
    view
    returns (
        string memory _content,
        string memory _jobState,
        address _contractAddress,
        address _contractParent,
        address _contractOwner,
        uint256 _createTime,
        uint256 _index,
        string memory _description,
        address[] memory _participants,
        address _participantAddress,
        string memory _symbol,
        string memory _nanoId
    )
    {
        return (
        title,
        jobState,
        contractAddress,
        contractParent,
        contractOwner,
        createTime,
        index,
        description,
        Participants,
        participantAddress,
        symbol,
        nanoId
        );
    }

    function withdrawAll() external {
        // jobState = true;
    }

    // function getContractInfo() public view returns (uint256) {
    //     return contractAddress.balance;
    // }

    function getBalance() public view returns (uint256) {
        return contractAddress.balance;
    }

    function transferToaddress(address payable _addressToSend) public payable {
        if (keccak256(bytes(jobState)) == keccak256(bytes("canceled"))) {
            if (_addressToSend == contractOwner) {
                _addressToSend.transfer(contractAddress.balance);
            }
        } else if (
            keccak256(bytes(jobState)) == keccak256(bytes("completed"))
        ) {

            participantAddress.transfer(contractAddress.balance);
        }
        // msg.sender.transfer(address(this).balance);
    }

    function transferToaddressChain(address payable _addressToSend, string memory chain) public payable {
        if (keccak256(bytes(jobState)) == keccak256(bytes("canceled"))) {
            if (_addressToSend == contractOwner) {
                _addressToSend.transfer(contractAddress.balance);
            }
        } else if (
            keccak256(bytes(jobState)) == keccak256(bytes("completed"))
        ) {
            _destinationAddresses.push(participantAddress);
            distributor.sendToMany(chain, _addressToSend, _destinationAddresses, 'WETH', contractAddress.balance);
        }
        // msg.sender.transfer(address(this).balance);
    }

    function transferToaddressChain2(address payable _addressToSend, string memory chain) public payable {
        if (keccak256(bytes(jobState)) == keccak256(bytes("canceled"))) {
            if (_addressToSend == contractOwner) {
                _addressToSend.transfer(contractAddress.balance);
            }
        } else if (
            keccak256(bytes(jobState)) == keccak256(bytes("completed"))
        ) {
            bytes memory symbolBytes = bytes(symbol);
            bytes memory chainBytes = bytes(chain);
            if (symbolBytes.length == 0) {
                // do nothing
            } else if (keccak256(symbolBytes) == keccak256(bytes("ETH"))) {
                participantAddress.transfer(contractAddress.balance);
            } else if (keccak256(symbolBytes) == keccak256(bytes("WETH")) && keccak256(chainBytes) != keccak256(bytes("Moonbase"))) {
                // _destinationAddresses.push(_addressToSend);
                // distributor.sendToMany(chain, _addressToSend, _destinationAddresses, 'aUSDC', contractAddress.balance);
                // string memory _addressToSend2 = bytes(_addressToSend);
                IERC20(_addressToSend).approve(address(gateway), contractAddress.balance);
                gateway.sendToken(chain, toAsciiString(_addressToSend), "WETH", contractAddress.balance);
            } else if (keccak256(symbolBytes) == keccak256(bytes("aUSDC"))) {
                address tokenAddress = gateway.tokenAddresses(symbol);
                amount = IERC20(tokenAddress).balanceOf(contractAddress);
                IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount);
                IERC20(tokenAddress).approve(address(gateway), amount);
            }
        }
        // msg.sender.transfer(address(this).balance);
    }

    function toAsciiString(address x) internal pure returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8*(19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2*i] = char(hi);
            s[2*i+1] = char(lo);
        }
        return string(s);
    }

    function char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }


    function jobParticipate(address _participantAddress) external {
        bool existed = false;
        if (Participants.length == 0) {
            Participants.push(_participantAddress);
        } else {
            for (uint256 i = 0; i < Participants.length; i++) {
                if (Participants[i] == _participantAddress) {
                    existed = true;
                }
            }
            if (!existed) {
                Participants.push(_participantAddress);
            }
        }
        // emit OneEventForAll2(contractAddress);
    }

    function jobStateChange(
        address payable _participantAddress,
        string memory _state
    ) external {
        if (keccak256(bytes(_state)) == keccak256(bytes("agreed"))) {
            jobState = "agreed";
            participantAddress = _participantAddress;
        } else if (keccak256(bytes(_state)) == keccak256(bytes("progress"))) {
            jobState = "progress";
        } else if (keccak256(bytes(_state)) == keccak256(bytes("review"))) {
            jobState = "review";
        } else if (keccak256(bytes(_state)) == keccak256(bytes("completed"))) {
            jobState = "completed";
        } else if (keccak256(bytes(_state)) == keccak256(bytes("canceled"))) {
            jobState = "canceled";
        }

        // emit OneEventForAll2(contractAddress);
    }

    // function jobReview(address _participantAddress) external {
    //     if (participantAddress == _participantAddress) {
    //         jobState = "review";
    //     }
    // }

    // function jobParticiantAgreed(address _participantAddress) external {
    //     jobState = "agreed";
    //     participantAddress = _participantAddress;

    //     // for (uint256 i = 0; i < Participants.length; i++) {
    //     //     if (Participants[i] == _participantAddress) {
    //     //         jobState = "agreed";
    //     //         participantAddress = _participantAddress;
    //     //     }
    //     // }
    // }

    // function jobInProgress() external {
    //     jobState = "progress";
    // }

    // function jobCompleted() external {
    //     jobState = "completed";
    // }

    // function jobCanceled() external {
    //     jobState = "canceled";
    // }

    receive() external payable {}

    // fallback () external payable    {

    // }

    // constructor(string memory _name, address _owner) {
    //     name = _name;
    //     owner = _owner;
    // }
}
