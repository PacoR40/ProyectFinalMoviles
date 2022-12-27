class ProductModel {
  String? Name;
  String? dscProduct;
  String? Brand;
  String? Category;
  String? Image;
  double? Price;
  double? exisProduct;

  ProductModel({this.Name, this.dscProduct, this.Brand, this.Category, this.Image, this.Price, this.exisProduct});

  Map<String, dynamic> toMap(){
    return {
      'Name' : this.Name,
      'dscProduct' : this.dscProduct,
      'Brand' : this.Brand,
      'Category' : this.Category,
      'Image' : this.Image,
      'Price' : this.Price,
      'exisProduct' : this.exisProduct,
    };
  }
}