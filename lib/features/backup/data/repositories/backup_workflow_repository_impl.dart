import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/models/auto_backup_frequency.dart';
import '../../domain/models/picked_backup.dart';
import '../../domain/repositories/backup_repository.dart';
import '../../domain/repositories/backup_workflow_repository.dart';
import '../../domain/services/backup_services.dart';

class BackupWorkflowRepositoryImpl implements BackupWorkflowRepository {
  final BackupRepository _repository;
  final BackupPreferences _preferences;
  final BackupScheduleController _scheduler;
  final BackupFileNameGenerator _fileNameGenerator;

  const BackupWorkflowRepositoryImpl(
    this._repository,
    this._preferences,
    this._scheduler,
    this._fileNameGenerator,
  );

  @override
  AutoBackupFrequency getFrequency() => _preferences.getFrequency();

  @override
  DateTime? getLastAutoBackupAt() => _preferences.getLastAutoBackupAt();

  @override
  Future<String?> saveManualBackup(Uint8List bytes) async {
    final fileName = _fileNameGenerator.generateManualFileName();
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Save backup file',
      fileName: fileName,
      type: FileType.any,
      bytes: bytes,
    );
    if (path == null) return null;

    final file = File(path);
    if (!await file.exists() || await file.length() == 0) {
      await file.writeAsBytes(bytes, flush: true);
    }
    return fileName;
  }

  @override
  Future<PickedBackup?> pickAndInspectBackupFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;

    final pickedFile = result.files.first;
    Uint8List? bytes = pickedFile.bytes;
    if (bytes == null && pickedFile.path != null) {
      bytes = await File(pickedFile.path!).readAsBytes();
    }
    if (bytes == null || bytes.isEmpty) {
      throw const FileSystemException('The chosen file could not be read.');
    }

    return PickedBackup(
      bytes: bytes,
      summary: await _repository.inspectBackup(bytes),
      fileName: pickedFile.name,
    );
  }

  @override
  Future<PickedBackup?> inspectFile(String path) async {
    final file = File(path);
    final bytes = await file.readAsBytes();
    return PickedBackup(
      bytes: bytes,
      summary: await _repository.inspectBackup(bytes),
      fileName: file.uri.pathSegments.last,
    );
  }

  @override
  Future<void> setFrequency(AutoBackupFrequency frequency) =>
      _scheduler.updateSchedule(frequency);

  @override
  Future<void> shareBackup(String path) async {
    await Share.shareXFiles([XFile(path)], subject: 'Fynza Backup');
  }
}
