import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

class PermissionsBloc {
  BehaviorSubject<PermissionStatus> _storagePermissionStatus;

  BehaviorSubject<PermissionStatus> get storagePermissionStatus$ =>
      _storagePermissionStatus;

  PermissionsBloc() {
    _storagePermissionStatus = BehaviorSubject<PermissionStatus>();
    requestStoragePermission();
  }

  Future<void> requestStoragePermission() async {
    Map<PermissionGroup, PermissionStatus> permission =
        await PermissionHandler().requestPermissions(
      [
        PermissionGroup.storage,
      ],
    );
    final PermissionStatus state = permission.values.toList()[0];

    _storagePermissionStatus.add(state);
  }

  void dispose() {
    _storagePermissionStatus.close();
  }
}
