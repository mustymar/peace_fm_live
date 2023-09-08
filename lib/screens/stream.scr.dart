import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../include/stream.barrel.inc.dart';

class PRTVStream extends StatefulWidget {
  const PRTVStream({super.key});

  @override
  State<PRTVStream> createState() => _PRTVStreamState();
}

class _PRTVStreamState extends State<PRTVStream> {
  @override
  void initState() {
    super.initState();
    AppStream().streamInit(getCurrentStreamUrlGlobal);
    print("Is this the global link: $getCurrentStreamUrlGlobal");
  }

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<AppState>(context).connectionStatus;

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
                    child: SizedBox(),
                  ),
                  PlayerBuilder.isBuffering(
                    player: assetsAudioPlayer,
                    builder: (context, isBuffering) {
                      if (isBuffering) {
                        return const Icon(Icons.cell_tower, color: Colors.red);
                      } else {
                        return const Icon(Icons.cell_tower,
                            color: AppColor.primaryColor); //empty
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  Builder(
                    builder: (BuildContext context) {
                      InternetConnection().onStatusChange.listen((status) {
                        Provider.of<AppState>(context, listen: false)
                            .connectionStatusFn(status);
                      });
                      if (connectionStatus == InternetStatus.connected) {
                        return const Icon(Icons.wifi,
                            color: AppColor.primaryColor);
                      } else {
                        return const Icon(Icons.wifi_off, color: Colors.red);
                      }
                    },
                  ),
                  const SizedBox(width: 10),
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
              Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.top * 2.5),
                child: PlayerBuilder.isPlaying(
                  player: assetsAudioPlayer,
                  builder: (context, isPlaying) {
                    Widget container = Center(
                      child: IconButton.outlined(
                        style: ButtonStyle(
                            side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(color: AppColor.primaryColor)),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)))),
                        onPressed: () async {
                          try {
                            if (isPlaying) {
                              assetsAudioPlayer.pause();
                            } else {
                              await AppStream().streamAudioGet(context);
                              assetsAudioPlayer.play();
                            }
                          } catch (t) {
                            String errorMessage = t.toString();
                            Fluttertoast.showToast(msg: errorMessage);
                          }
                        },
                        splashColor: AppColor.primaryColor,
                        color: AppColor.primaryColor,
                        icon: Icon(
                          isPlaying
                              ? Icons.stop_outlined
                              : Icons.play_arrow_outlined,
                          size: 64,
                        ),
                      ),
                    );
                    return container;
                  },
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
