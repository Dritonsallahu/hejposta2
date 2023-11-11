import 'package:flutter/material.dart';
import 'package:hejposta/local_storage/current_user_storage.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/shortcuts/modals.dart';
import 'package:hejposta/views/business/business_finances.dart';
import 'package:hejposta/views/business/business_orders.dart';
import 'package:hejposta/views/business/business_products.dart';
import 'package:hejposta/views/business/business_profile.dart';
import 'package:hejposta/views/business/business_rules.dart';
import 'package:hejposta/views/business/my_challange.dart';
import 'package:hejposta/views/business/online_requests.dart';
import 'package:hejposta/views/business/order_list.dart';
import 'package:provider/provider.dart';

class BusinessDrawer extends StatefulWidget {
  const BusinessDrawer({Key? key}) : super(key: key);

  @override
  State<BusinessDrawer> createState() => _BusinessDrawerState();
}

class _BusinessDrawerState extends State<BusinessDrawer> {
  @override
  Widget build(BuildContext context) {
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
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      color: Colors.transparent,
                      width: getPhoneWidth(context) / 2 - 22,
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          SizedBox(
                              width: 45,
                              child: Image.asset("assets/icons/1.png")),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Dashboard",
                            style: AppStyles.getHeaderNameText(
                                color: Colors.white,
                                size: 18.0,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const BusinessFinances()));
                    },
                    child: Container(
                      color: Colors.transparent,
                      width: getPhoneWidth(context) / 2 - 22,
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          SizedBox(
                              width: 45,
                              child: Image.asset("assets/icons/1.png")),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Financat",
                            style: AppStyles.getHeaderNameText(
                                color: Colors.white,
                                size: 18.0,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) =>   OrderList()));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      color: Colors.transparent,
                      width: getPhoneWidth(context) / 2 - 22,
                      child: Row(
                        children: [
                          SizedBox(
                              width: 45,
                              child: Image.asset("assets/icons/1.png")),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Porosite",
                            style: AppStyles.getHeaderNameText(
                                color: Colors.white,
                                size: 18.0,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const BusinessProducts()));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      color: Colors.transparent,
                      width: getPhoneWidth(context) / 2 - 22,
                      child: Row(
                        children: [
                          SizedBox(
                              width: 45,
                              child: Image.asset("assets/icons/1.png")),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Produktet",
                            style: AppStyles.getHeaderNameText(
                                color: Colors.white,
                                size: 18.0,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [

                  GestureDetector(
                    onTap: () {
                      // Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Messages()));
                      showMessageModal(context, "Katalogu i porosive do te behet ne versionet e radhes.", 15.0);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      color: Colors.transparent,
                      width: getPhoneWidth(context) / 2 - 22,
                      child: Row(
                        children: [
                          SizedBox(
                              width: 45,
                              child: Image.asset("assets/icons/1.png")),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Katalogu im",
                            style: AppStyles.getHeaderNameText(
                                color: Colors.white,
                                size: 18.0,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const BusinessRules()));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      color: Colors.transparent,
                      width: getPhoneWidth(context) / 2 - 22,
                      child: Row(
                        children: [
                          SizedBox(
                              width: 45,
                              child: Image.asset("assets/icons/1.png")),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Regullorja",
                            style: AppStyles.getHeaderNameText(
                                color: Colors.white,
                                size: 18.0,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [

                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OnlineRequests()));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      color: Colors.transparent,
                      width: getPhoneWidth(context) / 2 - 22,
                      child: Row(
                        children: [
                          SizedBox(
                              width: 45,
                              child: Image.asset("assets/icons/1.png")),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: getPhoneWidth(context) / 2 - 95,
                            child: Text(
                              "Kerkesat online",
                              style: AppStyles.getHeaderNameText(
                                  color: Colors.white,
                                  size: 18.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const BusinessRules()));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      color: Colors.transparent,
                      width: getPhoneWidth(context) / 2 - 22,
                      child: Row(
                        children: [
                          SizedBox(
                              width: 45,
                              child: Image.asset("assets/icons/1.png")),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Regullorja",
                            style: AppStyles.getHeaderNameText(
                                color: Colors.white,
                                size: 18.0,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const MyChallenge()));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      color: Colors.transparent,
                      width: getPhoneWidth(context) / 2 - 22,
                      child: Row(
                        children: [
                          SizedBox(
                              width: 45,
                              child: Image.asset("assets/icons/1.png")),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Sfida ime",
                            style: AppStyles.getHeaderNameText(
                                color: Colors.white,
                                size: 18.0,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BusinessProfile()));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      color: Colors.transparent,
                      width: getPhoneWidth(context) / 2 - 22,
                      child: Row(
                        children: [
                          SizedBox(
                              width: 45,
                              child: Image.asset("assets/icons/1.png")),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Profili",
                            style: AppStyles.getHeaderNameText(
                                color: Colors.white,
                                size: 18.0,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [

                  GestureDetector(
                    onTap: () {
                      var drawer = Provider.of<GeneralProvider>(context, listen: false);
                      drawer.setDrawerFalse();
                      CurrentUserStorage currentUserStorage = CurrentUserStorage();
                      currentUserStorage.removeUser(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      color: Colors.transparent,
                      width: getPhoneWidth(context) / 2 - 22,
                      child: Row(
                        children: [
                          SizedBox(
                              width: 45,
                              child: Image.asset("assets/icons/1.png")),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Dil",
                            style: AppStyles.getHeaderNameText(
                                color: Colors.white,
                                size: 18.0,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
