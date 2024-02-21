import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:workmanager_example/background_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String stringToDisplay = "N/A";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workmanager with Isolate'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              child: const Text('Trigger Background Task'),
              onPressed: () async {
                hasFinishedBackgroundTask(updateCallback: () {
                  setState(() {
                    stringToDisplay = "Successful";
                  });
                });
                await Future.delayed(const Duration(seconds: 5));
                Workmanager().registerOneOffTask(TASK_ONE, TASK_ONE);
              },
            ),
            Text(
              'Status: $stringToDisplay',
              style: const TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  stringToDisplay = "N/A";
                });
              },
              child: const Text('Reset Status'),
            ),
          ],
        ),
      ),
    );
  }
}
