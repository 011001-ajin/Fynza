import '../../domain/models/capture_status.dart';
import '../../domain/repositories/capture_control_repository.dart';
import '../../domain/services/capture_services.dart';

class CaptureControlRepositoryImpl implements CaptureControlRepository {
  final CapturePreferences _preferences;
  final CapturePermissionService _permissions;
  final CaptureQueueDrainer _queueDrainer;

  const CaptureControlRepositoryImpl(
    this._preferences,
    this._permissions,
    this._queueDrainer,
  );

  @override
  CaptureMode getMode() => _preferences.getMode();

  @override
  Future<void> setMode(CaptureMode mode) => _preferences.setMode(mode);

  @override
  bool isMasterEnabled() => _preferences.isMasterEnabled();

  @override
  Stream<bool> watchMasterEnabled() => _preferences.watchMasterEnabled();

  @override
  Future<void> setMasterEnabled(bool enabled) =>
      _preferences.setMasterEnabled(enabled);

  @override
  List<String> getIgnoredSenders() => _preferences.getIgnoredSenders();

  @override
  Future<void> removeIgnoredSender(String sender) =>
      _preferences.removeIgnoredSender(sender);

  @override
  Future<bool> isPermissionGranted() => _permissions.isPermissionGranted();

  @override
  Future<bool> openPermissionSettings() =>
      _permissions.openPermissionSettings();

  @override
  Future<void> drainNow() => _queueDrainer.drainNow();
}
