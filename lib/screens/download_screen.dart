import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key, required this.url});
  final String url;

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  bool isloadingThumbnail = true;
  bool isLoadingVideoUrl = true;
  bool isLoadingAudioUrl = true;

  final yt = YoutubeExplode();
  late String thumbnail = "";
  late String title = "";

  late Map<Uri, String> videoUrlRes = Map();
  late Map<String, String> videoQualitSize = Map();
  //late
  late Map<Uri, String> audioUrlsBitrate = Map();
  late Map<String, String> audioBitrateSize = Map();

  void startdownload() async {
    try {
      var video = await yt.videos.get(widget.url);
      //print('Title: ${video.title}');
      //print('Thumbnail URL: ${video.thumbnails.highResUrl}');
      thumbnail = video.thumbnails.highResUrl;
      setState(() {
        isloadingThumbnail = false;
        title = video.title;
      });

      var manifest = await yt.videos.streamsClient.getManifest(widget.url);

      var videoStreams = manifest.video;
      for (var stream in videoStreams) {
        videoUrlRes[stream.url] = stream.videoResolution.toString();
        videoQualitSize[stream.videoQuality.toString()] =
            stream.size.toString();
      }
      setState(() {
        isLoadingVideoUrl = false;
      });
      var audioStreams = manifest.audioOnly;
      for (var stream in audioStreams) {
        // print(
        //     'Audio Stream: ${stream.url} | Quality: ${stream.bitrate.kiloBitsPerSecond} kbps');
        audioUrlsBitrate[stream.url] =
            stream.bitrate.kiloBitsPerSecond.toString();
        audioBitrateSize[stream.bitrate.toString()] = stream.size.toString();
      }
      setState(() {
        isLoadingAudioUrl = false;
      });
    } catch (C) {
      Navigator.pop(context);
      rethrow;
    } finally {
      yt.close();
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    startdownload();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: OrientationBuilder(
            builder: (context, orientation) {
              Color startColor = (orientation == Orientation.portrait)
                  ? const Color(0xFF1CFCF3)
                  : const Color(0xFF74A9E6);

              Color endColor = (orientation == Orientation.portrait)
                  ? const Color(0xFF3FC1C9)
                  : const Color(0xFF1CFCF3);

              return AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [startColor, endColor],
                    begin: (orientation == Orientation.portrait)
                        ? Alignment.topCenter
                        : Alignment.bottomCenter,
                    end: (orientation == Orientation.portrait)
                        ? Alignment.bottomCenter
                        : Alignment.topCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 3,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: AppBar(
                  title: const Row(
                    children: [
                      Text(
                        "Dw Player",
                        style: TextStyle(
                          color: Color(0XFFF5F5F5),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.music_note_outlined,
                        color: Color(0xfff5f5f5),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Skeletonizer(
                enabled: isloadingThumbnail,
                enableSwitchAnimation: true,
                child: thumbnail.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          thumbnail,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 250,
                        ),
                      )
                    : Shimmer.fromColors(
                        baseColor: Color(0xff435364),
                        highlightColor: Color(0xff101418),
                        child: Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            color: Color(0xff101418),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
              ),
            ),
            // const SizedBox(
            //   height: 8,
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Skeletonizer(
                enabled: isloadingThumbnail,
                enableSwitchAnimation: true,
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    isloadingThumbnail ? "Loading thumbnail..." : title,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Color(0xffffc600),
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            isLoadingAudioUrl && isLoadingVideoUrl
                ? Skeletonizer(
                    enabled: true,
                    enableSwitchAnimation: true,
                    child: ListView.builder(
                      itemCount: 6,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text('Item number $index as title'),
                            subtitle: const Text('Subtitle here'),
                            trailing: const Icon(
                              Icons.ac_unit,
                              size: 32,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : ListView.builder(
                    itemCount: videoUrlRes.length + audioUrlsBitrate.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: videoUrlRes.length < index
                              ? Text("Video Stream ${videoQualitSize}")
                              : Text("Audio Stream"),
                          subtitle: Text("Download in your desired format"),
                          trailing: Icon(
                            videoUrlRes.length < index
                                ? Icons.video_collection_outlined
                                : Icons.audio_file_outlined,
                            size: 32,
                          ),
                        ),
                      );
                    },
                  )
          ]),
        ),
      ),
    );
  }
}
