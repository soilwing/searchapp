import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingState extends StateNotifier<bool> {
  LoadingState() : super(false);
}

final loadingProvider =
    StateNotifierProvider<LoadingState, bool>((ref) => LoadingState());
