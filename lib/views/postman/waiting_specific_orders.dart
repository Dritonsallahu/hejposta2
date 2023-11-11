
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:flutter_swipe_action_cell/core/controller.dart';
import 'package:hejposta/controllers/postman_orders_controller.dart';
import 'package:hejposta/models/order_model.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/shortcuts/modals.dart';
import 'package:hejposta/shortcuts/order_form.dart';
import 'package:hejposta/shortcuts/utilities.dart';
import 'package:hejposta/views/business/order_details.dart';
import 'package:hejposta/views/postman/postman_drawer.dart';
import 'package:provider/provider.dart';

class WaitingSpecificOrders extends StatefulWidget {
  List<OrderModel>? orders;
  String? status;
  WaitingSpecificOrders({Key? key, this.orders, required this.status}) : super(key: key);

  @override
  State<WaitingSpecificOrders> createState() => _WaitingSpecificOrdersState();
}

class _WaitingSpecificOrdersState extends State<WaitingSpecificOrders> {
  SwipeActionController swipeActionController = SwipeActionController();
  List<OrderModel> ordersFilter = [];
  PageController pageController = PageController(
    initialPage: 0,
  );
  int selectedIndex = 0;
  GlobalKey key = GlobalKey();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  ScrollController? _scrollController;
  bool _showAppbarColor = false;
  bool requesting = false;
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
      ordersFilter = widget.orders!;
    });
    super.initState();
  }

  prano(id) {
    setState(() {
      requesting = true;
    });
    PostmanOrdersController postmanOrdersController = PostmanOrdersController();
    postmanOrdersController.pranoPorosine(context, id).then((value) {
      if (value == "success") {
        if(widget.orders!.length == 1){
          Navigator.of(context).pop();
        }
        else{
          widget.orders!.removeWhere((element) => element.id == id);
        }
      }
      else if (value == "NotFound") {
        showModalOne(
            context,
            Column(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Nuk ekziston kjo porosi ne pritje",
                      style: AppStyles.getHeaderNameText(
                          color: Colors.blueGrey[800],
                          size: 20),
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
      else if (value == "NotValid") {
        showModalOne(
            context,
            Column(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Shifra e porosise eshte jo valide!",
                      style: AppStyles.getHeaderNameText(
                          color: Colors.blueGrey[800],
                          size: 20),
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
      else {
        showModalOne(
            context,
            Column(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Pranimi i porosise deshtoi",
                      style: AppStyles.getHeaderNameText(
                          color: Colors.blueGrey[800],
                          size: 20),
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
    }).whenComplete(() {
      setState(() {
        requesting = false;
      });
    });
  }

  dorezoNeDepo(id) {
    setState(() {
      requesting = true;
    });
    PostmanOrdersController postmanOrdersController = PostmanOrdersController();
    postmanOrdersController.dorzoNeDepoPorosine(context, id).then((value) {
      if (value == "success") {
        if(widget.orders!.length == 1){
          Navigator.of(context).pop();
        }
        else{
          widget.orders!.removeWhere((element) => element.id == id);
        }
      }
      else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  "Dorezimi i porosise deshtoi",
                  style: AppStyles.getHeaderNameText(
                      color: Colors.blueGrey, size: 18.0),
                ),
              );
            });
      }
    }).whenComplete((){
      setState(() {
        requesting = false;
      });
    });
  }

  refuzo(id) {
    setState(() {
      requesting = true;
    });
    PostmanOrdersController postmanOrdersController = PostmanOrdersController();
    postmanOrdersController.refuzoPorosine(context, id).then((value){
      if(value == "success"){
        if(widget.orders!.length == 1){
          Navigator.of(context).pop();
        }
        else{
          widget.orders!.removeWhere((element) => element.id == id);
        }
      }
      else {
        showDialog(context: context, builder: (context){
          return Container(height: 200,
            child: AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              title: Center(child: Text("Refuzimi i porosise deshtoi",style: AppStyles.getHeaderNameText(color: Colors.grey[700],size: 20.0),)),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: getPhoneWidth(context) - 140,child: Text("Kontaktoni administraten e postes per informata shtese",textAlign: TextAlign.center,style: AppStyles.getHeaderNameText(color: Colors.blueGrey,size: 16.0),)),
                ],
              ),
              actions: [Center(child: TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Largo",style: AppStyles.getHeaderNameText(color: Colors.blueGrey,size: 15.0),)),)],
            ),
          );
        } );
      }
    }).whenComplete((){
      setState(() {
        requesting = false;
      });
    });
  }

  scanoPorosine(id){
    showModalOne(
        context,
        Column(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  "Konfirmo pranimin e porosise",
                  style: AppStyles.getHeaderNameText(
                      color: Colors.blueGrey[800],
                      size: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Numri porosise: ${id}",
                  style: AppStyles.getHeaderNameText(
                      color: Colors.blueGrey[600],
                      size: 17),
                ),
              ],
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
                        color: Colors.blueGrey,
                        borderRadius:
                        BorderRadius.circular(100)),
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Jo",
                          style: AppStyles
                              .getHeaderNameText(
                              color: Colors.white,
                              size: 17),
                        ))),
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
                          if(widget.status == "waiting"){
                            prano(id);
                          }
                          else if(widget.status == "accpeted"){
                            dorezoNeDepo(id);
                          }
                        },
                        child: Text(
                          "Po",
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
                                  Row(
                                    children: const [
                                      SizedBox(
                                        width: 50,
                                        height: 26,
                                      ),
                                    ],
                                  )
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
                                                  decoration:
                                                      const BoxDecoration(
                                                          border: Border(
                                                              right: BorderSide(
                                                                  color: Colors
                                                                      .white))),
                                                  width:
                                                      getPhoneWidth(context) -
                                                          145,
                                                  child: TextField(
                                                    onChanged: (value){
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
          AnimatedPositioned(
            bottom: requesting ? 0:-65, duration: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
            width: getPhoneWidth(context) - 20,
            height: 55,
            decoration:   BoxDecoration(
                color: Colors.white,
              borderRadius: BorderRadius.circular(20)
            ),
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Text("Ju lutem prisni pak...  ",style: AppStyles.getHeaderNameText(color: Colors.blueGrey,size: 16.0),),
                      const SizedBox(width: 25,height: 25,child: CircularProgressIndicator(color: Colors.blueGrey,strokeWidth: 1.4,)),
                    ],
                  ),
          ),
              )),
        ],
      ),
      floatingActionButton: widget.status == "in_warehouse" ? null: FloatingActionButton(
        onPressed: () async {
          String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
              "#ff6666",
              "Largo",
              true,
              ScanMode.QR).then((value) {
                return value;
          });
          if(barcodeScanRes.isNotEmpty){
            scanoPorosine(barcodeScanRes);
          }
          else{

          }
        },
        backgroundColor: Colors.grey[300],
        child:
            const Icon(Icons.qr_code_scanner_outlined, color: Colors.blueGrey),
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
                        orderModel: order,
                      )));
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwipeActionCell(
                    key: ObjectKey(index),
                    backgroundColor: Colors.transparent,
                    controller: swipeActionController,
                    trailingActions: widget.status == "waiting" ? [
                      SwipeAction(
                          backgroundRadius: 20,
                          forceAlignmentToBoundary: false,
                          widthSpace: 95,
                          closeOnTap: true,
                          onTap: (CompletionHandler handler) async {
                            showModalOne(
                                context,
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Konfirmo refuzimin e porosise",
                                          style: AppStyles.getHeaderNameText(
                                              color: Colors.blueGrey[800],
                                              size: 20),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Numri porosise: ${widget.orders![index].orderNumber}",
                                          style: AppStyles.getHeaderNameText(
                                              color: Colors.blueGrey[600],
                                              size: 17),
                                        ),
                                      ],
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
                                                color: Colors.blueGrey,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  swipeActionController.closeAllOpenCell();

                                                },
                                                child: Text(
                                                  "Jo",
                                                  style: AppStyles
                                                      .getHeaderNameText(
                                                          color: Colors.white,
                                                          size: 17),
                                                ))),
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
                                                  refuzo(widget.orders![index]
                                                      .orderNumber);
                                                  swipeActionController.closeAllOpenCell();
                                                },
                                                child: Text(
                                                  "Po",
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
                          },
                          content: Container(
                              height: 120,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20)),
                                  color: Colors.red),
                              child: Center(
                                  child: Text(
                                "E dorezuar",
                                style: AppStyles.getHeaderNameText(
                                    color: Colors.white, size: 15.0),
                              ))),
                          color: Colors.transparent),
                      SwipeAction(
                          backgroundRadius: 20,
                          forceAlignmentToBoundary: false,
                          widthSpace: 80,
                          closeOnTap: true,
                          onTap: (CompletionHandler handler) async {
                            showModalOne(
                                context,
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Konfirmo pranimin e porosise",
                                          style: AppStyles.getHeaderNameText(
                                              color: Colors.blueGrey[800],
                                              size: 20),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Numri porosise: ${widget.orders![index].orderNumber}",
                                          style: AppStyles.getHeaderNameText(
                                              color: Colors.blueGrey[600],
                                              size: 17),
                                        ),
                                      ],
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
                                                color: Colors.blueGrey,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  swipeActionController.closeAllOpenCell();
                                                },
                                                child: Text(
                                                  "Jo",
                                                  style: AppStyles
                                                      .getHeaderNameText(
                                                          color: Colors.white,
                                                          size: 17),
                                                ))),
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
                                                  prano(widget.orders![index]
                                                      .orderNumber);
                                                  swipeActionController.closeAllOpenCell();
                                                },
                                                child: Text(
                                                  "Po",
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
                          },
                          content: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20)),
                                  color: AppColors.bottomColorTwo),
                              child: Center(
                                  child: Text(
                                "Prano",
                                style: AppStyles.getHeaderNameText(
                                    color: Colors.white, size: 15.0),
                              ))),
                          color: Colors.transparent),
                    ] : widget.status == "accepted"  ? [

                      SwipeAction(
                          backgroundRadius: 20,
                          forceAlignmentToBoundary: false,
                          widthSpace: 130,
                          closeOnTap: true,
                          onTap: (CompletionHandler handler) async {
                            showModalOne(
                                context,
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Konfirmo dorezimin e porosise\nne depo",textAlign: TextAlign.center,
                                          style: AppStyles.getHeaderNameText(
                                              color: Colors.blueGrey[800],
                                              size: 20),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Numri porosise: ${widget.orders![index].orderNumber}",
                                          style: AppStyles.getHeaderNameText(
                                              color: Colors.blueGrey[600],
                                              size: 17),
                                        ),
                                      ],
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
                                                color: Colors.blueGrey,
                                                borderRadius:
                                                BorderRadius.circular(100)),
                                            child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  swipeActionController.closeAllOpenCell();
                                                },
                                                child: Text(
                                                  "Jo",
                                                  style: AppStyles
                                                      .getHeaderNameText(
                                                      color: Colors.white,
                                                      size: 17),
                                                ))),
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
                                                  dorezoNeDepo(widget.orders![index]
                                                      .orderNumber);
                                                  swipeActionController.closeAllOpenCell();
                                                },
                                                child: Text(
                                                  "Po",
                                                  style: AppStyles
                                                      .getHeaderNameText(
                                                      color: Colors.white,
                                                      size: 17),
                                                ))),
                                      ],
                                    )
                                  ],
                                ),
                                170.0);
                          },
                          content: Container(
                              height: 120,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20)),
                                  color: AppColors.bottomColorTwo),
                              child: Center(
                                  child: Text(
                                    "Dorzo ne depo",
                                    style: AppStyles.getHeaderNameText(
                                        color: Colors.white, size: 15.0),
                                  ))),
                          color: Colors.transparent),
                    ]:[],
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 21,
                        right: 21,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          leftSideOrder(
                            context,height: 90,
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
                                        color: Colors.blueGrey[500],fontWeight: FontWeight.w600,
                                        size: 16.0),
                                  ),
                                  Text(
                                    "Produkti: ${order.orderName!}",
                                    style: AppStyles.getHeaderNameText(
                                        color: AppColors.orderDescColor,
                                        size: 16.0),
                                  ),
                                  Text(
                                    "Adresa: ${order.sender!.address!}",
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
                                height: 90,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20)),
                                    color: AppColors.bottomColorTwo),
                                child: Center(
                                  child: Text(
                                    getOrderStatus(widget.orders![index].status.toString()),
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
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: widget.orders!.length,
      );

  filtro(emri) {
    setState(() {
      widget.orders = [];
    });

    for (int i = 0; i < ordersFilter.length; i++) {
      if (ordersFilter[i]
          .orderNumber!
          .toUpperCase()
          .contains(emri.toUpperCase())) {
        setState(() {
          widget.orders!.add(ordersFilter[i]);
        });
      }
      else if (ordersFilter[i]
          .orderName!
          .toUpperCase()
          .contains(emri.toUpperCase())) {

       setState(() {
         widget.orders!.add(ordersFilter[i]);
       });

      }
    }
  }
}
