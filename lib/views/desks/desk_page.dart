import 'package:flutter/material.dart';
import 'package:gestionbureaudechange/models/helpers/desks_helper.dart';
import 'package:gestionbureaudechange/providers/entity_page_provider.dart';
import 'package:provider/provider.dart';
import '../../models/core/transaction.dart';
import '../helper_widgets/error_screen.dart';
import '../helper_widgets/stock_widget.dart';
import '../helper_widgets/transaction_widget.dart';

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
    context
        .read<FilterableEntity<DeskAndTransactions, Transaction>>()
        .getData(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page de bureau')),
      body: Consumer<FilterableEntity<DeskAndTransactions, Transaction>>(
          builder: (context, value, child) {
        return value.loading
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
                return value.filterRes.fold(
                    (e) => ErrorScreen(
                        refreshFunction: () => value.getData(widget.id),
                        message: 'error'),
                    (transactions) => RefreshIndicator(
                          child: onLoadingComplete(data, transactions, value),
                          onRefresh: () async {
                            await value.getData(widget.id);
                          },
                        ));
              }));
      }),
    );
  }

  Padding onLoadingComplete(DeskAndTransactions data,
      List<Transaction> transactions, FilterableEntity provider) {
    final stockEmpty = data.desk.stock?.toMap().isEmpty;
    final transactionsEmpty = transactions.isEmpty;

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
              Column(
                children: [
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Filtre :',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('achat'),
                          selected: provider.filters['type'] == 'achat',
                          onSelected: (selected) => provider.handleSelection(
                              selected, 'type', 'achat'),
                        ),
                      ),
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('vente'),
                          selected: provider.filters['type'] == 'vente',
                          onSelected: (selected) => provider.handleSelection(
                              selected, 'type', 'vente'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                          onPressed: () async {
                            final selected = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2050));

                            if (selected != null) {
                              provider.setFilter('date', selected);
                            }
                          },
                          child: Text(provider.filters['date'] != null
                              ? provider.filters['date']
                                  .toString()
                                  .split(' ')[0]
                              : 'Choisir une date')),
                      OutlinedButton(
                          onPressed: () {
                            if (provider.filters['date'] != null) {
                              provider.setFilter('date', null);
                            }
                          },
                          child: Text('Clear'))
                    ],
                  ),
                  !transactionsEmpty
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = transactions[index];
                            return TransactionWidget(transaction: transaction);
                          },
                        )
                      : const Text('Pas de transactions Enregistrées')
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
