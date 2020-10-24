String userID;
String userRole;
Map<String, dynamic> userData = {};
Map<String, dynamic> get kCurrentuserData => userData;

String get kCurrentUserID => userID;
String get kCurrentUserRole => userRole;

void setCurrentUserID(String userid) {
  userID = userid;
}

void setCurrentUserRole(String role) {
  userRole = role;
}

void setCurrentUserData(Map<String, dynamic> data) {
  userData = data;
}
