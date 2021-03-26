import 'package:helper_set/src/helper/ConstantHelper.dart';

class LocalErrorModel {
  String title;
  String message;

  int type = ConstantHelper.errorOthers;
  bool forceLogout = false;

  LocalErrorModel(
    this.message, {
    this.title = "Terjadi Kesalahan",
    this.type = ConstantHelper.errorOthers,
    this.forceLogout = false,
  });
}
