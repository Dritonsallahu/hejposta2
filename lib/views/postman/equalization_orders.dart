import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/shortcuts/order_form.dart';
import 'package:hejposta/views/postman/postman_drawer.dart';
import 'package:provider/provider.dart';

class EqualizationSpecificOrders extends StatefulWidget {
  const EqualizationSpecificOrders({Key? key}) : super(key: key);

  @override
  State<EqualizationSpecificOrders> createState() => _EqualizationSpecificOrdersState();
}

class _EqualizationSpecificOrdersState extends State<EqualizationSpecificOrders> {
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
    super.initState();
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
                                  IconButton(onPressed: (){
                                    Navigator.of(context).pop();
                                  },splashRadius: 0.01, icon: const Icon(Icons.arrow_back_ios)),
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
                                  //       Image.asset("assets/icons/3.png"),
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
                                    padding:
                                    EdgeInsets.symmetric(
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
                                            decoration: const BoxDecoration(
                                                border: Border(
                                                    right: BorderSide(
                                                        color: Colors
                                                            .white))),
                                            width:
                                            getPhoneWidth(context) -
                                                145,
                                            child: TextField(
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
                                                      vertical:
                                                      7)),
                                            )),
                                        GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return SizedBox(
                                                    width: getPhoneWidth(
                                                        context),
                                                    height: 250,
                                                  );
                                                });
                                          },
                                          child: Container(
                                            width:
                                            getPhoneWidth(context) /
                                                4 -
                                                30,
                                            height: 33,
                                            color: Colors.transparent,
                                            child: Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 0),
                                              child: Center(
                                                child: Text(
                                                  "Zona",
                                                  style: AppStyles
                                                      .getHeaderNameText(
                                                      color: Colors
                                                          .white,
                                                      size: 14.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
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
      return Padding(
        padding: const EdgeInsets.only(bottom: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwipeActionCell(
              key: ObjectKey(index),
              backgroundColor: Colors.transparent,
              trailingActions: const [
                // SwipeAction(
                //     backgroundRadius: 20,
                //     forceAlignmentToBoundary: false,
                //     widthSpace: 120,
                //     closeOnTap: true,
                //     onTap: (CompletionHandler handler) async {
                //       setState(() {});
                //     },
                //     content: Container(
                //         height: 120,
                //         decoration: BoxDecoration(
                //             borderRadius: const BorderRadius.only(
                //                 topRight: Radius.circular(20),
                //                 bottomRight: Radius.circular(20)),
                //             color: AppColors.bottomColorTwo),
                //         child: Center(
                //             child: Text(
                //               "E dorezuar",
                //               style: AppStyles.getHeaderNameText(
                //                   color: Colors.white, size: 15.0),
                //             ))),
                //     color: Colors.transparent),
                // SwipeAction(
                //     backgroundRadius: 20,
                //     forceAlignmentToBoundary: false,
                //     widthSpace: 120,
                //     closeOnTap: true,
                //     onTap: (CompletionHandler handler) async {
                //       setState(() {});
                //     },
                //     content: Container(
                //         height: 120,
                //         decoration:
                //         BoxDecoration(color: AppColors.bottomColorOne),
                //         child: Center(
                //             child: Text(
                //               "E kthyer",
                //               style: AppStyles.getHeaderNameText(
                //                   color: Colors.white, size: 15.0),
                //             ))),
                //     color: Colors.transparent),
                // SwipeAction(
                //     backgroundRadius: 20,
                //     forceAlignmentToBoundary: false,
                //     widthSpace: 100,
                //     closeOnTap: true,
                //     performsFirstActionWithFullSwipe: true,
                //     onTap: (CompletionHandler handler) async {
                //       setState(() {});
                //     },
                //     content: Container(
                //         height: 120,
                //         decoration: const BoxDecoration(
                //             borderRadius: BorderRadius.only(
                //                 topLeft: Radius.circular(20),
                //                 bottomLeft: Radius.circular(20)),
                //             color: Colors.red),
                //         child: Center(
                //             child: Text(
                //               "E refuzuar",
                //               style: AppStyles.getHeaderNameText(
                //                   color: Colors.white, size: 15.0),
                //             ))),
                //     color: Colors.transparent),
              ],
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
                        padding: const EdgeInsets.symmetric(horizontal: 15),
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
                              "Rruga:  Sali Ceku, Ferizaj",
                              style: AppStyles.getHeaderNameText(
                                  color: AppColors.orderDescColor,
                                  size: 16.0),
                            ),
                            Text(
                              "+38349822332",
                              style: AppStyles.getHeaderNameText(
                                  color: AppColors.orderDescColor,
                                  size: 16.0),
                            ),
                            Text(
                              "Shifra: 0011244",
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
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20)),
                              color: AppColors.bottomColorTwo),
                          child: Center(
                            child: Text(
                              "E pa dorezuar",
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
              ),
            )
          ],
        ),
      );
    },
    itemCount: 20,
  );
}
