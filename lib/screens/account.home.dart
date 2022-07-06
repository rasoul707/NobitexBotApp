import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nobibot/data/colors.dart';
import 'package:nobibot/models/property.dart';

import '../api/services.dart';
import '../models/account.dart';
import '../models/group.order.req.dart';
import '../models/order.dart';
import '../models/response.dart';
import '../widgets/snackbar.dart';
import 'add.new.order.dart';

class AccountHome extends StatefulWidget {
  const AccountHome(
    this.account,
    this.getAccount, {
    this.orders,
    this.properties,
    Key? key,
  }) : super(key: key);

  final List<Order>? orders;
  final List<Property>? properties;
  final Account account;
  final Future<void> Function() getAccount;
  @override
  _AccountHomeState createState() => _AccountHomeState();
}

class _AccountHomeState extends State<AccountHome>
    with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  TabController? tabController;
  int tabSelected = 0;

  void tabControllerChanged(int m) {
    setState(() {
      tabSelected = m;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  newOrder() async {
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

      GroupOrderRequest req = GroupOrderRequest(accounts: null, order: order);

      ApiResponse _result =
          await Services.newOrder(widget.account.token!, req, _err);

      RSnackBar.hide(context);
      if (_result.ok!) {
        RSnackBar.success(context, "سفارش شما با موفقیت ایجاد شد");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Account _account = widget.account;

    List<Widget> tabContent = [];
    if (widget.properties == null || widget.properties!.isEmpty) {
      tabContent.add(
        const SizedBox(
          height: 100,
          child: Center(
            child: Text(
              "دارایی پیدا نشد :(",
              style: TextStyle(color: Color.fromARGB(255, 197, 197, 197)),
            ),
          ),
        ),
      );
    } else {
      tabContent.add(
        Column(
          children: widget.properties!.map((e) {
            return ListTile(
              title: Text(e.coin!),
              subtitle: Text('میانگین: ' + e.avgPrice!.toString()),
              leading: const Icon(
                Icons.monetization_on,
                color: Colors.amber,
                size: 30,
              ),
              trailing: Text('حجم: ' + e.amount!.toString()),
            );
          }).toList(),
        ),
      );
    }

    if (widget.orders == null || widget.orders!.isEmpty) {
      tabContent.add(
        const SizedBox(
          height: 100,
          child: Center(
            child: Text(
              "سفارشی پیدا نشد :(",
              style: TextStyle(color: Color.fromARGB(255, 197, 197, 197)),
            ),
          ),
        ),
      );
    } else {
      tabContent.add(
        Column(
          children: widget.orders!.map((e) {
            var icon;
            if (e.type == 'buy') {
              icon = const Icon(
                Icons.currency_exchange,
                color: Colors.green,
                size: 30,
              );
            } else {
              icon = const Icon(
                Icons.currency_exchange,
                color: Colors.red,
                size: 30,
              );
            }

            if (e.actionType == 'stages') {
              return ListTile(
                title: Text(e.pair!),
                subtitle: e.stages != null
                    ? Text('تعداد پله: ' + e.stages!.length.toString())
                    : null,
                leading: icon,
                trailing: Text('حجم کل: ' + e.totalAmount.toString()),
              );
            } else {
              return ListTile(
                title: Text(e.pair!),
                subtitle: e.price != null
                    ? Text('قیمت: ' + e.price!.toString())
                    : null,
                leading: icon,
                trailing: Text('حجم: ' + e.amount.toString()),
              );
            }
          }).toList(),
        ),
      );
    }

    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
        SliverAppBar(
          pinned: true,
          title: Text(
            (_account.label == null ? "" : _account.label!),
            style: Theme.of(context).textTheme.titleMedium!,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: true,
          ),
          elevation: 0,
        ),
      ],
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            color: bgColor,
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: widget.getAccount,
              child: CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    floating: false,
                    delegate: OurDelegate(
                      toolBarHeight: MediaQuery.of(context).viewPadding.top + 0,
                      openHeight: 250,
                      closedHeight: 150,
                      balance: _account.balance,
                      onNewOrder: newOrder,
                      tabBar: TabBar(
                        controller: tabController,
                        onTap: tabControllerChanged,
                        tabs: const [
                          Tab(
                            text: "دارایی ها",
                          ),
                          Tab(
                            text: "سفارش ها",
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      // color: Colors.green,
                      child: tabContent[tabSelected],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class OurDelegate extends SliverPersistentHeaderDelegate {
  double toolBarHeight;
  double closedHeight;
  double openHeight;
  Widget tabBar;
  double? balance;
  void Function()? onNewOrder;

  OurDelegate({
    required this.toolBarHeight,
    required this.closedHeight,
    required this.openHeight,
    required this.tabBar,
    this.balance,
    this.onNewOrder,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double shrinkPercentage = min(1, shrinkOffset / (maxExtent - minExtent));

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("assets/images/drawerbg.jpg"),
          fit: BoxFit.cover,
          opacity: 1 - shrinkPercentage,
        ),
        color: Colors.purple,
      ),
      child: Material(
        elevation: 0,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  if (shrinkPercentage != 1)
                    Opacity(
                      opacity: 1 - shrinkPercentage,
                      child: ElevatedButton(
                        onPressed: onNewOrder,
                        child: const Text("ثبت سفارش جدید"),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.purple,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                height: max(
                  60,
                  80 * (1 - shrinkPercentage),
                ),
              ),
              child: FittedBox(
                child: Container(
                  padding: const EdgeInsets.all(30),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.account_balance_wallet,
                        size: 40,
                      ),
                      const Padding(padding: EdgeInsets.all(5)),
                      Text(
                        (balance != null ? balance.toString() : "-"),
                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Padding(padding: EdgeInsets.all(2)),
                      Text(
                        (balance != null ? "ريال" : ""),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.transparent,
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: tabBar,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => toolBarHeight + openHeight;

  @override
  double get minExtent => toolBarHeight + closedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
