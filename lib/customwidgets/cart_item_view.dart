import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_user_class/models/cart_model.dart';
import 'package:ecom_user_class/models/product_model.dart';
import 'package:ecom_user_class/providers/cart_provider.dart';
import 'package:ecom_user_class/utils/constants.dart';
import 'package:flutter/material.dart';

class CartItemView extends StatelessWidget {
  final CartModel cartModel;
  final CartProvider provider;

  const CartItemView(
      {Key? key, required this.cartModel, required this.provider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              leading: CachedNetworkImage(
                width: 70,
                height: 70,
                imageUrl: cartModel.productImageUrl,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              title: Text(cartModel.productName),
              subtitle:
                  Text('Unit Price: $currencySymbol${cartModel.salePrice}'),
              trailing: IconButton(
                onPressed: () {},
                icon: Icon(Icons.delete),
              ),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      provider.decreaseQuantity(cartModel);
                    },
                    icon: Icon(
                      Icons.remove_circle,
                      size: 30,
                    )),
                Text(
                  '${cartModel.quantity}',
                  style: Theme.of(context).textTheme.headline6,
                ),
                IconButton(
                  onPressed: () {
                    provider.increaseQuantity(cartModel);
                  },
                  icon: Icon(
                    Icons.add_circle,
                    size: 30,
                  ),
                ),
                const Spacer(),
                Text(
                  '$currencySymbol${provider.priceWithQuantity(cartModel)}',
                  style: Theme.of(context).textTheme.headline6,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
