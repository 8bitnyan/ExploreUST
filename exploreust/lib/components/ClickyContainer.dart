import 'package:flutter/material.dart';
import 'package:clicky_flutter/clicky_flutter.dart';
import 'package:clicky_flutter/styles.dart';

class ClickyContainer extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final ClickyStyle? style;

  const ClickyContainer({Key? key, required this.child, this.onTap, this.style})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Clicky(
      style: style ?? const ClickyStyle(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: child,
      ),
    );
  }
}
