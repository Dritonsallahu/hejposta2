
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hejposta/controllers/buyer_controller.dart';
import 'package:hejposta/controllers/city_controller.dart';
import 'package:hejposta/controllers/client_orders_controller.dart';
import 'package:hejposta/controllers/offer_controller.dart';
import 'package:hejposta/controllers/product_controller.dart';
import 'package:hejposta/controllers/unit_controller.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/buyer_provider.dart';
import 'package:hejposta/providers/city_provider.dart';
import 'package:hejposta/providers/connection_provider.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/providers/offer_provider.dart';
import 'package:hejposta/providers/product_provider.dart';
import 'package:hejposta/providers/unit_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/shortcuts/modals.dart';
import 'package:hejposta/shortcuts/urls.dart';
import 'package:hejposta/views/postman/postman_drawer.dart';
import 'package:provider/provider.dart';

class NewOrder extends StatefulWidget {
  const NewOrder({super.key});

  @override
  State<NewOrder> createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrder> {
  TextEditingController emriProduktit = TextEditingController();
  TextEditingController blersi = TextEditingController();
  TextEditingController shteti = TextEditingController();
  TextEditingController qyteti = TextEditingController();
  TextEditingController qmimi = TextEditingController();
  TextEditingController sasia = TextEditingController();
  TextEditingController oferta = TextEditingController();
  TextEditingController offerId = TextEditingController();
  TextEditingController unit = TextEditingController();
  TextEditingController unitId = TextEditingController();
  TextEditingController adresa = TextEditingController();
  TextEditingController nrTel = TextEditingController();
  TextEditingController pershkrimi = TextEditingController();
  PageController pageController = PageController(initialPage: 0);

  // If one of the clients from the list is chosen
  String clientId = "";
  String productId = "";

  FixedExtentScrollController fixedScrollController =
      FixedExtentScrollController();

  GlobalKey key = GlobalKey();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  List<String> qytetet = [];

  bool isOpen = true;
  bool isbrokable = false;
  bool isChange = false;

  List<String> shtetet = [
    'Kosovë',
    'Maqedonia',
    'Shqipëri',
  ];

  bool requesting = false;
  bool requestingClient = false;

  bool emriProduktitEmpty = false;
  bool blersiEmpty = false;
  bool shtetiEmpty = false;
  bool qytetiEmpty = false;
  bool qmimiEmpty = false;
  bool sasiaEmpty = false;
  bool adresaEmpty = false;
  bool nrTelEmpty = false;
  bool pershkrimiEmpty = false;
  bool ofertaEmpty = false;
  bool unitEmpty = false;

  StateSetter? _setter;

  searchUser(text) {}

  searchUProduct(text) {
    var products = Provider.of<ProductProvider>(context);
    products.filtro(text);
  }

  newOrder() {
    setState(() {
      requesting = true;
    });
    var network = Provider.of<ConnectionProvider>(context, listen: false);
    if (emriProduktit.text.isEmpty) {
      setState(() {
        emriProduktitEmpty = true;
        requesting = false;
        print("1");
      });
    }
    if (blersi.text.isEmpty) {
      setState(() {
        blersiEmpty = true;
        requesting = false;
        print("2");
      });
    }
    if (emriProduktit.text.isEmpty) {
      setState(() {
        emriProduktitEmpty = true;
        requesting = false;
        print("3");
      });
    }
    if (blersi.text.isEmpty) {
      setState(() {
        blersiEmpty = true;
        requesting = false;
        print("4");
      });
    }
    if (shteti.text.isEmpty) {
      setState(() {
        shtetiEmpty = true;
        requesting = false;
        print("5");
      });
    }
    if (qyteti.text.isEmpty) {
      setState(() {
        qytetiEmpty = true;
        requesting = false;
        print("6");
      });
    }
    if (qmimi.text.isEmpty) {
      setState(() {
        qmimiEmpty = true;
        requesting = false;
        print("7");
      });
    }
    if (sasia.text.isEmpty) {
      setState(() {
        sasiaEmpty = true;
        requesting = false;
        print("8");
      });
    }
    if (adresa.text.isEmpty) {
      setState(() {
        adresaEmpty = true;
        requesting = false;
        print("9");
      });
    }
    if (nrTel.text.isEmpty) {
      setState(() {
        nrTelEmpty = true;
        requesting = false;
        print("10");
      });
    }
    if (oferta.text.isEmpty) {
      setState(() {
        ofertaEmpty = true;
        requesting = false;
        print("12");
      });
    }
    if (unit.text.isEmpty) {
      setState(() {
        unitEmpty = true;
        requesting = false;
        print("13");
      });
    }

    if (network.getConnectionType() == ConnectionType.disconnected) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23)),
              title: Center(
                  child: Text(
                "Nuk jeni kyqur ne rrjet!",
                style: AppStyles.getHeaderNameText(
                    color: Colors.blueGrey, size: 16.0),
              )),
              actions: [
                Center(
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Largo",
                          style: AppStyles.getHeaderNameText(
                              color: Colors.blueGrey, size: 14.0),
                        )))
              ],
            );
          });
    } else {
      if (emriProduktit.text.isNotEmpty &&
          blersi.text.isNotEmpty &&
          emriProduktit.text.isNotEmpty &&
          blersi.text.isNotEmpty &&
          shteti.text.isNotEmpty &&
          qyteti.text.isNotEmpty &&
          sasia.text.isNotEmpty &&
          qmimi.text.isNotEmpty &&
          adresa.text.isNotEmpty &&
          oferta.text.isNotEmpty &&
          unit.text.isNotEmpty &&
          nrTel.text.isNotEmpty) {
        ClientOrdersController clientOrdersController =
            ClientOrdersController();
        clientOrdersController
            .newOrder(
                context,
                emriProduktit.text,
                blersi.text,
                shteti.text,
                qyteti.text,
                qmimi.text,
                sasia.text,
                offerId.text,
                unitId.text,
                adresa.text,
                nrTel.text,
                pershkrimi.text,
                isOpen,
                isbrokable,
                isChange,
                productId,clientId)
            .then((value) {
          if (value == "success") {
            showModalOne(
                context,
                Column(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Porosia juaj u regjistrua me sukses",
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
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                      24,
                    )),
                    title: Center(
                      child: Text(
                        "Shtimi i porosise deshtoi",
                        style: AppStyles.getHeaderNameText(
                          color: Colors.blueGrey[400],
                          size: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
                              color: Colors.blueGrey[400], size: 13.0),
                        ),
                      )),
                    ],
                  );
                });
          }
        }).whenComplete(() {

          setState(() {
            requesting = false;
          });
        });
      }

      else{
        showMessageModal(context, "Ju lutem plotesoni te gjitha fushat obligative", 17.0);
      }
    }
  }

  getQytetet() {
    CityController cityController = CityController();
    cityController.getQytetet(context);
  }

  getOffers() {
    OfferController offerController = OfferController();
    offerController.getOffers(context);
  }

  getUnits() {
    UnitController unitController = UnitController();
    unitController.getUnits(context);
  }

  getProducts() {
    ProductController productController = ProductController();
    productController.getProducts(context);
  }

  getBuyers() {
    BuyerController buyerController = BuyerController();
    buyerController.getBuyer(context);
  }

  addBuyer() {

    setState(() {
      requesting = true;
    });
    BuyerController buyerController = BuyerController();
    if (
        clientId.isEmpty &&
        blersi.text.isNotEmpty &&
        shteti.text.isNotEmpty &&
        qyteti.text.isNotEmpty &&
        adresa.text.isNotEmpty &&
        nrTel.text.isNotEmpty) {
      buyerController
          .addBuyer(context, clientId, blersi.text, adresa.text, qyteti.text,
          shteti.text, nrTel.text).then((value) {
            if(value == "success" && value != null){
              showModalOne(
                  context,
                  Column(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Bleresi i ri u shtua me sukses.",
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
            else if(value != "success" && value != null){
              showModalOne(
                  context,
                  Column(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            value,
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

      })
          .whenComplete(() {

        setState(() {
          requesting = false;
        });
      });
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
                    "Ju lutem plotesoni te gjitha fushat!",
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

  }

  @override
  void initState() {
    getOffers();
    getUnits();
    getQytetet();
    getProducts();
    getBuyers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var generalProvider = Provider.of<GeneralProvider>(context);
    var products = Provider.of<ProductProvider>(context);
    var buyers = Provider.of<BuyerProvider>(context);
    var qytetet = Provider.of<CityProvier>(context);
    var ofertat = Provider.of<OfferProvider>(context);
    var njesite = Provider.of<UnitProvider>(context);
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
              SizedBox(
                width: getPhoneWidth(context),
                height: getPhoneHeight(context) - 65,
                child: Image.asset(
              "assets/icons/map-icon.png",
              color: AppColors.mapColorFirst,
              filterQuality: FilterQuality.high,
              fit: BoxFit.cover,
                ),
              ),
              Positioned(child:  GestureDetector(
                onTap: () {
                  // call this method here to hide soft keyboard
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: SizedBox(
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
                              "Porosi e re",
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
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                            width: getPhoneWidth(context),
                            height: 50,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20)),
                                color: Colors.white),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: getPhoneWidth(context) - 120,
                                  child: TextField(
                                    controller: emriProduktit,
                                    onChanged: (value){
                                      setState(() {
                                        productId = "";
                                      });
                                    },
                                    decoration: InputDecoration(
                                        hintText: "Emri i produktit",
                                        hintStyle: AppStyles.getHeaderNameText(
                                            color: emriProduktitEmpty
                                                ? Colors.red
                                                : Colors.grey[900],
                                            size: 15.0),
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
                                        contentPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10)),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return StatefulBuilder(
                                              builder: (context, setter) {
                                                _setter = setter;
                                                return Container(
                                                  width: getPhoneWidth(context),
                                                  color: Colors.white,
                                                  child: ListView(
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 20,
                                                            vertical: 10),
                                                        child: TextField(
                                                          onChanged: (value) {
                                                            _setter!(() {});
                                                            products.filtro(value);
                                                          },
                                                          decoration: InputDecoration(
                                                              hintText: "Kerko",
                                                              border:
                                                              InputBorder.none,
                                                              isDense: true,
                                                              contentPadding:
                                                              const EdgeInsets.symmetric(
                                                                  horizontal: 20,
                                                                  vertical: 12),
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                  BorderRadius.circular(
                                                                      8),
                                                                  borderSide: BorderSide(
                                                                      color: Colors.grey[
                                                                      500]!)),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                  BorderRadius.circular(
                                                                      8),
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .grey[500]!))),
                                                        ),
                                                      ),
                                                      ListView.builder(
                                                        physics:
                                                        const ScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                sasia.text = "";
                                                                emriProduktit.text =
                                                                products.getProducts()[index].productName!;
                                                                emriProduktitEmpty = false;
                                                                qmimi.text = products.getProducts()[index].price!.toString();
                                                                qmimiEmpty = false;
                                                                productId = products.getProducts()[index].id;
                                                              });

                                                              products.setCheck(products.getProducts()[index].id, true);

                                                              products.filtro("");
                                                              Navigator.pop(context);
                                                            },
                                                            child: Container(
                                                              width: getPhoneWidth(
                                                                  context),
                                                              height: 60,
                                                              color:
                                                              Colors.transparent,
                                                              padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 20,
                                                                  vertical: 5),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                            10),
                                                                        child:
                                                                        Container(
                                                                          width: 55,
                                                                          height: 55,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius:
                                                                              BorderRadius.circular(
                                                                                  9),
                                                                              color: Colors
                                                                                  .grey[200]),
                                                                          child: Image
                                                                              .network(
                                                                            "$imgUrl/images/${products.getProducts()[index].image}",
                                                                            fit: BoxFit
                                                                                .cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 10,
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                        children: [
                                                                          Text(
                                                                            "${products.getProducts()[index].productName}",
                                                                            style: AppStyles.getHeaderNameText(
                                                                                color: Colors.blueGrey[
                                                                                400],
                                                                                size:
                                                                                17.0),
                                                                          ),
                                                                          const SizedBox(
                                                                            height: 8,
                                                                          ),
                                                                          Text(
                                                                            "Sasia: ${products.getProducts()[index].qty}",
                                                                            style: AppStyles.getHeaderNameText(
                                                                                color: Colors.blueGrey[
                                                                                400],
                                                                                size:
                                                                                15.0),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    width: 20,
                                                                    height: 20,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                            100),
                                                                        border: Border.all(
                                                                            color: AppColors
                                                                                .bottomColorTwo)),
                                                                    padding:
                                                                    const EdgeInsets
                                                                        .all(2),
                                                                    child: products
                                                                        .getProducts()[
                                                                    index]
                                                                        .checked
                                                                        ? Container(
                                                                      width: 20,
                                                                      height:
                                                                      20,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              100),
                                                                          color:
                                                                          AppColors.bottomColorTwo),
                                                                    )
                                                                        : const SizedBox(),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        itemCount: products
                                                            .getProducts()
                                                            .length,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              });
                                        });
                                  },
                                  child: Container(
                                    width: 70,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(20)),
                                        color: AppColors.bottomColorOne),
                                    child: const Center(
                                      child: Icon(
                                        Icons.list,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                            width: getPhoneWidth(context),
                            height: 50,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20)),
                                color: Colors.white),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: getPhoneWidth(context) - 120,
                                  child: TextField(
                                    controller: blersi,
                                    onChanged: (value) {
                                      if (clientId.isNotEmpty) {
                                        setState(() {
                                          clientId = "";
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                        hintText: "Emri i pranuesit",
                                        hintStyle: AppStyles.getHeaderNameText(
                                            color: blersiEmpty
                                                ? Colors.red
                                                : Colors.grey[900],
                                            size: 15.0),
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
                                        contentPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10)),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return StatefulBuilder(
                                              builder: (context, setter) {
                                                _setter = setter;
                                                return Container(
                                                  width: getPhoneWidth(context),
                                                  color: Colors.white,
                                                  child: ListView(
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 20,
                                                            vertical: 10),
                                                        child: TextField(
                                                          onChanged: (value) {
                                                            _setter!(() {});
                                                            buyers.filtro(value);
                                                          },
                                                          decoration: InputDecoration(
                                                              hintText:
                                                              "Kerko pranuesin",
                                                              hintStyle: AppStyles.getHeaderNameText(
                                                                  color: Colors
                                                                      .blueGrey[500],
                                                                  size: 15.0),
                                                              border:
                                                              InputBorder.none,
                                                              isDense: true,
                                                              contentPadding:
                                                              const EdgeInsets.symmetric(
                                                                  horizontal: 20,
                                                                  vertical: 12),
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                  BorderRadius.circular(
                                                                      8),
                                                                  borderSide: BorderSide(
                                                                      color:
                                                                      Colors.grey[
                                                                      500]!)),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                  BorderRadius.circular(8),
                                                                  borderSide: BorderSide(color: Colors.grey[500]!))),
                                                        ),
                                                      ),
                                                      buyers.getBuyers().isEmpty
                                                          ? Center(
                                                        child: Text(
                                                          "Nuk keni asnje klient!",
                                                          style: AppStyles
                                                              .getHeaderNameText(
                                                              color: Colors
                                                                  .blueGrey[
                                                              500],
                                                              size: 15.0),
                                                        ),
                                                      )
                                                          : ListView.builder(
                                                        physics:
                                                        const ScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                blersi.text = buyers
                                                                    .getBuyers()[
                                                                index]
                                                                    .fullName!;
                                                                blersiEmpty =
                                                                false;
                                                                adresa.text = buyers
                                                                    .getBuyers()[
                                                                index]
                                                                    .address!;
                                                                adresaEmpty =
                                                                false;
                                                                nrTel.text = buyers
                                                                    .getBuyers()[
                                                                index]
                                                                    .phoneNumber!;
                                                                nrTelEmpty =
                                                                false;
                                                                shteti.text = shtetet.firstWhere((element) =>
                                                                element ==
                                                                    buyers
                                                                        .getBuyers()[
                                                                    index]
                                                                        .state!);
                                                                shtetiEmpty =
                                                                false;
                                                                qyteti.text = qytetet
                                                                    .getCitiesByState(shteti
                                                                    .text)
                                                                    .firstWhere((element) =>
                                                                element
                                                                    .name ==
                                                                    buyers
                                                                        .getBuyers()[index]
                                                                        .city!)
                                                                    .name!;
                                                                qytetiEmpty =
                                                                false;
                                                                clientId = buyers
                                                                    .getBuyers()[
                                                                index]
                                                                    .id!;
                                                              });
                                                              buyers.setCheck(
                                                                  buyers
                                                                      .getBuyers()[
                                                                  index]
                                                                      .id,
                                                                  true);

                                                              buyers.filtro("");
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  width: getPhoneWidth(
                                                                      context),
                                                                  height: 60,
                                                                  color: Colors
                                                                      .transparent,
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                      20,
                                                                      vertical:
                                                                      5),
                                                                  child: SingleChildScrollView(
                                                                    scrollDirection: Axis.horizontal,
                                                                    child: Container(
                                                                      width: getPhoneWidth(context) - 60,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Column(
                                                                                crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    "${buyers.getBuyers()[index].fullName}",
                                                                                    style: AppStyles.getHeaderNameText(color: Colors.blueGrey[400], size: 17.0),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 8,
                                                                                  ),
                                                                                  Text(
                                                                                    "Adresa: ${buyers.getBuyers()[index].address}",
                                                                                    style: AppStyles.getHeaderNameText(color: Colors.blueGrey[400], size: 15.0),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                            20,
                                                                            height:
                                                                            20,
                                                                            decoration: BoxDecoration(
                                                                                borderRadius:
                                                                                BorderRadius.circular(100),
                                                                                border: Border.all(color: AppColors.bottomColorTwo)),
                                                                            padding:
                                                                            const EdgeInsets.all(2),
                                                                            child: buyers.getBuyers()[index].checked
                                                                                ? Container(
                                                                              width: 20,
                                                                              height: 20,
                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: AppColors.bottomColorTwo),
                                                                            )
                                                                                : const SizedBox(),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Divider(
                                                                  height: 3,
                                                                  color: Colors
                                                                      .blueGrey[
                                                                  100],
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                        itemCount: buyers
                                                            .getBuyers()
                                                            .length,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              });
                                        });
                                  },
                                  child: Container(
                                    width: 70,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(20)),
                                        color: AppColors.bottomColorOne),
                                    child: const Center(
                                      child: Icon(
                                        Icons.list,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: GestureDetector(
                          onTap: () {
                            if (shteti.text.isEmpty && shtetet.isNotEmpty) {
                              setState(() {
                                qyteti.text = "";
                                oferta.text = "";
                                shteti.text = shtetet[0];
                                unit.text = njesite.getUnits().isEmpty
                                    ? ""
                                    : njesite.getUnits()[0].unitName!;
                                unitId.text = njesite.getUnits().isEmpty
                                    ? ""
                                    : njesite.getUnits()[0].id!;
                              });
                            }
                            setState(() {
                              shtetiEmpty = false;
                            });

                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return SizedBox(
                                    width: getPhoneWidth(context),
                                    height: 200,
                                    child: CupertinoPicker.builder(
                                        itemExtent: 40,
                                        scrollController: fixedScrollController,
                                        onSelectedItemChanged: (value) {
                                          setState(() {
                                            shteti.text = shtetet[value];
                                            qyteti.text = qytetet
                                                .getCitiesByState(shteti.text)
                                                .isEmpty
                                                ? ""
                                                : qytetet
                                                .getCitiesByState(shteti.text)
                                                .elementAt(0)
                                                .name!;
                                            oferta.text = ofertat
                                                .getOfferByState(shteti.text)
                                                .isEmpty
                                                ? ""
                                                : ofertat
                                                .getOfferByState(shteti.text)
                                                .elementAt(0)
                                                .offerName!;
                                            offerId.text = ofertat
                                                .getOfferByState(shteti.text)
                                                .isEmpty
                                                ? ""
                                                : ofertat
                                                .getOfferByState(shteti.text)
                                                .elementAt(0)
                                                .id!;
                                            unit.text = njesite.getUnits().isEmpty
                                                ? ""
                                                : njesite.getUnits()[0].unitName!;
                                            unitId.text =
                                            njesite.getUnits().isEmpty
                                                ? ""
                                                : njesite.getUnits()[0].id!;
                                          });
                                        },
                                        itemBuilder: (context, index) {
                                          return Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Text(shtetet[index]),
                                            ],
                                          );
                                        },
                                        childCount: shtetet.length),
                                  );
                                });
                          },
                          child: Container(
                            width: getPhoneWidth(context),
                            height: 50,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20)),
                                color: Colors.white),
                            child: Row(
                              children: [
                                Text(
                                  shteti.text.isEmpty ? "Shteti" : shteti.text,
                                  style: AppStyles.getHeaderNameText(
                                      color: shtetiEmpty
                                          ? Colors.red
                                          : Colors.grey[900],
                                      size: 15.0),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: GestureDetector(
                          onTap: () {
                            if (unit.text.isEmpty &&
                                njesite.getUnits().isNotEmpty) {
                              setState(() {
                                unit.text = njesite.getUnits()[0].unitName!;
                                unitId.text = njesite.getUnits()[0].id!;
                              });
                            }
                            setState(() {
                              unitEmpty = false;
                            });
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return SizedBox(
                                    width: getPhoneWidth(context),
                                    height: 200,
                                    child: CupertinoPicker.builder(
                                      itemExtent: 40,
                                      onSelectedItemChanged: (value) {
                                        setState(() {
                                          unit.text =
                                          njesite.getUnits()[value].unitName!;
                                          unitId.text =
                                          njesite.getUnits()[value].id!;
                                        });
                                      },
                                      itemBuilder: (context, index) {
                                        return Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(njesite
                                                .getUnits()[index]
                                                .unitName!),
                                          ],
                                        );
                                      },
                                      childCount: njesite.getUnits().length,
                                    ),
                                  );
                                });
                          },
                          child: Container(
                            width: getPhoneWidth(context),
                            height: 50,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20)),
                                color: Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  unit.text.isEmpty ? "Njesia" : unit.text,
                                  style: AppStyles.getHeaderNameText(
                                      color: unitEmpty
                                          ? Colors.red
                                          : Colors.grey[900],
                                      size: 15.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: GestureDetector(
                          onTap: () {
                            if (shteti.text.isNotEmpty &&
                                qytetet
                                    .getCitiesByState(shteti.text)
                                    .isNotEmpty) {
                              setState(() {
                                qyteti.text = qytetet
                                    .getCitiesByState(shteti.text)
                                    .elementAt(0)
                                    .name!;
                              });
                              setState(() {
                                qytetiEmpty = false;
                              });
                              showModalBottomSheet(
                                  context: context, isScrollControlled: true,
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: (context, setter){
                                        _setter = setter;
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context).viewInsets.bottom),
                                          child: Container(
                                            width: getPhoneWidth(context),
                                            height: 255,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                                                    child: SizedBox(
                                                      width: getPhoneWidth(context),
                                                      height: 45,
                                                      child: TextField(
                                                        onChanged: (value){
                                                          var findIndex = 0;

                                                          for(int i=0;i<qytetet.getCitiesByState(shteti.text).length;i++){
                                                            if(qytetet.getCitiesByState(shteti.text).elementAt(i).name!.toLowerCase().contains(value.toLowerCase())){
                                                              print("fined ${i}");
                                                              _setter!((){
                                                                fixedScrollController.jumpToItem(i);
                                                              });
                                                            }
                                                          }

                                                        },
                                                        decoration: InputDecoration(
                                                            border: InputBorder.none,
                                                            enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10),
                                                                borderSide: BorderSide(color: Colors.grey[300]!)
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10),
                                                                borderSide: BorderSide(color: Colors.grey[300]!)
                                                            ),
                                                            contentPadding: EdgeInsets.symmetric(vertical: 3,horizontal: 15)
                                                        ),
                                                      ),),
                                                  ),
                                                  SizedBox(
                                                    width: getPhoneWidth(context),
                                                    height: 200,
                                                    child: CupertinoPicker.builder(
                                                      itemExtent: 40,scrollController: fixedScrollController,
                                                      onSelectedItemChanged: (value) {
                                                        setState(() {
                                                          qyteti.text = qytetet
                                                              .getCitiesByState(shteti.text)
                                                              .elementAt(value)
                                                              .name!;
                                                        });
                                                      },
                                                      itemBuilder: (context, index) {
                                                        return Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                          children: [
                                                            Text(qytetet
                                                                .getCitiesByState(shteti.text)
                                                                .elementAt(index)
                                                                .name!),
                                                          ],
                                                        );
                                                      },
                                                      childCount: qytetet
                                                          .getCitiesByState(shteti.text)
                                                          .length,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  });
                            } else {
                              showModalOne(
                                  context,
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            "Nuk keni zgjedhur shtetin!",
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
                          },
                          child: Container(
                            width: getPhoneWidth(context),
                            height: 50,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20)),
                                color: Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  qyteti.text.isEmpty ? "Qyteti" : qyteti.text,
                                  style: AppStyles.getHeaderNameText(
                                      color: qytetiEmpty
                                          ? Colors.red
                                          : Colors.grey[900],
                                      size: 15.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: getPhoneWidth(context),
                                height: 50,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(20)),
                                    color: Colors.white),
                                child: TextField(
                                  controller: qmimi,
                                  keyboardType: const TextInputType.numberWithOptions(
                                      decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}'))
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      if(sasia.text.isEmpty){
                                        sasia.text = "1";
                                      }
                                      qmimiEmpty = false;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Cmimi",
                                      hintStyle: AppStyles.getHeaderNameText(
                                          color: qmimiEmpty
                                              ? Colors.red
                                              : Colors.grey[900],
                                          size: 15.0),
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
                            Text("  Qmimi kalkulohet sipas sasise, por mund edhe te ndrrohet.",style: AppStyles.getHeaderNameText(color:Colors.white,size: 12.0),)
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 11,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                            width: getPhoneWidth(context),
                            height: 50,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20)),
                                color: Colors.white),
                            child: TextField(
                              controller: sasia,
                              keyboardType: TextInputType.numberWithOptions(signed: true,decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              ],
                              onChanged: (value) {
                                if(value.isNotEmpty){
                                  setState(() {
                                    products.getProducts().forEach((element) {

                                      if(element.id == productId){
                                        if(element.qty < int.parse(value)){
                                          sasia.text = element.qty.toString();
                                        }
                                        else{
                                          sasia.text = value;
                                        }
                                      }
                                    });
                                    sasia.selection = TextSelection.fromPosition(TextPosition(offset: sasia.text.length));


                                  });
                                }

                              },
                              decoration: InputDecoration(
                                  hintText: "Sasia",
                                  hintStyle: AppStyles.getHeaderNameText(
                                      color: sasiaEmpty
                                          ? Colors.red
                                          : Colors.grey[900],
                                      size: 15.0),
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
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: GestureDetector(
                          onTap: () {
                            print(ofertat.getOffers().length);
                            if (shteti.text.isNotEmpty &&
                                ofertat.getOfferByState(shteti.text).isNotEmpty) {
                              setState(() {
                                oferta.text = ofertat
                                    .getOfferByState(shteti.text)
                                    .elementAt(0)
                                    .offerName!;
                                offerId.text = ofertat
                                    .getOfferByState(shteti.text)
                                    .elementAt(0)
                                    .id!;
                              });
                              setState(() {
                                ofertaEmpty = false;
                              });
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                      width: getPhoneWidth(context),
                                      height: 200,
                                      child: CupertinoPicker.builder(
                                        itemExtent: 40,
                                        onSelectedItemChanged: (value) {
                                          setState(() {
                                            oferta.text = ofertat
                                                .getOfferByState(shteti.text)
                                                .elementAt(value)
                                                .offerName!;
                                            offerId.text = ofertat
                                                .getOfferByState(shteti.text)
                                                .elementAt(value)
                                                .id!;
                                          });
                                        },
                                        itemBuilder: (context, index) {
                                          return Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Text(ofertat
                                                  .getOfferByState(shteti.text)
                                                  .elementAt(index)
                                                  .offerName!),
                                            ],
                                          );
                                        },
                                        childCount: ofertat
                                            .getOfferByState(shteti.text)
                                            .length,
                                      ),
                                    );
                                  });
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
                                            "Nuk keni zgjedhur shtetin!",
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
                          },
                          child: Container(
                            width: getPhoneWidth(context),
                            height: 50,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20)),
                                color: Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  oferta.text.isEmpty ? "Oferta" : oferta.text,
                                  style: AppStyles.getHeaderNameText(
                                      color: ofertaEmpty
                                          ? Colors.red
                                          : Colors.grey[900],
                                      size: 15.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                            width: getPhoneWidth(context),
                            height: 50,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20)),
                                color: Colors.white),
                            child: TextField(
                              controller: adresa,
                              onChanged: (value) {
                                setState(() {
                                  adresaEmpty = false;
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: "Adresa",
                                  hintStyle: AppStyles.getHeaderNameText(
                                      color: adresaEmpty
                                          ? Colors.red
                                          : Colors.grey[900],
                                      size: 15.0),
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
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                            width: getPhoneWidth(context),
                            height: 50,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20)),
                                color: Colors.white),
                            child: TextField(
                              controller: nrTel,
                              keyboardType: TextInputType.numberWithOptions(signed: true,decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  nrTelEmpty = false;
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: "Numri tel.",
                                  hintStyle: AppStyles.getHeaderNameText(
                                      color: nrTelEmpty
                                          ? Colors.red
                                          : Colors.grey[900],
                                      size: 15.0),
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
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                            width: getPhoneWidth(context),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: TextField(
                              controller: pershkrimi,
                              decoration: InputDecoration(
                                  hintText: "Pershkrimi",
                                  hintStyle: AppStyles.getHeaderNameText(
                                      color: Colors.grey[900], size: 15.0),
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                    const BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                    const BorderSide(color: Colors.white),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10)),
                            )),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isOpen = !isOpen;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          width: getPhoneWidth(context),
                          color: Colors.transparent,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Te hapet",
                                style: AppStyles.getHeaderNameText(
                                    color: Colors.white, size: 18.0),
                              ),
                              Stack(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        border: Border.all(color: Colors.white)),
                                  ),
                                  AnimatedPositioned(
                                      duration: const Duration(milliseconds: 150),
                                      top: 2.3,
                                      right: !isOpen ? 32 : 3, // 32
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(100),
                                            color: !isOpen
                                                ? Colors.grey[400]
                                                : Colors.white),
                                      ))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isbrokable = !isbrokable;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          width: getPhoneWidth(context),
                          color: Colors.transparent,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "E thyeshme",
                                style: AppStyles.getHeaderNameText(
                                    color: Colors.white, size: 18.0),
                              ),
                              Stack(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        border: Border.all(color: Colors.white)),
                                  ),
                                  AnimatedPositioned(
                                      duration: const Duration(milliseconds: 150),
                                      top: 2.3,
                                      right: !isbrokable ? 32 : 3, // 32
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(100),
                                            color: !isbrokable
                                                ? Colors.grey[400]
                                                : Colors.white),
                                      ))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isChange = !isChange;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          width: getPhoneWidth(context),
                          color: Colors.transparent,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Nderrim",
                                style: AppStyles.getHeaderNameText(
                                    color: Colors.white, size: 18.0),
                              ),
                              Stack(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        border: Border.all(color: Colors.white)),
                                  ),
                                  AnimatedPositioned(
                                      duration: const Duration(milliseconds: 150),
                                      top: 2.3,
                                      right: !isChange ? 32 : 3, // 32
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(100),
                                            color: !isChange
                                                ? Colors.grey[400]
                                                : Colors.white),
                                      ))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment:clientId.isEmpty ?  MainAxisAlignment.spaceEvenly:MainAxisAlignment.center,
                        children: [
                          clientId.isNotEmpty
                              ? const SizedBox()
                              : Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 10),
                              child: GestureDetector(
                                onTap: () {
                                  showModalOne(
                                      context,
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "Deshironi te regjistroni bleresin e ri ?",
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
                                                        addBuyer();
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
                                      ),
                                      150.0);
                                },
                                child: Container(
                                  width: getPhoneWidth(context) / 2 - 30,
                                  height: 45,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white),
                                  child: requestingClient ? Center(child: SizedBox(width: 25,height: 25,child: CircularProgressIndicator(strokeWidth: 1.4,))):Center(
                                    child: Text(
                                      "Klient i ri",
                                      style: AppStyles.getHeaderNameText(
                                          color: Colors.black, size: 15.0),
                                    ),
                                  ),
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: clientId.isEmpty ? 0 : 0),
                              child: GestureDetector(
                                onTap: () {
                                  showModalOne(
                                      context,
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "Deshironi te vazhdoni ?",
                                                style:
                                                AppStyles.getHeaderNameText(
                                                    color:
                                                    Colors.blueGrey[800],
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
                                                  getPhoneWidth(context) / 2 -
                                                      80,
                                                  decoration: BoxDecoration(
                                                      color: Colors.blueGrey,
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                                  child: TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        "Jo",
                                                        style: AppStyles
                                                            .getHeaderNameText(
                                                            color:
                                                            Colors.white,
                                                            size: 17),
                                                      ))),
                                              Container(
                                                  height: 40,
                                                  width:
                                                  getPhoneWidth(context) / 2 -
                                                      80,
                                                  decoration: BoxDecoration(
                                                      color: Colors.blueGrey,
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                                  child: TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        newOrder();
                                                      },
                                                      child: Text(
                                                        "Po",
                                                        style: AppStyles
                                                            .getHeaderNameText(
                                                            color:
                                                            Colors.white,
                                                            size: 17),
                                                      ))),
                                            ],
                                          )
                                        ],
                                      ),
                                      150.0);
                                },
                                child: Container(
                                  width: clientId.isNotEmpty
                                      ? getPhoneWidth(context) - 50
                                      : getPhoneWidth(context) / 2 - 30,
                                  height: 45,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white),
                                  child: requesting ? Center(child: SizedBox(width: 25,height: 25,child: CircularProgressIndicator(strokeWidth: 1.4,))):Center(
                                    child: Text(
                                      "Regjistro porosine",
                                      style: AppStyles.getHeaderNameText(
                                          color: Colors.black, size: 15.0),
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                      const SizedBox(
                        height:50,
                      ),
                    ],
                  ),
                ),
              ),)
            ],
          ),
        ],
      ),
    );
  }
}
