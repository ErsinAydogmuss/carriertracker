import 'package:flutter/cupertino.dart';
import '../models/recieve_message.dart';

class NotificationProvider with ChangeNotifier {
  final List<ReceivedMessage> _notificationList = [];
  int unseenNotificationCount = 0;

  List<ReceivedMessage> get notificationList => _notificationList;

  void addNotification(ReceivedMessage notification) {
    print("asdasdas");
    print(notification);
    _notificationList.insert(0, notification);
    unseenNotificationCount++;

    notifyListeners();
  }
}