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
    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth < constraints.maxHeight
            ? _buildVertical(context)
            : _buildHorizontal(context);
      },
    );
  }

  Widget _buildVertical(BuildContext context) {
    // 縦向きの場合アイコンと詳細を縦に並べる
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('${data.fullName}'),
      ),
      body: Center(
        child: Column(children: [
          Expanded(
            flex: 2,
            child: icon(screenSize),
          ),
          Expanded(
            flex: 3,
            child: detail(screenSize),
          ),
        ]),
      ),
    );
  }

  Widget _buildHorizontal(BuildContext context) {
    // // 横向きの場合アイコンと詳細を横に並べる
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('${data.fullName}'),
      ),
      body: Center(
        child: Row(children: [
          Expanded(
            flex: 2,
            child: icon(screenSize),
          ),
          Expanded(
            flex: 3,
            child: detail(screenSize),
          ),
        ]),
      ),
    );
  }

  Widget icon(screenSize) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Image.network(
        '${data.avatarUrl}',
      ),
    );
  }

  Widget detail(screenSize) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(20),
      child: ListView(
        children: [
          Text('${data.name}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('言語'),
                    Text('star数'),
                    Text('Watcher数'),
                    Text('Fork数'),
                    Text('Issue数'),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${data.language}'),
                    Text('${data.stargazersCount}'),
                    Text('${data.watchersCount}'),
                    Text('${data.forksCount}'),
                    Text('${data.openIssuesCount}'),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '${data.description}',
            overflow: TextOverflow.clip,
          ),
          TextButton(
            onPressed: () {
              _launchUrl('${data.url}');
            },
            child: Text('${data.url}'),
          ),
        ],
      ),
    );
  }
}
