class BureauEntry {
  String currency;
  String montant;
  String mad;

  BureauEntry(this.montant, this.currency, this.mad);

  @override
  String toString() {
    return 'Bureau(montant=$montant, mad=$mad, currency=$currency)';
  }
}
