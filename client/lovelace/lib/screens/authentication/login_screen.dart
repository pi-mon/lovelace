import 'package:flutter/material.dart';
import 'package:lovelace/models/storage_item.dart';
import 'package:lovelace/resources/auth_methods.dart';
import 'package:lovelace/responsive/mobile_screen_layout.dart';
import 'package:lovelace/responsive/responsive_layout.dart';
import 'package:lovelace/responsive/web_screen_layout.dart';
import 'package:lovelace/screens/authentication/register_email_screen.dart';
import 'package:lovelace/services/storage_service.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _userPages = const ResponsiveLayout(
      mobileScreenLayout: MobileScreenLayout(),
      webScreenLayout: WebScreenLayout());
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  // final StorageService _storageService = StorageService();
  // late List<StorageItem> _items;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  // void iniState() async {
  //   super.initState();
  //   initList();
  // }

  // void initList() async {
  //   _items = await _storageService.readAllSecureData(); // use the readAll method to update the list with all data in secure storage
  //   _isLoading = false;
  //   setState(() {});
  // }

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
                                    color: primaryColor, fontSize: 20
                                  ),
                              )
                            )
                          ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Enter email and password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                      ),
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
                    validator: (value) {},
                  ),
                  const SizedBox(height: 16),
                  TextFieldInput(
                    label: "Password",
                    hintText: "Enter your password",
                    textInputType: TextInputType.text,
                    textEditingController: _passwordController,
                    isPass: true,
                    validator: (value) {},
                  ),
                  const SizedBox(height: 128),
                  Flexible(
                    flex: 1,
                    child: Container(),
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus(); // closes keyboard on login
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const RegisterEmailScreen();
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
                    child: const Text("Login",
                        style: TextStyle(
                          fontSize: 18,
                          color: whiteColor,
                          fontWeight: FontWeight.bold
                          )
                        ),
                    onPressed: () async {                
                      // debugPrint("Test");
                      if (_formKey.currentState!.validate()) {
                        final String email = _emailController.text;
                        final String password = _passwordController.text;
                        String res = await AuthMethods().login(email: email, password: password);

                        if (res.isNotEmpty) {
                          debugPrint(res);  
                          // TODO: STORE TOKEN AND LOGIN CREDENTIALS INSIDE SECURE_STORAGE
                          // StorageService().writeSecureData(StorageItem("JWT TOKEN", res));

                          showDialog(
                            // display pop-up of login status
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content:
                                  SingleChildScrollView(child: Text(res)),
                              );
                            },
                          );
                        }
                        showDialog(
                          // display pop-up of login status
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text(res),
                            );
                          },
                        );
                      }
                    },
                  ),
                ]
              )
            ),
        )        
      ),    
    );
  }
}
