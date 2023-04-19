import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';


class DetailPage extends ConsumerWidget {
  final dynamic data;
  const DetailPage({Key? key, required this.data}) : super(key: key);

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${data.fullName}'),
      ),
      body: Center(
        child: Column(children: [
          Text('${data.name}'),
          Image.network('${data.avatarUrl}'),
          Text('${data.language}'),
          Text('${data.stargazersCount}'),
          Text('${data.watchersCount}'),
          Text('${data.forksCount}'),
          Text('${data.openIssuesCount}'),
          Text('${data.description}'),
        TextButton(
            onPressed: () {
              _launchUrl('${data.url}');
            },
            child:Text('${data.url}'),
        ),
        ]),
      ),
    );
  }
}
