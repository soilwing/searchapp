import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:searchapp/loading.dart';

//検索ワード、結果の管理
class SearchNotifier extends StateNotifier<List<SearchResults>> {
  SearchNotifier(this._loadingNotifier) : super([]);

  final StateNotifier<bool> _loadingNotifier;

  Future<void> getSearchText(String searchText, String sortType) async {
    try {
      _loadingNotifier.state = true;
      final results = await githubSearch(searchText, sortType);
      state = results;
    } finally {
      _loadingNotifier.state = false;
    }
  }
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, List<SearchResults>>(
        (ref) => SearchNotifier(ref.watch(loadingProvider.notifier)));

//ソート
final sortStateProvider = StateProvider<String>((ref) => '');
final sortProvider = Provider<String>((ref) {
  final sortType = ref.watch(sortStateProvider);
  return sortType;
});
//GitHub APIを使用してリポジトリを検索
Future<List<SearchResults>> githubSearch(String searchText, String sort) async {
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
    print(response.statusCode);
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
    this.fullName,
    this.avatarUrl,
    this.language,
    this.stargazersCount,
    this.watchersCount,
    this.forksCount,
    this.openIssuesCount,
    this.description,
    this.url,
  );

  String name;
  String fullName;
  String avatarUrl;
  String language;
  int stargazersCount;
  int watchersCount;
  int forksCount;
  int openIssuesCount;
  String description;
  String url;

  factory SearchResults.fromJson(Map<String, dynamic> json) {
    final searchResults = SearchResults(
      json['name'] as String,
      json['full_name'] as String,
      json['owner']['avatar_url'] as String,
      json['language'] as String? ?? '不明',
      json['stargazers_count'] as int,
      0,
      json['forks_count'] as int,
      json['open_issues_count'] as int,
      json['description'] as String? ?? '',
      json['html_url'] as String,
    );
    searchResults.loadWatchersCount();
    return searchResults;
  }

  Future<void> loadWatchersCount() async {
    watchersCount = await getSubscribers(fullName);
  }
}
