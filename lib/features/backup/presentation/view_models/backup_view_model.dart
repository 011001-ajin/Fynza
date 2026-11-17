import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/database_provider.dart';
import '../../domain/models/auto_backup_frequency.dart';
import '../../domain/models/backup_file_info.dart';
import '../../domain/models/backup_failure.dart';
import '../../domain/models/backup_summary.dart';
import '../../domain/repositories/backup_repository.dart';
import '../../domain/models/picked_backup.dart';
import '../../domain/repositories/backup_workflow_repository.dart';

class BackupUiState {
  final bool isBusy;
  final String? busyStatus;
  final String backupDirectoryPath;
  final AutoBackupFrequency frequency;
  final DateTime? lastAutoBackupAt;
  final List<BackupFileInfo> autoBackups;
  final int storageUsageBytes;
  final int storageFileCount;
  final String? userErrorMessage;
  final String? successMessage;

  const BackupUiState({
    this.isBusy = false,
    this.busyStatus,
    this.backupDirectoryPath = '',
    this.frequency = AutoBackupFrequency.every12Hours,
    this.lastAutoBackupAt,
    this.autoBackups = const [],
    this.storageUsageBytes = 0,
    this.storageFileCount = 0,
    this.userErrorMessage,
    this.successMessage,
  });

  BackupUiState copyWith({
    bool? isBusy,
    String? busyStatus,
    bool clearBusyStatus = false,
    String? backupDirectoryPath,
    AutoBackupFrequency? frequency,
    DateTime? lastAutoBackupAt,
    List<BackupFileInfo>? autoBackups,
    int? storageUsageBytes,
    int? storageFileCount,
    String? userErrorMessage,
    bool clearError = false,
    String? successMessage,
    bool clearSuccess = false,
  }) {
    return BackupUiState(
      isBusy: isBusy ?? this.isBusy,
      busyStatus: clearBusyStatus ? null : (busyStatus ?? this.busyStatus),
      backupDirectoryPath: backupDirectoryPath ?? this.backupDirectoryPath,
      frequency: frequency ?? this.frequency,
      lastAutoBackupAt: lastAutoBackupAt ?? this.lastAutoBackupAt,
      autoBackups: autoBackups ?? this.autoBackups,
      storageUsageBytes: storageUsageBytes ?? this.storageUsageBytes,
      storageFileCount: storageFileCount ?? this.storageFileCount,
      userErrorMessage: clearError
          ? null
          : (userErrorMessage ?? this.userErrorMessage),
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
    );
  }
}

class BackupViewModel extends StateNotifier<BackupUiState> {
  final BackupRepository _repository;
  final BackupWorkflowRepository _workflowRepository;

  BackupViewModel(this._repository, this._workflowRepository)
    : super(const BackupUiState()) {
    loadState();
  }

  Future<void> loadState() async {
    final path = await _repository.getBackupDirectoryPath();
    final freq = _workflowRepository.getFrequency();
    final lastRun = _workflowRepository.getLastAutoBackupAt();
    final backups = await _repository.listAutoBackups();
    final usage = await _repository.getStorageUsage();

    state = state.copyWith(
      backupDirectoryPath: path,
      frequency: freq,
      lastAutoBackupAt: lastRun,
      autoBackups: backups,
      storageFileCount: usage.fileCount,
      storageUsageBytes: usage.totalSizeBytes,
      clearError: true,
      clearSuccess: true,
    );
  }

  Future<void> createManualBackup() async {
    if (state.isBusy) return;

    state = state.copyWith(
      isBusy: true,
      busyStatus: 'Creating backup...',
      clearError: true,
      clearSuccess: true,
    );

    try {
      final bytes = await _repository.createBackupBytes();
      final fileName = await _workflowRepository.saveManualBackup(bytes);
      if (fileName == null) {
        // User cancelled picker -> silent no-op
        state = state.copyWith(isBusy: false, clearBusyStatus: true);
        return;
      }

      state = state.copyWith(
        isBusy: false,
        clearBusyStatus: true,
        successMessage: 'Backup saved: $fileName',
      );
    } on BackupFailure catch (e) {
      state = state.copyWith(
        isBusy: false,
        clearBusyStatus: true,
        userErrorMessage: _mapFailureToMessage(e),
      );
    } catch (e) {
      state = state.copyWith(
        isBusy: false,
        clearBusyStatus: true,
        userErrorMessage: 'Failed to create backup: $e',
      );
    }
  }

  Future<PickedBackup?> pickAndInspectBackupFile() async {
    if (state.isBusy) return null;

    try {
      state = state.copyWith(
        isBusy: true,
        busyStatus: 'Validating backup...',
        clearError: true,
        clearSuccess: true,
      );

      final pickedBackup = await _workflowRepository.pickAndInspectBackupFile();

      state = state.copyWith(isBusy: false, clearBusyStatus: true);
      return pickedBackup;
    } on BackupFailure catch (e) {
      state = state.copyWith(
        isBusy: false,
        clearBusyStatus: true,
        userErrorMessage: _mapFailureToMessage(e),
      );
      return null;
    } catch (e) {
      state = state.copyWith(
        isBusy: false,
        clearBusyStatus: true,
        userErrorMessage: 'Invalid backup file: $e',
      );
      return null;
    }
  }

  Future<PickedBackup?> inspectExistingFile(String path) async {
    if (state.isBusy) return null;

    try {
      state = state.copyWith(
        isBusy: true,
        busyStatus: 'Validating backup...',
        clearError: true,
        clearSuccess: true,
      );

      final pickedBackup = await _workflowRepository.inspectFile(path);

      state = state.copyWith(isBusy: false, clearBusyStatus: true);
      return pickedBackup;
    } on BackupFailure catch (e) {
      state = state.copyWith(
        isBusy: false,
        clearBusyStatus: true,
        userErrorMessage: _mapFailureToMessage(e),
      );
      return null;
    } catch (e) {
      state = state.copyWith(
        isBusy: false,
        clearBusyStatus: true,
        userErrorMessage: 'Invalid backup file: $e',
      );
      return null;
    }
  }

  Future<bool> restoreBackup(
    Uint8List bytes, {
    required BackupSummary summary,
  }) async {
    if (state.isBusy) return false;

    state = state.copyWith(
      isBusy: true,
      busyStatus: 'Restoring data...',
      clearError: true,
      clearSuccess: true,
    );

    try {
      await _repository.restoreBackup(bytes);

      await loadState();

      state = state.copyWith(
        isBusy: false,
        clearBusyStatus: true,
        successMessage:
            'Restored ${summary.transactionCount} transactions, ${summary.categoryCount} categories, and ${summary.budgetCount} budgets.',
      );
      return true;
    } on BackupFailure catch (e) {
      state = state.copyWith(
        isBusy: false,
        clearBusyStatus: true,
        userErrorMessage: _mapFailureToMessage(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isBusy: false,
        clearBusyStatus: true,
        userErrorMessage: 'Restore failed: $e',
      );
      return false;
    }
  }

  Future<void> setFrequency(AutoBackupFrequency frequency) async {
    try {
      await _workflowRepository.setFrequency(frequency);
      state = state.copyWith(frequency: frequency, clearError: true);
    } catch (error) {
      state = state.copyWith(
        userErrorMessage: 'Failed to update backup frequency: $error',
      );
    }
  }

  Future<void> deleteAutoBackup(String path) async {
    await _repository.deleteBackupFile(path);
    final backups = await _repository.listAutoBackups();
    final usage = await _repository.getStorageUsage();
    state = state.copyWith(
      autoBackups: backups,
      storageFileCount: usage.fileCount,
      storageUsageBytes: usage.totalSizeBytes,
      successMessage: 'Backup deleted',
    );
  }

  Future<void> shareAutoBackup(String path) async {
    try {
      await _workflowRepository.shareBackup(path);
    } catch (e) {
      state = state.copyWith(userErrorMessage: 'Failed to share backup: $e');
    }
  }

  void clearMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }

  String _mapFailureToMessage(BackupFailure failure) {
    return switch (failure) {
      InvalidFileFailure(:final message) => message,
      UnsupportedVersionFailure(:final message) => message,
      CorruptDataFailure(:final message) => 'Backup data is invalid: $message',
      StorageErrorFailure(:final message) => 'Storage error: $message',
      UnknownBackupFailure(:final message) => message,
    };
  }
}

final backupViewModelProvider =
    StateNotifierProvider<BackupViewModel, BackupUiState>((ref) {
      final repository = ref.watch(backupRepositoryProvider);
      final workflowRepository = ref.watch(backupWorkflowRepositoryProvider);
      return BackupViewModel(repository, workflowRepository);
    });
