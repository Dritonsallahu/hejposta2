
import 'package:flutter/material.dart';
import 'package:hejposta/local_storage/current_user_storage.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/shortcuts/modals.dart';
import 'package:hejposta/views/postman/expences.dart';
import 'package:hejposta/views/postman/finances.dart';
import 'package:hejposta/views/postman/postman_profile.dart';
import 'package:hejposta/views/postman/statistics.dart';
import 'package:hejposta/views/postman/messages.dart';
import 'package:hejposta/views/postman/rules.dart';
import 'package:hejposta/views/postman/zones.dart';
import 'package:provider/provider.dart';

class PostmanDrawer extends StatefulWidget {
  const PostmanDrawer({Key? key}) : super(key: key);

  @override
  State<PostmanDrawer> createState() => _PostmanDrawerState();
}

class _PostmanDrawerState extends State<PostmanDrawer> {
  @override
  Widget build(BuildContext context) {
    var generalProvider = Provider.of<GeneralProvider>(context, listen: true);
    return Container(
      color: Colors.transparent,
      width: getPhoneWidth(context),
      height: getPhoneHeight(context) - 238,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      color: Colors.transparent,
                      width: getPhoneWidth(context)/2 - 22,
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          SizedBox(width: 45,child: Image.asset("assets/icons/1.png")),
                          const SizedBox(width: 10,),
                          Text("Dashboard",style: AppStyles.getHeaderNameText(color: Colors.white,size: 18.0,fontWeight: FontWeight.w600),)
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Statistics()));
                    },
                    child: Container(
                      color: Colors.transparent,
                      width: getPhoneWidth(context)/2 - 22,
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          SizedBox(width: 45,child: Image.asset("assets/icons/1.png")),
                          const SizedBox(width: 10,),
                          Text("Statistikat",style: AppStyles.getHeaderNameText(color: Colors.white,size: 18.0,fontWeight: FontWeight.w600),)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25,),
              Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Finances()));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      color: Colors.transparent,
                      width: getPhoneWidth(context)/2 - 22,
                      child: Row(
                        children: [
                          SizedBox(width: 45,child: Image.asset("assets/icons/1.png")),
                          const SizedBox(width: 10,),
                          Text("Financat",style: AppStyles.getHeaderNameText(color: Colors.white,size: 18.0,fontWeight: FontWeight.w600),)
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Expences()));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      color: Colors.transparent,
                      width: getPhoneWidth(context)/2 - 22,
                      child: Row(
                        children: [
                          SizedBox(width: 45,child: Image.asset("assets/icons/1.png")),
                          const SizedBox(width: 10,),
                          Text("Shpenzimet",style: AppStyles.getHeaderNameText(color: Colors.white,size: 18.0,fontWeight: FontWeight.w600),)
                        ],
                      ),
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 25,),
              Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Zones()));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      color: Colors.transparent,
                      width: getPhoneWidth(context)/2 - 22,
                      child: Row(
                        children: [
                          SizedBox(width: 45,child: Image.asset("assets/icons/1.png")),
                          const SizedBox(width: 10,),
                          Text("Zonat",style: AppStyles.getHeaderNameText(color: Colors.white,size: 18.0,fontWeight: FontWeight.w600),)
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Rules()));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      color: Colors.transparent,
                      width: getPhoneWidth(context)/2 - 22,
                      child: Row(
                        children: [
                          SizedBox(width: 45,child: Image.asset("assets/icons/1.png")),
                          const SizedBox(width: 10,),
                          Text("Rregullorja",style: AppStyles.getHeaderNameText(color: Colors.white,size: 18.0,fontWeight: FontWeight.w600),)
                        ],
                      ),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: (){
                  //     // Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Messages()));
                  //     showModalOne(
                  //         context,
                  //         Column(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Column(
                  //               children: [
                  //                 Text(
                  //                   "Kjo karakteristike do te rregullohet ne versionin e radhes!",
                  //                   style: AppStyles.getHeaderNameText(
                  //                       color: Colors.blueGrey[800], size: 17),textAlign: TextAlign.center,
                  //                 ),
                  //                 const SizedBox(
                  //                   height: 10,
                  //                 ),
                  //                 Text(
                  //                   "This feature will be added in next version",
                  //                   style: AppStyles.getHeaderNameText(
                  //                       color: Colors.blueGrey[800], size: 17),textAlign: TextAlign.center,
                  //                 ),
                  //               ],
                  //             ),
                  //             Row(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 Container(
                  //                     height: 40,
                  //                     width: getPhoneWidth(context) / 2 - 80,
                  //                     decoration: BoxDecoration(
                  //                         color: Colors.blueGrey,
                  //                         borderRadius: BorderRadius.circular(100)),
                  //                     child: TextButton(
                  //                         onPressed: () {
                  //                           Navigator.pop(context);
                  //                         },
                  //                         child: Text(
                  //                           "Largo/ Leave",
                  //                           style: AppStyles.getHeaderNameText(
                  //                               color: Colors.white, size: 17),
                  //                         ))),
                  //               ],
                  //             )
                  //           ],
                  //         ),
                  //         190.0);
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.only(left: 10),
                  //     color: Colors.transparent,
                  //     width: getPhoneWidth(context)/2 - 22,
                  //     child: Row(
                  //       children: [
                  //         SizedBox(width: 45,child: Image.asset("assets/icons/1.png")),
                  //         const SizedBox(width: 10,),
                  //         Text("Mesazhet",style: AppStyles.getHeaderNameText(color: Colors.white,size: 18.0,fontWeight: FontWeight.w600),)
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 25,),
              Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PostmanProfile()));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      color: Colors.transparent,
                      width: getPhoneWidth(context)/2 - 22,
                      child: Row(
                        children: [
                          SizedBox(width: 45,child: Image.asset("assets/icons/1.png")),
                          const SizedBox(width: 10,),
                          Text("Profili",style: AppStyles.getHeaderNameText(color: Colors.white,size: 18.0,fontWeight: FontWeight.w600),)
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      var drawer = Provider.of<GeneralProvider>(context,listen: false);
                      drawer.setDrawerFalse();
                      CurrentUserStorage currentUserStorage = CurrentUserStorage();
                      currentUserStorage.removeUser(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      color: Colors.transparent,
                      width: getPhoneWidth(context)/2 - 22,
                      child: Row(
                        children: [
                          SizedBox(width: 45,child: Image.asset("assets/icons/1.png")),
                          const SizedBox(width: 10,),
                          Text("Dil",style: AppStyles.getHeaderNameText(color: Colors.white,size: 18.0,fontWeight: FontWeight.w600),)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25,),
              Row(
                children: [
                ],
              ),
            ],
          ),

        ],
      ),
    );
  }
}
