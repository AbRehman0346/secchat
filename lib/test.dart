import 'package:flutter/material.dart';
import 'services/notification_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class Test extends StatefulWidget {
  Test({Key? key}) : super(key: key);
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Coflutter'),
        ),
        body: Container(
          child: Center(
            child: ElevatedButton(
              child: const Text('Notification'),
              onPressed: () async {
                try {
                  NotificationService().showNotification(
                      title: "Notification Title",
                      content: "Notification Content");
                } catch (e, s) {
                  print(s);
                }
              },
            ),
          ),
        ));
  }
}
