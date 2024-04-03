import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';

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

typedef CalcPiC = Double Function(Int32 precision);
typedef CalcPiDart = double Function(int precision);
typedef CReverse = Pointer<Utf8> Function(
  Pointer<Utf8> headerHex,
  Pointer<Utf8> targetHex,
);
typedef DartCReverse = Pointer<Utf8> Function(
  Pointer<Utf8> headerHex,
  Pointer<Utf8> targetHex,
);

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() async {
    final DynamicLibrary nativeAddLib = Platform.isAndroid
        ? DynamicLibrary.open('libminer_lib.so')
        : DynamicLibrary.process();

    // final calcPi = nativeAddLib.lookupFunction<CalcPiC, CalcPiDart>('calc_pi');
    // final result = calcPi(100000000);
    // print(result);

    final minerHeader =
        nativeAddLib.lookupFunction<CReverse, DartCReverse>('minerHeader');
    final result1 = minerHeader(
        '010000004944469562ae1c2c74d9a535e00b6f3e40ffbad4f2fda3895501b582000000007a06ea98cd40ba2e3288262b28638cec5337c1456aaf5eedc8e9e5a20f062bdf8cc16649ffff001d00000000'
            .toNativeUtf8(),
        '00000000ffff0000000000000000000000000000000000000000000000000000'
            .toNativeUtf8());
    print(result1.toDartString());

    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
