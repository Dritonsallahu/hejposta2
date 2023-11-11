import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hejposta/controllers/product_controller.dart';
import 'package:hejposta/models/product_model.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/shortcuts/modals.dart';
import 'package:hejposta/views/postman/postman_drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ProductUpdate extends StatefulWidget {
  final ProductModel? product;
  const ProductUpdate({super.key, this.product});

  @override
  State<ProductUpdate> createState() => _ProductUpdateState();
}

class _ProductUpdateState extends State<ProductUpdate> {
  TextEditingController emertimi = TextEditingController();
  TextEditingController qmimi = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController pershkrimi = TextEditingController();
  TextEditingController foto = TextEditingController();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  final ImagePicker picker = ImagePicker();
  bool registering = false;

  bool isOpen = false;
  bool isbrokable = false;
  bool isChange = false;

  bool emertimiEmpty = false;
  bool qmimiEmpty = false;
  bool amountEmpty = false;
  bool pershkrimiEmpty = false;
  XFile? photo;
  addProduct() {
    setState(() { registering = true; });
    if(emertimi.text.isEmpty){ setState(() { emertimiEmpty = true;});}
    if(qmimi.text.isEmpty){ setState(() { qmimiEmpty = true;});}
    if(amount.text.isEmpty){ setState(() { amountEmpty = true;});}
    if(pershkrimi.text.isEmpty){ setState(() { pershkrimiEmpty = true;});}

    if(!emertimiEmpty && !qmimiEmpty && !amountEmpty && !pershkrimiEmpty){
      ProductController productController = ProductController();
      productController.updateProduct(context,widget.product!.id, emertimi.text, qmimi.text, amount.text, pershkrimi.text, isOpen, isbrokable, isChange,
          file: photo)
          .then((value) {
        if(value == "success"){
          Navigator.pop(context);
        }
        else{
          showMessageModal(context, "Perditesimi i porosise deshtoi.\nJu lutem kontaktoni administraten per sqarime.", 15.0);
        }
      }).whenComplete((){
        setState(() { registering = false; });
      });
    }
    else{
      setState(() { registering = false; });
    }
  }
  bejFotografi() async {
// Capture a photo.
    photo = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      foto.text = photo!.name;
    });
  }

  merrGalerine() async {
    photo = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      foto.text = photo!.name;
    });
  }
  @override
  void initState() {
    setState(() {
      emertimi.text = widget.product!.productName!;
      qmimi.text = widget.product!.price.toString();
      amount.text = widget.product!.qty.toString();
      pershkrimi.text = widget.product!.describe!;
      if(widget.product!.image == null || widget.product!.image == "product-placeholder.webp"){
        foto.text = widget.product!.image! == "product-placeholder.webp" ? "Ska foto":widget.product!.image!;
      }
      isOpen = widget.product!.open!.toString() == "true" ? true:false;
      isbrokable = widget.product!.brake!.toString() == "true" ? true:false;
      isChange = widget.product!.change!.toString() == "true" ? true:false;
    });
    super.initState();
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
                            "${widget.product!.productName}",
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
                          child: TextField(
                            controller: emertimi,
                            onChanged: (value){
                              setState(() {
                                emertimiEmpty = false;
                              });
                            },
                            decoration: InputDecoration(
                                hintText: "Emri i produktit",
                                hintStyle: AppStyles.getHeaderNameText(
                                    color: emertimiEmpty ? Colors.red:Colors.grey[900], size: 16.0),
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
                            controller: qmimi,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                            onChanged: (value){
                              setState(() {
                                qmimiEmpty = false;
                              });
                            },
                            decoration: InputDecoration(
                                hintText: "Qmimi",
                                hintStyle: AppStyles.getHeaderNameText(
                                    color: qmimiEmpty ? Colors.red:Colors.grey[900], size: 16.0),
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
                            color: Colors.white,
                          ),
                          child: TextField(
                            controller: amount,
                            keyboardType:   TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],

                            onChanged: (value){
                              setState(() {
                                amountEmpty = false;
                              });
                            },
                            decoration: InputDecoration(
                                hintText: "Sasia",
                                hintStyle: AppStyles.getHeaderNameText(
                                    color: amountEmpty ? Colors.red: Colors.grey[900], size: 15.0),
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
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20)),
                              color: Colors.white),
                          child: TextField(
                            controller: pershkrimi,
                            minLines: 5,
                            maxLines: 190,
                            onChanged: (value){
                              setState(() {
                                pershkrimiEmpty = false;
                              });
                            },
                            decoration: InputDecoration(
                                hintText: "Pershkrimi",
                                hintStyle: AppStyles.getHeaderNameText(
                                    color: pershkrimiEmpty ? Colors.red : Colors.grey[900], size: 15.0),
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
                        onTap: (){
                          showModalOne(context, Column(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  bejFotografi();
                                },
                                child: Container(
                                  width: getPhoneWidth(context),
                                  height: 50,
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.camera),
                                      const SizedBox(width: 10,),
                                      Text("Bej fotografi",style: AppStyles.getHeaderNameText(color: Colors.black,size: 17.0),),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(height: 10,),
                              GestureDetector(
                                onTap: (){
                                  merrGalerine();
                                },
                                child: Container(
                                  width: getPhoneWidth(context),
                                  height: 50,
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.image_sharp),
                                      const SizedBox(width: 10,),
                                      Text("Merr nga galeria",style: AppStyles.getHeaderNameText(color: Colors.black,size: 17.0),),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ), 150.0);
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
                              controller: foto,
                              enabled: false,
                              decoration: InputDecoration(
                                  hintText: "Fotografia",
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
                      ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 29),
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
                        padding: const EdgeInsets.symmetric(horizontal: 29),
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
                        padding: const EdgeInsets.symmetric(horizontal: 29),
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
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: GestureDetector(
                          onTap: (){
                            addProduct();
                          },
                          child: Container(
                            width: getPhoneWidth(context),
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: Center(
                              child: registering ? const SizedBox(width: 25,height: 25,child: CircularProgressIndicator(strokeWidth: 1.4,)): Text(
                                "Perditeso produktin",
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
