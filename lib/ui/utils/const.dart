import 'package:flutter/material.dart';

showLog(String str) {
  print("-> $str");
}

hideKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}