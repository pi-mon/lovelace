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
        displayName = json['display_name'],
        birthday = json['birthday'],
        gender = json['gender'],
        location = json['location'],
        profilePicPath = json['profile_pic'] ?? "",
        displayPicPath = json['display_pic'] ?? "";

  Map<String, dynamic> toJson() => {
        'email': email,
        'display_name': displayName,
        'birthday': birthday,
        'gender': gender,
        'location': location,
        'profile_pic_path': profilePicPath,
        'display_pic_path': displayPicPath,
      };

  @override
  String toString() =>
      'UserDetails{email: $email, displayName: $displayName, birthday: $birthday, location: $location, gender: $gender, profilePicPath: $profilePicPath, displayPicPath: $displayPicPath}';
}
