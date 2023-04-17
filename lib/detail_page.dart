import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailPage extends ConsumerWidget {
  final dynamic data;

  const DetailPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${data.name}'),
      ),
      body: Center(
        child: Column(children: [
          Image.network('${data.avatarUrl}'),
          Text('${data.language}'),
          Text('${data.stargazersCount}'),
          Text('${data.watchersCount}'),
          Text('${data.forksCount}'),
          Text('${data.openIssuesCount}'),
        ]),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
