import 'dart:collection';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

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
      home: const Example5(),
    );
  }
}

@immutable
class Person {
  final String name;
  final int age;
  final String uuid;

  const Person({
    required this.name,
    required this.age,
    String? uuid,
  }) : uuid = uuid ?? const Uuid().v4();

  Person updated([String? name, int? age]) => Person(
        name: name ?? this.name,
        age: age ?? this.age,
        uuid: uuid,
      );

  String get displayName => '$name ($age years old';

  @override
  bool operator ==(covariant Person other) => uuid == other.uuid;
}

class DataModel extends ChangeNotifier {
  final List<Person> _person = [];
  int get count => _person.length;

  UnmodifiableListView<Person> get person => UnmodifiableListView(_person);
}

class Example5 extends StatefulWidget {
  const Example5({Key? key}) : super(key: key);

  @override
  State<Example5> createState() => _Example5State();
}

class _Example5State extends State<Example5> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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
