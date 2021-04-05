import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
class FUser{
  FUser({@required this.uid});
  final String uid;
}
abstract class AuthBase{
  FUser currentUser();
  Future<FUser> signInAnonymously();
  Future<void> signOut();
  Stream<FUser> get onAuthStateChanged;
  Future<FUser> signInWithGoogle();
  Future<FUser> signInWithEmailAndPassword(String email, String pass);
  Future<FUser> createUserWithEmailAndPassword(String email, String pass);
}
class Auth implements AuthBase{

  final _firebaseAuth= FirebaseAuth.instance;
  FUser _userFromFirebase(User user){
    if(user==null)return null;
    return FUser(uid: user.uid );
  }
  @override
  Stream<FUser> get onAuthStateChanged{
    return _firebaseAuth.authStateChanges().map((_userFromFirebase));
  }
  @override
  FUser currentUser() {
    final user= _firebaseAuth.currentUser;
    return _userFromFirebase(user); 
  }
  @override
  Future<FUser> signInAnonymously() async{
    final authResult = await  _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  Future<FUser> signInWithGoogle() async{
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if(googleAccount!=null){
      GoogleSignInAuthentication googleAuth = await googleAccount.authentication;
      if(googleAuth.idToken!=null && googleAuth.accessToken!=null){
      final authResult = await _firebaseAuth.signInWithCredential(
        GoogleAuthProvider.credential(idToken: googleAuth.idToken , accessToken:googleAuth.accessToken)
      );
      return _userFromFirebase(authResult.user);
      }
      else{
        throw PlatformException(
        code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
        message: 'Missing Google Auth Token',
      );
      }
    }
    else{
      throw PlatformException(
        code: 'ERRR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }
  @override
  Future<FUser> signInWithEmailAndPassword(String email, String pass)async{
      final authResult = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: pass);
      return _userFromFirebase(authResult.user);
  }
  @override
  Future<FUser> createUserWithEmailAndPassword(String email, String pass)async{
      final authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass);
      return _userFromFirebase(authResult.user);
  }
  @override
  Future<void> signOut() async{
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await  _firebaseAuth.signOut();
  }
}