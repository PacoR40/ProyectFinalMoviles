import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../firebase/autentication.dart';
import '../provider/theme_provider2.dart';
import '../widgets/textForm.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final _claveFormulario = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Authentication? _authentication;

  @override
  void initState() {
    _authentication = Authentication();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox( height: 40,),
              IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.arrow_back), color: Color.fromARGB(255, 0, 150, 255), iconSize: 30,),
              const SizedBox( height: 15,),
              Container(
                  alignment: Alignment.center,
                  height: 70,
                  child: Image(
                    image: themeProvider.isLightTheme ? AssetImage('assets/groceryLogoComplete.png') : AssetImage('assets/groceryWhite.png')
                  )
              ),
              const SizedBox( height: 25 ),
              Text(
                "Create your accoun",
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
                ),
              ),
      
              const SizedBox( height: 30 ),
              InkWell(
                onTap: () async {
                  if ( !_claveFormulario.currentState!.validate()) {
                    return;
                  }
                  await _authentication!.createUserWithEmailAndPassword(mail: emailController.text, password: passwordController.text).then((value) {
                    if (value){
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        text: 'Successful registration!',
                        onConfirmBtnTap: () {
                          Navigator.pop(context);
                        },
                      );
                      
                    }else{
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: 'Oops...',
                        text: 'Sorry, registration failed',
                      );
                    }
                  });
                  Navigator.pop(context);
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
            ],
          ),
        ),
      )
    );
  }
}