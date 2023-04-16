import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'search_page.dart';

// main関数
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SearchApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // SearchAppを表示
      home: const SearchPage(),
    );
  }
}
