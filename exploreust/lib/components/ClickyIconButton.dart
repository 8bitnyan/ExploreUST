import 'package:flutter/material.dart';
import 'package:clicky_flutter/clicky_flutter.dart';
import 'package:clicky_flutter/styles.dart';

class ClickyIconButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final double? iconSize;

  const ClickyIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.padding,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Clicky(
      style: ClickyStyle(
        color: const Color(0xFFF9A825).withOpacity(0.1),
        durationIn: const Duration(milliseconds: 200),
        durationOut: const Duration(milliseconds: 800),
      ),
      child: IconButton(
        icon: icon,
        onPressed: onPressed,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        padding: padding ?? const EdgeInsets.all(8.0),
        iconSize: iconSize ?? 24.0,
      ),
    );
  }
}
