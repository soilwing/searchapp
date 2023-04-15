// Import文で必要なパッケージを読み込む
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      home: const SearchApp(),
    );
  }
}

// 仮のProvider
final testProvider = Provider((ref) {
  return '';
});

class SearchApp extends ConsumerWidget {
  const SearchApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SearchApp'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Text('検索ワード'),
            // 入力フォームの大きさ
            SizedBox(
              width: 300.0,
              height: 50.0,
              // 入力フォーム
              child: TextFormField(
                enabled: true,
                style: const TextStyle(color: Colors.black),
                maxLines: 1,
              ),
            ),
            // 検索ボタン
            ElevatedButton(
                onPressed: () {
                  // 検索ボタンが押された時の処理
                },
                child: const Text('検索'))
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
