import 'package:flutter/material.dart';

class LoginBackground extends CustomPainter{

  LoginBackground({@required this.isJoin});

  final bool isJoin;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = isJoin?Colors.red: Colors.blue;        //한줄로 넣기
    canvas.drawCircle(Offset(size.width*0.5, size.height*0.2), size.height*0.5, paint);  //원 사이즈 위치 잡아주기

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }



}