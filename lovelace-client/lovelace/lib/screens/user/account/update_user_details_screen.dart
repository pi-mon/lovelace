import 'dart:convert';
import 'dart:io';
import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lovelace/models/user_detail.dart';
import 'package:lovelace/resources/account_methods.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/utils/global_variables.dart';
import 'package:lovelace/widgets/display_card.dart';
import 'package:lovelace/widgets/dropdown_field_input.dart';
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
  final StorageMethods _storageMethods = StorageMethods();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  File? _ppImage;
  File? _dpImage;
  bool _ppIsDefault = true;
  bool _dpIsDefault = true;
  bool _ppIsLoading = true;
  bool _dpIsLoading = true;
  List<String> dropdownValues = ['Male', 'Female'];

  String displayName = '';
  String email = '';
  String location = '';
  String gender = '';
  String birthday = '';
  String profilePic = '';
  String displayPic = '';

  final TextEditingController _newEmailController =
      TextEditingController(text: "");
  final TextEditingController _newDisplayNameController =
      TextEditingController();
  final TextEditingController _newGenderController =
      TextEditingController(text: "Male");
  final TextEditingController _newBirthdayController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  final TextEditingController _newLocationController =
      TextEditingController(text: "");

  _UpdateUserDetailsScreenState() {
    _storageMethods.read("userDetails").then((value) {
      dynamic valueJson = json.decode(value);
      setState(() {
        _newEmailController.text = valueJson["email"];
        _newDisplayNameController.text = valueJson["display_name"];
        _newGenderController.text = valueJson["gender"];
        _newBirthdayController.text = valueJson["birthday"];
        _newLocationController.text = valueJson["location"];
        profilePic = valueJson["profile_pic"];
        displayPic = valueJson["display_pic"];
        _ppIsLoading = false;
        _dpIsLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _newEmailController.dispose();
    _newDisplayNameController.dispose();
    _newGenderController.dispose();
    _newBirthdayController.dispose();
    _newLocationController.dispose();
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => userPages));
                // Navigator.pop(context);
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
                      // backgroundColor: Colors.grey,
                      child: GestureDetector(
                        onTap: () async {
                          XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              _ppImage = File(image.path);
                              _ppIsDefault = false;
                              _ppIsDefault = false;
                            });
                          }
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: _ppIsDefault
                                  ? (_ppIsLoading
                                      ? Image.asset(
                                              "assets/images/default-profile-picture.png")
                                          .image
                                      : Image.memory(Uint8List.fromList(
                                              base64.decode(profilePic)))
                                          .image)
                                  : Image.file(_ppImage!).image,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 70,
                        right: 5,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: whiteColor,
                              border: Border.all(
                                  color: Colors.grey.shade400, width: 1)),
                          child: const Icon(Icons.edit,
                              color: placeholderColor, size: 20),
                        ))
                  ],
                ),
                const SizedBox(height: 16),
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
                  textEditingController: _newDisplayNameController,
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownFieldInput(
                  textEditingController: _newGenderController,
                  label: "Gender",
                  hintText: "Select gender",
                  dropdownValues: dropdownValues,
                  setState: setState,
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
                        DateFormat('yyyy-MM-dd').format(newDate));
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
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
                  child: GestureDetector(
                    onTap: () async {
                      XFile? image =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setState(() {
                          _dpImage = File(image.path);
                          _dpIsDefault = false;
                          _dpIsDefault = false;
                        });
                      }
                    },
                    child: DisplayCard(
                      image: _dpIsDefault
                          ? (_dpIsLoading
                              ? "assets/images/default-profile-picture.png"
                              : Image.memory(Uint8List.fromList(
                                      base64.decode(profilePic)))
                                  .image)
                          : Image.file(_dpImage!).image,
                      name: _newDisplayNameController.text,
                      age: AgeCalculator.dateDifference(
                              fromDate:
                                  DateTime.parse(_newBirthdayController.text),
                              toDate: DateTime.now())
                          .years,
                      location: _newLocationController.text,
                    ),
                  ),
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
                    // String email = _newEmailController.text;
                    // String displayName = _newDisplayNameController.text;
                    // String birthday = _newBirthdayController.text;
                    // String location = _newLocationController.text;
                    // String gender = dropDownValue;

                    if (_formKey.currentState!.validate()) {
                      String email = _newEmailController.text;
                      String displayName = _newDisplayNameController.text;
                      String gender = _newGenderController.text;
                      String birthday = _newBirthdayController.text;
                      String location = _newLocationController.text;
                      File? profilePic = _ppImage;
                      File? displayPic = _dpImage;

                      UserDetails userDetails = UserDetails(
                        email: email,
                        displayName: displayName,
                        gender: gender,
                        birthday: birthday,
                        location: location,
                        profilePic: profilePic?.path ?? "",
                        displayPic: displayPic?.path ?? "",
                      );

                      //   // call update function to send request to server side to update user details
                      List response = await AccountMethods()
                          .update(userDetails: userDetails);

                      String output = response[0];
                      String message = response[1];
                      bool isSuccess = response[2];

                      print(output);

                      // show snackbar to show the result of the update
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(message),
                        backgroundColor: isSuccess ? successColor : errorColor,
                      ));
                      // scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
                      //   content: Text(message),
                      //   backgroundColor: isSuccess ? successColor : errorColor,
                      // ));
                    }
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
