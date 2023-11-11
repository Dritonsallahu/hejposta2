import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hejposta/controllers/client_finance_controller.dart';
import 'package:hejposta/main.dart';
import 'package:hejposta/models/city_data.dart';
import 'package:hejposta/models/order_data.dart';
import 'package:hejposta/models/received_notification.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/connection_provider.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/providers/messages_provider.dart';
import 'package:hejposta/providers/server_provider.dart';
import 'package:hejposta/providers/user_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/views/business/business_chat.dart';
import 'package:hejposta/views/business/business_drawer.dart';
import 'package:hejposta/views/business/business_orders.dart';
import 'package:hejposta/views/business/new_order.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BusinessDashboard extends StatefulWidget {
  const BusinessDashboard({Key? key}) : super(key: key);

  @override
  State<BusinessDashboard> createState() => _BusinessDashboardState();
}

class _BusinessDashboardState extends State<BusinessDashboard> {
  DateTime _firstDate = DateTime.now();
  DateTime _lastDate = DateTime.now();
  var connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  ScrollController? _scrollController;
  int teSuksesshme = 0;
  int nePritje = 0;
  int perDepo = 0;
  int neDepo = 0;
  int neDergese = 0;
  int teRikthyera = 0;
  int teAnuluara = 0;
  double gjiroTotale = 0.0;
  int totalPorosi = 0;

  List<String> shtetet = ["Te gjitha", "Kosovë", "Shqipëri", "Maqedonia"];
  String shteti = "Te gjitha";

  var qytetetMeShumShitje = <String, int>{};
  var shitjetSipasVitit = <String, dynamic>{};


  bool fetching = false;

  void initialize(dynamic s) async {
    await flutterLocalNotificationsPlugin.initialize(s,onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }
  onDidReceiveNotificationResponse(dynamic payload) async {
    print("payload: ${payload}");
  }

  @override
  void initState() {

    StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();
    getStatistics("all", "Te gjitha");
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
            didReceiveLocalNotificationStream.add(
          ReceivedNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          ),
        );
      },
    );
    void _configureDidReceiveLocalNotificationSubject() {
      didReceiveLocalNotificationStream.stream
          .listen((ReceivedNotification receivedNotification) async {
        await showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: receivedNotification.title != null
                ? Text(receivedNotification.title!)
                : null,
            content: receivedNotification.body != null
                ? Text(receivedNotification.body!)
                : null,
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  // await Navigator.of(context).push(
                    // MaterialPageRoute<void>(
                    //   builder: (BuildContext context) =>
                    //       SecondPage(receivedNotification.payload),
                    // )
                  // );
                },
                child: const Text('Ok'),
              )
            ],
          ),
        );
      });
    }
    var initSettings = InitializationSettings(android: android, iOS: initializationSettingsDarwin);
    initialize(initSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification!;
      print("--- new message");

      if (!kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                importance: Importance.max,

                priority: Priority.max,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      var serverProvider = Provider.of<ServerProvider>(context, listen: false);
      serverProvider.initServer(context);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('0000');
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
                importance: Importance.max,

                priority: Priority.max,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });
    super.initState();
  }

  void onDidReceiveLocalNotification(a,b,c,d){

  }

  List<CityData> cityStats = [];
  List<OrderData> yearStats = [];
  List<OrderData> data = [];

  getStatistics(type, state) {
    setState(() {
      gjiroTotale = 0.0;
      teAnuluara = 0;
      teSuksesshme = 0;
      totalPorosi = 0;
      nePritje = 0;
      perDepo = 0;
      neDepo = 0;
      neDergese = 0;
      teRikthyera = 0;
      data = [];
      yearStats = [];
      cityStats = [];
      qytetetMeShumShitje = <String, int>{};
      shitjetSipasVitit = <String, dynamic>{};
      fetching = true;
    });
    ClientFinanceController clientFinanceController = ClientFinanceController();
    clientFinanceController
        .getStatistics(context, _firstDate, _lastDate, type, state)
        .then((value) {
      if (value.isNotEmpty) {
        for (var element in value) {
          setState(() {
            totalPorosi++;
          });
          if (element.status == "delivered") {
            setState(() {
              gjiroTotale += (element.price - element.offer['price']);
              teSuksesshme++;
            });
            // if (element.barazimiAdministrat == true &&
            //     element.barazimiKlient == false) {
            //   perBarazim += (element.price - element.offer['price']);
            // }
            var elementDate = DateTime.parse(element.updatedAt!);

            qytetetMeShumShitje[element.receiver!.city!] =
                (qytetetMeShumShitje[element.receiver!.city!] ?? 0) + 1;
            shitjetSipasVitit[getMonthName(elementDate, context)!] =
                (shitjetSipasVitit[getMonthName(elementDate, context)] ?? 0) +
                    1;
          } else if (element.status == "rejected" ||
              element.status == "delivered_to_client") {
            setState(() {
              teAnuluara++;
            });
          } else if (element.status == "pending") {
            setState(() {
              nePritje++;
            });
          } else if (element.status == "accepted") {
            setState(() {
              perDepo++;
            });
          } else if (element.status == "delivering") {
            setState(() {
              neDergese++;
            });
          } else if (element.status == "in_warehouse") {
            setState(() {
              neDepo++;
            });
          } else if (element.status == "returned") {
            setState(() {
              teRikthyera++;
            });
          }
        }
        qytetetMeShumShitje.forEach((key, value) {
          setState(() {
            cityStats.add(CityData(key, value));
          });
        });
        shitjetSipasVitit.forEach((key, value) {
          yearStats.add(OrderData(key, value));
        });
      }
    }).whenComplete(() {
      setState(() {
        fetching = false;
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
  Widget build(BuildContext context) {
    var messagesProvider = Provider.of<MessagesProvider>(context);
    var serverProvider = Provider.of<ServerProvider>(context);
    var generalProvider = Provider.of<GeneralProvider>(context, listen: true);
    var user = Provider.of<UserProvider>(context, listen: true);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.bottomColorOne,
      drawer: const BusinessDrawer(),
      drawerScrimColor: Colors.transparent,
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      onDrawerChanged: (status) {
        generalProvider.changeDrawerStatus(status);
        setState(() {});
      },
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).viewPadding.top,
              decoration: BoxDecoration(color: AppColors.appBarColor),
            ),
            Stack(
              children: [
                Positioned(
                    child: SizedBox(
                  height: getPhoneHeight(context),
                  child: Image.asset(
                    "assets/icons/map-icon.png",
                    color: AppColors.mapColorSecond,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                )),
                SizedBox(
                  height: getPhoneHeight(context) -
                      MediaQuery.of(context).viewPadding.top,
                  child: NestedScrollView(
                    key: UniqueKey(),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: 70,
                                    child: Image.asset(
                                        "assets/logos/hej-logo.png")),
                                Row(
                                  children: [
                                    SizedBox(
                                        width: 50,
                                        height: 26,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                                child: IconButton(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 3),
                                                    onPressed: () {
                                                      var serverProvider =
                                                          Provider.of<
                                                                  ServerProvider>(
                                                              context,
                                                              listen: false);
                                                      Navigator.of(context)
                                                          .push(MaterialPageRoute(
                                                              builder: (_) =>
                                                                  const BusinessChat()))
                                                          .then((value) {
                                                        serverProvider
                                                            .leaveRoom(
                                                                context,
                                                                user
                                                                    .getUser()!
                                                                    .user
                                                                    .id);
                                                      });
                                                      messagesProvider
                                                          .readMessages();
                                                    },
                                                    icon: Stack(
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        const Icon(Icons.sms),
                                                        messagesProvider
                                                                    .unreadMessages ==
                                                                0
                                                            ? const SizedBox()
                                                            : Positioned(
                                                                top: -10,
                                                                right: -10,
                                                                child:
                                                                    Container(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          5,
                                                                      vertical:
                                                                          2),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            100),
                                                                    color: AppColors
                                                                        .bottomColorOne,
                                                                  ),
                                                                  child: Text(
                                                                    messagesProvider
                                                                        .unreadMessages
                                                                        .toString(),
                                                                    style: AppStyles.getHeaderNameText(
                                                                        size:
                                                                            14.0,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                )),
                                                        serverProvider
                                                                    .socketConnectionType ==
                                                                SocketConnectionType
                                                                    .connecting
                                                            ? const Positioned(
                                                                right: -5,
                                                                top: -5,
                                                                child:
                                                                    SizedBox(
                                                                  width: 10,
                                                                  height: 10,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        1.4,
                                                                  ),
                                                                )) : serverProvider
                                                            .socketConnectionType ==
                                                            SocketConnectionType
                                                                .failed || serverProvider
                                                            .socketConnectionType ==
                                                            SocketConnectionType
                                                                .disconnected ? const Positioned(
                                                            right: -5,
                                                            top: -5,
                                                            child:
                                                            SizedBox(
                                                              width: 10,
                                                              height: 10,
                                                              child: Icon(Icons.close,size: 15,),
                                                            ))
                                                            : const SizedBox()
                                                      ],
                                                    )))
                                          ],
                                        )),
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
                                ),
                              ],
                            ),
                          ),
                          collapsedHeight: 50,
                        ),
                      ];
                    },
                    body: generalProvider.checkDrawerStatus() == true
                        ? const SizedBox()
                        : RefreshIndicator(
                            onRefresh: () async {
                              getStatistics("all", shteti);
                            },
                            child: ListView(
                              padding: const EdgeInsets.only(
                                  left: 0, right: 0, top: 0),
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 25),
                                  child: Divider(
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            shteti = "Kosovë";
                                          });
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width:
                                                  getPhoneWidth(context) / 3 -
                                                      20,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(10),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                10)),
                                                border: Border.all(
                                                  color: shteti == "Kosovë" ||
                                                          shteti == "Te gjitha"
                                                      ? Colors.transparent
                                                      : Colors.white,
                                                ),
                                                color: shteti == "Kosovë" ||
                                                        shteti == "Te gjitha"
                                                    ? Colors.white
                                                    : Colors.transparent,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Kosove",
                                                  style: AppStyles
                                                      .getHeaderNameText(
                                                          color: shteti ==
                                                                      "Kosovë" ||
                                                                  shteti ==
                                                                      "Te gjitha"
                                                              ? Colors.black
                                                              : Colors.white,
                                                          size: 14.5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            shteti = "Shqipëri";
                                          });
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width:
                                                  getPhoneWidth(context) / 3 -
                                                      20,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: shteti == "Shqipëri" ||
                                                          shteti == "Te gjitha"
                                                      ? Colors.transparent
                                                      : Colors.white,
                                                ),
                                                color: shteti == "Shqipëri" ||
                                                        shteti == "Te gjitha"
                                                    ? Colors.white
                                                    : Colors.transparent,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Shqiperi",
                                                  style: AppStyles
                                                      .getHeaderNameText(
                                                          color: shteti ==
                                                                      "Shqipëri" ||
                                                                  shteti ==
                                                                      "Te gjitha"
                                                              ? Colors.black
                                                              : Colors.white,
                                                          size: 14.5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            shteti = "Maqedonia";
                                          });
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width:
                                                  getPhoneWidth(context) / 3 -
                                                      20,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        bottomRight:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(
                                                                10)),
                                                border: Border.all(
                                                  color: shteti ==
                                                              "Maqedonia" ||
                                                          shteti == "Te gjitha"
                                                      ? Colors.transparent
                                                      : Colors.white,
                                                ),
                                                color: shteti == "Maqedonia" ||
                                                        shteti == "Te gjitha"
                                                    ? Colors.white
                                                    : Colors.transparent,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Maqedoni",
                                                  style: AppStyles.getHeaderNameText(
                                                      color: shteti ==
                                                                  "Maqedonia" ||
                                                              shteti ==
                                                                  "Te gjitha"
                                                          ? Colors.black
                                                          : Colors.white,
                                                      size: 14.5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return SizedBox(
                                                  width: getPhoneWidth(context),
                                                  height: 250,
                                                  child: CupertinoDatePicker(
                                                    onDateTimeChanged: (date) {
                                                      setState(() {
                                                        _firstDate = date;
                                                      });
                                                    },
                                                    initialDateTime:
                                                        DateTime.now(),
                                                    minimumYear: 2020,
                                                    maximumYear: 2100,
                                                    minimumDate:
                                                        DateTime(2020, 01, 01),
                                                    maximumDate:
                                                        DateTime(2100, 01, 01),
                                                    mode:
                                                        CupertinoDatePickerMode
                                                            .date,
                                                  ),
                                                );
                                              });
                                        },
                                        child: Container(
                                          width:
                                              getPhoneWidth(context) / 3 - 20,
                                          height: 40,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft:
                                                    Radius.circular(10)),
                                            color: Colors.white,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Prej",
                                                style:
                                                    AppStyles.getHeaderNameText(
                                                        color: Colors.black,
                                                        size: 11.0),
                                              ),
                                              Text(
                                                DateFormat("yyyy-MM-dd")
                                                    .format(_firstDate),
                                                style:
                                                    AppStyles.getHeaderNameText(
                                                        color: Colors.black,
                                                        size: 14.5),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return SizedBox(
                                                  width: getPhoneWidth(context),
                                                  height: 250,
                                                  child: CupertinoDatePicker(
                                                    onDateTimeChanged: (date) {
                                                      setState(() {
                                                        _lastDate = date;
                                                      });
                                                    },
                                                    initialDateTime:
                                                        DateTime.now(),
                                                    minimumYear: 2020,
                                                    maximumYear: 2100,
                                                    minimumDate:
                                                        DateTime(2020, 01, 01),
                                                    maximumDate:
                                                        DateTime(2100, 01, 01),
                                                    mode:
                                                        CupertinoDatePickerMode
                                                            .date,
                                                  ),
                                                );
                                              });
                                        },
                                        child: Container(
                                          width:
                                              getPhoneWidth(context) / 3 - 20,
                                          height: 40,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Deri",
                                                style:
                                                    AppStyles.getHeaderNameText(
                                                        color: Colors.black,
                                                        size: 11.0),
                                              ),
                                              Text(
                                                DateFormat("yyyy-MM-dd")
                                                    .format(_lastDate),
                                                style:
                                                    AppStyles.getHeaderNameText(
                                                        color: Colors.black,
                                                        size: 14.5),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: getPhoneWidth(context) / 3 - 20,
                                        height: 40,
                                        child: GestureDetector(
                                          onTap: () {
                                            getStatistics("specifike", shteti);
                                          },
                                          child: Container(
                                            height: 45,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10)),
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Filtro",
                                                style:
                                                    AppStyles.getHeaderNameText(
                                                        color: Colors.black,
                                                        size: 15.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 25),
                                  child: Divider(color: Colors.white),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: getPhoneWidth(context) / 2 - 28,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              shteti = shtetet[0];
                                            });
                                            getStatistics("all", shteti);
                                          },
                                          child: Container(
                                            height: 40,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(20),
                                              ),
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Shfaq te gjitha",
                                                style:
                                                    AppStyles.getHeaderNameText(
                                                        color: Colors.black,
                                                        size: 15.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: getPhoneWidth(context) / 2 - 28,
                                        child: GestureDetector(
                                          onTap: () {
                                            getStatistics("all", shteti);
                                          },
                                          child: Container(
                                            height: 40,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(20),
                                              ),
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Sipas shtetit",
                                                style:
                                                    AppStyles.getHeaderNameText(
                                                        color: Colors.black,
                                                        size: 15.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 25),
                                  child: Divider(
                                    color: Colors.white,
                                  ),
                                ),
                                !fetching
                                    ? const SizedBox()
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: LinearProgressIndicator(
                                            minHeight: 2,
                                            color: AppColors.bottomColorTwo),
                                      ),
                                fetching
                                    ? const SizedBox()
                                    : Center(
                                        child: Text(
                                        "Total ${totalPorosi} porosi",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.white, size: 14.0),
                                      )),
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            width:
                                                getPhoneWidth(context) / 2 - 40,
                                            height: 85,
                                            decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                    colors: [
                                                      Color(0xffffc734),
                                                      Color(0xffffdf8d),
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    stops: [
                                                      0.65,
                                                      0.83,
                                                    ],
                                                    transform:
                                                        GradientRotation(6.9)),
                                                borderRadius:
                                                    BorderRadius.circular(18)),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Gjiro",
                                                  style: AppStyles
                                                      .getHeaderNameText(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          size: 16.0),
                                                ),
                                                Text(
                                                  "${gjiroTotale.toStringAsFixed(2)}€",
                                                  style: AppStyles
                                                      .getHeaderNameText(
                                                          color: Colors.white,
                                                          size: 21.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                              right: 10,
                                              top: 25,
                                              child: SizedBox(
                                                  width: 30,
                                                  child: Image.asset(
                                                      "assets/icons/10.png"))),
                                        ],
                                      ),
                                      Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          BusinessOrders(
                                                            type: "delivering",
                                                            state: shteti,
                                                            from: _firstDate,
                                                            to: _lastDate,
                                                          )));
                                            },
                                            child: Container(
                                              width:
                                                  getPhoneWidth(context) / 2 -
                                                      40,
                                              height: 85,
                                              decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                          colors: [
                                                            Color(0xff00ab4f),
                                                            Color(0xff6fcf9b),
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                          stops: [
                                                            0.65,
                                                            0.83,
                                                          ],
                                                          transform:
                                                              GradientRotation(
                                                                  6.9)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18)),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Ne dergese",
                                                    style: AppStyles
                                                        .getHeaderNameText(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            size: 16.0),
                                                  ),
                                                  Text(
                                                    "$neDergese",
                                                    style: AppStyles
                                                        .getHeaderNameText(
                                                            color: Colors.white,
                                                            size: 21.0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Positioned(
                                          //     right: 10,
                                          //     top: 28,
                                          //     child: SizedBox(
                                          //         width: 35,
                                          //         child: Image.asset(
                                          //             "assets/icons/17.png"))),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          BusinessOrders(
                                                            type: "pending",
                                                            state: shteti,
                                                            from: _firstDate,
                                                            to: _lastDate,
                                                          )));
                                            },
                                            child: Container(
                                              width:
                                                  getPhoneWidth(context) / 2 -
                                                      40,
                                              height: 85,
                                              decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                          colors: [
                                                            Color(0xff23aac5),
                                                            Color(0xffc1efef),
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                          stops: [
                                                            0.65,
                                                            0.83,
                                                          ],
                                                          transform:
                                                              GradientRotation(
                                                                  6.9)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18)),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Ne pritje",
                                                    style: AppStyles
                                                        .getHeaderNameText(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            size: 15.0),
                                                  ),
                                                  Text(
                                                    "$nePritje",
                                                    style: AppStyles
                                                        .getHeaderNameText(
                                                            color: Colors.white,
                                                            size: 23.0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          BusinessOrders(
                                                            type: "accepted",
                                                            state: shteti,
                                                            from: _firstDate,
                                                            to: _lastDate,
                                                          )));
                                            },
                                            child: Container(
                                              width:
                                                  getPhoneWidth(context) / 2 -
                                                      40,
                                              height: 85,
                                              decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                          colors: [
                                                            Color(0xff059d74),
                                                            Color(0xffcad7d3),
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                          stops: [
                                                            0.65,
                                                            0.83,
                                                          ],
                                                          transform:
                                                              GradientRotation(
                                                                  6.9)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18)),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Per depo",
                                                    style: AppStyles
                                                        .getHeaderNameText(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            size: 15.0),
                                                  ),
                                                  Text(
                                                    "$perDepo",
                                                    style: AppStyles
                                                        .getHeaderNameText(
                                                            color: Colors.white,
                                                            size: 23.0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          BusinessOrders(
                                                            type:
                                                                "in_warehouse",
                                                            state: shteti,
                                                            from: _firstDate,
                                                            to: _lastDate,
                                                          )));
                                            },
                                            child: Container(
                                              width:
                                                  getPhoneWidth(context) / 2 -
                                                      40,
                                              height: 85,
                                              decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                          colors: [
                                                            Color(0xffb6680d),
                                                            Color(0xffa19a96),
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                          stops: [
                                                            0.65,
                                                            0.83,
                                                          ],
                                                          transform:
                                                              GradientRotation(
                                                                  6.9)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18)),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Ne depo",
                                                    style: AppStyles
                                                        .getHeaderNameText(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            size: 15.0),
                                                  ),
                                                  Text(
                                                    "$neDepo",
                                                    style: AppStyles
                                                        .getHeaderNameText(
                                                            color: Colors.white,
                                                            size: 23.0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          BusinessOrders(
                                                            type: "returned",
                                                            state: shteti,
                                                            from: _firstDate,
                                                            to: _lastDate,
                                                          )));
                                            },
                                            child: Container(
                                              width:
                                                  getPhoneWidth(context) / 2 -
                                                      40,
                                              height: 85,
                                              decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                          colors: [
                                                            Color(0xff83cc13),
                                                            Color(0xffeaeaea),
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                          stops: [
                                                            0.65,
                                                            0.83,
                                                          ],
                                                          transform:
                                                              GradientRotation(
                                                                  6.9)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18)),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Te rikthyera",
                                                    style: AppStyles
                                                        .getHeaderNameText(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            size: 15.0),
                                                  ),
                                                  Text(
                                                    "$teRikthyera",
                                                    style: AppStyles
                                                        .getHeaderNameText(
                                                            color: Colors.white,
                                                            size: 23.0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          BusinessOrders(
                                                            type: "delivered",
                                                            state: shteti,
                                                            from: _firstDate,
                                                            to: _lastDate,
                                                          )));
                                            },
                                            child: Container(
                                              width:
                                                  getPhoneWidth(context) / 2 -
                                                      40,
                                              height: 85,
                                              decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                          colors: [
                                                            Color(0xff381e63),
                                                            Color(0xff8f81a8),
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                          stops: [
                                                            0.65,
                                                            0.83,
                                                          ],
                                                          transform:
                                                              GradientRotation(
                                                                  6.9)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18)),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Dergesa te suksesshme",
                                                    style: AppStyles
                                                        .getHeaderNameText(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            size: 13.0),
                                                  ),
                                                  Text(
                                                    "$teSuksesshme",
                                                    style: AppStyles
                                                        .getHeaderNameText(
                                                            color: Colors.white,
                                                            size: 23.0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                              right: 10,
                                              top: 25,
                                              child: SizedBox(
                                                  width: 35,
                                                  child: Image.asset(
                                                    "assets/icons/16.png",
                                                    color: Colors.white,
                                                  ))),
                                        ],
                                      ),
                                      Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          BusinessOrders(
                                                            type: "rejected",
                                                            state: shteti,
                                                            from: _firstDate,
                                                            to: _lastDate,
                                                          )));
                                            },
                                            child: Container(
                                              width:
                                                  getPhoneWidth(context) / 2 -
                                                      40,
                                              height: 85,
                                              decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                          colors: [
                                                            Color(0xffff3d5e),
                                                            Color(0xffff93a5),
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                          stops: [
                                                            0.65,
                                                            0.83,
                                                          ],
                                                          transform:
                                                              GradientRotation(
                                                                  6.9)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18)),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Anulime",
                                                    style: AppStyles
                                                        .getHeaderNameText(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            size: 13.0),
                                                  ),
                                                  Text(
                                                    "$teAnuluara",
                                                    style: AppStyles
                                                        .getHeaderNameText(
                                                            color: Colors.white,
                                                            size: 23.0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                              right: 10,
                                              top: 25,
                                              child: SizedBox(
                                                  width: 30,
                                                  child: Image.asset(
                                                    "assets/icons/15.png",
                                                    color: Colors.white,
                                                  ))),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: getPhoneWidth(context),
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Column(children: [
                                      //Initialize the chart widget
                                      Container(
                                        color: Colors.white.withOpacity(0.8),
                                        child: SfCartesianChart(
                                            primaryXAxis: CategoryAxis(
                                              title: AxisTitle(text: ""),
                                            ),
                                            // Chart title
                                            title: ChartTitle(
                                                text:
                                                    'Porosite me sukses pergjate vitit 2023'),
                                            // Enable legend
                                            legend: Legend(isVisible: false),
                                            // Enable tooltip
                                            tooltipBehavior:
                                                TooltipBehavior(enable: true),
                                            series: <CartesianSeries>[
                                              ColumnSeries<OrderData, String>(
                                                  dataSource: yearStats,
                                                  color:
                                                      AppColors.bottomColorTwo,
                                                  xValueMapper:
                                                      (OrderData year, _) =>
                                                          year.month,
                                                  yValueMapper:
                                                      (OrderData year, _) =>
                                                          year.sales,
                                                  name: 'Shitjet',
                                                  // Enable data label
                                                  dataLabelSettings:
                                                      const DataLabelSettings(
                                                          isVisible: true))
                                            ]),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        color: Colors.white.withOpacity(0.8),
                                        child: SfCartesianChart(
                                            primaryXAxis: CategoryAxis(
                                              title: AxisTitle(text: ""),
                                            ),
                                            // Chart title
                                            title: ChartTitle(
                                                text: 'Shitjet sipas qyteteve'),
                                            // Enable legend
                                            legend: Legend(isVisible: false),
                                            // Enable tooltip
                                            tooltipBehavior:
                                                TooltipBehavior(enable: true),
                                            series: <CartesianSeries>[
                                              ColumnSeries<CityData, String>(
                                                  dataSource: cityStats,
                                                  color:
                                                      AppColors.bottomColorTwo,
                                                  xValueMapper:
                                                      (CityData city, _) =>
                                                          city.city,
                                                  yValueMapper:
                                                      (CityData city, _) =>
                                                          city.sales,
                                                  name: 'Shitjet',
                                                  // Enable data label
                                                  dataLabelSettings:
                                                      const DataLabelSettings(
                                                          isVisible: true))
                                            ]),
                                      ),
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
                Positioned(
                  bottom: 95,
                  right: 15,
                  child: FloatingActionButton(
                    isExtended: true,
                    backgroundColor: AppColors.bottomColorTwo,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const NewOrder())).then((value) {
                        getStatistics("all", "Te gjitha");
                      });
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
