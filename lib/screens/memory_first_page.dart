import 'package:aventura/screens/memory_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
    "버킹엄 궁전",
    "몽마르트",
    "홍콩 스카이라인",
    "에펠탑",
    "파타야 아트 인 파라다이스",
  ];

  Future<List<String>> getThumbnailImageUrl(String id) async {
    try {
      final StorageReference storageReference =
          FirebaseStorage().ref().child(id);
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: new PreferredSize(
        preferredSize: new Size(MediaQuery.of(context).size.width, 160.0),
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
                padding: EdgeInsets.only(bottom: 10, top: 10),
                width: size.width / 2,
                child: Text(
                  "스토리",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                width: size.width / 2,
                child: Text(
                  "사진",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
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
            title: GestureDetector(
              child: Stack(
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MemoryImageList(),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
