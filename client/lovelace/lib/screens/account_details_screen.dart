import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lovelace/models/storage_item.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/resources/user_state_methods.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/card.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

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
    debugPrint("Executing from Account details page"); // testing
    _tokens = await _storageService.readAllSecureData();
    setState(() {});
  }

  Future<bool?> _checkJailBreak() async {
    bool jailBroken = false;
    bool _jailbroken = false;

    try {
      jailBroken = await FlutterJailbreakDetection.jailbroken;
      jailBroken = await FlutterJailbreakDetection
          .developerMode; // andrdoid devices only
    } on PlatformException {
      jailBroken = true;
    }
    setState(() {
      _jailbroken = jailBroken;
    });
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                                content: Text('Logging out...'));
                          });
                      UserStateMethods().logoutState(context);
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      // CHECK IF DEVICE IS JAILBROKEN
                    var jailBreakStatus = _checkJailBreak();
                      // ignore: unrelated_type_equality_checks
                      if (jailBreakStatus == true) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                content:
                                    Text('Your device has been jail broken!'),
                              );
                            });
                      }
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              content: Text('Your device is safe!'),
                            );
                          });
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: whiteColor),
                    child: Row(
                      children: const <Widget>[
                        Icon(Icons.safety_check, color: placeholderColor),
                        SizedBox(width: 10),
                        Text('Scan device',
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
