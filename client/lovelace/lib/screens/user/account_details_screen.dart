import 'package:flutter/material.dart';
import 'package:lovelace/models/storage_item.dart';
import 'package:lovelace/resources/auth_methods.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/resources/user_state_methods.dart';
import 'package:lovelace/responsive/mobile_screen_layout.dart';
import 'package:lovelace/responsive/responsive_layout.dart';
import 'package:lovelace/responsive/web_screen_layout.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/account_detail_btn.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  String email = '';
  String username = '';
  late TextEditingController emailController;
  late TextEditingController usernameController;
  late TextEditingController locationController;
  late final List<StorageItem> _tokens = [];
  final StorageMethods _storageMethods = StorageMethods();
  final _userPages = const ResponsiveLayout(
      mobileScreenLayout: MobileScreenLayout(),
      webScreenLayout: WebScreenLayout());

  @override
  void initState() {
    super.initState();
    initList();
    emailController = TextEditingController();
    usernameController = TextEditingController();
    locationController = TextEditingController();
  }

  void initList() async {
    await _storageMethods.readAll();
    setState(() {});
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
            child: Column(children: <Widget>[
          CustomButton(
              icon: const Icon(Icons.email, color: placeholderColor),
              label: "Update email",
              labelColor: blackColor,
              function: emailDialog),
          CustomButton(
              icon: const Icon(Icons.person, color: placeholderColor),
              label: "Update username",
              labelColor: blackColor,
              function: usernameDialog),
          CustomButton(
              icon: const Icon(Icons.location_city, color: placeholderColor),
              label: "Update location",
              labelColor: blackColor,
              function: locationDialog),
          CustomButton(
              icon: const Icon(Icons.exit_to_app, color: placeholderColor),
              label: "Logout",
              labelColor: errorColor,
              function: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          content: Row(
                        children: const <Widget>[
                          SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: primaryColor)),
                          SizedBox(width: 15),
                          Text('Logging out...')
                        ],
                      ));
                    });
                StorageMethods().delete(StorageItem('token', value: token));
                UserStateMethods().logoutState(context);
                initList();
              })
        ])),
      ),
    );
  }

  Future<String?> emailDialog() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Update Email Address'),
            content: TextField(
              autofocus: true,
              decoration:
                  const InputDecoration(hintText: 'Enter your email address'),
              controller: emailController,
            ),
            actions: [
              TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop(emailController.text),
                  child: const Text('UPDATE'))
            ],
          ));

  Future<String?> usernameDialog() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Update Username'),
            content: TextField(
              autofocus: true,
              decoration:
                  const InputDecoration(hintText: 'Enter your username'),
              controller: emailController,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(usernameController.text);
                  },
                  child: const Text('UPDATE'))
            ],
          ));

  Future<String?> locationDialog() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Update location'),
            content: TextField(
              autofocus: true,
              decoration:
                  const InputDecoration(hintText: 'Enter your location'),
              controller: locationController,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(locationController.text);
                  },
                  child: const Text('UPDATE'))
            ],
          ));
}
