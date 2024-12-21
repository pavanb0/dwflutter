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
  final yt = YoutubeExplode();
  late String thumbnail = "";

  void startdownload() async {
    try {
      var video = await yt.videos.get(widget.url);
      print('Title: ${video.title}');
      print('Thumbnail URL: ${video.thumbnails.highResUrl}');
      thumbnail = video.thumbnails.highResUrl;
      setState(() {
        isloadingThumbnail = false;
      });
      var manifest = await yt.videos.streamsClient.getManifest(widget.url);

      // Get all video formats
      var videoStreams = manifest.video;
      for (var stream in videoStreams) {
        print(
            'Video Stream: ${stream.url} | Resolution: ${stream.videoQuality}');
      }

      // Get all audio formats
      var audioStreams = manifest.audioOnly;
      for (var stream in audioStreams) {
        print(
            'Audio Stream: ${stream.url} | Quality: ${stream.bitrate.kiloBitsPerSecond} kbps');
      }
    } catch (C) {
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
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          isloadingThumbnail
                              ? "Loading thumbnail..."
                              : "Video Thumbnail",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Skeletonizer(
                    enabled: isloadingThumbnail,
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
                  ),
                ]),
          )),
    );
  }
}
