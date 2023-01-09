class User {
  final String email;
  final String password;
  final int otp;
  final String otpExpiry;

  User(
      {required this.email,
      required this.password,
      this.otp = -1,
      this.otpExpiry = ""});

  User.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        password = json['password'],
        otp = json['otp'],
        otpExpiry = json['otp_expiry'];

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'otp': otp,
        'otp_expiry': otpExpiry,
      };
}
