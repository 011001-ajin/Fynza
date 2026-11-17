import 'dart:typed_data';

import '../models/auto_backup_frequency.dart';
import '../models/picked_backup.dart';

abstract interface class BackupWorkflowRepository {
  AutoBackupFrequency getFrequency();
  DateTime? getLastAutoBackupAt();
  Future<String?> saveManualBackup(Uint8List bytes);
  Future<PickedBackup?> pickAndInspectBackupFile();
  Future<PickedBackup?> inspectFile(String path);
  Future<void> setFrequency(AutoBackupFrequency frequency);
  Future<void> shareBackup(String path);
}
