import 'package:flutter/material.dart';
import 'package:lovelace/models/storage_item.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/resources/user_state_methods.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/card.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  late List<StorageItem> _tokens = [];
  final StorageMethods _storageService = StorageMethods();

  @override
  void initState() {
    super.initState();
    initList();
  }

  void initList() async {
    _tokens = await _storageService.readAllSecureData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          StorageMethods().deleteAllSecureData();
          initList();
        },
        child: const Icon(Icons.delete),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(children: <Widget>[
            Flexible(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _tokens.length,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemBuilder: (_, index) {                    
                    return VaultCard(item: _tokens[index]);
                  }),
            ),
            SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {     
                    showDialog(context: context, builder: (context) {
                      return const AlertDialog(
                        content: Text('Logging out...')
                      );
                    });
                    UserStateMethods().logoutState(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: whiteColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const <Widget>[
                      Text('Logout',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: errorColor)),
                      Icon(Icons.exit_to_app, color: placeholderColor)
                    ],
                  ),
                )),
          ]),
        ),
      ),
    );
  }
}
