import 'package:ecom_user_class/pages/checkout_page.dart';
import 'package:ecom_user_class/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../customwidgets/cart_item_view.dart';
import '../utils/constants.dart';

class CartPage extends StatelessWidget {
  static const String routeName= '/cartPage';
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text('Cart List',style: TextStyle(color: Colors.black),),
      ),
      body: Consumer<CartProvider>(
        builder: (context, provider, child) => Column(
          children: [
            Expanded(child: ListView.builder(
              itemCount: provider.cartList.length,
                itemBuilder: (context, index) {
                  final cartModel = provider.cartList[index];
                  return CartItemView(cartModel: cartModel, provider: provider,);
                },
            )),
            Card(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Sub Total: $currencySymbol${provider.getCartSubTotal()}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  OutlinedButton(
                    onPressed:provider.totalItemsInCart == 0 ? null : () {
                      Navigator.pushNamed(context, CheckoutPage.routeName);
                    },
                    child: Text('CHECKOUT'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
