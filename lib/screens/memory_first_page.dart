import 'package:flutter/material.dart';

class MemoryFirstPage extends StatefulWidget {
  @override
  _MemoryFirstPageState createState() => _MemoryFirstPageState();
}

class _MemoryFirstPageState extends State<MemoryFirstPage> {
  final List<String> _listViewImageUrl = [
    "https://firebasestorage.googleapis.com/v0/b/aventura-36f85.appspot.com/o/1Ar9eX7dMrHA2hcgAIhD%2F1.jpg?alt=media&token=3007902d-221c-42e9-8eb0-a669957bda4c",
    "https://firebasestorage.googleapis.com/v0/b/aventura-36f85.appspot.com/o/1wP18lnpzFd3MZIalMgb%2F1.jpg?alt=media&token=51902e2f-e221-4be4-b8f5-0ce2079ae675",
    "https://firebasestorage.googleapis.com/v0/b/aventura-36f85.appspot.com/o/27Rk42mxCwy002UCUAMX%2F1.jpg?alt=media&token=855eb6cd-1c76-487a-8d2a-f02f2b67f8aa",
    "https://firebasestorage.googleapis.com/v0/b/aventura-36f85.appspot.com/o/2CbovDRf9q10syPHAMID%2F1.jpg?alt=media&token=0857dc04-d03b-4c56-873d-6113befb35fb",
    "https://firebasestorage.googleapis.com/v0/b/aventura-36f85.appspot.com/o/5IN83vcsv22fONlf3A6N%2F1.JPG?alt=media&token=07d51e97-6cab-4db1-bf49-c3e0f17e04f0",
  ];

  final List<String> _listViewText = [
    "여기는 어디일까요1",
    "여기는 어디일까요2",
    "여기는 어디일까요3",
    "여기는 어디일까요4",
    "여기는 어디일까요5",
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: new PreferredSize(
        preferredSize: new Size(MediaQuery.of(context).size.width, 130.0),
        child: new Container(
          padding: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Row(
            children: <Widget>[
              Container(
                width: size.width / 2,
                child: Text(
                  "스토리",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
              ),
              Container(
                width: size.width / 2,
                child: Text(
                  "사진",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: _listViewText.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1.0, color: Colors.grey),
        itemBuilder: (context, index) {
          return ListTile(
            dense: true,
            contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
            title: Stack(
              children: <Widget>[
                Container(
                  width: size.width,
                  height: 170,
                  child: Image.network(
                    _listViewImageUrl[index],
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  width: size.width,
                  height: 170,
                  child: Center(
                    child: Text(
                      _listViewText[index],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
