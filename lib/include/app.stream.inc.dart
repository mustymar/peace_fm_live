import '../include/app.stream.barrel.inc.dart';

class AppStream {
  void checkConnect(context) {
    InternetConnection().onStatusChange.listen((InternetStatus status) async {
      Provider.of<AppState>(context, listen: false).connectionStatusFn(status);
      if (status == InternetStatus.disconnected) {
        return;
      } else {
        await streamAudioGet(context);
        Future.delayed(const Duration(seconds: 3));
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const PRTVStream()));
      }
    });
  }

  Future streamAudioGet(context) async {
    String getCurrentStreamUrlLocal = 'https://prtvc.ng/streamlink.php';
    Response response = await Dio().get(getCurrentStreamUrlLocal);
    Object responseJSON = response.data["streaminglink"];
    String getCurrentStreamUrl = responseJSON.toString();
    Provider.of<AppState>(context, listen: false)
        .streamLink(getCurrentStreamUrl);
    getCurrentStreamUrlGlobal = getCurrentStreamUrl;
  }

  void streamInit(String streamLinkURL) async {
    NotificationSettings notificationSettings =
        const NotificationSettings(nextEnabled: false, prevEnabled: false);
    try {
      assetsAudioPlayer.onErrorDo = (errorHandler) => assetsAudioPlayer.stop();
      await assetsAudioPlayer.open(
        Audio.liveStream(streamLinkURL,
            metas: Metas(
                title: 'PEACE FM LIVE',
                album: 'Plateau Radio Television',
                artist: 'PRTV',
                image: const MetasImage.asset('assets/image/prtv.png'))),
        autoStart: false,
        showNotification: true,
        notificationSettings: notificationSettings,
      );
    } catch (t) {
      String errorMessage = t.toString();
      Fluttertoast.showToast(msg: errorMessage);
    }
  }
}
