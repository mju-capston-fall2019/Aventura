import 'package:aventura/models/AttractionModel.dart';
import 'package:aventura/models/GeolocationModel.dart';
import 'package:aventura/screens/google_map.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/widgets.dart';

class AreaInfo extends StatefulWidget {
  final AttractionModel attraction;
  final GeolocationModel userLocation;

  AreaInfo({this.attraction, this.userLocation});

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
            color: Colors.white,
          ),
        ),
        Container(
          child: Column(
              children: <Widget>[
                Container(
                  height:size.height * 0.4,
                  child: Top(
                    attraction: widget.attraction,
                    myLocation: widget.userLocation,
                  ),
                ),
                Container(
                  height: 100,
                  child: Mid(
                      type: widget.attraction.type,
                      name: widget.attraction.koName,
                      country: widget.attraction.country),
                ),
                Expanded(
                  child: Scaffold(
                    body: Container(
                      margin: const EdgeInsets.only(
                          right: 30.0, left: 30.0, top: 20.0),
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                          controller: _controller,
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return Text(
                              widget.attraction.koSummaryDesc,
                              style: TextStyle(
                                height: 1.6,
                                fontSize: 18,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ),
      ],
    );
  }
}

class Top extends StatefulWidget {
  final AttractionModel attraction;
  final GeolocationModel myLocation;

  const Top({this.attraction, this.myLocation});
  @override
  _TopState createState() => _TopState();
}

class _TopState extends State<Top> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> carouselImage() {
      List<Widget> carouselChildren = [];
      for (int i = 0; i < 3; i++) {
        var newChild = Container(
          child: CachedNetworkImage(
            imageUrl: widget.attraction.imageUrls[i],
            placeholder: (context, url) => Image.asset("assets/loading.gif", height: size.height * 0.4, fit: BoxFit.fitWidth),
            errorWidget: (context, url, error) => new Icon(Icons.error),
            height: size.height,
            width: size.width ,
            fit: BoxFit.cover
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
                        attraction: widget.attraction,
                        myLocation: widget.myLocation,
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
        alignment: Alignment.center,
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
