import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_user_class/models/cart_model.dart';
import 'package:ecom_user_class/models/comment_model.dart';
import 'package:ecom_user_class/models/notification_model.dart';
import 'package:ecom_user_class/models/order_model.dart';
import 'package:ecom_user_class/models/rating_model.dart';
import '../models/category_model.dart';
import '../models/order_constant_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

class DbHelper {
  static final _db = FirebaseFirestore.instance;

  static Future<bool> doesUserExist(String uid) async {
    final snapshot = await _db.collection(collectionUser).doc(uid).get();
    return snapshot.exists;
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getOrderConstants() =>
      _db
          .collection(collectionOrderConstant)
          .doc(documentOrderConstant)
          .snapshots();
  
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserInfo(String uid) =>
      _db.collection(collectionUser).doc(uid).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() =>
      _db.collection(collectionCategory).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() =>
      _db.collection(collectionProduct).snapshots();

  static Future<DocumentSnapshot<Map<String, dynamic>>> getAllProductsbyId(String id) =>
      _db.collection(collectionProduct).doc(id).get();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProductsByCategory(
          CategoryModel categoryModel) =>
      _db
          .collection(collectionProduct)
          .where('$productFieldCategory.$categoryFieldId',
              isEqualTo: categoryModel.categoryId)
          .snapshots();

  static Future<void> addUser(UserModel userModel) {
    return _db
        .collection(collectionUser)
        .doc(userModel.userId)
        .set(userModel.toMap());
  }

  static Future<void> userUpdateProfileField(String uid, Map<String, dynamic> map){
    return _db.collection(collectionUser).doc(uid).update(map);
  }

  static Future<void>addRating(RatingModel ratingModel) async {
    final ratdoc = _db.collection(collectionProduct)
        .doc(ratingModel.productId)
        .collection(collectionRating)
        .doc(ratingModel.userModel.userId);
    await ratdoc.set(ratingModel.toMap());
  }

  static Future<QuerySnapshot<Map<String,dynamic>>>getRatingByProduct(String productId) =>
      _db.collection(collectionProduct).doc(productId).collection(collectionRating).get();

  static Future<void> userUpdateProductField(String pid, Map<String, dynamic> map){
    return _db.collection(collectionProduct).doc(pid).update(map);
  }

  static Future<void> addComment(CommentModel commentModel) {
    return _db.collection(collectionProduct)
        .doc(commentModel.productId)
        .collection(collectionComment)
        .doc(commentModel.commentId)
        .set(commentModel.toMap());
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getAllCommentsByProduct(String productId) =>
      _db.collection(collectionProduct)
      .doc(productId)
      .collection(collectionComment)
      .where(commentFieldApproved, isEqualTo: true)
      .get();

  static Future<void> addToCart(String uid, CartModel cartModel) {
    return _db.collection(collectionUser)
        .doc(uid)
        .collection(collectionCart)
        .doc(cartModel.productId)
        .set(cartModel.toMap());
  }

  static Future<void> removeFromCart(String uid, String pid) {
    return _db.collection(collectionUser)
        .doc(uid)
        .collection(collectionCart)
        .doc(pid).delete();
  }

  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllCartItems(String uid) {
    return _db.collection(collectionUser).doc(uid).collection(collectionCart).snapshots();
  }

  static Future<void> updateCartQuantity(String uid, CartModel cartModel) {
    return _db.collection(collectionUser)
        .doc(uid)
        .collection(collectionCart)
        .doc(cartModel.productId)
        .set(cartModel.toMap());
  }

  static Future<void> clearCart(String uid, List<CartModel> cartList) {
    final wb = _db.batch();
    for (final cartItem in cartList){
      final doc = _db.collection(collectionUser)
          .doc(uid)
          .collection(collectionCart)
          .doc(cartItem.productId);
      wb.delete(doc);
    }
    return wb.commit();
  }

  static Future<void> saveOrder(OrderModel orderModel) async {
    final wb = _db.batch();
    final orderDoc =  _db.collection(collectionOrder).doc(orderModel.orderId);
    wb.set(orderDoc, orderModel.toMap());

    for(final cartItem in orderModel.productDetails){
      final proSnapshot = await _db.collection(collectionProduct).doc(cartItem.productId).get();
      final catSnapshot = await _db.collection(collectionCategory).doc(cartItem.categoryId).get();

      final preProStoct = proSnapshot.data()![productFieldStock];
      final preCatStoct = catSnapshot.data()![categoryFieldProductCount];

      final proDoc = _db.collection(collectionProduct).doc(cartItem.productId);
      final catDoc = _db.collection(collectionCategory).doc(cartItem.categoryId);

      wb.update(proDoc, {productFieldStock:(preProStoct-cartItem.quantity)});
      wb.update(catDoc, {categoryFieldProductCount:(preCatStoct-cartItem.quantity)});
    }
    return wb.commit();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllOrdersByUser(
      String uid) =>
      _db.collection(collectionOrder)
          .where(orderFieldUserId, isEqualTo: uid)
          .snapshots();

  static Future<void> addNotification(NotificationModel notificationModel) {
    return _db.collection(collectionNotification)
        .doc(notificationModel.id)
        .set(notificationModel.toMap());
  }

}
