import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class TextFormGlobal extends StatelessWidget {
  const TextFormGlobal({Key? key, required this.controller, required this.text, required this.textInputType, required this.obscure}) : super(key: key);

  final TextEditingController controller;
  final String text;
  final TextInputType textInputType;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.only( top: 3, left: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          )
        ] 
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: textInputType,
        obscureText: obscure,
        validator: (value) {
          if (value!.isEmpty) {
            return 'introduce the info';
          }
          return null;
        },
        style: GoogleFonts.raleway(
          fontStyle: FontStyle.normal,
        ),
        decoration: InputDecoration(
          hintText: text,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(0),
          hintStyle:  TextStyle(
            height: 1,
          )
        )
      ),
    );
  }
}