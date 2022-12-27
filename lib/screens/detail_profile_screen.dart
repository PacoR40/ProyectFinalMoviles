import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../firebase/autentication.dart';
import '../models/firebase_user.dart';
import '../provider/theme_provider2.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final FirebaseUser _user = FirebaseUser();
  final Authentication _authentication = Authentication();

  @override
  void initState() {
    _user.user(_authentication.user);
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
              const SizedBox( height: 5,),
              IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.arrow_back), color: Color.fromARGB(255, 0, 150, 255), iconSize: 30,),
              Center(
                child: Text(
                  'Your Profile',
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: themeProvider.isLightTheme
                        ? Colors.black
                        : Colors.white,
                  )
                )
              ),
              const SizedBox( height: 15,),
              Center(
                child: Hero(
                  tag:"imgProfile",
                  child: CircleAvatar(
                    radius: 110,
                    backgroundImage: _user.imageUrl !=  null  ? NetworkImage(_user.imageUrl!) : NetworkImage('https://i.pinimg.com/736x/8b/16/7a/8b167af653c2399dd93b952a48740620.jpg')
                  ),
                ),
              ),
              const SizedBox( height: 30,),
              Center(
                child: Text(
                  _user.name != null ? _user.name! : "sin nombre",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    color: themeProvider.isLightTheme
                        ? Colors.black
                        : Colors.white,
                  )
                )
              ),
              const SizedBox( height: 10,),
              Center(
                child: Text(
                  _user.email!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: themeProvider.isLightTheme
                        ? Colors.black
                        : Colors.white,
                  )
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}