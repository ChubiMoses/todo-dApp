import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class NoteProvider extends ChangeNotifier{
  static const String contractName = "TodoList";
  static const String _rpcURL = "http://192.168.0.154:7545";
  static const String _wsURL = "ws://192.168.0.154:7545";
  static const String _privacyKey = "0x719d72661cfec456d0a414067a8bff9b28f94209cdd11be3e60d7dcedf50c9bc"; 

  late Web3Client _client;
  late Credentials _credentials;
  late DeployedContract _contract;
  late ContractFunction _taskCount;
  late ContractFunction _createTask;
  late ContractFunction _todos;
  late ContractEvent _taskCreatedEvent; 
  late BigInt lifeMeaning;
  bool loading = true;


  NoteProvider(context){
    initialize(context);
  }

   //initialize connection to genache
   initialize(context)async{
    _client = Web3Client(
      _rpcURL, Client(), socketConnector: () {
        return IOWebSocketChannel.connect(_wsURL).cast<String>();
      });
    
    //load abi(api for smart contracts)
    final abiStringFile = await DefaultAssetBundle.of(context).
    loadString("truffle-artifacts/$contractName.json");
    final abiJson = jsonDecode(abiStringFile);
    final abi = jsonEncode(abiJson['abi']);

    final contactAddress  = EthereumAddress.fromHex(abiJson["networks"]["5777"]["address"]);
    _credentials = EthPrivateKey.fromHex(_privacyKey);
    _contract = DeployedContract(ContractAbi.fromJson(abi, contractName), contactAddress);

    _taskCount = _contract.function("taskCount");
    _createTask = _contract.function("createTask");
    _todos = _contract.function("todos");
    _taskCreatedEvent = _contract.event("TaskCreated");

   
    print( await _client.call(contract: _contract, function: _taskCount, params: []));

   
  }

  getTodos()async{
    List<dynamic> totalTaskList = await _client.call(contract: _contract, function: _taskCount, params: []);
    BigInt totalTask = totalTaskList[0];  
    print(totalTask);
  }

}

 class Task{
    String taskName;
    bool isCompleted;
    Task({required this.taskName, required this.isCompleted});
  }