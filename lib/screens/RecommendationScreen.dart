import 'package:aventura/components/RecommendationCard.dart';
import 'package:aventura/models/GeolocationModel.dart';
import 'package:aventura/models/AttractionModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  String userName = "Hey";
  int numOfNearAttractions = 0;

  Future<List<String>> getThumbnailImageUrl(String id) async {
    try {
      final StorageReference storageReference = FirebaseStorage().ref().child(id);
      List<String> urls = new List(3);
      urls[0] = await storageReference.child('1.jpg').getDownloadURL();
      urls[1] = await storageReference.child('2.jpg').getDownloadURL();
      urls[2] = await storageReference.child('3.jpg').getDownloadURL();
      return urls;
    } catch (e) {
      print('Error in getThumbnailImageUrl!\n');
      print(e);
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController();
    FirebaseAuth.instance.currentUser().then((user) {
      userName = user.email.split('@')[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    var userLocation = Provider.of<GeolocationModel>(context);
    if (userLocation == null) {
      // Wait Permission to access user's location
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
            child: Text(
              "Wait permission... :)",
              style: TextStyle(
                  fontSize: 15.0,
                  color: Color.fromRGBO(255, 255, 255, 0.6),
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      );
    } else {
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
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            child: Text(
                              DateFormat('EEEE').format(now).toString(),
                              style: TextStyle(
                                  fontSize: 30.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 12.0),
                            child: Text(
                              DateFormat('MMM d').format(now).toString(),
                              style: TextStyle(
                                  fontSize: 25.0,
                                  color: Color.fromRGBO(255, 255, 255, 0.6),
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Text(
                            "$userName, You have $numOfNearAttractions places to go!\n",
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
                        stream: Firestore.instance
                            .collection("Attractions")
                            .where('country', isEqualTo: 'Spain')
                            .snapshots(),
                        //TODO: Get most three closest attractions from user's current geo-location
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError)
                            return Text("Error: ${snapshot.error}");
                          if (!snapshot.hasData) return const Text("");
                          return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.documents.length,
                              controller: scrollController,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                numOfNearAttractions = snapshot.data.documents.length;
                                var attraction = new AttractionModel(
                                    snapshot.data.documents[index].documentID,
                                    snapshot.data.documents[index]['country'],
                                    snapshot.data.documents[index]['type'],
                                    new GeolocationModel(
                                        snapshot
                                            .data
                                            .documents[index]['geolocationData']
                                            .latitude,
                                        snapshot
                                            .data
                                            .documents[index]['geolocationData']
                                            .longitude),
                                    snapshot.data.documents[index]['enName'],
                                    snapshot.data.documents[index]['koName'],
                                    snapshot.data.documents[index]
                                        ['enSummaryDesc'],
                                    snapshot.data.documents[index]
                                        ['koSummaryDesc']);
                                return new FutureBuilder(
                                    future: getThumbnailImageUrl(attraction.id),
                                    builder: (BuildContext urlContext,
                                        AsyncSnapshot urlSnapshot) {
                                      if (urlSnapshot.hasError)
                                        return new Center(
                                            child: Text("something's wrong"));
                                      else {
                                        attraction.imageUrls = urlSnapshot.data;
                                        return new GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => AreaInfo(
                                                  attraction: attraction,
                                                  userLocation: userLocation,
                                                ),
                                              ),
                                            );
                                          },
                                          onHorizontalDragEnd: (details) {
                                            animationController =
                                                AnimationController(
                                                    vsync: this,
                                                    duration: Duration(
                                                        milliseconds: 500));
                                            curvedAnimation = CurvedAnimation(
                                                parent: animationController,
                                                curve: Curves.fastOutSlowIn);
                                            if (details.velocity.pixelsPerSecond
                                                    .dx >
                                                0) {
                                              if (cardIndex > 0) {
                                                cardIndex--;
                                              }
                                            } else {
                                              if (cardIndex <
                                                  snapshot.data.documents
                                                          .length -
                                                      1) {
                                                cardIndex++;
                                              }
                                            }
                                            setState(() {
                                              scrollController.animateTo(
                                                  (cardIndex) * 256.0,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.fastOutSlowIn);
                                            });
                                            animationController.forward();
                                          },
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: RecommendationCard(
                                                  attraction: attraction,
                                                  userLocation: userLocation)),
                                        );
                                      }
                                    });
                              });
                        })),
              ],
            ),
          ),
        ),
      );
    }
  }
}
