
import 'package:ecom_user_class/pages/cart_page.dart';
import 'package:ecom_user_class/pages/checkout_page.dart';
import 'package:ecom_user_class/pages/order_successful_page.dart';
import 'package:ecom_user_class/pages/otp_verification_page.dart';
import 'package:ecom_user_class/pages/user_profile.dart';
import 'package:ecom_user_class/providers/cart_provider.dart';
import 'package:ecom_user_class/providers/product_provider.dart';
import 'package:ecom_user_class/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'pages/launcher_page.dart';
import 'pages/login_page.dart';
import 'pages/order_page.dart';
import 'pages/product_details_page.dart';
import 'pages/view_product_page.dart';
import 'providers/order_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ProductProvider()),
    ChangeNotifierProvider(create: (_) => OrderProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
