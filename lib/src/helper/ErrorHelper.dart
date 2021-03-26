import 'package:flutter/cupertino.dart';
import 'package:helper_set/src/helper/ConstantHelper.dart';
import 'package:helper_set/src/model/LocalErrorModel.dart';
import 'package:helper_set/src/widget/PopUpInfo.dart';

class ErrorHelper {
  final BuildContext _context;
  final LocalErrorModel _localErrorModel;

  ErrorHelper(this._context, this._localErrorModel);

  handle(Function() onClickAction) {
    switch (_localErrorModel.type) {
      case ConstantHelper.errorConnection:
        showInternetProblem(_context, () {
          onClickAction();
        });
        break;
      default:
        showUnexpectedProblem(_context, () {
          onClickAction();
        }, desc: _localErrorModel.message);
        break;
    }
  }
}
