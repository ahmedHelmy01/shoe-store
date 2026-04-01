import 'package:url_launcher/url_launcher.dart';

Future<void> openUrl(String url) async {
  if (url.isEmpty) return;

  final uri = Uri.tryParse(url);
  if (uri == null) return;

  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $url';
  }
}
