// ignore_for_file: constant_identifier_names

import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:workmanager/workmanager.dart';

const TASK_ONE = 'me.niloybiswas.task_1';
const TASK_ONE_ISOLATE_CHANNEL = 'me.niloybiswas.task_1.isolate.channel';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    debugPrint("[ BACKGROUND ] Native called background task: $task");
    try {
      switch (task) {
        case TASK_ONE:
          debugPrint("[ BACKGROUND ] Task 1 was triggered...");
          final sendPort =
              IsolateNameServer.lookupPortByName(TASK_ONE_ISOLATE_CHANNEL);
          if (sendPort != null) {
            sendPort.send('Message from background');
            debugPrint('[ BACKGROUND ] message sent...');
          }
          debugPrint('[ BACKGROUND ] Task 1 finished');
          break;
      }
      return Future.value(true);
    } catch (ex) {
      debugPrint(
          '[ BACKGROUND ] Task failed with exception => ${ex.toString()}');
      return Future.value(true);
    }
  });
}

void hasFinishedBackgroundTask({required Function updateCallback}) {
  final port = ReceivePort();
  if (IsolateNameServer.lookupPortByName(TASK_ONE_ISOLATE_CHANNEL) != null) {
    IsolateNameServer.removePortNameMapping(TASK_ONE_ISOLATE_CHANNEL);
  }
  IsolateNameServer.registerPortWithName(
      port.sendPort, TASK_ONE_ISOLATE_CHANNEL);
  port.listen((message) {
    debugPrint('[ MAIN ] [$TASK_ONE_ISOLATE_CHANNEL] => got $message');
    if (message != null) {
      updateCallback();
    }
  });
}
