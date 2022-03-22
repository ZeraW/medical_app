import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/routes.dart';
import 'package:medical_app/services/auth.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'models/db_model.dart';
import 'navigation_service.dart';
import 'utils/themes.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
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
        StreamProvider<List<SpecialityModel>>.value(
            value: DatabaseService().getLiveSpeciality),
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
