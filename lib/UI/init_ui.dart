import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkitup/Providers/user_provider.dart';
import 'package:talkitup/UI/loading_widget.dart';
import 'package:talkitup/UI/sign_in_page.dart';
import 'package:talkitup/UI/sign_up_page.dart';

import 'home_page.dart';

class InitUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<UserProvider>(
      builder: (ctx, userProvider, _) {
        if (!userProvider.isLoggedIn) return SignInPage();
        if (userProvider.isLoadingUser) {
          return LoadingWidget(withScaffold: true);
        }

        return userProvider.userDetails == null ? SignUpPage() : HomePage();
      },
    ));
  }
}
