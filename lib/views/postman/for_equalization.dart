import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:flutter_swipe_action_cell/core/controller.dart';
import 'package:hejposta/controllers/equalization_controller.dart';
import 'package:hejposta/controllers/postman_orders_controller.dart';
import 'package:hejposta/models/order_model.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/equalization_provider.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/providers/postman_order_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/shortcuts/modals.dart';
import 'package:hejposta/shortcuts/order_form.dart';
import 'package:hejposta/views/postman/delivering_specific_order.dart';
import 'package:hejposta/views/postman/postman_drawer.dart';
import 'package:provider/provider.dart';

class ForEqualization extends StatefulWidget {
  const ForEqualization({Key? key}) : super(key: key);

  @override
  State<ForEqualization> createState() => _ForEqualizationState();
}

class _ForEqualizationState extends State<ForEqualization> {
  PageController pageController = PageController(
    initialPage: 0,
  );
  SwipeActionController swipeActionController = SwipeActionController();
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
    getEqualizingOrders();
    getEqualizedOrders();
    super.initState();
  }

  getEqualizingOrders() {
    EqualizationController equalizationController = EqualizationController();
    equalizationController.getEqualization(context);
  }

  getEqualizedOrders() {
    EqualizationController equalizationController = EqualizationController();
    equalizationController.getEqualizedOrders(context);
  }

  barazo(shifraBarazimit) {
    EqualizationController equalizationController = EqualizationController();
    equalizationController
        .performEqualization(context, shifraBarazimit)
        .then((value) {
      if (value['message'] == "success") {
        showModalOne(
            context,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Klienti u barazua me sukses",
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
      else if (value['message'] == "failed") {
        showModalOne(
            context,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Barazimi me klient deshtoi, kontaktoni administratën për sqarime shtesë! ",
                      textAlign: TextAlign.center,
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
            170.0);
      } else {
        showModalOne(
            context,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Barazimi me klient deshtoi, kontaktoni administratën për sqarime shtesë! ",
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
    });
  }

  scanoPorosine(shifraBarazimit) {
    showModalOne(
        context,
        Column(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  "Konfirmo barazimin e porosise",
                  style: AppStyles.getHeaderNameText(
                      color: Colors.blueGrey[800],
                      size: 20),
                ),
                const SizedBox(
                  height: 10,
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
                    getPhoneWidth(context) / 2 - 80,
                    decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius:
                        BorderRadius.circular(100)),
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Jo",
                          style: AppStyles
                              .getHeaderNameText(
                              color: Colors.white,
                              size: 17),
                        ))),
                Container(
                    height: 40,
                    width:
                    getPhoneWidth(context) / 2 - 80,
                    decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius:
                        BorderRadius.circular(100)),
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          barazo(shifraBarazimit);
                        },
                        child: Text(
                          "Po",
                          style: AppStyles
                              .getHeaderNameText(
                              color: Colors.white,
                              size: 17),
                        ))),
              ],
            )
          ],
        ),
        150.0);
  }
  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var generalProvider = Provider.of<GeneralProvider>(context);
    var postmanOrders = Provider.of<PostmanOrderProvider>(context);
    var equalizingOrders = Provider.of<EqualizationProvier>(context);
    var equalizedOrders = Provider.of<EqualizedOrdersProvier>(context);
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

              child: SizedBox(
                height: getPhoneHeight(context),
                child: Image.asset(
                  "assets/icons/map-icon.png",
                  color: AppColors.mapColorSecond,fit: BoxFit.cover,
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
                                                      context, "equalize",
                                                      npritje: postmanOrders
                                                          .porosiNePritje()
                                                          .toString(),
                                                      ndergese: postmanOrders
                                                          .getOnDeliveryOrders(
                                                              "delivering")
                                                          .length
                                                          .toString(),
                                                      perBarazim: equalizingOrders
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
                                                Row(
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
                                                            20,
                                                        child: TextField(
                                                          onChanged: (value){
                                                            if(deliveringStep == 0){
                                                              equalizingOrders.filter(value);
                                                            }
                                                            else{
                                                              print("Sdfs");
                                                              equalizedOrders.filter(value);
                                                            }
                                                          },
                                                          decoration: InputDecoration(
                                                              hintText: "Kerko",
                                                              hintStyle: AppStyles
                                                                  .getHeaderNameText(
                                                                      color: Colors
                                                                          .white,
                                                                      size:
                                                                          15.0),
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
                                                        width: getPhoneWidth(
                                                                    context) /
                                                                3 -
                                                            20,
                                                        height: 33,
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10),
                                                        child: Center(
                                                          child: Text(
                                                            "Per barazim",
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
                                                        width: getPhoneWidth(
                                                                    context) /
                                                                3 -
                                                            20,
                                                        height: 33,
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10),
                                                        decoration:
                                                            const BoxDecoration(
                                                                border: Border(
                                                          left: BorderSide(
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                        child: Center(
                                                          child: Text(
                                                            "Te barazuara",
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
                                  perBarazim(equalizingOrders),
                                  teBarazuara(equalizedOrders),
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


  perBarazim(EqualizationProvier equalizeOrders) => Stack(
    children: [
      RefreshIndicator(
            onRefresh: () async {
              getEqualizingOrders();
            },
            child: equalizeOrders.isFetchingPendingOrders()
                ? ListView(
                    children: const [
                      Center(
                          child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 1.4,
                      )),
                    ],
                  )
                : equalizeOrders.getEqualizations().isEmpty
                    ? RefreshIndicator(
                        onRefresh: () async {
                          getEqualizingOrders();
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
                          String senderId = equalizeOrders
                              .getEqualizations()
                              .keys
                              .elementAt(index);
                          List<OrderModel> orders =
                              equalizeOrders.getEqualizations()[senderId]!;
                          String business = orders.first.sender!.businessName!;
                          String senderAddress = orders.first.sender!.address!;
                          String phoneNumber = orders.first.sender!.phoneNumber!;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 7),
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
                                            left: 25, bottom: 3),
                                        child: SizedBox(
                                          width: getPhoneWidth(context) / 2 - 60,
                                          child: Text(
                                            business,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppStyles.getHeaderNameText(
                                                color: Colors.white,
                                                size: 17.0,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 17,
                                        width: 178,
                                        child: Image.asset(
                                          "assets/images/line.png",
                                          color: Colors.white,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SwipeActionCell(
                                  key: ObjectKey(index),
                                  backgroundColor: Colors.transparent,
                                  trailingActions: [
                                    SwipeAction(
                                        backgroundRadius: 20,
                                        forceAlignmentToBoundary: false,
                                        widthSpace: 120,
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
                                                        "Konfirmo barazimin me biznes",
                                                        style: AppStyles
                                                            .getHeaderNameText(
                                                                color: Colors
                                                                    .blueGrey[800],
                                                                size: 20),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "Emri biznesit: ${business}",
                                                        style: AppStyles
                                                            .getHeaderNameText(
                                                                color: Colors
                                                                    .blueGrey[600],
                                                                size: 17),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Container(
                                                          height: 40,
                                                          width: getPhoneWidth(
                                                                      context) /
                                                                  2 -
                                                              80,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.blueGrey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100)),
                                                          child: TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
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
                                                          width: getPhoneWidth(
                                                                      context) /
                                                                  2 -
                                                              80,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.blueGrey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100)),
                                                          child: TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                                barazo(orders.first
                                                                    .equalCodeWithClient);
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
                                              150.0);
                                        },
                                        content: Container(
                                            height: 120,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        bottomLeft:
                                                            Radius.circular(20)),
                                                color: AppColors.bottomColorTwo),
                                            child: Center(
                                                child: Text(
                                              "Barazohu me\nklientin",
                                              textAlign: TextAlign.center,
                                              style: AppStyles.getHeaderNameText(
                                                  color: Colors.white, size: 15.0),
                                            ))),
                                        color: Colors.transparent),
                                  ],
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
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            DeliveringSpecificOrders(
                                                              orders: orders,
                                                            )));
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 15),
                                                decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(17),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    17)),
                                                    border: Border.all(
                                                        color: AppColors
                                                            .bottomColorOne)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Adresa: $senderAddress",
                                                      style: AppStyles
                                                          .getHeaderNameText(
                                                              color: AppColors
                                                                  .orderDescColor,
                                                              size: 16.0),
                                                    ),
                                                    Text(
                                                      "Tel: $phoneNumber",
                                                      style: AppStyles
                                                          .getHeaderNameText(
                                                              color: AppColors
                                                                  .orderDescColor,
                                                              size: 16.0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            height: 90),
                                        Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            DeliveringSpecificOrders(
                                                              orders: orders,
                                                            )));
                                              },
                                              child: Container(
                                                width:
                                                    getPhoneWidth(context) * 0.3 -
                                                        25,
                                                height: 90,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(20),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    20)),
                                                    color:
                                                        AppColors.bottomColorTwo),
                                                child: Center(
                                                  child: Text(
                                                    "${orders.length}\nporosi",
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        AppStyles.getHeaderNameText(
                                                            color: Colors.white,
                                                            size: 15.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                                right: -2,
                                                top: 10,
                                                child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                    DeliveringSpecificOrders(orders: orders,)));
                                                    },
                                                    child: SizedBox(
                                                        height: 60,
                                                        child: Image.asset(
                                                          "assets/icons/8.png",
                                                          color: Colors.white
                                                              .withOpacity(0.7),
                                                        )))),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        itemCount: equalizeOrders.getEqualizations().length,
                      ),
          ),
      Positioned(bottom: 30,right: 30,child: GestureDetector(
        onTap: () async {
          String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
              "#ff6666",
              "Largo",
              true,
              ScanMode.QR).then((value) {
            return value;
          });
          if(barcodeScanRes.isNotEmpty){
            scanoPorosine(barcodeScanRes);
          }
          else{

          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey[200],
          ),
          width: 65,height: 65,child: Icon(Icons.qr_code_2,size: 30,),
        ),
      ))
    ],
  );
  teBarazuara(EqualizedOrdersProvier equalizedOrders) => RefreshIndicator(
    onRefresh: () async {
      getEqualizedOrders();
    },
    child: equalizedOrders.isFetchingPendingOrders()
        ? ListView(
      children: const [
        Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 1.4,
            )),
      ],
    )
        : equalizedOrders.getEqualizations().isEmpty
        ? RefreshIndicator(
      onRefresh: () async {
        getEqualizedOrders();
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
            String senderId = equalizedOrders
                .getEqualizations()
                .keys
                .elementAt(index);
            List<OrderModel> orders =
            equalizedOrders.getEqualizations()[senderId]!;
            String business = orders.first.sender!.businessName!;
            String senderAddress = orders.first.sender!.address!;
            String phoneNumber = orders.first.sender!.phoneNumber!;
            String city = orders.first.sender!.city!;
            return Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: getPhoneWidth(context),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25, bottom: 3),
                          child: SizedBox(
                            width: getPhoneWidth(context) / 2 - 60,
                            child: Text(
                              business,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.getHeaderNameText(
                                  color: Colors.white,
                                  size: 17.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 17,
                          width: 178,
                          child: Image.asset(
                            "assets/images/line.png",
                            color: Colors.white,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 21,
                      right: 21,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        leftSideOrder(
                          context,
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) =>
                                        DeliveringSpecificOrders(orders: orders,)));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(17),
                                      bottomLeft: Radius.circular(17)),
                                  border: Border.all(
                                      color: AppColors.bottomColorOne)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Adress: ${senderAddress}",
                                    style: AppStyles.getHeaderNameText(
                                        color: AppColors.orderDescColor,
                                        size: 16.0),
                                  ),
                                  Text(
                                    "Tel: ${phoneNumber}",
                                    style: AppStyles.getHeaderNameText(
                                        color: AppColors.orderDescColor,
                                        size: 16.0),
                                  ),
                                  Text(
                                    "Qyteti: ${city}",
                                    style: AppStyles.getHeaderNameText(
                                        color: AppColors.orderDescColor,
                                        size: 16.0),
                                  ),
                                ],
                              ),
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
                                  "${orders.length}\nporosi",
                                  textAlign: TextAlign.center,
                                  style: AppStyles.getHeaderNameText(color: Colors.white, size: 15.0),
                                ),
                              ),
                            ),
                            Positioned(
                                right: -2,
                                top: 10,
                                child:
                                SizedBox(height: 60, child: Image.asset("assets/icons/8.png",color: Colors.white.withOpacity(0.7),))),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
          itemCount: equalizedOrders.getEqualizations().length,
        ),
  );
}
