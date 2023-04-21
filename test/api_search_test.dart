import 'package:flutter_test/flutter_test.dart';

import '../lib/api_search.dart';

void main() {
  test('jsonからSearchResultsに変換', () {
    const json = {
      'name': 'repo',
      'full_name': 'owner/repo',
      'owner': {
        'avatar_url': 'https://avatars.githubusercontent.com/u/1234?v=4'
      },
      'language': 'Dart',
      'stargazers_count': 100,
      'forks_count': 50,
      'open_issues_count': 10,
      'description': 'これは説明です',
      'html_url': 'https://github.com/owner/repo',
    };
    final searchResults = SearchResults.fromJson(json);
    expect(searchResults.name, 'repo');
    expect(searchResults.fullName, 'owner/repo');
    expect(searchResults.avatarUrl,
        'https://avatars.githubusercontent.com/u/1234?v=4');
    expect(searchResults.language, 'Dart');
    expect(searchResults.stargazersCount, 100);
    expect(searchResults.watchersCount, 0);
    expect(searchResults.forksCount, 50);
    expect(searchResults.openIssuesCount, 10);
    expect(searchResults.description, 'これは説明です');
    expect(searchResults.url, 'https://github.com/owner/repo');
  });

  test('watchersCountの値が更新されているか', () async {
    const fullName = 'owner/repo';
    final watchersCount = await getSubscribers(fullName);
    final searchResults = SearchResults(
        'repo',
        fullName,
        'https://avatars.githubusercontent.com/u/1234?v=4',
        'Dart',
        100,
        0,
        50,
        10,
        'これは説明です',
        'https://github.com/owner/repo');
    await searchResults.loadWatchersCount();
    expect(searchResults.watchersCount, watchersCount);
  });
}
