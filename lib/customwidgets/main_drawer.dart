import 'package:ecom_user_class/pages/login_page.dart';
import 'package:ecom_user_class/pages/user_profile.dart';
import 'package:flutter/material.dart';

import '../auth/authservice.dart';
import '../pages/launcher_page.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            height: 150,
          ),
          if(!AuthService.currentUser!.isAnonymous)ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, UserProfile.routeName);
            },
            leading: const Icon(Icons.person),
            title: const Text('My Profile'),
          ),
          if(!AuthService.currentUser!.isAnonymous)ListTile(
            onTap: () {},
            leading: const Icon(Icons.shopping_cart),
            title: const Text('My Cart'),
          ),
          if(!AuthService.currentUser!.isAnonymous)ListTile(
            onTap: () {},
            leading: const Icon(Icons.monetization_on),
            title: const Text('My Orders'),
          ),
          if(AuthService.currentUser!.isAnonymous)ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(context, LoginPage.routeName);
            },
            leading: const Icon(Icons.person),
            title: const Text('Login/Register'),
          ),
          ListTile(
            onTap: () {
              AuthService.logout().then((value) =>
                  Navigator.pushReplacementNamed(
                      context, LauncherPage.routeName));
            },
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
