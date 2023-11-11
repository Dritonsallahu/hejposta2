import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:hejposta/controllers/postman_orders_controller.dart';
import 'package:hejposta/models/order_model.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/equalization_provider.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/providers/postman_order_provider.dart';
import 'package:hejposta/providers/user_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/shortcuts/order_form.dart';
import 'package:hejposta/views/postman/for_equalization.dart';
import 'package:hejposta/views/postman/postman_drawer.dart';
import 'package:hejposta/views/postman/waiting_specific_orders.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaitingOrders extends StatefulWidget {
  const WaitingOrders({super.key});

  @override
  State<WaitingOrders> createState() => _WaitingOrdersState();
}

class _WaitingOrdersState extends State<WaitingOrders> {
  PageController pageController = PageController(
    initialPage: 0,
  );
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  UniqueKey key = UniqueKey();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  ScrollController? _scrollController;
  bool _showAppbarColor = false;
  int selectedIndex = 0;
  int deliveringStep = 0;

  @override
  void initState() {
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
    } on PlatformException catch (e) {
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
      _connectionStatus = result;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _scrollController!.dispose();

    super.dispose();
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
                                      children: [
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
                                    toolbarHeight: _showAppbarColor ? 65 : 85,
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
                                            child: Row(
                                              children: [
                                                Container(
                                                    decoration: const BoxDecoration(
                                                        border: Border(
                                                            right: BorderSide(
                                                                color: Colors
                                                                    .white))),
                                                    width:
                                                        getPhoneWidth(context) /
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
                                                          border:
                                                              InputBorder.none,
                                                          isDense: true,
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 7)),
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
                                                            curve:
                                                                Curves.linear);

                                                        setState(() {
                                                          selectedIndex = 0;
                                                          deliveringStep = 0;
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 33,
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 15),
                                                        child: Center(
                                                          child: Text(
                                                            "Ne pritje",
                                                            style: AppStyles
                                                                .getHeaderNameText(
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
                                                            curve:
                                                                Curves.linear);

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
                                                                horizontal: 15),
                                                        decoration:
                                                            const BoxDecoration(
                                                                border: Border(
                                                          left: BorderSide(
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                        child: Center(
                                                          child: Text(
                                                            "Per depo",
                                                            style: AppStyles
                                                                .getHeaderNameText(
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
                                                            curve:
                                                                Curves.linear);

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
                                                                horizontal: 15),
                                                        decoration:
                                                            const BoxDecoration(
                                                                border: Border(
                                                          left: BorderSide(
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                        child: Center(
                                                          child: Text(
                                                            "Ne depo",
                                                            style: AppStyles
                                                                .getHeaderNameText(
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
                                  OnWaitingOrders(postmanOrders),
                                  AcceptedByPostmanOrders(postmanOrders),
                                  OnWarehouseOrders(postmanOrders),
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

  OnWaitingOrders(PostmanOrderProvider postmanOrders) {
    return RefreshIndicator(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Adresa: $senderAddress",
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
    );
  }

  AcceptedByPostmanOrders(postmanOrders) => RefreshIndicator(
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
                      var order = postmanOrders.getOrders()[index];
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
      );
  OnWarehouseOrders(postmanOrders) => RefreshIndicator(
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
                      var order = postmanOrders.getOrders()[index];
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
