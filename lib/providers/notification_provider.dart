import 'package:ecom_user_class/auth/authservice.dart';
import 'package:ecom_user_class/db/db_helper.dart';
import 'package:ecom_user_class/models/notification_model.dart';
import 'package:ecom_user_class/models/user_model.dart';
import 'package:flutter/cupertino.dart';

class NotificationProvider extends ChangeNotifier{
  Future<void> addNotification(NotificationModel notificationModel) {
    return DbHelper.addNotification(notificationModel);
  }

  // getUserInfo(){
  //   DbHelper.getUserInfo(AuthService.currentUser!.uid).listen((snapshot) {
  //     if ( snapshot.exists ){
  //       userModel = UserModel.fromMap(snapshot.data()!);
  //       notifyListeners();
  //     }
  //   });
  // }



}