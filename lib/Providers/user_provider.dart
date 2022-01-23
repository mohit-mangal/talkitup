import 'package:flutter/cupertino.dart';
import 'package:talkitup/Models/user_details.dart';
import 'package:talkitup/Services/auth_services.dart';

class UserProvider with ChangeNotifier {
  UserDetails? userDetails;
  late bool isLoadingUser = false;

  UserProvider() {
    isLoadingUser = true;
    _initListener();
  }

  void _initListener() {
    AuthServices.AuthStream.listen((user) {
      loadUser();
    });
  }

  void loadUser() async {
    isLoadingUser = true;
    notifyListeners();

    final bool? isUserLoggedIn = AuthServices.isUserLoggedIn();
    if (isUserLoggedIn == true) {
      userDetails = await AuthServices.currentUser();
    } else {
      userDetails = null;
    }
    isLoadingUser = false;
    notifyListeners();
  }

  bool get isLoggedIn => AuthServices.isUserLoggedIn() == true;
  String? get email => AuthServices.userEmail();
  String? get id => AuthServices.userId();
}
