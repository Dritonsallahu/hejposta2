import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hejposta/controllers/finance_controller.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/shortcuts/modals.dart';
import 'package:hejposta/views/postman/postman_drawer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Finances extends StatefulWidget {
  const Finances({Key? key}) : super(key: key);

  @override
  State<Finances> createState() => _FinancesState();
}

class _FinancesState extends State<Finances> {
  DateTime dateTime = DateTime.now();
  TextEditingController statusi = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  String porosiTeSuksesshme = "0";
  String vleraPorosive = "0";
  String shpenzime = "0";
  String totali = "0";
  bool fetchingFinancat = false;
  bool fetchingOrders = false;

  bool up = false;
  bool left = false;

  List<String> statuset = ["Te suksesshme", "Te anuluara", "Te rikthyera"];


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
    getFinances();
    super.initState();
  }


  getFinances(){
    setState(() {
      fetchingFinancat = true;
    });
    //{message: success, orderNubers: 1, ordersPrice: 65, expences: 21, totali: 44}
    FinanceController financeController = FinanceController();
    financeController.getFinances(context,dateTime).then((value) {
      if(value['message'] == "success"){
        setState(() {
          porosiTeSuksesshme = value['orderNubers'].toString();
          vleraPorosive = value['ordersPrice'].toString();
          shpenzime = value['expences'].toString();
          totali = value['totali'].toString();
        });
      }
      else{
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
      }
    }).whenComplete(() {

      setState(() {
        fetchingFinancat = false;
      });
    });
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
                            "Financat",
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
                        width: getPhoneWidth(context) ,
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
                                            onDateTimeChanged: (date){
                                              setState(() {
                                                dateTime = date;
                                              });
                                            },
                                            initialDateTime: DateTime.now(),
                                            minimumYear: 2020,
                                            maximumYear: 2100,
                                            minimumDate: DateTime(2020,01,01),
                                            maximumDate: DateTime(2100,01,01),
                                            mode: CupertinoDatePickerMode.date,
                                          ),
                                        );
                                      });
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  width: getPhoneWidth(context) - 162,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat("yyyy-MM-dd").format(dateTime),
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.black, size: 17.0),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  getFinances();
                                },
                                child: Container(
                                  width: 90,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
                                    color: AppColors.bottomColorTwo
                                  ),
                                  child: Center(child: Text("Kerko",style: AppStyles.getHeaderNameText(color: Colors.white,size: 16),),),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height:  !fetchingFinancat ? 0: 20,),
                    !fetchingFinancat ? SizedBox():Center(child: CircularProgressIndicator()),
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
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Numri i porosive\nme sukses",
                                      style: AppStyles.getHeaderNameText(
                                          color: Color(0xff381e63),
                                          fontWeight: FontWeight.w600,
                                          size: 13.0),
                                    ),
                                    Text(
                                      porosiTeSuksesshme,
                                      style: AppStyles.getHeaderNameText(
                                          color: Color(0xff381e63), size: 23.0),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                  right: 0,
                                  top: 15,
                                  child: SizedBox(
                                      width: 48,
                                      child: Image.asset(
                                        "assets/icons/8.png",
                                        color: Colors.redAccent,
                                      ))),
                            ],
                          ),
                          Stack(
                            children: [
                              Container(
                                width: getPhoneWidth(context) / 2 - 40,
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
                                      "Vlera e\nporosive",
                                      style: AppStyles.getHeaderNameText(
                                          color: const Color(0xff381e63),
                                          fontWeight: FontWeight.w600,
                                          size: 13.0),
                                    ),
                                    Text(
                                      "$vleraPorosive€",
                                      style: AppStyles.getHeaderNameText(
                                          color: const Color(0xff381e63),
                                          size: 23.0),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                  right: 0,
                                  top: 15,
                                  child: SizedBox(
                                      width: 48,
                                      child: Image.asset(
                                        "assets/icons/8.png",
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
                                      "Shpenzime",
                                      style: AppStyles.getHeaderNameText(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          size: 13.0),
                                    ),
                                    Text(
                                      "$shpenzime€",
                                      style: AppStyles.getHeaderNameText(
                                          color: Colors.white, size: 23.0),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                  right: 0,
                                  top: 18,
                                  child: SizedBox(
                                      width: 44,
                                      child:
                                          Image.asset("assets/icons/8.png"))),
                              Positioned(
                                  right: 36,
                                  top: 18,
                                  child: SizedBox(
                                      width: 44,
                                      child:
                                          Image.asset("assets/icons/8.png"))),
                            ],
                          ),
                          Stack(
                            children: [
                              Container(
                                width: getPhoneWidth(context) / 2 - 40,
                                height: 85,
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                        colors: [
                                          Color(0xff00ab4f),
                                          Color(0xff6fcf9b),
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
                                      "Totali",
                                      style: AppStyles.getHeaderNameText(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          size: 13.0),
                                    ),
                                    Text(
                                      "${int.parse(vleraPorosive) - int.parse(shpenzime)}€",
                                      style: AppStyles.getHeaderNameText(
                                          color: Colors.white, size: 23.0),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                  right: 0,
                                  top: 18,
                                  child: SizedBox(
                                      width: 44,
                                      child:
                                      Image.asset("assets/icons/8.png"))),
                              Positioned(
                                  right: 36,
                                  top: 18,
                                  child: SizedBox(
                                      width: 44,
                                      child:
                                      Image.asset("assets/icons/8.png"))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
