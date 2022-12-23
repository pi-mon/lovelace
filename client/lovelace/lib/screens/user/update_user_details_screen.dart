import 'package:flutter/material.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/text_field_input.dart';

class UpdateUserDetailsScreen extends StatefulWidget {
  const UpdateUserDetailsScreen({super.key});

  @override
  State<UpdateUserDetailsScreen> createState() =>
      _UpdateUserDetailsScreenState();
}

class _UpdateUserDetailsScreenState extends State<UpdateUserDetailsScreen> {
  final TextEditingController _updateEmailController = TextEditingController();
  final TextEditingController _updatePasswordController =
      TextEditingController();
  final TextEditingController _updateLocationController =
      TextEditingController();
  final TextEditingController _updateUsernameController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _updateEmailController.dispose();
    _updateUsernameController.dispose();
    _updateLocationController.dispose();
    _updatePasswordController.dispose();
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
                textEditingController: _updateEmailController,
                validator: (value) {},
              ),
              const SizedBox(height: 16),
              TextFieldInput(
                label: "Password",
                hintText: "Enter your password",
                textInputType: TextInputType.emailAddress,
                textEditingController: _updatePasswordController,
                validator: (value) {},
              ),
              const SizedBox(height: 16),
              TextFieldInput(
                label: "Username",
                hintText: "Enter your username",
                textInputType: TextInputType.emailAddress,
                textEditingController: _updateUsernameController,
                validator: (value) {},
              ),
              const SizedBox(height: 16),
              TextFieldInput(
                label: "Location",
                hintText: "Enter your location",
                textInputType: TextInputType.emailAddress,
                textEditingController: _updateLocationController,
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String email = _updateEmailController.text;
                    String password = _updatePasswordController.text;
                    String username = _updateUsernameController.text;
                    String location = _updateLocationController.text;
                  }
                },
              )
            ],
          ),
        ),
      )),
    );
  }
}
