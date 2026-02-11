import 'package:android_intent_plus/android_intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:siemb/l10n/app_localizations.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';




class LiveTab extends StatefulWidget{
final AsyncSnapshot<QuerySnapshot> snapshot;

const LiveTab(this.snapshot, {super.key});

  @override
  _LiveTab createState() => _LiveTab();
}

class _LiveTab extends State <LiveTab>{
  Map<String, dynamic> videoId = {};

  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  late YoutubeMetaData _videoMetaData;




  @override
  void initState() {
    super.initState();
    if (widget.snapshot.data != null && widget.snapshot.data!.docs.isNotEmpty) {
      videoId = (widget.snapshot.data!.docs.first.data() as Map<String, dynamic>?) ?? {};
    }
    final vid = videoId["ID"]?.toString() ?? 'dQw4w9WgXcQ';
    _controller = YoutubePlayerController(
      initialVideoId: vid,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        forceHD: true,
        loop: false,
        isLive: true,
      ),
    )..addListener(_listener);
    _videoMetaData = const YoutubeMetaData();
  }

  void _listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          appBar: AppBar(
            title: Text(
              _videoMetaData.title,
              softWrap: true,
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  const SizedBox(height: 10.0,),
                  player(),
                  const SizedBox(height: 10.0,),
                  // SizedBox(
                  //   width: 300,
                  //   height: 70,
                  //   child: RaisedButton(
                  //       shape: RoundedRectangleBorder (
                  //          borderRadius: BorderRadius.circular(10.0),
                  //       ),
                  //       color: Colors.blue,
                  //   onPressed: (){
                  //         Navigator.push(
                  //         context,
                  //         MaterialPageRoute(builder: (context) => LiveFull(videoId["ID"].toString())),
                  //              );
                  //         },
                  //     child: Text("Abrir player completo",
                  //         style: TextStyle(fontSize: 18.0, color: Colors.white)
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 10.0,),
                  SizedBox(
                    width: 300,
                    height: 70,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder (
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () => _launchYT (videoId["ID"]?.toString() ?? ""),
                      child: Text(
                        AppLocalizations.of(context).openYoutubeApp,
                        style: const TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ),
          ),
        );

  }

Widget player (){
  return YoutubePlayer(
    controller: _controller,
    showVideoProgressIndicator: true,
    onReady: () {
      _isPlayerReady = true;
    },
  );
}

_launchYT (String id) async{
     AndroidIntent intent = AndroidIntent(
        action: 'action_view',
        data: 'https://www.youtube.com/watch?v=$id'
    );
    await intent.launch();
}

  // Future<Void>_getVideoID()  async {
  //
  //   QuerySnapshot snapshot = await Firestore.instance.collection("live").getDocuments();
  //   videoId =  snapshot.documents.first.data;
  //   print (videoId["ID"]);
  // }

}






// @override
//   Widget build(BuildContext context) {
//
//     Widget _buildBodyBack() => Container(
//       decoration: BoxDecoration(
//           gradient: LinearGradient(
//               colors:[ Color.fromRGBO(255, 255, 255, 1),
//                 Color.fromRGBO(204, 0, 153, 0.5)],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter
//           )
//       ),
//     );
//
//     return Scaffold(
//
//       body: Stack(
//         alignment: Alignment.center,
//         children: <Widget>[
//
//           _buildBodyBack(),
//
//          SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 20.0,
//                 ),
//                 Center(
//                   child: _controller.value.initialized
//                       ? AspectRatio(
//                     aspectRatio: _controller.value.aspectRatio,
//                     child: VideoPlayer(_controller),
//                   )
//                       : Container(),
//                 ),
//                 floatingActionButton: FloatingActionButton(
//                  onPressed: () {
//                  setState(() {
//                    _controller.value.isPlaying
//                        ? _controller.pause()
//                        : _controller.play();
//                  });
//                },
//                child: Icon(
//                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//                ),
//               ],
//             )
//           ),
//         ],
//       ),
//     );
//   }
//
//   // FlutterYoutube.playYoutubeVideoByUrl(
//   // apiKey: "YOUR_YOUTUBE_API_KEY",
//   // videoUrl: "https://www.youtube.com/watch?v=...",
//   // fullScreen: false
//
// @override
// void dispose() {
//   super.dispose();
//   _controller.dispose();
// }
//
// }