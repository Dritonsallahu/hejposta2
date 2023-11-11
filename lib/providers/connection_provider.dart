import 'package:flutter/foundation.dart';

enum ConnectionType{
  pending,
  connected,
  disconnected,
}
class ConnectionProvider extends ChangeNotifier{
  ConnectionType connectionType = ConnectionType.pending;


  ConnectionType? getConnectionType(){
    return connectionType;
  }
  setConnectionStatus(ConnectionType connectionType){
    this.connectionType = connectionType;
    notifyListeners();
  }
}