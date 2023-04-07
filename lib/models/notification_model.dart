import 'package:ecom_user_class/models/user_model.dart';

import 'comment_model.dart';
import 'order_model.dart';

const String collectionNotification = 'Notifications';
const String notificationFieldId = 'notificationId';
const String notificationFieldType = 'type';
const String notificationFieldStatus = 'status';
const String notificationFieldMessage = 'message';
const String notificationFieldCommentModel = 'commentModel';
const String notificationFieldUserModel = 'userModel';
const String notificationFieldOrderModel = 'orderModel';

class NotificationModel {
  String id;
  String type;
  String message;
  bool status;
  CommentModel? commentModel;
  UserModel? userModel;
  OrderModel? orderModel;

  NotificationModel({
    required this.id,
    required this.type,
    required this.message,
    this.status = false,
    this.commentModel,
    this.userModel,
    this.orderModel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      notificationFieldId: id,
      notificationFieldType: type,
      notificationFieldMessage: message,
      notificationFieldStatus: status,
      notificationFieldCommentModel: commentModel?.toMap(),
      notificationFieldUserModel: userModel?.toMap(),
      notificationFieldOrderModel: orderModel?.toMap(),
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) =>
      NotificationModel(
        id: map[notificationFieldId],
        type: map[notificationFieldType],
        message: map[notificationFieldMessage],
        status: map[notificationFieldStatus],
        commentModel: map[notificationFieldCommentModel] == null
            ? null
            : CommentModel.fromMap(map[notificationFieldCommentModel]),
        userModel: map[notificationFieldUserModel] == null
            ? null
            : UserModel.fromMap(map[notificationFieldUserModel]),
        orderModel: map[notificationFieldOrderModel] == null
            ? null
            : OrderModel.fromMap(map[notificationFieldOrderModel]),
      );
}
