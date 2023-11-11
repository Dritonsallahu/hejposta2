

import 'package:flutter/material.dart';

getOrderStatus(status){
  if(status == "pending"){
    return  "Ne pritje";
  }
  else if(status == "accepted"){
    return "Per depo";
  }
  else if(status == "in_warehouse"){
    return "Ne depo";
  }
  return "d";
}