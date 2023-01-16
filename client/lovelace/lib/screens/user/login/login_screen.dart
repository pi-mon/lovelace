import 'package:flutter/material.dart';
import 'package:lovelace/resources/authenticate_methods.dart';
import 'package:lovelace/screens/user/login/login_verify_screen.dart';
import 'package:lovelace/screens/user/register/register_details_screen.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // final controllerToken = TextEditingController();
  final _authenticateMethods = AuthenticateMethods();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
                                'Login',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: primaryColor, fontSize: 20),
                              ))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Enter email and password',
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
                    label: "Email",
                    hintText: "Enter your email",
                    textInputType: TextInputType.emailAddress,
                    textEditingController: _emailController,
                    validator: (value) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFieldInput(
                    label: "Password",
                    hintText: "Enter your password",
                    textInputType: TextInputType.text,
                    textEditingController: _passwordController,
                    isPass: true,
                    validator: (value) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 128),
                  Flexible(
                    flex: 1,
                    child: Container(),
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus
                          ?.unfocus(); // closes keyboard on login
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const RegisterDetailsScreen();
                      }));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text(
                          "Not a user?",
                          style: TextStyle(color: linkColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 50),
                      backgroundColor: primaryColor,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(whiteColor),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    onPressed: () async {
                      if (_isLoading) return;
                      setState(() {
                        _isLoading = true;
                      });
                      if (_formKey.currentState!.validate()) {
                        final String email = _emailController.text;
                        final String password = _passwordController.text;

                        List response = await _authenticateMethods.login(
                          email: email,
                          password: password,
                        );

                        String output = response[0];
                        String message = response[1];
                        bool isSuccess = response[2];

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(message),
                          backgroundColor: isSuccess
                              ? const SnackBarThemeData().backgroundColor
                              : errorColor,
                        ));

                        if (isSuccess) {
                          setState(() {
                            _isLoading = true;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginVerifyScreen(
                                      email: email,
                                      password: password,
                                    )),
                          );
                          setState(() {
                            _isLoading = false;
                          });
                        } else {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      } else {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                  ),
                ])),
      )),
    );
  }
}
