import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medical_app/routes.dart';
import 'package:medical_app/services/auth.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:provider/provider.dart';
import 'navigation_service.dart';
import 'utils/themes.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        StreamProvider<User>.value(value: AuthService().user),
        ProxyProvider0(update: (_, __) => DatabaseService().getUserById )
      ],
      child: MaterialApp(
        title: 'OPTS',
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.instance.key,
        initialRoute: '/',
        theme: appTheme(),
        routes: routes,
      ),
    );
  }
}
