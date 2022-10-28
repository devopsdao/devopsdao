// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

// import { IDistributionExecutable } from './IDistributionExecutable.sol';
import { IDistributionExecutable } from './IDistributionExecutable.sol';


// import { AxelarExecutable } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/executables/AxelarExecutable.sol';
import { IAxelarGateway } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol';
import { IERC20 } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IERC20.sol';
// import { IAxelarGasService } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol';
import { StringToAddress, AddressToString } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/StringAddressUtils.sol';

error RevertReason (string message);

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
        string nanoId,
        address jobAddress,
        address jobOwner,
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

    function createJobContract(string memory _nanoId, string memory _title, string memory _description, string memory _symbol, uint256 _amount)
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

        if (keccak256(bytes(_symbol)) != keccak256(bytes("ETH"))) {
            address tokenAddress = gateway.tokenAddresses(_symbol);
            // amount = IERC20(tokenAddress).balanceOf(contractAddress);
            IERC20(tokenAddress).transferFrom(msg.sender, address(job), _amount);
        }
        // IERC20(tokenAddress).approve(address(gateway), _amount);

        jobArray.push(job);
        countNew++;
        emit JobContractCreated(_nanoId, address(job), msg.sender, _title, _description, _symbol, _amount);
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

    function jobAuditParticipate(Job job) external {
        jobArray[job.index()].jobAuditParticipate(msg.sender);
        emit OneEventForAll(address(job), job.index());
    }

    function jobRating(Job job, uint256 _score) external {
        jobArray[job.index()].jobRate(_score, msg.sender);
        emit OneEventForAll(address(job), job.index());
    }


    function jobStateChange(
        Job job,
        address payable _participantAddress,
        string memory _state
    ) external {
        jobArray[job.index()].jobStateChange(_participantAddress, _state, msg.sender);
        emit OneEventForAll(address(job), job.index());
    }
    

    function jobAuditStateChange(
        Job job,
        string memory _favour
    ) external {
        jobArray[job.index()].jobAuditDecision(_favour);
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

    // function transferToaddressChain(Job job, address payable addressToSend, string memory chain)
    // external
    // payable
    // {
    //     jobArray[job.index()].transferToaddressChain(addressToSend, chain);
    //     emit OneEventForAll(address(job), job.index());
    // }

    function transferToaddressChain2(Job job, address payable addressToSend, string memory chain)
    external
    payable
    {
        jobArray[job.index()].transferToaddressChain2{value: msg.value}(addressToSend, chain);
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
        string memory,
        uint256,
        address[] memory,
        string memory,
        address
        
    )
    {
        Job _retBal = Job(payable(address(jobArray[_classIndex])));
        return _retBal.getJob();
    }

    // receive() external payable {}
}

contract Job {
    // IDistributionExecutable public immutable distributor;

    IAxelarGateway public immutable gateway;
    using AddressToString for address;
    using StringToAddress for string;

    address[] public Participants;
    address[] public AuditParticipants;
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
    uint256 rating = 0;
    address public auditInitiator;
    string public auditState;
    address public auditorAddress;


    event Logs(address contractAdr, string message);
    event LogsValue(address contractAdr, string message, uint value);

    constructor(
        string memory _nanoId,
        string memory _title,
        string memory _description,
        string memory _symbol,
        uint256 _index,
        address _contractOwner
        // uint256 _rating
    ) payable {
        // data = _data;
        nanoId = _nanoId;
        title = _title;
        jobState = "new";
        contractAddress = address(this);
        contractParent = msg.sender;
        contractOwner = _contractOwner;
        createTime = block.timestamp;
        index = _index;
        description = _description;
        symbol = _symbol;
        // rating = _rating;

        address gateway_ = 0x5769D84DD62a6fD969856c75c7D321b84d455929;
        gateway = IAxelarGateway(gateway_);

        // address distributor_ = 0xE9F4b6dB26f964E5B62Fa3bEC5115a56B4DBd79A;
        // distributor = IDistributionExecutable(distributor_);
        // distributor = DistributionExecutable(gateway_);
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

    function getJob() public view returns (
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
        string memory _nanoId,
        uint256 _rating,
        address[] memory _auditParticipants,
        string memory _auditState,
        address _auditorAddress
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
            nanoId,
            rating,
            AuditParticipants,
        auditState,
            auditorAddress
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

    // function transferToaddressChain(address payable _addressToSend, string memory chain) public payable {
    //     if (keccak256(bytes(jobState)) == keccak256(bytes("canceled"))) {
    //         if (_addressToSend == contractOwner) {
    //             _addressToSend.transfer(contractAddress.balance);
    //         }
    //     } else if (
    //         keccak256(bytes(jobState)) == keccak256(bytes("completed"))
    //     ) {
    //         _destinationAddresses.push(participantAddress);
    //         distributor.sendToMany(chain, _addressToSend, _destinationAddresses, 'WETH', contractAddress.balance);
    //     }
    //     // msg.sender.transfer(address(this).balance);
    // }

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

    function transferToaddressChain2(address payable _addressToSend, string memory chain) public payable {
        if (keccak256(bytes(jobState)) == keccak256(bytes("canceled"))) {
            if (participantAddress == contractOwner) {
                participantAddress.transfer(contractAddress.balance);
            }
        } else if (
            keccak256(bytes(jobState)) == keccak256(bytes("completed")) //|| 1==1
        ) {
            bytes memory symbolBytes = bytes(symbol);
            bytes memory chainBytes = bytes(chain);

            //check USDC balance
            address tokenAddress = gateway.tokenAddresses("aUSDC");
            uint256 contractUSDCAmount = IERC20(tokenAddress).balanceOf(contractAddress)/10;
            
            //check ETH balance
            if (contractAddress.balance != 0) {
                emit Logs(address(contractAddress), string.concat("withdrawing ", symbol, " to Ethereum address: ",this.addressToString(participantAddress)));
                participantAddress.transfer(contractAddress.balance);
            } 
            if (contractUSDCAmount !=0 && (
                keccak256(chainBytes) == keccak256(bytes("PolygonAxelar"))
            )) {
                emit Logs(address(contractAddress), string.concat("withdrawing via sendToMany ", symbol, " to ", chain, "value: ", uint2str(msg.value), " address:",this.addressToString(participantAddress)));
                emit LogsValue(address(this), string.concat("msg.sender: ", this.addressToString(msg.sender)," call value: "), msg.value);
                // string memory _addressToSend2 = bytes(_addressToSend);
                IERC20(tokenAddress).approve(0xE9F4b6dB26f964E5B62Fa3bEC5115a56B4DBd79A, contractUSDCAmount);
                _destinationAddresses.push(participantAddress);
                IDistributionExecutable(0xE9F4b6dB26f964E5B62Fa3bEC5115a56B4DBd79A).sendToMany{value: msg.value}("polygon", this.addressToString(0xEAAA71f74b01617BA2235083334a1c952BAC0a6C), _destinationAddresses, 'aUSDC', contractUSDCAmount);
            }
            else if (keccak256(symbolBytes) == keccak256(bytes("aUSDC")) && (
                keccak256(chainBytes) == keccak256(bytes("Ethereum")) || 
                keccak256(chainBytes) == keccak256(bytes("Binance")) ||
                keccak256(chainBytes) == keccak256(bytes("Fantom")) ||
                keccak256(chainBytes) == keccak256(bytes("Avalanche")) ||
                keccak256(chainBytes) == keccak256(bytes("Polygon"))
            )) {
                emit Logs(address(contractAddress), string.concat("withdrawing ", symbol, " to ", chain, "address:",this.addressToString(participantAddress)));
                // _destinationAddresses.push(_addressToSend);
                // distributor.sendToMany(chain, _addressToSend, _destinationAddresses, 'aUSDC', contractAddress.balance);
                // string memory _addressToSend2 = bytes(_addressToSend);

                IERC20(tokenAddress).approve(address(gateway), contractUSDCAmount);
                // gateway.sendToken(chain, toAsciiString(participantAddress), "aUSDC", amount);
                gateway.sendToken(chain, this.addressToString(participantAddress), "aUSDC", contractUSDCAmount);
            } else if (keccak256(symbolBytes) == keccak256(bytes("aUSDC")) && keccak256(chainBytes) == keccak256(bytes("Moonbase"))) {
                // revert InvalidToken({
                //     token: string.concat("we are in moonbase, participantAddress",this.addressToString(participantAddress))
                // });
                emit Logs(address(contractAddress), string.concat("withdrawing ", symbol, " to ", chain, "address:",this.addressToString(participantAddress)));
                IERC20(tokenAddress).approve(contractAddress, contractUSDCAmount);
                IERC20(tokenAddress).transferFrom(contractAddress, participantAddress, contractUSDCAmount);
                // IERC20(tokenAddress).approve(address(gateway), amount);
            }
            else{
                revert RevertReason({
                    message: "invalid destination network"
                });
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
    }

    function jobAuditParticipate(address _auditParticipantAddress) external {
        // TODO: add NFT based auditor priviledge check
        bool existed = false;
        if (AuditParticipants.length == 0) {
            AuditParticipants.push(_auditParticipantAddress);
        } else {
            for (uint256 i = 0; i < Participants.length; i++) {
                if (AuditParticipants[i] == _auditParticipantAddress) {
                    existed = true;
                    break;
                }
            }
            if (!existed) {
                AuditParticipants.push(_auditParticipantAddress);
            }
        }
    }

    function jobRate(uint _score, address _applicant) external {
        if (
            rating == 0 &&
            _score != 0 &&
            _score <= 5 &&
            keccak256(bytes(jobState)) == keccak256(bytes("completed")) &&
            contractOwner == _applicant
        ) {
            rating = _score;
        } else {
        }
    }

    //todo: only allow calling child contract functions from the parent contract!!!
    function jobStateChange(
        address payable _participantAddress,
        string memory _state,
        address _initiatorAddress
        // string memory _message
    ) external {
        if (_initiatorAddress == contractOwner && _initiatorAddress != _participantAddress && keccak256(bytes(jobState)) == keccak256(bytes("new")) && 
        keccak256(bytes(_state)) == keccak256(bytes("agreed"))) {
            //TODO: LETS FIX IT!!!!! _participantAddress must be compared with participant list in its contract ************************
            jobState = "agreed";
            participantAddress = _participantAddress;
        } else if (_initiatorAddress == participantAddress &&
            keccak256(bytes(jobState)) == keccak256(bytes("agreed")) && keccak256(bytes(_state)) == keccak256(bytes("progress"))) {
            jobState = "progress";
        } else if (_initiatorAddress == participantAddress && 
            keccak256(bytes(jobState)) == keccak256(bytes("progress")) && keccak256(bytes(_state)) == keccak256(bytes("review"))) {
            jobState = "review";
        } else if (_initiatorAddress == contractOwner &&  _initiatorAddress != participantAddress &&
            keccak256(bytes(jobState)) == keccak256(bytes("review")) && keccak256(bytes(_state)) == keccak256(bytes("completed"))) {
            jobState = "completed";
        } else if (keccak256(bytes(jobState)) == keccak256(bytes("new")) && _initiatorAddress == contractOwner && keccak256(bytes(_state)) == keccak256(bytes("canceled"))) {
            jobState = "canceled";
        } else if (keccak256(bytes(_state)) == keccak256(bytes("audit"))){
            if(_initiatorAddress == contractOwner &&  _initiatorAddress != participantAddress &&
                (keccak256(bytes(jobState)) == keccak256(bytes("agreed")) || keccak256(bytes(jobState)) == keccak256(bytes("progress")) || keccak256(bytes(jobState)) == keccak256(bytes("review")))){
                jobState = "audit";
                auditInitiator = _initiatorAddress;
                auditState = 'requested';
            }
            else if(_initiatorAddress == participantAddress &&
                (keccak256(bytes(jobState)) == keccak256(bytes("review"))))

            {
                jobState = "audit";
                auditInitiator = _initiatorAddress;
                auditState = 'requested';
                //TODO: audit history need to add 
            }
            if(_initiatorAddress == contractOwner &&
                keccak256(bytes(jobState)) == keccak256(bytes("audit")) && 
                keccak256(bytes(auditState)) == keccak256(bytes("requested")) &&
                AuditParticipants.length != 0) {
                for (uint256 i = 0; i < AuditParticipants.length; i++) {
                    if (AuditParticipants[i] == _participantAddress) {
                        jobState = "audit";
                        auditorAddress = _participantAddress;
                        auditState = 'performing';
                        break;
                    }
                }
            }
        }
    }

    function jobAuditDecision(
        // address payable _participantAddress,
        string memory _favour
    ) external {
        // TODO: add NFT based auditor priviledge check
        if (msg.sender == auditorAddress && keccak256(bytes(jobState)) == keccak256(bytes("audit"))
        && keccak256(bytes(auditState)) == keccak256(bytes("performing"))
        && keccak256(bytes(_favour)) == keccak256(bytes("customer"))) {
            auditState = "complete";
            jobState = "new";
        }
        if (msg.sender == auditorAddress && keccak256(bytes(jobState)) == keccak256(bytes("audit"))
        && keccak256(bytes(auditState)) == keccak256(bytes("performing"))
        && keccak256(bytes(_favour)) == keccak256(bytes("performer"))) {
            auditState = "finished";
            jobState = "completed";
        }
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
