import 'package:ecom_user_class/providers/order_provider.dart';
import 'package:ecom_user_class/providers/user_provider.dart';
import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  static const String routeName = '/checkout';

  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late OrderProvider orderProvider;
  late UserProvider userProvider;
  String paymentMenthodGroupValue='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CheckOut Page'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          buildHeaderSection('Product Info'),
          buildProductInfoSection(),
          buildOrderSummarysection('Order Summary'),
        ],
      ),
    );
  }

  Widget buildHeaderSection(String title) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Text(title),
    );
  }
  buildProductInfoSection(){
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [],
        ),
      ),
    );
  }

  buildOrderSummarysection(String s) {}
}
