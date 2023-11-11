
import 'package:flutter/material.dart';
import 'package:hejposta/models/message_model.dart';

class MessagesProvider extends ChangeNotifier{
  final ScrollController _scrollController = ScrollController();
  final List<MessageModel> _messages = [];
  var unreadMessages = 0;
  var adminId = "";

  List<MessageModel> getMessages() => _messages;

  addMessages(List<MessageModel> messages) {
    _messages.clear();
    _messages.addAll(messages);
    notifyListeners();
  }

  addMessage(MessageModel message, {bool? outside}){
    _messages.add(message);
    outside ?? animateToBottom();
    notifyListeners();
  }

  removeMessage(){
    _messages.clear();
    notifyListeners();
  }

  countUnreadMessages(){
    unreadMessages++;
    notifyListeners();
  }

  readMessages(){
    unreadMessages = 0;
    notifyListeners();
  }

  addAdmin(String id){
    adminId = id;
    notifyListeners();
  }


  getScroll(){
    return _scrollController;
  }
  animateToBottom() {
    if(_scrollController.positions.isNotEmpty){
      _scrollController.animateTo(_scrollController.position.maxScrollExtent + 70,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }

  }

  jumpToBottom() {
    if(_scrollController.positions.isNotEmpty) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent+ 40);
    }
  }
}