import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:searchapp/theme_change.dart';
import 'search_page.dart';
import 'package:google_fonts/google_fonts.dart';


// main関数
void main() {
  runApp(const ProviderScope(child: MyApp()));
}
class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'Flutter SearchApp',
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: GoogleFonts.mPlus1TextTheme(
            ThemeData(brightness: Brightness.light).textTheme
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.mPlus1TextTheme(
            ThemeData(brightness: Brightness.dark).textTheme
        ),
      ),
      themeMode: themeMode,
      // SearchAppを表示
      home: const SearchPage(),
    );
  }
}
