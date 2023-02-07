import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_user_class/auth/authservice.dart';
import 'package:ecom_user_class/models/address_model.dart';
import 'package:ecom_user_class/models/date_model.dart';
import 'package:ecom_user_class/models/order_model.dart';
import 'package:ecom_user_class/pages/order_successful_page.dart';
import 'package:ecom_user_class/pages/view_product_page.dart';
import 'package:ecom_user_class/providers/cart_provider.dart';
import 'package:ecom_user_class/providers/order_provider.dart';
import 'package:ecom_user_class/providers/user_provider.dart';
import 'package:ecom_user_class/utils/constants.dart';
import 'package:ecom_user_class/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  static const String routeName = '/checkout';

  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late OrderProvider orderProvider;
  late CartProvider cartProvider;
  late UserProvider userProvider;
  String paymentMenthodGroupValue = PaymentMethod.cod;
  String? city;
  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final zipCodeController = TextEditingController();

  @override
  void didChangeDependencies() {
    orderProvider = Provider.of<OrderProvider>(context);
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    _setAddress();
    super.didChangeDependencies();
  }

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
          buildHeaderSection('Order Summary'),
          buildOrderSummarysection(),
          buildHeaderSection('Delivery Address'),
          buildDeliveryAddressSection(),
          buildHeaderSection('Payment Method'),
          buildPaymentMethodSection(),
          ElevatedButton(onPressed: _saveOrder, child: Text('Place Order'))
        ],
      ),
    );
  }

  Widget buildHeaderSection(String title) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  Widget buildProductInfoSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: cartProvider.cartList
              .map((cartItem) => ListTile(
                    title: Text(cartItem.productName),
                    trailing:
                        Text('${cartItem.quantity}X${cartItem.salePrice}'),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget buildOrderSummarysection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            ListTile(
              title: Text('Sub-Total'),
              trailing:
                  Text('$currencySymbol${cartProvider.getCartSubTotal()}'),
            ),
            ListTile(
              title: Text(
                  'Discount(${orderProvider.orderConstantModel.discount}%)'),
              trailing: Text(
                  '-$currencySymbol${orderProvider.getDiscountAmount(cartProvider.getCartSubTotal())}'),
            ),
            ListTile(
              title: Text('Vat(${orderProvider.orderConstantModel.vat}%)'),
              trailing: Text(
                  '$currencySymbol${orderProvider.getVatAmount(cartProvider.getCartSubTotal())}'),
            ),
            ListTile(
              title: Text(
                  'Delivery Charge(${orderProvider.orderConstantModel.deliveryCharge}%)'),
              trailing: Text(
                  '$currencySymbol${orderProvider.orderConstantModel.deliveryCharge}'),
            ),
            const Divider(
              height: 2,
              color: Colors.black,
            ),
            ListTile(
              title: Text(
                'Grand Total',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              trailing: Text(
                  '$currencySymbol${orderProvider.getGrandTotal(cartProvider.getCartSubTotal())}'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDeliveryAddressSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              controller: addressLine1Controller,
              decoration: InputDecoration(hintText: 'Address Line 1'),
            ),
            TextField(
              controller: addressLine2Controller,
              decoration: InputDecoration(hintText: 'Address Line 2'),
            ),
            TextField(
              controller: addressLine2Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'ZipCode'),
            ),
            DropdownButton<String>(
              value: city,
              hint: Text('Select City'),
              isExpanded: true,
              onChanged: (value) {
                setState(() {
                  city = value;
                });
              },
              items: cities
                  .map((city) =>
                      DropdownMenuItem<String>(value: city, child: Text(city)))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildPaymentMethodSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Radio(
              value: PaymentMethod.cod,
              groupValue: paymentMenthodGroupValue,
              onChanged: (value) {
                setState(() {
                  paymentMenthodGroupValue = value!;
                });
              },
            ),
            Text(PaymentMethod.cod),
            Radio(
              value: PaymentMethod.online,
              groupValue: paymentMenthodGroupValue,
              onChanged: (value) {
                setState(() {
                  paymentMenthodGroupValue = value!;
                });
              },
            ),
            Text(PaymentMethod.online),
          ],
        ),
      ),
    );
  }

  Future<void> _saveOrder() async {
    if (addressLine1Controller.text.isEmpty) {
      showMsg(context, 'Please Enter Your Location');
      return;
    }
    if (zipCodeController.text.isEmpty) {
      showMsg(context, 'Please Enter Your Zipcode');
      return;
    }
    if (city == null) {
      showMsg(context, 'Please Enter Your City');
      return;
    }
    EasyLoading.show(status: 'Plaese wait');
    final orderModel = OrderModel(
      orderId: generatedOrderId,
      userId: AuthService.currentUser!.uid,
      orderStatus: OrderStatus.pending,
      paymentMethod: paymentMenthodGroupValue,
      grandTotal: orderProvider.getGrandTotal(cartProvider.getCartSubTotal()),
      discount: orderProvider.orderConstantModel.discount,
      VAT: orderProvider.orderConstantModel.vat,
      deliveryCharge: orderProvider.orderConstantModel.deliveryCharge,
      orderDate: DateModel(
        timestamp: Timestamp.fromDate(DateTime.now()),
        day: DateTime.now().day,
        month: DateTime.now().month,
        year: DateTime.now().year
      ),
      deliveryAddress: AddressModel(
        addressLine1: addressLine1Controller.text,
        addressLine2: addressLine2Controller.text,
        zipcode: zipCodeController.text,
        city: city,
      ),
      productDetails: cartProvider.cartList,
    );
    try{
      await orderProvider.saveOrder(orderModel);
      await cartProvider.clearCart();
      EasyLoading.dismiss();
      Navigator.pushNamedAndRemoveUntil(context, OrderSuccessfulPage.routeName, ModalRoute.withName(ViewProductPage.routeName));
    }catch (error){
      EasyLoading.dismiss();
      print(error.toString());
      rethrow;
    }
  }

  @override
  void dispose() {
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    zipCodeController.dispose();
    super.dispose();
  }

  void _setAddress() {
    if (userProvider.userModel != null) {
      if (userProvider.userModel!.addressModel != null) {
        final address = userProvider.userModel!.addressModel!;
        addressLine1Controller.text = address.addressLine1!;
        addressLine2Controller.text = address.addressLine2!;
        zipCodeController.text = address.zipcode!;
        city = address.city;
      }
    }
  }
}
