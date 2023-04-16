import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

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
      //log(results.toString());
      inspect(results);
      return results;
    } else {
      return [];
    }
  } catch (e) {
    return [];
  }
}

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

  factory SearchResults.fromJson(Map<String, dynamic> json) => SearchResults(
    json['name'] as String,
    json['owner']['avatar_url'] as String,
    json['language'] as String?,
    json['stargazers_count'] as int,
    json['watchers_count'] as int,
    json['forks_count'] as int,
    json['open_issues_count'] as int,
  );

}
