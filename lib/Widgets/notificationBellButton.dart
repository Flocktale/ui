import 'package:flocktale/pages/NotificationPage.dart';
import 'package:flocktale/providers/notificationProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationBellButton extends StatelessWidget {
  final Function(Widget) navigateTo;

  const NotificationBellButton({Key key, this.navigateTo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (_, provider, __) {
        return IconButton(
          onPressed: () {
            if (navigateTo != null) {
              navigateTo(NotificationPage());
              provider.changeHighlighted(false);
            }
          },
          icon: Icon(
            provider.isHighlighted
                ? Icons.notifications_active
                : Icons.notifications_none_outlined,
            color: provider.isHighlighted ? Colors.redAccent : Colors.white,
          ),
        );
      },
    );
  }
}
