import 'package:flutter/material.dart';
import 'package:lovelace/screens/user/initialise/init_profile_pic_screen.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lovelace/widgets/text_field_input.dart';
import 'package:geocoding/geocoding.dart';

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  Position coordinates = await Geolocator.getCurrentPosition();
  return coordinates;
}

Future<String> _getLocation() async {
  String location = "";
  Position position = await _determinePosition();
  List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude, position.longitude,
      localeIdentifier: "en");
  Placemark placemark = placemarks[0];
  if (placemark.locality != "") {
    location += "${placemark.locality}, ";
  }
  location += "${placemark.country}";
  return location;
}

class InitLocationScreen extends StatefulWidget {
  final String displayName;
  final String gender;
  final String birthday;

  const InitLocationScreen(
      {super.key,
      required this.displayName,
      required this.gender,
      required this.birthday});

  @override
  State<InitLocationScreen> createState() => _InitLocationScreenState();
}

class _InitLocationScreenState extends State<InitLocationScreen> {
  _InitLocationScreenState();
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
                                builder: (context) => InitprofilePicScreen(
                                      displayName: widget.displayName,
                                      gender: widget.gender,
                                      birthday: widget.birthday,
                                      location: _locationController.text,
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
