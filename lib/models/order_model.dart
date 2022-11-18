import 'package:ecom_user_class/models/address_model.dart';
import 'package:ecom_user_class/models/date_model.dart';

import 'cart_model.dart';

const String orderField = 'Orders';
const String orderFieldId = 'orderId';
const String orderFieldorderStatus = 'orderStatus';

class OrderModel {
  String orderId;
  String userId;
  String orderStatus;
  String paymentMethod;
  num grandTotal;
  num discount;
  num VAT;
  num deliveryCharge;
  DateModel orderDate;
  AddressModel deliveryAddress;
  List<CartModel> productDetails;

  OrderModel(
      {required this.orderId,
      required this.userId,
      required this.orderStatus,
      required this.paymentMethod,
      required this.grandTotal,
      required this.discount,
      required this.VAT,
      required this.deliveryCharge,
      required this.orderDate,
      required this.deliveryAddress,
      required this.productDetails});
}