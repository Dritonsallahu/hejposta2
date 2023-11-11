import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hejposta/controllers/goals_controller.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/shortcuts/modals.dart';
import 'package:hejposta/views/postman/postman_drawer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewChallage extends StatefulWidget {
  const NewChallage({super.key});

  @override
  State<NewChallage> createState() => _NewChallageState();
}

class _NewChallageState extends State<NewChallage> {
  DateTime _firstDate = DateTime.now();
  DateTime _lastDate = DateTime.now();
  TextEditingController numriPorosive = TextEditingController();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  bool fetching = false;

  addGoal(){
    setState(() {
      fetching = true;
    });
    GoalsController goalsController = GoalsController();
    goalsController.addGoal(context, _firstDate, _lastDate, numriPorosive.text).then((value) {
      if(value == "success"){

      }
      else{
        showModalOne(
            context,
            Column(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Regjistrimi i sfides deshtoi!",
                      style: AppStyles.getHeaderNameText(
                          color: Colors.blueGrey[800],
                          size: 17),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
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
                              "Largo",
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
    }).whenComplete((){
      setState(() {
        fetching = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var generalProvider = Provider.of<GeneralProvider>(context, listen: true);
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
      body: ListView(
        padding: const EdgeInsets.all(0),
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
                            "Produkt i ri",
                            style: AppStyles.getHeaderNameText(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                size: 20.0),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nga: ",
                                  style: AppStyles.getHeaderNameText(
                                      color: Colors.white, size: 15),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: getPhoneWidth(context) / 2 - 40,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(20)),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          DateFormat("yyyy-MM-dd").format(_firstDate),
                                          style: AppStyles.getHeaderNameText(
                                              color: Colors.black, size: 14.5),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Image.asset(
                                              "assets/icons/cal-icon.png"),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Deri: ",
                                  style: AppStyles.getHeaderNameText(
                                      color: Colors.white, size: 15),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: getPhoneWidth(context) / 2 - 40,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(20)),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          DateFormat("yyyy-MM-dd").format(_lastDate),
                                          style: AppStyles.getHeaderNameText(
                                              color: Colors.black, size: 14.5),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Image.asset(
                                              "assets/icons/cal-icon.png"),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Numri porosive: ",
                            style: AppStyles.getHeaderNameText(
                                color: Colors.white, size: 15),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                              width: getPhoneWidth(context),
                              height: 50,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      topLeft: Radius.circular(20)),
                                  color: Colors.white),
                              child: TextField(
                                controller: numriPorosive,
                                decoration: InputDecoration(
                                    hintText: "Numri i porosive",
                                    hintStyle: AppStyles.getHeaderNameText(
                                        color: Colors.grey[900], size: 15.0),
                                    border: InputBorder.none,
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          topLeft: Radius.circular(20)),
                                      borderSide: BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          topLeft: Radius.circular(20)),
                                      borderSide: BorderSide(color: Colors.white),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10)),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: GestureDetector(
                          onTap: (){
                            addGoal();
                          },
                          child: Container(
                            width: getPhoneWidth(context),
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: Center(
                              child: Text(
                                "Regjistro produktin",
                                style: AppStyles.getHeaderNameText(
                                    color: Colors.blueGrey[800], size: 15.0),
                              ),
                            ),
                          ),
                        )),
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
