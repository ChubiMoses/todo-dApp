import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_dapp/add_task_screen.dart';
import 'package:note_dapp/model/task.dart';
import 'package:note_dapp/service/contract_service.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoProvider = ref.read(TodoProvider.provider);
    bool loading = ref.watch(TodoProvider.provider).loading;
    return WillPopScope(
      onWillPop: ()async{
        return true;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add_outlined),
          onPressed: (){
            Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>  AddTaskScreen(task: null,)));
          }
        ),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
          leading: const IconButton(
              icon: Icon(
                Icons.calendar_today_outlined,
                color: Colors.grey,
              ),
              onPressed: null),
          title:
          const Row(
            children: [
              Text(
                "Task",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                  letterSpacing: -1.2,
                ),
              ),
              Text(
                "Manager",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0,
                ),
              )
            ],
          ),
          centerTitle: false,
          elevation: 0,
          actions: [
            Container(
              margin: const EdgeInsets.all(0),
              child: IconButton(
                  icon: const Icon(Icons.history_outlined),
                  iconSize: 25.0,
                  color: Colors.black,
                  onPressed: (){
                    
                  })
            ),
            Container(
              margin: const EdgeInsets.all(6.0),
              child: IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  iconSize: 25.0,
                  color: Colors.black,
                  onPressed: () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const Settings()))),
            )
          ],
        ),
        body:loading ? 
          const Center(child: CircularProgressIndicator()) :
          ListView.builder(
            itemBuilder: (context, int index){
              Task task =  todoProvider.todos[index];
              return   ListTile(
                title: Text(
                  task.taskName,
                  style: TextStyle(
                    fontSize: 18.0,
                    decoration: !task.isCompleted
                        ? TextDecoration.none
                        : TextDecoration.lineThrough,
                  ),
                ),
                        
                trailing: Checkbox(
                  onChanged: (value) {
                    todoProvider.editTask(index, task.taskName, task.isCompleted ? false : true);
                  },
                  activeColor: Theme.of(context).primaryColor,
                  value: task.isCompleted ? true : false,
                ),
                onTap: (){
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>  AddTaskScreen(task: task, index: index)));
                }
              );
            }, 
        itemCount: todoProvider.taskCount),
      ),
    );
  }
}
