import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:switcher/switcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/theme_provider2.dart';

class subscriptionsScreen extends StatefulWidget {
  const subscriptionsScreen({Key? key}) : super(key: key);

  @override
  State<subscriptionsScreen> createState() => _subscriptionsScreenState();
}

class _subscriptionsScreenState extends State<subscriptionsScreen> {

  bool ?valor1 = false;
  bool ?valor2 = false;

  
  // Future<void> saveSubs ( valor1, valor2) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('valor1', valor1);
  //   await prefs.setBool('valor2', valor2);
  // }

  Future<void> checkSubs () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    valor1 = prefs.getBool('valor2');
    valor2 = prefs.getBool('valor2');
  }

  @override
  void initState() {
    checkSubs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final sw1 = CheckboxListTile(
      checkColor: Colors.white,
      value: valor1,
      title: const Text('Messages'),
      onChanged: (bool? value){
        setState(() {
          valor1 = value!;
        });
      },
      secondary: const Icon(Icons.message_rounded),
    );

    final sw2 = CheckboxListTile(
      checkColor: Colors.white,
      value: valor2,
      title: const Text('Offers'),
      onChanged: (bool? value){
        setState(() {
          valor2 = value!;
        });
      },
      secondary: const Icon(Icons.local_offer),
    );

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
              const SizedBox( height: 20,),
              Center(
                child: Text(
                  "Select your topics of interest",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(
                    fontStyle: FontStyle.normal,
                    fontSize: 25,
                    color: themeProvider.isLightTheme
                          ? Colors.black
                          : Colors.white,
                  )
                ),
              ),
              const SizedBox( height: 50,),
              // Center(
              //   child: Text(
              //     "Messages",
              //     style: GoogleFonts.raleway(
              //       fontStyle: FontStyle.normal,
              //       fontSize: 18,
              //       color: themeProvider.isLightTheme
              //             ? Colors.black
              //             : Colors.white,
              //     )
              //   ),
              // ),
              // const SizedBox( height: 10,),
              Center(
                child: Container(child: sw1)
              ),
              //const SizedBox( height: 20,),
              // Center(
              //   child: Text(
              //     "Offers",
              //     style: GoogleFonts.raleway(
              //       fontStyle: FontStyle.normal,
              //       fontSize: 18,
              //       color: themeProvider.isLightTheme
              //             ? Colors.black
              //             : Colors.white,
              //     )
              //   ),
              // ),
              const SizedBox( height: 10,),
              Center(
                child: Container(child: sw2)
              ),
              const SizedBox( height: 30,),
              InkWell(
                  onTap: () async {
                    print('valor 1:');
                    print(valor1);
                    print('valor 2:');
                    print(valor2);
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('valor1', valor1!);
                      await prefs.setBool('valor1', valor2!);
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
      ),
    );
  }
}