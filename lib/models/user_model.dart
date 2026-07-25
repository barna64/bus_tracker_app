class User {
  String uid;
  final String email;
  final String role;
  final String? routeNumber;
  final String? busNumber;

  User({
    required this.uid,
    required this.email,
    required this.role,
    this.routeNumber,
    this.busNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'routeNumber': routeNumber,
      'busNumber': busNumber,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      email: map['email'],
      role: map['role'],
      routeNumber: map['routeNumber'],
      busNumber: map['busNumber'],
    );
  }
}
