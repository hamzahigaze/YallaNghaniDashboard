import 'package:flutter/material.dart';

class FormDialogBase extends StatelessWidget {
  const FormDialogBase({this.child, Key key}) : super(key: key);

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 600 ? 300 : 80,
          vertical: 80,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 50,
            vertical: 25,
          ),
          child: child,
        ),
      ),
    );
  }
}
