import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:gestionbureaudechange/models/core/mappable.dart';
import 'package:gestionbureaudechange/providers/filtrable_list_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg_flutter.dart';

class FilterableListWidget<T> extends StatefulWidget {
  final String target;
  final String singular;
  final String navKey;
  final String postNavKey;
  const FilterableListWidget(
      this.target, this.singular, this.navKey, this.postNavKey,
      {super.key});

  @override
  State<FilterableListWidget> createState() => _FilterableListWidgetState<T>();
}

class _FilterableListWidgetState<T> extends State<FilterableListWidget> {
  final logger = Logger();
  _FilterableListWidgetState();

  @override
  void initState() {
    super.initState();
    context.read<FilterableListProvider<T>>().getList();
    // requestData();
  }

  requestData() {
    context.read<FilterableListProvider<T>>().getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context),
        body: filterableListBody(context),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              bool? added = await context.push('/${widget.postNavKey}');
              if (added == true) {
                requestData();
              }
            },
            child: const Icon(Icons.add)));
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text('Page des ${widget.target}'),
      leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: const Icon(Icons.arrow_back)),
    );
  }

  ProgressHUD filterableListBody(BuildContext context) {
    return ProgressHUD(
      child: Column(
        children: [
          searchField(onChanged: (query) {
            //filter
            context.read<FilterableListProvider<T>>().runFilter(query);
          }),
          Expanded(
            child: RefreshIndicator.adaptive(
              onRefresh: () =>
                  context.read<FilterableListProvider<T>>().getList(),
              child: Consumer<FilterableListProvider<T>>(
                builder: (context, value, child) {
                  if (value.loading) {
                    logger.d('loding');
                    return const Center(child: CircularProgressIndicator());
                  }
                  return value.found.fold((l) {
                    return Center(
                      child: Text('$l'),
                    );
                  }, (data) {
                    if (data.isEmpty) {
                      return const Center(
                        child: Text('Pas de bureaux'),
                      );
                    } else {
                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) => desksListElement(
                              buildContext: context,
                              item: (data[index] as Mapable).toMap(),
                              popMenu: (id) {
                                logger.d(id);
                              },
                              navigateToItemPage: (id) {
                                context.push('/${widget.navKey}/$id');
                              }));
                    }
                  });
                  // return const Center(
                  //   child: CircularProgressIndicator(),
                  // );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Container searchField({required Function(String) onChanged}) {
    return Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: const Color(0xff1D1617).withOpacity(0.11),
              blurRadius: 40,
              spreadRadius: 0.0)
        ]),
        child: TextField(
          onChanged: (value) {
            onChanged(value);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(15),
            hintText: 'Search Products',
            hintStyle: const TextStyle(
                color: Color.fromARGB(255, 165, 161, 161), fontSize: 14),
            prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset(
                  'assets/icons/Search.svg',
                )),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none),
          ),
        ));
  }

  GestureDetector desksListElement(
      {required Map<String, dynamic> item,
      required Function(String) popMenu,
      required Function(String) navigateToItemPage,
      required BuildContext buildContext}) {
    final menuList = [
      MenuItemButton(
          child: const Text('Supprimer'),
          onPressed: () {
            showDeleteDialog(item['_id'], buildContext);
          }),
      MenuItemButton(
        child: const Text('Modifier les informations'),
        onPressed: () {
          context.push("/${widget.navKey}/${item['_id']}/modify");
        },
      ),
    ];
    if (widget.navKey == 'users') {
      menuList.add(MenuItemButton(
          child: const Text('Change le mot de passe'),
          onPressed: () {
            context.push("/users/${item['_id']}/passwordModify");
          }));
    }
    return GestureDetector(
      onTap: () {
        navigateToItemPage(item['_id']);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        child: Container(
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 0),
                spreadRadius: 0)
          ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(item['name'].toString()),
              MenuAnchor(
                menuChildren: menuList,
                builder: (context, controller, child) {
                  return GestureDetector(
                    onTap: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 8, bottom: 8),
                      child: const Icon(Icons.more_horiz),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showDeleteDialog(String id, BuildContext buildContext) {
    final progress = ProgressHUD.of(buildContext);
    return showDialog(
      context: buildContext,
      builder: (context) => AlertDialog(
        title: Text('Supprimer ce ${widget.singular}?'),
        content: Text(
            'Vous etes sur le point de supprimer un ${widget.singular}, Procéder ?'),
        actions: [
          FilledButton(
            onPressed: () {
              progress?.show();
              buildContext.read<FilterableListProvider<T>>().deleteElement(id,
                  onFail: () {
                    progress?.dismiss();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Erreur innatendue')));
                  },
                  onSuccess: () => progress?.dismiss());
              context.pop();
            },
            child: const Text('Oui'),
          ),
          FilledButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Annuler'))
        ],
      ),
    );
  }
}
