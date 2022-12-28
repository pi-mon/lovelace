class User:
    def __init__(self, display_name, email, password):
        self.display_name = display_name
        self.email = email
        self.password = password
        self.otp = 0
        self.otp_expiry = 0


class UserDetails:
    def __init__(self, email, age, location):
        self.email = email
        self.age = age
        self.location = location
        self.profile_pic = ""
        self.card_pic = ""
