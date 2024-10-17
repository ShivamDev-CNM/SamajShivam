import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samajapp/Controllers/eventController.dart';
import 'package:samajapp/Utils/colors.dart';
import 'package:samajapp/Utils/mytxt.dart';
import 'package:video_player/video_player.dart';

class myVideoPlayerWidget extends StatefulWidget {


  myVideoPlayerWidget(
      {super.key, required this.vides, required this.thumbNail});

  final List vides;
  final List thumbNail;

  @override
  State<myVideoPlayerWidget> createState() => _myVideoPlayerWidgetState();
}

class _myVideoPlayerWidgetState extends State<myVideoPlayerWidget>
    with TickerProviderStateMixin {

  Eventcontroller ec = Get.find<Eventcontroller>();


  @override
  void initState() {
    ec.ac = AnimationController(vsync: this, duration: Duration(seconds: 500));
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ec.vc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      color: Colors.white,
      child: Obx(() {
        if (ec.isVideoInitialized.value == true) {
          return Column(
            children: [
              Obx(() {
                return AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ec.videoLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Green,
                            strokeWidth: 2,
                          ),
                        )
                      : VideoPlayer(ec.vc),
                );
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DataText(
                        text: '${ec.formatDuration(ec.videoDuration.value)}',
                        fontSize: 15),
                    DataText(
                        text: ec.formatDuration(ec.TotalvideoDuration.value),
                        fontSize: 14)
                  ],
                ),
              ),
              Obx(() {
                return Slider.adaptive(
                  value: ec.videoDuration.value.inSeconds.toDouble(),
                  onChanged: (val) {
                    ec.seekVid(val);
                  },
                  max: ec.TotalvideoDuration.value.inSeconds.toDouble(),
                );
              }),
              Obx(() {
                return GestureDetector(
                  onTap: () {
                    ec.playPauseVideo();
                  },
                  child: Icon(
                    ec.videoPlaying.value
                        ? Icons.pause_circle
                        : Icons.play_circle,
                    color: Colors.blue,
                    size: 45,
                  ),
                );
              }),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: List.generate(widget.vides.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          if (ec.ViInd.value != index) {
                            ec.ViInd.value = index;
                            ec.videoLoading(true);
                            await ec.loadVideo(widget.vides[index]['video']);
                            ec.videoLoading(false);
                          }
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              border: ec.ViInd.value == index
                                  ? Border.all(color: Green, width: 2)
                                  : null,
                              image: DecorationImage(
                                  image:
                                      FileImage(File(widget.thumbNail[index])),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(10)),
                          child: Icon(
                            Icons.play_circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              )
            ],
          );
        } else {
          return Center(
            child: DataText(text: 'Failed to show video', fontSize: 15),
          );
        }
      }),
    );
  }
}
