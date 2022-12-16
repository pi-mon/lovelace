import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:lovelace/screens/user/register_password_screen.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/text_field_input.dart';

class RegisterParticularsScreen extends StatefulWidget {
  final String email;
  const RegisterParticularsScreen({super.key, required this.email});

  @override
  State<RegisterParticularsScreen> createState() => _RegisterParticularsScreenState();
}

class _RegisterParticularsScreenState extends State<RegisterParticularsScreen> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  List<num> ageList = [18, 19, 20, 21, 22];
  int selectedAge = 18;

  @override
  void dispose() {
    super.dispose();
    _ageController.dispose();
    _locationController.dispose();
    _usernameController.dispose();
  }

  // void iniState() {
  //   super.initState();
  //   init();
  // }

  // Future init() async {
  //   final email = await SecureStorage().getEmail() ?? '';

  //   setState(() {
  //     this._emailController.text = email;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              width: double.infinity,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: primaryColor,
                          ),
                        ),
                        const Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(right: 32.0),
                                child: Text(
                                  'Register',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: primaryColor, fontSize: 20),
                                ))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Welcome!\nHow are you?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                    TextFieldInput(
                      label: "Username",
                      hintText: "Enter your username",
                      textInputType: TextInputType.text,
                      textEditingController: _usernameController,
                      validator: (value) {},
                    ),
                    DropdownButton<int>(
                      value: selectedAge, 
                      items: ageList.map((age) => DropdownMenuItem<int>(
                        value: age.toInt(), 
                        child: Text('$age'))
                      ).toList(),
                      onChanged: (age) => setState(() {
                        setState(() {
                          selectedAge = age!;
                        });
                    })),
                    const SizedBox(height: 128),
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: () async {
                          String email = _usernameController.text;
                          bool isValid = EmailValidator.validate(email);

                          if (!isValid) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Username already taken!'),
                              backgroundColor: errorColor,
                            ));
                            return;
                          }
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPasswordScreen(
                                      username: _usernameController.text, location: _locationController.text, age: _ageController.hashCode,
                                    )),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 50),
                          backgroundColor: primaryColor,
                        ),
                        child: const Text("Next",
                            style: TextStyle(
                                fontSize: 18,
                                color: whiteColor,
                                fontWeight: FontWeight.bold))),
                  ]))),
    );
  }
}
