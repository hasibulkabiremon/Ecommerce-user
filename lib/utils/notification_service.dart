import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationService(){
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!.requestPermission();
    AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ic_notifications');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void sendNotifications(RemoteMessage message) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('channel01', 'description',
        channelDescription: 'Test',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker'
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(
        android: androidNotificationDetails
    );

    await flutterLocalNotificationsPlugin.show(
        0, message.notification!.title, message.notification!.body, notificationDetails, payload: 'item x');
  }

}