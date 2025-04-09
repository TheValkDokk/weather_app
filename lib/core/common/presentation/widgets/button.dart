import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, required this.onPressed, required this.child});

  final Function() onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FilledButton(onPressed: onPressed, child: child);
  }
}
