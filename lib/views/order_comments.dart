import 'package:flutter/material.dart';
import 'package:hejposta/controllers/comment_controller.dart';
import 'package:hejposta/models/comment_model.dart';
import 'package:hejposta/models/order_model.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/shortcuts/modals.dart';
import 'package:provider/provider.dart';

class OrderComments extends StatefulWidget {
  final OrderModel? orderModel;
  const OrderComments({Key? key, this.orderModel}) : super(key: key);

  @override
  State<OrderComments> createState() => _OrderCommentsState();
}

class _OrderCommentsState extends State<OrderComments> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final TextEditingController _newComment = TextEditingController();
  bool fetching = false;
  List<CommentModel> _comments = [];

  getComments() {
    setState(() {
      fetching = true;
    });
    CommentController commentController = CommentController();
    commentController.getComments(context, widget.orderModel!.id).then((value) {
      if (value == "failed") {
        showModalOne(
            context,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Ka ndodhur nje problem!",
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
      } else {
        setState(() {
          _comments = value as List<CommentModel>;
        });
      }
    })
    .whenComplete(() {
      setState(() {
        fetching = false;
      });
    });
  }

  addComment() {
    setState(() {
      fetching = true;
    });
    CommentController commentController = CommentController();
    commentController
        .addComment(context, widget.orderModel!, _newComment.text)
        .then((value) {
      if (value != "error" && value != "failed") {
        _comments.insert(0, value);
        setState(() {
          _newComment.text = "";
        });
        getComments();
      } else if (value == "failed") {
        showModalOne(
            context,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Ka ndodhur nje problem!",
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
    })
    .whenComplete((){
      setState(() {
        fetching = false;
      });
    });
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      getComments();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var generalProvider = Provider.of<GeneralProvider>(context, listen: true);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.bottomColorOne,
      drawerScrimColor: Colors.transparent,
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      onDrawerChanged: (status) {
        generalProvider.changeDrawerStatus(status);
        setState(() {});
      },
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).viewPadding.top,
              decoration: BoxDecoration(color: AppColors.appBarColor),
            ),
            Stack(
              children: [
                AnimatedPositioned(
                    duration: const Duration(
                      seconds: 20,
                    ),
                    child: SizedBox(
                      height: getPhoneHeight(context) -
                          MediaQuery.of(context).viewPadding.top,
                      child: Image.asset(
                        "assets/icons/map-icon.png",
                        fit: BoxFit.cover,
                        color: AppColors.mapColorSecond,
                        filterQuality: FilterQuality.high,
                      ),
                    )),
                SizedBox(
                  width: getPhoneWidth(context),
                  height: getPhoneHeight(context) -
                      MediaQuery.of(context).viewPadding.top,
                  child: Column(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.only(left: 25, right: 13, top: 10),
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
                              "Komentet",
                              style: AppStyles.getHeaderNameText(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  size: 20.0),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              child: Row(
                                children: [
                                   SizedBox(
                                    width: 60,
                                    child: Row(
                                      children: [fetching ? const SizedBox(width: 22,height: 22,child: CircularProgressIndicator(color: Colors.white,strokeWidth: 1.5,)):const SizedBox()],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: _comments.isEmpty
                              ? Center(
                                  child: Text(
                                  "Ska asnje koment!",
                                  style: AppStyles.getHeaderNameText(
                                      color: Colors.white, size: 15.0),
                                ))
                              : RefreshIndicator(
                                  onRefresh: () async {
                                    getComments();
                                  },
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(10),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 55,
                                              height: 55,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  color: Colors.grey[200]),
                                              child: Icon(
                                                Icons.person,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width:
                                                      getPhoneWidth(context) -
                                                          110,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        _comments[index]
                                                            .user['username'],
                                                        style: AppStyles
                                                            .getHeaderNameText(
                                                                color: Colors
                                                                        .blueGrey[
                                                                    800],
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                size: 17.0),
                                                      ),
                                                      Text(
                                                         checkTime(DateTime
                                                            .parse(_comments[
                                                                    index]
                                                                .updatedAt!)),
                                                        style: AppStyles
                                                            .getHeaderNameText(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                size: 13.0),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                    width:
                                                        getPhoneWidth(context) -
                                                            110,
                                                    child: Text(
                                                      _comments[index].body,
                                                      style: AppStyles
                                                          .getHeaderNameText(
                                                              color: Colors
                                                                      .blueGrey[
                                                                  900],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              size: 15.0),
                                                    ))
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    itemCount: _comments.length,
                                  ),
                                )),
                      Stack(
                        children: [
                          Container(
                            width: getPhoneWidth(context),
                            height: 90,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 80),
                              child: TextField(
                                controller: _newComment,
                                textInputAction: TextInputAction.go,
                                minLines: 1,
                                maxLines: 4,
                                decoration: const InputDecoration(
                                  hintText: "Komento",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              right: 10,
                              child: IconButton(
                                  onPressed: () {
                                    addComment();
                                  },
                                  icon: Icon(
                                    Icons.send,
                                    color: AppColors.bottomColorTwo,
                                  )))
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
