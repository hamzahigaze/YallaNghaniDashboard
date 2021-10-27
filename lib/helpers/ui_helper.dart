import 'package:flutter/material.dart';

class UIHelper {
  static showMessageDialogWithOkButton(BuildContext context, String message,
      [Function(dynamic) popCallBack]) async {
    await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('حسناً'),
              )
            ],
          );
        }).then(
      (value) => {if (popCallBack != null) popCallBack(value)},
    );
  }

  static Future<bool> showDeleteConfirmationDialog(BuildContext context,
      [itemName]) async {
    var result = await showConfirmationDialog(
      context,
      'هل أنت متأكد من حذف ${itemName ?? 'العنصر'} ؟',
    );

    return result;
  }

  static Future<bool> showConfirmationDialog(
      BuildContext context, String message) async {
    var result = await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (innerContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('نعم'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('لا'),
              ),
            ],
          ),
        );
      },
    );

    return result;
  }
}
