import 'package:flutter/material.dart';
import 'package:lovelace/models/user.dart';
import 'package:lovelace/resources/authenticate_methods.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:lovelace/widgets/text_field_input.dart';

class UpdateUserDetailsScreen extends StatefulWidget {
  const UpdateUserDetailsScreen({super.key});

  @override
  State<UpdateUserDetailsScreen> createState() =>
      _UpdateUserDetailsScreenState();
}

class _UpdateUserDetailsScreenState extends State<UpdateUserDetailsScreen> {
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newLocationController = TextEditingController();
  final TextEditingController _newUsernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Future<List<User>> getData() async {
  //   String route = "/account/test";
  //   final response = await http.get(Uri.http(route));
  //   var responseData = json.decode(response.body);
  //   debugPrint('Response from get method: $responseData');

  //   // Create a list to store the retrieved user data
  //   List<User> users = [];
  //   for (var userData in responseData) {
  //     User user =
  //         User(email: userData["email"], password: userData["password"]);
  //     users.add(user);
  //   }
  //   debugPrint('$users');
  //   return users;
  // }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    // TODO: Get the user data from server side

    // setState(() {
    //   this._newEmailController.text =
    //   this._newPasswordController.text =
    //   this._newLocationController.text =
    //   this._newUsernameController.text =
    // });
  }

  @override
  void dispose() {
    _newEmailController.dispose();
    _newUsernameController.dispose();
    _newLocationController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          width: double.infinity,
          child: Column(
            children: <Widget>[
              const Text(
                'Update User Details',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
              const SizedBox(height: 20),
              TextFieldInput(
                label: "Email",
                hintText: "Enter your email",
                textInputType: TextInputType.emailAddress,
                textEditingController: _newEmailController,
                validator: (value) {},
              ),
              const SizedBox(height: 16),
              TextFieldInput(
                label: "Password",
                hintText: "Enter your password",
                textInputType: TextInputType.text,
                textEditingController: _newPasswordController,
                validator: (value) {},
              ),
              const SizedBox(height: 16),
              TextFieldInput(
                label: "Username",
                hintText: "Enter your username",
                textInputType: TextInputType.text,
                textEditingController: _newUsernameController,
                validator: (value) {},
              ),
              const SizedBox(height: 16),
              TextFieldInput(
                label: "Location",
                hintText: "Enter your location",
                textInputType: TextInputType.text,
                textEditingController: _newLocationController,
                validator: (value) {},
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
                  // if (_formKey.currentState!.validate()) {
                  //   String email = _newEmailController.text;
                  //   String password = _newPasswordController.text;
                  //   String username = _newUsernameController.text;
                  //   String location = _newLocationController.text;

                  //   // call update function to send request to server side to update user details
                  //   List response = await AuthenticateMethods().updateUserDetails(
                  //       email: _newEmailController.text,
                  //       password: _newPasswordController.text);

                  //   String output = response[0];
                  //   String message = response[1];
                  //   bool isUpdated = response[2];

                  //   // ignore: use_build_context_synchronously
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
    );
  }
}
