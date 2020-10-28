import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

List<List<List<String>>> videos = [
  [
    ["assets/videos/q11.mp4", "why are cows 🐄 ,so,Dumb?"],
    ["assets/videos/q12.mp4", "Coz,They are,White"],
    ["assets/videos/q13.mp4", "Stripes, are never, great"],
    ["assets/videos/q14.mp4", "Coz,They, Beef bro"]
  ],
  [
    ["assets/videos/q21.mp4", "why are cats 🐄 ,so,Dumb?"],
    ["assets/videos/q22.mp4", "Coz,They are,White"],
    ["assets/videos/q23.mp4", "Stripes, are never, great"],
    ["assets/videos/q24.mp4", "Coz,They, Beef bro"]
  ]
];

class _HomePageState extends State<HomePage> {
  PageController mainController;
  PageController _controller;
  VideoPlayerController videoController;
  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: 0,
      viewportFraction: 1,
    );
    mainController = PageController(
      initialPage: 0,
      viewportFraction: 1,
    );
    videoController = VideoPlayerController.asset(videos[0][0][0])
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {
          videoController.play();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: PageView.builder(
          controller: mainController,
          pageSnapping: true,
          scrollDirection: Axis.horizontal,
          itemCount: videos.length,
          onPageChanged: (index) {
            videoController.pause();
            videoController.removeListener(() {});
            videoController = VideoPlayerController.asset(videos[index][0][0])
              ..setLooping(true)
              ..initialize().then((_) {
                setState(() {
                  videoController.play();
                });
              });
          },
          itemBuilder: (context, index) => questionPageBuilder(videos[index])),
    ));
  }

  PageView questionPageBuilder(List<List<String>> videoList) {
    return PageView.builder(
        controller: _controller,
        pageSnapping: true,
        scrollDirection: Axis.vertical,
        dragStartBehavior: DragStartBehavior.start,
        itemCount: videoList.length,
        onPageChanged: (index) {
          videoController.pause();
          videoController.removeListener(() {});
          videoController = VideoPlayerController.asset(videoList[index][0])
            ..setLooping(true)
            ..initialize().then((_) {
              setState(() {
                videoController.play();
              });
            });
        },
        itemBuilder: (context, index) => (videoController?.value?.initialized)
            ? InkWell(
                onTap: () {
                  videoController.value.isPlaying
                      ? videoController.pause()
                      : videoController.play();
                },
                child: Stack(children: [
                  VideoPlayer(videoController),
                  Positioned(
                      bottom: 50,
                      child: ColumnBuilder(
                        mainAxisSize: MainAxisSize.min,
                        itemCount: videoList[index][1].split(",").length,
                        itemBuilder: (context, item) =>
                            PlayAnimation<MultiTweenValues<AniProps>>(
                          delay: (item * 500).milliseconds,
                          duration: 500.milliseconds,
                          tween: MultiTween<AniProps>()
                            ..add(
                                AniProps.opacity, 0.0.tweenTo(1.0), 1.seconds),
                          builder: (context, child, value) => Opacity(
                              opacity: value.get(AniProps.opacity),
                              child: Text(
                                  videoList[index][1].split(",")[item].trim(),
                                  style: TextStyle(
                                      fontSize: 50,
                                      backgroundColor: Colors.white,
                                      fontWeight: FontWeight.bold))),
                        ),
                      ))
                ]))
            : Center(child: Text("Waiting")));
  }

  @override
  void dispose() {
    _controller.dispose();
    videoController.dispose();
    super.dispose();
  }
}

class ColumnBuilder extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection textDirection;
  final VerticalDirection verticalDirection;
  final int itemCount;

  const ColumnBuilder({
    Key key,
    @required this.itemBuilder,
    @required this.itemCount,
    this.mainAxisAlignment: MainAxisAlignment.start,
    this.mainAxisSize: MainAxisSize.max,
    this.crossAxisAlignment: CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection: VerticalDirection.down,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: new List.generate(
          this.itemCount, (index) => this.itemBuilder(context, index)).toList(),
    );
  }
}

enum AniProps { width, height, opacity }
