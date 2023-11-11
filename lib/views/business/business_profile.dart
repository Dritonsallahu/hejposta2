import 'package:flutter/material.dart';
import 'package:hejposta/controllers/client_profile_controller.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/user_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/shortcuts/modals.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessProfile extends StatefulWidget {
  const BusinessProfile({Key? key}) : super(key: key);

  @override
  State<BusinessProfile> createState() => _BusinessProfileState();
}

class _BusinessProfileState extends State<BusinessProfile> {
  TextEditingController fullName = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController units = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController comment = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();

  List<String> unitsList = [];

  updateProfile() async {
    var client = Provider.of<UserProvider>(context, listen: false);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if(client.getUser()!.user.username == username.text &&
        client.getUser()!.user.email == email.text &&
        oldPassword.text.isEmpty && newPassword.text.isEmpty
    ){
      // ignore: use_build_context_synchronously
      showModalOne(
          context,
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "Te dhenat nuk jane ndryshuar!",
                    style: AppStyles.getHeaderNameText(
                        color: Colors.blueGrey[800], size: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 40,
                      // ignore: use_build_context_synchronously
                      width: getPhoneWidth(context) / 2 - 80,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(100)),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Largo",
                            style: AppStyles.getHeaderNameText(
                                color: Colors.white, size: 17),
                          ))),
                ],
              )
            ],
          ),
          150.0);
    }
    else if(!regex.hasMatch(newPassword.text)){
      // ignore: use_build_context_synchronously
      showModalOne(
          context,
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "Fjalekalimi duhet te permbaj minimum 8 karaktere dhe se paku, nje shkronje te madhe, nje shkonje te vogel, nje karakter dhe nje numer",
                    style: AppStyles.getHeaderNameText(
                        color: Colors.blueGrey[800], size: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 40,
                      // ignore: use_build_context_synchronously
                      width: getPhoneWidth(context) / 2 - 80,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(100)),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Largo",
                            style: AppStyles.getHeaderNameText(
                                color: Colors.white, size: 17),
                          ))),
                ],
              )
            ],
          ),
          160.0);
    }
    else{
      // ignore: use_build_context_synchronously
      ClientProfileController().updateProfile(context, username.text,oldPassword.text,newPassword.text, email.text).then((value){

        if(value == "success"){
          preferences.setString("hejposta_2-user-email", email.text);
          client.changeEmail(email.text);
          showModalOne(
              context,
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        "Te dhenat u perditesuan me sukses.",
                        style: AppStyles.getHeaderNameText(
                            color: Colors.blueGrey[800], size: 18),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 40,
                          width: getPhoneWidth(context) / 2 - 80,
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(100)),
                          child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Largo",
                                style: AppStyles.getHeaderNameText(
                                    color: Colors.white, size: 17),
                              ))),
                    ],
                  )
                ],
              ),
              150.0);
          setState(() {
            oldPassword.text = "";
            newPassword.text = "";
          });
        }
        else if(value == "WrongPassword"){
          showModalOne(
              context,
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        "Fjalekalimi vjeter eshte gabim!",
                        style: AppStyles.getHeaderNameText(
                            color: Colors.blueGrey[800], size: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 40,
                          width: getPhoneWidth(context) / 2 - 80,
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(100)),
                          child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Largo",
                                style: AppStyles.getHeaderNameText(
                                    color: Colors.white, size: 17),
                              ))),
                    ],
                  )
                ],
              ),
              150.0);
        }
      });
    }

  }

  getProfile(){
    ClientProfileController profileController = ClientProfileController();
    profileController.getProfile(context).then((value){
      if(value == "success"){
        setState(() {
          for(int i=0;i<value['units'].length;i++){
            unitsList.add(value['units'][i]['unitName']);
          }
        });
      }


    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp){
      var client = Provider.of<UserProvider>(context, listen: false);
      fullName.text = client.getUser()!.businessName;
      city.text = client.getUser()!.city['name'];
      state.text = client.getUser()!.state;
      username.text = client.getUser()!.user.username;
      comment.text = client.getUser()!.comment;
      phoneNumber.text = client.getUser()!.phoneNumber;
      email.text = client.getUser()!.user.email;
    });
    getProfile();
    super.initState();
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
              height: MediaQuery.of(context).viewPadding.top,
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
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                      "Profili",
                                      style: AppStyles.getHeaderNameText(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          size: 20.0),
                                    ),
                                    const SizedBox(width: 60,),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20,),
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
                                    controller: fullName,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                        hintText: "Emri i biznesit",
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
                                    controller: username,
                                    decoration: InputDecoration(
                                        hintText: "Emri i perdoruesit",
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
                                child: GestureDetector(
                                  onTap: (){
                                    showModalOne(context, StatefulBuilder(
                                        builder: (context, setter) {
                                          return unitsList.isEmpty ? Center(child: Text("Nuk keni asnje njesi",style: AppStyles.getHeaderNameText(color: Colors.blueGrey,size: 16.0),),):ListView(
                                            children: [
                                              ListView.builder(
                                                physics: const ScrollPhysics(),
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return Column(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {

                                                        },
                                                        child: Container(
                                                          width: getPhoneWidth(
                                                              context) -
                                                              50,
                                                          height: 60,
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 15),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey[200]!)),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                  width: getPhoneWidth(
                                                                      context) -
                                                                      133,
                                                                  child: Text(
                                                                    unitsList[index],
                                                                    maxLines: 2,
                                                                    overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                    style: AppStyles
                                                                        .getHeaderNameText(
                                                                        color: Colors
                                                                            .blueGrey,
                                                                        size:
                                                                        16.0),
                                                                  )),
                                                              Container(
                                                                width: 25,
                                                                height: 25,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        100),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .blueGrey)),
                                                                child:  Container(
                                                                  width: 25,
                                                                  height: 25,
                                                                  margin: const EdgeInsets
                                                                      .all(2),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius.circular(
                                                                          100),
                                                                      color: Colors
                                                                          .blueGrey),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                    ],
                                                  );
                                                },
                                                itemCount: unitsList.length,
                                              ),

                                            ],
                                          );
                                        }), 415.0);
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    width: getPhoneWidth(context)  ,
                                    child: TextField(
                                      controller: TextEditingController(text: "${unitsList.length} njesi"),
                                      enabled: false,
                                      decoration: InputDecoration(
                                          hintText: "Njesite",
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
                                          disabledBorder:  const OutlineInputBorder(
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
                                    controller: city,
                                    readOnly: true,
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
                                    controller: state,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                        hintText: "Shteti",
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
                                    controller: oldPassword,
                                    decoration: InputDecoration(
                                        hintText: "Fjalekalimi i vjeter",
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
                                    controller: newPassword,
                                    decoration: InputDecoration(
                                        hintText: "Fjalekalimi i i ri",
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

                            ],
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
                              updateProfile();
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
                                    "Perditeso",
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
