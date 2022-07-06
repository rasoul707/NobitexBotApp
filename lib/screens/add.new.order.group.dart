import 'package:flutter/material.dart';
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

  Future<void> accountList() async {
    final m = await getAccountsList();
    setState(() {
      accounts = m;
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

  submit() {}

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
    for (int i = 0; i < accounts.length; i++) {
      Account e = accounts[i];
      tabContent.add(
        ListTile(
          title: Text(e.label!),
          subtitle: Text(e.balance.toString() + " ريال"),
          leading: const Icon(Icons.person, color: whiteTextColor),
          trailing: SizedBox(
            width: 100,
            child: TextField(
              textDirection: TextDirection.ltr,
              decoration: const InputDecoration(
                hintText: 'ضریب',
                hintStyle: TextStyle(
                  color: whiteTextColor,
                ),
              ),
              keyboardType: TextInputType.number,
              controller: ratioController.elementAt(i),
            ),
          ),
        ),
      );
    }

    tabContent.add(
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: newOrderDialog,
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
