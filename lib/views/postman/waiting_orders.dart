import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hejposta/controllers/postman_orders_controller.dart';
import 'package:hejposta/main.dart';
import 'package:hejposta/models/order_model.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/equalization_provider.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/providers/postman_order_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/shortcuts/modals.dart';
import 'package:hejposta/shortcuts/order_form.dart';
import 'package:hejposta/views/postman/postman_drawer.dart';
import 'package:hejposta/views/postman/waiting_specific_orders.dart';
import 'package:provider/provider.dart';

class WaitingOrders extends StatefulWidget {
  const WaitingOrders({super.key});

  @override
  State<WaitingOrders> createState() => _WaitingOrdersState();
}
//$2a$08$8ki/67yJwI4ULB4S4t50CuKwtu6DSWmRn4qR5CwAeWtRnsdO8f0R2 TEST
//$2a$08$GU1nj7AYhALojOlpyJN7u.FvWOLNUkQ8ByYyGgFhcCHKRknLP6FUi REAL
class _WaitingOrdersState extends State<WaitingOrders> {
  PageController pageController = PageController(
    initialPage: 0,
  );
  ConnectivityResult connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  UniqueKey key = UniqueKey();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  ScrollController? _scrollController;
  bool _showAppbarColor = false;
  int selectedIndex = 0;
  int deliveringStep = 0;

  bool acceptedOrders = false;
  bool warehouseOrders = false;

  @override
  void initState()   {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
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
    getOrders();




    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification!;

      if (!kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                importance: Importance.high,

                priority: Priority.high,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
     if(kDebugMode){
       print('A new onMessageOpenedApp event was published!');
       print("message");
     }
    });
    super.initState();
  }

  getOrders() {
    PostmanOrdersController postmanOrdersController = PostmanOrdersController();
    postmanOrdersController.getOrders(context);
    postmanOrdersController.getOnDeliveringOrders(context);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException {
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      connectionStatus = result;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _scrollController!.dispose();
    super.dispose();
  }

  bool requesting = false;

  prano(id,isScanning) {
    var postmanOrders = Provider.of<PostmanOrderProvider>(context,listen: false);

    PostmanOrdersController postmanOrdersController = PostmanOrdersController();
    postmanOrdersController.pranoPorosine(context, id).then((value) async {
      if (value == "success") {
        setState(() {
          acceptedOrders = true;
        });
        Future.delayed(const Duration(milliseconds: 700)).then((value){
          setState(() {
            acceptedOrders = false;
          });
        });
        postmanOrders.moveOrder(id,"accepted");
        if(  postmanOrders.getOrders().length > 1){
          String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
              "#ff6666", "Largo", true, ScanMode.QR)
              .then((value) {
            return value;
          });
          if (barcodeScanRes.isNotEmpty) {
            if(barcodeScanRes != "-1"){
              scanoPorosine(barcodeScanRes, "waiting");
            }
          } else {}
        }


      }
      else if (value == "NotFound") {
        showModalOne(
            context,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Nuk ekziston kjo porosi ne pritje",
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
      });

    });
  }

  dorezoNeDepo(id,isScanning) {
    var postmanOrders = Provider.of<PostmanOrderProvider>(context,listen: false);
    setState(() {
      requesting = true;
    });
    PostmanOrdersController postmanOrdersController = PostmanOrdersController();
    postmanOrdersController.dorzoNeDepoPorosine(context, id).then((value) async{
      if (value == "success") {
        postmanOrders.moveOrder(id,"in_warehouse");
        setState(() {
          warehouseOrders = true;
        });
        Future.delayed(const Duration(milliseconds: 700)).then((value){
          setState(() {
            warehouseOrders = false;
          });
        });
        if( postmanOrders.getOrders().length > 1){
          String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Largo", true, ScanMode.QR)
              .then((value) {
            return value;
          });
          if (barcodeScanRes.isNotEmpty) {
            scanoPorosine(barcodeScanRes,"accepted");
          } else {}
        }
      }
      else if(value == "NotFound"){
        showMessageModal(context, "Kjo porosi nuk ekziston", 20);
      }
      else {
        showMessageModal(context, value, 20);
      }
    }).whenComplete(() {
      setState(() {
        requesting = false;
      });
      postmanOrders.stopFetchingPendingOrders();
    });
  }

  scanoPorosine(id,text) {
    showModalOne(
        context,
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  "Konfirmo ${text == "waiting" ? "pranimin" : "shkarkimin"} e porosise",
                  style: AppStyles.getHeaderNameText(
                      color: Colors.blueGrey[800], size: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Numri porosise: $id",
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
                          if (deliveringStep == 0) {
                            prano(id,true);
                          } else if (deliveringStep == 1) {
                            dorezoNeDepo(id,true);
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

  @override
  Widget build(BuildContext context) {
    var generalProvider = Provider.of<GeneralProvider>(context);
    var postmanOrders = Provider.of<PostmanOrderProvider>(context);
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
          Positioned(
              child: SizedBox(
            width: getPhoneWidth(context),
            height: getPhoneHeight(context),
            child: Image.asset(
              "assets/images/map-icon.png",
              color: AppColors.mapColorSecond,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
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
                    height: getPhoneHeight(context) - 60,
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
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // GestureDetector(
                                        //   onTap: (){
                                        //     Navigator.of(context).push(MaterialPageRoute(builder: (_) => PostmanMessages()));
                                        //   },
                                        //   child: Container(
                                        //     color: Colors.transparent,
                                        //     width: 40,
                                        //     height: 26,
                                        //     child: Icon(Icons.comment),
                                        //   ),
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
                                                      context, "wait",
                                                      npritje: postmanOrders
                                                          .porosiNePritje()
                                                          .toString(),
                                                      ndergese: postmanOrders
                                                          .getOnDeliveryOrders(
                                                            "delivering",
                                                          )
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
                                                  Container(
                                                      decoration: const BoxDecoration(
                                                          border: Border(
                                                              right: BorderSide(
                                                                  color: Colors
                                                                      .white))),
                                                      width: getPhoneWidth(
                                                                  context) /
                                                              3 -
                                                          50,
                                                      child: TextField(
                                                        onChanged: (value) {
                                                          postmanOrders
                                                              .filter(value);
                                                        },
                                                        decoration: InputDecoration(
                                                            hintText: "Kerko",
                                                            hintStyle: AppStyles
                                                                .getHeaderNameText(
                                                                    color: Colors
                                                                        .white,
                                                                    size: 15.0),
                                                            border: InputBorder
                                                                .none,
                                                            isDense: true,
                                                            contentPadding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        7)),
                                                      )),
                                                  Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          pageController.animateToPage(
                                                              0,
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          400),
                                                              curve: Curves
                                                                  .linear);

                                                          setState(() {
                                                            selectedIndex = 0;
                                                            deliveringStep = 0;
                                                          });
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      15),
                                                          child: Center(
                                                            child: Text(
                                                              "Ne pritje\n(${postmanOrders
                                                                  .porosiNePritje()
                                                                  .toString()})",textAlign: TextAlign.center,
                                                              style: AppStyles.getHeaderNameText(
                                                                  color: deliveringStep ==
                                                                          0
                                                                      ? Colors
                                                                          .blueGrey
                                                                      : Colors
                                                                          .white,
                                                                  size: 14.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          pageController.animateToPage(
                                                              1,
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          400),
                                                              curve: Curves
                                                                  .linear);

                                                          setState(() {
                                                            selectedIndex = 1;
                                                            deliveringStep = 1;
                                                          });
                                                        },
                                                        child: Container(
                                                          height: 33,
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      15),
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
                                                              "Per depo\n(${postmanOrders
                                                                  .porosiPerDepo()
                                                                  .toString()})",textAlign: TextAlign.center,
                                                              style: AppStyles.getHeaderNameText(
                                                                  color: deliveringStep ==
                                                                          1
                                                                      ? Colors
                                                                          .blueGrey
                                                                      : Colors
                                                                          .white,
                                                                  size: 14.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          pageController.animateToPage(
                                                              2,
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          400),
                                                              curve: Curves
                                                                  .linear);

                                                          setState(() {
                                                            selectedIndex = 2;
                                                            deliveringStep = 2;
                                                          });
                                                        },
                                                        child: Container(
                                                          height: 33,
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      15),
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
                                                              "Ne depo\n(${postmanOrders
                                                                  .porosiNeDepo()
                                                                  .toString()})",textAlign: TextAlign.center,
                                                              style: AppStyles.getHeaderNameText(
                                                                  color: deliveringStep ==
                                                                          2
                                                                      ? Colors
                                                                          .blueGrey
                                                                      : Colors
                                                                          .white,
                                                                  size: 14.0),
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
                                    collapsedHeight:
                                        _showAppbarColor ? 65 : 105,
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
                                  onWaitingOrders(postmanOrders),
                                  acceptedByPostmanOrders(postmanOrders),
                                  onWarehouseOrders(postmanOrders),
                                ],
                              )),
                  ),
                ],
              ),
            ),
          ),
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
        ],
      ),
    );
  }

  onWaitingOrders(PostmanOrderProvider postmanOrders) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            getOrders();
          },
          child: postmanOrders.isFetchingPendingOrders()
              ? ListView(
                  children: const [
                    Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 1.4,
                    )),
                  ],
                )
              : postmanOrders.getSpecificOrders("pending").isEmpty
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
                  : ListView.builder(
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        String senderId = postmanOrders
                            .groupBySender("pending")
                            .keys
                            .elementAt(index);
                        List<OrderModel> orders =
                            postmanOrders.groupBySender("pending")[senderId]!;
                        String business = orders.first.sender!.businessName!;
                        String senderAddress = orders.first.sender!.address!;
                        String phoneNumber = orders.first.sender!.phoneNumber!;
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (_) => WaitingSpecificOrders(
                                          orders: orders,
                                          status: "waiting",
                                        )))
                                .then((value) {
                              getOrders();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 21, right: 21, bottom: 7),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: getPhoneWidth(context),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 3),
                                        child: SizedBox(
                                          width: getPhoneWidth(context) - 100,
                                          child: Text(
                                            "$business",
                                            maxLines: 1,
                                            style: AppStyles.getHeaderNameText(
                                                color: Colors.white,
                                                size: 17.0,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    leftSideOrder(
                                        context,
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.only(
                                                  topLeft: Radius.circular(17),
                                                  bottomLeft: Radius.circular(17)),
                                              border: Border.all(
                                                  color: AppColors.bottomColorOne)),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Adresa: $senderAddress",textAlign: TextAlign.center,
                                                style: AppStyles.getHeaderNameText(
                                                    color: Colors.grey[800],
                                                    size: 16.0),
                                              ),
                                              Text(
                                                "Tel: $phoneNumber",
                                                style: AppStyles.getHeaderNameText(
                                                    color: Colors.grey[800],
                                                    size: 16.0),
                                              )
                                            ],
                                          ),
                                        ),
                                        height: 90),
                                    Stack(
                                      children: [
                                        Container(
                                          width: getPhoneWidth(context) * 0.3 - 25,
                                          height: 90,
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.only(
                                                  topRight: Radius.circular(20),
                                                  bottomRight: Radius.circular(20)),
                                              color: AppColors.bottomColorTwo),
                                          child: Center(
                                            child: Text(
                                              "${orders.length} \nporosi",
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
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: postmanOrders.groupBySender("pending").length,
                    ),
        ),
        Positioned(bottom: 35,right: 25,
          child: FloatingActionButton(
            onPressed: () async {
              String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                  "#ff6666", "Largo", true, ScanMode.QR);
              if (barcodeScanRes.isNotEmpty) {
                scanoPorosine(barcodeScanRes, "waiting");
              } else {}
            },
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.qr_code_scanner_outlined,
                color: Colors.blueGrey),
          ),
        ),
      ],
    );
  }

  acceptedByPostmanOrders(postmanOrders) => Stack(
    children: [
      RefreshIndicator(
            onRefresh: () async {
              getOrders();
            },
            child: postmanOrders.isFetchingPendingOrders()
                ? ListView(
                    children: const [
                      Center(
                          child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 1.4,
                      )),
                    ],
                  )
                : postmanOrders.getSpecificOrders("accepted").isEmpty
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
                    : ListView.builder(
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (context, index) {
                          String senderId = postmanOrders
                              .groupBySender("accepted")
                              .keys
                              .elementAt(index);
                          List<OrderModel> orders =
                              postmanOrders.groupBySender("accepted")[senderId]!;
                          String business = orders.first.sender!.businessName!;
                          String senderAddress = orders.first.sender!.address!;
                          String phoneNumber = orders.first.sender!.phoneNumber!;
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (_) => WaitingSpecificOrders(
                                            orders: orders,
                                            status: "accepted",
                                          )))
                                  .then((value) {
                                getOrders();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 21, right: 21, bottom: 7),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: getPhoneWidth(context),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, bottom: 3),
                                          child: SizedBox(
                                            width: getPhoneWidth(context) / 2 - 60,
                                            child: Text(
                                              "Emri: $business",
                                              overflow: TextOverflow.ellipsis,
                                              style: AppStyles.getHeaderNameText(
                                                  color: Colors.white,
                                                  size: 17.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      leftSideOrder(
                                          context,
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(17),
                                                        bottomLeft:
                                                            Radius.circular(17)),
                                                border: Border.all(
                                                    color:
                                                        AppColors.bottomColorOne)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Adresa: $senderAddress",
                                                  style:
                                                      AppStyles.getHeaderNameText(
                                                          color: Colors.grey[800],
                                                          size: 16.0),
                                                ),
                                                Text(
                                                  "Tel: $phoneNumber",
                                                  style:
                                                      AppStyles.getHeaderNameText(
                                                          color: Colors.grey[800],
                                                          size: 16.0),
                                                )
                                              ],
                                            ),
                                          ),
                                          height: 90),
                                      Stack(
                                        children: [
                                          Container(
                                            width:
                                                getPhoneWidth(context) * 0.3 - 25,
                                            height: 90,
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
                                                "${orders.length} \nporosi",
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
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: postmanOrders.groupBySender("accepted").length,
                      ),
          ),
      Positioned(bottom: 35,right: 25,
        child: FloatingActionButton(
          onPressed: () async {
            String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                "#ff6666", "Largo", true, ScanMode.QR);
            if (barcodeScanRes.isNotEmpty) {
              scanoPorosine(barcodeScanRes, "accepted");
            } else {}
          },
          backgroundColor: Colors.grey[300],
          child: const Icon(Icons.qr_code_scanner_outlined,
              color: Colors.blueGrey),
        ),
      ),
      AnimatedPositioned(
          bottom: acceptedOrders ? 0 : -65,
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
                    "Porosia u pranua me sukses",
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
          bottom: warehouseOrders ? 0 : -65,
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
                    "Porosia u pranua me sukses",
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
  );
  onWarehouseOrders(postmanOrders) => RefreshIndicator(
        onRefresh: () async {
          getOrders();
        },
        child: postmanOrders.isFetchingPendingOrders()
            ? ListView(
                children: const [
                  Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 1.4,
                  )),
                ],
              )
            : postmanOrders.getSpecificOrders("in_warehouse").isEmpty
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
                : ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      String senderId = postmanOrders
                          .groupBySender("in_warehouse")
                          .keys
                          .elementAt(index);
                      List<OrderModel> orders = postmanOrders
                          .groupBySender("in_warehouse")[senderId]!;
                      String business = orders.first.sender!.businessName!;
                      String senderAddress = orders.first.sender!.address!;
                      String phoneNumber = orders.first.sender!.phoneNumber!;
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (_) => WaitingSpecificOrders(
                                        orders: orders,
                                        status: "in_warehouse",
                                      )))
                              .then((value) {
                            getOrders();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 21, right: 21, bottom: 7),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: getPhoneWidth(context),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, bottom: 3),
                                      child: SizedBox(
                                        width: getPhoneWidth(context) / 2 - 60,
                                        child: Text(
                                          "Emri: $business",
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyles.getHeaderNameText(
                                              color: Colors.white,
                                              size: 17.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  leftSideOrder(
                                      context,
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(17),
                                                    bottomLeft:
                                                        Radius.circular(17)),
                                            border: Border.all(
                                                color:
                                                    AppColors.bottomColorOne)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Adresa: $senderAddress",
                                              style:
                                                  AppStyles.getHeaderNameText(
                                                      color: Colors.grey[800],
                                                      size: 16.0),
                                            ),
                                            Text(
                                              "Tel: $phoneNumber",
                                              style:
                                                  AppStyles.getHeaderNameText(
                                                      color: Colors.grey[800],
                                                      size: 16.0),
                                            )
                                          ],
                                        ),
                                      ),
                                      height: 90),
                                  Stack(
                                    children: [
                                      Container(
                                        width:
                                            getPhoneWidth(context) * 0.3 - 25,
                                        height: 90,
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
                                            "${orders.length} \nporosi",
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
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount:
                        postmanOrders.groupBySender("in_warehouse").length,
                  ),
      );
}
