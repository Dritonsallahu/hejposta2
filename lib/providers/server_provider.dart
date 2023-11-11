
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hejposta/main.dart';
import 'package:hejposta/models/message_model.dart';
import 'package:hejposta/providers/messages_provider.dart';
import 'package:hejposta/providers/user_provider.dart';
import 'package:hejposta/shortcuts/urls.dart';
import 'package:provider/provider.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum SocketConnectionType { connecting, connected, disconnected, failed }

class ServerProvider extends ChangeNotifier {
  IO.Socket? socket;
  SocketConnectionType socketConnectionType = SocketConnectionType.connecting;

  initServer(context){
    socket = IO.io(
        '$protocol$host',
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .setExtraHeaders({'foo': 'bar'}) // optional
            .build());
    socket!.connect();
    onConnection();
    onDisconnect(context);
    onReconnecting(context);
    joinConnection(context);
    onRecievingMessage(context);
    onRecievingMessageRoom(context);
    onReconnect(context);
    onReconnecting(context);
    onReconnectError(context);
    onReconnectFailed(context);

    notifyListeners();
  }

  // ignore: avoid_print
  onConnection() {
    socket!.onConnect((_) {
      socketConnectionType = SocketConnectionType.connected;
    });
    notifyListeners();
  }

  joinConnection(context) {
    if (kDebugMode) {
      print("joining");
    }
    var user = Provider.of<UserProvider>(context, listen: false);
    socket!.emitWithAck("join", [
      {"myId": user.getUser()!.user.id, "client": user.getUser()!.clientId}
    ], ack: (data) {
      if (kDebugMode) {
        print(data);
      }
    });
  }

  joinRoom(context, admin) {

    var user = Provider.of<UserProvider>(context, listen: false);
    print("joinig room");
    if(socket == null){
      initServer(context);
    }
    print("---");
    socket!.emitWithAck(
        "joinRoom", {"myId": user.getUser()!.user.id, "otherUserId": admin},
        ack: (data) {
      if (kDebugMode) {
        print(data);
      }
    });
  }

  leaveRoom(context,userId) {
      print("leaving in room");


    socket!.emit("leaveRoom", {"userId": userId});
  }

  // ignore: avoid_print
  onDisconnect(context) {
    socket!.onDisconnect((_) {
      socketConnectionType = SocketConnectionType.disconnected;
      notifyListeners();
    });
  }

  // ignore: avoid_print
  onReconnecting(context) {
    socket!.onReconnecting((_) {
      socketConnectionType = SocketConnectionType.connecting;
      notifyListeners();
    });
  }

  // ignore: avoid_print
  onReconnect(context) {
    socket!.onReconnect((_) {
      socketConnectionType = SocketConnectionType.connected;
      joinConnection(context);
      notifyListeners();
    });
  }

  // ignore: avoid_print
  onReconnectError(context) {
    socket!.onReconnectError((_) {
      socketConnectionType = SocketConnectionType.failed;
      notifyListeners();
    });
  }

  // ignore: avoid_print
  onReconnectFailed(context) {
    socket!.onReconnectFailed((_) {
      socketConnectionType = SocketConnectionType.failed;
      notifyListeners();
    });
  }

  sendMessage(reciever, sender, message) {
    socket!.emitWithAck(
        "messageSend", {"userId": reciever, "myId": sender, "message": message},
        ack: (data) {
      notifyListeners();
    });
  }

  onRecievingMessage(context) {
    var messagesProvider =
        Provider.of<MessagesProvider>(context, listen: false);
    var user = Provider.of<UserProvider>(context, listen: false);
    socket!.on("reciveMessage", (data) {
      print(data);
      messagesProvider.addMessage(
        MessageModel(
          by: messagesProvider.adminId,
          to: user.getUser()!.clientId,
          message: data['message'],
          status: "delivered",
          updatedAt: DateTime.now().toIso8601String(),
          createdAt: DateTime.now().toIso8601String(),
        ),outside: true
      );
      flutterLocalNotificationsPlugin.show(
          DateTime.now().hashCode,
          "Hejposta",
           data['message'],
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              importance: Importance.max,

              priority: Priority.max,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: '@mipmap/ic_launcher',
            ),
          ));
      messagesProvider.countUnreadMessages();
    });
  }

  onRecievingMessageRoom(context) {
    var messagesProvider = Provider.of<MessagesProvider>(context, listen: false);
    var user = Provider.of<UserProvider>(context, listen: false);
    socket!.on("reciveMessageRoom", (data) {
      messagesProvider.addMessage(
        MessageModel(
          by: messagesProvider.adminId,
          to: user.getUser()!.clientId,
          message: data['recivemessage'],
          status: "delivered",
          updatedAt: DateTime.now().toIso8601String(),
          createdAt: DateTime.now().toIso8601String(),
        ),
      );

    });
  }
}
