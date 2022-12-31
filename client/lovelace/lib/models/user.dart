class User {
  final String email;
  final String password;
  final String displayName;
  final int otp;
  final String otpExpiry;

  User(
      {required this.email,
      required this.password,
      this.displayName = "",
      this.otp = -1,
      this.otpExpiry = ""});

  User.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        password = json['password'],
        displayName = json['displayName'],
        otp = json['otp'],
        otpExpiry = json['otpExpiry'];

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'displayName': displayName,
        'otp': otp,
        'otpExpiry': otpExpiry,
      };
}
