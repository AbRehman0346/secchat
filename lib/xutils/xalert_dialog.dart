import 'package:flutter/material.dart';

class XAlertDialog {
  void showYesNoAlertDialog({
    required BuildContext context,
    required String content,
    Function? onYes,
    Function? onNo,
  }) {
    _positiveNegativeAlertDialog(
      context: context,
      content: content,
      positiveButtonText: "Yes",
      negativeButtonText: "No",
      onPositive: onYes,
      onNegative: onNo,
    );
  }

  void showOkayCancelAlertDialog({
    required BuildContext context,
    required String content,
    required Function onOkay,
    required Function onCancel,
  }) {
    _positiveNegativeAlertDialog(
        context: context,
        content: content,
        positiveButtonText: "OKAY",
        negativeButtonText: "Cancel",
        onPositive: onOkay,
        onNegative: onCancel);
  }

  void _positiveNegativeAlertDialog({
    required BuildContext context,
    required String content,
    required String positiveButtonText,
    required String negativeButtonText,
    Function? onPositive,
    Function? onNegative,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text(content),
          actions: [
            ElevatedButton(
              onPressed: () {
                onNegative!();
              },
              child: Text(negativeButtonText),
            ),
            ElevatedButton(
              onPressed: () {
                onPositive!();
              },
              child: Text(positiveButtonText),
            ),
          ],
        );
      },
    );
  }
}
