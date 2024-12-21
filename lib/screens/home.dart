import 'package:dwflutter/screens/download_screen.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController urlcontroller = TextEditingController();
  // bool isloading = false;

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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "download any video from Youtube 🔥",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0XF5F5F5F5), fontSize: 20.00),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: urlcontroller,
                      decoration: const InputDecoration(
                        labelText: "Enter video URL",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.link),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: OutlinedButton(
                      onPressed: () {
                        if (urlcontroller.text.trim() != "") {
                          String url = urlcontroller.text.trim();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=>DownloadScreen(url: url,))
                          );
                        } else {
                          Vibration.vibrate();
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Colors.deepPurple, // Border color
                          width: 2, // Border width
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12), // Padding inside the button
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Rounded corners
                        ),
                        backgroundColor: Colors.deepPurple
                            .withOpacity(0.1), // Background color with opacity
                        shadowColor: Colors.deepPurple, // Shadow color
                        elevation: 5, // Elevation for 3D effect
                      ),
                      child: const Text(
                        "Next",
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 16, // Font size
                          fontWeight: FontWeight.bold, // Text weight
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15.00,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          const Text(
                            "share the youtube video as link copy the link and paste it on video url ",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Color(0XF5F5F5F5),
                              fontSize: 18.00,
                            ),
                            softWrap: true,
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'assets/images/roshi.jpg',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'assets/images/pikachu.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ))
                ]),
          )),
    );
  }
}
