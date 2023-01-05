import 'package:flutter/material.dart';
import 'package:lovelace/screens/user/initialise/init_profile_pic_screen.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lovelace/widgets/text_field_input.dart';
import 'package:geocoding/geocoding.dart';

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  Position coordinates = await Geolocator.getCurrentPosition();
  return coordinates;
}

Future<String> _getLocation() async {
  String location = "";
  Position position = await _determinePosition();
  List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
  Placemark placemark = placemarks[0];
  if (placemark.locality != "") {
    location += "${placemark.locality}, ";
  }
  location += "${placemark.country}";
  return location;
}

class InitLocationScreen extends StatefulWidget {
  final String gender;
  final String birthday;

  const InitLocationScreen({super.key, required this.gender, required this.birthday});

  @override
  State<InitLocationScreen> createState() => _InitLocationScreenState(gender, birthday);
}

class _InitLocationScreenState extends State<InitLocationScreen> {
  _InitLocationScreenState(this.birthday, this.gender);
  final String birthday;
  final String gender;
  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _locationController.dispose();
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
                      'Where do you live?',
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
                      onTap: () async {
                        String location = await _getLocation();
                        _locationController.text = location;
                      },
                      label: "Location",
                      hintText: "Tap to get your location",
                      textInputType: TextInputType.text,
                      textEditingController: _locationController,
                      validator: (value) {
                        return null;
                      },
                    ),
                    const SizedBox(height: 128),
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                        onPressed: () async {
                          String location = _locationController.text;

                          bool locationIsValid = location.isNotEmpty;

                          if (!locationIsValid) {
                            String message = "Invalid ";
                            if (!locationIsValid) {
                              message += "location";
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
                                builder: (context) => InitProfilePicScreen(
                                    birthday: birthday,
                                    location: _locationController.text,
                                    gender: gender)),
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
