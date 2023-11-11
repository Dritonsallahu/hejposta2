import 'package:flutter/material.dart';
import 'package:hejposta/controllers/client_orders_controller.dart';
import 'package:hejposta/models/order_history_model.dart';
import 'package:hejposta/models/order_model.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/views/order_comments.dart';
import 'package:hejposta/views/postman/postman_drawer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetails extends StatefulWidget {
  final OrderModel? orderModel;
  const OrderDetails({Key? key, this.orderModel}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  PageController pageController = PageController(initialPage: 0);
  int selectedIndex = 0;
  GlobalKey key = GlobalKey();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  OrderHistoryModel? orderHistoryModel;
  bool fetchingHistory = false;

  bool filerEqualized = false;
  int deliveringStep = 0;

  bool up = false;
  bool left = false;

  @override
  void initState() {
    orderHistory(widget.orderModel!.id);
    super.initState();
  }

  orderHistory(id) {
    setState(() {
      fetchingHistory = true;
    });
    ClientOrdersController clientOrdersController = ClientOrdersController();
    clientOrdersController.getOrderHistory(context, id).then((value) {
      if (value == "Something went wrong") {
        setState(() {
          orderHistoryModel = null;
        });
      } else if (value == "empty") {
        setState(() {
          orderHistoryModel = null;
        });
      } else {
        setState(() {
          orderHistoryModel = value;
        });
      }
    }).whenComplete(() {
      setState(() {
        fetchingHistory = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var generalProvider = Provider.of<GeneralProvider>(context, listen: true);
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
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).viewPadding.top,
            decoration: BoxDecoration(color: AppColors.appBarColor),
          ),
          Stack(
            children: [
              AnimatedPositioned(
                  duration: const Duration(
                    seconds: 20,
                  ),
                  top: !up ? -65 : 65,
                  left: -165,
                  child: SizedBox(
                    height: getPhoneHeight(context),
                    child: Image.asset(
                      "assets/icons/map-icon.png",
                      color: AppColors.mapColorSecond,
                      filterQuality: FilterQuality.high,
                    ),
                  )),
              SizedBox(
                width: getPhoneWidth(context),
                height: getPhoneHeight(context) - 65,
                child: ListView(
                  padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(left: 25, right: 13, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                checkIsAndroid(context)
                                    ? Icons.arrow_back
                                    : Icons.arrow_back_ios,
                                color: Colors.white,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left:10),
                            child: Text(
                              "NR:${widget.orderModel!.orderNumber}",
                              style: AppStyles.getHeaderNameText(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  size: 20.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (widget.orderModel!.status ==
                                            "delivering" ||
                                        widget.orderModel!.status ==
                                            "delivered") {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (_) => OrderComments(
                                                    orderModel:
                                                        widget.orderModel,
                                                  )));
                                    }
                                  },
                                  child: (widget.orderModel!.status ==
                                              "delivering" ||
                                          widget.orderModel!.status ==
                                              "delivered")
                                      ? Container(
                                          width: 85,
                                          decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.white)),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Komento\nporosine",
                                                style:
                                                    AppStyles.getHeaderNameText(
                                                        color: Colors.white,
                                                        size: 15.0),
                                              )
                                            ],
                                          ))
                                      : const SizedBox(
                                          width: 50,
                                        ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 3, vertical: 3),
                            width: getPhoneWidth(context),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                            child: Stack(
                              children: [
                                Container(
                                  width: getPhoneWidth(context),
                                  height: getPhoneHeight(context) - 160,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: AppColors.bottomColorTwo,
                                          width: 1.4)),
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      orderHistory(widget.orderModel!.id);
                                    },
                                    child: ListView(
                                      padding: const EdgeInsets.only(top: 0),
                                      children: [
                                        Text("Te dhenat e porosise"),
                                        SizedBox(height: 5,),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width:
                                                  getPhoneWidth(context) / 2 -
                                                      50,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Emri i produktit:",
                                                    style: AppStyles
                                                        .getHeaderNameText(
                                                            color: Colors.green,
                                                            size: 13.0),
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    "${widget.orderModel!.orderName}",
                                                    style: AppStyles
                                                        .getHeaderNameText(
                                                            color:
                                                                Colors.blueGrey,
                                                            size: 15.0),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Emri i derguesit:",
                                                      style: AppStyles
                                                          .getHeaderNameText(
                                                              color: Colors.green,
                                                              size: 13.0),
                                                    ),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    Text(
                                                      "${widget.orderModel!.sender!.username}",
                                                      style: AppStyles
                                                          .getHeaderNameText(
                                                              color:
                                                                  Colors.blueGrey,
                                                              size: 15.0),
                                                    ),
                                                  ],
                                                ),

                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              color:Colors.transparent,
                                              child: SizedBox(
                                                width:
                                                getPhoneWidth(context) / 2 -
                                                    50,
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Qmimi i porosise:",
                                                      style: AppStyles
                                                          .getHeaderNameText(
                                                          color: Colors.green,
                                                          size: 13.0),
                                                    ),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    Text(
                                                      "${widget.orderModel!.price}€",
                                                      style: AppStyles
                                                          .getHeaderNameText(
                                                          color:
                                                          Colors.blueGrey,
                                                          size: 15.0),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width:
                                              getPhoneWidth(context) / 2 -
                                                  50,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Sasia:",
                                                    style: AppStyles
                                                        .getHeaderNameText(
                                                        color: Colors.green,
                                                        size: 13.0),
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    "${widget.orderModel!.qty}",
                                                    style: AppStyles
                                                        .getHeaderNameText(
                                                        color:
                                                        Colors.blueGrey,
                                                        size: 15.0),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),

                                        Divider(),
                                        Text("Te dhenat e pranuesit"),

                                        const SizedBox(
                                          height: 9,
                                        ),
                                        Row(
                                          crossAxisAlignment:CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width:
                                                  getPhoneWidth(context) / 2 - 50,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Emri i pranuesit:",
                                                    style:
                                                        AppStyles.getHeaderNameText(
                                                            color: Colors.green,
                                                            size: 13.0),
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    "${widget.orderModel!.receiver!.fullName}",
                                                    style:
                                                        AppStyles.getHeaderNameText(
                                                            color: Colors.blueGrey,
                                                            size: 15.0),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            GestureDetector(
                                              onTap: () async {
                                                final Uri launchUri = Uri(
                                                  scheme: 'tel',
                                                  path: widget.orderModel!
                                                      .receiver!.phoneNumber,
                                                );
                                                print(launchUri);
                                                await launchUrl(launchUri);
                                              },
                                              child: Container(
                                                color: Colors.transparent,
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Nr tel. i pranuesit",
                                                      style: AppStyles
                                                          .getHeaderNameText(
                                                          color: Colors.green,
                                                          size: 13.0),
                                                    ),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    Text(
                                                      "${widget.orderModel!.receiver!.phoneNumber}",
                                                      style: AppStyles
                                                          .getHeaderNameText(
                                                          color:
                                                          Colors.blueGrey,
                                                          size: 15.0),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width:
                                              getPhoneWidth(context) / 2 -
                                                  50,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Shteti pranuesit:",
                                                    style: AppStyles
                                                        .getHeaderNameText(
                                                        color: Colors.green,
                                                        size: 13.0),
                                                  ), 
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    "${widget.orderModel!.receiver!.state}",
                                                    style: AppStyles
                                                        .getHeaderNameText(
                                                        color:
                                                        Colors.blueGrey,
                                                        size: 15.0),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Qyteti pranuesit",
                                                  style: AppStyles
                                                      .getHeaderNameText(
                                                      color: Colors.green,
                                                      size: 13.0),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  "${widget.orderModel!.receiver!.city}",
                                                  style: AppStyles
                                                      .getHeaderNameText(
                                                      color:
                                                      Colors.blueGrey,
                                                      size: 15.0),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "Adresa pranuesit",
                                          style: AppStyles.getHeaderNameText(
                                              color: Colors.green, size: 13.0),
                                        ),
                                        Text(
                                          "${widget.orderModel!.receiver!.address}",
                                          style: AppStyles.getHeaderNameText(
                                              color: Colors.blueGrey,
                                              size: 15.0),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),

                                        Divider(),

                                        Text("Te dhenat e derguesit"),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                final Uri launchUri = Uri(
                                                  scheme: 'tel',
                                                  path: widget.orderModel!
                                                      .sender!.phoneNumber,
                                                );
                                                await launchUrl(launchUri);
                                              },
                                              child: Container(
                                                color: Colors.transparent,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [

                                                    SizedBox(
                                                      width:
                                                      getPhoneWidth(context) / 2 - 50,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Emri i derguesit:",
                                                            style:
                                                            AppStyles.getHeaderNameText(
                                                                color: Colors.green,
                                                                size: 13.0),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          Text(
                                                            "${widget.orderModel!.sender!.businessName}",
                                                            style:
                                                            AppStyles.getHeaderNameText(
                                                                color: Colors.blueGrey,
                                                                size: 15.0),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          getPhoneWidth(context) /
                                                                  2 -
                                                              50,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Nr tel. i derguesit",
                                                            style: AppStyles
                                                                .getHeaderNameText(
                                                                    color: Colors
                                                                        .green,
                                                                    size: 13.0),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          Text(
                                                            "${widget.orderModel!.sender!.phoneNumber}",
                                                            style: AppStyles
                                                                .getHeaderNameText(
                                                                    color: Colors
                                                                        .blueGrey,
                                                                    size: 15.0),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        Row(
                                          children: [
                                            SizedBox(
                                              width:
                                                  getPhoneWidth(context) / 2 -
                                                      50,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Shteti derguesit:",
                                                    style: AppStyles
                                                        .getHeaderNameText(
                                                            color: Colors.green,
                                                            size: 13.0),
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    "${widget.orderModel!.sender!.state}",
                                                    style: AppStyles
                                                        .getHeaderNameText(
                                                            color:
                                                                Colors.blueGrey,
                                                            size: 15.0),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Qyteti derguesit",
                                                  style: AppStyles
                                                      .getHeaderNameText(
                                                          color: Colors.green,
                                                          size: 13.0),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  "${widget.orderModel!.sender!.city}",
                                                  style: AppStyles
                                                      .getHeaderNameText(
                                                          color:
                                                              Colors.blueGrey,
                                                          size: 15.0),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                        Text(
                                          "Adresa derguesit",
                                          style: AppStyles.getHeaderNameText(
                                              color: Colors.green, size: 13.0),
                                        ),

                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "${widget.orderModel!.sender!.address}",
                                          style: AppStyles.getHeaderNameText(
                                              color: Colors.blueGrey,
                                              size: 15.0),
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        
                                        Text(
                                          "Pershkrimi",
                                          style: AppStyles.getHeaderNameText(
                                              color: Colors.green, size: 13.0),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "${widget.orderModel!.comment}",
                                          style: AppStyles.getHeaderNameText(
                                              color: Colors.blueGrey,
                                              size: 15.0),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Historiku i porosise",
                                              style:
                                                  AppStyles.getHeaderNameText(
                                                      color: Colors.grey[800],
                                                      size: 20),
                                            ),
                                          ],
                                        ),
                                        fetchingHistory
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                color: Colors.black,
                                                strokeWidth: 1.4,
                                              ))
                                            : orderHistoryModel == null
                                                ? const Text(
                                                    "Historiku nuk mund te shfaqet per kete porosi.\nJu lutem kontaktoni"
                                                    " administraten e postes per informacione shtese.")
                                                : ListView.builder(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 25),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Column(
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                width: 18,
                                                                height: 18,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            100),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .blue,
                                                                        width:
                                                                            3)),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                    width: getPhoneWidth(
                                                                            context) -
                                                                        130,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          "${replyTextBasedOnStatus(orderHistoryModel!.updates[index]['order_status'].toString())}",
                                                                          style: AppStyles.getHeaderNameText(
                                                                              color: AppColors.bottomColorTwo,
                                                                              size: 16.0),
                                                                        ),

                                                                      ],
                                                                    ),
                                                                  ),

                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  SizedBox(
                                                                      width: getPhoneWidth(
                                                                              context) -
                                                                          140,
                                                                      child:
                                                                          Text(
                                                                        orderHistoryModel!
                                                                            .updates[index]['messageClient']
                                                                            .toString(),
                                                                        style: AppStyles.getHeaderNameText(
                                                                            color:
                                                                                Colors.blueGrey,
                                                                            size: 15.0),
                                                                      )),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Text(
                                                                    parseDate(orderHistoryModel!.updates[index]
                                                                    [
                                                                    'updatedAt']!),
                                                                    style: AppStyles.getHeaderNameText(
                                                                        color: Colors.blueGrey[800],
                                                                        size: 12.0),
                                                                  ),
                                                                  Container(width: getPhoneWidth(context) - 130,child: Divider(color: Colors.grey, )),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                    physics:
                                                        const ScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        orderHistoryModel!
                                                            .updates.length,
                                                  ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  replyTextBasedOnStatus(status) {
    print(status);
    if (status == "pending") {
      return "Porosia ne pritje";
    } else if (status == "accepted") {
      return "Porosia tek postieri";
    } else if (status == "in_warehouse") {
      return "Porosia ne depo";
    } else if (status == "delivering") {
      return "Porosia ne dergese";
    }else if (status == "returned") {
      return "Porosia eshte kthyer";
    }else if (status == "returning_to_warehouse") {
      return "Porosia ne kthim per depo";
    } else if (status == "delivered") {
      return "Porosia e dorezuar";
    } else {
      return "No data";
    }
  }

  parseDate(String date) {
    var parsedDate = DateFormat("yyyy-MM-dd HH:mm:ss")
        .format(DateTime.parse(date).add(Duration(hours: 2)));
    return parsedDate;
  }
}
