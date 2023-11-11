import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:flutter_swipe_action_cell/core/controller.dart';
import 'package:hejposta/controllers/city_controller.dart';
import 'package:hejposta/controllers/client_orders_controller.dart';
import 'package:hejposta/controllers/offer_controller.dart';
import 'package:hejposta/main.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/client_order_provider.dart';
import 'package:hejposta/providers/connection_provider.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/providers/server_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/shortcuts/modals.dart';
import 'package:hejposta/shortcuts/order_form.dart';
import 'package:hejposta/views/business/business_drawer.dart';
import 'package:hejposta/views/business/edit_order.dart';
import 'package:hejposta/views/business/order_details.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BusinessOrders extends StatefulWidget {
    String? type;
    String? state;
    DateTime? from;
    DateTime? to;
    BusinessOrders({super.key, required this.type, required this.state,this.from,this.to});

  @override
  State<BusinessOrders> createState() => _BusinessOrdersState();
}

class _BusinessOrdersState extends State<BusinessOrders> with SingleTickerProviderStateMixin{
  SwipeActionController swipeActionController = SwipeActionController();
  TextEditingController kerkoPorosine = TextEditingController();
  TabController? _tabController;

  var  connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  UniqueKey key = UniqueKey();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  ScrollController? _scrollController;
  bool _showAppbarColor = false;

  bool updating  = false;
  bool success  = false;
  bool failed  = false;

  String statusText = "";
  String orderStatus = "pending";

  List<String> statuses = [
    'pending',
    'accepted',
    'in_warehouse',
    'delivering',
    'delivered',
    'rejected',
    'returned',
    'deleted',
  ];

  getOrders() {
    ClientOrdersController clientOrdersController = ClientOrdersController();
    clientOrdersController.getOrders(context).whenComplete(() {});
  }

  getOrdersBasedOnStatus(status) {
    ClientOrdersController clientOrdersController = ClientOrdersController();
    clientOrdersController.getOrdersByStatus(context, status);
  }

  getQytetet(){
    CityController cityController = CityController();
    cityController.getQytetet(context);
  }

  getOffers(){
    OfferController offerController = OfferController();
    offerController.getOffers(context);
  }

  @override
  void initState()   {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      if (_scrollController!.offset <= 10) {
        setState(() {
          _showAppbarColor = false;
        });
      } else {
        setState(() {
          _showAppbarColor = true;
        });
      }
    });
    _tabController = TabController(length: 3, vsync: this);
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      var serverProvider = Provider.of<ServerProvider>(context,listen: false);
      serverProvider.initServer(context);
    });
    getOrders();
    getQytetet();
    getOffers();





    super.initState();
  }


  deleteOrder(orderNumber){
    setState(() {
      updating = true;
    });
    ClientOrdersController clientOrdersController = ClientOrdersController();
    clientOrdersController.deleteOrder(context, orderNumber).then((value) {
      if(value == "success"){
        setState(() {
          success == true;
        });
        Future.delayed(const Duration(milliseconds: 800)).then((value) {
          setState(() {
            success == false;
          });
        });
      }
      else {
        setState(() {
          failed == true;
        });
        Future.delayed(const Duration(milliseconds: 800)).then((value) {
          setState(() {
            failed == false;
          });
        });
      }
    }).whenComplete(() {
      setState((){
        updating = false;
      });
    });
  }


// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    var conn = Provider.of<ConnectionProvider>(context, listen: false);
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      if (result.name == "wifi" || result.name == "mobile") {
        conn.setConnectionStatus(ConnectionType.connected);
      } else {
        conn.setConnectionStatus(ConnectionType.disconnected);
      }
    } on PlatformException {
      return ;
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
    var conn = Provider.of<ConnectionProvider>(context, listen: false);
    result = await _connectivity.checkConnectivity();
    if (result.name == "wifi" || result.name == "mobile") {
      conn.setConnectionStatus(ConnectionType.connected);
    } else {
      conn.setConnectionStatus(ConnectionType.disconnected);
    }
    setState(() {
      connectionStatus = result;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var orderProvider = Provider.of<ClientOrderProvider>(context, listen: true);
    var conn = Provider.of<ConnectionProvider>(context);
    var generalProvider = Provider.of<GeneralProvider>(context, listen: true);


    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.bottomColorTwo,
      drawer: const BusinessDrawer(),
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
              color: AppColors.mapColorFirst,
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
                    height: getPhoneHeight(context) - MediaQuery.of(context).viewPadding.top,
                    child: NestedScrollView(
                        key: key,
                        controller: _scrollController,
                        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                          return [

                             SliverAppBar(
                                    pinned: true,
                                    primary: false,
                                    expandedHeight: 0,
                                    foregroundColor: Colors.red,
                                    toolbarHeight: 54,
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
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 30,
                                                child: IconButton(padding: const EdgeInsets.all(0),onPressed: (){
                                                  Navigator.pop(context);
                                                }, icon: const Icon(Icons.arrow_back,size: 25,color: Colors.white,)),
                                              ),
                                              Container(
                                                width: getPhoneWidth(context) - 88,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(20),
                                                    border: Border.all(
                                                        color: Colors.white)),
                                                child: Row(
                                                  children: [

                                                    Container(

                                                        width:
                                                            getPhoneWidth(context) -
                                                                95,
                                                        child: TextField(
                                                          controller: kerkoPorosine,
                                                          style: AppStyles
                                                              .getHeaderNameText(
                                                              color: Colors.white,
                                                              size: 15.0),
                                                          onChanged: (value){
                                                            orderProvider.filtro(kerkoPorosine.text);
                                                          },
                                                          decoration: InputDecoration(
                                                              hintText: "Kerko",
                                                              hintStyle: AppStyles
                                                                  .getHeaderNameText(
                                                                      color: Colors.white,
                                                                      size: 15.0),
                                                              border:
                                                                  InputBorder.none,
                                                              isDense: true,
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal: 20,
                                                                      vertical: 7)),
                                                        )),

                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    collapsedHeight: 55,
                                  ),

                          ];
                        },
                        // list of images for scrolling
                        body:  SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height:  getPhoneHeight(context)  - 160,
                                child:    RefreshIndicator(
                                  onRefresh: () async {
                                    getOrders();
                                  },
                                  child: orderProvider.isFetchingPendingOrders()
                                      ? ListView(
                                    children: const [
                                      Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 1.4,
                                          )),
                                    ],
                                  )
                                      :     ListView.builder(
                                    padding: const EdgeInsets.all(0),
                                    itemBuilder: (context, index) {
                                      var order = orderProvider
                                          .getOrdersByState(widget.state,widget.type,widget.from!,widget.to)!
                                          .elementAt(index);
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 21,
                                                right: 21,
                                                bottom: 7),
                                            child:Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width:
                                                  getPhoneWidth(context),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            left:10,
                                                            bottom: 3),
                                                        child: SizedBox(

                                                          child: Text(
                                                            DateFormat("yyyy-MM-dd  HH:mm").format(DateTime.parse(order.createdAt!)).toString(),
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: AppStyles.getHeaderNameText(
                                                                color: Colors
                                                                    .white,
                                                                size: 14.0,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              right: 15,
                                                              bottom: 0),
                                                          height: 17,
                                                          child: Text(order.orderNumber!,style: AppStyles.getHeaderNameText(color: Colors.white,size: 15.0),)
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SwipeActionCell(
                                                  controller: swipeActionController,
                                                  key: ObjectKey(index),
                                                  backgroundColor: Colors.transparent,
                                                  trailingActions: [
                                                    SwipeAction(
                                                        backgroundRadius: 20,
                                                        forceAlignmentToBoundary: false,
                                                        widthSpace: 120,
                                                        closeOnTap: true,
                                                        onTap: (CompletionHandler handler) async {
                                                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => EditOrder(orderModel: order))).then((value) {
                                                            getOrders();
                                                          });
                                                        },
                                                        content: Container(
                                                            height: 120,
                                                            decoration: BoxDecoration(
                                                                borderRadius: const BorderRadius.only(
                                                                    topRight: Radius.circular(20),
                                                                    bottomRight: Radius.circular(20)),
                                                                color: AppColors.bottomColorTwo),
                                                            child: Center(
                                                                child: Text(
                                                                  "Edito",
                                                                  style: AppStyles.getHeaderNameText(
                                                                      color: Colors.white, size: 15.0),
                                                                ))),
                                                        color: Colors.transparent),
                                                    SwipeAction(
                                                        backgroundRadius: 20,
                                                        forceAlignmentToBoundary: false,
                                                        widthSpace: order.status != "pending" ? 0: 120,
                                                        closeOnTap: true,
                                                        onTap: (CompletionHandler handler) async {
                                                          showModalOne(
                                                              context,
                                                              Column(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      Text(
                                                                        "Konfirmo fshirjen e porosise",
                                                                        style:
                                                                        AppStyles.getHeaderNameText(
                                                                            color: Colors
                                                                                .blueGrey[800],
                                                                            size: 20),
                                                                      ),

                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment.spaceEvenly,
                                                                    children: [
                                                                      Container(
                                                                          height: 40,
                                                                          width:
                                                                          getPhoneWidth(context) /
                                                                              2 -
                                                                              80,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.blueGrey,
                                                                              borderRadius:
                                                                              BorderRadius.circular(
                                                                                  100)),
                                                                          child: TextButton(
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                                swipeActionController
                                                                                    .closeAllOpenCell();
                                                                              },
                                                                              child: Text(
                                                                                "Jo",
                                                                                style: AppStyles
                                                                                    .getHeaderNameText(
                                                                                    color: Colors
                                                                                        .white,
                                                                                    size: 17),
                                                                              ))),
                                                                      Container(
                                                                          height: 40,
                                                                          width:
                                                                          getPhoneWidth(context) /
                                                                              2 -
                                                                              80,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.blueGrey,
                                                                              borderRadius:
                                                                              BorderRadius.circular(
                                                                                  100)),
                                                                          child: TextButton(
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                                deleteOrder(order.id);
                                                                                swipeActionController
                                                                                    .closeAllOpenCell();
                                                                              },
                                                                              child: Text(
                                                                                "Po",
                                                                                style: AppStyles
                                                                                    .getHeaderNameText(
                                                                                    color: Colors
                                                                                        .white,
                                                                                    size: 17),
                                                                              ))),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                              130.0);


                                                        },
                                                        content:order.status != "pending" ? const SizedBox(): Container(
                                                            height: 120,
                                                            decoration: const BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius.circular(20),
                                                                    bottomLeft: Radius.circular(20)),
                                                                color: Colors.red),
                                                            child: Center(
                                                                child: Text(
                                                                  "Fshij",
                                                                  style: AppStyles.getHeaderNameText(
                                                                      color: Colors.white, size: 15.0),
                                                                ))),
                                                        color: Colors.transparent),
                                                  ],
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      leftSideOrder(
                                                          context,
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.of(
                                                                  context)
                                                                  .push(MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      OrderDetails(orderModel: order,)));
                                                            },
                                                            child: Container(
                                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                                              decoration: BoxDecoration(
                                                                  borderRadius: const BorderRadius
                                                                      .only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                          17),
                                                                      bottomLeft:
                                                                      Radius.circular(
                                                                          17)),
                                                                  border: Border.all(
                                                                      color: AppColors
                                                                          .bottomColorOne)),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    "Klienti: ${order
                                                                        .receiver!.fullName} ",maxLines: 1,overflow: TextOverflow.ellipsis,
                                                                    style: AppStyles.getHeaderNameText(
                                                                        color: Colors
                                                                            .grey[
                                                                        800],
                                                                        size:
                                                                        15.0),
                                                                  ),
                                                                  Text(
                                                                    "Produkti: ${order
                                                                        .orderName!}",maxLines: 1,overflow: TextOverflow.ellipsis,
                                                                    style: AppStyles.getHeaderNameText(
                                                                        color: Colors
                                                                            .grey[
                                                                        800],
                                                                        size:
                                                                        15.0),
                                                                  ),
                                                                  Text(
                                                                    "Adresa: ${order
                                                                        .receiver!
                                                                        .address!}",maxLines: 2,overflow: TextOverflow.ellipsis,
                                                                    style: AppStyles.getHeaderNameText(
                                                                        color: Colors
                                                                            .grey[
                                                                        800],
                                                                        size:
                                                                        15.0),
                                                                  ),

                                                                ],
                                                              ),
                                                            ),
                                                          ),height: 85
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      OrderDetails(orderModel: order,)));
                                                        },
                                                        child: Container(
                                                          color: Colors
                                                              .transparent,
                                                          child: Stack(
                                                            children: [
                                                              Container(
                                                                width: getPhoneWidth(
                                                                    context) *
                                                                    0.3 -
                                                                    25,
                                                                height: 85,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: const BorderRadius
                                                                        .only(
                                                                        topRight:
                                                                        Radius.circular(
                                                                            20),
                                                                        bottomRight:
                                                                        Radius.circular(
                                                                            20)),
                                                                    color: AppColors
                                                                        .bottomColorOne),
                                                                child: Center(
                                                                  child: Text(
                                                                    widget.type == "pending" ? "Ne pritje":widget.type == "accepted" ? "Per depo": widget.type == "in_warehouse" ? "Ne depo": widget.type == "delivering" ? "Ne dergese": widget.type == "delivered" ? "E derguar": widget.type == "rejected" ?"E anuluar": "E refuzuar",
                                                                    textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                    style: AppStyles.getHeaderNameText(
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                        15.0),
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
                                                                        color: Colors
                                                                            .white
                                                                            .withOpacity(0.7),
                                                                      ))),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    itemCount:   orderProvider
                                        .getOrdersByState(widget.state,widget.type,widget.from!,widget.to)!
                                        .length,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ))
                    ,
                  ),
                ],
              ),
            ),
          ),
          AnimatedPositioned(  
              duration: const Duration(milliseconds: 400),
              bottom:
                  conn.connectionType != ConnectionType.disconnected ? -80 : 10,
              width: getPhoneWidth(context),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info,
                        color: Colors.blueGrey,
                      ),
                      Text(
                        " Nuk jeni i kyqur ne internet!",
                        style: AppStyles.getHeaderNameText(
                            color: Colors.blueGrey, size: 17),
                      ),
                    ],
                  ),
                ),
              )),
          AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              bottom: !updating ? -80 : 10,
              width: getPhoneWidth(context),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [

                      Text(
                        "Ju lutem prisni pak...",
                        style: AppStyles.getHeaderNameText(
                            color: Colors.blueGrey, size: 17),
                      ),
                    ],
                  ),
                ),
              )),
          AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              bottom: !success ? -80 : 10,
              width: getPhoneWidth(context),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                        "Perditesimi u perfundoi me sukses",
                        style: AppStyles.getHeaderNameText(
                            color: Colors.blueGrey, size: 16),
                      ),
                      Icon(Icons.check_circle,color: AppColors.bottomColorTwo,)
                    ],
                  ),
                ),
              )),
          AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              bottom: !failed ? -80 : 10,
              width: getPhoneWidth(context),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                        "Perditesimi deshtoi",
                        style: AppStyles.getHeaderNameText(
                            color: Colors.blueGrey, size: 16),
                      ),
                      const Icon(Icons.sms_failed,color: Colors.blueGrey,)
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
