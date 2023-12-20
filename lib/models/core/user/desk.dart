import 'dart:convert';

import 'package:gestionbureaudechange/models/core/mappable.dart';
import 'package:gestionbureaudechange/models/core/user/new_stock.dart';

class Desk extends Mapable {
  String? id;
  String? name;
  Stock? stock;
  List<dynamic>? users;
  int? v;

  Desk({this.id, this.name, this.stock, this.users, this.v});

  @override
  String toString() {
    return 'Desk(id: $id, name: $name, stock: $stock, users: $users, v: $v)';
  }

  factory Desk.fromMap(Map<String, dynamic> data) => Desk(
        id: data['_id'] as String?,
        name: data['name'] as String?,
        stock: data['stock'] == null
            ? null
            : Stock.fromMap(data['stock'] as Map<String, dynamic>),
        users: data['users'] as List<dynamic>?,
        v: data['__v'] as int?,
      );

  @override
  Map<String, dynamic> toMap() => {
        '_id': id,
        'name': name,
        'stock': stock?.toMap(),
        'users': users,
        '__v': v,
      }..removeWhere((dynamic key, dynamic value) => value == null);

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Desk].
  factory Desk.fromJson(String data) {
    return Desk.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Desk] to a JSON string.
  String toJson() => json.encode(toMap());

  Desk copyWith({
    String? id,
    String? name,
    Stock? stock,
    List<dynamic>? users,
    int? v,
  }) {
    return Desk(
      id: id ?? this.id,
      name: name ?? this.name,
      stock: stock ?? this.stock,
      users: users ?? this.users,
      v: v ?? this.v,
    );
  }
}
