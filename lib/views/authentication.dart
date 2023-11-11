import 'package:flutter/material.dart';
import 'package:hejposta/controllers/login_controller.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/views/registration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isPasswordSeen = true;
  bool logging = false;
  authenticate() {
    setState(() {
      logging = true;
    });
    LoginController.authenticate(username.text, password.text, context)
        .then((value) {
      if (value == "success") {
        saveLog();
      } else {
        showDialog(
            context: context,
            builder: (contex) {
              return AlertDialog(
                title: Center(
                    child: Text(
                  value.toString(),textAlign: TextAlign.center,
                  style: AppStyles.getHeaderNameText(
                      color: Colors.blueGrey, size: 15),
                )),
                actions: [
                  Center(
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Mbyll",
                          style: AppStyles.getHeaderNameText(
                          color: Colors.blueGrey, size: 15),
                        )),
                  )
                ],
              );
            });
      }
    }).whenComplete(() {

      setState(() {
        logging = false;
      });
    });
  }

  saveLog() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("hejposta_2-log", true);
    preferences.setString("hejposta_2-log-username", username.text);
  }

  getLogs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var log = preferences.getBool("hejposta_2-log");
    if (log != null && log != false) {
      setState(() {
        username.text = preferences.getString("hejposta_2-log-username")!;
      });
    }
  }

  @override
  void initState() {
    getLogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
            decoration: BoxDecoration(color: AppColors.appBarColor),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: getPhoneWidth(context),
                  decoration: BoxDecoration(
                      color: AppColors.bottomColorTwo,
                      image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/map-icon.png"))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: const DecorationImage(
                                image: AssetImage("assets/images/avatar.png"))),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        "HEJ, Mireseerdhe knej!",
                        style: AppStyles.fontModelOne,
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      Container(
                        width: getPhoneWidth(context),
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Perdoruesi",
                              style: AppStyles.fontModelTow,
                            ),
                            SizedBox(
                              width: getPhoneWidth(context) - 200,
                              child: TextField(
                                controller: username,
                                decoration: InputDecoration(
                                    hintText: "Filan",
                                    hintStyle: AppStyles.fontModelThree,
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
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: getPhoneWidth(context),
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.only(left: 20,right: 5),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Fjalekalimi",
                              style: AppStyles.fontModelTow,
                            ),
                            SizedBox(
                              width: getPhoneWidth(context) - 210,
                              child: TextField(
                                controller: password,
                                obscureText: isPasswordSeen,
                                decoration: InputDecoration(
                                    hintText: "**********",
                                    hintStyle: AppStyles.fontModelThree,
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
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  isPasswordSeen = !isPasswordSeen;
                                });
                              },
                              child: Container(
                                color: Colors.transparent,
                                width: 30,
                                height: 40,
                                child: Icon(isPasswordSeen ? Icons.visibility_off:Icons.visibility),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: getPhoneWidth(context) - 220,
                            child: Divider(
                              height: 10,
                              thickness: 1.5,
                              color: AppColors.lineColor,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => const Registration()));
                            },
                            child: Container(
                              height: 50,
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Text(
                                    "Krijo llogari, nese nuk ki",
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
                AnimatedPositioned(
                    bottom: 0,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.linearToEaseOut,
                    width: getPhoneWidth(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if(!logging){
                              authenticate();
                            }
                            // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>   BusinessOrders()));
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
                                child: logging ? const SizedBox(width: 25,height: 25,child: CircularProgressIndicator(strokeWidth: 1.3,color: Colors.black,)) :Text(
                              "Hyr",
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
            decoration: BoxDecoration(color: AppColors.bottomColorOne),
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 70, child: Image.asset("assets/images/6.png")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
