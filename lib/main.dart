import 'package:flutter/material.dart';
import 'package:gestionbureaudechange/models/core/user/user.dart';
import 'package:gestionbureaudechange/models/helpers/desks_helper.dart';
import 'package:gestionbureaudechange/models/helpers/users_helper.dart';
import 'package:gestionbureaudechange/providers/auth_provider.dart';
import 'package:gestionbureaudechange/providers/desk_add_provider.dart';
import 'package:gestionbureaudechange/providers/desk_modify_provider.dart';
import 'package:gestionbureaudechange/providers/entity_page_provider.dart';
import 'package:gestionbureaudechange/providers/filtrable_list_provider.dart';
import 'package:gestionbureaudechange/providers/password_modify_provider.dart';
import 'package:gestionbureaudechange/providers/user_add_provider.dart';
import 'package:gestionbureaudechange/providers/user_modify_provider.dart';
import 'package:gestionbureaudechange/views/auth_page.dart';
import 'package:gestionbureaudechange/views/filterable_list_widget.dart';
import 'package:gestionbureaudechange/views/home_page.dart';
import 'package:gestionbureaudechange/views/users/user_add.dart';
import 'package:gestionbureaudechange/views/users/user_modify.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'models/core/user/desk.dart';
import 'views/desks/desk_add.dart';
import 'views/desks/desk_modify.dart';
import 'views/desks/desk_page.dart';
import 'views/users/password_modify.dart';
import 'views/users/user_page.dart';

final logger = Logger();
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final config = GoRouter(routes: [
    //home page and auth

    GoRoute(
      path: '/',
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      name: 'home',
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),

    //desk routes
    GoRoute(
      name: 'desks',
      path: '/desks',
      builder: (context, state) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => FilterableListProvider<Desk>(DesksHelper())),
        ],
        child: const FilterableListWidget<Desk>(
            'Bureau', 'bureau', 'desks', 'addDesk'),
      ),
    ),
    GoRoute(
      path: '/desks/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ChangeNotifierProvider(
          create: (context) =>
              EntityPageProvider<DeskAndTransactions>(DesksHelper()),
          child: DeskPage(id: id),
        );
      },
    ),
    GoRoute(
      name: 'deskAdd',
      path: '/addDesk',
      builder: (context, state) => ChangeNotifierProvider(
        create: (context) => DeskAddProvider(),
        child: const DeskAdd(),
      ),
    ),
    GoRoute(
      path: '/desks/:id/modify',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ChangeNotifierProvider(
          create: (context) => DeskModifyProvider(),
          child: DeskModify(
            id: id,
          ),
        );
      },
    ),

    //users routes

    GoRoute(
      path: '/users/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ChangeNotifierProvider(
          create: (context) => EntityPageProvider<User>(UsersHelper()),
          child: UserPage(id: id),
        );
      },
    ),
    GoRoute(
      path: '/users/:id/passwordModify',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ChangeNotifierProvider(
          create: (context) => PasswordModifyProvider(),
          child: PasswordModify(id: id),
        );
      },
    ),
    GoRoute(
      name: 'userAdd',
      path: '/addUser',
      builder: (context, state) => ChangeNotifierProvider(
        create: (context) => UserAddProvider(),
        child: const UserAddPage(),
      ),
    ),
    GoRoute(
      path: '/users/:id/modify',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ChangeNotifierProvider(
          create: (context) => UserModifyProvider(),
          child: UserModify(
            id: id,
          ),
        );
      },
    ),

    GoRoute(
      name: 'users',
      path: '/users',
      builder: (context, state) => ChangeNotifierProvider(
        create: (context) => FilterableListProvider<User>(UsersHelper()),
        child: const FilterableListWidget<User>(
            'Utilisateurs', 'utilisateur', 'users', 'addUser'),
      ),
    ),
  ]);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthProvider(),
          ),
        ],
        child: MaterialApp.router(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xff202c34)),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          debugShowCheckedModeBanner: false,
          routerConfig: config,
        ));
  }
}
