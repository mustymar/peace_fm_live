import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prtv_stream/include/menu.items.inc.dart';
import 'package:radio_player/radio_player.dart';

import '../include/colors.inc.dart';
import 'about.scr.dart';
import 'webview.scr.dart';

class PRTVStream extends StatefulWidget {
  const PRTVStream({super.key});

  @override
  State<PRTVStream> createState() => _PRTVStreamState();
}

class _PRTVStreamState extends State<PRTVStream> {
  RadioPlayer radioPlayer = RadioPlayer();
  bool isPlaying = false;
  void startStream() {
    radioPlayer.setChannel(
        title: "PEACE FM LIVE",
        url:
            "https://freeuk25.listen2myradio.com/live.mp3?typeportmount=s1_10795_stream_336205374",
        // url: "http://65.108.124.70:7380/okinfm",
        imagePath: "assets/image/prtv_stream.png");
    radioPlayer.play();
    radioPlayer.stateStream.listen((value) {
      setState(() {
        isPlaying = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startStream();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(context: context, builder: (_) => dialogFn());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.primaryColor,
          elevation: 0,
          toolbarHeight: 0,
        ),
        body: Container(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).padding.top * 0.4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: AppColor.primaryColor,
                      size: 20,
                    ),
                    onPressed: () {
                      showDialog(context: context, builder: (_) => dialogFn());
                    },
                  ),
                  const Expanded(
                    child: SizedBox(
                      height: 0,
                    ),
                  ),
                  PopupMenuButton<Items>(
                      color: AppColor.primaryColor,
                      onSelected: (item) => onSelected(context, item),
                      itemBuilder: (_) => [
                            ...MenuItems.items.map(buildMenuItems).toList(),
                          ]),
                ],
              ),

              Container(
                height: 200,
                width: 200,
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                  boxShadow: const [
                    BoxShadow(
                        spreadRadius: 0.5,
                        blurRadius: 5,
                        color: Colors.white,
                        offset: Offset(0, 0))
                  ],
                ),
                child: const Image(
                  fit: BoxFit.scaleDown,
                  image: AssetImage("assets/image/prtv.png"),
                  width: 100,
                  height: 100,
                ),
              ),
              const Text(
                "PEACE FM LIVE",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
              //Control Buttons
              Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.top * 2.5),
                child: Center(
                  child: IconButton.outlined(
                    style: ButtonStyle(
                        side: MaterialStateProperty.all<BorderSide>(
                            const BorderSide(color: AppColor.primaryColor)),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)))),
                    onPressed: () =>
                        isPlaying ? radioPlayer.stop() : radioPlayer.play(),
                    splashColor: AppColor.primaryColor,
                    color: AppColor.primaryColor,
                    icon: Icon(
                      isPlaying
                          ? Icons.stop_outlined
                          : Icons.play_arrow_outlined,
                      size: 64,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AlertDialog dialogFn() => AlertDialog(
        title: const Text(
          "Confirmation",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Do you want exit",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black,
        shadowColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20,
          ),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(
                AppColor.primaryColor,
              ),
              fixedSize: MaterialStateProperty.all<Size>(const Size(30, 20)),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              "NO",
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(
                AppColor.primaryColor,
              ),
              fixedSize: MaterialStateProperty.all<Size>(const Size(30, 20)),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            onPressed: () => SystemNavigator.pop(),
            child: const Text(
              "YES",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
}

PopupMenuEntry<Items> buildMenuItems(Items mItems) => PopupMenuItem(
    value: mItems,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          mItems.icon,
          color: Colors.white,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          mItems.title,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    ));

void onSelected([BuildContext? context, Items? item]) {
  switch (item) {
    case MenuItems.itemBlog:
      Navigator.of(context!)
          .push(MaterialPageRoute(builder: (_) => const PRTVWebView()));
      break;
    case MenuItems.about:
      Navigator.of(context!)
          .push(MaterialPageRoute(builder: (_) => const PRTVAbout()));
      break;
  }
}
