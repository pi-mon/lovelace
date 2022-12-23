import 'package:flutter/material.dart';
import 'package:lovelace/models/storage_item.dart';
import 'package:lovelace/resources/storage_methods.dart';

class VaultCard extends StatefulWidget {
  StorageItem item;

  VaultCard({required this.item, Key? key}) : super(key: key);

  @override
  State<VaultCard> createState() => _CardState();
}

class _CardState extends State<VaultCard> {
  bool _visibility = false;
  final StorageMethods _storageService = StorageMethods();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(3, 3),
                    color: Colors.grey.shade300,
                    blurRadius: 5)
              ]),
          child: ListTile(
            onLongPress: () {
              setState(() {
                _visibility = !_visibility;
              });
            },
            title: Text(
              widget.item.key,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            subtitle: Visibility(
              visible: _visibility,
              child: Text(
                widget.item.value,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            leading: const Icon(Icons.security, size: 30),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                // DISPLAY THE TOKEN VALUER
                showDialog(
                  context: context,
                  builder: (context) {   
                    final readToken = _storageService.readAllSecureData().toString();          
                    debugPrint(readToken);
                    return const AlertDialog(
                      content: Text('test')
                    );
                  }
                );
              },
            ),
          )
        ),
    );
  }
}