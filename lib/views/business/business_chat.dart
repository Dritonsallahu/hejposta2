import 'package:flutter/material.dart';
import 'package:hejposta/controllers/messages_controller.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/providers/messages_provider.dart';
import 'package:hejposta/providers/server_provider.dart';
import 'package:hejposta/providers/user_provider.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/views/postman/postman_drawer.dart';
import 'package:provider/provider.dart';

class BusinessChat extends StatefulWidget {
  const BusinessChat({Key? key}) : super(key: key);

  @override
  State<BusinessChat> createState() => _BusinessChatState();
}

class _BusinessChatState extends State<BusinessChat> {
  final TextEditingController _message = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  bool fetching = false;

  sendMessage() {
    MessagesController messagesController = MessagesController();
    messagesController.sendMessage(context, _message.text).whenComplete(() {
      setState(() {
        _message.text = "";
      });
    });
  }

  @override
  void initState() {
    setState(() {
      fetching = true;
    });
    MessagesController messagesController = MessagesController();
    messagesController.getMessages(context).whenComplete(() {
      WidgetsFlutterBinding.ensureInitialized()
          .addPostFrameCallback((timeStamp) {
        ServerProvider server = Provider.of<ServerProvider>(context, listen: false);
        var messages = Provider.of<MessagesProvider>(context, listen: false);
        server.joinRoom(context, messages.adminId);
        messages.jumpToBottom();
      });

      setState(() {
        fetching = false;
      });
    });

    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var generalProvider = Provider.of<GeneralProvider>(context);
    var serverProvider = Provider.of<ServerProvider>(context);
    var messagesProvider = Provider.of<MessagesProvider>(context);
    var user = Provider.of<UserProvider>(context);
    return WillPopScope(
      onWillPop: () async{
        // serverProvider.leaveRoom(context);
        return Future.value(false);
      },
      child: Scaffold(
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
        body: SingleChildScrollView(
          child: Column(
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
                    ),
                  ),
                  SizedBox(
                    width: getPhoneWidth(context),
                    height: getPhoneHeight(context) - 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 28, right: 20, top: 10),
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
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Administrata",
                                        style: AppStyles.getHeaderNameText(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            size: 20.0),
                                      ),
                                      serverProvider.socketConnectionType ==
                                              SocketConnectionType.connected
                                          ? const SizedBox()
                                          : Text(
                                              serverProvider.socketConnectionType ==
                                                      SocketConnectionType
                                                          .connecting
                                                  ? "Duke u lidhur"
                                                  : serverProvider
                                                              .socketConnectionType ==
                                                          SocketConnectionType
                                                              .failed
                                                      ? "Lidhja deshtoi"
                                                      : "Nuk jeni te lidhur",
                                              style: AppStyles.getHeaderNameText(
                                                  color: Colors.blueGrey[700],
                                                  fontWeight: FontWeight.w500,
                                                  size: 13.0),
                                            ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 13),
                                    child: Row(
                                      children: const [
                                        SizedBox(
                                          width: 50,
                                          height: 26,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              color: Colors.white,
                              height: 2,
                            ),
                            SizedBox(
                              height: getPhoneHeight(context) - 190,
                              child: fetching
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 1.5,
                                    ))
                                  : messagesProvider.getMessages().isEmpty
                                      ? Center(
                                          child: Text(
                                          "Ska asnje mesazh!",
                                          style: AppStyles.getHeaderNameText(
                                              color: Colors.white, size: 15.0),
                                        ))
                                      : ListView.builder(
                                          padding: const EdgeInsets.all(0),
                                          controller: messagesProvider.getScroll(),
                                          itemBuilder: (context, index) {
                                            var message = messagesProvider
                                                .getMessages()[index];
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 7, horizontal: 10),
                                              child: Row(
                                                mainAxisAlignment: (message.by ==
                                                        user.getUser()!.user.id)
                                                    ? MainAxisAlignment.end
                                                    : MainAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: (message
                                                                .by ==
                                                            user.getUser()!.user.id)
                                                        ? CrossAxisAlignment.end
                                                        : CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 10,
                                                            vertical: 8),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(14),
                                                            color: (message.by ==
                                                                    user
                                                                        .getUser()!
                                                                        .user
                                                                        .id)
                                                                ? Colors.transparent
                                                                : AppColors
                                                                    .bottomColorOne,
                                                            border: Border.all(
                                                                color: (message
                                                                            .by ==
                                                                        user
                                                                            .getUser()!
                                                                            .user
                                                                            .id)
                                                                    ? Colors.white
                                                                    : Colors
                                                                        .transparent)),
                                                        constraints: BoxConstraints(
                                                            maxWidth: getPhoneWidth(
                                                                    context) *
                                                                0.7),
                                                        child: Text(
                                                          message.message!.trim(),
                                                          style: AppStyles
                                                              .getHeaderNameText(
                                                                  color:
                                                                      Colors.white,
                                                                  size: 15.0),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 3,
                                                      ),
                                                      Text(
                                                        message.createdAt!
                                                            .substring(0, 10),
                                                        style: AppStyles
                                                            .getHeaderNameText(
                                                                color: Colors.white,
                                                                size: 12.0),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          itemCount:
                                              messagesProvider.getMessages().length,
                                        ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15,right: 5),
                          child: SizedBox(
                            width: getPhoneWidth(context),

                            height: 55,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: getPhoneWidth(context) - 80,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100)
                                  ),
                                  child: TextField(
                                    controller: _message,
                                    minLines: 1,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(100),
                                          borderSide: BorderSide(
                                              color: Colors.blueGrey[400]!)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(100),
                                          borderSide: const BorderSide(
                                              color: Colors.transparent)),
                                      isDense: true,
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 18),
                                    ),
                                  ),
                                ),
                                IconButton(
                                    padding: const EdgeInsets.only(right: 25),
                                    onPressed: () {
                                      sendMessage();
                                    },
                                    icon: const Icon(
                                      Icons.send,size: 30,
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
