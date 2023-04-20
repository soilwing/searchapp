import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:searchapp/search_widgets.dart';
import 'package:searchapp/theme_change.dart';
import 'api_search.dart';
import 'detail_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searchBar(),
        actions: [
          //theme切り替え
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
            sortList(),
            Consumer(builder: (context, ref, _) {
              final resultState = ref.watch(searchProvider);
              return Expanded(
                child: ListView.builder(
                  itemCount: resultState.length,
                  itemBuilder: (BuildContext context, int index) {
                    final result = resultState[index];
                    return GestureDetector(
                      child: SizedBox(
                        height: 100,
                        child: Card(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: ListTile(
                            title: Text(result.fullName),
                            subtitle: Text(result.description, maxLines: 2),
                            trailing: const Icon(Icons.chevron_right),
                            isThreeLine: true,
                          ),
                        ),
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
