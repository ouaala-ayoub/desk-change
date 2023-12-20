import 'dart:convert';
import 'package:gestionbureaudechange/models/core/mappable.dart';

class User extends Mapable {
  String? id;
  String? name;
  String? phone;
  String? email;
  String? userName;
  String? password;
  String? desk;
  int? v;

  User({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.userName,
    this.password,
    this.desk,
    this.v,
  });

  @override
  String toString() {
    return 'User(id: $id, name: $name, phone: $phone, email: $email, userName: $userName, password: $password, desk: $desk, v: $v)';
  }

  factory User.fromMap(Map<String, dynamic> data) => User(
        id: data['_id'] as String?,
        name: data['name'] as String?,
        phone: data['phone'] as String?,
        email: data['email'] as String?,
        userName: data['userName'] as String?,
        password: data['password'] as String?,
        desk: data['desk'] as String?,
        v: data['__v'] as int?,
      );

  @override
  Map<String, dynamic> toMap() => {
        '_id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'userName': userName,
        'password': password,
        'desk': desk,
        '__v': v,
      }..removeWhere((dynamic key, dynamic value) => value == null);

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [User].
  factory User.fromJson(String data) {
    return User.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [User] to a JSON string.
  String toJson() => json.encode(toMap());

  User copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? userName,
    String? password,
    String? desk,
    int? v,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      password: password ?? this.password,
      desk: desk ?? this.desk,
      v: v ?? this.v,
    );
  }
}
