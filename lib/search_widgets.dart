import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:searchapp/api_search.dart';
import 'package:searchapp/loading.dart';

var _searchTextController = TextEditingController();

Widget searchBar() {
  return Consumer(builder: (context, ref, _) {
    final searchTextNotifier = ref.watch(searchProvider.notifier);
    final loadingState = ref.watch(loadingProvider);
    return TextFormField(
      controller: _searchTextController,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 18,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18.0),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        //検索ボタン
        suffixIcon: IconButton(
          onPressed: () {
            searchTextNotifier.getSearchText(
              _searchTextController.text,
              ref.watch(sortStateProvider),
            );
          },
          //検索中はくるくるにする
          icon: loadingState
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                )
              : const Icon(Icons.search),
        ),
        hintText: 'Search',
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
      ),
      onFieldSubmitted: (_) {
        searchTextNotifier.getSearchText(
          _searchTextController.text,
          ref.watch(sortStateProvider),
        );
      },
      onEditingComplete: () {
        searchTextNotifier.getSearchText(
            _searchTextController.text, ref.watch(sortStateProvider));
      },
    );
  });
}

Widget sortList() {
  return Consumer(builder: (context, ref, _) {
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
          searchTextNotifier.getSearchText(
              _searchTextController.text, ref.watch(sortStateProvider));
        });
  });
}
