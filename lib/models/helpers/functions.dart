String formatNumberWithCommas(double number) =>
    number.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match.group(1)},',
        );

double tauxCalcul(String mad, String amount) {
  final taux = (double.parse(mad) / double.parse(amount));
  return taux.isFinite ? taux : 0.0;
}
