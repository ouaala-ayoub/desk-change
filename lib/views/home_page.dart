// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gestionbureaudechange/models/core/admin.dart';
import 'package:gestionbureaudechange/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: homeBody(context),
      drawer: Drawer(
          child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => authProvider.loading
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : authProvider.auth.fold(
                (l) => const Center(
                      child: Text("Erreur de connexion"),
                    ),
                (admin) => ListView(
                      children: [
                        drawerHeader(admin),
                        ListTile(
                          title: const Text('Ajouter un admin'),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Coming soon')));
                          },
                        ),
                        ListTile(
                          title: const Text('Se déconnecter'),
                          onTap: () async {
                            await authProvider.logout(() => context.go('/'));
                          },
                        ),
                      ],
                    )),
      )),
    );
  }

  DrawerHeader drawerHeader(Admin admin) {
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Nom d'utilisateur :"),
          Text(
            "${admin.userName}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text("Nom :"),
          Text('${admin.name}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
        ],
      ),
    );
  }

  Center homeBody(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            ChoiceWidget(
                data: 'Bureaux',
                icon: const Icon(
                  Icons.business_center,
                  size: 40,
                ),
                onTap: () {
                  context.pushNamed('desks');
                }),
            ChoiceWidget(
                data: 'Utilisateurs',
                icon: const Icon(
                  Icons.person,
                  size: 40,
                ),
                onTap: () {
                  context.pushNamed('users');
                })
          ]),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text('Home Page'),
    );
  }
}

// ignore: must_be_immutable
class ChoiceWidget extends StatelessWidget {
  String data;
  Icon icon;
  void Function() onTap;

  ChoiceWidget({
    Key? key,
    required this.data,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    blurRadius: 40, color: Colors.black12, spreadRadius: 30)
              ],
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: icon,
              ),
              Text(
                data,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SvgPicture.asset('assets/icons/button.svg'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
