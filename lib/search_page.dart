import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:searchapp/loading.dart';
import 'package:searchapp/theme_change.dart';
import 'api_search.dart';
import 'detail_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _searchTextController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('SearchApp'),
        actions: [
          Consumer(builder: (context, ref, _) {
            final themeMode = ref.watch(themeModeProvider);
            return Switch(
                value: themeMode == ThemeMode.dark,
                onChanged: (_) {
                  ref.read(themeModeProvider.notifier).toggleThemeMode();
                });
          })
        ],
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
            Consumer(builder: (context, ref, _) {
              final searchTextNotifier = ref.watch(searchProvider.notifier);
              final loadingState = ref.watch(loadingProvider);
              // 検索ボタン
              return ElevatedButton(
                  onPressed: () {
                    searchTextNotifier.getSearchText(_searchTextController.text,
                        ref.watch(sortStateProvider));
                  },
                  child: loadingState
                      ? const CircularProgressIndicator()
                      : const Text('検索'));
            }),
            Consumer(builder: (context, ref, _) {
              final searchTextNotifier = ref.watch(searchProvider.notifier);
              return DropdownButton<String>(
                  items: const [
                    DropdownMenuItem(
                      value: '',
                      child: Text('best match'),
                    ),
                    DropdownMenuItem(
                      value: 'stars',
                      child: Text('stars'),
                    ),
                    DropdownMenuItem(
                      value: 'forks',
                      child: Text('forks'),
                    ),
                    DropdownMenuItem(
                      value: 'help-wanted-issues',
                      child: Text('help-wanted-issues'),
                    ),
                    DropdownMenuItem(
                      value: 'updated',
                      child: Text('updated'),
                    ),
                  ],
                  value: ref.watch(sortStateProvider),
                  onChanged: (value) {
                    ref.read(sortStateProvider.notifier).state = value!;
                    searchTextNotifier.getSearchText(_searchTextController.text,
                        ref.watch(sortStateProvider));
                  });
            }),
            Consumer(builder: (context, ref, _) {
              final resultState = ref.watch(searchProvider);
              return Expanded(
                child: ListView.builder(
                  itemCount: resultState.length,
                  itemBuilder: (BuildContext context, int index) {
                    final result = resultState[index];
                    return GestureDetector(
                      child: ListTile(
                        title: Text(result.fullName),
                        subtitle: Text(result.description),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPage(data: result)),
                        );
                      },
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
