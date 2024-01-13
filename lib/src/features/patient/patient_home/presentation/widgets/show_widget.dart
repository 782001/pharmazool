 import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowWidget extends StatelessWidget {
  const ShowWidget({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(builder: Builder(
      builder: (context) {
        return child;
      },
    ));
  }
}
