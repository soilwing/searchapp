import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_search.dart';
class SearchPage extends ConsumerWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final resultState = ref.watch(searchProvider);
    final searchTextNotifier = ref.watch(searchProvider.notifier);
    var _searchTextController = TextEditingController();
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
                controller: _searchTextController,
                enabled: true,
                style: const TextStyle(color: Colors.black),
                maxLines: 1,
              ),
            ),
            // 検索ボタン
            ElevatedButton(
                onPressed: () {
                  searchTextNotifier.getSearchText(_searchTextController.text);
                },
                child: const Text('検索'))
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
