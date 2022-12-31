import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lovelace/screens/user/initialise/init_display_pic_screen.dart';
import 'package:lovelace/utils/colors.dart';

class InitProfilePicScreen extends StatefulWidget {
  final String birthday;
  final String location;

  const InitProfilePicScreen(
      {super.key, required this.birthday, required this.location});

  @override
  State<InitProfilePicScreen> createState() =>
      _InitProfilePicScreenState(birthday, location);
}

class _InitProfilePicScreenState extends State<InitProfilePicScreen> {
  _InitProfilePicScreenState(this.birthday, this.location);
  final String birthday;
  final String location;
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  bool _isDefault = true;

  @override
  void dispose() {
    super.dispose();
  }

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
                                  'First Time Login',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: primaryColor, fontSize: 20),
                                ))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'What is your profile picture?',
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
                    CircleAvatar(
                      radius: 125,
                      backgroundColor: Colors.grey,
                      child: GestureDetector(
                        onTap: () async {
                          XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              _image = image;
                              _isDefault = false;
                            });
                          }
                        },
                        child: Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            border: Border.all(color: borderColor),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: _isDefault
                                  ? const AssetImage(
                                      'assets/images/landing_user.jpeg')
                                  : AssetImage(_image!.path),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                        onPressed: () async {
                          bool imageIsValid = _image != null;

                          if (!imageIsValid) {
                            String message = "Invalid ";
                            if (!imageIsValid) {
                              message += "image";
                            }
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(message),
                              backgroundColor: errorColor,
                            ));
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InitDisplayPicScreen(
                                      birthday: birthday,
                                      location: location,
                                      profilePic: _image,
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
