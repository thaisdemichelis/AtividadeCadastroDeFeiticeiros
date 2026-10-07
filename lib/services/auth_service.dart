import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> entrarComGoogle() {
    return _auth.signInWithProvider(GoogleAuthProvider());
  }

  Future<void> sair() {
    return _auth.signOut();
  }
}
