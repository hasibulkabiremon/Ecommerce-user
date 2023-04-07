
import 'package:ecom_user_class/pages/cart_page.dart';
import 'package:ecom_user_class/pages/checkout_page.dart';
import 'package:ecom_user_class/pages/order_successful_page.dart';
import 'package:ecom_user_class/pages/otp_verification_page.dart';
import 'package:ecom_user_class/pages/user_profile.dart';
import 'package:ecom_user_class/providers/cart_provider.dart';
import 'package:ecom_user_class/providers/notification_provider.dart';
import 'package:ecom_user_class/providers/product_provider.dart';
import 'package:ecom_user_class/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'pages/launcher_page.dart';
import 'pages/login_page.dart';
import 'pages/order_page.dart';
import 'pages/product_details_page.dart';
import 'pages/view_product_page.dart';
import 'providers/order_provider.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('RECIEVED DATA: ${message.data['KEY']}');

  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  print('FCM TOKEN $fcmToken');
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ProductProvider()),
    ChangeNotifierProvider(create: (_) => OrderProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
    ChangeNotifierProvider(create: (_) => NotificationProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!.requestPermission();
    AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ic_notifications');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    WidgetsBinding.instance.addObserver(this);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null){
        print('Message also contained a notification: ${message.notification}');
        _sendNotifications(message);
      }
    });

    setupInteractedMessage();
    // TODO: implement initState
    super.initState();
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['key'] == 'order') {
      Navigator.pushNamed(context, OrderPage.routeName,
      );
    }
  }

  void _sendNotifications(RemoteMessage message) async {
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



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.mavenProTextTheme(),
        primarySwatch: Colors.blue,
      ),
      builder: EasyLoading.init(),
      initialRoute: LauncherPage.routeName,
      routes: {
        LauncherPage.routeName: (_) => const LauncherPage(),
        LoginPage.routeName: (_) => const LoginPage(),
        ViewProductPage.routeName: (_) => const ViewProductPage(),
        ProductDetailsPage.routeName: (_) => const ProductDetailsPage(),
        OrderPage.routeName: (_) => const OrderPage(),
        UserProfile.routeName: (_) => const UserProfile(),
        OtpVerificationPage.routeName: (_) => const OtpVerificationPage(),
        CheckoutPage.routeName: (_) => const CheckoutPage(),
        CartPage.routeName: (_) => const CartPage(),
        OrderSuccessfulPage.routeName: (_) => const OrderSuccessfulPage(),
      },
    );
  }
}
