import "dart:async";
import 'dart:convert';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';
import '../models/user_model.dart';

class UserService {
  final FacebookLogin facebookSignIn = new FacebookLogin();
  final url = '$apiAuthorityUrl/users';

  Future<int> fbLogin() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        User userProfile = await loadUserProfile(result.accessToken.token);
        saveProfileIntoPreferences(userProfile);
        return 1;
      case FacebookLoginStatus.cancelledByUser:
        return 0;
      case FacebookLoginStatus.error:
        return -1;
    }
    return 0;
  }

  void doLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userProfile", null);
    if (await facebookSignIn.isLoggedIn) {
      await facebookSignIn.logOut();
    }
    // TODO : Implement Email/Password  Logout feature
  }

  int doLogin() {
    // TODO : Implement Email/Password Sign In feature
    return 1;
  }

  Future<User> loadUserProfile(dynamic accessToken) async {
    String queryFields = "name,first_name,last_name,email,picture";

    final graphResponse = await http.get(
        "https://graph.facebook.com/v4.0/me?fields=$queryFields&access_token=$accessToken");
    final jsonProfile = json.decode(graphResponse.body);

    return new User(
        email: jsonProfile['email'],
        firstName: jsonProfile['first_name'],
        lastName: jsonProfile['last_name'],
        username: jsonProfile['email']);
  }

  void saveProfileIntoPreferences(User userProfile) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      User user = await findUserProfile(userProfile.username);
      if (user == null) {
        // first login
        user = await createUserProfile(userProfile);
      }
      await prefs.setString("userProfile", json.encode(user));
    } on Exception catch (e) {
      // TODO
    }
  }

  Future<User> createUserProfile(User user) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    final response = await http.post(url,
        body: json.encode({
          "username": user.username,
          "email": user.email,
          "first_name": user.firstName,
          "last_name": user.lastName
        }),
        headers: requestHeaders);
    final jsonResponse = json.decode(response.body);
    if (response.statusCode != 201) {
      throw Exception("Error while creating new user");
    } else
      return User.fromJson(jsonResponse);
  }

  Future<User> getProfileInfoFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = prefs.getString("userProfile");
    if (user != null)
      return User.fromJson(json.decode(user));
    else
      return null;
  }

  Future<User> findUserProfile(String username) async {
    final response = await http.get('$url?username=$username');

    if (response.statusCode == 200) {
      final results = User.asListFromJson(json.decode(response.body));
      if (results.length > 0) return results.first;
    } else {
      throw Exception('Failed to load Data');
    }
    return null;
  }
}
