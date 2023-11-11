import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hejposta/controllers/city_controller.dart';
import 'package:hejposta/controllers/registration_controller.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/city_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/shortcuts/modals.dart';
import 'package:provider/provider.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController username = TextEditingController();
  TextEditingController emriBiznesit = TextEditingController();
  TextEditingController shteti = TextEditingController();
  TextEditingController referalCode = TextEditingController();
  TextEditingController qyteti = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController adresa = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  FixedExtentScrollController fixedScrollController =  FixedExtentScrollController();

  var cityId = "";

  bool usernameEmpty = false;
  bool emriBiznesitEmpty = false;
  bool shtetiEmpty = false;
  bool qytetiEmpty = false;
  bool adresaEmpty = false;
  bool phoneNumberEmpty = false;
  bool emailEmpty = false;
  bool passwordEmpty = false;

  List<String> shtetet = [
    'Kosovë',
    'Maqedonia',
    'Shqipëri',
  ];
  List<String> qytetet = [];

  getQytetet() {
    CityController cityController = CityController();
    cityController.getQytetet(context);
  }
  register(){
    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');


      if(username.text.isNotEmpty && emriBiznesit.text.isNotEmpty && shteti.text.isNotEmpty && qyteti.text.isNotEmpty && adresa.text.isNotEmpty && phoneNumber.text.isNotEmpty && email.text.isNotEmpty && password.text.isNotEmpty){
        if(!regex.hasMatch(password.text)){
          showMessageModal(context, "Fjalekalimi duhet te permbaj minimum 8 karaktere dhe se paku, nje shkronje te madhe, nje shkonje te vogel, nje karakter dhe nje numer", 16);
          return ;
        }
        RegistrationController.register(context, username.text, emriBiznesit.text,shteti.text,cityId,adresa.text,phoneNumber.text,email.text,password.text,referalCode.text).
        then((value) {
          if(value == "success"){
            showMessageModal(context, "Urime! Ju jeni regjistruar me sukses.\nAdministrata do te ju kontaktoj per verifikim te llogarise", 16);
            setState(() {
              username.text = "";
              emriBiznesit.text = "";
              shteti.text = "";
              referalCode.text = "";
              qyteti.text = "";
              phoneNumber.text = "";
              adresa.text = "";
              email.text = "";
              password.text = "";
            });
          }
          else if(value == "failed"){
            showMessageModal(context, "Regjistrimi deshtoi!\nJu lutem kontaktoni administraten per sqarim.", 17);
          }
          else if(value.toString().contains("email")){
            showMessageModal(context, value['email'], 16,height: 140);
          }
          else if(value.toString().contains("username")){
            showMessageModal(context, value['username'], 16,height: 140);
          }

        });
      }
      else{
        showMessageModal(context, "Ju lutem plotesoni te gjitha fushat", 16,height: 140);

      }


  }

  @override
  void initState() {
    getQytetet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var qytetet = Provider.of<CityProvier>(context);
    var inputSpace = 20.0;
    return Scaffold(
      body: Container(
        width: getPhoneWidth(context),
        height: getPhoneHeight(context),
        decoration: BoxDecoration(
          color: AppColors.bottomColorOne.withOpacity(0.93),
        ),
       child: Column(
          children: [
            Container(
              height: 85,
              decoration: BoxDecoration(color: AppColors.appBarColor),
            ),
            Expanded(
              child: Stack(
                children: [
                  Stack(
                    children: [
                     Positioned(
                        width: getPhoneWidth(context),
                        height: getPhoneHeight(context),
                        child: Image.asset("assets/images/map-icon.png",fit: BoxFit.cover,color: const Color(0xffdb6921),),
                      ),
                      SizedBox(
                        width: getPhoneWidth(context),
                        height: getPhoneHeight(context),
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 180,child: Image.asset("assets/logos/hej-logo.png")),
                                const SizedBox(height: 50,),
                                Container(
                                  width: getPhoneWidth(context),
                                  margin: const EdgeInsets.symmetric(horizontal: 40),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: getPhoneWidth(context)  ,
                                    child: TextField(
                                      controller: username,
                                      decoration: InputDecoration(
                                          hintText: "Emri perdoruesit",
                                          hintStyle: AppStyles.inputTextModelOne,
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
                                  SizedBox(
                                  height: inputSpace,
                                ),
                                Container(
                                  width: getPhoneWidth(context),
                                  margin: const EdgeInsets.symmetric(horizontal: 40),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: getPhoneWidth(context)  ,
                                    child: TextField(
                                      controller: emriBiznesit,
                                      decoration: InputDecoration(
                                          hintText: "Emri biznesit",
                                          hintStyle: AppStyles.inputTextModelOne,
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
                                  SizedBox(
                                  height: inputSpace,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 40),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (shteti.text.isEmpty && shtetet.isNotEmpty) {
                                        setState(() {
                                          qyteti.text = qytetet.getCities().first.name!;
                                          cityId = qytetet.getCities().first.id!;
                                          shteti.text = shtetet[0];
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
                                                      cityId = qytetet
                                                          .getCitiesByState(shteti.text)
                                                          .isEmpty
                                                          ? ""
                                                          : qytetet
                                                          .getCitiesByState(shteti.text)
                                                          .elementAt(0)
                                                          .id!;
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
                                                    :shteti.text.isEmpty ? Colors.grey[500]: Colors.grey[900],
                                                size: 15.0),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                  SizedBox(
                                  height: inputSpace,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 40),
                                  child: GestureDetector(
                                    onTap: () {

                                      if (qyteti.text.isNotEmpty &&
                                          qytetet
                                              .getCitiesByState(shteti.text)
                                              .isNotEmpty) {
                                        setState(() {
                                          qyteti.text = qytetet
                                              .getCitiesByState(shteti.text)
                                              .elementAt(0)
                                              .name!;
                                          cityId = qytetet
                                              .getCitiesByState(shteti.text)
                                              .isEmpty
                                              ? ""
                                              : qytetet
                                              .getCitiesByState(shteti.text)
                                              .elementAt(0)
                                              .id!;
                                        });
                                        setState(() {
                                          qytetiEmpty = false;
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
                                                color: qytetiEmpty ? Colors.red :qyteti.text.isEmpty ? Colors.grey[500]: Colors.grey[900],
                                                size: 15.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                  SizedBox(
                                  height: inputSpace,
                                ),
                                Container(
                                  width: getPhoneWidth(context),
                                  margin: const EdgeInsets.symmetric(horizontal: 40),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: getPhoneWidth(context)  ,
                                    child: TextField(
                                      controller: phoneNumber,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          hintText: "Numri telefonit",
                                          hintStyle: AppStyles.inputTextModelOne,
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
                                  SizedBox(
                                  height: inputSpace,
                                ),
                                Container(
                                  width: getPhoneWidth(context),
                                  margin: const EdgeInsets.symmetric(horizontal: 40),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: getPhoneWidth(context)  ,
                                    child: TextField(
                                      controller: adresa,
                                      decoration: InputDecoration(
                                          hintText: "Adresa",
                                          hintStyle: AppStyles.inputTextModelOne,
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
                                  SizedBox(
                                  height: inputSpace,
                                ),
                                Container(
                                  width: getPhoneWidth(context),
                                  margin: const EdgeInsets.symmetric(horizontal: 40),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: getPhoneWidth(context)  ,
                                    child: TextField(
                                      controller: email,
                                      decoration: InputDecoration(
                                          hintText: "Adresa elektronike",
                                          hintStyle: AppStyles.inputTextModelOne,
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
                                SizedBox(
                                  height: inputSpace,
                                ),
                                Container(
                                  width: getPhoneWidth(context),
                                  margin: const EdgeInsets.symmetric(horizontal: 40),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: getPhoneWidth(context)  ,
                                    child: TextField(
                                      controller: password,
                                      decoration: InputDecoration(
                                          hintText: "Fjalekalimi",
                                          hintStyle: AppStyles.inputTextModelOne,
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
                                SizedBox(
                                  height: inputSpace,
                                ),
                                Container(
                                  width: getPhoneWidth(context),
                                  margin: const EdgeInsets.symmetric(horizontal: 40),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: getPhoneWidth(context)  ,
                                    child: TextField(
                                      controller: referalCode,
                                      decoration: InputDecoration(
                                          hintText: "Kodi referues (Opsionale)",
                                          hintStyle: AppStyles.inputTextModelOne,
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

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: getPhoneWidth(context) - 170,
                                      child: Divider(
                                        height: 10,
                                        thickness: 1.5,
                                        color: AppColors.lineColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 50,
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Text(
                                              "Kthehu pas",
                                              style: AppStyles.lineFont,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),


                    ],
                  ),
                  AnimatedPositioned(
                      bottom: 0,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.linearToEaseOut,
                      width: getPhoneWidth(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){
                              register();
                            },
                            child: Container(
                              width: 150,
                              height: 45,
                              decoration: BoxDecoration(
                                color: AppColors.inputColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                              ),
                              child: Center(
                                  child: Text(
                                    "Regjistrohu",
                                    style: AppStyles.fontModelTow,
                                  )),
                            ),
                          )
                        ],
                      ))
                ],
              ),
            ),
            Container(
              height: 80,
              width: getPhoneWidth(context),
              decoration: BoxDecoration(color: AppColors.bottomColorTwo),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 70,child: Image.asset("assets/images/6.png")),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
