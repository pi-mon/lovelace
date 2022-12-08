import argon2


class User:
    def __init__(self, email, password):
        self._id = email
        self.email = email
        self.password = password


class User_details:
    def __init__(self, id, age, location):
        self.id = id
        self.age = age
        self.location = location
