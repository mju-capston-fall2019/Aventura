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
    return Column(
      children: <Widget>[
        Expanded(
          flex: topFlex,
          child: Top(
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
              margin: const EdgeInsets.only(right: 30.0, left: 30.0),
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
    );
  }
}

class Top extends StatefulWidget {
  final double latitude;
  final double longitude;
  const Top({this.latitude, this.longitude});
  @override
  _TopState createState() => _TopState();
}

class _TopState extends State<Top> {
  //todo - get url from FB
  List<String> url = [
    "https://firebasestorage.googleapis.com/v0/b/aventura-36f85.appspot.com/o/%20GQ1oFM2ZSfZM1RcpxlQP%2F1.jpg?alt=media&token=31458340-e640-4317-9543-604cf387518f",
    "https://firebasestorage.googleapis.com/v0/b/aventura-36f85.appspot.com/o/%20GQ1oFM2ZSfZM1RcpxlQP%2F2.jpg?alt=media&token=14e9f217-5931-4bbf-8aa8-0747c2f2b60c",
    "https://firebasestorage.googleapis.com/v0/b/aventura-36f85.appspot.com/o/%20GQ1oFM2ZSfZM1RcpxlQP%2F3.jpg?alt=media&token=1e9461ad-56e1-494f-8d80-1660be51ded9",
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
                        latitude: widget.latitude,
                        longitude: widget.longitude,
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

//finish
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
              style: TextStyle(
                fontSize: 15,
                color: Colors.teal,
                letterSpacing: 1.0,
              ),
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: 25,
                letterSpacing: 3.0,
              ),
            ),
            Text(
              country,
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
