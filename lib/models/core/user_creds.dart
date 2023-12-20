import 'dart:convert';

class UserCredentiels {
  String? userName;
  String? password;

  UserCredentiels({this.userName, this.password});

  @override
  String toString() => 'UserCreds(userName: $userName, password: $password)';

  factory UserCredentiels.fromMap(Map<String, dynamic> data) => UserCredentiels(
        userName: data['userName'] as String?,
        password: data['password'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'userName': userName,
        'password': password,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UserCreds].
  factory UserCredentiels.fromJson(String data) {
    return UserCredentiels.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UserCreds] to a JSON string.
  String toJson() => json.encode(toMap());
}
