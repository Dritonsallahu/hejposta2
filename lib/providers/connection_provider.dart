import 'package:flutter/foundation.dart';

enum ConnectionType{
  Pending,
  Connected,
  Disconnected,
}
class ConnectionProvider extends ChangeNotifier{
  ConnectionType connectionType = ConnectionType.Pending;


  ConnectionType? getConnectionType(){
    return connectionType;
  }
  setConnectionStatus(ConnectionType connectionType){
    this.connectionType = connectionType;
    notifyListeners();
  }
}