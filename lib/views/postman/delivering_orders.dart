import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:flutter_swipe_action_cell/core/controller.dart';
import 'package:hejposta/controllers/postman_orders_controller.dart';
import 'package:hejposta/controllers/zones_controller.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/equalization_provider.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/providers/postman_order_provider.dart';
import 'package:hejposta/providers/user_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/shortcuts/modals.dart';
import 'package:hejposta/shortcuts/order_form.dart';
import 'package:hejposta/views/business/order_details.dart';
import 'package:hejposta/views/postman/postman_drawer.dart';
import 'package:provider/provider.dart';

class DeliveringOrders extends StatefulWidget {
  const DeliveringOrders({Key? key}) : super(key: key);

  @override
  State<DeliveringOrders> createState() => _DeliveringOrdersState();
}

class _DeliveringOrdersState extends State<DeliveringOrders> {
  PageController pageController = PageController(
    initialPage: 0,
  );
  SwipeActionController swipeActionController = SwipeActionController();
  final TextEditingController _comment = TextEditingController();
  final TextEditingController _zones = TextEditingController();
  final TextEditingController _kerkoPorosine = TextEditingController();
  bool commented = false;
  int selectedIndex = 0;
  GlobalKey key = GlobalKey();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  ScrollController? _scrollController;
  bool _showAppbarColor = false;

  bool filerEqualized = false;
  int deliveringStep = 0;

  bool up = false;
  bool left = false;

  bool search = false;
  bool requesting = false;
  bool loadedOrder = false;
  bool deliveredOrder = false;
  bool rejectedOrder = false;
  bool returnedOrder = false;
  bool hasReason = false;
  int reasonType = -1;
  String zone = "";
  List<String> reasons = [
    "Produkti eshte i demtuar",
    "Produkti eshte i hapur",
    "Pranuesi nuk eshte i qasshem",
    "Pranuesi nuk deshiron ta pranoj porosine",
    "Tjeter"
  ];

  StateSetter? _setState;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      if (_scrollController!.offset <= 70) {
        setState(() {
          _showAppbarColor = false;
        });
      } else {
        setState(() {
          _showAppbarColor = true;
        });
      }
    });

    Future.delayed(const Duration(seconds: 1)).then((value) {
      setState(() {
        up = true;
      });

      Future.delayed(const Duration(seconds: 20)).then((value) {
        setState(() {
          up = false;
        });
      });
    });

    getPostmanZones();
    super.initState();
  }

  getOrders() {
    PostmanOrdersController postmanOrdersController = PostmanOrdersController();
    postmanOrdersController.getOnDeliveringOrders(context);
  }

  deliverOrder(id) {
    setState(() {
      requesting = true;
    });
    PostmanOrdersController postmanOrdersController = PostmanOrdersController();
    postmanOrdersController.dergoTeKlientiPorosine(context, id).then((value) {
      if (value == "success") {
        setState(() {
          deliveredOrder = true;
        });
        Future.delayed(const Duration(milliseconds: 900)).then((d){
          setState(() {
            deliveredOrder = false;
          });
        });
      } else if (value == "NotFound") {
        showModalOne(
            context,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Nuk ekziston kjo porosi per dergese",
                      style: AppStyles.getHeaderNameText(
                          color: Colors.blueGrey[800], size: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 40,
                        width: getPhoneWidth(context) / 2 - 80,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(100)),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Largo",
                              style: AppStyles.getHeaderNameText(
                                  color: Colors.white, size: 17),
                            ))),
                  ],
                )
              ],
            ),
            150.0);
      }
      else if (value == "NotValid") {
        showModalOne(
            context,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Shifra e porosise eshte jo valide!",
                      style: AppStyles.getHeaderNameText(
                          color: Colors.blueGrey[800], size: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 40,
                        width: getPhoneWidth(context) / 2 - 80,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(100)),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Largo",
                              style: AppStyles.getHeaderNameText(
                                  color: Colors.white, size: 17),
                            ))),
                  ],
                )
              ],
            ),
            150.0);
      } else {
        showModalOne(
            context,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      value,textAlign: TextAlign.center,
                      style: AppStyles.getHeaderNameText(
                          color: Colors.blueGrey[800], size: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 40,
                        width: getPhoneWidth(context) / 2 - 80,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(100)),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Largo",
                              style: AppStyles.getHeaderNameText(
                                  color: Colors.white, size: 17),
                            ))),
                  ],
                )
              ],
            ),
            150.0);
      }
    }).whenComplete(() {
      setState(() {
        requesting = false;
      });
    });
  }

  rejectOrder(id) {
    setState(() {
      requesting = true;
    });
    PostmanOrdersController postmanOrdersController = PostmanOrdersController();
    postmanOrdersController
        .refuzoNgaKlientiPorosine(
            context, id, reasons[reasonType], _comment.text)
        .then((value) {
      if (value == "success") {
        setState(() {
          rejectedOrder = true;
        });
        Future.delayed(const Duration(milliseconds: 900)).then((d){
          setState(() {
            rejectedOrder = false;
          });
        });
      } else if (value == "NotFound") {

        showModalOne(
            context,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Kjo porosi nuk ekziston!",
                      style: AppStyles.getHeaderNameText(
                          color: Colors.blueGrey[800], size: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 40,
                        width: getPhoneWidth(context) / 2 - 80,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(100)),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Largo",
                              style: AppStyles.getHeaderNameText(
                                  color: Colors.white, size: 17),
                            ))),
                  ],
                )
              ],
            ),
            150.0);
      } else if (value == "NotValid") {
        showModalOne(
            context,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Shifra e porosise eshte jo valide!",
                      style: AppStyles.getHeaderNameText(
                          color: Colors.blueGrey[800], size: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 40,
                        width: getPhoneWidth(context) / 2 - 80,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(100)),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Largo",
                              style: AppStyles.getHeaderNameText(
                                  color: Colors.white, size: 17),
                            ))),
                  ],
                )
              ],
            ),
            150.0);
      }
      else {
        showModalOne(
            context,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      value,textAlign: TextAlign.center,
                      style: AppStyles.getHeaderNameText(
                          color: Colors.blueGrey[800], size: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 40,
                        width: getPhoneWidth(context) / 2 - 80,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(100)),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Largo",
                              style: AppStyles.getHeaderNameText(
                                  color: Colors.white, size: 17),
                            ))),
                  ],
                )
              ],
            ),
            150.0);
      }
    }).whenComplete(() {
      setState(() {
        requesting = false;
        hasReason = false;
        reasonType = -1;
        _comment.text = "";
      });
    });
  }

  returnOrder(id) {
    setState(() {
      requesting = true;
    });
    PostmanOrdersController postmanOrdersController = PostmanOrdersController();
    postmanOrdersController
        .riktheNgaKlientiPorosine(
            context, id, reasons[reasonType], _comment.text)
        .then((value) {
      if (value == "success") {
        setState(() {
          returnedOrder = true;
        });
        Future.delayed(const Duration(milliseconds: 900)).then((d){
          setState(() {
            returnedOrder = false;
          });
        });
      } else if (value == "NotFound") {
        showModalOne(
            context,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Kjo porosi nuk ekziston!",
                      style: AppStyles.getHeaderNameText(
                          color: Colors.blueGrey[800], size: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 40,
                        width: getPhoneWidth(context) / 2 - 80,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(100)),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Largo",
                              style: AppStyles.getHeaderNameText(
                                  color: Colors.white, size: 17),
                            ))),
                  ],
                )
              ],
            ),
            150.0);
      } else if (value == "NotValid") {
        showModalOne(
            context,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Shifra e porosise eshte jo valide!",
                      style: AppStyles.getHeaderNameText(
                          color: Colors.blueGrey[800], size: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 40,
                        width: getPhoneWidth(context) / 2 - 80,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(100)),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Largo",
                              style: AppStyles.getHeaderNameText(
                                  color: Colors.white, size: 17),
                            ))),
                  ],
                )
              ],
            ),
            150.0);
      } else {
        showModalOne(
            context,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      value,
                      style: AppStyles.getHeaderNameText(
                          color: Colors.blueGrey[800], size: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 40,
                        width: getPhoneWidth(context) / 2 - 80,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(100)),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Largo",
                              style: AppStyles.getHeaderNameText(
                                  color: Colors.white, size: 17),
                            ))),
                  ],
                )
              ],
            ),
            150.0);
      }
    }).whenComplete(() {
      setState(() {
        requesting = false;
        hasReason = false;
        reasonType = -1;
        _comment.text = "";
      });
    });
  }

  loadOrder(id) {
    setState(() {
      requesting = true;
    });
    PostmanOrdersController postmanOrdersController = PostmanOrdersController();
    postmanOrdersController
        .ngarkoPorosinePerDergese(
            context, id, zone)
        .then((value) {
      if (value == "success") {
        setState(() {
          loadedOrder = true;
        });
        Future.delayed(const Duration(milliseconds: 900)).then((d){
          setState(() {
            loadedOrder = false;
          });
        });
      } else if (value == "NotFound") {
        showModalOne(
            context,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Kjo porosi nuk ekziston!",
                      style: AppStyles.getHeaderNameText(
                          color: Colors.blueGrey[800], size: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 40,
                        width: getPhoneWidth(context) / 2 - 80,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(100)),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Largo",
                              style: AppStyles.getHeaderNameText(
                                  color: Colors.white, size: 17),
                            ))),
                  ],
                )
              ],
            ),
            150.0);
      } else if (value == "NotValid") {
        showModalOne(
            context,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Shifra e porosise eshte jo valide!",
                      style: AppStyles.getHeaderNameText(
                          color: Colors.blueGrey[800], size: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 40,
                        width: getPhoneWidth(context) / 2 - 80,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(100)),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Largo",
                              style: AppStyles.getHeaderNameText(
                                  color: Colors.white, size: 17),
                            ))),
                  ],
                )
              ],
            ),
            150.0);
      } else {
        showModalOne(
            context,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      value,
                      style: AppStyles.getHeaderNameText(
                          color: Colors.blueGrey[800], size: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 40,
                        width: getPhoneWidth(context) / 2 - 80,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(100)),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Largo",
                              style: AppStyles.getHeaderNameText(
                                  color: Colors.white, size: 17),
                            ))),
                  ],
                )
              ],
            ),
            150.0);
      }
    }).whenComplete(() {
      setState(() {
        requesting = false;
        hasReason = false;
        reasonType = -1;
        _comment.text = "";
      });
    });
  }

  scanOrder(orderNumber, type) {
    // var user = Provider.of<UserProvider>(context,listen: false);
    if(orderNumber != "-1"){
      showModalOne(
          context,
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "Konfirmo ${type == "deliver" ? "pranimin" : type == "reject" ? "anulimin" : type == "load" ?  "ngarkesen": "rikthimin"} e porosise",
                    style: AppStyles.getHeaderNameText(
                        color: Colors.blueGrey[800], size: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Numri porosise: $orderNumber",
                    style: AppStyles.getHeaderNameText(
                        color: Colors.blueGrey[600], size: 17),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      height: 40,
                      width: getPhoneWidth(context) / 2 - 80,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(100)),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Jo",
                            style: AppStyles.getHeaderNameText(
                                color: Colors.white, size: 17),
                          ))),
                  Container(
                      height: 40,
                      width: getPhoneWidth(context) / 2 - 80,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(100)),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            if (type == "deliver") {
                              Navigator.of(context).pop();
                              deliverOrder(orderNumber);
                            }
                            else if (type == "reject") {
                              Navigator.of(context).pop();
                              showModalOne(context, StatefulBuilder(builder: (context, setter) {
                                _setState = setter;
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child: ListView(
                                    children: [
                                      ListView.builder(
                                        physics: const ScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  _setState!(() {
                                                    hasReason = true;
                                                    reasonType = index;
                                                  });
                                                },
                                                child: Container(
                                                  width:
                                                  getPhoneWidth(context) - 50,
                                                  height: 60,
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                                  decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      border: Border.all(
                                                          color:
                                                          Colors.grey[200]!)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                          width: getPhoneWidth(
                                                              context) -
                                                              133,
                                                          child: Text(
                                                            reasons[index],
                                                            maxLines: 2,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: AppStyles
                                                                .getHeaderNameText(
                                                                color: Colors
                                                                    .blueGrey,
                                                                size: 16.0),
                                                          )),
                                                      Container(
                                                        width: 25,
                                                        height: 25,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .blueGrey)),
                                                        child: reasonType != index
                                                            ? const SizedBox()
                                                            : Container(
                                                          width: 25,
                                                          height: 25,
                                                          margin:
                                                          const EdgeInsets
                                                              .all(2),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  100),
                                                              color: Colors
                                                                  .blueGrey),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          );
                                        },
                                        itemCount: reasons.length,
                                      ),
                                      reasonType != reasons.length - 1
                                          ? const SizedBox()
                                          : Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextField(
                                            minLines: 4,
                                            maxLines: 4,
                                            onChanged: (value) {
                                              if (value.isEmpty) {
                                                _setState!(() {
                                                  commented = false;
                                                });
                                              } else {
                                                _setState!(() {
                                                  commented = true;
                                                });
                                              }
                                            },
                                            controller: _comment,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Arsyeja",
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      15),
                                                  borderSide: BorderSide(
                                                      color:
                                                      Colors.grey[200]!),
                                                ),
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      15),
                                                  borderSide: BorderSide(
                                                      color:
                                                      Colors.grey[200]!),
                                                ),
                                                contentPadding:
                                                const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 15,
                                                    vertical: 10)),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                              height: 40,
                                              width:
                                              getPhoneWidth(context) / 2 - 80,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[400],
                                                  borderRadius:
                                                  BorderRadius.circular(100)),
                                              child: TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "Largo",
                                                    style:
                                                    AppStyles.getHeaderNameText(
                                                        color: Colors.white,
                                                        size: 17),
                                                  ))),
                                          Container(
                                              height: 40,
                                              width:
                                              getPhoneWidth(context) / 2 - 80,
                                              decoration: BoxDecoration(
                                                  color: commented || hasReason
                                                      ? Colors.blueGrey
                                                      : Colors.grey[400],
                                                  borderRadius:
                                                  BorderRadius.circular(100)),
                                              child: TextButton(
                                                  onPressed: () {
                                                    if (!hasReason) {
                                                      _setState!(() {
                                                        commented = false;
                                                      });
                                                    } else {
                                                      Navigator.pop(context);
                                                      rejectOrder(orderNumber);
                                                      swipeActionController
                                                          .closeAllOpenCell();
                                                    }
                                                  },
                                                  child: Text(
                                                    "Vazhdo",
                                                    style:
                                                    AppStyles.getHeaderNameText(
                                                        color: Colors.white,
                                                        size: 17),
                                                  ))),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }), 415.0);
                            }
                            else if (type == "return") {
                              Navigator.of(context).pop();
                              showModalOne(context,
                                  StatefulBuilder(builder: (context, setter) {
                                    _setState = setter;
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).viewInsets.bottom),
                                      child: ListView(
                                        children: [
                                          ListView.builder(
                                            physics: const ScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      _setState!(() {
                                                        hasReason = true;
                                                        reasonType = index;
                                                      });
                                                    },
                                                    child: Container(
                                                      width:
                                                      getPhoneWidth(context) - 50,
                                                      height: 60,
                                                      padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 15),
                                                      decoration: BoxDecoration(
                                                          color: Colors.transparent,
                                                          borderRadius:
                                                          BorderRadius.circular(10),
                                                          border: Border.all(
                                                              color:
                                                              Colors.grey[200]!)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                              width: getPhoneWidth(
                                                                  context) -
                                                                  133,
                                                              child: Text(
                                                                reasons[index],
                                                                maxLines: 2,
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                                style: AppStyles
                                                                    .getHeaderNameText(
                                                                    color: Colors
                                                                        .blueGrey,
                                                                    size: 16.0),
                                                              )),
                                                          Container(
                                                            width: 25,
                                                            height: 25,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(100),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .blueGrey)),
                                                            child: reasonType != index
                                                                ? const SizedBox()
                                                                : Container(
                                                              width: 25,
                                                              height: 25,
                                                              margin:
                                                              const EdgeInsets
                                                                  .all(2),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      100),
                                                                  color: Colors
                                                                      .blueGrey),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                ],
                                              );
                                            },
                                            itemCount: reasons.length,
                                          ),
                                          reasonType != reasons.length - 1
                                              ? const SizedBox()
                                              : Column(
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              TextField(
                                                minLines: 4,
                                                maxLines: 4,
                                                onChanged: (value) {
                                                  if (value.isEmpty) {
                                                    _setState!(() {
                                                      commented = false;
                                                    });
                                                  } else {
                                                    _setState!(() {
                                                      commented = true;
                                                    });
                                                  }
                                                },
                                                controller: _comment,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: "Arsyeja",
                                                    enabledBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          15),
                                                      borderSide: BorderSide(
                                                          color:
                                                          Colors.grey[200]!),
                                                    ),
                                                    focusedBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          15),
                                                      borderSide: BorderSide(
                                                          color:
                                                          Colors.grey[200]!),
                                                    ),
                                                    contentPadding:
                                                    const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15,
                                                        vertical: 10)),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                  height: 40,
                                                  width:
                                                  getPhoneWidth(context) / 2 - 80,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[400],
                                                      borderRadius:
                                                      BorderRadius.circular(100)),
                                                  child: TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        "Largo",
                                                        style:
                                                        AppStyles.getHeaderNameText(
                                                            color: Colors.white,
                                                            size: 17),
                                                      ))),
                                              Container(
                                                  height: 40,
                                                  width:
                                                  getPhoneWidth(context) / 2 - 80,
                                                  decoration: BoxDecoration(
                                                      color: commented || hasReason
                                                          ? Colors.blueGrey
                                                          : Colors.grey[400],
                                                      borderRadius:
                                                      BorderRadius.circular(100)),
                                                  child: TextButton(
                                                      onPressed: () {
                                                        if (!hasReason) {
                                                          _setState!(() {
                                                            commented = false;
                                                          });
                                                        } else {
                                                          Navigator.pop(context);
                                                          returnOrder(orderNumber);
                                                          swipeActionController
                                                              .closeAllOpenCell();
                                                        }
                                                      },
                                                      child: Text(
                                                        "Vazhdo",
                                                        style:
                                                        AppStyles.getHeaderNameText(
                                                            color: Colors.white,
                                                            size: 17),
                                                      ))),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  }), 415.0);
                            }
                            else if (type == "load") {
                              // showModalOne(context,
                              //     StatefulBuilder(builder: (context, setter) {
                              //   _setState = setter;
                              //   return ListView(
                              //     children: [
                              //       ListView.builder(
                              //         physics: const ScrollPhysics(),
                              //         shrinkWrap: true,
                              //         itemBuilder: (context, index) {
                              //           return Column(
                              //             children: [
                              //               GestureDetector(
                              //                 onTap: () {
                              //                   _setState!(() {
                              //                     zone = user.getUser().areas[index].name;
                              //                   });
                              //                 },
                              //                 child: Container(
                              //                   width:
                              //                       getPhoneWidth(context) - 50,
                              //                   height: 60,
                              //                   padding:
                              //                       const EdgeInsets.symmetric(
                              //                           horizontal: 15),
                              //                   decoration: BoxDecoration(
                              //                       color: Colors.transparent,
                              //                       borderRadius:
                              //                           BorderRadius.circular(10),
                              //                       border: Border.all(
                              //                           color:
                              //                               Colors.grey[200]!)),
                              //                   child: Row(
                              //                     mainAxisAlignment:
                              //                         MainAxisAlignment
                              //                             .spaceBetween,
                              //                     children: [
                              //                       SizedBox(
                              //                           width: getPhoneWidth(
                              //                                   context) -
                              //                               133,
                              //                           child: Text(
                              //                             user.getUser().areas[index].name.toString(),
                              //                             maxLines: 2,
                              //                             overflow: TextOverflow
                              //                                 .ellipsis,
                              //                             style: AppStyles
                              //                                 .getHeaderNameText(
                              //                                     color: Colors
                              //                                         .blueGrey,
                              //                                     size: 16.0),
                              //                           )),
                              //                       Container(
                              //                         width: 25,
                              //                         height: 25,
                              //                         decoration: BoxDecoration(
                              //                             borderRadius:
                              //                                 BorderRadius
                              //                                     .circular(100),
                              //                             border: Border.all(
                              //                                 color: Colors
                              //                                     .blueGrey)),
                              //                         child: zone != user.getUser().areas[index].name
                              //                             ? const SizedBox()
                              //                             : Container(
                              //                                 width: 25,
                              //                                 height: 25,
                              //                                 margin:
                              //                                     const EdgeInsets
                              //                                         .all(2),
                              //                                 decoration: BoxDecoration(
                              //                                     borderRadius:
                              //                                         BorderRadius
                              //                                             .circular(
                              //                                                 100),
                              //                                     color: Colors
                              //                                         .blueGrey),
                              //                               ),
                              //                       )
                              //                     ],
                              //                   ),
                              //                 ),
                              //               ),
                              //               const SizedBox(
                              //                 height: 5,
                              //               ),
                              //             ],
                              //           );
                              //         },
                              //         itemCount: user.getUser().areas.length,
                              //       ),
                              //
                              //       const SizedBox(
                              //         height: 10,
                              //       ),
                              //       Row(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.spaceEvenly,
                              //         children: [
                              //           Container(
                              //               height: 40,
                              //               width:
                              //                   getPhoneWidth(context) / 2 - 80,
                              //               decoration: BoxDecoration(
                              //                   color: Colors.grey[400],
                              //                   borderRadius:
                              //                       BorderRadius.circular(100)),
                              //               child: TextButton(
                              //                   onPressed: () {
                              //                     Navigator.pop(context);
                              //                   },
                              //                   child: Text(
                              //                     "Largo",
                              //                     style:
                              //                         AppStyles.getHeaderNameText(
                              //                             color: Colors.white,
                              //                             size: 17),
                              //                   ))),
                              //           Container(
                              //               height: 40,
                              //               width:
                              //                   getPhoneWidth(context) / 2 - 80,
                              //               decoration: BoxDecoration(
                              //                   color: zone.isNotEmpty
                              //                       ? Colors.blueGrey
                              //                       : Colors.grey[400],
                              //                   borderRadius:
                              //                       BorderRadius.circular(100)),
                              //               child: TextButton(
                              //                   onPressed: () {
                              //
                              //                   },
                              //                   child: Text(
                              //                     "Vazhdo",
                              //                     style:
                              //                         AppStyles.getHeaderNameText(
                              //                             color: Colors.white,
                              //                             size: 17),
                              //                   ))),
                              //         ],
                              //       )
                              //     ],
                              //   );
                              // }), 415.0);
                              Navigator.pop(context);
                              loadOrder(orderNumber);
                            }
                          },
                          child: Text(
                            "Po",
                            style: AppStyles.getHeaderNameText(
                                color: Colors.white, size: 17),
                          ))),
                ],
              )
            ],
          ),
          150.0);
    }

  }

  getPostmanZones() {
    ZonesController zonesController = ZonesController();
    zonesController.getZones(context);
  }

  searchByZone(zone) {
    var postmanOrders =
        Provider.of<PostmanOrderProvider>(context, listen: false);
    postmanOrders.addZone(zone);
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var generalProvider = Provider.of<GeneralProvider>(context, listen: true);
    var user = Provider.of<UserProvider>(context, listen: true);
    var postmanOrders = Provider.of<PostmanOrderProvider>(context, listen: true);
    var equalizedOrders = Provider.of<EqualizationProvier>(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.bottomColorOne,
      drawer: const PostmanDrawer(),
      drawerScrimColor: Colors.transparent,
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      onDrawerChanged: (status) {
        generalProvider.changeDrawerStatus(status);
        setState(() {});
      },
      body: Stack(
        children: [
          AnimatedPositioned(
              duration: const Duration(
                seconds: 20,
              ),
              top: !up ? -65 : 65,
              left: -165,
              child: SizedBox(
                child: Image.asset(
                  "assets/icons/map-icon.png",
                  color: AppColors.mapColorSecond,
                  fit: BoxFit.cover,
                ),
              )),
          SizedBox(
            width: getPhoneWidth(context),
            height: getPhoneHeight(context),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).viewPadding.top,
                    decoration: BoxDecoration(color: AppColors.appBarColor),
                  ),
                  SizedBox(
                    height: getPhoneHeight(context) - 75,
                    child: NestedScrollView(
                        key: key,
                        controller: _scrollController,
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return [
                            SliverAppBar(
                              pinned: false,
                              primary: false,
                              stretch: false,
                              expandedHeight: 0,
                              toolbarHeight: 50,
                              automaticallyImplyLeading: false,
                              backgroundColor: Colors.transparent,
                              title: Container(
                                padding: const EdgeInsets.only(
                                    left: 17, right: 17, top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                        width: 70,
                                        child: Image.asset(
                                            "assets/logos/hej-logo.png")),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              search = !search;
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.search,
                                            size: 30,
                                          ),
                                        ),
                                        // SizedBox(
                                        //   width: 70,
                                        //   height: 26,
                                        //   child:
                                        //       Image.asset("assets/icons/3.png"),
                                        // ),
                                        // const SizedBox(
                                        //   width: 10,
                                        // ),
                                        IconButton(
                                            onPressed: () {
                                              scaffoldKey.currentState!
                                                  .openDrawer();
                                            },
                                            icon: const Icon(
                                              Icons.menu,
                                              size: 30,
                                            ))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              collapsedHeight: 50,
                            ),
                            generalProvider.checkDrawerStatus() == true
                                ? SliverAppBar(
                                    pinned: true,
                                    primary: false,
                                    expandedHeight: 0,
                                    foregroundColor: Colors.red,
                                    toolbarHeight: 58,
                                    shadowColor: AppColors.bottomColorOne,
                                    surfaceTintColor: Colors.red,
                                    scrolledUnderElevation: 0,
                                    backgroundColor: _showAppbarColor
                                        ? AppColors.bottomColorOne
                                        : Colors.transparent,
                                    automaticallyImplyLeading: false,
                                  )
                                : SliverAppBar(
                                    pinned: true,
                                    primary: false,
                                    expandedHeight: 0,
                                    foregroundColor: Colors.red,
                                    toolbarHeight: _showAppbarColor ? 65 : 90,
                                    shadowColor: AppColors.bottomColorOne,
                                    surfaceTintColor: Colors.red,
                                    scrolledUnderElevation: 0,
                                    backgroundColor: _showAppbarColor
                                        ? AppColors.bottomColorOne
                                        : Colors.transparent,
                                    automaticallyImplyLeading: false,
                                    title: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Column(
                                        children: [
                                          _showAppbarColor
                                              ? const SizedBox()
                                              : Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: orderGroupNumbers(
                                                      context, "delivering",
                                                      npritje: postmanOrders
                                                          .porosiNePritje()
                                                          .toString(),
                                                      ndergese: postmanOrders
                                                          .getOnDeliveryOrders(
                                                              "delivering")
                                                          .length
                                                          .toString(),
                                                      perBarazim: equalizedOrders
                                                          .getEqualizations()
                                                          .length
                                                          .toString())),
                                          Container(
                                            width: getPhoneWidth(context) - 20,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    color: Colors.white)),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  search
                                                      ? Row(
                                                          children: [
                                                            Container(
                                                                decoration: const BoxDecoration(
                                                                    border: Border(
                                                                        right: BorderSide(
                                                                            color: Colors
                                                                                .white))),
                                                                width: getPhoneWidth(
                                                                        context) -
                                                                    145,
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      _kerkoPorosine,
                                                                  onChanged:
                                                                      (value) {
                                                                    postmanOrders
                                                                        .filtroNeDergese(
                                                                            value,
                                                                            "delivering");
                                                                  },
                                                                  decoration: InputDecoration(
                                                                      hintText:
                                                                          "Kerko",
                                                                      hintStyle: AppStyles.getHeaderNameText(
                                                                          color: Colors
                                                                              .white,
                                                                          size:
                                                                              15.0),
                                                                      border: InputBorder
                                                                          .none,
                                                                      isDense:
                                                                          true,
                                                                      contentPadding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              20,
                                                                          vertical:
                                                                              7)),
                                                                )),
                                                            GestureDetector(
                                                              onTap: () {
                                                                if (user.getUser()!.areas !=
                                                                        null &&
                                                                    user
                                                                            .getUser()!
                                                                            .areas
                                                                            .length >
                                                                        0) {
                                                                  setState(() {
                                                                    // ignore: prefer_interpolation_to_compose_strings
                                                                    _zones
                                                                            .text =
                                                                        // ignore: prefer_interpolation_to_compose_strings
                                                                        "${user.getUser()!.areas[0]['name'].toString().trim()} - " +
                                                                            user.getUser()!.areas[0]['cityName'];
                                                                  });
                                                                }

                                                                showModalBottomSheet(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return StatefulBuilder(builder:
                                                                          (context,
                                                                              setter) {
                                                                        _setState =
                                                                            setter;
                                                                        return SizedBox(
                                                                          width:
                                                                              getPhoneWidth(context),
                                                                          height:
                                                                              300,
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 50,
                                                                                    width: getPhoneWidth(context) - 100,
                                                                                    padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
                                                                                    child: TextField(
                                                                                      controller: _zones,
                                                                                      decoration: InputDecoration(border: InputBorder.none, enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.blueGrey[400]!)), contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), isDense: true),
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                      width: 70,
                                                                                      height: 40,
                                                                                      decoration: BoxDecoration(
                                                                                        color: Colors.blueGrey[300],
                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                      ),
                                                                                      child: TextButton(
                                                                                          onPressed: () {
                                                                                            searchByZone(_zones.text);
                                                                                            Navigator.pop(context);
                                                                                          },
                                                                                          child: Text(
                                                                                            "Kerko",
                                                                                            style: AppStyles.getHeaderNameText(color: Colors.white, size: 14.0),
                                                                                          )))
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 250,
                                                                                child: CupertinoPicker.builder(
                                                                                    itemExtent: 40,
                                                                                    onSelectedItemChanged: (value) {
                                                                                      _setState!(() {
                                                                                        _zones.text = user.getUser()!.areas[value]['name'] + " - " + user.getUser()!.areas[value]['cityName'];
                                                                                      });
                                                                                    },
                                                                                    itemBuilder: (context, index) {
                                                                                      return SizedBox(
                                                                                        width: getPhoneWidth(context) - 50,
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          children: [
                                                                                            Text(
                                                                                              user.getUser()!.areas[index]['name'] + " - " + user.getUser()!.areas[index]['cityName'],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                    childCount: user.getUser()!.areas == null ? 0 : user.getUser()!.areas.length),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      });
                                                                    });
                                                              },
                                                              child: Container(
                                                                width: getPhoneWidth(
                                                                            context) /
                                                                        4 -
                                                                    30,
                                                                height: 33,
                                                                color: Colors
                                                                    .transparent,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          0),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Zona",
                                                                      style: AppStyles.getHeaderNameText(
                                                                          color: Colors
                                                                              .white,
                                                                          size:
                                                                              14.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                pageController.animateToPage(0,
                                                                    duration: const Duration(
                                                                        milliseconds:
                                                                            400),
                                                                    curve: Curves
                                                                        .linear);

                                                                setState(() {
                                                                  selectedIndex =
                                                                      0;
                                                                  deliveringStep =
                                                                      0;
                                                                });
                                                              },
                                                              child: Container(
                                                                height: 40,
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10),
                                                                child: Center(
                                                                  child: Text(
                                                                    "Ne dergese\n(${postmanOrders
                                                                        .porosiNeDergese()
                                                                        .toString()})",textAlign: TextAlign.center,
                                                                    style: AppStyles.getHeaderNameText(
                                                                        color: deliveringStep ==
                                                                                0
                                                                            ? Colors
                                                                                .blueGrey
                                                                            : Colors
                                                                                .white,
                                                                        size:
                                                                            14.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                pageController.animateToPage(1,
                                                                    duration: const Duration(
                                                                        milliseconds:
                                                                            400),
                                                                    curve: Curves
                                                                        .linear);

                                                                setState(() {
                                                                  selectedIndex =
                                                                      1;
                                                                  deliveringStep =
                                                                      1;
                                                                });
                                                              },
                                                              child: Container(
                                                                height: 40,
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10),
                                                                decoration:
                                                                    const BoxDecoration(
                                                                        border:
                                                                            Border(
                                                                  left: BorderSide(
                                                                      color: Colors
                                                                          .white),
                                                                )),
                                                                child: Center(
                                                                  child: Text(
                                                                    "Me sukses\n(${postmanOrders
                                                                        .porosiTeSuksesshme()
                                                                        .toString()})",textAlign: TextAlign.center,
                                                                    style: AppStyles.getHeaderNameText(
                                                                        color: deliveringStep ==
                                                                                1
                                                                            ? Colors
                                                                                .blueGrey
                                                                            : Colors
                                                                                .white,
                                                                        size:
                                                                            14.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                pageController.animateToPage(2,
                                                                    duration: const Duration(
                                                                        milliseconds:
                                                                            400),
                                                                    curve: Curves
                                                                        .linear);

                                                                setState(() {
                                                                  selectedIndex =
                                                                      2;
                                                                  deliveringStep =
                                                                      2;
                                                                });
                                                              },
                                                              child: Container(
                                                                height: 40,
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        15),
                                                                decoration: const BoxDecoration(
                                                                    border: Border(
                                                                        left: BorderSide(
                                                                            color: Colors
                                                                                .white),
                                                                        right: BorderSide(
                                                                            color:
                                                                                Colors.white))),
                                                                child: Center(
                                                                  child: Text(
                                                                    "Anuluara\n(${postmanOrders
                                                                        .porosiTeAnuluara()
                                                                        .toString()})",textAlign: TextAlign.center,
                                                                    style: AppStyles.getHeaderNameText(
                                                                        color: deliveringStep ==
                                                                                2
                                                                            ? Colors
                                                                                .blueGrey
                                                                            : Colors
                                                                                .white,
                                                                        size:
                                                                            14.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                pageController.animateToPage(3,
                                                                    duration: const Duration(
                                                                        milliseconds:
                                                                            400),
                                                                    curve: Curves
                                                                        .linear);

                                                                setState(() {
                                                                  selectedIndex =
                                                                      3;
                                                                  deliveringStep =
                                                                      3;
                                                                });
                                                              },
                                                              child: Container(
                                                                height: 40,
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10),
                                                                decoration:
                                                                    const BoxDecoration(
                                                                        border:
                                                                            Border(
                                                                  left: BorderSide(
                                                                      color: Colors
                                                                          .white),
                                                                )),
                                                                child: Center(
                                                                  child: Text(
                                                                    "Rikthyera\n(${postmanOrders
                                                                        .porosiTeRikthyera()
                                                                        .toString()})",textAlign: TextAlign.center,
                                                                    style: AppStyles.getHeaderNameText(
                                                                        color: deliveringStep ==
                                                                                3
                                                                            ? Colors
                                                                                .blueGrey
                                                                            : Colors
                                                                                .white,
                                                                        size:
                                                                            14.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    collapsedHeight: _showAppbarColor ? 65 : 105,
                                  ),
                          ];
                        },
                        // list of images for scrolling
                        body: generalProvider.checkDrawerStatus() == true
                            ? const SizedBox()
                            : PageView(
                                controller: pageController,
                                onPageChanged: (index) {
                                  setState(() {
                                    deliveringStep = index;
                                  });
                                },
                                children: [
                                  Stack(
                                    children: [
                                      delivering(postmanOrders),
                                      Positioned(
                                          bottom: 20,
                                          right: 30,
                                          child: GestureDetector(
                                            onTap: () async {

                                              showModalOne(
                                                  context,
                                                  Column(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () async {
                                                          String barcodeScanRes =
                                                          await FlutterBarcodeScanner.scanBarcode("#ff6666", "Largo", true,
                                                              ScanMode.QR).then((value) { return value; });
                                                          if (barcodeScanRes.isNotEmpty) { scanOrder(barcodeScanRes, "load"); }
                                                        },
                                                        child: Container(
                                                          width: getPhoneWidth(
                                                              context),
                                                          color: Colors.transparent,
                                                          height: 50,
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                                  horizontal: 10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [

                                                              const Icon(Icons.upload_rounded,color:Colors.blueGrey),
                                                              Text(
                                                                "Ngarko per dergese",
                                                                style: AppStyles
                                                                    .getHeaderNameText(
                                                                        color: Colors
                                                                                .blueGrey[
                                                                            800],
                                                                        size:
                                                                            18.0),
                                                              ),
                                                              const Icon(Icons
                                                                  .qr_code_2),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Divider(
                                                        color: Colors
                                                            .blueGrey[400],
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
//             String
                                                          String
                                                              barcodeScanRes =
                                                              await FlutterBarcodeScanner.scanBarcode(
                                                                      "#ff6666",
                                                                      "Largo",
                                                                      true,
                                                                      ScanMode
                                                                          .QR)
                                                                  .then(
                                                                      (value) {
                                                            return value;
                                                          });
                                                          if (barcodeScanRes
                                                              .isNotEmpty) {
                                                            scanOrder(
                                                                barcodeScanRes,
                                                                "deliver");
                                                          }
                                                        },
                                                        child: Container(
                                                          width: getPhoneWidth(
                                                              context),
                                                          height: 50,
                                                          color: Colors
                                                              .transparent,
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              const Icon(Icons.check_circle,color:Colors.green),
                                                              Text(
                                                                "Dorezo porosine",
                                                                style: AppStyles
                                                                    .getHeaderNameText(
                                                                        color: Colors.blueGrey[
                                                                            800],
                                                                        size:
                                                                            18.0),
                                                              ),
                                                              const Icon(Icons
                                                                  .qr_code_2),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Divider(
                                                        color: Colors
                                                            .blueGrey[400],
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          String
                                                              barcodeScanRes =
                                                              await FlutterBarcodeScanner.scanBarcode(
                                                                      "#ff6666",
                                                                      "Largo",
                                                                      true,
                                                                      ScanMode
                                                                          .QR)
                                                                  .then(
                                                                      (value) {
                                                            return value;
                                                          });
                                                          if (barcodeScanRes
                                                              .isNotEmpty) {
                                                            scanOrder(
                                                                barcodeScanRes,
                                                                "return");
                                                          }
                                                        },
                                                        child: Container(
                                                          width: getPhoneWidth(
                                                              context),
                                                          height: 50,
                                                          color: Colors
                                                              .transparent,
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              const Icon(Icons.refresh,color:Colors.blue),
                                                              Text(
                                                                "Rikthe ne depo",
                                                                style: AppStyles
                                                                    .getHeaderNameText(
                                                                        color: Colors.blueGrey[
                                                                            800],
                                                                        size:
                                                                            18.0),
                                                              ),
                                                              const Icon(Icons
                                                                  .qr_code_2),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Divider(
                                                        color: Colors
                                                            .blueGrey[400],
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                                      String
                                                                          barcodeScanRes =
                                                                          await FlutterBarcodeScanner.scanBarcode(
                                                                                  "#ff6666",
                                                                                  "Largo",
                                                                                  true,
                                                                                  ScanMode
                                                                                      .QR)
                                                                              .then(
                                                                                  (value) {
                                                                        return value;
                                                                      });
                                                                      if (barcodeScanRes
                                                                          .isNotEmpty) {
                                                                        scanOrder(
                                                                            barcodeScanRes,
                                                                            "reject");
                                                                      }
                                                        },
                                                        child: Container(
                                                          width: getPhoneWidth(
                                                              context),
                                                          height: 50,
                                                          color: Colors
                                                              .transparent,
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              const Icon(Icons.close,color:Colors.red),
                                                              Text(
                                                                "Anulo porosine",
                                                                style: AppStyles
                                                                    .getHeaderNameText(
                                                                        color: Colors.blueGrey[
                                                                            800],
                                                                        size:
                                                                            18.0),
                                                              ),
                                                              const Icon(Icons
                                                                  .qr_code_2),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Divider(
                                                        color: Colors
                                                            .blueGrey[400],
                                                      ),
                                                    ],
                                                  ),
                                                  300.0);
                                            },
                                            child: Container(
                                                width: 65,
                                                height: 65,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color:
                                                        Colors.blueGrey[400]),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons
                                                        .qr_code_scanner_outlined,
                                                    size: 28,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                          )),
                                      AnimatedPositioned(
                                          bottom: requesting ? 0 : -65,
                                          duration: const Duration(milliseconds: 200),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: getPhoneWidth(context) - 20,
                                              height: 55,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(20)),
                                              padding: const EdgeInsets.symmetric(horizontal: 25),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Ju lutem prisni pak...  ",
                                                    style: AppStyles.getHeaderNameText(
                                                        color: Colors.blueGrey, size: 16.0),
                                                  ),
                                                  const SizedBox(
                                                      width: 25,
                                                      height: 25,
                                                      child: CircularProgressIndicator(
                                                        color: Colors.blueGrey,
                                                        strokeWidth: 1.4,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          )),
                                      AnimatedPositioned(
                                          bottom: loadedOrder ? 0 : -65,
                                          duration: const Duration(milliseconds: 200),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: getPhoneWidth(context) - 20,
                                              height: 55,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(20)),
                                              padding: const EdgeInsets.symmetric(horizontal: 25),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Porosia u ngarkua me sukses ",
                                                    style: AppStyles.getHeaderNameText(
                                                        color: Colors.blueGrey, size: 16.0),
                                                  ),
                                                  SizedBox(
                                                      width: 25,
                                                      height: 25,
                                                      child: Icon(Icons.check_circle,color:AppColors.bottomColorTwo)),
                                                ],
                                              ),
                                            ),
                                          )),
                                      AnimatedPositioned(
                                          bottom: deliveredOrder ? 0 : -65,
                                          duration: const Duration(milliseconds: 200),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: getPhoneWidth(context) - 20,
                                              height: 55,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(20)),
                                              padding: const EdgeInsets.symmetric(horizontal: 25),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Porosia u dorezua me sukses ",
                                                    style: AppStyles.getHeaderNameText(
                                                        color: Colors.blueGrey, size: 16.0),
                                                  ),
                                                  SizedBox(
                                                      width: 25,
                                                      height: 25,
                                                      child: Icon(Icons.check_circle,color:AppColors.bottomColorTwo)),
                                                ],
                                              ),
                                            ),
                                          )),
                                      AnimatedPositioned(
                                          bottom: rejectedOrder ? 0 : -65,
                                          duration: const Duration(milliseconds: 200),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: getPhoneWidth(context) - 20,
                                              height: 55,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(20)),
                                              padding: const EdgeInsets.symmetric(horizontal: 25),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Porosia u anulua me sukses ",
                                                    style: AppStyles.getHeaderNameText(
                                                        color: Colors.blueGrey, size: 16.0),
                                                  ),
                                                  SizedBox(
                                                      width: 25,
                                                      height: 25,
                                                      child: Icon(Icons.check_circle,color:AppColors.bottomColorTwo)),
                                                ],
                                              ),
                                            ),
                                          )),
                                      AnimatedPositioned(
                                          bottom: returnedOrder ? 0 : -65,
                                          duration: const Duration(milliseconds: 200),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: getPhoneWidth(context) - 20,
                                              height: 55,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(20)),
                                              padding: const EdgeInsets.symmetric(horizontal: 25),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Porosia u rikthye me sukses ",
                                                    style: AppStyles.getHeaderNameText(
                                                        color: Colors.blueGrey, size: 16.0),
                                                  ),
                                                  SizedBox(
                                                      width: 25,
                                                      height: 25,
                                                      child: Icon(Icons.check_circle,color:AppColors.bottomColorTwo)),
                                                ],
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                  delivered(postmanOrders),
                                  canceled(postmanOrders),
                                  returned(postmanOrders),
                                ],
                              )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  delivering(PostmanOrderProvider postmanOrders) => postmanOrders
          .isFetchingPendingOrders()
      ? ListView(
          children: const [
            Center(
                child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 1.4,
            )),
          ],
        )
      : postmanOrders.getOnDeliveryOrders("delivering").isEmpty
          ? RefreshIndicator(
              onRefresh: () async {
                getOrders();
                getPostmanZones();
              },
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  Center(
                      child: Text(
                    "Nuk keni asnje porosi",
                    style: AppStyles.getHeaderNameText(
                        color: Colors.white, size: 17),
                  )),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                getOrders();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  var order = postmanOrders
                      .getOnDeliveryOrders("delivering")
                      .elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: getPhoneWidth(context),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 25, bottom: 3),
                                child: SizedBox(
                                  width: getPhoneWidth(context) / 2 - 60,
                                  child: Text(
                                    order.receiver!.fullName!,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyles.getHeaderNameText(
                                        color: Colors.white,
                                        size: 17.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 25, bottom: 3),
                                child: Text(
                                  "Nr: ${order.orderNumber}",
                                  style: AppStyles.getHeaderNameText(
                                      color: Colors.white,
                                      size: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => OrderDetails(
                                      orderModel: order,
                                    )));
                          },
                          child: SwipeActionCell(
                            controller: swipeActionController,
                            key: ObjectKey(index),
                            backgroundColor: Colors.transparent,
                            // trailingActions: [
                            //   SwipeAction(
                            //       backgroundRadius: 20,
                            //       forceAlignmentToBoundary: false,
                            //       widthSpace: 120,
                            //       closeOnTap: true,
                            //       onTap: (CompletionHandler handler) async {
                            //         showModalOne(
                            //             context,
                            //             Column(
                            //               mainAxisAlignment:
                            //                   MainAxisAlignment.spaceBetween,
                            //               children: [
                            //                 Column(
                            //                   children: [
                            //                     Text(
                            //                       "Konfirmo dorezimin e porosise",
                            //                       style: AppStyles
                            //                           .getHeaderNameText(
                            //                               color: Colors
                            //                                   .blueGrey[800],
                            //                               size: 20),
                            //                     ),
                            //                     const SizedBox(
                            //                       height: 10,
                            //                     ),
                            //                     Text(
                            //                       "Numri porosise: ${order.orderNumber}",
                            //                       style: AppStyles
                            //                           .getHeaderNameText(
                            //                               color: Colors
                            //                                   .blueGrey[600],
                            //                               size: 17),
                            //                     ),
                            //                   ],
                            //                 ),
                            //                 Row(
                            //                   mainAxisAlignment:
                            //                       MainAxisAlignment.spaceEvenly,
                            //                   children: [
                            //                     Container(
                            //                         height: 40,
                            //                         width:
                            //                             getPhoneWidth(context) /
                            //                                     2 -
                            //                                 80,
                            //                         decoration: BoxDecoration(
                            //                             color: Colors.blueGrey,
                            //                             borderRadius:
                            //                                 BorderRadius
                            //                                     .circular(100)),
                            //                         child: TextButton(
                            //                             onPressed: () {
                            //                               Navigator.pop(
                            //                                   context);
                            //                             },
                            //                             child: Text(
                            //                               "Jo",
                            //                               style: AppStyles
                            //                                   .getHeaderNameText(
                            //                                       color: Colors
                            //                                           .white,
                            //                                       size: 17),
                            //                             ))),
                            //                     Container(
                            //                         height: 40,
                            //                         width:
                            //                             getPhoneWidth(context) /
                            //                                     2 -
                            //                                 80,
                            //                         decoration: BoxDecoration(
                            //                             color: Colors.blueGrey,
                            //                             borderRadius:
                            //                                 BorderRadius
                            //                                     .circular(100)),
                            //                         child: TextButton(
                            //                             onPressed: () {
                            //                               Navigator.pop(
                            //                                   context);
                            //                               deliverOrder(
                            //                                   order.orderNumber);
                            //                               swipeActionController
                            //                                   .closeAllOpenCell();
                            //                             },
                            //                             child: Text(
                            //                               "Po",
                            //                               style: AppStyles
                            //                                   .getHeaderNameText(
                            //                                       color: Colors
                            //                                           .white,
                            //                                       size: 17),
                            //                             ))),
                            //                   ],
                            //                 )
                            //               ],
                            //             ),
                            //             150.0);
                            //       },
                            //       content: Container(
                            //           height: 120,
                            //           decoration: BoxDecoration(
                            //               borderRadius: const BorderRadius.only(
                            //                   topRight: Radius.circular(20),
                            //                   bottomRight: Radius.circular(20)),
                            //               color: AppColors.bottomColorTwo),
                            //           child: Center(
                            //               child: Text(
                            //             "Dorezo",
                            //             style: AppStyles.getHeaderNameText(
                            //                 color: Colors.white, size: 15.0),
                            //           ))),
                            //       color: Colors.transparent),
                            //   SwipeAction(
                            //       backgroundRadius: 20,
                            //       forceAlignmentToBoundary: false,
                            //       widthSpace: 120,
                            //       closeOnTap: true,
                            //       onTap: (CompletionHandler handler) async {
                            //         showModalOne(context, StatefulBuilder(
                            //             builder: (context, setter) {
                            //           _setState = setter;
                            //           return ListView(
                            //             children: [
                            //               ListView.builder(
                            //                 physics: const ScrollPhysics(),
                            //                 shrinkWrap: true,
                            //                 itemBuilder: (context, index) {
                            //                   return Column(
                            //                     children: [
                            //                       GestureDetector(
                            //                         onTap: () {
                            //                           _setState!(() {
                            //                             hasReason = true;
                            //                             reasonType = index;
                            //                           });
                            //                         },
                            //                         child: Container(
                            //                           width: getPhoneWidth(
                            //                                   context) -
                            //                               50,
                            //                           height: 60,
                            //                           padding: const EdgeInsets
                            //                                   .symmetric(
                            //                               horizontal: 15),
                            //                           decoration: BoxDecoration(
                            //                               color: Colors
                            //                                   .transparent,
                            //                               borderRadius:
                            //                                   BorderRadius
                            //                                       .circular(10),
                            //                               border: Border.all(
                            //                                   color: Colors
                            //                                       .grey[200]!)),
                            //                           child: Row(
                            //                             mainAxisAlignment:
                            //                                 MainAxisAlignment
                            //                                     .spaceBetween,
                            //                             children: [
                            //                               SizedBox(
                            //                                   width: getPhoneWidth(
                            //                                           context) -
                            //                                       133,
                            //                                   child: Text(
                            //                                     reasons[index],
                            //                                     maxLines: 2,
                            //                                     overflow:
                            //                                         TextOverflow
                            //                                             .ellipsis,
                            //                                     style: AppStyles
                            //                                         .getHeaderNameText(
                            //                                             color: Colors
                            //                                                 .blueGrey,
                            //                                             size:
                            //                                                 16.0),
                            //                                   )),
                            //                               Container(
                            //                                 width: 25,
                            //                                 height: 25,
                            //                                 decoration: BoxDecoration(
                            //                                     borderRadius:
                            //                                         BorderRadius
                            //                                             .circular(
                            //                                                 100),
                            //                                     border: Border.all(
                            //                                         color: Colors
                            //                                             .blueGrey)),
                            //                                 child: reasonType !=
                            //                                         index
                            //                                     ? const SizedBox()
                            //                                     : Container(
                            //                                         width: 25,
                            //                                         height: 25,
                            //                                         margin: const EdgeInsets
                            //                                             .all(2),
                            //                                         decoration: BoxDecoration(
                            //                                             borderRadius:
                            //                                                 BorderRadius.circular(
                            //                                                     100),
                            //                                             color: Colors
                            //                                                 .blueGrey),
                            //                                       ),
                            //                               )
                            //                             ],
                            //                           ),
                            //                         ),
                            //                       ),
                            //                       const SizedBox(
                            //                         height: 5,
                            //                       ),
                            //                     ],
                            //                   );
                            //                 },
                            //                 itemCount: reasons.length,
                            //               ),
                            //               reasonType != reasons.length - 1
                            //                   ? const SizedBox()
                            //                   : Column(
                            //                       children: [
                            //                         const SizedBox(
                            //                           height: 10,
                            //                         ),
                            //                         TextField(
                            //                           minLines: 4,
                            //                           maxLines: 4,
                            //                           onChanged: (value) {
                            //                             if (value.isEmpty) {
                            //                               _setState!(() {
                            //                                 commented = false;
                            //                               });
                            //                             } else {
                            //                               _setState!(() {
                            //                                 commented = true;
                            //                               });
                            //                             }
                            //                           },
                            //                           controller: _comment,
                            //                           decoration:
                            //                               InputDecoration(
                            //                                   border: InputBorder
                            //                                       .none,
                            //                                   hintText:
                            //                                       "Arsyeja",
                            //                                   enabledBorder:
                            //                                       OutlineInputBorder(
                            //                                     borderRadius:
                            //                                         BorderRadius
                            //                                             .circular(
                            //                                                 15),
                            //                                     borderSide: BorderSide(
                            //                                         color: Colors
                            //                                                 .grey[
                            //                                             200]!),
                            //                                   ),
                            //                                   focusedBorder:
                            //                                       OutlineInputBorder(
                            //                                     borderRadius:
                            //                                         BorderRadius
                            //                                             .circular(
                            //                                                 15),
                            //                                     borderSide: BorderSide(
                            //                                         color: Colors
                            //                                                 .grey[
                            //                                             200]!),
                            //                                   ),
                            //                                   contentPadding:
                            //                                       const EdgeInsets
                            //                                               .symmetric(
                            //                                           horizontal:
                            //                                               15,
                            //                                           vertical:
                            //                                               10)),
                            //                         )
                            //                       ],
                            //                     ),
                            //               const SizedBox(
                            //                 height: 10,
                            //               ),
                            //               Row(
                            //                 mainAxisAlignment:
                            //                     MainAxisAlignment.spaceEvenly,
                            //                 children: [
                            //                   Container(
                            //                       height: 40,
                            //                       width:
                            //                           getPhoneWidth(context) /
                            //                                   2 -
                            //                               80,
                            //                       decoration: BoxDecoration(
                            //                           color: Colors.grey[400],
                            //                           borderRadius:
                            //                               BorderRadius.circular(
                            //                                   100)),
                            //                       child: TextButton(
                            //                           onPressed: () {
                            //                             Navigator.pop(context);
                            //                           },
                            //                           child: Text(
                            //                             "Largo",
                            //                             style: AppStyles
                            //                                 .getHeaderNameText(
                            //                                     color: Colors
                            //                                         .white,
                            //                                     size: 17),
                            //                           ))),
                            //                   Container(
                            //                       height: 40,
                            //                       width:
                            //                           getPhoneWidth(context) /
                            //                                   2 -
                            //                               80,
                            //                       decoration: BoxDecoration(
                            //                           color: commented ||
                            //                                   hasReason
                            //                               ? Colors.blueGrey
                            //                               : Colors.grey[400],
                            //                           borderRadius:
                            //                               BorderRadius.circular(
                            //                                   100)),
                            //                       child: TextButton(
                            //                           onPressed: () {
                            //                             if (!hasReason) {
                            //                               _setState!(() {
                            //                                 commented = false;
                            //                               });
                            //                             } else {
                            //                               Navigator.pop(
                            //                                   context);
                            //                               returnOrder(order.orderNumber);
                            //                               swipeActionController
                            //                                   .closeAllOpenCell();
                            //                             }
                            //                           },
                            //                           child: Text(
                            //                             "Rikthe",
                            //                             style: AppStyles
                            //                                 .getHeaderNameText(
                            //                                     color: Colors
                            //                                         .white,
                            //                                     size: 17),
                            //                           ))),
                            //                 ],
                            //               )
                            //             ],
                            //           );
                            //         }), 415.0);
                            //       },
                            //       content: Container(
                            //           height: 120,
                            //           decoration: BoxDecoration(
                            //               color: AppColors.bottomColorOne),
                            //           child: Center(
                            //               child: Text(
                            //             "E kthyer",
                            //             style: AppStyles.getHeaderNameText(
                            //                 color: Colors.white, size: 15.0),
                            //           ))),
                            //       color: Colors.transparent),
                            //   SwipeAction(
                            //       backgroundRadius: 20,
                            //       forceAlignmentToBoundary: false,
                            //       widthSpace: 100,
                            //       closeOnTap: true,
                            //       performsFirstActionWithFullSwipe: true,
                            //       onTap: (CompletionHandler handler) async {
                            //         showModalOne(context, StatefulBuilder(
                            //             builder: (context, setter) {
                            //           _setState = setter;
                            //           return ListView(
                            //             children: [
                            //               ListView.builder(
                            //                 physics: const ScrollPhysics(),
                            //                 shrinkWrap: true,
                            //                 itemBuilder: (context, index) {
                            //                   return Column(
                            //                     children: [
                            //                       GestureDetector(
                            //                         onTap: () {
                            //                           _setState!(() {
                            //                             hasReason = true;
                            //                             reasonType = index;
                            //                           });
                            //                         },
                            //                         child: Container(
                            //                           width: getPhoneWidth(
                            //                                   context) -
                            //                               50,
                            //                           height: 60,
                            //                           padding: const EdgeInsets
                            //                                   .symmetric(
                            //                               horizontal: 15),
                            //                           decoration: BoxDecoration(
                            //                               color: Colors
                            //                                   .transparent,
                            //                               borderRadius:
                            //                                   BorderRadius
                            //                                       .circular(10),
                            //                               border: Border.all(
                            //                                   color: Colors
                            //                                       .grey[200]!)),
                            //                           child: Row(
                            //                             mainAxisAlignment:
                            //                                 MainAxisAlignment
                            //                                     .spaceBetween,
                            //                             children: [
                            //                               SizedBox(
                            //                                   width: getPhoneWidth(
                            //                                           context) -
                            //                                       133,
                            //                                   child: Text(
                            //                                     reasons[index],
                            //                                     maxLines: 2,
                            //                                     overflow:
                            //                                         TextOverflow
                            //                                             .ellipsis,
                            //                                     style: AppStyles
                            //                                         .getHeaderNameText(
                            //                                             color: Colors
                            //                                                 .blueGrey,
                            //                                             size:
                            //                                                 16.0),
                            //                                   )),
                            //                               Container(
                            //                                 width: 25,
                            //                                 height: 25,
                            //                                 decoration: BoxDecoration(
                            //                                     borderRadius:
                            //                                         BorderRadius
                            //                                             .circular(
                            //                                                 100),
                            //                                     border: Border.all(
                            //                                         color: Colors
                            //                                             .blueGrey)),
                            //                                 child: reasonType !=
                            //                                         index
                            //                                     ? const SizedBox()
                            //                                     : Container(
                            //                                         width: 25,
                            //                                         height: 25,
                            //                                         margin: const EdgeInsets
                            //                                             .all(2),
                            //                                         decoration: BoxDecoration(
                            //                                             borderRadius:
                            //                                                 BorderRadius.circular(
                            //                                                     100),
                            //                                             color: Colors
                            //                                                 .blueGrey),
                            //                                       ),
                            //                               )
                            //                             ],
                            //                           ),
                            //                         ),
                            //                       ),
                            //                       const SizedBox(
                            //                         height: 5,
                            //                       ),
                            //                     ],
                            //                   );
                            //                 },
                            //                 itemCount: reasons.length,
                            //               ),
                            //               reasonType != reasons.length - 1
                            //                   ? const SizedBox()
                            //                   : Column(
                            //                       children: [
                            //                         const SizedBox(
                            //                           height: 10,
                            //                         ),
                            //                         TextField(
                            //                           minLines: 4,
                            //                           maxLines: 4,
                            //                           onChanged: (value) {
                            //                             if (value.isEmpty) {
                            //                               _setState!(() {
                            //                                 commented = false;
                            //                               });
                            //                             } else {
                            //                               _setState!(() {
                            //                                 commented = true;
                            //                               });
                            //                             }
                            //                           },
                            //                           controller: _comment,
                            //                           decoration:
                            //                               InputDecoration(
                            //                                   border: InputBorder
                            //                                       .none,
                            //                                   hintText:
                            //                                       "Arsyeja",
                            //                                   enabledBorder:
                            //                                       OutlineInputBorder(
                            //                                     borderRadius:
                            //                                         BorderRadius
                            //                                             .circular(
                            //                                                 15),
                            //                                     borderSide: BorderSide(
                            //                                         color: Colors
                            //                                                 .grey[
                            //                                             200]!),
                            //                                   ),
                            //                                   focusedBorder:
                            //                                       OutlineInputBorder(
                            //                                     borderRadius:
                            //                                         BorderRadius
                            //                                             .circular(
                            //                                                 15),
                            //                                     borderSide: BorderSide(
                            //                                         color: Colors
                            //                                                 .grey[
                            //                                             200]!),
                            //                                   ),
                            //                                   contentPadding:
                            //                                       const EdgeInsets
                            //                                               .symmetric(
                            //                                           horizontal:
                            //                                               15,
                            //                                           vertical:
                            //                                               10)),
                            //                         )
                            //                       ],
                            //                     ),
                            //               const SizedBox(
                            //                 height: 10,
                            //               ),
                            //               Row(
                            //                 mainAxisAlignment:
                            //                     MainAxisAlignment.spaceEvenly,
                            //                 children: [
                            //                   Container(
                            //                       height: 40,
                            //                       width:
                            //                           getPhoneWidth(context) /
                            //                                   2 -
                            //                               80,
                            //                       decoration: BoxDecoration(
                            //                           color: Colors.grey[400],
                            //                           borderRadius:
                            //                               BorderRadius.circular(
                            //                                   100)),
                            //                       child: TextButton(
                            //                           onPressed: () {
                            //                             Navigator.pop(context);
                            //                           },
                            //                           child: Text(
                            //                             "Largo",
                            //                             style: AppStyles
                            //                                 .getHeaderNameText(
                            //                                     color: Colors
                            //                                         .white,
                            //                                     size: 17),
                            //                           ))),
                            //                   Container(
                            //                       height: 40,
                            //                       width:
                            //                           getPhoneWidth(context) /
                            //                                   2 -
                            //                               80,
                            //                       decoration: BoxDecoration(
                            //                           color: commented ||
                            //                                   hasReason
                            //                               ? Colors.blueGrey
                            //                               : Colors.grey[400],
                            //                           borderRadius:
                            //                               BorderRadius.circular(
                            //                                   100)),
                            //                       child: TextButton(
                            //                           onPressed: () {
                            //                             if (!hasReason) {
                            //                               _setState!(() {
                            //                                 commented = false;
                            //                               });
                            //                             } else {
                            //                               Navigator.pop(
                            //                                   context);
                            //                               rejectOrder(order.orderNumber);
                            //                               swipeActionController
                            //                                   .closeAllOpenCell();
                            //                             }
                            //                           },
                            //                           child: Text(
                            //                             "Refuzo",
                            //                             style: AppStyles
                            //                                 .getHeaderNameText(
                            //                                     color: Colors
                            //                                         .white,
                            //                                     size: 17),
                            //                           ))),
                            //                 ],
                            //               )
                            //             ],
                            //           );
                            //         }), 415.0);
                            //       },
                            //       content: Container(
                            //           height: 120,
                            //           decoration: const BoxDecoration(
                            //               borderRadius: BorderRadius.only(
                            //                   topLeft: Radius.circular(20),
                            //                   bottomLeft: Radius.circular(20)),
                            //               color: Colors.red),
                            //           child: Center(
                            //               child: Text(
                            //             "Refuzo",
                            //             style: AppStyles.getHeaderNameText(
                            //                 color: Colors.white, size: 15.0),
                            //           ))),
                            //       color: Colors.transparent),
                            // ],
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 21,
                                right: 21,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  leftSideOrder(
                                    context,
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(17),
                                              bottomLeft: Radius.circular(17)),
                                          border: Border.all(
                                              color: AppColors.bottomColorOne)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Adresa: ${order.receiver!.address!}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppStyles.getHeaderNameText(
                                                color: AppColors.orderDescColor,
                                                size: 16.0),
                                          ),
                                          Text(
                                            "Nr: ${order.receiver!.phoneNumber!}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppStyles.getHeaderNameText(
                                                color: AppColors.orderDescColor,
                                                size: 16.0),
                                          ),
                                          Text(
                                            "Produkti: ${order.orderName!} sdf sdp jpo",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppStyles.getHeaderNameText(
                                                color: AppColors.orderDescColor,
                                                size: 16.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                        width:
                                            getPhoneWidth(context) * 0.3 - 25,
                                        height: 80,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(20),
                                                    bottomRight:
                                                        Radius.circular(20)),
                                            color: AppColors.bottomColorTwo),
                                        child: Center(
                                          child: Text(
                                            order.status == "pending" ? "Ne pritje":order.status == "accepted" ? "Per depo": order.status == "in_warehouse" ? "Ne depo": order.status == "delivering" ? "Ne dergese": order.status == "delivered" ? "E derguar": order.status == "rejected" ?"E anuluar": "E refuzuar",
                                            textAlign: TextAlign.center,
                                            style: AppStyles.getHeaderNameText(
                                                color: Colors.white,
                                                size: 15.0),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          right: -2,
                                          top: 10,
                                          child: SizedBox(
                                              height: 60,
                                              child: Image.asset(
                                                "assets/icons/8.png",
                                                color: Colors.white
                                                    .withOpacity(0.7),
                                              ))),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
                itemCount:
                    postmanOrders.getOnDeliveryOrders("delivering").length,
              ),
            );

  delivered(PostmanOrderProvider postmanOrders) => postmanOrders
          .isFetchingPendingOrders()
      ? ListView(
          children: const [
            Center(
                child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 1.4,
            )),
          ],
        )
      : postmanOrders.getOnDeliveryOrders("delivered").isEmpty
          ? RefreshIndicator(
              onRefresh: () async {
                getOrders();
              },
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  Center(
                      child: Text(
                    "Nuk keni asnje porosi",
                    style: AppStyles.getHeaderNameText(
                        color: Colors.white, size: 17),
                  )),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                getOrders();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  var order = postmanOrders
                      .getOnDeliveryOrders("delivered")
                      .elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: getPhoneWidth(context),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 25, bottom: 3),
                                child: SizedBox(
                                  width: getPhoneWidth(context) / 2 - 60,
                                  child: Text(
                                    order.receiver!.fullName!,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyles.getHeaderNameText(
                                        color: Colors.white,
                                        size: 17.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 25, bottom: 3),
                                child: Text(
                                  "Nr: ${order.orderNumber}",
                                  style: AppStyles.getHeaderNameText(
                                      color: Colors.white,
                                      size: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => OrderDetails(
                                      orderModel: order,
                                    )));
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: 21,
                              right: 21,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                leftSideOrder(
                                  context,
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(17),
                                            bottomLeft: Radius.circular(17)),
                                        border: Border.all(
                                            color: AppColors.bottomColorOne)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Adresa: ${order.receiver!.address!}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyles.getHeaderNameText(
                                              color: AppColors.orderDescColor,
                                              size: 16.0),
                                        ),
                                        Text(
                                          "Nr: ${order.receiver!.phoneNumber!}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyles.getHeaderNameText(
                                              color: AppColors.orderDescColor,
                                              size: 16.0),
                                        ),
                                        Text(
                                          "Produkti: ${order.orderName!} sdf sdp jpo",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyles.getHeaderNameText(
                                              color: AppColors.orderDescColor,
                                              size: 16.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      width: getPhoneWidth(context) * 0.3 - 25,
                                      height: 80,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              bottomRight: Radius.circular(20)),
                                          color: AppColors.bottomColorTwo),
                                      child: Center(
                                        child: Text(
                                          order.status == "pending" ? "Ne pritje":order.status == "accepted" ? "Per depo": order.status == "in_warehouse" ? "Ne depo": order.status == "delivering" ? "Ne dergese": order.status == "delivered" ? "E derguar": order.status == "rejected" ?"E anuluar": "E refuzuar",
                                          textAlign: TextAlign.center,
                                          style: AppStyles.getHeaderNameText(
                                              color: Colors.white, size: 15.0),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        right: -2,
                                        top: 10,
                                        child: SizedBox(
                                            height: 60,
                                            child: Image.asset(
                                              "assets/icons/8.png",
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                            ))),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
                itemCount:
                    postmanOrders.getOnDeliveryOrders("delivered").length,
              ),
            );

  canceled(PostmanOrderProvider postmanOrders) => postmanOrders
          .isFetchingPendingOrders()
      ? ListView(
          children: const [
            Center(
                child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 1.4,
            )),
          ],
        )
      : postmanOrders.getOnDeliveryOrders("rejected").isEmpty
          ? RefreshIndicator(
              onRefresh: () async {
                getOrders();
              },
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  Center(
                      child: Text(
                    "Nuk keni asnje porosi",
                    style: AppStyles.getHeaderNameText(
                        color: Colors.white, size: 17),
                  )),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                getOrders();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  var order = postmanOrders
                      .getOnDeliveryOrders("rejected")
                      .elementAt(index);
                  print("sdf");
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: getPhoneWidth(context),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 25, bottom: 3),
                                child: SizedBox(
                                  width: getPhoneWidth(context) / 2 - 60,
                                  child: Text(
                                    order.receiver!.fullName!,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyles.getHeaderNameText(
                                        color: Colors.white,
                                        size: 17.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 25, bottom: 3),
                                child: Text(
                                  "Nr: ${order.orderNumber}",
                                  style: AppStyles.getHeaderNameText(
                                      color: Colors.white,
                                      size: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => OrderDetails(
                                      orderModel: order,
                                    )));
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: 21,
                              right: 21,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                leftSideOrder(
                                  context,
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(17),
                                            bottomLeft: Radius.circular(17)),
                                        border: Border.all(
                                            color: AppColors.bottomColorOne)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Adresa: ${order.receiver!.address!}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyles.getHeaderNameText(
                                              color: AppColors.orderDescColor,
                                              size: 16.0),
                                        ),
                                        Text(
                                          "Nr: ${order.receiver!.phoneNumber!}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyles.getHeaderNameText(
                                              color: AppColors.orderDescColor,
                                              size: 16.0),
                                        ),
                                        Text(
                                          "Produkti: ${order.orderName!} sdf sdp jpo",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyles.getHeaderNameText(
                                              color: AppColors.orderDescColor,
                                              size: 16.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      width: getPhoneWidth(context) * 0.3 - 25,
                                      height: 80,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              bottomRight: Radius.circular(20)),
                                          color: AppColors.bottomColorTwo),
                                      child: Center(
                                        child: Text(
                                          order.status == "pending" ? "Ne pritje":order.status == "accepted" ? "Per depo": order.status == "in_warehouse" ? "Ne depo": order.status == "delivering" ? "Ne dergese": order.status == "delivered" ? "E derguar": order.status == "rejected" ?"E anuluar": "E refuzuar",
                                          textAlign: TextAlign.center,
                                          style: AppStyles.getHeaderNameText(
                                              color: Colors.white, size: 15.0),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        right: -2,
                                        top: 10,
                                        child: SizedBox(
                                            height: 60,
                                            child: Image.asset(
                                              "assets/icons/8.png",
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                            ))),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
                itemCount: postmanOrders.getOnDeliveryOrders("rejected").length,
              ),
            );

  returned(PostmanOrderProvider postmanOrders) => postmanOrders
          .isFetchingPendingOrders()
      ? ListView(
          children: const [
            Center(
                child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 1.4,
            )),
          ],
        )
      : postmanOrders.getOnDeliveryOrders("returned").isEmpty
          ? RefreshIndicator(
              onRefresh: () async {
                getOrders();
              },
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  Center(
                      child: Text(
                    "Nuk keni asnje porosi",
                    style: AppStyles.getHeaderNameText(
                        color: Colors.white, size: 17),
                  )),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                getOrders();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  var order = postmanOrders
                      .getOnDeliveryOrders("returned")
                      .elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: getPhoneWidth(context),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 25, bottom: 3),
                                child: SizedBox(
                                  width: getPhoneWidth(context) / 2 - 60,
                                  child: Text(
                                    order.receiver!.fullName!,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyles.getHeaderNameText(
                                        color: Colors.white,
                                        size: 17.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 25, bottom: 3),
                                child: Text(
                                  "Nr: ${order.orderNumber}",
                                  style: AppStyles.getHeaderNameText(
                                      color: Colors.white,
                                      size: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => OrderDetails(
                                      orderModel: order,
                                    )));
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: 21,
                              right: 21,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                leftSideOrder(
                                  context,
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(17),
                                            bottomLeft: Radius.circular(17)),
                                        border: Border.all(
                                            color: AppColors.bottomColorOne)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Adresa: ${order.receiver!.address!}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyles.getHeaderNameText(
                                              color: AppColors.orderDescColor,
                                              size: 16.0),
                                        ),
                                        Text(
                                          "Nr: ${order.receiver!.phoneNumber!}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyles.getHeaderNameText(
                                              color: AppColors.orderDescColor,
                                              size: 16.0),
                                        ),
                                        Text(
                                          "Produkti: ${order.orderName!} sdf sdp jpo",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyles.getHeaderNameText(
                                              color: AppColors.orderDescColor,
                                              size: 16.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      width: getPhoneWidth(context) * 0.3 - 25,
                                      height: 80,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              bottomRight: Radius.circular(20)),
                                          color: AppColors.bottomColorTwo),
                                      child: Center(
                                        child: Text(
                                          order.status == "pending" ? "Ne pritje":order.status == "accepted" ? "Per depo": order.status == "in_warehouse" ? "Ne depo": order.status == "delivering" ? "Ne dergese": order.status == "delivered" ? "E derguar": order.status == "rejected" ?"E anuluar": "E refuzuar",
                                          textAlign: TextAlign.center,
                                          style: AppStyles.getHeaderNameText(
                                              color: Colors.white, size: 15.0),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        right: -2,
                                        top: 10,
                                        child: SizedBox(
                                            height: 60,
                                            child: Image.asset(
                                              "assets/icons/8.png",
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                            ))),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
                itemCount: postmanOrders.getOnDeliveryOrders("returned").length,
              ),
            );
}
