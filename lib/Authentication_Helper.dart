import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:take_a_break/globals.dart';

class AuthenticationHelper{
  final FirebaseAuth _firebaseAuth;

  AuthenticationHelper(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }


  Future<String> signIn({String email, String password}) async{
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      Globals.uid =  _firebaseAuth.currentUser.uid;
      return "Signed in";
    } on FirebaseAuthException catch (e){
      return e.message;
    }

  }
  Future<String> signUp({String email, String password}) async{
    try{
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      Globals.uid = _firebaseAuth.currentUser.uid;
      return "Signed up";
    } on FirebaseAuthException catch (e){
      return "could not signup";
    }
  }

}