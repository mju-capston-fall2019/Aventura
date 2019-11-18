import 'package:flutter/material.dart';

class LoginBackground extends CustomPainter{

  LoginBackground({@required this.isJoin}); // 생성자.

  final bool isJoin;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint()..color = isJoin ? Colors.red : Colors.blue; // .. 을 쓰면 paint object 생성해서 그 안에 color값을 set까지 해주는것
    canvas.drawCircle(Offset(size.width*0.5, size.height*0.2), size.height*0.5, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // 계속 다시 그릴 지 여부
    return false;
  }
}