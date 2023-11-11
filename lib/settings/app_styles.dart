import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyles{
  static TextStyle fontModelOne = const TextStyle(fontFamily: 'Bahnschrift', color: Colors.white,fontWeight: FontWeight.w600);
  static TextStyle fontModelTow = const TextStyle(fontFamily: 'Bahnschrift', color: Colors.black,fontWeight: FontWeight.w500);
  static TextStyle fontModelThree =   TextStyle(fontFamily: 'Bahnschrift', color: Colors.grey[400],fontWeight: FontWeight.w500,fontSize: 12);
  static TextStyle lineFont = const TextStyle(fontFamily: 'Bahnschrift', color: Colors.white,fontWeight: FontWeight.w600,fontSize: 11);
  static TextStyle inputTextModelOne = const TextStyle(fontFamily: 'Bahnschrift',color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 14);

  static getHeaderNameText({var size,var fontWeight,var color}){
    return TextStyle(fontFamily: 'Bahnschrift',fontSize: size.toDouble() ?? 12,fontWeight: fontWeight ?? FontWeight.w500,color: color ?? Colors.white);
  }
}