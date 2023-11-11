import 'package:flutter/material.dart';
import 'package:hejposta/controllers/rules_controller.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/shortcuts/modals.dart';
import 'package:hejposta/views/postman/postman_drawer.dart';
import 'package:provider/provider.dart';

class BusinessRules extends StatefulWidget {
  const BusinessRules({Key? key}) : super(key: key);

  @override
  State<BusinessRules> createState() => _BusinessRulesState();
}

class _BusinessRulesState extends State<BusinessRules> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  dynamic rules;
  bool fetching = false;

  getRules() {
    setState(() {
      fetching = true;
    });
    RulesController rulesController = RulesController();
    rulesController.getRules(context, "biznes").then((value) {
      if (value != "failed" && value != null) {
        setState(() {
          rules = value;
        });
      } else if (value == "failed") {
        showMessageModal(context, "Ka ndodhur nje problem!", 15.0);
      }
    }).whenComplete(() {
      setState(() {
        fetching = false;
      });
    });
  }

  @override
  void initState() {
    getRules();
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
                    fetching
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 1.5,
                          ))
                        : rules.toString() == "null"
                            ? Text(
                                "Shfaqja e politikave te privatesise deshtoi\nKontaktoni administraten per sqarime shtese.", textAlign: TextAlign.center,
                      style: AppStyles.getHeaderNameText(
                        color: Colors.white,
                        size: 18.0,
                      ),)
                            : Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: SizedBox(
                                      width: getPhoneWidth(context),
                                      child: Text(
                                        rules['title'].toString(),
                                        textAlign: TextAlign.center,
                                        style: AppStyles.getHeaderNameText(
                                          color: Colors.white,
                                          size: 18.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: SizedBox(
                                      width: getPhoneWidth(context),
                                      child: Text(
                                        rules['body'].toString(),
                                        textAlign: TextAlign.center,
                                        style: AppStyles.getHeaderNameText(
                                          color: Colors.white,
                                          size: 18.0,
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
        ],
      ),
    );
  }
}
