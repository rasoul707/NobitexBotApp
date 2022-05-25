import 'package:flutter/material.dart';

import '../data/colors.dart';

class OccButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final String? type;
  final bool? enabled;
  final bool? loading;

  const OccButton({
    Key? key,
    required this.onPressed,
    required this.label,
    this.type,
    this.enabled,
    this.loading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BoxDecoration _decour = const BoxDecoration(
      gradient: LinearGradient(
        colors: brandColorGradient,
        begin: FractionalOffset(1.0, 0.0),
        end: FractionalOffset(0.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(50),
      ),
    );

    if (type is String && type == 'cancel') {
      _decour = const BoxDecoration(
        color: extraColor,
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
      );
    }

    // if (enabled is bool && enabled == false) {
    //   _decour = const BoxDecoration(
    //     color: disabledColor,
    //     borderRadius: BorderRadius.all(
    //       Radius.circular(50),
    //     ),
    //   );
    // }

    void Function()? _onPress = () {
      FocusScope.of(context).unfocus();
      onPressed();
    };
    Widget child = Text(
      label,
      style: const TextStyle(
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
    );
    if (loading is bool && loading == true) {
      _onPress = FocusScope.of(context).unfocus;

      child = const SizedBox(
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 3,
        ),
        height: 25,
        width: 25,
      );
    } else if (enabled is bool && enabled == false) {
      _onPress = FocusScope.of(context).unfocus;
    }

    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(50),
      ),
      child: Container(
        decoration: _decour,
        height: 50,
        width: double.infinity,
        child: TextButton(
          onPressed: _onPress,
          child: child,
        ),
      ),
    );
  }
}
