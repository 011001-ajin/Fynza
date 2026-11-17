import 'dart:typed_data';

import 'backup_summary.dart';

class PickedBackup {
  final Uint8List bytes;
  final BackupSummary summary;
  final String fileName;

  const PickedBackup({
    required this.bytes,
    required this.summary,
    required this.fileName,
  });
}
