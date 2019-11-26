import 'package:aventura/models/AttractionModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AreaInfo extends StatelessWidget {
  AreaInfo({this.attraction});

  final AttractionModel attraction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Top(),
        ),
        Expanded(
          flex: 1,
          child: Mid(),
        ),
        Expanded(
          flex: 2,
          child: Bottom(),
        ),
        //b
      ],
    );
  }
}

class Top extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Image.network(
          "https://firebasestorage.googleapis.com/v0/b/aventura-36f85.appspot.com/o/%20GQ1oFM2ZSfZM1RcpxlQP%2F1.jpg?alt=media&token=31458340-e640-4317-9543-604cf387518f",
          width: size.width,
          height: size.height,
          fit: BoxFit.fill,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>[
              IconButton(
                icon: Image.asset("assets/google_map_icon.png"),
                onPressed: null,
                iconSize: 60.0,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class Mid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment(0.0, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              //todo - get attraction type
              "historical place",
              style: TextStyle(
                fontSize: 15,
                color: Colors.teal,
                letterSpacing: 1.0,
              ),
            ),
            Text(
              //todo - get attraction ko name
              "마드리드 왕궁",
              style: TextStyle(
                fontSize: 25,
                letterSpacing: 3.0,
              ),
            ),
            Text(
              //todo - get attraction country
              "spain",
              style: TextStyle(
                fontSize: 15,
                color: Colors.blueGrey,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Bottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(right: 30.0, left: 30.0),
        child: Text(
          //todo 가져온 정보는 여기에 보여준다.
          "스페인 건축물의 절정이라고 평가받는 마드리드의 대표적인 명소로 그 화려함과 규모에 놀랄 만하다. 18세기에 지어진 왕궁은 역사적으로도 기념비적인 건축물이다. 9세기 이슬람의 알카사르(요새)가 있던 자리에 세워져 펠리페 2세가 마드리드로 수도를 옮기면서 왕궁으로 사용했으나, 1734년 크리스마스 때 화재로 미술품과 함께 소실되고 말았다.  이후 그의 제자 사케티가 프란시스코 데 사바티니, 벤투라 로드리케스 등과 함께 1764년 왕궁을 완공하여 현재 모습을 지니게 되었다. 왕궁의 주된 건축 양식은 고전주의 바로크 양식이다. 현재 국왕 일가는 교외의 사르수엘라 궁에 거처하고 있기 때문에 공식 행사가 있을 때 외에는 일반에게 공개된다.",
          style: TextStyle(
            height: 1.3,
            letterSpacing: 1.0,
            fontSize: 20,
            fontFamily: "Wooa",
          ),
        ),
      ),
    );
  }
}

//child: SafeArea(
//child: Scaffold(
//appBar: AppBar(
//backgroundColor: Color(0xff2d1440),
//leading: Center(
//child: FlatButton(
//onPressed: () {
//Navigator.pop(context);
//},
//child: Icon(Icons.arrow_back, color: Colors.white,),
//),
//),
//),
//body: Container(
//width: size.width,
//height: size.height,
//decoration: BoxDecoration(
//border: Border.all(color: const Color(0xff2d1440), width: 25),
//color: const Color(0xffffffff),
//),
//child: new Column(
//children: <Widget>[
//Expanded(
//flex: 1,
//child: Container(
//height: size.height / 2,
//width: 400,
//child: Carousel(
//boxFit: BoxFit.fill,
//images: [
//AssetImage('assets/colosseum/image1.jpg'),
//AssetImage('assets/colosseum/image2.jpg'),
//AssetImage('assets/colosseum/image3.jpg'),
//],
//autoplay: true,
//indicatorBgPadding: 1.0,
//dotBgColor: Colors.transparent,
//dotSize: 6.0,
//),
//),
//),
//Container(
//padding: EdgeInsets.only(bottom: 10, top: 10),
//child: Center(
//child: Text(
//attraction.enName,
//style: TextStyle(
//fontSize: 30,
//fontWeight: FontWeight.w400
//),
//),
//),
//),
//Expanded(
//flex: 1,
//child: ListView(
//children: <Widget>[
//Container(
//padding: EdgeInsets.only(left: 25, right: 25),
//width: 150,
////height: 150,
//child: Text(
//attraction.enSummaryDesc,
//style: TextStyle(
//height: 1.3,
//letterSpacing: 1.0,
//fontSize: 20,
//),
//),
//),
//],
//),
//),
//],
//),
//),
//),
//),
