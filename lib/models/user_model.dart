import 'package:cloud_firestore/cloud_firestore.dart';

import 'address_model.dart';

const String collectionUser = 'user';

const String userFieldId = 'user_id';
const String userFieldDisplayName = 'display_name';
const String userFieldAddressModel = 'address_model';
const String userFieldCreationTime = 'creation_time';
const String userFieldGender = 'gender';
const String userFieldAge = 'age';
const String userFieldPhone = 'phone';
const String userFieldEmail = 'email';
const String userFieldImageUrl = 'image';

class UserModel {
  String userId;
  String? displayName;
  AddressModel? addressModel;
  Timestamp? userCreationTime;
  String? gender;
  Timestamp? age;
  String? phone;
  String email;
  String? imageUrl;

  UserModel(
      {required this.userId,
      this.displayName,
      this.addressModel,
      this.userCreationTime,
      this.gender,
      this.age,
      this.phone,
      this.imageUrl,
      required this.email});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      userFieldId: userId,
      userFieldDisplayName: displayName,
      userFieldAddressModel: addressModel?.toMap(),
      userFieldCreationTime: userCreationTime,
      userFieldGender: gender,
      userFieldAge: age,
      userFieldPhone: phone,
      userFieldEmail: email,
      userFieldImageUrl: imageUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        userId: map[userFieldId],
        displayName: map[userFieldDisplayName],
        addressModel: map[userFieldAddressModel] == null
            ? null
            : AddressModel.fromMap(map[userFieldAddressModel]),
        userCreationTime: map[userFieldCreationTime],
        gender: map[userFieldGender],
        age: map[userFieldAge],
        phone: map[userFieldPhone],
        email: map[userFieldEmail],
        imageUrl: map[userFieldImageUrl],
      );
}
