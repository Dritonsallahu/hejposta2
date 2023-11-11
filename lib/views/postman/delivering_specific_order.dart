import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:hejposta/models/order_model.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/shortcuts/modals.dart';
import 'package:hejposta/shortcuts/order_form.dart';
import 'package:hejposta/views/business/order_details.dart';
import 'package:hejposta/views/postman/postman_drawer.dart';
import 'package:provider/provider.dart';

class DeliveringSpecificOrders extends StatefulWidget {
  List<OrderModel>? orders;
  DeliveringSpecificOrders({Key? key, this.orders}) : super(key: key);

  @override
  State<DeliveringSpecificOrders> createState() =>
      _DeliveringSpecificOrdersState();
}

class _DeliveringSpecificOrdersState extends State<DeliveringSpecificOrders> {
  List<OrderModel>? ordersFilter = [];
  PageController pageController = PageController(
    initialPage: 0,
  );
  int selectedIndex = 0;
  GlobalKey key = GlobalKey();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  ScrollController? _scrollController;
  bool _showAppbarColor = false;

  bool filerEqualized = false;
  int deliveringStep = 0;

  bool up = false;
  bool left = false;

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
    setState(() {
      ordersFilter = widget.orders;
    });
    super.initState();
  }

  filtro(emri) {
    setState(() {
      widget.orders = [];
    });

    for (int i = 0; i < ordersFilter!.length; i++) {
      if (ordersFilter![i]
          .orderNumber!
          .toUpperCase()
          .contains(emri.toUpperCase())) {
        setState(() {
          widget.orders!.add(ordersFilter![i]);
        });
      } else if (ordersFilter![i]
          .sender!
          .phoneNumber!
          .toUpperCase()
          .contains(emri.toUpperCase())) {
        setState(() {
          widget.orders!.add(ordersFilter![i]);
        });
      }else if (ordersFilter![i]
          .orderName!
          .toUpperCase()
          .contains(emri.toUpperCase())) {
        setState(() {
          widget.orders!.add(ordersFilter![i]);
        });
      }
    }
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
                    height: getPhoneHeight(context) - 65,
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
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      splashRadius: 0.01,
                                      icon: const Icon(Icons.arrow_back_ios)),
                                  SizedBox(
                                      width: 70,
                                      child: Image.asset(
                                          "assets/logos/hej-logo.png")),
                                  // Row(
                                  //   children: [
                                  //     SizedBox(
                                  //       width: 70,
                                  //       height: 26,
                                  //       child:
                                  //           Image.asset("assets/icons/3.png"),
                                  //     ),
                                  //     const SizedBox(
                                  //       width: 10,
                                  //     ),
                                  //   ],
                                  // )
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
                                  toolbarHeight: 55,
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
                                            : const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 0),
                                              ),
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
                                                  width:
                                                      getPhoneWidth(context) -
                                                          60,
                                                  child: TextField(
                                                    style: AppStyles
                                                        .getHeaderNameText(
                                                            color: Colors.white,
                                                            size: 15.0),
                                                    onChanged: (value) {
                                                      filtro(value);
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
                                                                horizontal: 20,
                                                                vertical: 7)),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  collapsedHeight: _showAppbarColor ? 55 : 65,
                                ),
                        ];
                      },
                      // list of images for scrolling
                      body: generalProvider.checkDrawerStatus() == true
                          ? const SizedBox()
                          : delivering(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  delivering() => ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        itemBuilder: (context, index) {
          var order = widget.orders![index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => OrderDetails(
                        orderModel: widget.orders![index],
                      )));
            },
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
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
                                      "Shifra: ${order.orderNumber}",
                                      style: AppStyles.getHeaderNameText(
                                          color: AppColors.orderDescColor,
                                          size: 16.0),
                                    ),
                                    Text(
                                      "Produkti: ${order.orderName}",
                                      style: AppStyles.getHeaderNameText(
                                          color: AppColors.orderDescColor,
                                          size: 16.0),
                                    ),
                                    Text(
                                      "Adresa: ${order.sender!.address}",
                                      style: AppStyles.getHeaderNameText(
                                          color: AppColors.orderDescColor,
                                          size: 16.0),
                                    ),
                                    Text(
                                      "Nr: ${order.sender!.phoneNumber}",
                                      style: AppStyles.getHeaderNameText(
                                          color: AppColors.orderDescColor,
                                          size: 16.0),
                                    ),
                                  ],
                                ),
                              ),
                              height: 95),
                          Stack(
                            children: [
                              Container(
                                width: getPhoneWidth(context) * 0.3 - 25,
                                height: 95,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20)),
                                    color: AppColors.bottomColorTwo),
                                child: Center(
                                  child: Text(
                                    "Per\nbarazim",
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
                                        color: Colors.white.withOpacity(0.7),
                                      ))),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: widget.orders!.length,
      );
}
