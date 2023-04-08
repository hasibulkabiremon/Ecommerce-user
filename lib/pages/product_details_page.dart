import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_user_class/auth/authservice.dart';
import 'package:ecom_user_class/models/comment_model.dart';
import 'package:ecom_user_class/providers/user_provider.dart';
import 'package:ecom_user_class/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../models/notification_model.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/notification_provider.dart';
import '../providers/product_provider.dart';
import '../utils/constants.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = '/productdetails';

  const ProductDetailsPage({Key? key}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late ProductModel productModel;
  late ProductProvider productProvider;
  String displayUrl = '';
  double userRating = 0.0;
  final txtcontroller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void didChangeDependencies() {
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    productModel = ModalRoute.of(context)!.settings.arguments as ProductModel;
    displayUrl = productModel.thumbnailImageUrl;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(productModel.productName,style: const TextStyle(color: Colors.black),),
      ),
      body: ListView(
        children: [
          CachedNetworkImage(
            width: double.infinity,
            height: 200,
            imageUrl: displayUrl,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      displayUrl = productModel.thumbnailImageUrl;
                    });
                  },
                  child: Card(
                    child: CachedNetworkImage(
                      width: 60,
                      height: 60,
                      imageUrl: productModel.thumbnailImageUrl,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                ...productModel.additionalImages.map((url) {
                  if (url.isEmpty) {
                    return SizedBox();
                  }
                  return InkWell(
                    onTap: () {
                      setState(() {
                        displayUrl = url;
                      });
                    },
                    child: Card(
                      child: CachedNetworkImage(
                        width: 60,
                        height: 60,
                        imageUrl: url,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  );
                }).toList()
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.favorite,color: Colors.pink,),
                  label: Text('Add to Favorite',style: TextStyle(color: Colors.black),),
                )),
                Expanded(child: Consumer<CartProvider>(
                  builder: (context, provider, child) {
                    final inInCart = provider.isProductInCart(productModel.productId!);
                    return OutlinedButton.icon(
                      onPressed: () {
                        if(inInCart){
                          provider.removeFromCart(productModel.productId!);
                        }else{
                          provider.addToCart(productModel);
                        }
                      },
                      icon: Icon(inInCart ? Icons.remove_shopping_cart : Icons.shopping_cart,color: Colors.black,),
                      label: Text(inInCart ?'Remove from Cart': 'Add to Cart',style: TextStyle(color: Colors.black),),
                    );
                  },
                ))
              ],
            ),
          ),
          ListTile(
            title: Text(productModel.productName),
            subtitle: Text(productModel.category.categoryName),
          ),
          ListTile(
            title: Text(
                'Sale Price: $currencySymbol${calculatePriceAfterDiscount(productModel.salePrice, productModel.productDiscount)}'),
          ),
          Card(
              child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Text('Rate this Product'),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: RatingBar.builder(
                    initialRating: 0.0,
                    minRating: 0.0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    ignoreGestures: false,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      userRating = rating;
                    },
                  ),
                ),
                OutlinedButton(
                    onPressed: () async {
                      if (AuthService.currentUser!.isAnonymous) {
                        showMsg(context, 'Please sign in first');
                        return;
                      }
                      EasyLoading.show(status: 'Please Wait');
                      await productProvider.addRating(
                          productModel.productId!,
                          userRating,
                          (context.read<UserProvider>().userModel!));
                      EasyLoading.dismiss();
                      showMsg(context, 'Thanks for Rating');
                    },
                    child: Text('Submit'))
              ],
            ),
          )),
          Card(
              child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Text('Rate this Product'),
                Padding(
                    padding: EdgeInsets.all(8),
                    child: TextField(
                      controller: txtcontroller,
                      focusNode: focusNode,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    )),
                OutlinedButton(
                    onPressed: () async {
                      if (txtcontroller.text.isEmpty) {
                        showMsg(context, 'Plese write some comment');
                        return;
                      }
                      if (AuthService.currentUser!.isAnonymous) {
                        showMsg(context, 'Please sign in first');
                        return;
                      }
                      EasyLoading.show(status: 'Please Wait');
                      final commentModel = CommentModel(
                        commentId: DateTime.now().millisecondsSinceEpoch.toString(),
                        userModel: context.read<UserProvider>().userModel!,
                        productId: productModel.productId!,
                        comment: txtcontroller.text,
                        date: getFormattedDate(DateTime.now(),pattern: 'dd/MM/yy hh:mm:s a'),
                      );
                      await productProvider.addComment(commentModel);
                      EasyLoading.dismiss();
                      focusNode.unfocus();
                      txtcontroller.clear();
                      showMsg(context,
                          'Thanks for Comment. Please wait for approval');
                      final notificationModel = NotificationModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          type: NotificationType.comment,
                          message: 'Product ${productModel.productName} has a new comment which is waiting fot your approval',
                          commentModel: commentModel
                      );
                      await Provider.of<NotificationProvider>(context, listen: false).addNotification(notificationModel);
                    },
                    child: Text('Submit'))
              ],
            ),
          )),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text('All Comments'),
          ),
          FutureBuilder<List<CommentModel>>(
            future: productProvider
                .getAllCommentsByProduct(productModel.productId!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final commentList = snapshot.data!;
                if (commentList.isEmpty) {
                  return Center(
                    child: Text('No comments available'),
                  );
                } else {
                  return Column(
                    children: commentList
                        .map((comment) => Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ListTile(
                                  leading: Icon(Icons.person),
                                  title: Text(comment.userModel.displayName ??
                                      comment.userModel.email),
                                  subtitle: Text(comment.date),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 16),
                                  child: Text(comment.comment),
                                )
                              ],
                            ))
                        .toList(),
                  );
                }
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Failed to Load comment'),
                );
              }
              return Center(
                child: Text('Loading Commert'),
              );
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    txtcontroller.dispose();
    super.dispose();
  }
}
