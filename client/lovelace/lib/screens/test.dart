import 'package:flutter/material.dart';
import 'package:lovelace/models/storage_item.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/card.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  late List<StorageItem> _tokens;
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
                    // TODO: Use Dismissible Widget to delete a particular key-pair using the deleteSecureData method
                    return VaultCard(item: _tokens[index]);
                  }),
            ),
            Container(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: LOGOUT USER & DIRECT TO LOGIUN PAGE
                },
                style: ElevatedButton.styleFrom(backgroundColor: whiteColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const <Widget>[
                    Text('Logout',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: errorColor)),
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
