import 'package:helper_set/src/model/LocalErrorModel.dart';

class ConstantHelper {
  static const param1 = "param1";
  static const param2 = "param2";
  static const param3 = "param3";
  static const param4 = "param4";
  static const param5 = "param5";

  ///ERROR
  static const errorNotRegistered = 990010006;
  static const errorConnection = 0;
  static const errorOthers = 1;

  static final uploadErrorModel =
      LocalErrorModel("Beberapa file gagal diupload");
}
