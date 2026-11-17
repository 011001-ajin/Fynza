import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/database_provider.dart';
import '../../domain/models/capture_item.dart';
import '../../domain/models/raw_notification.dart';
import '../../domain/repositories/capture_repository.dart';
import '../../domain/repositories/capture_control_repository.dart';

class CaptureInboxState {
  final List<CaptureItem> pendingItems;
  final List<CaptureItem> recentlyAutoAdded;
  final bool isPermissionGranted;
  final bool isLoading;
  final String? errorMessage;

  const CaptureInboxState({
    this.pendingItems = const [],
    this.recentlyAutoAdded = const [],
    this.isPermissionGranted = true,
    this.isLoading = false,
    this.errorMessage,
  });

  CaptureInboxState copyWith({
    List<CaptureItem>? pendingItems,
    List<CaptureItem>? recentlyAutoAdded,
    bool? isPermissionGranted,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CaptureInboxState(
      pendingItems: pendingItems ?? this.pendingItems,
      recentlyAutoAdded: recentlyAutoAdded ?? this.recentlyAutoAdded,
      isPermissionGranted: isPermissionGranted ?? this.isPermissionGranted,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class CaptureInboxViewModel extends StateNotifier<CaptureInboxState> {
  final CaptureRepository _repository;
  final CaptureControlRepository _controlRepository;

  StreamSubscription<List<CaptureItem>>? _pendingSub;
  StreamSubscription<List<CaptureItem>>? _autoAddedSub;

  CaptureInboxViewModel(this._repository, this._controlRepository)
    : super(const CaptureInboxState(isLoading: true)) {
    _init();
  }

  void _init() {
    _pendingSub = _repository.watchPendingCaptures().listen(
      (items) {
        state = state.copyWith(pendingItems: items, isLoading: false);
      },
      onError: (e) {
        state = state.copyWith(
          errorMessage: 'Failed to load inbox items',
          isLoading: false,
        );
      },
    );

    _autoAddedSub = _repository.watchRecentlyAutoAdded().listen((items) {
      state = state.copyWith(recentlyAutoAdded: items);
    }, onError: (_) {});

    checkPermission();
    drain();
  }

  Future<void> checkPermission() async {
    final granted = await _controlRepository.isPermissionGranted();
    state = state.copyWith(isPermissionGranted: granted);
  }

  Future<void> drain() async {
    await _controlRepository.drainNow();
  }

  Future<void> dismiss(int id) async {
    await _repository.dismissCapture(id);
  }

  Future<void> undoDismiss(int id) async {
    await _repository.undoDismiss(id);
  }

  Future<void> undoAutoAdd(int id) async {
    await _repository.undoAutoAdd(id);
  }

  Future<void> ignoreSender(String sender) async {
    await _repository.ignoreSender(sender);
  }

  Future<void> ingestManualMessage(String text) async {
    await _repository.ingest([
      RawNotification(
        key: 'manual_${DateTime.now().millisecondsSinceEpoch}',
        packageName: 'com.google.android.apps.messaging',
        title: 'MANUAL-SMS',
        text: text,
        postTime: DateTime.now().millisecondsSinceEpoch,
      ),
    ]);
  }

  Future<void> openPermissionSettings() async {
    await _controlRepository.openPermissionSettings();
  }

  @override
  void dispose() {
    _pendingSub?.cancel();
    _autoAddedSub?.cancel();
    super.dispose();
  }
}

final captureInboxViewModelProvider =
    StateNotifierProvider.autoDispose<CaptureInboxViewModel, CaptureInboxState>(
      (ref) {
        final repo = ref.watch(captureRepositoryProvider);
        final controlRepository = ref.watch(captureControlRepositoryProvider);
        return CaptureInboxViewModel(repo, controlRepository);
      },
    );

final pendingCaptureCountProvider = StreamProvider.autoDispose<int>((ref) {
  final repo = ref.watch(captureRepositoryProvider);
  return repo.watchPendingCount();
});
