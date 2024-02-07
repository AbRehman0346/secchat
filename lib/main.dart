import 'package:flutter/material.dart';
import 'package:secchat/screens/home_screen.dart';
import 'package:secchat/screens/login_screen.dart';
import 'package:secchat/services/firebase_auth_services.dart';
import 'package:secchat/constants/AppConstants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'constants/notification_constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AwesomeNotifications().initialize(null, [
    //Popup Notification Channel with maximum importance.
    NotificationChannel(
      channelKey: NotificationChannelKeys.popupNotificationChannelKey,
      channelName: NotificationChannelKeys.popupNotificationChannelName,
      channelDescription: NotificationChannelKeys.popupNotificationChannelDes,
      playSound: true,
      ledColor: Colors.white,
      enableLights: true,
      enableVibration: true,
      importance: NotificationImportance.Max,
    ),

    //Basic Notification Channel.
    NotificationChannel(
      channelKey: NotificationChannelKeys.basicNotificationChannelKey,
      channelName: NotificationChannelKeys.basicNotificationChannelName,
      channelDescription: NotificationChannelKeys.basicNotificationChannelDes,
      playSound: true,
      ledColor: Colors.white,
      enableLights: true,
      enableVibration: true,
      importance: NotificationImportance.Max,
    ),
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Screen Height = 752.0
    // Screen Width = 360.0
    return InAppNotification(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Secret Chat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: Test(),
        home: StreamBuilder(
            stream: FirebaseAuthServices().firebaseAuth.authStateChanges(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                //Pre-Data Collection
                AppContent.user = snapshot.data;
                return const HomeScreen();
              }
              return const LoginScreen();
            }),
      ),
    );
  }
}
