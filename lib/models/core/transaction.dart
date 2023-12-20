import 'dart:convert';

class Transaction {
  String? id;
  String? type;
  String? currency;
  double? amount;
  double? mad;
  double? currencyValue;
  String? desk;
  double? acv;
  double? profit;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Transaction({
    this.id,
    this.type,
    this.currency,
    this.amount,
    this.mad,
    this.currencyValue,
    this.desk,
    this.acv,
    this.profit,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Transaction.fromMap(Map<String, dynamic> data) => Transaction(
        id: data['_id'] as String?,
        type: data['type'] as String?,
        currency: data['currency'] as String?,
        amount: (data['amount'] as num?)?.toDouble(),
        mad: (data['mad'] as num?)?.toDouble(),
        currencyValue: (data['currencyValue'] as num?)?.toDouble(),
        desk: data['desk'] as String?,
        profit: (data['profit'] as num?)?.toDouble(),
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        updatedAt: data['updatedAt'] == null
            ? null
            : DateTime.parse(data['updatedAt'] as String),
        v: data['__v'] as int?,
      );

  Map<String, dynamic> toMap() => {
        '_id': id,
        'type': type,
        'currency': currency,
        'amount': amount,
        'mad': mad,
        'currencyValue': currencyValue,
        'desk': desk,
        'acv': acv,
        'profit': profit,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Transaction].
  factory Transaction.fromJson(String data) {
    return Transaction.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Transaction] to a JSON string.
  String toJson() => json.encode(toMap());

  Transaction copyWith({
    String? id,
    String? type,
    String? currency,
    double? amount,
    double? mad,
    double? currencyValue,
    String? desk,
    double? acv,
    double? profit,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return Transaction(
      id: id ?? this.id,
      type: type ?? this.type,
      currency: currency ?? this.currency,
      amount: amount ?? this.amount,
      mad: mad ?? this.mad,
      currencyValue: currencyValue ?? this.currencyValue,
      desk: desk ?? this.desk,
      acv: acv ?? this.acv,
      profit: profit ?? this.profit,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
