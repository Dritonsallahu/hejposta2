import 'package:flutter/material.dart';
import 'package:hejposta/controllers/product_controller.dart';
import 'package:hejposta/models/product_model.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/client_order_provider.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/shortcuts/urls.dart';
import 'package:hejposta/views/business/product_update.dart';
import 'package:hejposta/views/postman/postman_drawer.dart';
import 'package:provider/provider.dart';

class SingleProduct extends StatefulWidget {
  final ProductModel? productModel;
  const SingleProduct({Key? key, this.productModel}) : super(key: key);

  @override
  State<SingleProduct> createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {

  int rejectedOrders = 0;
  int processing = 0;
  int delieveredOrders = 0;
  int kosove = 0;
  int shqiperi = 0;
  int maqedoni = 0;
  double offer = 0.0;
  double total = 0.0;

  checkDetails(){
    setState(() {
      delieveredOrders = 0;
      rejectedOrders = 0;
      processing = 0;
      total = 0;
      kosove = 0;
      shqiperi = 0;
      maqedoni = 0;
    });
    var orderProvider = Provider.of<ClientOrderProvider>(context,listen: false);
    var orders = orderProvider.getOrders("all");
    for (var element in orders!) {
      if(element.product == widget.productModel!.id){
        setState(() {
          offer = element.offer!.price.toDouble();
        });
        if(element.status == "pending" || element.status == "delivering" || element.status == "accepted" || element.status == "in_warehouse"){
          setState(() {
            processing++;
            total += (element.price - offer).toDouble();
          });
        }
        else if(element.status == "delivered" || element.status == "delivered_to_client"){
          setState(() {
            delieveredOrders++;
            total += (element.price - offer).toDouble();
          });
        }
        else if(element.status == "rejected"){
          setState(() {
            rejectedOrders++;
          });
        }
        if(element.receiver!.state == "Kosovë"){
          setState(() {
            kosove++;
          });
        }
        else if(element.receiver!.state == "Shqipëri"){
          setState(() {
            shqiperi++;
          });
        }
        else if(element.receiver!.state == "Maqedonia"){
          setState(() {
            maqedoni++;
          });
        }

      }
    }
  }

  deleteProduct(id){
    ProductController productController = ProductController();
    productController.deleteProduct(context, id).then((value){
      if(value == "success"){
        Navigator.pop(context);
        Navigator.pop(context);
      }
    });
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      checkDetails();
    });
    super.initState();
  }

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
                            "${widget.productModel!.productName}",
                            style: AppStyles.getHeaderNameText(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                size: 20.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            child: Row(
                              children:   [
                                GestureDetector(
                                  onTap: (){
                                    showModalBottomSheet(context: context, builder: (context){
                                      return Container(
                                        width: getPhoneWidth(context),
                                        height: 200,
                                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              onTap: (){
                                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductUpdate(product: widget.productModel)));
                                              },
                                              child: Container(
                                                color:Colors.transparent,
                                                padding: const EdgeInsets.symmetric(vertical: 15),
                                                child: Row(
                                                  children: [
                                                    const Icon(Icons.edit),
                                                    const SizedBox(width: 10,),
                                                    Text("Perditeso",style: AppStyles.getHeaderNameText(color: Colors.blueGrey[700],size:15.0),)
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Divider(),
                                            GestureDetector(
                                              onTap: (){
                                                deleteProduct(widget.productModel!.id);
                                              },
                                              child: Container(
                                                color:Colors.transparent,
                                                padding: const EdgeInsets.symmetric(vertical: 15),
                                                child: Row(
                                                  children: [
                                                    const Icon(Icons.delete_forever),
                                                    const SizedBox(width: 10,),
                                                    Text("Fshije",style: AppStyles.getHeaderNameText(color: Colors.blueGrey[700],size:15.0),)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      );
                                    });
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    width: 60,
                                    height: 26,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: const [
                                        Icon(Icons.more_vert_outlined,color: Colors.white,),
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
                    Container(
                      width: getPhoneWidth(context),
                      height: getPhoneHeight(context)* 0.3 - 50,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ClipRRect(borderRadius: BorderRadius.circular(10),child: Image.network("$imgUrl/images/${widget.productModel!.image}",fit: BoxFit.cover,)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                      child: Container(
                        width: getPhoneWidth(context),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Çmimi i produktit",style: AppStyles.getHeaderNameText(color: Colors.white,size: 18.0),),
                                Text("${widget.productModel!.price - offer}€",style: AppStyles.getHeaderNameText(color: Colors.white,size: 16.0),),
                              ],
                            ),
                            const SizedBox(height: 17,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Stoku",style: AppStyles.getHeaderNameText(color: Colors.white,size: 18.0),),
                                Text("${widget.productModel!.qty}",style: AppStyles.getHeaderNameText(color: Colors.white,size: 16.0),),
                              ],
                            ),
                            const SizedBox(height: 17,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Ne proces",style: AppStyles.getHeaderNameText(color: Colors.white,size: 18.0),),
                                Text("$processing",style: AppStyles.getHeaderNameText(color: Colors.white,size: 16.0),),
                              ],
                            ),
                            const SizedBox(height: 17,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Te shitura",style: AppStyles.getHeaderNameText(color: Colors.white,size: 18.0),),
                                Text("$delieveredOrders",style: AppStyles.getHeaderNameText(color: Colors.white,size: 16.0),),
                              ],
                            ),
                            const SizedBox(height: 17,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Anulime",style: AppStyles.getHeaderNameText(color: Colors.white,size: 18.0),),
                                Text("$rejectedOrders",style: AppStyles.getHeaderNameText(color: Colors.white,size: 16.0),),
                              ],
                            ),
                            const SizedBox(height: 17,),
                            const Divider(color:Colors.white,thickness: 1,height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Kosove",style: AppStyles.getHeaderNameText(color: Colors.white,size: 18.0),),
                                Text("$kosove",style: AppStyles.getHeaderNameText(color: Colors.white,size: 16.0),),
                              ],
                            ),
                            const SizedBox(height: 17,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Shqiperi",style: AppStyles.getHeaderNameText(color: Colors.white,size: 18.0),),
                                Text("$shqiperi",style: AppStyles.getHeaderNameText(color: Colors.white,size: 16.0),),
                              ],
                            ),
                            const SizedBox(height: 17,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Maqedoni",style: AppStyles.getHeaderNameText(color: Colors.white,size: 18.0),),
                                Text("$maqedoni",style: AppStyles.getHeaderNameText(color: Colors.white,size: 16.0),),
                              ],
                            ),
                            const Divider(color:Colors.white,thickness: 1,height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total",style: AppStyles.getHeaderNameText(color: Colors.white,size: 18.0),),
                                Text("$total€",style: AppStyles.getHeaderNameText(color: Colors.white,size: 16.0),),
                              ],
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
        ],
      ),
    );
  }
}
