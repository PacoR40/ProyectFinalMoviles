
//import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_card/image_card.dart';
import 'package:practica7/firebase/autentication.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../firebase/products_firebase.dart';
import '../models/firebase_user.dart';
import '../provider/theme_provider2.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final FirebaseUser _user = FirebaseUser();
  final Authentication _authentication = Authentication();
  ProdctsFirebase? _prodctsFirebase;

  @override
  void initState() {
    _user.user(_authentication.user);
    _prodctsFirebase = ProdctsFirebase();
    //init();
    super.initState();
  }

  //init() async {
  //   // listen for user to click on notification 
  //   FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
  //     String? title = remoteMessage.notification!.title;
  //     String? description = remoteMessage.notification!.body;

  //     //im gonna have an alertdialog when clicking from push notification
  //     print('AQUIIIII');
  //     Navigator.pushNamed(context, '/notification');
  //   });
  //   print('AQUIIIII 2');
  // }


  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: themeProvider.isLightTheme
          ? Color.fromARGB(255, 0, 150, 255)
          : Color.fromARGB(221, 112, 112, 112),
      ),
      drawer: Drawer(
        backgroundColor: themeProvider.isLightTheme
          ? Color.fromARGB(255, 0, 150, 255)
          : Color.fromARGB(255, 112, 112, 112),
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://static.vecteezy.com/system/resources/previews/006/571/605/original/illustration-of-beautiful-scenery-mountains-in-dark-blue-gradient-color-vector.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              currentAccountPicture: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
                child: Hero(
                  tag: 'imgProfile',
                  child: CircleAvatar(
                    backgroundImage: _user.imageUrl !=  null  ? NetworkImage(_user.imageUrl!) : NetworkImage('https://i.pinimg.com/736x/8b/16/7a/8b167af653c2399dd93b952a48740620.jpg')
                  )
                ),
              ),
              accountName: Text(_user.name != null ? _user.name! : "sin nombre", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              accountEmail: Text(_user.email!, style: TextStyle(color: Colors.white),),
            ),
            ListTile(
              trailing: Icon(Icons.chevron_right),
              title: Text('Subscriptions'),
              onTap: () {
                Navigator.pushNamed(context, '/selectSubs');
              },
            ),
            ListTile(
              trailing: Icon(Icons.chevron_right),
              title: Text('Cerrar Sesion'),
              onTap: () {
                _authentication.signOut();
                Navigator.pushNamed(context, '/');
              },
            )
          ],
        ),
      ),
      body: StreamBuilder(
        stream: _prodctsFirebase!.getAllProducts(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(color: themeProvider.isLightTheme
                        ? Colors.white
                        : Colors.black),
              padding: EdgeInsets.symmetric(
                vertical: 20
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var product = snapshot.data!.docs[index];
                      return Center(
                       child: FillImageCard(
                         width: 300,
                         heightImage: 150,
                         contentPadding: EdgeInsets.all(15),
                         color: themeProvider.isLightTheme
                        ? Color.fromARGB(26, 126, 120, 120)
                        : Color.fromARGB(221, 112, 112, 112),
                         borderRadius: 25,
                         imageProvider: NetworkImage(product.get('Image')),
                         //imageProvider: Image.file(File(product.get('Image'))).image ,
                         tags: [
                          _tag(
                            themeProvider.isLightTheme
                              ? Color.fromARGB(255, 0, 150, 255)
                              : Colors.black,
                            product.get('Category'),
                          ),
                          _tag(
                            themeProvider.isLightTheme
                              ? Color.fromARGB(255, 0, 150, 255)
                              : Colors.black,
                            product.get('Brand'),
                          )],
                          title: Text(
                            product.get('Name'),
                            style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              color: themeProvider.isLightTheme
                                ? Colors.black87
                                : Colors.white,
                            ),
                          ),
                         description: Text(
                            product.get('dscProduct'),
                            style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: themeProvider.isLightTheme
                                ? Colors.black87
                                : Colors.white,
                            ),
                          ),
                         footer: Row(
                          
                            children: [
                              Icon( Icons.attach_money_rounded, size: 30, color: Colors.lightGreenAccent[200]),
                              const SizedBox(width: 5),
                              Text(
                                product.get('Price').toString(),
                                style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  color: themeProvider.isLightTheme
                                    ? Colors.black87
                                    : Colors.white,
                                ),
                              ),
                              const SizedBox(width: 5,),
                              Icon( Icons.dashboard_rounded, size: 30, color: Colors.brown[800],),
                              const SizedBox(width: 5,),
                              Text(
                                product.get('exisProduct').toString(),
                                style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  color: themeProvider.isLightTheme
                                    ? Colors.black87
                                    : Colors.white,
                                ),
                              ),
                              const SizedBox(width: 30,),
                              IconButton(
                                iconSize: 30,
                                color: Colors.yellowAccent[400],
                                icon: Icon(Icons.edit_outlined),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/updateProduct', arguments: {
                                    'idProduct': product.id,
                                    'image' :product.get('Image').toString(),
                                    'name' : product.get('Name').toString(),
                                    'brand' : product.get('Brand').toString(),
                                    'category' : product.get('Category').toString(),
                                    'dscProduct' : product.get('dscProduct').toString(),
                                    'price' : product.get('Price').toString(),
                                    'exisProduct' : product.get('exisProduct').toString()
                                  });
                                },
                              ),
                              const SizedBox(width: 5),
                              IconButton(
                                iconSize: 30,
                                color: Colors.red[300],
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  QuickAlert.show(
                                   context: context,
                                   type: QuickAlertType.confirm,
                                   title: 'Are you sure?',
                                   text: 'Are you sure to delete the product?',
                                   confirmBtnText: 'Yes',
                                   cancelBtnText: 'No',
                                   confirmBtnColor: Colors.green,
                                   onConfirmBtnTap: () {
                                    _prodctsFirebase!.delProduct(product.id);
                                    Navigator.pop(context);
                                   },
                                  );
                                },
                              )

                            ],
                          )
                       )
                      );
              },
            );
          }else{
            if (snapshot.hasError) {
              return const Center(child: Text('Error'));
            }else{
              return const CircularProgressIndicator();
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        //backgroundColor: Colors.,
        onPressed: () {
          Navigator.pushNamed(context, '/addProduct');
        } ,
        child: Icon(Icons.add)
      )
    );
  }

  Widget _tag(Color color, String tag) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: color
          ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(
          tag,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

}