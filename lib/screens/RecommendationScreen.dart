import 'package:aventura/models/GeolocationModel.dart';
import 'package:aventura/models/AttractionModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'area_info_page.dart';

class RecommendationScreen extends StatefulWidget {
  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen>
    with TickerProviderStateMixin {
  ScrollController scrollController;
  AnimationController animationController;
  CurvedAnimation curvedAnimation;
  var cardIndex = 0;
  var now = new DateTime.now();

  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              Color.fromRGBO(186, 104, 200, 1),
              Color.fromRGBO(74, 22, 140, 1)
            ])),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: size.width * 0.9,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 20.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: Text(
                            DateFormat('EEEE').format(now).toString(),
                            style: TextStyle(
                                fontSize: 30.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 12.0),
                          child: Text(
                            DateFormat('MMM d').format(now).toString(),
                            style: TextStyle(
                                fontSize: 25.0,
                                color: Color.fromRGBO(255, 255, 255, 0.6),
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Text(
                          "kangsan, You have 3 places to go!",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Color.fromRGBO(255, 255, 255, 0.6),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 30.0),
                height: 400.0,
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection("Attractions").snapshots(),
                  //TODO: Get most three closest attractions from user's current geo-location
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if(snapshot.hasError) return Text("Error: ${snapshot.error}");
                    if(!snapshot.hasData) return const Text("Loading...");
                    // TODO: get Pictures of attractions (using documents[index].documentID)

                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.documents.length,
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var attraction = new AttractionModel(
                              snapshot.data.documents[index].documentID,
                              snapshot.data.documents[index]['country'],
                              snapshot.data.documents[index]['type'],
                              new GeolocationModel(snapshot.data.documents[index]['geolocationData'].latitude, snapshot.data.documents[index]['geolocationData'].longitude),
                              snapshot.data.documents[index]['enName'],
                              snapshot.data.documents[index]['koName'],
                              snapshot.data.documents[index]['enSummaryDesc'],
                              snapshot.data.documents[index]['koSummaryDesc']
                          );
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>
                                      AreaInfo(
                                        attraction: attraction,
                                      ),
                                ),
                              );
                            },
                            onHorizontalDragEnd: (details) {
                              animationController = AnimationController(
                                  vsync: this,
                                  duration: Duration(milliseconds: 500));
                              curvedAnimation = CurvedAnimation(
                                  parent: animationController,
                                  curve: Curves.fastOutSlowIn);
                              if (details.velocity.pixelsPerSecond.dx > 0) {
                                if (cardIndex > 0) {
                                  cardIndex--;
                                }
                              } else {
                                if (cardIndex < snapshot.data.documents.length - 1) {
                                  cardIndex++;
                                }
                              }
                              setState(() {
                                scrollController.animateTo(
                                    (cardIndex) * 256.0,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.fastOutSlowIn);
                              });
                              animationController.forward();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0)),
                                child: Container(
                                  width: 250.0,
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 8.0,
                                            left: 8.0,
                                            top: 4.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Chip(
                                              label: new Text(
                                                attraction.type,
                                                style: TextStyle(color: Colors.white),
                                              ),
                                              backgroundColor: Colors
                                                  .black38,
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                        child: Container(
                                          child: Image.asset("assets/colosseum/image1.jpg", height: 200, fit: BoxFit.fitHeight),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 8.0,
                                                  vertical: 4.0),
                                              child: Text(
                                                //TODO: Create Dynamic distance in card using user's current geo-location
                                                "1.5 Km from here",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 18.0),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 8.0, vertical: 4.0),
                                              child: Text(
                                                attraction.enName,
                                                style: TextStyle(fontSize: 25.0),
                                                softWrap: false,
                                                overflow:TextOverflow.fade
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
                        });
                  }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
