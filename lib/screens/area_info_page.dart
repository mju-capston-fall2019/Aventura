import 'package:aventura/models/AttractionModel.dart';
import 'package:aventura/screens/google_map.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

class AreaInfo extends StatefulWidget {
  AreaInfo({this.attraction});

  final AttractionModel attraction;

  @override
  _AreaInfoState createState() => _AreaInfoState();
}

class _AreaInfoState extends State<AreaInfo> {
  ScrollController _controller;
  int topFlex = 3;
  int midFlex = 1;
  int bottomFlex = 2;

  _scrollListener() {
    if (_controller.offset != _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      //top:max->min bottom:min->max
      setState(() {
        topFlex = 3;
        bottomFlex = 4;
      });
    } else {
      setState(() {
        topFlex = 3;
        bottomFlex = 2;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[
        Expanded(
          flex: topFlex,
          child: Top(),
        ),
        Expanded(
          flex: midFlex,
          child: Mid(),
        ),
        Expanded(
          flex: bottomFlex,
          child: Scaffold(
            body: Container(
              margin: const EdgeInsets.only(right: 30.0, left: 30.0),
              child: ListView.builder(
                controller: _controller,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Text(
                    //todo 가져온 정보는 여기에 보여준다.
                    "스페인 건축물의 절정이라고 평가받는 마드리드의 대표적인 명소로 그 화려함과 규모에 놀랄 만하다. 18세기에 지어진 왕궁은 역사적으로도 기념비적인 건축물이다. 9세기 이슬람의 알카사르(요새)가 있던 자리에 세워져 펠리페 2세가 마드리드로 수도를 옮기면서 왕궁으로 사용했으나, 1734년 크리스마스 때 화재로 미술품과 함께 소실되고 말았다.  이후 그의 제자 사케티가 프란시스코 데 사바티니, 벤투라 로드리케스 등과 함께 1764년 왕궁을 완공하여 현재 모습을 지니게 되었다. 왕궁의 주된 건축 양식은 고전주의 바로크 양식이다. 현재 국왕 일가는 교외의 사르수엘라 궁에 거처하고 있기 때문에 공식 행사가 있을 때 외에는 일반에게 공개된다.",
                    style: TextStyle(
                      height: 1.7,
                      letterSpacing: 1.0,
                      fontSize: 20,
                      //fontFamily: "Wooa",
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Top extends StatefulWidget {
  @override
  _TopState createState() => _TopState();
}

class _TopState extends State<Top> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Carousel(
          images: [
            //todo - get attraction image list
            Container(
              child: FadeInImage.assetNetwork(
                placeholder: "assets/loading.gif",
                image:
                    "https://firebasestorage.googleapis.com/v0/b/aventura-36f85.appspot.com/o/%20GQ1oFM2ZSfZM1RcpxlQP%2F1.jpg?alt=media&token=31458340-e640-4317-9543-604cf387518f",
                width: size.width,
                height: size.height,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              child: FadeInImage.assetNetwork(
                placeholder: "assets/loading.gif",
                image:
                    "https://firebasestorage.googleapis.com/v0/b/aventura-36f85.appspot.com/o/%20GQ1oFM2ZSfZM1RcpxlQP%2F2.jpg?alt=media&token=14e9f217-5931-4bbf-8aa8-0747c2f2b60c",
                width: size.width,
                height: size.height,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              child: FadeInImage.assetNetwork(
                placeholder: "assets/loading.gif",
                image:
                    "https://firebasestorage.googleapis.com/v0/b/aventura-36f85.appspot.com/o/%20GQ1oFM2ZSfZM1RcpxlQP%2F3.jpg?alt=media&token=1e9461ad-56e1-494f-8d80-1660be51ded9",
                width: size.width,
                height: size.height,
                fit: BoxFit.fill,
              ),
            ),
//            Image.network(
//              "https://firebasestorage.googleapis.com/v0/b/aventura-36f85.appspot.com/o/%20GQ1oFM2ZSfZM1RcpxlQP%2F1.jpg?alt=media&token=31458340-e640-4317-9543-604cf387518f",
//              width: size.width,
//              height: size.height,
//              fit: BoxFit.fill,
//            ),
//            Image.network(
//              "https://firebasestorage.googleapis.com/v0/b/aventura-36f85.appspot.com/o/%20GQ1oFM2ZSfZM1RcpxlQP%2F2.jpg?alt=media&token=14e9f217-5931-4bbf-8aa8-0747c2f2b60c",
//              width: size.width,
//              height: size.height,
//              fit: BoxFit.fill,
//            ),
//            Image.network(
//              "https://firebasestorage.googleapis.com/v0/b/aventura-36f85.appspot.com/o/%20GQ1oFM2ZSfZM1RcpxlQP%2F3.jpg?alt=media&token=1e9461ad-56e1-494f-8d80-1660be51ded9",
//              width: size.width,
//              height: size.height,
//              fit: BoxFit.fill,
//            ),
          ],
          autoplay: true,
          autoplayDuration: Duration(seconds: 3),
          dotBgColor: Colors.transparent,
          dotSize: 6.0,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>[
              IconButton(
                icon: Image.asset("assets/google_map_icon.png"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapWidget(
                        latitude: 40.418521,
                        longitude: -3.714421,
                      ),
                    ),
                  );
                },
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
