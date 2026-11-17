import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';

import 'package:fynza/features/backup/domain/models/auto_backup_frequency.dart';
import 'package:fynza/features/backup/domain/models/backup_file_info.dart';
import 'package:fynza/features/backup/domain/models/backup_failure.dart';
import 'package:fynza/features/backup/domain/models/picked_backup.dart';
import 'package:fynza/features/backup/domain/models/backup_summary.dart';
import 'package:fynza/features/backup/domain/repositories/backup_repository.dart';
import 'package:fynza/features/backup/domain/repositories/backup_workflow_repository.dart';
import 'package:fynza/features/backup/presentation/view_models/backup_view_model.dart';

class FakeBackupRepository implements BackupRepository {
  bool shouldFailRestore = false;
  bool shouldFailCreate = false;

  @override
  Future<Uint8List> createBackupBytes({String appVersion = '1.0.0'}) async {
    if (shouldFailCreate) {
      throw const StorageErrorFailure('Disk full');
    }
    return Uint8List.fromList([1, 2, 3]);
  }

  @override
  Future<BackupSummary> inspectBackup(Uint8List bytes) async {
    return BackupSummary(
      formatVersion: 1,
      appVersion: '1.0.0',
      dbSchemaVersion: 1,
      createdAt: DateTime.utc(2026, 10, 10),
      categoryCount: 5,
      transactionCount: 10,
      budgetCount: 2,
    );
  }

  @override
  Future<void> restoreBackup(Uint8List bytes) async {
    if (shouldFailRestore) {
      throw const CorruptDataFailure('Invalid data in backup');
    }
  }

  @override
  Future<void> createAutoBackup({String appVersion = '1.0.0'}) async {}

  @override
  Future<void> deleteBackupFile(String path) async {}

  @override
  Future<String> getBackupDirectoryPath() async => '/mock/backups';

  @override
  Future<({int fileCount, int totalSizeBytes})> getStorageUsage() async =>
      (fileCount: 2, totalSizeBytes: 2048);

  @override
  Future<List<BackupFileInfo>> listAutoBackups() async => [];
}

class FakeBackupWorkflowRepository implements BackupWorkflowRepository {
  AutoBackupFrequency frequency = AutoBackupFrequency.every12Hours;

  @override
  AutoBackupFrequency getFrequency() => frequency;

  @override
  DateTime? getLastAutoBackupAt() => null;

  @override
  Future<String?> saveManualBackup(Uint8List bytes) async => 'backup.expbak';

  @override
  Future<PickedBackup?> pickAndInspectBackupFile() async => null;

  @override
  Future<PickedBackup?> inspectFile(String path) async => null;

  @override
  Future<void> setFrequency(AutoBackupFrequency value) async {
    frequency = value;
  }

  @override
  Future<void> shareBackup(String path) async {}
}

void main() {
  group('BackupViewModel Tests', () {
    late FakeBackupRepository fakeRepo;
    late FakeBackupWorkflowRepository workflowRepository;
    late BackupViewModel viewModel;

    setUp(() {
      fakeRepo = FakeBackupRepository();
      workflowRepository = FakeBackupWorkflowRepository();

      viewModel = BackupViewModel(fakeRepo, workflowRepository);
    });

    test('Loads initial state correctly', () async {
      await viewModel.loadState();
      expect(viewModel.state.backupDirectoryPath, '/mock/backups');
      expect(viewModel.state.frequency, AutoBackupFrequency.every12Hours);
      expect(viewModel.state.storageFileCount, 2);
      expect(viewModel.state.storageUsageBytes, 2048);
    });

    test('Updates frequency and persists in preferences', () async {
      await viewModel.setFrequency(AutoBackupFrequency.daily);
      expect(viewModel.state.frequency, AutoBackupFrequency.daily);
      expect(workflowRepository.frequency, AutoBackupFrequency.daily);
    });

    test('Restores successfully and updates state', () async {
      final summary = await fakeRepo.inspectBackup(Uint8List(0));
      final success = await viewModel.restoreBackup(
        Uint8List.fromList([1, 2, 3]),
        summary: summary,
      );

      expect(success, isTrue);
      expect(
        viewModel.state.successMessage,
        contains('Restored 10 transactions'),
      );
      expect(viewModel.state.isBusy, isFalse);
    });

    test('Maps failures to friendly user message on restore error', () async {
      fakeRepo.shouldFailRestore = true;
      final summary = await fakeRepo.inspectBackup(Uint8List(0));
      final success = await viewModel.restoreBackup(
        Uint8List.fromList([1, 2, 3]),
        summary: summary,
      );

      expect(success, isFalse);
      expect(
        viewModel.state.userErrorMessage,
        contains('Backup data is invalid: Invalid data in backup'),
      );
      expect(viewModel.state.isBusy, isFalse);
    });
  });
}
