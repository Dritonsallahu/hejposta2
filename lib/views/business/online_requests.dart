import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:flutter_swipe_action_cell/core/controller.dart';
import 'package:hejposta/controllers/client_orders_controller.dart';
import 'package:hejposta/controllers/offer_controller.dart';
import 'package:hejposta/controllers/online_request_controller.dart';
import 'package:hejposta/models/order_history_model.dart';
import 'package:hejposta/models/order_model.dart';
import 'package:hejposta/models/order_request_model.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/providers/offer_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/shortcuts/modals.dart';
import 'package:hejposta/shortcuts/order_form.dart';
import 'package:hejposta/views/order_comments.dart';
import 'package:hejposta/views/postman/postman_drawer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OnlineRequests extends StatefulWidget {
  final OrderModel? orderModel;
  const OnlineRequests({Key? key, this.orderModel}) : super(key: key);

  @override
  State<OnlineRequests> createState() => _OnlineRequestsState();
}

class _OnlineRequestsState extends State<OnlineRequests> {
  TextEditingController kerkoPorosine = TextEditingController();
  PageController pageController = PageController(initialPage: 0);
  SwipeActionController swipeActionController = SwipeActionController();
  int selectedIndex = 0;
  GlobalKey key = GlobalKey();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  OrderHistoryModel? orderHistoryModel;
  bool fetchingHistory = false;
  List<OrderRequestModel> _onlineRequests = [];
  ScrollController? _scrollController;
  bool filerEqualized = false;
  int deliveringStep = 0;
  String offerName = "";
  String offerId = "";
  String offerStatus = "";
  String offerPrice = "";
  String offerState = "";
  bool up = false;
  bool left = false;

  @override
  void initState() {
    getOnlineRequests();
    _scrollController = ScrollController();
    getOffers();
    super.initState();
  }

  getOnlineRequests() {
    setState(() {
      fetchingHistory = true;
    });
    OnlineRequestController onlineRequestController = OnlineRequestController();
    onlineRequestController.getOnlineRequests(context).then((value){
      if(value == "failed"){
        showMessageModal(context, "Ka ndodhur nje problem!\nJu lutem kontaktoni administraten per informata shtese.", 14.0);
      }
      else{
        try{
         setState(() {
           _onlineRequests = value as List<OrderRequestModel>;
         });
        }
        catch(e){
          showMessageModal(context, "Ka ndodhur nje problem!\nJu lutem kontaktoni administraten per informata shtese.", 14.0);
        }
      }
    }).whenComplete(() {
      setState(() {
        fetchingHistory = false;
      });
    });
  }
  getOffers(){
    OfferController offerController = OfferController();
    offerController.getOffers(context);
  }

  anuloKerkesen(id){
    OnlineRequestController onlineRequestController = OnlineRequestController();
    onlineRequestController.rejectRequest(context, id).then((value){
      if(value == "success"){
        getOnlineRequests();
      }
      else if(value == "failed"){
        showMessageModal(context, "Refuzimi kerkeses deshtoi!", 17.0);
      }
      Navigator.pop(
          context);
    });
  }

  zgjidhOfferten(id,state){
    var offers = Provider.of<OfferProvider>(context,listen: false);
    if(offers.getOfferByState(state).isNotEmpty){
      setState(() {
        offerName = offers.getOfferByState(state).elementAt(0).offerName!;
        offerId = offers.getOfferByState(state).elementAt(0).id!;
        offerPrice = offers.getOfferByState(state).elementAt(0).price!;
        offerStatus = offers.getOfferByState(state).elementAt(0).status!;
        offerState = offers.getOfferByState(state).elementAt(0).state!;
      });
    }

    print(offers.getOfferByState(state).length);
    showModalOne(context, Column(
      children: [
        Container(
          height: 250,
          child: CupertinoPicker.builder(itemExtent: 35.0, onSelectedItemChanged: (value){
            setState(() {
              offerName = offers.getOfferByState(state).elementAt(value).offerName!;
              offerId = offers.getOfferByState(state).elementAt(value).id!;
              offerPrice = offers.getOfferByState(state).elementAt(value).price!;
              offerStatus = offers.getOfferByState(state).elementAt(value).status!;
              offerState = offers.getOfferByState(state).elementAt(value).state!;
            });
          }, itemBuilder: (context, index){
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(offers.getOfferByState(state).elementAt(index).offerName!),
              ],
            );
          },childCount: offers.getOfferByState(state).length,),
        ),

        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                height: 50,
                width:
                getPhoneWidth(context) /
                    2 -
                    60,
                decoration: BoxDecoration(
                    color: Colors.blueGrey[200],
                    borderRadius:
                    BorderRadius
                        .circular(10)),
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(
                          context);
                    },
                    child: Text(
                      "Largo",
                      style: AppStyles
                          .getHeaderNameText(
                          color: Colors
                              .white,
                          size: 17),
                    ))),
            Container(
                height: 50,
                width:
                getPhoneWidth(context) /
                    2 -
                    60,
                decoration: BoxDecoration(
                    color: AppColors.bottomColorTwo,
                    borderRadius:
                    BorderRadius
                        .circular(10)),
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(
                          context);
                      pranoKerkesen(id,offerState,offerPrice,offerName,offerStatus);
                    },
                    child: Text(
                      "Bej porosine",
                      style: AppStyles
                          .getHeaderNameText(
                          color: Colors
                              .white,
                          size: 17),
                    ))),
          ],
        )
      ],
    ),
        340.0);
  }
  pranoKerkesen(id,state,price,name,status){
    OnlineRequestController onlineRequestController = OnlineRequestController();
    onlineRequestController.acceptRequest(context, id,name,price,status).then((value){
      if(value == "success"){
        getOnlineRequests();
      }
      else if(value == "failed"){
        showMessageModal(context, "Refuzimi kerkeses deshtoi!", 17.0);
      }
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
                height: getPhoneHeight(context) -
                MediaQuery.of(context).viewPadding.top,
                child: Column(
                  children: [
                    SizedBox(
                      height: getPhoneHeight(context) -
                          MediaQuery.of(context).viewPadding.top  ,
                      child:   Column(
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 40,
                                      child: IconButton(
                                          padding: const EdgeInsets.all(0),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(
                                            Icons.arrow_back,
                                            size: 25,
                                            color: Colors.white,
                                          )),
                                    ),
                                    Container(
                                      width: getPhoneWidth(context) - 88,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(20),
                                          border: Border.all(
                                              color: Colors.white)),
                                      child: Row(
                                        children: [
                                          SizedBox(

                                              width:
                                              getPhoneWidth(context) -
                                                  110,
                                              child: TextField(
                                                controller: kerkoPorosine,
                                                onChanged: (value) {

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

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                                height: getPhoneHeight(context) - MediaQuery.of(context).padding.top - 150,
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    getOnlineRequests();
                                  },
                                  child: fetchingHistory
                                      ? ListView(
                                    children: const [
                                      Center(
                                          child:
                                          CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 1.4,
                                          )),
                                    ],
                                  )
                                      : _onlineRequests.isEmpty
                                      ? Center(
                                      child: Text(
                                        "Nuk keni asnje porosi",
                                        textAlign: TextAlign.center,
                                        style:
                                        AppStyles.getHeaderNameText(
                                            color: Colors.white,
                                            size: 13.0),
                                      ))
                                      : ListView.builder(
                                    padding: const EdgeInsets.only(top: 10),
                                    itemBuilder: (context, index) {

                                      return Column(
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                left: 21,
                                                right: 21,
                                                bottom: 7),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                SizedBox(
                                                  width:
                                                  getPhoneWidth(
                                                      context),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .only(
                                                            left: 10,
                                                            bottom:
                                                            3),
                                                        child:
                                                        SizedBox(
                                                          child: Text(
                                                            DateFormat(
                                                                "yyyy-MM-dd  HH:mm")
                                                                .format(
                                                                DateTime.parse(_onlineRequests[index].createdAt!))
                                                                .toString(),
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: AppStyles.getHeaderNameText(
                                                                color: Colors
                                                                    .white,
                                                                size:
                                                                14.0,
                                                                fontWeight:
                                                                FontWeight.w600),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                          padding: const EdgeInsets
                                                              .only(
                                                              right:
                                                              15,
                                                              bottom:
                                                              0),
                                                          height: 17,
                                                          child: Text(
                                                            _onlineRequests[index]
                                                                .productName!,
                                                            style: AppStyles.getHeaderNameText(
                                                                color: Colors
                                                                    .white,
                                                                size:
                                                                15.0),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                SwipeActionCell(
                                                  controller:
                                                  swipeActionController,
                                                  key: ObjectKey(
                                                      index),
                                                  backgroundColor:
                                                  Colors
                                                      .transparent,

                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      leftSideOrder(
                                                          context,
                                                          GestureDetector(
                                                            onTap:
                                                                () {

                                                            },
                                                            child:
                                                            Container(
                                                              padding:
                                                              const EdgeInsets.symmetric(horizontal: 10),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                  const BorderRadius.only(topLeft: Radius.circular(17), bottomLeft: Radius.circular(17)),
                                                                  border: Border.all(color: AppColors.bottomColorOne)),
                                                              child:
                                                              Column(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    "Klienti: ${_onlineRequests[index].client.toString()} ",
                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: AppStyles.getHeaderNameText(color: Colors.grey[800], size: 15.0),
                                                                  ),
                                                                  Text(
                                                                    "Produkti: ${_onlineRequests[index].productName!}",
                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: AppStyles.getHeaderNameText(color: Colors.grey[800], size: 15.0),
                                                                  ),
                                                                  Text(
                                                                    "Adresa: ${_onlineRequests[index].address}",
                                                                    maxLines: 2,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: AppStyles.getHeaderNameText(color: Colors.grey[800], size: 15.0),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          height: 85),
                                                      GestureDetector(
                                                        onTap: () {
                                                          showModalBottomSheet(context: context, builder: (context){
                                                            return Container(
                                                              width: getPhoneWidth(context),
                                                              height: getPhoneHeight(context)*0.9,
                                                              child: SingleChildScrollView(
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    const SizedBox(height: 10,),
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                      child: Row(

                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          SizedBox(width: 40,),
                                                                          Text("${_onlineRequests[index].productName}",style: AppStyles.getHeaderNameText(color: Colors.black,size: 20.0),),
                                                                          SizedBox(width: 40,child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close)),),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                                                                      child: Text("Emri mbiemri",style: AppStyles.getHeaderNameText(color: Colors.blueGrey,size: 15.5),),
                                                                    ),
                                                                    Container(
                                                                      width: getPhoneWidth(context),
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                      child: TextField(
                                                                        readOnly: true,
                                                                        controller: TextEditingController(text: _onlineRequests[index].fullName),
                                                                        decoration: InputDecoration(
                                                                          border: InputBorder.none,
                                                                          enabledBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            borderSide: BorderSide(color: Colors.blueGrey[400]!)
                                                                          ),
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              borderSide: BorderSide(color: Colors.blueGrey[400]!)
                                                                          ),
                                                                          contentPadding: const EdgeInsets.symmetric(vertical: 4,horizontal: 15)
                                                                        ),
                                                                      ),

                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                                                                      child: Text("Adresa elektronike",style: AppStyles.getHeaderNameText(color: Colors.blueGrey,size: 15.5),),
                                                                    ),
                                                                    Container(
                                                                      width: getPhoneWidth(context),
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                      child: TextField(
                                                                        readOnly: true,
                                                                        controller: TextEditingController(text: _onlineRequests[index].email),
                                                                        decoration: InputDecoration(
                                                                          border: InputBorder.none,
                                                                          enabledBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            borderSide: BorderSide(color: Colors.blueGrey[400]!)
                                                                          ),
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              borderSide: BorderSide(color: Colors.blueGrey[400]!)
                                                                          ),
                                                                          contentPadding: const EdgeInsets.symmetric(vertical: 4,horizontal: 15)
                                                                        ),
                                                                      ),

                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                                                                      child: Text("Adresa",style: AppStyles.getHeaderNameText(color: Colors.blueGrey,size: 15.5),),
                                                                    ),
                                                                    Container(
                                                                      width: getPhoneWidth(context),
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                      child: TextField(
                                                                        readOnly: true,
                                                                        controller: TextEditingController(text: _onlineRequests[index].address),
                                                                        decoration: InputDecoration(
                                                                          border: InputBorder.none,
                                                                          enabledBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            borderSide: BorderSide(color: Colors.blueGrey[400]!)
                                                                          ),
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              borderSide: BorderSide(color: Colors.blueGrey[400]!)
                                                                          ),
                                                                          contentPadding: const EdgeInsets.symmetric(vertical: 4,horizontal: 15)
                                                                        ),
                                                                      ),

                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                                                                      child: Text("Qyteti",style: AppStyles.getHeaderNameText(color: Colors.blueGrey,size: 15.5),),
                                                                    ),
                                                                    Container(
                                                                      width: getPhoneWidth(context),
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                      child: TextField(
                                                                        readOnly: true,
                                                                        controller: TextEditingController(text: _onlineRequests[index].city),
                                                                        decoration: InputDecoration(
                                                                          border: InputBorder.none,
                                                                          enabledBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            borderSide: BorderSide(color: Colors.blueGrey[400]!)
                                                                          ),
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              borderSide: BorderSide(color: Colors.blueGrey[400]!)
                                                                          ),
                                                                          contentPadding: const EdgeInsets.symmetric(vertical: 4,horizontal: 15)
                                                                        ),
                                                                      ),

                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                                                                      child: Text("Shteti",style: AppStyles.getHeaderNameText(color: Colors.blueGrey,size: 15.5),),
                                                                    ),
                                                                    Container(
                                                                      width: getPhoneWidth(context),
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                      child: TextField(
                                                                        readOnly: true,
                                                                        controller: TextEditingController(text: _onlineRequests[index].state),
                                                                        decoration: InputDecoration(
                                                                          border: InputBorder.none,
                                                                          enabledBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            borderSide: BorderSide(color: Colors.blueGrey[400]!)
                                                                          ),
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              borderSide: BorderSide(color: Colors.blueGrey[400]!)
                                                                          ),
                                                                          contentPadding: const EdgeInsets.symmetric(vertical: 4,horizontal: 15)
                                                                        ),
                                                                      ),

                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                                                                      child: Text("Numri telefonit",style: AppStyles.getHeaderNameText(color: Colors.blueGrey,size: 15.5),),
                                                                    ),
                                                                    Container(
                                                                      width: getPhoneWidth(context),
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                      child: TextField(
                                                                        readOnly: true,
                                                                        controller: TextEditingController(text: _onlineRequests[index].phoneNumber),
                                                                        decoration: InputDecoration(
                                                                          border: InputBorder.none,
                                                                          enabledBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            borderSide: BorderSide(color: Colors.blueGrey[400]!)
                                                                          ),
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              borderSide: BorderSide(color: Colors.blueGrey[400]!)
                                                                          ),
                                                                          contentPadding: const EdgeInsets.symmetric(vertical: 4,horizontal: 15)
                                                                        ),
                                                                      ),

                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                                                                      child: Text("Pershkrimi",style: AppStyles.getHeaderNameText(color: Colors.blueGrey,size: 15.5),),
                                                                    ),
                                                                    Container(
                                                                      width: getPhoneWidth(context),
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                      child: TextField(
                                                                        readOnly: true,
                                                                        controller: TextEditingController(text: _onlineRequests[index].comment),
                                                                        decoration: InputDecoration(
                                                                          border: InputBorder.none,
                                                                          enabledBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            borderSide: BorderSide(color: Colors.blueGrey[400]!)
                                                                          ),
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              borderSide: BorderSide(color: Colors.blueGrey[400]!)
                                                                          ),
                                                                          contentPadding: const EdgeInsets.symmetric(vertical: 4,horizontal: 15)
                                                                        ),
                                                                      ),

                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                                                                      child: Text("Sasia",style: AppStyles.getHeaderNameText(color: Colors.blueGrey,size: 15.5),),
                                                                    ),
                                                                    Container(
                                                                      width: getPhoneWidth(context),
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                      child: TextField(
                                                                        readOnly: true,
                                                                        controller: TextEditingController(text: _onlineRequests[index].qty.toString()),
                                                                        decoration: InputDecoration(
                                                                          border: InputBorder.none,
                                                                          enabledBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            borderSide: BorderSide(color: Colors.blueGrey[400]!)
                                                                          ),
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              borderSide: BorderSide(color: Colors.blueGrey[400]!)
                                                                          ),
                                                                          contentPadding: const EdgeInsets.symmetric(vertical: 4,horizontal: 15)
                                                                        ),
                                                                      ),

                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                                                                      child: Text("Cmimi",style: AppStyles.getHeaderNameText(color: Colors.blueGrey,size: 15.5),),
                                                                    ),
                                                                    Container(
                                                                      width: getPhoneWidth(context),
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                      child: TextField(
                                                                        readOnly: true,
                                                                        controller: TextEditingController(text: _onlineRequests[index].productName),
                                                                        decoration: InputDecoration(
                                                                          border: InputBorder.none,
                                                                          enabledBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            borderSide: BorderSide(color: Colors.blueGrey[400]!)
                                                                          ),
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              borderSide: BorderSide(color: Colors.blueGrey[400]!)
                                                                          ),
                                                                          contentPadding: const EdgeInsets.symmetric(vertical: 4,horizontal: 15)
                                                                        ),
                                                                      ),

                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                                                                      child: Text("Te hapet",style: AppStyles.getHeaderNameText(color: Colors.blueGrey,size: 15.5),),
                                                                    ),
                                                                    Container(
                                                                      width: getPhoneWidth(context),
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                      child: TextField(
                                                                        readOnly: true,
                                                                        controller: TextEditingController(text: _onlineRequests[index].open == true ? "Po":"Jo"),
                                                                        decoration: InputDecoration(
                                                                          border: InputBorder.none,
                                                                          enabledBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            borderSide: BorderSide(color: Colors.blueGrey[400]!)
                                                                          ),
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              borderSide: BorderSide(color: Colors.blueGrey[400]!)
                                                                          ),
                                                                          contentPadding: const EdgeInsets.symmetric(vertical: 4,horizontal: 15)
                                                                        ),
                                                                      ),

                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                                                                      child: Text("E thyeshme",style: AppStyles.getHeaderNameText(color: Colors.blueGrey,size: 15.5),),
                                                                    ),
                                                                    Container(
                                                                      width: getPhoneWidth(context),
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                      child: TextField(
                                                                        readOnly: true,
                                                                        controller: TextEditingController(text: _onlineRequests[index].brake == true ? "Po":"Jo"),
                                                                        decoration: InputDecoration(
                                                                          border: InputBorder.none,
                                                                          enabledBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            borderSide: BorderSide(color: Colors.blueGrey[400]!)
                                                                          ),
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              borderSide: BorderSide(color: Colors.blueGrey[400]!)
                                                                          ),
                                                                          contentPadding: const EdgeInsets.symmetric(vertical: 4,horizontal: 15)
                                                                        ),
                                                                      ),

                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                                                                      child: Text("Ndrrim",style: AppStyles.getHeaderNameText(color: Colors.blueGrey,size: 15.5),),
                                                                    ),
                                                                    Container(
                                                                      width: getPhoneWidth(context),
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                      child: TextField(
                                                                        readOnly: true,
                                                                        controller: TextEditingController(text: _onlineRequests[index].change == true ? "Po":"Jo"),
                                                                        decoration: InputDecoration(
                                                                          border: InputBorder.none,
                                                                          enabledBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            borderSide: BorderSide(color: Colors.blueGrey[400]!)
                                                                          ),
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              borderSide: BorderSide(color: Colors.blueGrey[400]!)
                                                                          ),
                                                                          contentPadding: const EdgeInsets.symmetric(vertical: 4,horizontal: 15)
                                                                        ),
                                                                      ),

                                                                    ),

                                                                    const SizedBox(height: 20,),
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap: (){
                                                                              Navigator.of(context).pop();
                                                                              showModalOne(
                                                                                  context,
                                                                                  StatefulBuilder(builder: (context,setter){
                                                                                    return Column(
                                                                                      mainAxisAlignment:
                                                                                      MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Column(
                                                                                          children: [
                                                                                            Text(
                                                                                              "Deshironi ta anuloni kete porosi ?",
                                                                                              style: AppStyles
                                                                                                  .getHeaderNameText(
                                                                                                  color: Colors
                                                                                                      .blueGrey[800],
                                                                                                  size: 17),
                                                                                            ),
                                                                                            const SizedBox(
                                                                                              height: 10,
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
                                                                                                getPhoneWidth(context) /
                                                                                                    2 -
                                                                                                    80,
                                                                                                decoration: BoxDecoration(
                                                                                                    color: Colors.blueGrey,
                                                                                                    borderRadius:
                                                                                                    BorderRadius
                                                                                                        .circular(100)),
                                                                                                child: TextButton(
                                                                                                    onPressed: () {
                                                                                                      Navigator.of(context).pop();
                                                                                                    },
                                                                                                    child: Text(
                                                                                                      "Jo",
                                                                                                      style: AppStyles
                                                                                                          .getHeaderNameText(
                                                                                                          color: Colors
                                                                                                              .white,
                                                                                                          size: 17),
                                                                                                    ))),
                                                                                            Container(
                                                                                                height: 40,
                                                                                                width:
                                                                                                getPhoneWidth(context) /
                                                                                                    2 -
                                                                                                    80,
                                                                                                decoration: BoxDecoration(
                                                                                                    color: Colors.blueGrey,
                                                                                                    borderRadius:
                                                                                                    BorderRadius
                                                                                                        .circular(100)),
                                                                                                child: TextButton(
                                                                                                    onPressed: () {

                                                                                                      anuloKerkesen(_onlineRequests[index].id);
                                                                                                    },
                                                                                                    child: Text(
                                                                                                      "Po",
                                                                                                      style: AppStyles
                                                                                                          .getHeaderNameText(
                                                                                                          color: Colors
                                                                                                              .white,
                                                                                                          size: 17),
                                                                                                    ))),
                                                                                          ],
                                                                                        )
                                                                                      ],
                                                                                    );
                                                                                  }),
                                                                                  150.0);
                                                                            },
                                                                            child: Container(
                                                                              width: getPhoneWidth(context)/2 -30,
                                                                              height: 45,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                color: Colors.redAccent,
                                                                              ),
                                                                              child: Center(child: Text("Refuzo",style: AppStyles.getHeaderNameText(color: Colors.white,size: 16.0),)),
                                                                            ),
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap: (){
                                                                              Navigator.of(context).pop();
                                                                              showModalOne(
                                                                                  context,
                                                                              StatefulBuilder(builder: (context,setter){
                                                                                return Column(
                                                                                  mainAxisAlignment:
                                                                                  MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Column(
                                                                                      children: [
                                                                                        Text(
                                                                                          "Deshironi te pranoni kete porosi ?",
                                                                                          style: AppStyles
                                                                                              .getHeaderNameText(
                                                                                              color: Colors
                                                                                                  .blueGrey[800],
                                                                                              size: 17),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 10,
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
                                                                                            getPhoneWidth(context) /
                                                                                                2 -
                                                                                                80,
                                                                                            decoration: BoxDecoration(
                                                                                                color: Colors.blueGrey,
                                                                                                borderRadius:
                                                                                                BorderRadius
                                                                                                    .circular(100)),
                                                                                            child: TextButton(
                                                                                                onPressed: () {
                                                                                                  Navigator.pop(
                                                                                                      context);
                                                                                                },
                                                                                                child: Text(
                                                                                                  "Jo",
                                                                                                  style: AppStyles
                                                                                                      .getHeaderNameText(
                                                                                                      color: Colors
                                                                                                          .white,
                                                                                                      size: 17),
                                                                                                ))),
                                                                                        Container(
                                                                                            height: 40,
                                                                                            width:
                                                                                            getPhoneWidth(context) /
                                                                                                2 -
                                                                                                80,
                                                                                            decoration: BoxDecoration(
                                                                                                color: Colors.blueGrey,
                                                                                                borderRadius:
                                                                                                BorderRadius
                                                                                                    .circular(100)),
                                                                                            child: TextButton(
                                                                                                onPressed: () {
                                                                                                  Navigator.pop(
                                                                                                      context);
                                                                                                  zgjidhOfferten(_onlineRequests[index].id,_onlineRequests[index].state);
                                                                                                },
                                                                                                child: Text(
                                                                                                  "Po",
                                                                                                  style: AppStyles
                                                                                                      .getHeaderNameText(
                                                                                                      color: Colors
                                                                                                          .white,
                                                                                                      size: 17),
                                                                                                ))),
                                                                                      ],
                                                                                    )
                                                                                  ],
                                                                                );
                                                                              }),

                                                                                  150.0);
                                                                            },
                                                                            child: Container(
                                                                              width: getPhoneWidth(context)/2 -30,
                                                                              height: 45,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                color: AppColors.bottomColorTwo,
                                                                              ),
                                                                              child: Center(child: Text("Aprovo",style: AppStyles.getHeaderNameText(color: Colors.white,size: 16.0),)),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    const SizedBox(height: 40,),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },isScrollControlled: true);
                                                        },
                                                        child:
                                                        Container(
                                                          color: Colors
                                                              .transparent,
                                                          child:
                                                          Stack(
                                                            children: [
                                                              Container(
                                                                width:
                                                                getPhoneWidth(context) * 0.3 - 25,
                                                                height:
                                                                85,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                                                                    color: AppColors.bottomColorTwo),
                                                                child:
                                                                Center(
                                                                  child:
                                                                  Text(
                                                                     "Ne pritje",
                                                                    textAlign: TextAlign.center,
                                                                    style: AppStyles.getHeaderNameText(color: Colors.white, size: 15.0),
                                                                  ),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                  right:
                                                                  -2,
                                                                  top:
                                                                  10,
                                                                  child: SizedBox(
                                                                      height: 60,
                                                                      child: Image.asset(
                                                                        "assets/icons/8.png",
                                                                        color: Colors.white.withOpacity(0.7),
                                                                      ))),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    itemCount: _onlineRequests.length,
                                  ),
                                ),
                              ),
                        ],
                      )
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

  replyTextBasedOnStatus(status) {
    print(status);
    if (status == "pending") {
      return "Porosia ne pritje";
    } else if (status == "accepted") {
      return "Porosia tek postieri";
    } else if (status == "in_warehouse") {
      return "Porosia ne depo";
    } else if (status == "delivering") {
      return "Porosia ne dergese";
    }else if (status == "returned") {
      return "Porosia eshte kthyer";
    }else if (status == "returning_to_warehouse") {
      return "Porosia ne kthim per depo";
    } else if (status == "delivered") {
      return "Porosia e dorezuar";
    } else {
      return "No data";
    }
  }

  parseDate(String date) {
    var parsedDate = DateFormat("yyyy-MM-dd HH:mm:ss")
        .format(DateTime.parse(date).add(const Duration(hours: 2)));
    return parsedDate;
  }
}
