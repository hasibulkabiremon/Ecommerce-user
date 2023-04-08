import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_user_class/models/address_model.dart';
import 'package:ecom_user_class/models/user_model.dart';
import 'package:ecom_user_class/pages/otp_verification_page.dart';
import 'package:ecom_user_class/utils/helper_functions.dart';
import 'package:ecom_user_class/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class UserProfile extends StatelessWidget {
  static const String routeName = '/profile';

  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text('Profile Page',style: TextStyle(color: Colors.black),),
        ),
        body: userProvider.userModel == null
            ? Center(
                child: Text('Failed to load user Data'),
              )
            : ListView(
                children: [
                  _headerSection(context, userProvider),
                  ListTile(
                    leading: const Icon(Icons.call),
                    title: Text(userProvider.userModel!.phone ?? 'Not set yet'),
                    trailing: IconButton(
                      onPressed: () {
                        showSingleTextInputDialog(
                            context: context,
                            title: 'Mobile Number (+8801XXX..)',
                            onSubmit: (value) {
                              Navigator.pushNamed(
                                  context, OtpVerificationPage.routeName,
                                  arguments: value);
                            });
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ),
                  if (userProvider.userModel!.age == null)
                    ListTile(
                      leading: const Icon(Icons.calendar_month),
                      title: Text('Not Set Yet'),
                      subtitle: Text('Date of Birth'),
                      trailing: IconButton(
                        onPressed: () {
                          _selctDate(context, userProvider);
                        },
                        icon: Icon(Icons.edit),
                      ),
                    ),
                  if (userProvider.userModel!.age != null)
                    ListTile(
                      leading: const Icon(Icons.calendar_month),
                      title: Text(getFormattedDate(
                          userProvider.userModel!.age!.toDate())),
                      subtitle: Text('Date of Birth'),
                      trailing: IconButton(
                        onPressed: () {
                          _selctDate(context, userProvider);
                        },
                        icon: Icon(Icons.edit),
                      ),
                    ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title:
                        Text(userProvider.userModel!.gender ?? 'Not set yet'),
                    subtitle: Text('Gender'),
                    trailing: IconButton(
                      onPressed: () {
                        _radioGender(context, userProvider);
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_city),
                    title: Text(
                        userProvider.userModel!.addressModel?.addressLine1 ??
                            'Not set yet'),
                    subtitle: Text('Address Line 1'),
                    trailing: IconButton(
                      onPressed: () {
                        showSingleTextInputDialog(
                          context: context,
                          title: 'Address Line 1',
                          onSubmit: (value) {
                            userProvider.updateUserProfileField(
                                '$userFieldAddressModel.$addressFieldAddressLine1',
                                value);
                          },
                        );
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_city),
                    title: Text(
                        userProvider.userModel!.addressModel?.addressLine2 ??
                            'Not set yet'),
                    subtitle: Text('Address Line 2'),
                    trailing: IconButton(
                      onPressed: () {
                        showSingleTextInputDialog(
                            context: context,
                            title: 'Address Line 2',
                            onSubmit: (value) {
                              userProvider.updateUserProfileField(
                                  '$userFieldAddressModel.$addressFieldAddressLine2',
                                  value);
                            });
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_city),
                    title: Text(userProvider.userModel!.addressModel?.city ??
                        'Not set yet'),
                    subtitle: Text('City'),
                    trailing: IconButton(
                      onPressed: () {
                        showSingleTextInputDialog(
                            context: context,
                            title: 'City',
                            onSubmit: (value) {});
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_city),
                    title: Text(userProvider.userModel!.addressModel?.zipcode ??
                        'Not set yet'),
                    subtitle: Text('Zipcode'),
                    trailing: IconButton(
                      onPressed: () {
                        showSingleTextInputDialog(
                            context: context,
                            title: 'Zipcode',
                            onSubmit: (value) {
                              userProvider.updateUserProfileField(
                                  '$userFieldAddressModel.$addressFieldZipcode',
                                  value);
                            });
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ),
                ],
              ));
  }

  Container _headerSection(BuildContext context, UserProvider userProvider) {
    return Container(
      height: 150,
      color: Theme.of(context).primaryColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45)),
              elevation: 5,
              child: userProvider.userModel!.imageUrl == null
                  ? Icon(
                      Icons.person,
                      size: 90,
                      color: Colors.grey,
                    )
                  : Padding(
                      padding: EdgeInsets.all(2),
                      child: ClipOval(
                        child: (CachedNetworkImage(
                          width: 90,
                          height: 90,
                          imageUrl: userProvider.userModel!.imageUrl!,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )),
                      ),
                    ),
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userProvider.userModel!.displayName ?? 'No Display Name',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.white),
                ),
                Text(
                  userProvider.userModel!.email,
                  style: TextStyle(color: Colors.white60),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _selctDate(context, userProvider) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 20),
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      userProvider.updateUserProfileField(userFieldAge, date);
    }
  }

  void _radioGender(context, userProvider) {
    String? gender;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Select Your Gender'),
                  Row(
                    children: [
                      Radio(
                        value: 'Male',
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                      Text('Male')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 'Female',
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                      Text('Female')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 'Other',
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                      Text('Other')
                    ],
                  ),
                  TextButton(
                      onPressed: () {
                        userProvider.updateUserProfileField(
                            '$userFieldGender', gender);
                        Navigator.pop(context);
                      },
                      child: Text('OK'))
                ],
              );
            },
          ),
        );
      },
    );
  }
}
