import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hejposta/controllers/expences_controller.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/expence_provider.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/shortcuts/modals.dart';
import 'package:hejposta/views/postman/postman_drawer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Expences extends StatefulWidget {
  const Expences({Key? key}) : super(key: key);

  @override
  State<Expences> createState() => _ExpencesState();
}

class _ExpencesState extends State<Expences> {
  DateTime expenceDate = DateTime.now();
  TextEditingController kategoria = TextEditingController();
  TextEditingController _comment = TextEditingController();
  TextEditingController qmimi = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  List<String> kategorite = [
    "Karburant",
    "Rregullimi i problemit teknik",
    "Tjeter"
  ];
  var fetching = false;
  int selectedIndex = -1;
  bool commented = false;
  bool up = false;
  bool left = false;
  StateSetter? _setState;

  @override
  void initState() {
    super.initState();
  }

  getExpences() {
    ExpencesController expencesController = ExpencesController();
    expencesController.getExpences(context).then((value) {
      if (value == "Connection refused") {
        serverRespondErrorModal(context);
      }
    });
  }

  addExpence() {
    setState(() {
      fetching = true;
    });
    ExpencesController expencesController = ExpencesController();
    if (kategoria.text.isEmpty || qmimi.text.isEmpty) {
      showModalOne(
          context,
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "Plotesoni te gjitha fushat!",
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
      setState(() {
        fetching = false;
      });
    } else {
      expencesController
          .addExpence(context, expenceDate, kategoria.text, qmimi.text)
          .then((value) {
            print(value);
        if (value == "Connection refused") {
          serverRespondErrorModal(context);
        } else {
          if (value == "success") {
            getExpences();
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return Container(
                    height: 200,
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      title: Center(
                          child: Text(
                        "Shtimi i shpeznimit deshtoi",
                        style: AppStyles.getHeaderNameText(
                            color: Colors.grey[700], size: 20.0),
                      )),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: getPhoneWidth(context) - 140,
                              child: Text(
                                "Kontaktoni administraten e postes per informata shtese",
                                textAlign: TextAlign.center,
                                style: AppStyles.getHeaderNameText(
                                    color: Colors.blueGrey, size: 16.0),
                              )),
                        ],
                      ),
                      actions: [
                        Center(
                          child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Largo",
                                style: AppStyles.getHeaderNameText(
                                    color: Colors.blueGrey, size: 15.0),
                              )),
                        )
                      ],
                    ),
                  );
                });
          }
        }
      }).whenComplete(() {

        setState(() {
          fetching = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var generalProvider = Provider.of<GeneralProvider>(context);
    var expences = Provider.of<ExpenceProvider>(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.bottomColorTwo,
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
              Positioned(
                  child: SizedBox(
                width: getPhoneWidth(context),
                height: getPhoneHeight(context) - 65,
                child: Image.asset(
                  "assets/icons/map-icon.png",
                  color: AppColors.mapColorFirst,
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.cover,
                ),
              )),
              SizedBox(
                width: getPhoneWidth(context),
                height: getPhoneHeight(context) - 66,
                child: RefreshIndicator(
                  onRefresh: () async {
                    getExpences();
                  },
                  child: ListView(
                    padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.only(left: 28, right: 20, top: 10),
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
                              "Shpenzimet",
                              style: AppStyles.getHeaderNameText(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  size: 20.0),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 50,
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
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    width: getPhoneWidth(context),
                                    height: 250,
                                    child: CupertinoDatePicker(
                                      minimumDate: DateTime(2020, 01, 01),
                                      maximumDate: DateTime.now()
                                          .add(Duration(hours: 1)),
                                      onDateTimeChanged: (value) {
                                        setState(() {
                                          expenceDate = value;
                                        });
                                      },
                                      maximumYear: 2040,
                                      initialDateTime: DateTime.now(),
                                      minimumYear: 2020,
                                      dateOrder: DatePickerDateOrder.dmy,
                                    ),
                                  );
                                });
                          },
                          child: Container(
                            width: getPhoneWidth(context),
                            height: 50,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20)),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "// ${DateFormat("yyyy-MM-dd HH:mm:dd").format(expenceDate)}",
                                  style: AppStyles.getHeaderNameText(
                                      color: Colors.blueGrey, size: 15.0),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: SizedBox(
                                      width: 23,
                                      child: Image.asset(
                                          "assets/icons/cal-icon.png")),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: GestureDetector(
                          onTap: () {
                            showModalOne(context,
                                StatefulBuilder(builder: (context, setter) {
                              _setState = setter;
                              return ListView(
                                padding: const EdgeInsets.all(0),
                                children: [
                                  ListView.builder(
                                    padding: const EdgeInsets.all(0),
                                    physics: const ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _setState!(() {
                                                selectedIndex = index;
                                              });
                                              if (selectedIndex !=
                                                  kategorite.length - 1) {
                                                Navigator.pop(context);
                                                setState(() {
                                                  kategoria.text =
                                                      kategorite[index];
                                                  selectedIndex = index;
                                                });
                                              } else {
                                                setState(() {
                                                  kategoria.text = "";
                                                  selectedIndex = index;
                                                });
                                              }
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
                                                        kategorite[index],
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
                                                    child:
                                                        selectedIndex != index
                                                            ? const SizedBox()
                                                            : Container(
                                                                width: 25,
                                                                height: 25,
                                                                margin:
                                                                    const EdgeInsets
                                                                        .all(2),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
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
                                    itemCount: kategorite.length,
                                  ),
                                  selectedIndex != kategorite.length - 1
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
                                                setState(() {});
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
                                              color: commented
                                                  ? Colors.blueGrey
                                                  : Colors.grey[400],
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                          child: TextButton(
                                              onPressed: () {
                                                if (commented) {
                                                  _setState!(() {
                                                    commented = false;
                                                  });
                                                  setState(() {
                                                    kategoria.text =
                                                        _comment.text;
                                                    _comment.text = "";
                                                  });
                                                }
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Ruaj",
                                                style:
                                                    AppStyles.getHeaderNameText(
                                                        color: Colors.white,
                                                        size: 17),
                                              ))),
                                    ],
                                  )
                                ],
                              );
                            }), 340.0);
                            setState(() {});
                          },
                          child: Container(
                            width: getPhoneWidth(context),
                            height: 50,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20)),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  kategoria.text.isEmpty
                                      ? "Kategoria e shpenzimit"
                                      : kategoria.text,
                                  style: AppStyles.getHeaderNameText(
                                      color: Colors.grey[800], size: 16.0),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 35,
                                  color: AppColors.bottomColorOne,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return SizedBox(
                                    width: getPhoneWidth(context),
                                    height: 250,
                                  );
                                });
                          },
                          child: Container(
                              width: getPhoneWidth(context),
                              height: 50,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      topLeft: Radius.circular(20)),
                                  color: Colors.white),
                              child: TextField(
                                controller: qmimi,
                                decoration: InputDecoration(
                                    hintText: "Cmimi",
                                    hintStyle: AppStyles.getHeaderNameText(
                                        color: Colors.grey[900], size: 15.0),
                                    border: InputBorder.none,
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          topLeft: Radius.circular(20)),
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          topLeft: Radius.circular(20)),
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10)),
                              )),
                        ),
                      ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 25),
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       showModalBottomSheet(
                      //           context: context,
                      //           builder: (context) {
                      //             return Container(
                      //               width: getPhoneWidth(context),
                      //               height: 250,
                      //               padding:
                      //                   EdgeInsets.symmetric(horizontal: 20),
                      //               child: Center(
                      //                 child: Text(
                      //                   "Kjo karakteristike do te rregullohet e versionin e radhes!",
                      //                   textAlign: TextAlign.center,
                      //                   style: AppStyles.getHeaderNameText(
                      //                       color: Colors.blueGrey, size: 18),
                      //                 ),
                      //               ),
                      //             );
                      //           });
                      //     },
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.end,
                      //       children: [
                      //         Container(
                      //           width: 100,
                      //           height: 50,
                      //           decoration: const BoxDecoration(
                      //             borderRadius: BorderRadius.only(
                      //                 bottomRight: Radius.circular(20),
                      //                 bottomLeft: Radius.circular(20)),
                      //             color: Color(0xffff7d24),
                      //           ),
                      //           padding:
                      //               const EdgeInsets.symmetric(horizontal: 20),
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               Text(
                      //                 "Foto",
                      //                 style: AppStyles.getHeaderNameText(
                      //                     color: Colors.white, size: 16.0),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: GestureDetector(
                          onTap: () {
                            if(!fetching){
                              addExpence();
                            }
                          },
                          child: Container(
                            width: getPhoneWidth(context),
                            height: 50,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: fetching ?SizedBox(width: 25,height: 25,child: CircularProgressIndicator(strokeWidth: 1.4,)):  Text(
                                "Ruaje",
                                style: AppStyles.getHeaderNameText(
                                    color: Colors.grey[900], size: 16.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 20),
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 8),
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.blueGrey[200],
                                            border: const Border(
                                                bottom: BorderSide(
                                                    color: Colors.blueGrey))),
                                        width: getPhoneWidth(context) / 3 - 17,
                                        child: Row(
                                          children: [
                                            Text(
                                              "Kategoria",
                                              style:
                                                  AppStyles.getHeaderNameText(
                                                      color: Colors.white,
                                                      size: 15.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 8),
                                        decoration: BoxDecoration(
                                            color:
                                            Colors.blueGrey[200],
                                            border: const Border(
                                                bottom: BorderSide(
                                                    color: Colors.blueGrey))),
                                        width: getPhoneWidth(context) / 3 - 16,
                                        child: Row(
                                          children: [
                                            Text(
                                              "Cmimi",
                                              style:
                                                  AppStyles.getHeaderNameText(
                                                      color: Colors.white,
                                                      size: 15.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                            color:
                                            Colors.blueGrey[200],
                                            border: const Border(
                                                bottom: BorderSide(
                                                    color: Colors.blueGrey))),
                                        width: getPhoneWidth(context) / 3 - 17,
                                        child: Row(
                                          children: [
                                            Text(
                                              "Data",
                                              style:
                                                  AppStyles.getHeaderNameText(
                                                      color: Colors.white,
                                                      size: 15.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Table(
                              children: List.generate(
                                  expences.getExpences().length, (index) {


                                return TableRow(
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.8)),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          expences.getExpences()[index].reason!,
                                          style: AppStyles.getHeaderNameText(
                                              color: Colors.blueGrey,
                                              size: 15.0),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          expences
                                                  .getExpences()[index]
                                                  .total!
                                                  .toString() +
                                              "€",
                                          style: AppStyles.getHeaderNameText(
                                              color: Colors.blueGrey,
                                              size: 15.0),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          expences
                                              .getExpences()[index]
                                              .expenceDate!
                                              .toString()
                                              .substring(0, 10),
                                          style: AppStyles.getHeaderNameText(
                                              color: Colors.blueGrey,
                                              size: 15.0),
                                        ),
                                      ),
                                    ]);
                              }),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
