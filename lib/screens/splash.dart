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
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Image(
                    image: AssetImage("assets/images/nobitex.png"),
                    width: 150,
                    color: Colors.white,
                  ),
                ),
                Container(
                  // color: Colors.white,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Text(
                    appDesc,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.purple,
                        ),
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
