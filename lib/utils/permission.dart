import 'package:permission_handler/permission_handler.dart';

Future<bool> checkPermission() async {
  try {
    var audioStatus = await Permission.storage.status;
    var photoStatus = await Permission.photos.status;

    if (audioStatus == PermissionStatus.granted && photoStatus == PermissionStatus.granted) {
      return true;
    } else {
      var audioResult = await Permission.storage.request();
      var photoResult = await Permission.photos.request();

      if (audioResult == PermissionStatus.granted && photoResult == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  } catch (e) {
    print(e);
    return false;
  }


}
