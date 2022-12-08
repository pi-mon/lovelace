class User:
  
  def __init__(self,username,password,email):
    self._id = email
    self.password = password
    self.username = username

class User_details:

  def __init__(self,id,age,location):
    self.id = id
    self.age = age
    self.location = location
