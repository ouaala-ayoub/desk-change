import 'dart:convert';

class Admin {
  final String? id;
  final String? name;
  final String? userName;
  final String? password;
  final int? v;

  const Admin({this.id, this.name, this.userName, this.password, this.v});

  @override
  String toString() {
    return 'Admin(id: $id, name: $name, userName: $userName, password: $password, v: $v)';
  }

  factory Admin.fromMap(Map<String, dynamic> data) => Admin(
        id: data['_id'] as String?,
        name: data['name'] as String?,
        userName: data['userName'] as String?,
        password: data['password'] as String?,
        v: data['__v'] as int?,
      );

  Map<String, dynamic> toMap() => {
        '_id': id,
        'name': name,
        'userName': userName,
        'password': password,
        '__v': v,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Admin].
  factory Admin.fromJson(String data) {
    return Admin.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Admin] to a JSON string.
  String toJson() => json.encode(toMap());

  Admin copyWith({
    String? id,
    String? name,
    String? userName,
    String? password,
    int? v,
  }) {
    return Admin(
      id: id ?? this.id,
      name: name ?? this.name,
      userName: userName ?? this.userName,
      password: password ?? this.password,
      v: v ?? this.v,
    );
  }
}
