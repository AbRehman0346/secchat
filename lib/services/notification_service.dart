import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:in_app_notification/in_app_notification.dart';

import '../constants/notification_constants.dart';

class NotificationService {
  void showInAppNotification(BuildContext context) {
    InAppNotification.show(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        height: 20,
        child: const Text("Notification working."),
      ),
      context: context,
      duration: const Duration(
          seconds: NotificationConstants.infoNotificationDuration),
    );
  }

  void showNotification({
    required String title,
    required String content,
    String channelKey = NotificationChannelKeys.popupNotificationChannelKey,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: ++NotificationConstants.notificationKeyCounter,
        channelKey: channelKey,
        title: title,
        body: content,
      ),
    );
  }
}
