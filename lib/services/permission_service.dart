import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

final List<Permission> _requiredPermissions = [
  Permission.microphone,
  Permission.storage
];

Future<bool> requestAppPermission() async {
  bool granted = true;
  Map<Permission, PermissionStatus> result =
      await _requiredPermissions.request();

  print(result);
  result.forEach((permission, permissionStatus) {
    granted = granted && permissionStatus == PermissionStatus.granted;
  });

  return granted;
}

/*void createAppStorage() async {
  print("create app storage");
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  final Directory extDir = await getExternalStorageDirectory();
  final String appDirPath = extDir.path + "/" + packageInfo.appName;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('appDirPath', appDirPath);
  Directory(appDirPath).createSync();
}*/
