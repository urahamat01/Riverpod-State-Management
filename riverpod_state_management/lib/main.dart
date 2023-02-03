import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

extension OptionalInfixAddition<T extends num> on T? {
  T? operator +(T? other) {
    final shadow = this;
    if (shadow != null) {
      return shadow + (other ?? 0) as T;
    } else {
      return null;
    }
  }
}

void testIt() {
  final int? int1 = 1;
  final int? int2 = null;
  final result = int1 + int2;
  if (kDebugMode) {
    print(result);
  }
}

class Counter extends StateNotifier<int?> {
  Counter() : super(null);
  void increment() => state = state == null ? 1 : state + 1;

  int? get value => state;
}

final counterProvider =
    StateNotifierProvider<Counter, int?>((ref) => Counter());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    testIt();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Home Page'),
      // ),

      appBar: AppBar(
        title: Consumer(
          builder: (context, ref, child) {
            final counter = ref.watch(counterProvider);
            final text =
                counter == null ? 'Press the button' : counter.toString();
            return Text(text);
          },
        ),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: ref.read(counterProvider.notifier).increment,
            child: const Text('Increment Counter'),
          ),
        ],
      ),
    );
  }
}
