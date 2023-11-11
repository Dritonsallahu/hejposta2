import 'package:flutter/material.dart';
import 'package:hejposta/models/product_model.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/shortcuts/urls.dart';
import 'package:hejposta/views/postman/postman_drawer.dart';
import 'package:provider/provider.dart';

class SingleProduct extends StatefulWidget {
  final ProductModel? productModel;
  const SingleProduct({Key? key, this.productModel}) : super(key: key);

  @override
  State<SingleProduct> createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {

  @override
  Widget build(BuildContext context) {
    var generalProvider = Provider.of<GeneralProvider>(context, listen: true);
    return Scaffold(
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
                      width: getPhoneWidth(context),
                      height: getPhoneHeight(context)* 0.4 - 50,
                      child: ClipRRect(borderRadius: BorderRadius.circular(0),child: Image.network("$imgUrl/images/${widget.productModel!.image}",fit: BoxFit.cover,)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                      child: Container(
                        width: getPhoneWidth(context),
                        height: getPhoneHeight(context)* 0.4 - 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Çmimi i produktit",style: AppStyles.getHeaderNameText(color: Colors.blueGrey[800],size: 18.0),),
                                Text("${widget.productModel!.price}€",style: AppStyles.getHeaderNameText(color: Colors.blueGrey[800],size: 16.0),),
                              ],
                            )
                          ],
                        ),
                      ),
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
