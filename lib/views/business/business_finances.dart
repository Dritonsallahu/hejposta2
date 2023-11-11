import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hejposta/controllers/client_finance_controller.dart';
import 'package:hejposta/models/order_model.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/views/postman/postman_drawer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:qr/qr.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BusinessFinances extends StatefulWidget {
  const BusinessFinances({Key? key}) : super(key: key);

  @override
  State<BusinessFinances> createState() => _BusinessFinancesState();
}

class _BusinessFinancesState extends State<BusinessFinances> {
  DateTime _dateTime = DateTime.now();
  GlobalKey key = GlobalKey();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  List<OrderModel> _orders = [];

    var equalizationCodes = {};

  double gjiroTotale = 0.0;
  double bilanciNeHej = 0.0;
  double bilanicNePostaPartnere = 0.0;

  bool filerEqualized = false;
  int deliveringStep = 0;

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
    getFinances();
    super.initState();
  }

  bool fetching = false;

  getFinances(){
    setState(() {
      gjiroTotale = 0.0;
      bilanciNeHej = 0.0;
      bilanicNePostaPartnere = 0.0;
      fetching= true;
    });
    ClientFinanceController clientFinanceController = ClientFinanceController();
    clientFinanceController.getFinances(context,_dateTime).then((value) {
      if(value == "failed"){

      }
      else{
        setState(() {
          _orders = value['ordersList']; // lista e porosive te barazuara sipas dates
          gjiroTotale = value['total'].toDouble(); // mir eshte
        });
        value['ordersList'].forEach((element) {
          setState(() {
            bilanciNeHej += ((element.price - element.offer.price) * element.qty);
            if(element.receiver.state == "Shqipëri" || element.receiver.state == "Maqedonia"){
              bilanicNePostaPartnere += ((element.price - element.offer.price) * element.qty);
            }
          });
        });
        equalizationCodes = groupBy(value['ordersList']!, (OrderModel orderModel) => orderModel.equalCodeWithClient)
            .map((senderId, orders) {
          final totalPrice = orders
              .map((order) {
                return (order.price - order.offer!.price) * order.qty;
          })
              .reduce((value, element) => value + element);

          return MapEntry(
            orders.first.equalCodeWithClient.toString(),
            {'count': orders.length, 'totalPrice': totalPrice},
          );
        });
      }
    }).whenComplete(() {
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
      body: Column(
        children: [
          Container(
            height:  MediaQuery.of(context).viewPadding.top,
            decoration: BoxDecoration(color: AppColors.appBarColor),
          ),
          Stack(
            children: [
              AnimatedPositioned(
                  duration: const Duration(
                    seconds: 20,
                  ),
                  top: !up ? -65 : 65,
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
                              children:  [
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
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: getPhoneWidth(context) / 2 - 35,
                            height: 85,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.white, width: 2)),
                            padding: const EdgeInsets.all(3),
                            child: Stack(
                              children: [
                                Container(
                                  width: getPhoneWidth(context) / 2 - 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4)),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Gjiro Totale",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.white, size: 16),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "$gjiroTotale€",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.white, size: 23),
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 15,
                                  right: 10,
                                  child: SizedBox(
                                      width: 30,
                                      child: Image.asset(
                                        "assets/icons/gjiro.png",
                                        color: Colors.white,
                                      )),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: getPhoneWidth(context) / 2 - 35,
                            height: 85,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.white, width: 2)),
                            padding: const EdgeInsets.all(3),
                            child: Stack(
                              children: [
                                Container(
                                  width: getPhoneWidth(context) / 2 - 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4)),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Bilanci në Hej",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.white, size: 16),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${bilanciNeHej}€",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.white, size: 23),
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 15,
                                  right: 10,
                                  child: SizedBox(
                                      width: 30,
                                      child: Image.asset(
                                        "assets/icons/bilanci.png",
                                        color: Colors.white,
                                      )),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: getPhoneWidth(context) / 2 - 35,
                            height: 85,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.white, width: 2)),
                            padding: const EdgeInsets.all(3),
                            child: Stack(
                              children: [
                                Container(
                                  width: getPhoneWidth(context) / 2 - 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 7),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Bilani ne posta partnere",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.white, size: 14),
                                      ),
                                      Text(
                                        "${bilanicNePostaPartnere}€",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.white, size: 23),
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 15,
                                  right: 10,
                                  child: SizedBox(
                                      width: 30,
                                      child: Image.asset(
                                        "assets/icons/bil-partner.png",
                                        color: Colors.white,
                                      )),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: getPhoneWidth(context) / 2 - 35,
                            height: 85,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: (){

                                    if(bilanciNeHej == 0.0){

                                    }
                                    else{
                                      showModalBottomSheet(context: context, builder: (context){
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              const Text("Gjate barazimit me postier, me posht gjeni barkodet me te cilat behet barazimi"),
                                              Column(
                                                children: List.generate(equalizationCodes.length, (index){
                                                  final orderGroupEntry = equalizationCodes.entries.toList()[index];
                                                  final equalCodeWithClient = orderGroupEntry.key;
                                                  final count = orderGroupEntry.value['count'];
                                                  final totalPrice = orderGroupEntry.value['totalPrice'];

                                                  return Column(
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 10),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text("Kodi barazimit:",style: AppStyles.getHeaderNameText(color: Colors.blueGrey[800],size: 16.0),),
                                                                Text(equalCodeWithClient.toString(),style: AppStyles.getHeaderNameText(color: Colors.blueGrey[800],size: 16.0),),
                                                                const SizedBox(height: 20,),
                                                                Text("Numri i porosive:",style: AppStyles.getHeaderNameText(color: Colors.blueGrey[800],size: 16.0),),
                                                                Text(count.toString(),style: AppStyles.getHeaderNameText(color: Colors.blueGrey[800],size: 16.0),),
                                                                const SizedBox(height: 20,),
                                                                Text("Qmimi i porosive:",style: AppStyles.getHeaderNameText(color: Colors.blueGrey[800],size: 16.0),),
                                                                Text(totalPrice.toString()+"€",style: AppStyles.getHeaderNameText(color: Colors.blueGrey[800],size: 16.0),),

                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                              width: 200,
                                                              height: 200,
                                                              color: Colors.grey[200],
                                                              child: TextButton(
                                                                onPressed: (){
                                                                  showDialog(context: context, builder: (context){
                                                                    return AlertDialog(
                                                                     content: Container(
                                                                         width: 200,
                                                                         height: 200,
                                                                         child: QrImage(
                                                                           data: equalCodeWithClient,
                                                                           version: QrVersions.auto,
                                                                           size: 320,
                                                                           gapless: false,
                                                                           embeddedImageStyle: QrEmbeddedImageStyle(
                                                                             size: const Size(80, 80),
                                                                           ),
                                                                         )
                                                                     ),
                                                                    );
                                                                  });
                                                                },
                                                                child: const Center(
                                                                  child: Text("Hap barkodin"),
                                                                ),
                                                              )
                                                          ),
                                                        ],
                                                      ),
                                                      const Divider()
                                                    ],
                                                  ) ;
                                                }),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: getPhoneWidth(context) / 2 - 35,
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
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          bilanciNeHej == 0.0 ? "Kërko barazim":"Barazo",
                                          style: AppStyles.getHeaderNameText(
                                              color: Colors.white, size: 22),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 45,
                                  right: 10,
                                  child: SizedBox(
                                      width: 50,
                                      child: Image.asset(
                                        "assets/icons/prano.png",
                                        color: Colors.white,
                                      )),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 25),
                    //   child: Container(
                    //     width: getPhoneWidth(context),
                    //     height: 45,
                    //     decoration: const BoxDecoration(
                    //       borderRadius: BorderRadius.only(
                    //           topRight: Radius.circular(20),
                    //           topLeft: Radius.circular(20)),
                    //       color: Colors.white,
                    //     ),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         GestureDetector(
                    //           onTap: (){
                    //             showModalBottomSheet(
                    //                 context: context,
                    //                 builder: (context) {
                    //                   return Container(
                    //                     width: getPhoneWidth(context),
                    //                     height: 250,
                    //                     child: CupertinoDatePicker(
                    //                       onDateTimeChanged: (date) {
                    //                         setState(() {
                    //                           _dateTime = date;
                    //                         });
                    //                       },
                    //                       initialDateTime: DateTime.now(),
                    //                       minimumYear: 2020,
                    //                       maximumYear: 2100,
                    //                       minimumDate: DateTime(2020, 01, 01),
                    //                       maximumDate: DateTime(2100, 01, 01),
                    //                       mode: CupertinoDatePickerMode.date,
                    //                     ),
                    //                   );
                    //                 });
                    //           },
                    //           child: Container(
                    //             color: Colors.transparent,
                    //             width: getPhoneWidth(context) - 120,
                    //             height: 50,
                    //             child: Row(
                    //               children: [
                    //                 Padding(
                    //                   padding: const EdgeInsets.only(left: 20),
                    //                   child: Text(
                    //                     "// ${DateFormat("yyyy-MM-dd").format(_dateTime)}",
                    //                     style: AppStyles.getHeaderNameText(
                    //                         color: Colors.blueGrey, size: 17.0),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //         GestureDetector(
                    //           onTap: () {
                    //            getFinances();
                    //           },
                    //           child: Container(
                    //               width: 63,
                    //               decoration: BoxDecoration(
                    //                   borderRadius: const BorderRadius.only(
                    //                       topRight: Radius.circular(20)),
                    //                   color: AppColors.bottomColorOne),
                    //               child: Row(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: [
                    //                   const Padding(
                    //                     padding: EdgeInsets.all(10.0),
                    //                     child: Icon(Icons.search,size: 28,color: Colors.white,)
                    //                   ),
                    //                 ],
                    //               )),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    border: const Border(
                                        bottom: BorderSide(
                                            color: Colors.blueGrey))),
                                width: getPhoneWidth(context) / 3 - 17,
                                child: Row(
                                  children: [
                                    Text(
                                      "Shifra",
                                      style: AppStyles.getHeaderNameText(
                                          color: Colors.blueGrey, size: 15.0),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    border: const Border(
                                        bottom: BorderSide(
                                            color: Colors.blueGrey))),
                                width: getPhoneWidth(context) / 3 - 17,
                                child: Row(
                                  children: [
                                    Text(
                                      "Shuma",
                                      style: AppStyles.getHeaderNameText(
                                          color: Colors.blueGrey, size: 15.0),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    border: const Border(
                                        bottom: BorderSide(
                                            color: Colors.blueGrey))),
                                width: getPhoneWidth(context) / 3 - 16,
                                child: Row(
                                  children: [
                                    Text(
                                      "Data",
                                      style: AppStyles.getHeaderNameText(
                                          color: Colors.blueGrey, size: 15.0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Table(
                            children: List.generate(_orders.length, (index) {
                              return TableRow(
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.8)),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${_orders[index].orderNumber}",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.blueGrey, size: 15.0),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${_orders[index].price - _orders[index].offer!.price}€",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.blueGrey, size: 15.0),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        _orders[index].updatedAt!.substring(0,10),
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.blueGrey, size: 15.0),
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
            ],
          ),
        ],
      ),
    );
  }
}
