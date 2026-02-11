import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LiveFull extends StatefulWidget{
  final String videoId;

  const LiveFull(this.videoId, {super.key});


  @override
  _LiveFull createState() => _LiveFull();
}

class _LiveFull extends State <LiveFull>{



  late YoutubePlayerController _controller;
  late bool _isPlayerReady;
  late YoutubeMetaData _videoMetaData;



  @override
  void initState() {

    super.initState();
    _isPlayerReady = false;
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
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
    return WillPopScope(
        onWillPop: () async => false,
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation){
            if (orientation == Orientation.landscape){
              return Scaffold(
                body: youTubePlay(),
              );
            }else {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    _videoMetaData.title,
                    softWrap: true,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
                body: youTubePlay(),
              );
            }
          },
        ),
        );



  }

  youTubePlay (){
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height
      ),
      child: SingleChildScrollView(

          child: Column(
            children: [
              const SizedBox(height: 10.0,),
              //player(),
              YoutubePlayerBuilder(
                  player: player(),
                  builder: (context, player) {
                    return Column(
                      children: [
                        player,
                      ],
                    );
                  }
              ),
              const SizedBox(height: 10.0,),
            ],
          ),
        ),
    );

  }

  YoutubePlayer player (){
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      onReady: () {
        _isPlayerReady = true;
      },
    );
  }

}



