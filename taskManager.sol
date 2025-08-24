// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TaskManager {
    struct Task {
        string description;
        uint256 dueDate;
        bool completed;
        uint256 submittedAt;
    }

    Task[] public tasks;

    
    event TaskCreated(uint256 indexed taskId, string description, uint256 dueDate);
    event TaskSubmitted(uint256 indexed taskId, bool completedOnTime, uint256 submittedAt);

    function createTask(string memory _description, uint256 _dueDate) public {
        tasks.push(Task({
            description: _description,
            dueDate: _dueDate,
            completed: false,
            submittedAt: 0
        }));

        emit TaskCreated(tasks.length - 1, _description, _dueDate);
    }

    
    function submitTask(uint256 _taskId) public {
        require(_taskId < tasks.length, "Invalid task ID");
        Task storage task = tasks[_taskId];
        require(!task.completed, "Task already completed");

        task.submittedAt = block.timestamp;

        
        if (block.timestamp <= task.dueDate) {
            task.completed = true;
            emit TaskSubmitted(_taskId, true, block.timestamp);
        } else {
            task.completed = false; 
            emit TaskSubmitted(_taskId, false, block.timestamp);
        }
    }

    
    function getTask(uint256 _taskId) public view returns (
        string memory description,
        uint256 dueDate,
        bool completed,
        uint256 submittedAt,
        string memory status
    ) {
        require(_taskId < tasks.length, "Invalid task ID");
        Task storage task = tasks[_taskId];

        string memory _status;
        if (!task.completed && task.submittedAt == 0) {
            _status = "Pending";
        } else if (task.completed) {
            _status = "Completed on time";
        } else if (!task.completed && task.submittedAt > 0) {
            _status = "Submitted late";
        }

        return (
            task.description,
            task.dueDate,
            task.completed,
            task.submittedAt,
            _status
        );
    }

    
    function getTaskCount() public view returns (uint256) {
        return tasks.length;
    }
}
