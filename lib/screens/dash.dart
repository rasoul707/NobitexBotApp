import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:page_transition/page_transition.dart';

import '../helpers/localstorage.dart';
import '../models/order.dart';
import '../models/property.dart';
import 'account.home.dart';
import '../screens/add.new.account.dart';
import '../database/accounts_db.dart';
import '../models/account.dart';
import '../models/response.dart';
import '../api/services.dart';
import '../data/colors.dart';
import '../widgets/snackbar.dart';
import 'add.new.order.group.dart';

class DashContent extends StatefulWidget {
  const DashContent(this.fromDBAccount, {Key? key}) : super(key: key);

  final Account? fromDBAccount;

  @override
  _DashContentState createState() => _DashContentState();
}

class _DashContentState extends State<DashContent> {
  int homeAccountID = 0;
  Account? _account;
  bool hasAccount = false;

  List<Order> orders = [];
  List<Property> properties = [];

  final TextEditingController labelController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (widget.fromDBAccount != null) {
        setState(() {
          hasAccount = true;
        });
        setHomeAccountID(
          widget.fromDBAccount!.id,
          fromDB: widget.fromDBAccount,
        );
      }
    });
  }

  setHomeAccountID(v, {Account? fromDB}) {
    setState(() {
      homeAccountID = v;
    });
    setLastAccount(v);
    _getAccount(fromDB: fromDB, noRefresh: true);
  }

  addNewAccount({bool confirm = false}) async {
    Account? data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return AddNewAccount(
          labelController: labelController,
          emailController: emailController,
          passwordController: passwordController,
          confirm: confirm,
        );
      },
    );
    //

    if (data is Account) {
      setHomeAccountID(
        data.id,
        fromDB: data,
      );
      setState(() {
        hasAccount = true;
      });
    }

    labelController.clear();
    emailController.clear();
    passwordController.clear();
  }

  _removeAccount(Account? account, {bool? forceRemove}) async {
    if (account!.id is int) {
      bool? result;
      if (forceRemove == null || !forceRemove) {
        result = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('حذف دسترسی اکانت'),
              content: const Text('آیا مطمئنید؟'),
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
      }

      if ((result is bool && result) || (forceRemove is bool && forceRemove)) {
        ApiResponse _result =
            await Services.removeAccount(account.token!, null);

        await deleteAccount(account.id!);
        //
        if (account.id! == homeAccountID) {
          int? llid = await getLastAccountID();
          if (llid != null) {
            setState(() {
              hasAccount = true;
            });
            setHomeAccountID(llid);
          } else {
            setState(() {
              hasAccount = false;
              _account = null;
            });
          }
        } else {
          setState(() {
            hasAccount = true;
          });
        }
        //
        if (forceRemove is bool && forceRemove) {
          RSnackBar.error(
            context,
            "دسترسی شما به پایان رسید. باید مجدد لاگین کنید",
          );
        } else {
          RSnackBar.success(context, "با موفقیت حذف شد :)");
          Navigator.pop(context);
        }
      }
    }
  }

  Future<void> _getAccount({Account? fromDB, bool? noRefresh}) async {
    Account? account;
    if (fromDB != null) {
      account = fromDB;
    } else {
      account = await getAccountByID(homeAccountID);
    }
    //
    if (account != null) {
      if (noRefresh is bool && noRefresh) {
        setState(() {
          _account = account;
        });
      }

      ApiResponse _result = await Services.getAccount(account.token!, null);

      if (_result.ok!) {
        account.balance = _result.account?.balance;
        setState(() {
          _account = account;
        });
        updateAccount(account);

        ApiResponse ordersRes =
            await Services.getOrders(_account!.token!, null);
        if (ordersRes.ok! && ordersRes.orders != null) {
          setState(() {
            orders = ordersRes.orders!;
          });
        }

        ApiResponse propertiesRes =
            await Services.getProperties(_account!.token!, null);

        if (propertiesRes.ok! && propertiesRes.properties != null) {
          setState(() {
            properties = propertiesRes.properties!;
          });
        }
      } else {
        account.ok = 0;
        setState(() {
          _account = account;
        });
        updateAccount(account);
        labelController.text = account.label!;
        labelController.text = account.label!;
        emailController.text = account.email!;
        addNewAccount(confirm: true);
      }
    }
  }

  newOrderGroup() async {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.bottomToTop,
        child: const AddNewOrderGroup(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                            'assets/images/drawable-back.jpg',
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
                    ListTile(
                      leading: const Icon(Icons.group_work_outlined),
                      title: const Text('سفارش گروهی'),
                      iconColor: textColor,
                      onTap: () {
                        Navigator.pop(context);
                        newOrderGroup();
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
                        trailing: snapshot.data!.elementAt(i).ok! == 0
                            ? const Text(
                                "نیاز به تایید",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 238, 0, 0),
                                ),
                              )
                            : const Text(""),
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
                  _drawerList.add(
                    ListTile(
                      leading: const Icon(Icons.person_add_alt_outlined),
                      title: const Text('سفارش گروهی'),
                      iconColor: textColor,
                      onTap: () {
                        Navigator.pop(context);
                        newOrderGroup();
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
    Widget _body;

    if (_account != null) {
      _body = AccountHome(
        _account!,
        _getAccount,
        orders: orders,
        properties: properties,
      );
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
    }

    return Scaffold(
      drawer: _drawer,
      body: _body,
      backgroundColor: Colors.purple,
    );
  }
}
