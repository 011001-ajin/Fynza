import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/database_provider.dart';
import '../../domain/models/capture_status.dart';
import '../../domain/repositories/capture_repository.dart';
import '../../domain/repositories/capture_control_repository.dart';

class AutoCaptureSettingsState {
  final bool isMasterEnabled;
  final CaptureMode mode;
  final bool isPermissionGranted;
  final List<String> ignoredSenders;
  final bool isLoading;

  const AutoCaptureSettingsState({
    required this.isMasterEnabled,
    required this.mode,
    required this.isPermissionGranted,
    required this.ignoredSenders,
    this.isLoading = false,
  });

  AutoCaptureSettingsState copyWith({
    bool? isMasterEnabled,
    CaptureMode? mode,
    bool? isPermissionGranted,
    List<String>? ignoredSenders,
    bool? isLoading,
  }) {
    return AutoCaptureSettingsState(
      isMasterEnabled: isMasterEnabled ?? this.isMasterEnabled,
      mode: mode ?? this.mode,
      isPermissionGranted: isPermissionGranted ?? this.isPermissionGranted,
      ignoredSenders: ignoredSenders ?? this.ignoredSenders,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AutoCaptureSettingsViewModel
    extends StateNotifier<AutoCaptureSettingsState> {
  final CaptureControlRepository _controlRepository;
  final CaptureRepository _repository;

  AutoCaptureSettingsViewModel(this._controlRepository, this._repository)
    : super(
        AutoCaptureSettingsState(
          isMasterEnabled: _controlRepository.isMasterEnabled(),
          mode: _controlRepository.getMode(),
          isPermissionGranted: false,
          ignoredSenders: _controlRepository.getIgnoredSenders(),
        ),
      ) {
    refreshPermissionStatus();
  }

  Future<void> refreshPermissionStatus() async {
    final granted = await _controlRepository.isPermissionGranted();
    state = state.copyWith(
      isMasterEnabled: _controlRepository.isMasterEnabled(),
      mode: _controlRepository.getMode(),
      isPermissionGranted: granted,
      ignoredSenders: _controlRepository.getIgnoredSenders(),
    );
  }

  Future<void> setMasterEnabled(bool enabled) async {
    await _controlRepository.setMasterEnabled(enabled);
    state = state.copyWith(isMasterEnabled: enabled);
  }

  Future<void> setMode(CaptureMode mode) async {
    await _controlRepository.setMode(mode);
    state = state.copyWith(mode: mode);
  }

  Future<void> removeIgnoredSender(String sender) async {
    await _controlRepository.removeIgnoredSender(sender);
    state = state.copyWith(
      ignoredSenders: _controlRepository.getIgnoredSenders(),
    );
  }

  Future<void> requestPermission() async {
    await _controlRepository.openPermissionSettings();
  }

  Future<void> deleteAllCapturedData() async {
    state = state.copyWith(isLoading: true);
    await _repository.deleteAllCapturedData();
    state = state.copyWith(isLoading: false);
  }
}

final autoCaptureSettingsViewModelProvider =
    StateNotifierProvider.autoDispose<
      AutoCaptureSettingsViewModel,
      AutoCaptureSettingsState
    >((ref) {
      final controlRepository = ref.watch(captureControlRepositoryProvider);
      final repo = ref.watch(captureRepositoryProvider);
      return AutoCaptureSettingsViewModel(controlRepository, repo);
    });
