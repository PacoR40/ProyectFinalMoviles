import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:http/http.dart' as http;

import '../models/github_login_request.dart';
import '../models/github_login_response.dart';

class Authentication{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FacebookLogin _objFacebookSignIn = new FacebookLogin();

  User? get user {
    return _auth.currentUser;
  }

  Future<bool> createUserWithEmailAndPassword ({required String mail, required String password}) async{
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(email: mail, password: password);
      User user = userCredential.user!;
      user.sendEmailVerification();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signInWithEmailAndPassword({required  String mail, required String password}) async{
    try {
      await _auth.signInWithEmailAndPassword(email: mail, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signInGoogle() async{
    try {
      final GoogleSignInAccount googleUser = (await _googleSignIn.signIn())!;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if(user!.uid == _auth.currentUser!.uid)
        return true;
    } catch (e) {
      print("Error in signInGoogle Mwthod: ${e.toString()}");
    }
    return false;
  }

  Future<User?> signInFacebook() async {
    User? user;

    FacebookLoginResult objFacebookSignInAccount = await _objFacebookSignIn.logIn(
      permissions: [
        FacebookPermission.email,
        FacebookPermission.publicProfile
      ]);

    if (objFacebookSignInAccount != null ) {
      FacebookAccessToken objAccessToken = objFacebookSignInAccount.accessToken!;
      AuthCredential objCredential = FacebookAuthProvider.credential(objAccessToken.token);
      try {
        UserCredential objUserCredential = await FirebaseAuth.instance.signInWithCredential(objCredential);
        user = objUserCredential.user;
        return user;
      } on FirebaseAuthException catch (e) {
        print("Error en la autenticacion");
      }
    }else{
      return null;
    }
    //return null;
  }

  Future<User> loginWithGitHub(String code) async{
    final response = await http.post(Uri.parse("https://github.com/login/oauth/access_token"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: jsonEncode(GitHubLoginRequest(
        clientId: "",
        clientSecret: "",
        code: code
      )),
    );
    GitHubLoginResponse loginResponse = GitHubLoginResponse.fromJson(json.decode(response.body));

    final AuthCredential credential = GithubAuthProvider.credential(loginResponse.accessToken!);

    final User? user = (await _auth.signInWithCredential(credential)).user;
    return user!;
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      await _objFacebookSignIn.logOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
