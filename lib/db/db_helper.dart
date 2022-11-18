import 'package:cloud_firestore/cloud_firestore.dart';
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
}
