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
  int bottomFlex = 3;

  _scrollListener() {
    if (_controller.offset != _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      //top:max->min bottom:min->max
      setState(() {
        topFlex = 2;
        midFlex = 2;
        bottomFlex = 6;
      });
    } else {
      setState(() {
        topFlex = 3;
        midFlex = 1;
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
    return Stack(
      children: <Widget>[
        Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                Color.fromRGBO(186, 104, 200, 1),
                Color.fromRGBO(74, 22, 140, 1)
              ])),
        ),
        Container(
          margin: EdgeInsets.all(20),
          child: ClipRRect(
            borderRadius: new BorderRadius.circular(20.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: topFlex,
                  child: Top(
                    name: widget.attraction.koName,
                    country: widget.attraction.country,
                    latitude: widget.attraction.geolocationData.latitude,
                    longitude: widget.attraction.geolocationData.longitude,
                  ),
                ),
                Expanded(
                  flex: midFlex,
                  child: Mid(
                      type: widget.attraction.type,
                      name: widget.attraction.koName,
                      country: widget.attraction.country),
                ),
                Expanded(
                  flex: bottomFlex,
                  child: Scaffold(
                    body: Container(
                      margin: const EdgeInsets.only(
                          right: 30.0, left: 30.0, top: 0),
                      child: ListView.builder(
                        controller: _controller,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Text(
                            widget.attraction.koSummaryDesc,
                            style: TextStyle(
                              height: 1.7,
                              letterSpacing: 1.0,
                              fontSize: 20,
                              fontFamily: "Wooa",
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Top extends StatefulWidget {
  final String name;
  final String country;
  final double latitude;
  final double longitude;
  const Top({this.name, this.country, this.latitude, this.longitude});
  @override
  _TopState createState() => _TopState();
}

class _TopState extends State<Top> {
  //todo - get url from FB
  List<String> url = [
    "https://firebasestorage.googleapis.com/v0/b/aventura-36f85.appspot.com/o/C1gT4r367U5PYYVGxUYH%2F1.jpg?alt=media&token=b5fe592f-7260-4f32-849a-8c02d259ed8c",
    "https://firebasestorage.googleapis.com/v0/b/aventura-36f85.appspot.com/o/C1gT4r367U5PYYVGxUYH%2F1.jpg?alt=media&token=b5fe592f-7260-4f32-849a-8c02d259ed8c",
    "https://firebasestorage.googleapis.com/v0/b/aventura-36f85.appspot.com/o/C1gT4r367U5PYYVGxUYH%2F1.jpg?alt=media&token=b5fe592f-7260-4f32-849a-8c02d259ed8c",
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> carouselImage() {
      List<Widget> carouselChildren = [];
      for (int i = 0; i < 3; i++) {
        var newChild = Container(
          child: FadeInImage.assetNetwork(
            placeholder: "assets/loading.gif",
            image: url[i],
            width: size.width,
            height: size.height,
            fit: BoxFit.fill,
          ),
        );
        carouselChildren.add(newChild);
      }
      return carouselChildren;
    }

    return Stack(
      children: <Widget>[
        Carousel(
          images: carouselImage(),
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
                        name: widget.name,
                        latitude: widget.latitude,
                        longitude: widget.longitude,
                        country: widget.country,
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
  final String type;
  final String name;
  final String country;
  const Mid({this.type, this.name, this.country});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment(0.0, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              type,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                color: Colors.teal,
                letterSpacing: 1.0,
              ),
            ),
            Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 25,
                letterSpacing: 3.0,
              ),
            ),
            Text(
              country,
              overflow: TextOverflow.ellipsis,
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
