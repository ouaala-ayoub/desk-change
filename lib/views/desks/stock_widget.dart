import 'package:flutter/material.dart';
import '../../models/helpers/functions.dart';

class StockWidget extends StatefulWidget {
  const StockWidget({
    super.key,
    required this.stockKey,
    required this.value,
    required this.tauxValue,
  });
  final String stockKey;
  final Map<dynamic, dynamic> value;
  final double tauxValue;

  @override
  State<StockWidget> createState() => _StockWidgetState();
}

class _StockWidgetState extends State<StockWidget> {
  bool _isTauxVisible = false;

  switchTauxVisibility() {
    setState(() {
      _isTauxVisible = !_isTauxVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => switchTauxVisibility(),
      child: Card(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                      text: '${widget.stockKey} : ',
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                      children: [
                        TextSpan(
                            text: formatNumberWithCommas(
                                double.parse(widget.value['amount'])),
                            style: const TextStyle(color: Color(0xff202c34)))
                      ]),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.sync_outlined,
                      color: Colors.black,
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Taux Moyen : ',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                                text: formatNumberWithCommas(widget.tauxValue),
                                style:
                                    const TextStyle(color: Color(0xff202c34)))
                          ]),
                    ),
                  ],
                ),
                RichText(
                  text: TextSpan(
                      text: 'MAD : ',
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                      children: [
                        TextSpan(
                            text: formatNumberWithCommas(
                                double.parse(widget.value['mad'])),
                            style: const TextStyle(color: Color(0xff202c34)))
                      ]),
                ),
                Visibility(
                  visible: _isTauxVisible,
                  child: Text(
                    'Taux Moyen exacte : ${widget.tauxValue}',
                    style: const TextStyle(
                        color: Color(0xff202c34),
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
