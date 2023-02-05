class UserDetails {
  final String email;
  final String displayName;
  final String birthday;
  final String gender;
  final String location;
  final String profilePic;
  final String displayPic;

  UserDetails(
      {required this.email,
      required this.displayName,
      required this.birthday,
      required this.gender,
      required this.location,
      required this.profilePic,
      required this.displayPic});

  UserDetails.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        displayName = json['display_name'],
        birthday = json['birthday'],
        gender = json['gender'],
        location = json['location'],
        profilePic = json['profile_pic'] ?? "",
        displayPic = json['display_pic'] ?? "";

  Map<String, dynamic> toJson() => {
        'email': email,
        'display_name': displayName,
        'birthday': birthday,
        'gender': gender,
        'location': location,
        'profile_pic': profilePic,
        'display_pic': displayPic,
      };

  @override
  String toString() =>
      'UserDetails{email: $email, displayName: $displayName, birthday: $birthday, location: $location, gender: $gender, profilePic: $profilePic, displayPic: $displayPic}';
}
