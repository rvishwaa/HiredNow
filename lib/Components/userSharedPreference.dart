import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreference {

  late SharedPreferences _preferences;
  static const _userId = 'userId';
  static const _authToken = 'authToken';
  static const _username = 'username';
  static const _email = 'email';
  static const _dob = 'dob';

  Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  Future setUserId(String userId) async =>
    await _preferences.setString(_userId, userId) ;

  String? getUserId() => _preferences.getString(_userId);

  Future setAuthToken(String authToken) async =>
    await _preferences.setString(_authToken, authToken) ;

  String? getAuthToken() => _preferences.getString(_authToken);

  Future setUsername(String username) async =>
      await _preferences.setString(_username, username) ;

  String? getUsername() => _preferences.getString(_username);

  Future setEmail(String email) async =>
      await _preferences.setString(_email, email) ;

  String? getEmail() => _preferences.getString(_email);

  Future setDob(String dob) async =>
      await _preferences.setString(_dob, dob) ;

  String? getDob() => _preferences.getString(_dob);

}