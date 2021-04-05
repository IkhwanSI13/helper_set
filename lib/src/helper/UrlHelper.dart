import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  void openToBrowser(String url) async {
    if (url.contains("whatsapp://send")) {
      url = url.replaceFirst("whatsapp://", "https://wa.me/");
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
