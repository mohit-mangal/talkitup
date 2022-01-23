import 'package:firebase_auth/firebase_auth.dart';
import 'package:talkitup/Models/user_details.dart';
import 'package:talkitup/Services/firestore_services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  static final _firebaseAuth = FirebaseAuth.instance;

  static final AuthStream = _firebaseAuth.authStateChanges();

  static String? userEmail() {
    return _firebaseAuth.currentUser?.email;
  }

  static String? userId() {
    return _firebaseAuth.currentUser?.uid;
  }

  static bool? isUserLoggedIn() {
    User? firebaseUser;
    try {
      firebaseUser = _firebaseAuth.currentUser;
    } catch (e) {
      return null;
    }

    if (firebaseUser != null) {
      return true;
    } else {
      return false;
    }
  }

  static Future<UserDetails?> currentUser() async {
    final user = _firebaseAuth.currentUser!;
    return await FirestoreServices.fetchUser(user.uid);
  }

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['profile', 'email', 'openid'],
  );

  static Future<User?> signInWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount;
    try {
      googleSignInAccount = await _googleSignIn.signIn();
    } catch (e) {
      print('google sign in error: ${e.toString()}');
    }

    if (googleSignInAccount == null) {
      return null;
    }

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    User? user;
    try {
      user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    } catch (e) {
      print('firebase sign in error: ${e.toString()}');
      await signOutGoogle();
    }
    if (user == null) return null;

    final currentUser = FirebaseAuth.instance.currentUser;

    return currentUser;
  }

  static Future<void> signOutGoogle() async {
    if (_googleSignIn != null) {
      await _googleSignIn.signOut();
    }
    await FirebaseAuth.instance.signOut();
    print("User Sign Out");
  }
}
