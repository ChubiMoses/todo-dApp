

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:note_dapp/model/task.dart';
import 'package:note_dapp/utils/constants.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

final _contractProvider = ChangeNotifierProvider((ref) => TodoProvider());

class TodoProvider extends ChangeNotifier {
static AlwaysAliveProviderBase<TodoProvider> get provider =>_contractProvider;

  final String _rpcURL = Constants().rpcURL;
  final String _wsURL =  Constants().wsURL;
  final String _privacyKey = Constants().privacyKey;
  static const String contractName = "TodoList";
  TextEditingController controller = TextEditingController();
  bool isLoading = true;
  List<Task> todos = []; 
  int taskCount = 0;
  late Web3Client _client;
  late Credentials _credentials;
  late DeployedContract _contract;
  late ContractFunction _taskCount;
  late ContractFunction _createTask;
  late ContractFunction _editTask;
  late ContractFunction _deleteTask;
  late ContractFunction _todos;
  late ContractEvent _taskCreatedEvent; 
  late BigInt lifeMeaning;
  bool loading = true;


  TodoProvider(){
    initialize();
  }

   //initialize connection to genache
   initialize()async{
    _client = Web3Client(
      _rpcURL, Client(), socketConnector: () {
        return IOWebSocketChannel.connect(_wsURL).cast<String>();
      });
    
    //load abi(api for smart contracts)
    final abiStringFile = await rootBundle.loadString("truffle-artifacts/$contractName.json");
    final abiJson = jsonDecode(abiStringFile);
    final abi = jsonEncode(abiJson['abi']);

    final contactAddress  = EthereumAddress.fromHex(abiJson["networks"]["5777"]["address"]);
    _credentials = EthPrivateKey.fromHex(_privacyKey);
    _contract = DeployedContract(ContractAbi.fromJson(abi, contractName), contactAddress);

    _taskCount = _contract.function("taskCount");
    _createTask = _contract.function("createTask");
    _editTask = _contract.function("editTodo");
    _deleteTask = _contract.function("deleteTask");
    _todos = _contract.function("todos");
    _taskCreatedEvent = _contract.event("TaskCreated");
     getTodos();
  }

  Future getTodos()async{
    todos.clear();
    List<dynamic> totalTaskList = await _client.call(contract: _contract, function: _taskCount, params: []);
    BigInt totalTask = totalTaskList[0];  
    taskCount = totalTask.toInt();
    for(var i = 0; i < totalTask.toInt(); i++){
      var temp = await _client.call(contract: _contract, function: _todos, params: [BigInt.from(i)]);
      todos.add(Task(taskName: temp[0], isCompleted: temp[1]));
    }
    isLoading =  false;
     notifyListeners();
  }
  
  Future addTask()async{
    isLoading = true;
     notifyListeners();
    _client.sendTransaction(_credentials, 
    Transaction.callContract(
      contract: _contract, 
      function: _createTask  , parameters:[controller.text],),
       chainId: 1337,
        fetchChainIdFromNetworkId: false
      ).then((value){
         controller.clear();
          getTodos();
      });
   
   } 


  Future editTask(int index, String task, bool status)async{
    isLoading = true;
     notifyListeners();
      _client.sendTransaction(_credentials, 
      Transaction.callContract(
        contract: _contract, 
        function: _editTask, parameters:[BigInt.from(index), task, status],),
        chainId: 1337,
          fetchChainIdFromNetworkId: false
        ).then((value){
            getTodos();
        });
  } 


  Future deleteTask(int index)async{
    isLoading = true;
     notifyListeners();
      _client.sendTransaction(_credentials, 
      Transaction.callContract(
        contract: _contract, 
        function: _deleteTask, parameters:[BigInt.from(index)],),
        chainId: 1337,
          fetchChainIdFromNetworkId: false
        ).then((value){
            getTodos();
        });
  } 




}