import 'package:covid19_tracker/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomTopBar extends StatelessWidget {
  /// Creates a custom top bar used with stack widget.
  CustomTopBar({required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 8,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [pSwatch, pSwatch[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 15.0, bottom: 10.0, left: 10.0, right: 10.0),
          child: child,
        ),
      ),
    );
  }
}
