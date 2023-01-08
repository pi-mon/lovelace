import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lovelace/models/user_detail.dart';
import 'package:lovelace/resources/account_methods.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/text_field_input.dart';

class UpdateUserDetailsScreen extends StatefulWidget {
  const UpdateUserDetailsScreen({super.key});

  @override
  State<UpdateUserDetailsScreen> createState() =>
      _UpdateUserDetailsScreenState();
}

class _UpdateUserDetailsScreenState extends State<UpdateUserDetailsScreen> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  DateTime dateNow = DateTime(2022);
  String dropDownValue = 'Male';
  final StorageMethods _storageMethods = StorageMethods();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  File? _image;
  bool _isDefault = true;
  List<String> dropdownValues = ['Male', 'Female'];
  String dropdownValue = 'Male';

  String displayName = '';
  String email = '';
  String location = '';
  String gender = '';
  String birthday = '';

  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _newDisplayNameController =
      TextEditingController();
  final TextEditingController _newBirthdayController = TextEditingController();
  final TextEditingController _newLocationController = TextEditingController();

  _UpdateUserDetailsScreenState() {
    _storageMethods.read("userDetails").then((value) {
      dynamic valueJson = json.decode(value);
      setState(() {
        _newEmailController.text = valueJson["email"];
        _newDisplayNameController.text = valueJson["displayName"];
        dropDownValue = valueJson["gender"]; // doesn't work
        _newBirthdayController.text = valueJson["birthday"];
        _newLocationController.text = valueJson["location"];
      });
    });
  }

  @override
  void dispose() {
    _newEmailController.dispose();
    _newDisplayNameController.dispose();
    _newBirthdayController.dispose();
    _newLocationController.dispose();
    super.dispose();
  }

  void updateUserDetails() {
    UserDetails userDetail = UserDetails(
      displayName: _newDisplayNameController.text,
      email: _newEmailController.text,
      location: _newLocationController.text,
      gender: dropDownValue,
      birthday: _newBirthdayController.text,
      imageUrl: '',
    );

    AccountMethods().updateUserDetails(userDetail);
    _storageMethods.save("userDetails", json.encode(userDetail.toJson()));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: primaryColor,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          title: const Text(
            "Update User Details",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey,
                      child: GestureDetector(
                        onTap: () async {
                          File? image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              _image = File(image.path);
                              _isDefault = false;
                            });
                          }
                        },
                        child: _isDefault
                            ? const Icon(Icons.person)
                            : Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(_image!),
                                        fit: BoxFit.cover))),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _image = null;
                              _isDefault = true;
                            });
                          },
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 15,
                              color: Colors.black,
                            ),
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                TextFieldInput(
                  label: "Display Name",
                  controller: _newDisplayNameController,
                  onChanged: (value) {
                    displayName = value;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFieldInput(
                  label: "Email",
                  controller: _newEmailController,
                  onChanged: (value) {
                    email = value;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFieldInput(
                  label: "Location",
                  controller: _newLocationController,
                  onChanged: (value) {
                    location = value;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  child: DropdownButton<String>(
                    value: dropDownValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        dropDownValue = newValue;
                      });
                    },
                    items: dropdownValues
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFieldInput(
                  label: "Birthday",
                  controller: _newBirthdayController,
                  onChanged: (value) {
                    birthday = value;
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: double.infinity,
                  height: 45,
                  child: FlatButton(
                    onPressed: () {
                      updateUserDetails();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: primaryColor,
                    child: Text(
                      "Update",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
