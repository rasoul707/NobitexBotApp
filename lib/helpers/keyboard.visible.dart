import 'package:flutter/material.dart';

class KeyboardVisibilityBuilder extends StatefulWidget {
  final List<Widget> children;
  final Widget Function(
    BuildContext context,
    List<Widget> children,
    bool isKeyboardVisible,
    double bottomInset,
  ) builder;

  const KeyboardVisibilityBuilder({
    Key? key,
    required this.children,
    required this.builder,
  }) : super(key: key);

  @override
  _KeyboardVisibilityBuilderState createState() =>
      _KeyboardVisibilityBuilderState();
}

class _KeyboardVisibilityBuilderState extends State<KeyboardVisibilityBuilder>
    with WidgetsBindingObserver {
  var _isKeyboardVisible = false;
  var _bottomInset = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance?.window.viewInsets.bottom;
    final newValue = bottomInset! > 0.0;
    if (newValue != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = newValue;
        _bottomInset = bottomInset;
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(
      context, widget.children, _isKeyboardVisible, _bottomInset);
}
