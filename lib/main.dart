import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';

import 'api/services.dart';
import 'data/strings.dart';

import 'database/accounts_db.dart';
import 'models/account.dart';
import 'models/response.dart';
import 'screens/splash.dart';
import 'screens/dash.dart';

import 'helpers/theme.dart';

import 'helpers/localstorage.dart';

void main() {
  debugPaintSizeEnabled = false;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeModeHandler(
      manager: ThemeModeManager(),
      placeholderWidget: const SplashScreen(loaded: false),
      builder: (ThemeMode themeMode) {
        return MaterialApp(
          title: appTitle,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          home: const RootApp(),
          localizationsDelegates: const [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale("fa", "IR"), // rtl
          ],
          locale: const Locale("fa", "IR"),
        );
      },
    );
  }
}

// ##################
// ##################
// ##################

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  @override
  void initState() {
    super.initState();
    preparing();
  }

  // check token valid
  Future<void> preparing() async {
    Account? showAccount;

    int? accID;
    int? lid = await getLastAccount();
    if (lid is int) {
      accID = lid;
    } else {
      int? llid = await getLastAccountID();
      if (llid != null) {
        accID = llid;
      }
    }

    if (accID != null) {
      final Account? account = await getAccountByID(accID);
      if (account != null) {
        showAccount = account;
      }
    }

    await Future.delayed(const Duration(seconds: 2));

    // finish
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: DashContent(showAccount),
      ),
    );
    //
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
