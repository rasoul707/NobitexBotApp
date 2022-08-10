import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nobibot/models/account.dart';
import 'package:nobibot/models/group.order.dart';
import '../api/services.dart';
import '../data/colors.dart';
import '../database/accounts_db.dart';
import '../helpers/keyboard.visible.dart';
import '../models/group.order.req.dart';
import '../models/order.dart';
import '../models/response.dart';
import '../models/stage.dart';
import '../widgets/snackbar.dart';
import 'add.new.order.dart';

class AddNewOrderGroup extends StatefulWidget {
  const AddNewOrderGroup({
    Key? key,
  }) : super(key: key);

  @override
  _AddNewOrderGroupState createState() => _AddNewOrderGroupState();
}

class _AddNewOrderGroupState extends State<AddNewOrderGroup> {
  List<Account> accounts = [];
  List<TextEditingController> ratioController = [];
  bool loading = true;

  Future<void> accountList() async {
    final m = await getAccountsList();

    for (int i = 0; i < m.length; i++) {
      String? tok = m.elementAt(i).token;
      if (tok is String) {
        ApiResponse _result = await Services.getAccount(tok, null);
        if (_result.ok!) {
          m.elementAt(i).balance = _result.account?.balance;
          m.elementAt(i).ok = 1;
        } else {
          m.elementAt(i).ok = 0;
        }
      } else {
        m.elementAt(i).ok = 0;
      }

      updateAccount(m.elementAt(i));
    }

    setState(() {
      accounts = m;
      loading = false;
    });

    for (int i = 0; i < m.length; i++) {
      ratioController.add(TextEditingController(
        text: m.elementAt(i).ratio.toString(),
      ));
    }
  }

  @override
  void initState() {
    super.initState();

    accountList();
  }

  newOrderDialog() async {
    List<GroupOrder> reqAccounts = [];
    for (int i = 0; i < accounts.length; i++) {
      double? rr = double.tryParse(ratioController.elementAt(i).text);
      accounts.elementAt(i).ratio = rr;

      GroupOrder gorder = GroupOrder(
        token: accounts.elementAt(i).token,
        ratio: rr,
      );

      await updateAccount(accounts.elementAt(i));

      reqAccounts.add(gorder);
    }

    Order? order = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return const AddNewOrder();
      },
    );

    if (order is Order) {
      RSnackBar.info(
        context,
        "در حال ارسال درخواست ...",
        duration: const Duration(seconds: 120),
      );

      ErrorAction _err = ErrorAction(
        response: ((res) {
          RSnackBar.error(context, "خطا: " + res);
        }),
        connection: () {
          RSnackBar.error(context, "خطای اتصال");
        },
      );

      GroupOrderRequest req = GroupOrderRequest(
        accounts: reqAccounts,
        order: order,
      );

      ApiResponse _result = await Services.newOrder('', req, _err);

      RSnackBar.hide(context);
      if (_result.ok!) {
        RSnackBar.success(context, "سفارش شما با موفقیت ایجاد شد");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabContent = [];
    tabContent.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          "سفارش گروهی",
          style: Theme.of(context).textTheme.titleMedium!,
          textAlign: TextAlign.center,
        ),
      ),
    );
    tabContent.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          "ضریب باید بین 0 تا 10 باشد",
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: whiteTextColor,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
    if (loading) {
      tabContent.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            "در حال بارگذاری ...",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: whiteTextColor,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    for (int i = 0; i < accounts.length; i++) {
      Account e = accounts[i];
      tabContent.add(
        ListTile(
          title: Text(e.label!),
          subtitle: Text(e.balance.toString() + " ريال"),
          leading: const Icon(Icons.person, color: whiteTextColor),
          trailing: SizedBox(
            width: 100,
            child: e.ok == 1
                ? TextField(
                    textDirection: TextDirection.ltr,
                    decoration: const InputDecoration(
                      hintText: 'ضریب',
                      hintStyle: TextStyle(
                        color: whiteTextColor,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    controller: ratioController.elementAt(i),
                    onChanged: (val) {
                      int? ll = int.tryParse(val);
                      if (ll is int && ll >= 10) {
                        ratioController.elementAt(i).text = "10";
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                  )
                : const Text(
                    "نیاز به تایید",
                    style: TextStyle(
                      color: Color.fromARGB(255, 238, 0, 0),
                    ),
                  ),
          ),
        ),
      );
    }

    tabContent.add(
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: loading ? null : newOrderDialog,
          child: const Text("ثبت سفارش"),
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: bgColor,
          padding: const EdgeInsets.all(15),
          child: ListView(
            children: tabContent,
          ),
        ),
      ),
    );
  }
}
