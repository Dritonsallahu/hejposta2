import 'package:flutter/material.dart';

class OrderClip extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width - 20, size.height);
    path.lineTo(0, size.height);  //
    path.quadraticBezierTo(-13, 0, 26,  0);
    path.quadraticBezierTo(size.height, 0, 126,  0);
    // top left corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
  
}