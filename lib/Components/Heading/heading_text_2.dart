import 'package:flutter/material.dart';
import 'package:ourtalks/main.dart';

class HeadingText2 extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color? textColor;
  const HeadingText2(
      {super.key, required this.text, this.style, this.textColor});

  @override
  Widget build(BuildContext context) {
    return // TEXT
        Text(
      text,
      style: style ??
          cnstSheet.textTheme.fs15Normal
              .copyWith(color: textColor ?? cnstSheet.colors.white),
    );
  }
}
