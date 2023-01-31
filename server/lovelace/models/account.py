class User:
    def __init__(self, email, password):
        self.email = email
        self.password = password
        self.otp = 0
        self.otp_expiry = 0


class UserDetails:
    def __init__(self, email, display_name, birthday, gender, location):
        self.email = email
        self.display_name = display_name
        self.birthday = birthday
        self.location = location
        self.gender = gender
        self.profile_pic = ""
        self.display_pic = ""
