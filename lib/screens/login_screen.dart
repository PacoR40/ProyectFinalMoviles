import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:practica7/firebase/autentication.dart';
import 'package:practica7/widgets/textForm.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/theme_provider2.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _claveFormulario = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Authentication _authentication = Authentication();
  StreamSubscription? _subs;
  bool? loader;
  bool? status = false;

  void ChechAutentication(){
    Future.delayed(Duration.zero, (() {
      if( _auth.currentUser != null ){
        Navigator.pushNamed(context, '/onBoarding');
      }
    }));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    loader = false;
    _initDeepLinkListener();
    ChechAutentication();
    super.initState();
    FirebaseStorage.instance.ref('/images').list();
  }

  ///INICA GIIITTTT
  void _initDeepLinkListener() async {
    _subs = linkStream.listen((String? link) {
      _checkDeepLink(link!);
    }, cancelOnError: true);
  }

  void _checkDeepLink(String link) {
    if (link != null) {
      String code = link.substring(link.indexOf(RegExp('code=')) + 5);
      _authentication.loginWithGitHub(code)
        .then((firebaseUser) {
          Navigator.pushNamed(context, '/onBoarding');
        }).catchError((e) {
          print("LOGIN ERROR: " + e.toString());
        });
    }
  }

  void _disposeDeepLinkListener() {
    if (_subs != null) {
      _subs!.cancel();
      _subs = null;
    }
  }
///Termina GIT

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox( height: 50 ),
                Container(
                  alignment: Alignment.center,
                  height: 70,
                  child: Image(image: themeProvider.isLightTheme ? AssetImage('assets/groceryLogoComplete.png') : AssetImage('assets/groceryWhite.png'))
                ),
                const SizedBox( height: 25 ),
                Text(
                  "Login to your accoun",
                  style: GoogleFonts.raleway(
                    fontStyle: FontStyle.normal,
                    fontSize: 18,
                    color: themeProvider.isLightTheme
                        ? Colors.black
                        : Colors.white,
                  )
                ),
                const SizedBox( height: 15 ),
                Form(
                  key: _claveFormulario,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      TextFormGlobal(controller: emailController, text: "Email", textInputType: TextInputType.emailAddress, obscure: false,),
                      const SizedBox( height: 10 ),
                      TextFormGlobal(controller: passwordController, text: "Password", textInputType: TextInputType.visiblePassword, obscure: true,),
                    ],
                  )
                ),
            
                const SizedBox( height: 30 ),
                InkWell(
                  onTap: () async {
                    if ( !_claveFormulario.currentState!.validate()) {
                      return;
                    }
                    var ban = await _authentication.signInWithEmailAndPassword(mail: emailController.text, password: passwordController.text);
                    if (ban){
                      if(_auth.currentUser!.emailVerified){
                        Navigator.pushNamed(context, '/onBoarding');    
                      }else{
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: 'Oops...',
                          text: 'Sorry, unverified user',
                        );
                      }
                    }else{
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: 'Oops...',
                          text: 'Sorry, invalid credentials',
                      );
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 0, 150, 255),
                      borderRadius:  BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10
                        )
                      ]
                    ),
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                const SizedBox( height: 25 ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '-Or sign in with-',
                    style: GoogleFonts.raleway(
                      fontStyle: FontStyle.normal,
                      fontSize: 15,
                      color: themeProvider.isLightTheme
                        ? Colors.black
                        : Colors.white,
                    )
                  )
                ),
                const SizedBox( height: 20 ),
                SocialLoginButton(
                  width: 280,
                  buttonType: SocialLoginButtonType.google,
                  onPressed: () async{
                    var ban = await _authentication.signInGoogle();
                    if (ban != null){
                      Navigator.pushNamed(context, '/onBoarding');
                    }
                  }
                ),
                const SizedBox( height: 5 ),
                SocialLoginButton(
                  width: 280,
                  buttonType: SocialLoginButtonType.facebook,
                  onPressed: () async{
                    var ban = await _authentication.signInFacebook();
                    if (ban != null){
                      Navigator.pushNamed(context, '/onBoarding');
                    }
                  }
                ),
                const SizedBox( height: 5 ),
                SocialLoginButton(
                  width: 280,
                  buttonType: SocialLoginButtonType.github,
                  onPressed: () async{
                    await onClickGitHubLoginButton();
                  }
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        //color: Colors.white,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: GoogleFonts.raleway(
                fontStyle: FontStyle.normal,
                color: themeProvider.isLightTheme
                        ? Colors.black
                        : Colors.white,
              )
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/signUp');
              },
              child: Text(
                "Sign Up",
                style: GoogleFonts.raleway(
                  fontStyle: FontStyle.normal,
                  color: Colors.blueAccent
                )
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> onClickGitHubLoginButton() async {
  const String url = "https://github.com/login/oauth/authorize" +
        "?client_id=" + "e3c3c6cc6f08995493cd" +
        "&scope=public_repo%20read:user%20user:email";
  // ignore: deprecated_member_use
  if (await canLaunch(url)) {
      setState(() {
        loader = true;
      });
      // ignore: deprecated_member_use
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
      //return true;
      print("Se logeoo");
    } else {
      setState(() {
        loader = false;
      });
      //return true;
      print("No Se logeoo");
      print("CANNOT LAUNCH THIS URL!");
    }
    return true;
    }

}