import 'package:flutter/material.dart';
import 'package:hejposta/local_storage/current_user_storage.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/views/authentication.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int animationStep = 0;
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1600)).then((value) {
      setState(() {
        animationStep = 1;
      });
      Future.delayed(const Duration(seconds: 2)).then((value) {
        setState(() {
          animationStep = 2;
        });
      }).then((value) async  {
        await Future.delayed(const Duration(seconds: 2));
          CurrentUserStorage currentUserStorage = CurrentUserStorage();
          currentUserStorage.getUser(context);
      });
    });

    super.initState();
  }

  autoLogin(){

  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: getPhoneWidth(context),
                    height: getPhoneHeight(context),
                    decoration: BoxDecoration(
                        color: AppColors.inputColor,
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/nature.png"))),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: getPhoneWidth(context),
                    height: getPhoneHeight(context) * 0.24,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/nature2.png"))),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(
                    milliseconds: 2500,
                  ),
                  curve: Curves.linearToEaseOut,
                  top: 100,
                  right: animationStep == 0
                      ? -150
                      : animationStep == 1
                          ? 150
                          : 450,
                  child: Container(
                    height: 120,
                    width: 140,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage("assets/images/hej-icon.png"))),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(
                    milliseconds: 1500,
                  ),
                  curve: Curves.linearToEaseOut,
                  top: -20,
                  left: animationStep == 0
                      ? -440
                      : animationStep == 1
                          ? 0
                          : 440,
                  child: Stack(
                    children: [
                      Container(
                        height: 420,
                        width: 440,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.contain,
                                image: AssetImage("assets/images/5.png"))),
                      ),
                      Positioned(
                        top: 140,
                        left: 150,
                        child: Container(
                          height: 320,
                          width: 340,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: AssetImage("assets/images/5.png"))),
                        ),
                      ),
                      Positioned(
                        top: 100,
                        right: 150,
                        child: Container(
                          height: 320,
                          width: 340,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: AssetImage("assets/images/5.png"))),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
