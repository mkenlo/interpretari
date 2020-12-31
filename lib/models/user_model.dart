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

  static List<User> asListFromJson(List<dynamic> json) {
    return json.map((i) => User.fromJson(i)).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'username': username,
        'first_name': firstName,
        'last_name': lastName,
      };

  @override
  String toString() {
    return 'User{id: $id, email: $email, username: $username, firstName: $firstName, lastName: $lastName}';
  }
}
