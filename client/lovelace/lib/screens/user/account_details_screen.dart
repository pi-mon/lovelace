import 'package:flutter/material.dart';
import 'package:lovelace/models/storage_item.dart';
import 'package:lovelace/resources/auth_methods.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/resources/user_state_methods.dart';
import 'package:lovelace/utils/colors.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  late final List<StorageItem> _tokens = [];
  final StorageMethods _storageMethods = StorageMethods();

  @override
  void initState() {
    super.initState();
    initList();
  }

  void initList() async {
    _storageMethods.readAllSecureData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                content: Row(
                                  children: const <Widget>[
                                    SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: primaryColor)),
                                    SizedBox(width: 15),
                                    Text('Logging out...')
                                  ],
                                ));
                          });
                      // TODO: DELETE TOKEN FROM SECURE_STORAGE
                      StorageMethods()
                          .deleteSecureData(StorageItem('token', value: token));
                      UserStateMethods().logoutState(context);
                      initList();
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: whiteColor),
                    child: Row(
                      children: const <Widget>[
                        Icon(Icons.exit_to_app, color: placeholderColor),
                        SizedBox(width: 10),
                        Text('Logout',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: errorColor)),
                      ],
                    ),
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}
