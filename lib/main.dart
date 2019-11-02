import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:r_music/musicdownload.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
      home: new HomePage(),
      theme: new ThemeData(
        primarySwatch: Colors.purple,
        brightness: Brightness.dark,
        accentColor: Color.fromARGB(1, 170, 92, 178),
      ),
    ));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  List data;
  String inputtext;
  @override
  void initState() {
    super.initState();
  }

  Future<String> youtubeResult(String searchQuery) async {
    String url =
        "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&key=AIzaSyAGFFnYMnV8muNAlq8tbqS80A4g-84c43s&q=$searchQuery&type=video";

    var response = await http.get(
        //Encode the url
        Uri.encodeFull(url),
        //Only Json
        headers: {"Accept": "application/json"});
    setState(() {
      var convertDataToJson = json.decode(response.body);
      data = convertDataToJson['items'];
    });
    var convertDataToJson = json.decode(response.body);
    data = convertDataToJson['items'];
    return "Successs";
  }

  @override
  Widget build(BuildContext context) {
    var pleasewait = "Please Wait ";
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Made With ❤️ By Ramyak Mehra"),
        backgroundColor: Colors.purpleAccent[300],
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(20.0),
            child: new Container(
              height: 50.0,
              color: Colors.grey.shade900,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      child: new TextField(
                        decoration: new InputDecoration(
                          alignLabelWithHint: true,
                          hintText: "Search Song",
                        ),
                        keyboardType: TextInputType.text,
                        onSubmitted: (text) {
                          inputtext = text;
                          youtubeResult(text);
                        },
                      ),
                    ),
                  ),
                  new IconButton(
                      icon: Image.asset('images/Search button.png',
                          height: 300.0),
                      onPressed: () {
                        youtubeResult(inputtext);
                      }),
                  data == null
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : new Text(""),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: new ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index) {
                return new SafeArea(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MusicDownload(
                                    musicname: data[index]['snippet']['title'],
                                    videoid: data[index]['id']['videoId'],
                                  )));
                    },
                    child: Card(
                        elevation: 3.0,
                        child: CustomListItemTwo(
                            title: data[index]['snippet']['title'],
                            subtitle: data[index]['snippet']['channelTitle'],
                            thumbnail: new Image.network(data[index]['snippet']
                                ['thumbnails']['medium']['url']))),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleDescription extends StatelessWidget {
  _ArticleDescription({
    Key key,
    this.title,
    this.subtitle,
  }) : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$title',
                maxLines: null,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 15.0)),
              Text(
                '$subtitle',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[],
          ),
        ),
      ],
    );
  }
}

class CustomListItemTwo extends StatelessWidget {
  CustomListItemTwo({
    Key key,
    this.thumbnail,
    this.title,
    this.subtitle,
  }) : super(key: key);

  final Widget thumbnail;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.0,
              child: thumbnail,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                child: _ArticleDescription(
                  title: title,
                  subtitle: subtitle,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
