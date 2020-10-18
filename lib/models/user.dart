import 'package:firebase_auth/firebase_auth.dart';

class LocalUser {
  UserCredential firebaseCredential;
  String get userId => firebaseCredential.user.uid;
  String name;
  String get samplePath => 'users/$userId/samples';
}
