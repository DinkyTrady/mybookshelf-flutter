import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class ToastUtil {
  static void showToast(
    BuildContext context,
    String message, {
    bool success = true,
    GFToastPosition position = GFToastPosition.BOTTOM,
  }) {
    GFToast.showToast(
      message,
      context,
      toastPosition: position,
      backgroundColor: success ? Colors.green : Colors.red,
      textStyle: const TextStyle(color: Colors.white),
      toastBorderRadius: 8.0,
      toastDuration: 2,
    );
  }
}
