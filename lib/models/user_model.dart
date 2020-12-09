class User {
  int id;
  String email;
  String username;
  String firstName;
  String lastName;

  User({
    this.id,
    this.email,
    this.username,
    this.firstName,
    this.lastName,
  });

  String fullName() => "$firstName $lastName";

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["id"],
        email: json['email'],
        username: json['username'],
        firstName: json['first_name'],
        lastName: json['last_name']);
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'first_name': firstName,
        'last_name': lastName,
      };
}
