import 'package:flutter/material.dart';
import 'package:nobibot/models/account.dart';
import 'package:nobibot/models/response.dart';

import '../api/services.dart';
import '../database/accounts_db.dart';
import '../widgets/snackbar.dart';

class AddNewAccount extends StatelessWidget {
  const AddNewAccount({
    Key? key,
    this.listController,
    required this.labelController,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  final ScrollController? listController;

  final TextEditingController labelController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  submit(context) async {
    final String label = labelController.text;
    final String email = emailController.text;
    final String password = passwordController.text;

    AddAccountReq accountReq = AddAccountReq(email: email, password: password);

    ApiResponse _result = await Services.addAccount(accountReq, null);
    if (_result.ok!) {
      Account account = Account(
        label: label,
        email: email,
        password: password,
        token: _result.addAccount!.token,
        device: _result.addAccount!.device,
      );
      Account? mm = await getAccountByEmail(email);
      if (mm != null) {
        account.id = mm.id;
        await updateAccount(account);
        RSnackBar.success(context, "حساب کاربری بروزرسانی شد :)");
      } else {
        account.id = await insertAccount(account);
        RSnackBar.success(context, "حساب کاربری جدید اضافه شد :)");
      }
      Navigator.pop(context, account);
    } else {
      Navigator.pop(context);
      RSnackBar.error(context, "خطایی رخ داد :(");
    }
  }

  @override
  Widget build(BuildContext context) {
    //

    return KeyboardVisibilityBuilder(
      builder: (BuildContext context, List<Widget> children,
          bool isKeyboardVisible, double bottomInset) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: DraggableScrollableSheet(
            expand: false,
            maxChildSize: 0.80,
            minChildSize: 0.55,
            initialChildSize: 0.55,
            builder: (_, c) {
              return Container(
                color: Colors.transparent,
                padding: const EdgeInsets.all(15),
                child: ListView(
                  controller: c,
                  children: children,
                ),
              );
            },
          ),
        );
      },
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            "افزودن حساب",
            style: Theme.of(context).textTheme.titleMedium!,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: TextFormField(
            controller: labelController,
            textInputAction: TextInputAction.next,
            textDirection: TextDirection.rtl,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "عنوان",
              prefixIcon: Icon(Icons.label),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: TextFormField(
            controller: emailController,
            textInputAction: TextInputAction.next,
            textDirection: TextDirection.ltr,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "ایمیل",
              prefixIcon: Icon(Icons.alternate_email),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: TextFormField(
            controller: passwordController,
            textInputAction: TextInputAction.next,
            textDirection: TextDirection.ltr,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "گذرواژه",
              prefixIcon: Icon(Icons.lock_outline),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15, left: 25, right: 25),
          child: ElevatedButton(
            onPressed: () {
              submit(context);
            },
            child: const Text("افزودن"),
          ),
        ),
      ],
    );
  }
}

/// Calls `builder` on keyboard close/open.
/// https://stackoverflow.com/a/63241409/1321917
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
