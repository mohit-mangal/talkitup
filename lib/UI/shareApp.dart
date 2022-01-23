import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ShareApp {
  final BuildContext context;
  ShareApp(this.context);

  final String appLink =
      'Link to the app: https://play.google.com/store/apps/details?';

  void _share(String text) {
    Share.share(
      text,
      subject: 'TalkItUp - An incredible social audio app',
    );
  }

  void club(String roomTitle) {
    //  final RenderBox box = context.findRenderObject();
    String text = '$roomTitle is booming💥on TalkItUp. ';

    text +=
        'Hey, come and join us in Hall. The panelists are really interesting.';

    text += ' $appLink';
    _share(text);
  }
}
