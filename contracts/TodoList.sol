//SPDX-License-Identifier: GPL-3.0

pragma  solidity >=0.6.2 <0.9.0;

contract TodoList{
    uint public taskCount;

    struct Task{
        string taskName;
        bool isComplete;
    }

    mapping (uint index =>Task) public  todos;

    event TaskCreated(string task, uint taskNumber);
    event TaskDeleted(uint taskNumber);
    event TaskModified(uint taskNumber);

    constructor()  {
        taskCount = 0;
    }

    function createTask(string memory _taskName) public {
        todos[taskCount++] = Task(_taskName, false);
       emit TaskCreated(_taskName, taskCount-1);
    }

    function deleteTask(uint index) public {
        delete todos[index];
        taskCount--;
        emit  TaskDeleted(index);
    }


    function editTodo(uint index, string memory _taskName, bool isComplete) public {
        todos[index] = Task(_taskName, isComplete);
        emit  TaskModified(index);
    }
}