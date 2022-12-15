class User {
  // final int id;
  // final String username;
  final String email;
  final String password;
  // final String location;
  // final Image profilepic;

  User({required this.email, required this.password});

  User.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}
