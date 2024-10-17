import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:samajapp/APIS/APIS.dart';
import 'package:samajapp/Utils/SharedPrefunc.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class Eventcontroller extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchEventList();
    Loading(true);
  }


  late AnimationController ac;

  RxBool videoLoading = false.obs;
  RxInt ViInd = 0.obs;

  var eventData = [].obs;
  RxBool openFilterBox = false.obs;
  RxString filter = "upcoming".obs;
  RxBool Loading = false.obs;
  RxDouble volume = 0.3.obs;
  RxInt imageIndex = 0.obs;
  RxBool videoPlaying = true.obs;

  playPauseVideo() {
    videoPlaying.toggle();
    videoPlaying.value ? vc.play() : vc.pause();
    videoPlaying.value ? ac.reverse() : ac.forward();
  }

  decreaseVolume() {
    if (volume > 0.0) {
      volume.value -= 0.1;
      vc.setVolume(volume.value);
    }
  }

  IncreaseVolume() {
    if (volume < 1.0) {
      volume.value += 0.1;
      vc.setVolume(volume.value);
    }
  }

  late VideoPlayerController vc;
  RxBool isVideoInitialized = false.obs;
  Rx<Duration> videoDuration = Duration().obs;
  Rx<Duration> TotalvideoDuration = Duration().obs;
  RxInt videoIndex = 0.obs;

  seekVid(value) {
    final duration = Duration(seconds: value.toInt());
    vc.seekTo(duration);
  }

  loadVideo(videoUrl) async {
    try {
      var url = Uri.parse(videoUrl);
      vc = VideoPlayerController.networkUrl(url);
      await vc.initialize();
      isVideoInitialized.value = true;
      videoPlaying(true);
      vc.play();
      TotalvideoDuration.value = vc.value.duration;
      vc.addListener(() {
        videoDuration.value = vc.value.position;
      });
    } catch (e) {
      isVideoInitialized.value = false;
    }
  }

  RxList<String> thumbnailList = <String>[].obs;

  LoopIt() async {
    thumbnailList.clear();
    if (eventDetailData['multiple_event_video'].isNotEmpty) {
      for (var video in eventDetailData['multiple_event_video']) {
        String Thumb = await GetVideoThumbnail(video['video']);
        thumbnailList.add(Thumb);
      }
    }
  }

  GetVideoThumbnail(videoUrl) async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 64,
      quality: 75,
    );
    return fileName;
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigitMinutes}:" + "$twoDigitSeconds";
  }

  TextEditingController searchController = TextEditingController();

  RxBool isSearched = false.obs;

  fetchEventList() async {
    try {
      String accesstoken = await getShared();

      final response = await http.get(
          Uri.parse(myApi.EventListAPI +
              '?filters=${filter.value}&search=${searchController.text.toString()}'),
          headers: {'x-api-key': accesstoken});

      if (response.statusCode == 200) {
        eventData.clear();
        final jsonData = jsonDecode(response.body);
        eventData.assignAll(jsonData['data']);
      } else if (response.statusCode == 407) {
        await RemoveUser();
      }
    } catch (e) {
      eventData.clear();
    } finally {
      Loading(false);
      update();
    }
  }

  dynamic eventDetailData = {}.obs;

  fetchEventDetail(id) async {
    try {
      eventDetailData.clear();
      String accesstoken = await getShared();

      final response = await http.get(
          Uri.parse(myApi.EventDetailAPI + '?event_id=${id}'),
          headers: {'x-api-key': accesstoken});

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        eventDetailData = jsonData;
      } else if (response.statusCode == 407) {
        await RemoveUser();
      }
    } catch (e) {
      eventDetailData.clear();
    } finally {
      Loading(false);
      update();
    }
  }

  var eventDonationList = [].obs;

  fetchEventDonationList(id) async {
    try {
      eventDonationList.clear();
      String accesstoken = await getShared();

      final response = await http.get(
          Uri.parse(myApi.eventDonation + '?event_id=${id.toString()}'),
          headers: {'x-api-key': accesstoken});
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        eventDonationList.assignAll(jsonData['data']);
      } else {
        eventDonationList.clear();
      }
    } catch (e) {
      eventDonationList.clear();
      print(e.toString());
    } finally {
      update();
    }
  }

  var eventExpenseList = [].obs;

  fetchEventExpenseList(id) async {
    try {
      eventExpenseList.clear();
      String accesstoken = await getShared();

      final response = await http.get(
          Uri.parse(myApi.eventExpense + '?event_id=${id.toString()}'),
          headers: {'x-api-key': accesstoken});
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        eventExpenseList.assignAll(jsonData['data']);
      } else {
        eventExpenseList.clear();
      }
    } catch (e) {
      eventExpenseList.clear();
      print(e.toString());
    } finally {
      update();
    }
  }
}
