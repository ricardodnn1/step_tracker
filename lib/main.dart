import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:step_tracker/tacker_list_component.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TrackerListController controller;

  @override
  void initState() {
    super.initState();
    controller = TrackerListController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TrackerListComponent(
              steps: const [
                'Texto exemplo 1',
                'Texto exemplo 2',
                'Texto exemplo 3',
                'Texto exemplo 4',
                'Texto exemplo 5',
                'Texto exemplo 6',
                'Texto exemplo 7',
                'Texto exemplo 8',
                'Texto exemplo 9',
                'Texto exemplo 10',
              ],
              controller: controller,
            ),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
              onPressed: controller.next,
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
