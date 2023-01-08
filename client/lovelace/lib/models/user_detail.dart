class UserDetails {
  final String email;
  final String displayName;
  final String birthday;
  final String gender;
  final String location;
  final String profilePicPath;
  final String displayPicPath;

  UserDetails(
      {required this.email,
      required this.displayName,
      required this.birthday,
      required this.gender,
      required this.location,
      required this.profilePicPath,
      required this.displayPicPath});

  UserDetails.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        displayName = json['displayName'],
        birthday = json['birthday'],
        gender = json['gender'],
        location = json['location'],
        profilePicPath = json['profilePic'] ?? "",
        displayPicPath = json['displayPic'] ?? "";

  Map<String, dynamic> toJson() => {
        'email': email,
        'displayName': displayName,
        'birthday': birthday,
        'gender': gender,
        'location': location,
        'profilePicPath': profilePicPath,
        'displayPicPath': displayPicPath,
      };

  @override
  String toString() =>
      'UserDetails{email: $email, displayName: $displayName, birthday: $birthday, location: $location, gender: $gender, profilePicPath: $profilePicPath, displayPicPath: $displayPicPath}';
}
