class User:
    def __init__(self, email, password):
        self.email = email
        self.password = password
        self.username = ""
        self.otp = 0
        self.otp_expiry = 0


class UserDetails:
    def __init__(self,email ,username, age, location):
        self.email = email
        self.username = username
        self.age = age
        self.location = location
        self.profile_pic = ""
        self.card_pic = ""