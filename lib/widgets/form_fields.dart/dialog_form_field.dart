import 'package:flutter/material.dart';

class DialogFormField extends StatelessWidget {
  const DialogFormField({
    Key key,
    this.initialValue = '',
    this.label,
    this.textDirection = TextDirection.rtl,
    this.onChanged,
    this.maxLines = 1,
  }) : super(key: key);

  final String initialValue, label;
  final TextDirection textDirection;
  final Function(String value) onChanged;
  final int maxLines;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      width: 300,
      child: TextFormField(
        onChanged: onChanged,
        textDirection: textDirection,
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
        ),
        maxLines: maxLines,
      ),
    );
  }
}
