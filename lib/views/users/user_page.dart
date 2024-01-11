import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gestionbureaudechange/models/core/user/user.dart';
import 'package:gestionbureaudechange/providers/entity_page_provider.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  final String id;
  const UserPage({required this.id, super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final logger = Logger();
  @override
  void initState() {
    super.initState();
    logger.i('id ${widget.id}');
    context.read<EntityPageProvider<User>>().getData(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Page d'utilisateur")),
      body: Consumer<EntityPageProvider<User>>(
        builder: (context, value, child) {
          return value.loading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: value.data?.fold((l) {
                    return ErrorWidget(l);
                  }, (data) {
                    logger.i('data $data');
                    return onLoadingComplete(data);
                  }),
                );
        },
      ),
    );
  }

  Widget textWidget(String? value, IconData? icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(icon),
          ),
          Expanded(
            child: AutoSizeText(
              '$value',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 18),
            ),
          )
        ],
      ),
    );
  }

  Widget onLoadingComplete(User data) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          textWidget("Nom D'utilisateur : ${data.userName}", Icons.person),
          textWidget(
              "Utilisateur : ${data.name}", Icons.supervised_user_circle),
          textWidget("Numero de téléphone : ${data.phone}", Icons.phone),
          textWidget("Email : ${data.email}", Icons.email),
        ],
      ),
    );
  }
}
