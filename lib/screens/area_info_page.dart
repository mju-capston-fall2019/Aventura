import 'package:aventura/models/AttractionModel.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AreaInfo extends StatelessWidget {

  AreaInfo({this.attraction});

  final AttractionModel attraction;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff2d1440),
            leading: Center(
              child: FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back, color: Colors.white,),
              ),
            ),
          ),
          body: Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xff2d1440), width: 25),
              color: const Color(0xffffffff),
            ),
            child: new Column(
              children: <Widget>[
              Expanded(
              flex: 1,
              child: Container(
                height: size.height / 2,
                width: 400,
                child: Carousel(
                  boxFit: BoxFit.fill,
                  images: [
                    AssetImage('assets/colosseum/image1.jpg'),
                    AssetImage('assets/colosseum/image2.jpg'),
                    AssetImage('assets/colosseum/image3.jpg'),
                  ],
                  autoplay: true,
                  indicatorBgPadding: 1.0,
                  dotBgColor: Colors.transparent,
                  dotSize: 6.0,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 10, top: 10),
              child: Center(
                child: Text(
                  attraction.enName,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    width: 150,
                    //height: 150,
                    child: Text(
                      attraction.enSummaryDesc,
                      style: TextStyle(
                        height: 1.3,
                        letterSpacing: 1.0,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
