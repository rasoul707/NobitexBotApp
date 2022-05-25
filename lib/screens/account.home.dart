import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nobibot/data/colors.dart';

import '../models/account.dart';

class AccountHome extends StatefulWidget {
  const AccountHome(
    this.account,
    this.getAccount, {
    Key? key,
  }) : super(key: key);
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

  @override
  void initState() {
    super.initState();
    // _getAccount();
    tabController = TabController(length: 2, vsync: this);
  }

  toSettingsScreen() {
    print("toSettingsScreen");
  }

  @override
  Widget build(BuildContext context) {
    final Account _account = widget.account;
    Future<void> Function() _getAccount = widget.getAccount;
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
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: toSettingsScreen,
              tooltip: "تنظیمات",
            ),
          ],
        ),
      ],
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            color: bgColor,
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverPersistentHeader(
                      pinned: true,
                      floating: false,
                      delegate: OurDelegate(
                        toolBarHeight:
                            MediaQuery.of(context).viewPadding.top + 0,
                        openHeight: 180,
                        closedHeight: 120,
                        balance: _account.balance,
                        onNewOrder: () {},
                        tabBar: TabBar(
                          controller: tabController,
                          tabs: const [
                            Tab(
                              text: "دارایی ها",
                            ),
                            Tab(
                              text: "سفارش ها",
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned.fill(
                  top: 217,
                  child: TabBarView(
                    controller: tabController,
                    children: <Widget>[
                      RefreshIndicator(
                        key: _refreshIndicatorKey,
                        onRefresh: _getAccount,
                        // displacement: 100,
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            ListTile(
                              title: Text("fgdgfd"),
                            ),
                            ListTile(
                              title: Text("fgdgfd"),
                            ),
                            ListTile(
                              title: Text("fgdgfd"),
                            ),
                            ListTile(
                              title: Text("fgdgfd"),
                            ),
                            ListTile(
                              title: Text("fgdgfd"),
                            ),
                            ListTile(
                              title: Text("fgdgfd"),
                            ),
                            ListTile(
                              title: Text("fgdgfd"),
                            ),
                            ListTile(
                              title: Text("fgdgfd"),
                            ),
                            ListTile(
                              title: Text("fgdgfd"),
                            ),
                            ListTile(
                              title: Text("fgdgfd"),
                            ),
                            ListTile(
                              title: Text("fgdgfd"),
                            ),
                            ListTile(
                              title: Text("fgdgfd"),
                            ),
                            ListTile(
                              title: Text("fgdgfd"),
                            ),
                            ListTile(
                              title: Text("fgdgfd"),
                            ),
                            ListTile(
                              title: Text("fgdgfd"),
                            ),
                            ListTile(
                              title: Text("fgdgfd"),
                            ),
                            ListTile(
                              title: Text("fgdgfd"),
                            ),
                          ],
                        ),
                      ),
                      RefreshIndicator(
                        // key: _refreshIndicatorKey,
                        onRefresh: _getAccount,
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            ListTile(
                              title: Text("sss"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/drawerbg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Material(
        elevation: 0,
        color: Colors.transparent,
        child: Stack(
          children: [
            if (shrinkPercentage != 0)
              Opacity(
                opacity: shrinkPercentage,
                child: Positioned.fill(child: Container(color: Colors.purple)),
              ),
            Column(
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
