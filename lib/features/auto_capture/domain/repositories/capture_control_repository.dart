import '../models/capture_status.dart';

abstract interface class CaptureControlRepository {
  CaptureMode getMode();
  Future<void> setMode(CaptureMode mode);
  bool isMasterEnabled();
  Stream<bool> watchMasterEnabled();
  Future<void> setMasterEnabled(bool enabled);
  List<String> getIgnoredSenders();
  Future<void> removeIgnoredSender(String sender);
  Future<bool> isPermissionGranted();
  Future<bool> openPermissionSettings();
  Future<void> drainNow();
}
