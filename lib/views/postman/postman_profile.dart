import 'package:flutter/material.dart';
import 'package:hejposta/controllers/profile_controller.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/user_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/shortcuts/modals.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostmanProfile extends StatefulWidget {
  const PostmanProfile({Key? key}) : super(key: key);

  @override
  State<PostmanProfile> createState() => _PostmanProfileState();
}

class _PostmanProfileState extends State<PostmanProfile> {
  TextEditingController fullName = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController clients = TextEditingController();
  TextEditingController units = TextEditingController();
  TextEditingController cities = TextEditingController();
  TextEditingController salary = TextEditingController();
  TextEditingController bonusi = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();

  List<String> clientsList = [];
  List<String> unitsList = [];
  List<String> citiesList = [];
  List<String> areasList = [];

  updateProfile() async {
    var postman = Provider.of<UserProvider>(context, listen: false);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(postman.getUser()!.user.username == username.text &&
        postman.getUser()!.user.email == email.text &&
        oldPassword.text.isEmpty && newPassword.text.isEmpty
    ){
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
    else{
      ProfileController().updateProfile(context, username.text,oldPassword.text,newPassword.text, email: email.text).then((value){

        if(value == "success"){
          preferences.setString("hejposta_2-user-email", email.text);
          postman.changeEmail(email.text);
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
    ProfileController profileController = ProfileController();
    profileController.getProfile(context).then((value){
      setState(() {
        print(value );
        for(int i=0;i<value['units'].length;i++){
          unitsList.add(value['units'][i]['unitName']);
        }
        for(int i=0;i<value['clients'].length;i++){
          clientsList.add(value['client'][i]['businessName']);
        }
        for(int i=0;i<value['cities'].length;i++){
          citiesList.add(value['cities'][i]['name']);
        }
        for(int i=0;i<value['areas'].length;i++){
          areasList.add(value['areas'][i]['name']+" - "+ value['areas'][i]['cityName']);
        }
      });
    });
  }

  getUnits(){}

  getCitites(){}



  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp){
      var postman = Provider.of<UserProvider>(context, listen: false);
      fullName.text = postman.getUser()!.fullName;
      username.text = postman.getUser()!.user.username;
      salary.text = postman.getUser()!.salary.toString();
      bonusi.text = postman.getUser()!.onSuccessDeliveryBonus.toString();
      note.text = postman.getUser()!.note;
      phoneNumber.text = postman.getUser()!.phoneNumber;
      email.text = postman.getUser()!.user.email;
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
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 13),
                                        child: Row(
                                          children: [
                                            SizedBox(width: 30,),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20,),
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
                                            return clientsList.isEmpty ? Center(child: Text("Nuk keni asnje biznes",style: AppStyles.getHeaderNameText(color: Colors.blueGrey,size: 16.0),),):ListView(
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
                                                                Container(
                                                                    width: getPhoneWidth(
                                                                        context) -
                                                                        133,
                                                                    child: Text(
                                                                      clientsList[index],
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
                                                  itemCount: clientsList.length,
                                                ),
                                              ],
                                            );
                                          }), 415.0);
                                    },
                                    child: Container(
                                        color: Colors.transparent,

                                      width: getPhoneWidth(context)  ,
                                      child: TextField(
                                        controller: TextEditingController(text: "${clientsList.length} biznese"),
                                        enabled: false,
                                        decoration: InputDecoration(
                                            hintText: "Bizneset",
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
                                                                Container(
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
                                  child: GestureDetector(
                                    onTap: (){
                                      showModalOne(context, StatefulBuilder(
                                          builder: (context, setter) {
                                            return citiesList.isEmpty ? Center(child: Text("Nuk keni asnje qytet",style: AppStyles.getHeaderNameText(color: Colors.blueGrey,size: 16.0),),):ListView(
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
                                                                Container(
                                                                    width: getPhoneWidth(
                                                                        context) -
                                                                        133,
                                                                    child: Text(
                                                                      citiesList[index],
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
                                                  itemCount: citiesList.length,
                                                ),

                                              ],
                                            );
                                          }), 415.0);
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      width: getPhoneWidth(context)  ,
                                      child: TextField(
                                        controller: TextEditingController(text: "${citiesList.length} qytete"),
                                        enabled: false,
                                        decoration: InputDecoration(
                                            hintText: "Qytetet",
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
                                      controller: salary,
                                      readOnly: true,
                                      decoration: InputDecoration(
                                          hintText: "Pagesa",
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
                                      controller: bonusi,
                                      readOnly: true,
                                      decoration: InputDecoration(
                                          hintText: "Bounsi per porosi",
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
