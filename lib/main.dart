import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_dapp/home_screen.dart';
import 'package:note_dapp/provider/todo_provider.dart';

void main() {
   runApp(const ProviderScope(child: MyApp()));

}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
   ref.read(TodoProvider.provider).initialize();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo dapp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen()
    );
  }
}
