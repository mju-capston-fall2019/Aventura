import 'package:flutter/material.dart';

class MemoryImageList extends StatefulWidget {
  @override
  _MemoryImageListState createState() => _MemoryImageListState();
}

class _MemoryImageListState extends State<MemoryImageList> {
  final List<String> _listViewImageUrl = [
    "https://firebasestorage.googleapis.com/v0/b/aventura-36f85.appspot.com/o/1Ar9eX7dMrHA2hcgAIhD%2F1.jpg?alt=media&token=3007902d-221c-42e9-8eb0-a669957bda4c",
    "https://firebasestorage.googleapis.com/v0/b/aventura-36f85.appspot.com/o/1Ar9eX7dMrHA2hcgAIhD%2F2.jpg?alt=media&token=6f7b8aa6-0579-4372-a5d7-3ca43b41b5a6",
    "https://firebasestorage.googleapis.com/v0/b/aventura-36f85.appspot.com/o/1Ar9eX7dMrHA2hcgAIhD%2F3.jpg?alt=media&token=3c409c72-f8ff-465a-bc6b-93eb2464a5cb",
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: new PreferredSize(
        preferredSize: new Size(MediaQuery.of(context).size.width, 130.0),
        child: new Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                Color.fromRGBO(186, 104, 200, 1),
                Color.fromRGBO(74, 22, 140, 1)
              ])),
          padding: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                width: size.width,
                child: Text(
                  "버킹엄 궁전",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: _listViewImageUrl.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1.0, color: Colors.grey),
        itemBuilder: (context, index) {
          return ListTile(
            dense: true,
            contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
            title: GestureDetector(
              child: Stack(
                children: <Widget>[
                  Container(
                    width: size.width,
                    height: 270,
                    child: Image.network(
                      _listViewImageUrl[index],
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
