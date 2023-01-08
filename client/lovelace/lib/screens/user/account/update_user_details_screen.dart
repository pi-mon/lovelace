import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lovelace/models/user_detail.dart';
import 'package:lovelace/resources/account_methods.dart';
import 'package:lovelace/resources/authenticate_methods.dart';
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
  DateTime dateNow = DateTime(2022);
  String dropDownValue = 'Male';
  final StorageMethods _storageMethods = StorageMethods();
  final AccountMethods _accountMethods = AccountMethods();
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
  final TextEditingController _newBirthdayController = TextEditingController();
  final TextEditingController _newLocationController = TextEditingController();
  final TextEditingController _newDisplayNameController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   init();
  // }

  // void init() async {
  //   List response = await _accountMethods.read();
  //   String output = response[0];
  //   UserDetails userDetails =
  //       UserDetails.fromJson(json.decode(output)["response"]);
  //   String email = userDetails.email;
  //   _storageMethods.read("userDetails_$email").then((value) {
  //     dynamic valueJson = json.decode(value);
  //     setState(() {
  //       displayName = valueJson["displayName"];
  //       location = valueJson["location"];
  //       email = valueJson["email"];
  //       birthday = valueJson["birthday"];
  //       gender = valueJson["gender"];
  //     });
  //   });
  // }

  @override
  void dispose() {
    _newEmailController.dispose();
    _newDisplayNameController.dispose();
    _newLocationController.dispose();
    _newBirthdayController.dispose();
    super.dispose();
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
                          XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              _image = File(image.path);
                              _isDefault = false;
                            });
                          }
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: borderColor),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: _isDefault
                                  ? const AssetImage(
                                      'assets/images/default-profile-picture.png')
                                  : Image.file(_image!).image,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 70,
                        right: 5,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: whiteColor,
                              border:
                                  Border.all(color: primaryColor, width: 1)),
                          child: const Icon(Icons.edit,
                              color: placeholderColor, size: 20),
                        ))
                  ],
                ),
                TextFieldInput(
                  label: "Email",
                  hintText: "Enter your email",
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _newEmailController,
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFieldInput(
                  label: "Display Name",
                  hintText: "Enter your Display Name",
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _newEmailController,
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFieldInput(
                  onTap: () async {
                    DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: dateNow,
                        firstDate: DateTime(1990),
                        lastDate: DateTime(2023));
                    // if CANCEL is pressed
                    if (newDate == null) return;

                    // if OK is pressed
                    setState(() => _newBirthdayController.text =
                        DateFormat('dd-MM-yyyy').format(newDate));
                  },
                  label: "Birthday",
                  hintText: "Enter your birthday",
                  textInputType: TextInputType.text,
                  textEditingController: _newBirthdayController,
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text("Gender",
                        style: TextStyle(color: primaryColor, fontSize: 18)),
                    Padding(
                      padding: const EdgeInsets.only(right: 16, bottom: 16),
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        decoration: BoxDecoration(
                            border: Border.all(color: primaryColor, width: 1),
                            borderRadius: BorderRadius.circular(12)),
                        child: DropdownButton<String>(
                          hint: const Text("Select gender"),
                          value: dropdownValue,
                          icon: const Icon(Icons.arrow_drop_down),
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: dropdownValues.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFieldInput(
                  label: "Location",
                  hintText: "Enter your location",
                  textInputType: TextInputType.text,
                  textEditingController: _newLocationController,
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 50),
                      backgroundColor: primaryColor),
                  child: const Text(
                    "Update",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: whiteColor),
                  ),
                  onPressed: () async {
                    String email = _newEmailController.text;
                    String displayName = _newDisplayNameController.text;
                    String birthday = _newBirthdayController.text;
                    String location = _newLocationController.text;
                    String gender = dropDownValue;

                    debugPrint('$email, $displayName, $birthday, $location, $gender');

                    // if (_formKey.currentState!.validate()) {
                    //   String email = _newEmailController.text;
                    //   String birthday = _newBirthdayController.text;
                    //   String gender = dropDownValue;
                    //   String location = _newLocationController.text;
                    //   File? displayPic = _image;

                    //   // call update function to send request to server side to update user details
                    //   List response = await AuthenticateMethods()
                    //       .updateUserDetails(
                    //           email: email,
                    //           birthday: birthday,
                    //           location: location,
                    //           gender: gender,
                    //           displayPic: displayPic);

                    //   String output = response[0];
                    //   String message = response[1];
                    //   bool isUpdated = response[2];

                    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //     content: Text(message),
                    //     backgroundColor: isUpdated ? successColor : errorColor,
                    //   ));
                    // }
                  },
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
