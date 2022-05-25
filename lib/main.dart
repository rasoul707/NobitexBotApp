import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';

import 'api/services.dart';
import 'data/strings.dart';

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
    authentication();
  }

  // check token valid
  Future<void> authentication() async {
    bool showDashboard = false;
    // bool hasUser = await hasUserData();

    // error action
    // ErrorAction _err = ErrorAction(
    //   response: (r) {
    //     showDashboard = false;
    //   },
    //   connection: () async {
    //     if (hasUser) {
    //       showDashboard = true;
    //     } else {
    //       showDashboard = false;
    //     }
    //   },
    //   cancel: () {
    //     showDashboard = true;
    //   },
    // );

    // String _result = await Services.authentication(_err);
    // print(_result);

    // okay
    // if (_result.isNotEmpty) showDashboard = true;

    // finish
    // Navigator.pushReplacement(
    //   context,
    //   PageTransition(
    //     type: PageTransitionType.rightToLeft,
    //     child: (showDashboard && hasUser)
    //         ? const DashContent()
    //         : const AuthContent(),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return const DashContent();
  }
}
