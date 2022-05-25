import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:page_transition/page_transition.dart';

import '../helpers/localstorage.dart';
import 'account.home.dart';
import '../screens/add.new.account.dart';
import '../database/accounts_db.dart';
import '../models/account.dart';
import '../models/response.dart';
import '../api/services.dart';
import '../data/colors.dart';
import '../data/strings.dart';
import '../widgets/snackbar.dart';

class DashContent extends StatefulWidget {
  const DashContent({Key? key}) : super(key: key);

  @override
  _DashContentState createState() => _DashContentState();
}

class _DashContentState extends State<DashContent> {
  int homeAccountID = 0;
  Account _account = Account();
  bool isOkAccount = false;
  bool hasAccount = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((_) async {
      int? lid = await getLastAccount();
      if (lid is int) {
        setHomeAccountID(lid);
      } else {
        int? llid = await getLastAccountID();
        if (llid != null) {
          setState(() {
            hasAccount = true;
          });
          setHomeAccountID(llid);
        } else {
          setState(() {
            hasAccount = false;
          });
        }
      }
    });
  }

  toSettingsScreen() {
    print("toSettingsScreen");
  }

  addNewAccount() async {
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30.0),
        topRight: Radius.circular(30.0),
      ),
    );
    int? data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: shape,
      backgroundColor: bgColor,
      builder: (_) {
        return AddNewAccount();
      },
    );
    //
    if (data is int) {
      setHomeAccountID(data);
    }
  }

  _removeAccount(Account? account) async {
    if (account!.id is int) {
      final bool? result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('حذف دسترسی اکانت'),
            content: const Text('آیا مطمئنید؟'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('انصراف'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('بله'),
              ),
            ],
          );
        },
      );
      if (result is bool && result) {
        ApiResponse _result =
            await Services.removeAccount(account.token!, null);
        print(account);
        if (_result.ok!) {
          await deleteAccount(account.id!);
          int? llid = await getLastAccountID();
          if (account.id! == homeAccountID) {
            if (llid != null) {
              setState(() {
                hasAccount = true;
              });
              setHomeAccountID(llid);
            } else {
              setState(() {
                hasAccount = false;
                isOkAccount = false;
              });
            }
          }
          RSnackBar.success(context, "با موفقیت حذف شد :)");
          Navigator.pop(context);
        } else {
          RSnackBar.error(context, "خطایی رخ داد :(");
          Navigator.pop(context);
        }
      }
    }
  }

  setHomeAccountID(v) {
    setState(() {
      homeAccountID = v;
    });
    setLastAccount(v);
    _getAccount();
  }

  Future<void> _getAccount() async {
    final Account? account = await getAccountByID(homeAccountID);
    print("object");
    if (account == null) {
      setState(() {
        isOkAccount = false;
      });
    } else {
      setState(() {
        _account = account;
        isOkAccount = true;
      });
      // ApiResponse _result = await Services.getAccount(account.token!, null);
      // print(_result.toJson());
      // if (_result.ok!) {
      // account.label = 'رسول';
      account.profileName = 'رسول احمدی فر';
      account.balance = 15000;
      setState(() {
        _account = account;
      });
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("update dash");
    //

    //
    final Drawer _drawer = Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: FutureBuilder<List<Account>>(
              future: getAccountsList(),
              builder: (context, snapshot) {
                List<Widget> _drawerList = [];
                _drawerList.add(
                  DrawerHeader(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/drawerbg.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                  ),
                );
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  _drawerList.add(
                    ListTile(
                      leading: const Icon(Icons.person_add_alt_outlined),
                      title: const Text('افزودن حساب جدید'),
                      iconColor: textColor,
                      onTap: () {
                        Navigator.pop(context);
                        addNewAccount();
                      },
                    ),
                  );
                  _drawerList.add(
                    const ListTile(
                      title: Text('حساب ها'),
                      tileColor: Color.fromARGB(85, 255, 255, 255),
                      dense: true,
                      visualDensity: VisualDensity(vertical: -3),
                    ),
                  );
                  for (int i = 0; i < snapshot.data!.length; i++) {
                    _drawerList.add(
                      ListTile(
                        leading:
                            const Icon(Icons.account_balance_wallet_outlined),
                        title: Text(snapshot.data!.elementAt(i).label!),
                        onTap: () {
                          Navigator.pop(context);
                          setHomeAccountID(snapshot.data!.elementAt(i).id);
                        },
                        onLongPress: () =>
                            _removeAccount(snapshot.data!.elementAt(i)),
                        iconColor: textColor,
                        selected:
                            snapshot.data!.elementAt(i).id == homeAccountID,
                      ),
                    );
                  }
                } else {
                  _drawerList.add(
                    ListTile(
                      leading: const Icon(Icons.person_add_alt_outlined),
                      title: const Text('افزودن حساب'),
                      iconColor: textColor,
                      onTap: () {
                        Navigator.pop(context);
                        addNewAccount();
                      },
                    ),
                  );
                }

                return ListView(
                  padding: EdgeInsets.zero,
                  children: _drawerList,
                );
              },
            ),
          ),
        ],
      ),
    );
    //
    Widget _body = Container();
    PreferredSizeWidget? _appBar;
    if (isOkAccount) {
      _body = AccountHome(homeAccountID, _account, _getAccount);
    } else {
      if (hasAccount) {
        _body = Container(
          color: bgColor,
          child: const Center(
            child: Text("مشکلی پیش آمده است :("),
          ),
        );
      } else {
        _body = Container(
          color: bgColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("اولین حساب کاربری خود را تعریف کنید"),
                const Padding(padding: EdgeInsets.all(8)),
                ElevatedButton(
                  onPressed: addNewAccount,
                  child: const Text("ایجاد حساب"),
                ),
              ],
            ),
          ),
        );
      }

      _appBar = AppBar(
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
            tooltip: "تنظیمات",
          ),
        ],
      );
    }

    return Scaffold(
      appBar: _appBar,
      drawer: _drawer,
      body: _body,
      backgroundColor: Colors.purple,
    );
  }
}
