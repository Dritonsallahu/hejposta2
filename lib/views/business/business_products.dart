import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hejposta/controllers/product_controller.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/providers/product_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/shortcuts/urls.dart';
import 'package:hejposta/views/business/product_register.dart';
import 'package:hejposta/views/business/single_product.dart';
import 'package:hejposta/views/postman/postman_drawer.dart';
import 'package:provider/provider.dart';

class BusinessProducts extends StatefulWidget {
  const BusinessProducts({super.key});

  @override
  State<BusinessProducts> createState() => _BusinessProductsState();
}

class _BusinessProductsState extends State<BusinessProducts> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  getProducts() {
    ProductController productController = ProductController();
    productController.getProducts(context).then((value) {
      print(value);
    });
  }

  @override
  void initState() {
    getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var generalProvider = Provider.of<GeneralProvider>(context, listen: true);
    var products = Provider.of<ProductProvider>(context, listen: true);
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
                  color: AppColors.mapColorFirst,
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.cover,
                ),
              )),
              SizedBox(
                width: getPhoneWidth(context),
                height: getPhoneHeight(context) - 66,
                child: Column(
                  children: [
                    Container(
                      height: 58,
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
                            "Produktet",
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
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const ProductRegister()));
                        },
                        child: Container(
                          width: getPhoneWidth(context),
                          height: 45,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15)),
                              color: Colors.white),
                          child: Center(
                            child: Text(
                              "Regjistro produktet",
                              style: AppStyles.getHeaderNameText(
                                  color: Colors.blueGrey[800], size: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: getPhoneHeight(context) -
                          MediaQuery.of(context).viewPadding.top -
                          130,
                      child: products.isFetching()
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 1.5,
                            ))
                          : SingleChildScrollView(
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  getProducts();
                                },
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  alignment: WrapAlignment.start,
                                  children: List.generate(
                                      products.getProducts().length, (index) {
                                    var product = products.getProducts()[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: GestureDetector(
                                        onTap: (){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => SingleProduct(productModel: products.getProducts()[index],)));
                                        },
                                        child: Container(
                                          width: getPhoneWidth(context) / 3 - 20,
                                          height: getPhoneWidth(context) / 3 - 20,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.all(2.4),
                                          child: Container(
                                            width:
                                                getPhoneWidth(context) / 3 - 20,
                                            height:
                                                getPhoneWidth(context) / 3 - 20,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      "${imgUrl}/images/${product.image}")),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }, growable: true),
                                ),
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
