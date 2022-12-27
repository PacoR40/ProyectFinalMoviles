
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practica7/models/products_model.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../firebase/products_firebase.dart';
import '../provider/theme_provider2.dart';
import '../widgets/textForm.dart';

class updateProductScreen extends StatefulWidget {
  const updateProductScreen({Key? key}) : super(key: key);

  @override
  State<updateProductScreen> createState() => _updateProductScreenState();
}

class _updateProductScreenState extends State<updateProductScreen> {

  File? sampleImage;
  String? urlImage;
  String? imagePath;

  final _claveFormulario = GlobalKey<FormState>();
  ProdctsFirebase? _prodctsFirebase;
  ProductModel? _productModel;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController dscProductController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController exisProductController = TextEditingController();

  String idProduct = "";

  @override
  void initState() {
    super.initState();
    _prodctsFirebase = ProdctsFirebase();
  }

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);

    if (ModalRoute.of(context)!.settings.arguments != null) {
      final product = ModalRoute.of(context)?.settings.arguments as Map;
      urlImage = product['image'];
      //imagePath = product['image'];
      nameController.text = product['name'];
      brandController.text = product['brand'];
      categoryController.text = product['category'];
      dscProductController.text = product['dscProduct'];
      priceController.text = product['price'];
      exisProductController.text = product['exisProduct'];
      idProduct = product['idProduct'];
    }

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
                  'Update Product',
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
              sampleImage == null ?
              Center(
                child: CircleAvatar(
                  radius: 110,
                  backgroundImage: NetworkImage(urlImage!),
                ),
              ):
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Image.file(
                    File(imagePath!),
                    fit: BoxFit.cover,
                    height: 220,
                    width: 220,
                    )
                ),
              ),
              Center(
                child: IconButton(
                  icon: Icon(Icons.add_a_photo),
                  iconSize: 40,
                  color: Color.fromARGB(255, 0, 150, 255),
                  onPressed: () async {
                    final ImagePicker _picker = ImagePicker();
                    XFile? _pickerFile = await _picker.pickImage(source: ImageSource.camera);
                    imagePath = _pickerFile?.path;
                    sampleImage = File(imagePath!);
                    setState(() {});
                  },
                ),
              ),

              Form(
                key: _claveFormulario,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    TextFormGlobal(controller: nameController, text: "Product name", textInputType: TextInputType.text, obscure: false,),
                    const SizedBox( height: 15 ),
                    TextFormGlobal(controller: dscProductController, text: "Description", textInputType: TextInputType.text, obscure: false,),
                    const SizedBox( height: 15 ),
                    TextFormGlobal(controller: brandController, text: "Company", textInputType: TextInputType.text, obscure: false,),
                    const SizedBox( height: 15 ),
                    TextFormGlobal(controller: categoryController, text: "Category", textInputType: TextInputType.text, obscure: false,),
                    const SizedBox( height: 15 ),
                    TextFormGlobal(controller: priceController, text: "Price", textInputType: TextInputType.number, obscure: false,),
                    const SizedBox( height: 15 ),
                    TextFormGlobal(controller: exisProductController, text: "Existence", textInputType: TextInputType.number, obscure: false,),
                  ],
              )),

              const SizedBox( height: 20 ),

              InkWell(
                onTap: () async {
                  if ( !_claveFormulario.currentState!.validate()) {
                    return;
                  }
                  if (sampleImage != null) {
                    
                  
                    FirebaseStorage storage = FirebaseStorage.instance;
                    // Reference ref2 = storage.refFromURL(urlImage!);
                    // await ref2.delete();


                    Reference ref = storage.ref().child(DateTime.now().toString()+".jpg");
                    UploadTask uploadTask = ref.putFile(sampleImage!);
                    await uploadTask.whenComplete(() async {
                      urlImage = await uploadTask.snapshot.ref.getDownloadURL();
                    });

                    
                  }
                  _productModel = ProductModel(
                    Image: urlImage,
                    Name: nameController.text,
                    dscProduct: dscProductController.text,
                    Brand: brandController.text,
                    Category: categoryController.text,
                    Price: double.parse(priceController.text),
                    exisProduct: double.parse(priceController.text),
                  );
                  _prodctsFirebase?.updProduct(_productModel!, idProduct);
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
                    'Update',
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