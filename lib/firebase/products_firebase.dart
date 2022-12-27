import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:practica7/models/products_model.dart';

class ProdctsFirebase {
  late FirebaseFirestore? _firestore;
  CollectionReference? _productsCollection;

  ProdctsFirebase(){
    _firestore = FirebaseFirestore.instance;
    _productsCollection = _firestore!.collection('products');
  }

  Future<void> insProduct (ProductModel objPlace){
    return _productsCollection!.add(objPlace.toMap());
  }

  Stream <QuerySnapshot> getAllProducts(){
    return _productsCollection!.snapshots();
  }

  Future<void> delProduct(String idProduct){
    return _productsCollection!.doc(idProduct).delete();
  }

  Future<void> updProduct(ProductModel objProduct, String idProduct){
    return _productsCollection!.doc(idProduct).update(objProduct.toMap());
  }

}