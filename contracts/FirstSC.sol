// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract FirstSC {
    uint256 public taskCount = 0;
    uint256 public price = 0;
    address public contractOwner;
    address public contractAddress;
    uint256 public balance = 0;

    struct Task {
        uint256 id;
        string content;
        bool completed;
        address contractOwner;
        address contractAddress;
        uint256 price;
        uint256 balance;
    }

    mapping(uint256 => Task) public tasks;

    event jobCreated(uint256 id, string content, bool completed);

    event JobCompleted(uint256 id, bool completed);

    constructor() {
        contractOwner = msg.sender;
        contractAddress = address(this);
        price = 0;
        createTask("test", price);
    }

    function createTask(string memory _content, uint256 _price) public {
        taskCount++;
        contractOwner = msg.sender;
        contractAddress = address(this);
        balance = contractAddress.balance;
        tasks[taskCount] = Task(
            taskCount,
            _content,
            false,
            contractOwner,
            contractAddress,
            _price,
            balance
        );
        emit jobCreated(taskCount, _content, false);
    }

    function buttonCompleted(uint256 _id) public {
        Task memory _task = tasks[_id];
        _task.completed = !_task.completed;
        tasks[_id] = _task;
        emit JobCompleted(_id, _task.completed);
    }

    // view meant readonly
    function getBalance() public view returns (uint256) {
        return contractAddress.balance;
    }

    // receive() external payable {}
}
