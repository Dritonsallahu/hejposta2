import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hejposta/controllers/city_controller.dart';
import 'package:hejposta/controllers/zones_controller.dart';
import 'package:hejposta/models/postman_model.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/city_provider.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/providers/user_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/views/postman/postman_drawer.dart';
import 'package:provider/provider.dart';

class Zones extends StatefulWidget {
  const Zones({Key? key}) : super(key: key);

  @override
  State<Zones> createState() => _ZonesState();
}

class _ZonesState extends State<Zones> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
TextEditingController name = TextEditingController();
TextEditingController cityName = TextEditingController();


  bool up = false;
  bool left = false;

  @override
  void initState() {
    getQytetet();
    getPostmanZones();
    super.initState();
  }

  addZone(){
    ZonesController zonesController = ZonesController();
    zonesController.addZone(context, name.text, cityName.text);
  }

  getQytetet(){
    CityController cityController = CityController();
    cityController.getQytetet(context);
  }
  getPostmanZones(){
    ZonesController zonesController = ZonesController();
    zonesController.getZones(context);
  }
  @override
  Widget build(BuildContext context) {
    var qytetet = Provider.of<CityProvier>(context);
    var generalProvider = Provider.of<GeneralProvider>(context, listen: true);
    var user = Provider.of<UserProvider>(context, listen: true);
    print(user.getUser()!.areas);
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
                            "Zonat",
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

                    Container(
                      width: getPhoneWidth(context),
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: SizedBox(
                        width: getPhoneWidth(context)  ,
                        child: TextField(
                          controller: name,
                          decoration: InputDecoration(
                              hintText: "Emri zones",
                              hintStyle: AppStyles.getHeaderNameText(color: Colors.black,size: 15.0),
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              isDense: true),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),


                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: GestureDetector(
                        onTap: (){
                          if(cityName.text.isEmpty && qytetet.getCitiesByState("Kosovë").isNotEmpty){
                            setState(() {
                              cityName.text = qytetet.getCitiesByState("Kosovë").elementAt(0).name!;
                            });
                          }

                          showModalBottomSheet(context: context, builder: (context){
                            return SizedBox(
                              width: getPhoneWidth(context),
                              height: 200,
                              child: CupertinoPicker.builder(
                                itemExtent: 40,
                                onSelectedItemChanged: (value){
                                  setState(() {
                                    cityName.text = qytetet.getCitiesByState("Kosovë").elementAt(value).name!;
                                  });
                                },
                                itemBuilder: (context,index){
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(qytetet.getCitiesByState("Kosovë").elementAt(index).name!),
                                    ],
                                  );
                                },childCount: qytetet.getCitiesByState("Kosovë").length,),
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
                              Text(cityName.text.isEmpty ? "Qyteti":cityName.text,style: AppStyles.getHeaderNameText(
                                  color: Colors.grey[900], size: 15.0),),

                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: GestureDetector(
                        onTap: () {
                          addZone();
                        },
                        child: Container(
                          width: getPhoneWidth(context),
                          height: 50,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight : Radius.circular(20)),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Ruaje",
                                style: AppStyles.getHeaderNameText(
                                    color: Colors.grey[900], size: 16.0),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 20),
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.8),
                                          border: const Border(
                                              bottom: BorderSide(
                                                  color: Colors.blueGrey))),
                                      width: getPhoneWidth(context) / 2 - 27,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Emri zones",
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
                                      width: getPhoneWidth(context) / 2 - 17,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Qyteti",
                                            style: AppStyles.getHeaderNameText(
                                                color: Colors.blueGrey, size: 15.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          user.getUser()!.areas == null ? SizedBox(): Table(
                            children: List.generate(user.getUser()!.areas.length, (index) {
                              return TableRow(
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.8)),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        user.getUser()!.areas![index].name.toString(),
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.blueGrey, size: 15.0),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        user.getUser()!.areas![index].cityName.toString(),
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.blueGrey, size: 15.0),
                                      ),
                                    ),
                                  ]
                                  );
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
