import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_user_class/main.dart';
import 'package:ecom_user_class/pages/product_details_page.dart';
import 'package:ecom_user_class/providers/cart_provider.dart';
import 'package:ecom_user_class/providers/user_provider.dart';
import 'package:ecom_user_class/utils/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import '../customwidgets/cart_bubble_view.dart';
import '../customwidgets/main_drawer.dart';
import '../customwidgets/product_grid_item_view.dart';
import '../models/category_model.dart';
import '../providers/order_provider.dart';
import '../providers/product_provider.dart';
import 'order_page.dart';

class ViewProductPage extends StatefulWidget {
  static const String routeName = '/viewproduct';

  const ViewProductPage({Key? key}) : super(key: key);

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  CategoryModel? categoryModel;

  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print('Got a message whilst in the foreground!');
      // print('Message data: ${message.data}');

      if (message.notification != null){
        // print('Message also contained a notification: ${message.notification}');
        NotificationService service = NotificationService();
        service.sendNotifications(message);
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
    if (message.data['key'] == 'product') {
      final id = message.data['value'];
      Provider.of<ProductProvider>(context,listen: false).getProductById(id).then((productModel) =>
          Navigator.pushNamed(context, ProductDetailsPage.routeName, arguments: productModel
          )
      );

    }
  }

  @override
  void didChangeDependencies() {
    Provider.of<ProductProvider>(context, listen: false).getAllCategories();
    Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    Provider.of<OrderProvider>(context, listen: false).getOrderConstants();
    Provider.of<OrderProvider>(context, listen: false).getAllOrders();
    Provider.of<UserProvider>(context, listen: false).getUserInfo();
    Provider.of<CartProvider>(context, listen: false).getAllCartItems();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      // appBar: AppBar(
      //   title: const Text('Products'),
      // ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                actions: [
                  CartBubbleView(),
                ],
                expandedHeight: 250,
                pinned: true,
                floating: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text('Products'),
                  background: ListView(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<CategoryModel>(
                          hint: const Text('Select Category'),
                          value: categoryModel,
                          isExpanded: true,
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                          items: provider
                              .getCategoryListForFiltering()
                              .map((catModel) =>
                              DropdownMenuItem(
                                  value: catModel,
                                  child: Text(catModel.categoryName)))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              categoryModel = value;
                            });
                            provider.getAllProductsByCategory(categoryModel!);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                ),
                delegate: SliverChildBuilderDelegate(
                  childCount: provider.productList.length,
                      (context, index) {
                    final product = provider.productList[index];
                    return ProductGridItemView(productModel: product);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Column buildColumn(ProductProvider provider) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField<CategoryModel>(
            hint: const Text('Select Category'),
            value: categoryModel,
            isExpanded: true,
            validator: (value) {
              if (value == null) {
                return 'Please select a category';
              }
              return null;
            },
            items: provider
                .getCategoryListForFiltering()
                .map((catModel) =>
                DropdownMenuItem(
                    value: catModel, child: Text(catModel.categoryName)))
                .toList(),
            onChanged: (value) {
              setState(() {
                categoryModel = value;
              });
              provider.getAllProductsByCategory(categoryModel!);
            },
          ),
        ),
        provider.productList.isEmpty
            ? const Expanded(
            child: Center(
              child: Text('No item found'),
            ))
            : Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
            ),
            itemCount: provider.productList.length,
            itemBuilder: (context, index) {
              final product = provider.productList[index];
              return ProductGridItemView(productModel: product);
            },
          ),
        ),
      ],
    );
  }

}
