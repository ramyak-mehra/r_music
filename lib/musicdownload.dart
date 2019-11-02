import 'package:flutter/material.dart';
import 'package:youtube_extractor/youtube_extractor.dart';

import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class MusicDownload extends StatefulWidget {
  final String musicname;
  final String videoid;
  const MusicDownload({Key key, this.musicname, this.videoid})
      : super(key: key);
  @override
  _MusicDownloadState createState() => _MusicDownloadState();
}

class _MusicDownloadState extends State<MusicDownload> {
  String finalUrl = "";
  bool downloading = true;
  var progressString = "Processing";
  @override
  void initState() {
    super.initState();
    downloadFile(widget.videoid);
  }

  Future<void> downloadFile(String videoId) async {
    

    try {
     var audioUrlInfo = await YouTubeExtractor().getMediaStreamsAsync(videoId);
     finalUrl = audioUrlInfo.audio.first.url;
     
     } catch (e) {
      print(e);
    }
    setState(() {
      progressString = "Done";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.musicname),
      ),
      body: Center(
        child: finalUrl!=null
            ? Container(
                height: 220.0,
                width: 220.0,
                child: Card(
                  elevation: 4.0,
                  color: Colors.grey.shade900,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      
                      RaisedButton(
                        child: new Text("Click Here"),
                        onPressed: () {
                          _launchURL(context, finalUrl);

                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text("$progressString ")
                    ],
                  ),
                ),
              )
            : Container(
                height: 220.0,
                width: 220.0,
                child: Card(
                  elevation: 4.0,
                  color: Colors.grey.shade900,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        backgroundColor: Colors.cyan,
                      ),
                      
                      SizedBox(
                        height: 10.0,
                      ),
                      Text("Processing Please Wait")
                    ],
                  ),
                ),
              )
      )
      
    );
  }
}

void _launchURL(BuildContext context, String url) async {
  try {
    await launch(
      url,
      option: new CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: new CustomTabsAnimation.slideIn()),
    );
  } catch (e) {
    print(e.toString());
  }
}
