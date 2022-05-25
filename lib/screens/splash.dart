import 'package:flutter/material.dart';

import '../data/colors.dart';
import '../data/strings.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key, this.loaded = true}) : super(key: key);

  final bool loaded;

  @override
  Widget build(BuildContext context) {
    if (!loaded) return Container();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: brandColorGradient,
            begin: FractionalOffset(1.0, 0.0),
            end: FractionalOffset(0.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        width: double.infinity,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Image(
                        image: AssetImage("assets/images/splash.png"),
                        width: 270,
                      ),
                    ),
                    Text(
                      appTitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      appDesc,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(
                  height: 50.0,
                  width: double.infinity,
                  child: Text(
                    appVer,
                    style: Theme.of(context).textTheme.labelLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
