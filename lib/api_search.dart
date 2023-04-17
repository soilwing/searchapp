import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

//検索ワード、結果の管理
class SearchNotifier extends StateNotifier<List<SearchResults>> {
  SearchNotifier() : super([]);

  Future<void> getSearchText(String searchText) async {
    final results = await githubSearch(searchText);
    state = results;
  }
}
final searchProvider =
    StateNotifierProvider<SearchNotifier, List<SearchResults>>(
  (ref) => SearchNotifier(),
);

//GitHub APIを使用してリポジトリを検索
Future<List<SearchResults>> githubSearch(String searchText) async {
  const sort = 'stars';
  final url =
      'https://api.github.com/search/repositories?sort=$sort&q=$searchText';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final itemList = data['items'] as List<dynamic>;
      final results = itemList
          .map((item) => SearchResults.fromJson(item as Map<String, dynamic>))
          .toList();
      return results;
    } else {
      return [];
    }
  } catch (e) {
    return [];
  }
}
// リポジトリ詳細からsubscribers_countの値を取得しWatcher数とする
// (watchers_countとstargazers_countに同じ値が設定されているため)
Future<int> getSubscribers(String fullName) async {
  final url = 'https://api.github.com/repos/$fullName';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['subscribers_count'];
    } else {
      return 0;
    }
  } catch (e) {
    return 0;
  }
}

//jsonから必要な値を抜き出し整形
class SearchResults {
  SearchResults(
    this.name,
    this.avatarUrl,
    this.language,
    this.stargazersCount,
    this.watchersCount,
    this.forksCount,
    this.openIssuesCount,
  );

  String name;
  String avatarUrl;
  String? language;
  int stargazersCount;
  int watchersCount;
  int forksCount;
  int openIssuesCount;

  factory SearchResults.fromJson(Map<String, dynamic> json) {
    final searchResults = SearchResults(
      json['full_name'] as String,
      json['owner']['avatar_url'] as String,
      json['language'] as String?,
      json['stargazers_count'] as int,
      0,
      json['forks_count'] as int,
      json['open_issues_count'] as int,
    );
    searchResults.loadWatchersCount();
    return searchResults;
  }

  Future<void> loadWatchersCount() async {
    watchersCount = await getSubscribers(name);
  }
}
