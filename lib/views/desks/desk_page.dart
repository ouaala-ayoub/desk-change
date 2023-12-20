import 'package:flutter/material.dart';
import 'package:gestionbureaudechange/models/helpers/desks_helper.dart';
import 'package:gestionbureaudechange/providers/entity_page_provider.dart';
import 'package:gestionbureaudechange/views/auth_page.dart';
import 'package:provider/provider.dart';
import '../../models/helpers/functions.dart';
import 'transaction_widget.dart';

class DeskPage extends StatefulWidget {
  final String id;
  const DeskPage({required this.id, super.key});

  @override
  State<DeskPage> createState() => _DeskPageState();
}

class _DeskPageState extends State<DeskPage> {
  _DeskPageState();

  @override
  void initState() {
    super.initState();
    context.read<EntityPageProvider<DeskAndTransactions>>().getData(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page de bureau')),
      body: Consumer<EntityPageProvider<DeskAndTransactions>>(
          builder: (context, value, child) {
        return value.loding
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: value.data?.fold((l) {
                return ErrorScreen(
                  message: l.toString(),
                  refreshFunction: () => value.getData(widget.id),
                );
              }, (data) {
                return onLoadingComplete(data);
              }));
      }),
    );
  }

  Padding onLoadingComplete(DeskAndTransactions data) {
    final stockEmpty = data.desk.stock?.toMap().isEmpty;
    final transactionsEmpty = data.transactions.isEmpty;

    //sort by date
    data.transactions.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bureau: ${data.desk.name}',
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Stock :',
                  style: TextStyle(color: Color(0xff202c34), fontSize: 18),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              stockEmpty != true && stockEmpty != null
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.desk.stock?.toMap().length ?? 0,
                      itemBuilder: (context, index) {
                        final map = data.desk.stock!.toMap();
                        final stockKey = map.keys.elementAt(index);
                        final value = map[stockKey];

                        final taux = (double.parse(value['mad']) /
                            double.parse(value['amount']));
                        final tauxValue = taux.isFinite ? taux : 0.0;
                        return GestureDetector(
                          onLongPress: () {
                            // showPopupMenu(context, index.toString());
                          },
                          child: StockWidget(
                              stockKey: stockKey,
                              value: value,
                              tauxValue: tauxValue),
                        );
                      },
                    )
                  : const Text('Pas de stock Enregistré'),
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Historique des transactions :',
                    style: TextStyle(color: Color(0xff202c34), fontSize: 18)),
              ),
              const SizedBox(
                height: 10,
              ),
              !transactionsEmpty
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = data.transactions[index];
                        return TransactionWidget(transaction: transaction);
                      },
                    )
                  : const Text('Pas de transactions Enregistrées')
            ],
          )
        ],
      ),
    );
  }
}

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
