import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hejposta/controllers/finance_controller.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/equalization_provider.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/providers/salaries_provider.dart';
import 'package:hejposta/providers/user_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/shortcuts/modals.dart';
import 'package:hejposta/views/postman/postman_drawer.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  bool fetchingStatistikat = false;
  DateTime dateTime = DateTime.now();
  double bonuset = 0.0;
  double paga = 0.0;
  double minuset = 0.0;
  double totali = 0.0;

  bool up = false;
  bool left = false;

  @override
  void initState() {
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

  getStatistikat() {
    var user = Provider.of<UserProvider>(context, listen: false);
    var bonusPrice = user.getUser()!.onSuccessDeliveryBonus;
    setState(() {
      fetchingStatistikat = true;
    });
    //{message: success, orderNubers: 1, ordersPrice: 65, expences: 21, totali: 44}
    FinanceController financeController = FinanceController();
    financeController.getStatistikat(context, dateTime).then((value) {
      print(value);
      if (value == "Connection Refused") {
        showModalOne(
            context,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Ka ndodhur nje problem!",
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
      } else if (value['message'] == "success") {
          bonuset = double.parse(value['total_earned_bonus']);
          minuset = double.parse(value['total_minus']) ;
      }
    }).whenComplete(() {
      setState(() {
        fetchingStatistikat = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var generalProvider = Provider.of<GeneralProvider>(context);
    var user = Provider.of<UserProvider>(context);
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
                          Text(
                            "Statistikat",
                            style: AppStyles.getHeaderNameText(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                size: 20.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            child: Row(
                              children: const [
                                SizedBox(
                                  width: 60,
                                  height: 26,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 8),
                      child: Container(
                        width: getPhoneWidth(context),
                        height: 50,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20)),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 22),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          width: getPhoneWidth(context),
                                          height: 250,
                                          child: CupertinoDatePicker(
                                            onDateTimeChanged: (date) {
                                              setState(() {
                                                dateTime = date;
                                              });
                                            },
                                            initialDateTime: DateTime.now(),
                                            minimumYear: 2020,
                                            maximumYear: 2100,
                                            minimumDate: DateTime(2020, 01, 01),
                                            maximumDate: DateTime(2100, 01, 01),
                                            mode: CupertinoDatePickerMode.date,
                                          ),
                                        );
                                      });
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  width: getPhoneWidth(context) - 162,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${getMonthName(dateTime, context)!}/${dateTime.year}",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.black, size: 17.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  getStatistikat();
                                },
                                child: Container(
                                  width: 90,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20)),
                                      color: AppColors.bottomColorTwo),
                                  child: Center(
                                    child: Text(
                                      "Kerko",
                                      style: AppStyles.getHeaderNameText(
                                          color: Colors.white, size: 16),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: !fetchingStatistikat ? 0 : 20,
                    ),
                    !fetchingStatistikat
                        ? SizedBox()
                        : Center(child: CircularProgressIndicator()),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: getPhoneWidth(context) / 2 - 40,
                                height: 85,
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                        colors: [
                                          Color(0xff381e63),
                                          Color(0xff8f81a8),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        stops: [
                                          0.65,
                                          0.83,
                                        ],
                                        transform: GradientRotation(6.9)),
                                    borderRadius: BorderRadius.circular(18)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "BONUSET",
                                      style: AppStyles.getHeaderNameText(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          size: 17.0),
                                    ),
                                    Text(
                                      "${bonuset.toStringAsFixed(2)}€",
                                      style: AppStyles.getHeaderNameText(
                                          color: Colors.white, size: 23.0),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                  right: 15,
                                  top: 25,
                                  child: SizedBox(
                                      width: 30,
                                      child:
                                          Image.asset("assets/icons/9.png"))),
                            ],
                          ),
                          Stack(
                            children: [
                              Container(
                                width: getPhoneWidth(context) / 2 - 40,
                                height: 85,
                                decoration: BoxDecoration(
                                    color: const Color(0xffffc734),
                                    borderRadius: BorderRadius.circular(18)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "PAGA",
                                      style: AppStyles.getHeaderNameText(
                                          color: const Color(0xff381e63),
                                          fontWeight: FontWeight.w600,
                                          size: 17.0),
                                    ),
                                    Text(
                                      "${user.getUser()!.salary}€",
                                      style: AppStyles.getHeaderNameText(
                                          color: const Color(0xff381e63),
                                          size: 23.0),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                  right: 15,
                                  top: 25,
                                  child: SizedBox(
                                      width: 30,
                                      child:
                                          Image.asset("assets/icons/10.png"))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: getPhoneWidth(context) / 2 - 40,
                                height: 85,
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                        colors: [
                                          Color(0xffff3d5e),
                                          Color(0xffff93a5),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        stops: [
                                          0.65,
                                          0.83,
                                        ],
                                        transform: GradientRotation(6.9)),
                                    borderRadius: BorderRadius.circular(18)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "MINUSET",
                                      style: AppStyles.getHeaderNameText(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          size: 17.0),
                                    ),
                                    Text(
                                      "${minuset.toStringAsFixed(2)}€",
                                      style: AppStyles.getHeaderNameText(
                                          color: Colors.white, size: 23.0),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                  right: 15,
                                  top: 25,
                                  child: SizedBox(
                                      width: 30,
                                      child:
                                          Image.asset("assets/icons/12.png"))),
                            ],
                          ),
                          Stack(
                            children: [
                              Container(
                                width: getPhoneWidth(context) / 2 - 40,
                                height: 85,
                                decoration: BoxDecoration(
                                    color: const Color(0xff4dc6a6),
                                    borderRadius: BorderRadius.circular(18)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "TOTALI",
                                      style: AppStyles.getHeaderNameText(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          size: 17.0),
                                    ),
                                    Text(
                                      "${((bonuset + user.getUser()!.salary) + minuset).toStringAsFixed(2)}€",
                                      style: AppStyles.getHeaderNameText(
                                          color: Colors.white, size: 23.0),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                  right: 15,
                                  top: 25,
                                  child: SizedBox(
                                      width: 30,
                                      child:
                                          Image.asset("assets/icons/11.png"))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 25, vertical: 20),
                    //   child: Column(
                    //     children: [
                    //       Row(
                    //         children: [
                    //           Container(
                    //             padding: const EdgeInsets.all(8.0),
                    //             decoration: BoxDecoration(
                    //                 color: Colors.white.withOpacity(0.8),
                    //                 border: const Border(
                    //                     bottom: BorderSide(
                    //                         color: Colors.blueGrey))),
                    //             width: getPhoneWidth(context) / 3 - 17,
                    //             child: Row(
                    //               children: [
                    //                 Text(
                    //                   "Data",
                    //                   style: AppStyles.getHeaderNameText(
                    //                       color: Colors.blueGrey, size: 15.0),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //           Container(
                    //             padding: const EdgeInsets.symmetric(
                    //                 vertical: 8, horizontal: 8),
                    //             decoration: BoxDecoration(
                    //                 color: Colors.white.withOpacity(0.8),
                    //                 border: const Border(
                    //                     bottom: BorderSide(
                    //                         color: Colors.blueGrey))),
                    //             width: getPhoneWidth(context) / 3 - 17,
                    //             child: Row(
                    //               children: [
                    //                 Text(
                    //                   "Bonus",
                    //                   style: AppStyles.getHeaderNameText(
                    //                       color: Colors.blueGrey, size: 15.0),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //           Container(
                    //             padding: const EdgeInsets.symmetric(
                    //                 vertical: 8, horizontal: 8),
                    //             decoration: BoxDecoration(
                    //                 color: Colors.white.withOpacity(0.8),
                    //                 border: const Border(
                    //                     bottom: BorderSide(
                    //                         color: Colors.blueGrey))),
                    //             width: getPhoneWidth(context) / 3 - 16,
                    //             child: Row(
                    //               children: [
                    //                 Text(
                    //                   "Minus",
                    //                   style: AppStyles.getHeaderNameText(
                    //                       color: Colors.blueGrey, size: 15.0),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       // Table(
                    //       //   children: List.generate(equallization.getEqualizations().length, (index) {
                    //       //     var s = equallization.getEqualizations()[index];
                    //       //     return TableRow(
                    //       //         decoration: BoxDecoration(
                    //       //             color: Colors.white.withOpacity(0.8)),
                    //       //         children: [
                    //       //           Padding(
                    //       //             padding: const EdgeInsets.all(8.0),
                    //       //             child: Text(
                    //       //               s.createdAt.toString().substring(0,10),
                    //       //               style: AppStyles.getHeaderNameText(
                    //       //                   color: Colors.blueGrey, size: 15.0),
                    //       //             ),
                    //       //           ),
                    //       //           Padding(
                    //       //             padding: const EdgeInsets.all(8.0),
                    //       //             child: Text(
                    //       //               "${s.postmanBonuses.toStringAsFixed(2)}€",
                    //       //               style: AppStyles.getHeaderNameText(
                    //       //                   color: Colors.blueGrey, size: 15.0),
                    //       //             ),
                    //       //           ),
                    //       //           Padding(
                    //       //             padding: const EdgeInsets.all(8.0),
                    //       //             child: Text(
                    //       //               "${s.debt.toStringAsFixed(2)}€",
                    //       //               style: AppStyles.getHeaderNameText(
                    //       //                   color: Colors.blueGrey, size: 15.0),
                    //       //             ),
                    //       //           ),
                    //       //         ]);
                    //       //   }),
                    //       // ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
