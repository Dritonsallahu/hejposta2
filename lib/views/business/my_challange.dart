import 'package:flutter/material.dart';
import 'package:hejposta/controllers/goals_controller.dart';
import 'package:hejposta/models/goal_model.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/shortcuts/modals.dart';
import 'package:hejposta/views/business/new_challange.dart';
import 'package:hejposta/views/postman/postman_drawer.dart';
import 'package:provider/provider.dart';

class MyChallenge extends StatefulWidget {
  const MyChallenge({super.key});

  @override
  State<MyChallenge> createState() => _MyChallengeState();
}

class _MyChallengeState extends State<MyChallenge> {
  TextEditingController kerkoSfiden = TextEditingController();
  List<GoalModel> _goals = [];
  bool fetching = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  getGoals(){
    setState(() {
      fetching = true;
    });
    GoalsController goalsController = GoalsController();
    goalsController.getGoals(context).then((value) {
      if(value == "failed"){
        showModalOne(
            context,
            Column(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Ka ndodhur nje problem!",
                      style: AppStyles.getHeaderNameText(
                          color: Colors.blueGrey[800],
                          size: 17),
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
      else{
        setState(() {
          _goals = value;
        });
      }
    }).whenComplete((){
      setState(() {
        fetching = false;
      });
    });
  }

  @override 
  void initState() {
    getGoals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var generalProvider = Provider.of<GeneralProvider>(context, listen: true);
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
      body: ListView(
        padding: const EdgeInsets.all(0),
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
                child: ListView(
                  padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
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
                            "Sfida ime",
                            style: AppStyles.getHeaderNameText(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                size: 20.0),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NewChallage()));
                        },
                        child: Container(
                          width: getPhoneWidth(context),
                          height: 45,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                              color: Colors.white
                          ),
                          child: Center(
                            child: Text("Regjistro sfiden",style: AppStyles.getHeaderNameText(color: Colors.blueGrey[800],size: 15),),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                     fetching ? Center(child: const CircularProgressIndicator(color: Colors.white,strokeWidth: 1.4,)): _goals.isEmpty ? Center(child:   Text("Nuk keni regjistruar sfide",style: AppStyles.getHeaderNameText(color: Colors.white,size: 15.0),)):Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: ListView.builder(padding: EdgeInsets.zero,physics: const ScrollPhysics(),shrinkWrap: true,
                        itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                 SizedBox(
                                   width: getPhoneWidth(context)/2 - 40,
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Text("Prej: ${_goals[index].startDate.toString().substring(0,10)}",style: AppStyles.getHeaderNameText(color: Colors.blueGrey[800],size: 17.0),),
                                       const SizedBox(height: 15,),
                                       Text("Prej: ${_goals[index].startDate.toString().substring(0,10)}",style: AppStyles.getHeaderNameText(color: Colors.blueGrey[800],size: 17.0),),
                                     ],
                                   ),
                                 ),
                                SizedBox(
                                  width: getPhoneWidth(context)/2 - 50,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Target: ${_goals[index].orderNumber}",style: AppStyles.getHeaderNameText(color: Colors.blueGrey[800],size: 17.0),),
                                      const SizedBox(height: 15,),
                                      Text("Perfunduar: ${_goals[index].numberCompleted}",style: AppStyles.getHeaderNameText(color: Colors.blueGrey[800],size: 17.0),)
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },itemCount: _goals.length,),
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
