import 'package:flutter/cupertino.dart';

class BottomSheetController extends ChangeNotifier {
  bool isChecked = false;

  updateIsChecked(bool value) {
    isChecked = value;
    notifyListeners();
  }
}
