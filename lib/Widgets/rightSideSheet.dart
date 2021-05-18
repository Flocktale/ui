import 'package:flutter/material.dart';

class RightSideSheet extends StatelessWidget {
  static display(
    BuildContext context, {
    BoxDecoration sheetDecoration,
    Widget child,
  }) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return RightSideSheet(child, sheetDecoration);
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(1, 0), end: Offset(0, 0)).animate(animation1),
          child: child,
        );
      },
    );
  }

  final Widget child;
  final Decoration sheetDecoration;
  const RightSideSheet(this.child, this.sheetDecoration);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          height: double.infinity,
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: sheetDecoration ??
              BoxDecoration(
                color: Colors.black87,
                border: Border(
                  left: BorderSide(
                    color: Colors.white54,
                  ),
                ),
              ),
          child: child,
        ),
      ),
    );
  }
}
