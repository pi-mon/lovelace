import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SetPinScreen extends StatefulWidget {
  const SetPinScreen({super.key});

  @override
  State<SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  TextEditingController pinController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    pinController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(resizeToAvoidBottomInset: false, body: content()),
    );
  }

  Widget content() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
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
                          'Set your PIN',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: primaryColor, fontSize: 20),
                        ))),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: PinCodeTextField(
              appContext: context,
              controller: pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              length: 6,
              cursorHeight: 16,
              enableActiveFill: true,
              textStyle: const TextStyle(
                  color: whiteColor, fontSize: 20, fontWeight: FontWeight.bold),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                fieldWidth: 50,
                inactiveColor: Colors.grey,
                inactiveFillColor: Colors.grey.shade50,
                selectedColor: primaryColor, // color of border of selected box
                activeFillColor: primaryColor,
                selectedFillColor: primaryColor,
                borderWidth: 1,
                borderRadius:
                    BorderRadius.circular(10), // color of the box when selected
              ),
              onChanged: (value) {
                print(pinController.text);
              },
            ),
          ),
          const SizedBox(height: 30),
          // submit button
          ElevatedButton(
              onPressed: () async {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 50),
                backgroundColor: primaryColor,
              ),
              child: const Icon(Icons.check_rounded, size: 50)),
        ],
      ),
    );
  }
}
