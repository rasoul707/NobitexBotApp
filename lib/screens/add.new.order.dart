import 'package:flutter/material.dart';
import '../helpers/keyboard.visible.dart';
import '../models/order.dart';
import '../models/stage.dart';

class AddNewOrder extends StatefulWidget {
  const AddNewOrder({
    Key? key,
  }) : super(key: key);

  @override
  _AddNewOrderState createState() => _AddNewOrderState();
}

class _AddNewOrderState extends State<AddNewOrder>
    with TickerProviderStateMixin {
  //

  final TextEditingController amountController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController stagesCountController = TextEditingController();
  List<List<TextEditingController>> stagesControllers = [];

  //
  String pair = 'xrpusdt';
  String type = 'buy';
  String actionType = 'normal';
  int stagesCount = 0;
  String errors = '';
  bool disabled = false;

  @override
  void initState() {
    super.initState();
    stagesCountController.addListener(() {
      int value = int.tryParse(stagesCountController.text) ?? 0;
      String eachPer = (value == 0 ? 0 : 100 / value).toStringAsFixed(1);
      String lastPer =
          (100 - ((value - 1) * double.tryParse(eachPer)!)).toStringAsFixed(1);
      stagesControllers = [];

      for (int i = 0; i < value; i++) {
        stagesControllers.add([
          TextEditingController(text: i == value - 1 ? lastPer : eachPer),
          TextEditingController(),
        ]);
      }

      setState(() {
        stagesCount = value;
      });
    });
  }

  setType(String t) {
    setState(() {
      type = t;
      actionType = 'normal';
    });
    amountController.clear();
    priceController.clear();
    totalAmountController.clear();
    stagesCountController.clear();
    FocusScope.of(context).unfocus();
  }

  setActionType(String t) {
    setState(() {
      actionType = t;
    });
    amountController.clear();
    priceController.clear();
    totalAmountController.clear();
    stagesCountController.clear();
    FocusScope.of(context).unfocus();
  }

  submit(context) async {
    Order order = Order(
      pair: pair,
      type: type,
      actionType: actionType,
      amount: double.tryParse(amountController.text),
      price: double.tryParse(priceController.text),
      totalAmount: double.tryParse(totalAmountController.text),
      stages: stagesControllers.map((e) {
        return Stage(
          percent: double.tryParse(e.elementAt(0).text),
          price: double.tryParse(e.elementAt(1).text),
        );
      }).toList(),
    );

    bool isValid = true;
    String error = '';

    if (order.actionType == 'stage') {
      if (order.totalAmount == null || order.totalAmount == 0) {
        isValid = false;
        if (error.isEmpty) error = 'حجم کل رو وارد کنید';
      }
      if (order.stages == null || order.stages!.isEmpty) {
        isValid = false;
        if (error.isEmpty) error = 'تعداد پله ها رو وارد کنید';
      }
      double sum = 0;

      for (int i = 0; i < order.stages!.length; i++) {
        double? pr = order.stages!.elementAt(i).percent;
        double? pc = order.stages!.elementAt(i).price;
        if (pr == null || pr == 0.0) {
          isValid = false;
          if (error.isEmpty) {
            error = 'درصد پله ' + (i + 1).toString() + ' رو وارد کنید';
          }
          break;
        }
        if (pc == null || pc == 0.0) {
          isValid = false;
          if (error.isEmpty) {
            error = 'قیمت پله ' + (i + 1).toString() + ' رو وارد کنید';
          }
          break;
        }
        sum += pr;
      }
      if (sum != 100) {
        isValid = false;
        if (error.isEmpty) error = 'درصد پله ها رو به درستی وارد نکرده اید';
      }
    } else {
      if (order.amount == null || order.amount == 0) {
        isValid = false;
        if (error.isEmpty) error = 'حجم رو وارد کنید';
      }
      if (order.price == null || order.price == 0) {
        isValid = false;
        if (error.isEmpty) error = 'قیمت رو وارد کنید';
      }
    }

    if (!isValid) {
      print(error);
      setState(() {
        errors = error;
      });
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          errors = '';
        });
      });
      return;
    }

    setState(() {
      disabled = true;
    });

    Navigator.pop(context, order);
  }

  Widget stagesItem(int ii) {
    return Card(
      color: const Color.fromARGB(255, 255, 187, 0),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text("پله " + (ii + 1).toString()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: stagesControllers[ii][0],
                    textInputAction: TextInputAction.next,
                    textDirection: TextDirection.ltr,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "درصد",
                      contentPadding: EdgeInsets.only(left: 15, right: 15),
                    ),
                    enabled: !disabled,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(5)),
                Expanded(
                  child: TextFormField(
                    controller: stagesControllers[ii][1],
                    textInputAction: TextInputAction.next,
                    textDirection: TextDirection.ltr,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "قیمت",
                      contentPadding: EdgeInsets.only(left: 15, right: 15),
                    ),
                    enabled: !disabled,
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
  Widget build(BuildContext context) {
    //
    final normalAction = [
      GestureDetector(
        onTap: disabled ? null : () => setActionType('stage'),
        child: Center(
          child: Text(
            type == 'buy' ? "خرید پله ای؟" : "فروش پله ای؟",
            style: const TextStyle(color: Colors.lightBlue),
          ),
        ),
      ),
      const Padding(padding: EdgeInsets.all(5)),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: TextFormField(
              controller: amountController,
              textInputAction: TextInputAction.next,
              textDirection: TextDirection.ltr,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "حجم",
                contentPadding: EdgeInsets.only(left: 15, right: 15),
              ),
              enabled: !disabled,
            ),
          ),
          const Padding(padding: EdgeInsets.all(5)),
          Expanded(
            child: TextFormField(
              controller: priceController,
              textInputAction: TextInputAction.next,
              textDirection: TextDirection.ltr,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "قیمت",
                contentPadding: EdgeInsets.only(left: 15, right: 15),
              ),
              enabled: !disabled,
            ),
          ),
        ],
      ),
    ];

    final stageAction = [
      GestureDetector(
        onTap: disabled ? null : () => setActionType('normal'),
        child: Center(
          child: Text(
            type == 'buy' ? "خرید عادی؟" : "فروش عادی؟",
            style: const TextStyle(color: Colors.lightBlue),
          ),
        ),
      ),
      const Padding(padding: EdgeInsets.all(5)),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: TextFormField(
              controller: totalAmountController,
              textInputAction: TextInputAction.next,
              textDirection: TextDirection.ltr,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "حجم کل",
                contentPadding: EdgeInsets.only(left: 15, right: 15),
              ),
              enabled: !disabled,
            ),
          ),
          const Padding(padding: EdgeInsets.all(5)),
          Expanded(
            child: TextFormField(
              controller: stagesCountController,
              textInputAction: TextInputAction.next,
              textDirection: TextDirection.ltr,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "تعداد پله",
                contentPadding: EdgeInsets.only(left: 15, right: 15),
              ),
              enabled: !disabled,
            ),
          ),
        ],
      ),
      const Padding(padding: EdgeInsets.all(5)),
      for (int i = 0; i < stagesCount; i++) stagesItem(i),
    ];

    return KeyboardVisibilityBuilder(
      builder: (BuildContext context, List<Widget> children,
          bool isKeyboardVisible, double bottomInset) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: DraggableScrollableSheet(
            expand: false,
            maxChildSize: 0.85,
            minChildSize: 0.5,
            initialChildSize: 0.7,
            builder: (_, c) {
              return Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        "سفارش جدید",
                        style: Theme.of(context).textTheme.titleMedium!,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: disabled ? null : () => setType('buy'),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: type == 'buy'
                                      ? Colors.green
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(50),
                                  border:
                                      Border.all(color: Colors.green, width: 1),
                                ),
                                child: const Center(
                                  child: Text("خرید"),
                                ),
                                height: 40,
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(5)),
                          Expanded(
                            child: GestureDetector(
                              onTap: disabled ? null : () => setType('sell'),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: type == 'sell'
                                      ? Colors.red
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(50),
                                  border:
                                      Border.all(color: Colors.red, width: 1),
                                ),
                                child: const Center(
                                  child: Text("فروش"),
                                ),
                                height: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    Expanded(
                      child: ListView(
                        controller: c,
                        children: children,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    errors.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              errors,
                              style: const TextStyle(color: Colors.red),
                            ),
                          )
                        : Container(),
                    //
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: disabled ? null : () => submit(context),
                        child: const Text("ایجاد سفارش"),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
      children: actionType == 'stage' ? stageAction : normalAction,
    );
  }
}
