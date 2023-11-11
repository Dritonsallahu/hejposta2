import 'package:flutter/material.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/views/postman/postman_drawer.dart';
import 'package:provider/provider.dart';

class Rules extends StatefulWidget {
  const Rules({Key? key}) : super(key: key);

  @override
  State<Rules> createState() => _RulesState();
}

class _RulesState extends State<Rules> {
  PageController pageController = PageController(initialPage: 0);
  int selectedIndex = 0;
  GlobalKey key = GlobalKey();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  bool filerEqualized = false;
  int deliveringStep = 0;

  bool up = false;
  bool left = false;

  @override
  void initState() {
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
                  color: AppColors.mapColorSecond,
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
                            "Rregullorja",
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
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        width: getPhoneWidth(context),
                        child: Text(
                          "Rregullorja e punes, rregullorja e punes rregull lorja e punes"
                          " rregullorja e punes rregullorja e pun a e punes rregullorja e punes rregullorja e punes"
                          " rregullorja e punes rregules rregullorja e punes rregullorja e punes rregullorja e punes"
                          " rregullorja e punes rregullor punes rregullorja e punes rregullorja e punes rregullorja e punes rregullorja e punes rregullorja e punes rregullorja e punes rregullorja e punes rregullorja e punes"
                          " rregullorja e punes rregullorja e punes rregul s rregullorja e punes rregullorja e punes rregullorja e punes rregullorja e punes"
                          " rregullorja e punes rregullorja e punes rregullorja e punes"
                          ""
                          ""
                          "",
                          style: AppStyles.getHeaderNameText(
                              color: Colors.white, size: 17.0),
                        ),
                      ),
                    )
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
