import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:async';

import '../../core/di/database_provider.dart';
import '../../features/auto_capture/domain/repositories/capture_control_repository.dart';

final autoCaptureEnabledProvider =
    StateNotifierProvider<AutoCaptureEnabledNotifier, bool>((ref) {
      return AutoCaptureEnabledNotifier(
        ref.watch(captureControlRepositoryProvider),
      );
    });

class AutoCaptureEnabledNotifier extends StateNotifier<bool> {
  final CaptureControlRepository _repository;
  late final StreamSubscription<bool> _subscription;

  AutoCaptureEnabledNotifier(this._repository)
    : super(_repository.isMasterEnabled()) {
    _subscription = _repository.watchMasterEnabled().listen((enabled) {
      state = enabled;
    });
  }

  Future<void> setEnabled(bool enabled) async {
    await _repository.setMasterEnabled(enabled);
    state = enabled;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
