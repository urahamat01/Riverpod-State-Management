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

enum City {
  stockholm,
  paris,
  tokyo,
}

Future<String> getWeather(City city) {
  return Future.delayed(
    const Duration(seconds: 1),
    () =>
        {
          City.stockholm: 'Stock',
          City.paris: 'Pari',
          City.tokyo: 'Toky',
        }[city] ??
        '?',
  );
}

final myProvider = Provider((_) => DateTime.now());

//Will be changed by the UI writes to this
final currentCityProvider = StateProvider<City?>(
  (ref) => null,
);

const unknownWeatherEmoji = 'Unknown';

//UI reads this
final weatherProvider = FutureProvider<dynamic>(
  (ref) {
    final city = ref.watch(currentCityProvider);
    if (city != null) {
      return getWeather(city);
    } else {
      return unknownWeatherEmoji;
    }
  },
);

const names = [
  'Alice',
  'Bob',
  'Charlie',
  'David',
  'Eve',
  'Fred',
  'Ginny',
  'Harriet',
  'Ileana',
  'Kincaid',
  'Larry',
];
final tickerProvider = StreamProvider(
  (ref) => Stream.periodic(
    const Duration(seconds: 1),
    (i) => i + 1,
  ),
);

final namesProvider = StreamProvider(
  (ref) => ref.watch(tickerProvider.stream).map(
        (event) => names.getRange(
          0,
          event,
        ),
      ),
);

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(
      weatherProvider,
    );
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
//Example 3
//       body: Column(
//         children: [
//           TextButton(
//             onPressed: ref.read(counterProvider.notifier).increment,
//             child: const Text('Increment Counter'),
//           ),
//
// //          currentWeather.when(data: (data) => Text(data, style:  TextStyle(fontFamily: 23),), error: (Object error, StackTrace stackTrace) {  }, )
//
//           currentWeather.when(
//             data: (data) => Text(
//               data,
//               style: const TextStyle(),
//             ),
//             //error: (Object) => Text('data'),
//             //error: (dynamic) =>  Text('Error ????'),
//             loading: () => const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: CircularProgressIndicator(),
//             ),
//             error: (Object error, StackTrace stackTrace) => Text('Error ??'),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: City.values.length,
//               itemBuilder: (context, index) {
//                 final city = City.values[index];
//                 final isSelected = city == ref.watch(currentCityProvider);
//
//                 return ListTile(
//                   title: Text(
//                     city.toString(),
//                   ),
//                   trailing: isSelected ? const Icon(Icons.check) : null,
//                   onTap: () =>
//                       ref.read(currentCityProvider.notifier,).state = city,
//                 );
//               },
//             ),
//           ),
//         ],
//       ),

        //Stream Provider Example 4
        body: Column(
          children: [],
        ));
  }
}
