import 'package:flutter/material.dart';
import 'package:hejposta/controllers/registration_controller.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController emriMbiemri = TextEditingController();
  TextEditingController emriBiznesit = TextEditingController();
  TextEditingController qyteti = TextEditingController();
  TextEditingController adresa = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  register(){
    RegistrationController.register(emriMbiemri.text, emriBiznesit.text,qyteti.text,adresa.text,email.text,password.text);
  }
  @override
  Widget build(BuildContext context) {
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
              child: Container(
                child: Stack(
                  children: [
                    Stack(
                      children: [
                       Positioned(
                          width: getPhoneWidth(context),
                          height: getPhoneHeight(context),
                          child: Container(
                            child: Image.asset("assets/images/map-icon.png",fit: BoxFit.cover,color: const Color(0xffdb6921),),
                          ),
                        ),
                        Container(
                          width: getPhoneWidth(context),
                          height: getPhoneHeight(context),
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(width: 180,child: Image.asset("assets/logos/hej-logo.png")),
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
                                        controller: emriMbiemri,
                                        decoration: InputDecoration(
                                            hintText: "Emri dhe mbiemri",
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
                                        controller: qyteti,
                                        decoration: InputDecoration(
                                            hintText: "Qyteti",
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
