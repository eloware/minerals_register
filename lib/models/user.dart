import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalUser {
  UserCredential? firebaseCredential;

  String get userId => firebaseCredential!.user.uid;
  String? name;

  String get samplePath => 'users/$userId/samples';

  void logout() async {
        var prefs = await SharedPreferences.getInstance();
        prefs.remove('username');
        prefs.remove('password');
        firebaseCredential = null;
        name = null;
  }
}
