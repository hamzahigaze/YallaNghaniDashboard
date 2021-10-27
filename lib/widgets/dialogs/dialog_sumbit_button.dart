import 'package:flutter/material.dart';

class DialogSubmitButton extends StatelessWidget {
  const DialogSubmitButton(
      {Key key,
      this.alignment = Alignment.center,
      this.color = Colors.green,
      this.text = '',
      this.width = 120,
      this.onPressed})
      : super(key: key);

  final double width;
  final Alignment alignment;
  final Color color;
  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: color),
        child: Text(text),
        onPressed: onPressed,
      ),
    );
  }
}
