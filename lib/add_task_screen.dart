import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_dapp/model/task.dart';
import 'package:note_dapp/service/contract_service.dart';

class AddTaskScreen extends ConsumerWidget {
  final Task? task;
  final int? index;

   AddTaskScreen({super.key,  this.index,  required this.task});

    final List<String> _priorities = ['Low', 'Medium', 'High'];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoProvider = ref.read(TodoProvider.provider);
    todoProvider.controller.text = task?.taskName??"";
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context)),
        title: Row(children: [
          Text(
            task == null ? 'Add Task' : 'Update Task',
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 20.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ]),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.info_outline,
                color: Colors.black,
              ),
              onPressed: () {}),
        ],
        centerTitle: false,
        elevation: 0,
      ),
      body:
       GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Column(
                      children: [
                         Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: TextFormField(
                        controller:todoProvider.controller,
                        style: const TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: const TextStyle(fontSize: 18.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      
                      ),
                    ),
                   
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: DropdownButtonFormField(
                        isDense: true,
                        icon: const Icon(Icons.arrow_drop_down_circle),
                        iconSize: 22.0,
                        iconEnabledColor: Theme.of(context).primaryColor,
                        items: _priorities.map((String priority) {
                          return DropdownMenuItem(
                            value: priority,
                            child: Text(
                              priority,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                              ),
                            ),
                          );
                        }).toList(),
                        style: const TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          labelText: 'Priority',
                          labelStyle: const TextStyle(fontSize: 18.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                       
                        onChanged: (value) {
                         
                        },
                      
                      ),
                    ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20.0),
                      height: 60.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: ElevatedButton(
                        style:ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor
                        ),
                        child: Text(
                          task == null ? 'Add' : 'Update',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                        onPressed: (){
                          if(task != null){
                             todoProvider.editTask(index!, todoProvider.controller.text, task!.isCompleted).then((value){
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Todo Updated")));
                             Navigator.pop(context);
                            });
                          }else{
                             todoProvider.addTask().then((value){
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Todo added")));
                                Navigator.pop(context);
                          });
                          }
                         
                        },
                      ),
                    ),
                    task != null
                        ? Container(
                            margin: const EdgeInsets.symmetric(vertical: 0.0),
                            height: 60.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: ElevatedButton(
                               style:ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent
                              ),
                               child: const Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                              onPressed: (){
                                 todoProvider.deleteTask(index!).then((value){
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Task Deleted")));
                                     Navigator.pop(context);
                                });
                              },
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
