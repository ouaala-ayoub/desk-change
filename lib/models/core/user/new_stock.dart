class Currency {
  String amount;
  String mad; // Moroccan Dirham

  Currency({
    this.amount = '0',
    this.mad = '0',
  });

  factory Currency.fromMap(Map<String, dynamic> map) {
    return Currency(
      amount: map['amount'].toString(),
      mad: map['mad'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'mad': mad,
    };
  }
}

class Stock {
  Currency mad;
  Currency omr;
  Currency eur;
  Currency jpy;
  Currency gbp;
  Currency aed;
  Currency qar;
  Currency usd;
  Currency cad;
  Currency sar;
  Currency kwd;
  Currency bhd;
  Currency gip;
  Currency chf;

  Stock({
    required this.mad,
    required this.omr,
    required this.eur,
    required this.jpy,
    required this.gbp,
    required this.aed,
    required this.qar,
    required this.usd,
    required this.cad,
    required this.sar,
    required this.kwd,
    required this.bhd,
    required this.gip,
    required this.chf,
  });

  static const emptyStock = {'amount': '0', 'mad': '0'};

  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      mad: Currency.fromMap(map['MAD'] ?? emptyStock),
      omr: Currency.fromMap(map['OMR'] ?? emptyStock),
      eur: Currency.fromMap(map['EUR'] ?? emptyStock),
      jpy: Currency.fromMap(map['JPY'] ?? emptyStock),
      gbp: Currency.fromMap(map['GBP'] ?? emptyStock),
      aed: Currency.fromMap(map['AED'] ?? emptyStock),
      qar: Currency.fromMap(map['QAR'] ?? emptyStock),
      usd: Currency.fromMap(map['USD'] ?? emptyStock),
      cad: Currency.fromMap(map['CAD'] ?? emptyStock),
      sar: Currency.fromMap(map['SAR'] ?? emptyStock),
      kwd: Currency.fromMap(map['KWD'] ?? emptyStock),
      bhd: Currency.fromMap(map['BHD'] ?? emptyStock),
      gip: Currency.fromMap(map['GIP'] ?? emptyStock),
      chf: Currency.fromMap(map['CHF'] ?? emptyStock),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'MAD': mad.toMap(),
      'OMR': omr.toMap(),
      'EUR': eur.toMap(),
      'JPY': jpy.toMap(),
      'GBP': gbp.toMap(),
      'AED': aed.toMap(),
      'QAR': qar.toMap(),
      'USD': usd.toMap(),
      'CAD': cad.toMap(),
      'SAR': sar.toMap(),
      'KWD': kwd.toMap(),
      'BHD': bhd.toMap(),
      'GIP': gip.toMap(),
      'CHF': chf.toMap(),
    };
  }
}
