import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hejposta/controllers/client_finance_controller.dart';
import 'package:hejposta/models/city_data.dart';
import 'package:hejposta/models/order_data.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/views/postman/postman_drawer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BusinessOrders extends StatefulWidget {
  const BusinessOrders({Key? key}) : super(key: key);

  @override
  State<BusinessOrders> createState() => _BusinessOrdersState();
}

class _BusinessOrdersState extends State<BusinessOrders> {
  DateTime _firstDate = DateTime.now();
  DateTime _lastDate = DateTime.now();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  int teSuksesshme = 0;
  int nePritje = 0;
  int perDepo = 0;
  int neDepo = 0;
  int neDergese = 0;
  int teRikthyera = 0;
  int teAnuluara = 0;
  double gjiroTotale = 0.0;
  double perBarazim = 0.0;

  var qytetetMeShumShitje = <String, int>{};
  var shitjetSipasVitit = <String, dynamic>{};

  bool up = false;
  bool left = false;
  bool fetching = false;

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
  List<CityData> cityStats = [];
  List<OrderData> yearStats = [];
  List<OrderData> data = [];

  getStatistics() {
    setState(() {
      gjiroTotale = 0.0;
      teAnuluara = 0;
      teSuksesshme = 0;
      perBarazim = 0.0;
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
    clientFinanceController.getStatistics(context, _firstDate, _lastDate).then((value) {
      if(value.isNotEmpty){
        for (var element in value) {
          print(element.status);
          if(element.status == "delivered"){
            setState(() {
              gjiroTotale +=  (element.price - element.offer['price']) ;
              teSuksesshme ++;
            });
            if(element.barazimiAdministrat == true && element.barazimiKlient == false){
              perBarazim +=  (element.price - element.offer['price']) ;
            }
            var elementDate = DateTime.parse(element.updatedAt!);

            qytetetMeShumShitje[element.receiver!.city!] = (qytetetMeShumShitje[element.receiver!.city!] ?? 0) + 1;
            shitjetSipasVitit[getMonthName(elementDate, context)!] = (shitjetSipasVitit[getMonthName(elementDate, context)] ?? 0) +1;
          }
          else if(element.status == "rejected"){
            setState(() {
              teAnuluara ++;
            });
          }
          else if(element.status == "pending"){
            setState(() {
              nePritje++;
            });
          }
          else if(element.status == "accepted"){
            setState(() {
              perDepo++;
            });
          }
          else if(element.status == "in_warehouse"){
            setState(() {
              neDepo++;
            });
          }
          else if(element.status == "returned"){
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
      backgroundColor: AppColors.bottomColorOne,
      drawer: const PostmanDrawer(),
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
                  height: getPhoneHeight(context) - 25,
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
                                children:   [
                                  SizedBox(
                                    width: 60,
                                    height: 26,
                                    child: fetching ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: const [
                                        SizedBox(width: 26,height: 26,child: CircularProgressIndicator(strokeWidth: 1.4,color: Colors.white,)),
                                      ],
                                    ) : const SizedBox(),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: GestureDetector(
                          onTap: (){
                            getStatistics();
                          },
                          child: Container(
                            width: getPhoneWidth(context)   - 40,
                            height: 50,
                            decoration:   BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)),
                              color: AppColors.bottomColorTwo,
                            ),
                            child: Center(child: Text("Kerko",style: AppStyles.getHeaderNameText(color:Colors.white,size: 17.0),),),
                          ),
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
                                        "Gjiro",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            size: 15.0),
                                      ),
                                      Text(
                                        "$gjiroTotale€",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.white, size: 23.0),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                    right: 10,
                                    top: 25,
                                    child: SizedBox(
                                        width: 30,
                                        child:
                                        Image.asset("assets/icons/10.png"))),
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
                                        "Per barazim",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            size: 15.0),
                                      ),
                                      Text(
                                        "$perBarazim€",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.white, size: 23.0),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                    right: 10,
                                    top: 28,
                                    child: SizedBox(
                                        width: 35,
                                        child:
                                        Image.asset("assets/icons/17.png"))),
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
                                            Color(0xff23aac5),
                                            Color(0xffc1efef),
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
                                        "Ne pritje",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            size: 15.0),
                                      ),
                                      Text(
                                        "$nePritje",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.white, size: 23.0),
                                      ),
                                    ],
                                  ),
                                ),
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
                                            Color(0xff059d74),
                                            Color(0xffcad7d3),
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
                                        "Per depo",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            size: 15.0),
                                      ),
                                      Text(
                                        "$perDepo",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.white, size: 23.0),
                                      ),
                                    ],
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
                                            Color(0xffb6680d),
                                            Color(0xffa19a96),
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
                                        "Ne depo",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            size: 15.0),
                                      ),
                                      Text(
                                        "$neDepo",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.white, size: 23.0),
                                      ),
                                    ],
                                  ),
                                ),
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
                                            Color(0xff83cc13),
                                            Color(0xffeaeaea),
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
                                        "Te rikthyera",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            size: 15.0),
                                      ),
                                      Text(
                                        "$teRikthyera",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.white, size: 23.0),
                                      ),
                                    ],
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
                                        "Dergesa te suksesshme",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            size: 13.0),
                                      ),
                                      Text(
                                        "$teSuksesshme",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.white, size: 23.0),
                                      ),
                                    ],
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
                                        "Anulime",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            size: 13.0),
                                      ),
                                      Text(
                                        "$teAnuluara",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.white, size: 23.0),
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

                      const SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: getPhoneWidth(context),
                          padding: const EdgeInsets.only(left: 10,right: 10),
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
                                      text: 'Total porosi pergjate vitit 2023'),
                                  // Enable legend
                                  legend: Legend(isVisible: false),
                                  // Enable tooltip
                                  tooltipBehavior: TooltipBehavior(enable: true),
                                  series: <CartesianSeries>[
                                    ColumnSeries<OrderData, String>(
                                        dataSource: yearStats,color: AppColors.bottomColorTwo,
                                        xValueMapper: (OrderData year, _) =>
                                        year.month,
                                        yValueMapper: (OrderData year, _) =>
                                        year.sales,
                                        name: 'Shitjet',
                                        // Enable data label
                                        dataLabelSettings:
                                        const DataLabelSettings(isVisible: true))
                                  ]),
                            ),
                            const SizedBox(height: 10,),
                            Container(
                              color: Colors.white.withOpacity(0.8),
                              child: SfCartesianChart(
                                  primaryXAxis: CategoryAxis(
                                    title: AxisTitle(text: ""),
                                  ),
                                  // Chart title
                                  title: ChartTitle(text: 'Shitjet sipas qyteteve'),
                                  // Enable legend
                                  legend: Legend(isVisible: false),
                                  // Enable tooltip
                                  tooltipBehavior: TooltipBehavior(enable: true),
                                  series: <CartesianSeries>[
                                    ColumnSeries<CityData, String>(
                                        dataSource: cityStats ,color: AppColors.bottomColorTwo,
                                        xValueMapper: (CityData city, _) =>
                                        city.city,
                                        yValueMapper: (CityData city, _) =>
                                        city.sales,
                                        name: 'Shitjet',
                                        // Enable data label
                                        dataLabelSettings:
                                            const DataLabelSettings(isVisible: true))
                                  ]),
                            ),
                          ]),
                        ),
                      ),


                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
