import 'package:flutter_test/flutter_test.dart';
import 'package:fynza/features/auto_capture/domain/models/capture_item.dart';
import 'package:fynza/features/auto_capture/domain/models/capture_status.dart';
import 'package:fynza/features/auto_capture/domain/models/raw_notification.dart';
import 'package:fynza/features/auto_capture/domain/repositories/capture_control_repository.dart';
import 'package:fynza/features/auto_capture/domain/repositories/capture_repository.dart';
import 'package:fynza/features/auto_capture/presentation/view_models/auto_capture_settings_view_model.dart';
import 'package:fynza/features/auto_capture/presentation/view_models/capture_inbox_view_model.dart';
import 'package:fynza/shared/models/transaction_type.dart';

class FakeCaptureRepository implements CaptureRepository {
  final CaptureItem item = CaptureItem(
    id: 1,
    amountCents: 5000,
    type: TransactionType.expense,
    occurredAt: DateTime(2026, 11),
    capturedAt: DateTime(2026, 11),
    sourcePackage: 'bank.app',
    sender: 'BANK',
    dedupeKey: 'key',
    status: CaptureStatus.pending,
  );
  int dismissedId = -1;
  bool deletedAll = false;

  @override
  Stream<List<CaptureItem>> watchPendingCaptures() => Stream.value([item]);

  @override
  Stream<int> watchPendingCount() => Stream.value(1);

  @override
  Stream<List<CaptureItem>> watchRecentlyAutoAdded({int limit = 10}) =>
      Stream.value(const []);

  @override
  Future<void> dismissCapture(int captureId) async {
    dismissedId = captureId;
  }

  @override
  Future<void> deleteAllCapturedData() async {
    deletedAll = true;
  }

  @override
  Future<void> ingest(List<RawNotification> notifications) async {}

  @override
  Future<void> confirmCapture(
    int captureId, {
    required int categoryId,
    String? note,
    DateTime? date,
    int? amountCents,
    TransactionType? type,
  }) async {}

  @override
  Future<void> undoDismiss(int id) async {}

  @override
  Future<void> undoAutoAdd(int id) async {}

  @override
  Future<void> ignoreSender(String sender) async {}

  @override
  Future<void> purgeOldCaptures({
    Duration retentionPeriod = const Duration(days: 90),
  }) async {}

  @override
  Future<int?> getSuggestedCategory(String counterparty) async => null;
}

class FakeCaptureControlRepository implements CaptureControlRepository {
  bool enabled = false;
  CaptureMode mode = CaptureMode.reviewFirst;
  bool permissionGranted = true;
  List<String> ignoredSenders = ['BANK'];
  int drainCalls = 0;
  bool permissionSettingsOpened = false;

  @override
  CaptureMode getMode() => mode;

  @override
  Future<void> setMode(CaptureMode value) async {
    mode = value;
  }

  @override
  bool isMasterEnabled() => enabled;

  @override
  Stream<bool> watchMasterEnabled() => Stream.value(enabled);

  @override
  Future<void> setMasterEnabled(bool value) async {
    enabled = value;
  }

  @override
  List<String> getIgnoredSenders() => ignoredSenders;

  @override
  Future<void> removeIgnoredSender(String sender) async {
    ignoredSenders = ignoredSenders.where((item) => item != sender).toList();
  }

  @override
  Future<bool> isPermissionGranted() async => permissionGranted;

  @override
  Future<bool> openPermissionSettings() async {
    permissionSettingsOpened = true;
    return true;
  }

  @override
  Future<void> drainNow() async {
    drainCalls++;
  }
}

void main() {
  test('capture inbox loads state and forwards inbox actions', () async {
    final captures = FakeCaptureRepository();
    final controls = FakeCaptureControlRepository();
    final viewModel = CaptureInboxViewModel(captures, controls);

    await Future<void>.delayed(Duration.zero);
    expect(viewModel.state.pendingItems.single.id, 1);
    expect(viewModel.state.isPermissionGranted, isTrue);
    expect(controls.drainCalls, 1);

    await viewModel.dismiss(1);
    await viewModel.openPermissionSettings();
    expect(captures.dismissedId, 1);
    expect(controls.permissionSettingsOpened, isTrue);
    viewModel.dispose();
  });

  test(
    'capture settings updates preferences and deletes captured data',
    () async {
      final captures = FakeCaptureRepository();
      final controls = FakeCaptureControlRepository();
      final viewModel = AutoCaptureSettingsViewModel(controls, captures);

      await Future<void>.delayed(Duration.zero);
      await viewModel.setMasterEnabled(true);
      await viewModel.setMode(CaptureMode.addAutomatically);
      await viewModel.removeIgnoredSender('BANK');
      await viewModel.requestPermission();
      await viewModel.deleteAllCapturedData();

      expect(viewModel.state.isMasterEnabled, isTrue);
      expect(viewModel.state.mode, CaptureMode.addAutomatically);
      expect(viewModel.state.ignoredSenders, isEmpty);
      expect(controls.permissionSettingsOpened, isTrue);
      expect(captures.deletedAll, isTrue);
      expect(viewModel.state.isLoading, isFalse);
      viewModel.dispose();
    },
  );
}
