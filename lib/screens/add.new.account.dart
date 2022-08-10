import 'package:flutter/material.dart';

import '../api/services.dart';
import '../database/accounts_db.dart';
import '../helpers/keyboard.visible.dart';
import '../widgets/snackbar.dart';
import '../models/account.dart';
import '../models/response.dart';

class AddNewAccount extends StatefulWidget {
  const AddNewAccount({
    Key? key,
    required this.labelController,
    required this.emailController,
    required this.passwordController,
    required this.confirm,
  }) : super(key: key);

  final TextEditingController labelController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool confirm;

  @override
  _AddNewAccountState createState() => _AddNewAccountState();
}

class _AddNewAccountState extends State<AddNewAccount> {
  bool disabled = false;

  submit(context) async {
    final String label = widget.labelController.text;
    final String email = widget.emailController.text;
    final String password = widget.passwordController.text;

    AddAccountReq accountReq = AddAccountReq(email: email, password: password);

    setState(() {
      disabled = true;
    });

    ApiResponse _result = await Services.addAccount(accountReq, null);
    if (_result.ok!) {
      Account account = Account(
        label: label,
        email: email,
        password: password,
        token: _result.addAccount!.token,
        device: _result.addAccount!.device,
        ratio: 10,
        ok: 1,
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
            widget.confirm ? "تایید حساب" : "افزودن حساب",
            style: Theme.of(context).textTheme.titleMedium!,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: TextFormField(
            controller: widget.labelController,
            textInputAction: TextInputAction.next,
            textDirection: TextDirection.rtl,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "عنوان",
              prefixIcon: Icon(Icons.label),
            ),
            enabled: widget.confirm ? false : !disabled,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: TextFormField(
            controller: widget.emailController,
            textInputAction: TextInputAction.next,
            textDirection: TextDirection.ltr,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "ایمیل",
              prefixIcon: Icon(Icons.alternate_email),
            ),
            enabled: widget.confirm ? false : !disabled,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: TextFormField(
            controller: widget.passwordController,
            textInputAction: TextInputAction.next,
            textDirection: TextDirection.ltr,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "گذرواژه",
              prefixIcon: Icon(Icons.lock_outline),
            ),
            enabled: !disabled,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15, left: 25, right: 25),
          child: ElevatedButton(
            onPressed: disabled ? null : () => submit(context),
            child: Text(widget.confirm ? "تایید" : "افزودن"),
          ),
        ),
      ],
    );
  }
}
