import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/core/transaction.dart';
import '../../models/helpers/functions.dart';

class TransactionWidget extends StatelessWidget {
  final Transaction transaction;

  const TransactionWidget({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    bool isBuy = transaction.type == TransactionType.buy.type;
    String inValue = isBuy
        ? "${formatNumberWithCommas(transaction.amount!.toDouble())} ${transaction.currency}"
        : "${formatNumberWithCommas(transaction.mad ?? 0.0)} MAD";

    String outValue = isBuy
        ? "${formatNumberWithCommas(transaction.amount! * transaction.currencyValue!)} MAD"
        : "${formatNumberWithCommas(transaction.amount!.toDouble())} ${transaction.currency}";

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Type : ${transaction.type}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text("ID: ${transaction.id}"),
            Row(
              children: [
                const Icon(
                  Icons.add,
                  color: Colors.green,
                ),
                Text(inValue),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.sync_outlined,
                  color: Colors.black,
                ),
                Text("Taux: ${transaction.currencyValue.toString()}"),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.remove,
                  color: Colors.red,
                ),
                Text(outValue),
              ],
            ),
            Text(
              'crée le ${transaction.createdAt}',
              style:
                  const TextStyle(color: CupertinoColors.black, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}

enum TransactionType {
  buy(type: 'achat'),
  sell(type: 'vente');

  const TransactionType({
    required this.type,
  });

  final String type;
}
