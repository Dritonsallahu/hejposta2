import 'package:flutter/foundation.dart';
import 'package:hejposta/models/product_model.dart';

class ProductProvider extends ChangeNotifier{
    List<ProductModel> _products = [];
  final List<ProductModel> _productsFilter = [];

  var fetching = false;
  List<ProductModel> getProducts() => _products;

  addProducts(List<ProductModel> products) {
    _products.clear();
    _productsFilter.clear();
    _products.addAll(products);
    _productsFilter.addAll(products);
    notifyListeners();
  }

  addProduct(ProductModel product){
    _products.add(product);
    _productsFilter.add(product);
    notifyListeners();
  }

  updateProduct(ProductModel product){
   for(int i=0;i<_products.length;i++){
     if(_products[i].id == product.id){
       _products[i] = product;
     }
   }
   for(int i=0;i<_productsFilter.length;i++){
     if(_productsFilter[i].id == product.id){
       _productsFilter[i] = product;
     }
   }
    notifyListeners();
  }

  deleteProduct(ProductModel product){
  _products.remove(product);
  _productsFilter.remove(product);
    notifyListeners();
  }

  removeProduct(){
    _products.clear();
    _productsFilter.clear();
    notifyListeners();
  }

  isFetching() => fetching;

  startFetching(){
    fetching = true;
    notifyListeners();
  }
  stopFetching(){
    fetching = false;
    notifyListeners();
  }
  getCheckStatus(prId) => _products.firstWhere((element) => element.id == prId).checked;

  setCheck(prodId,status){
    for (var element in _products) {
      if(element.id == prodId){
        element.checked = status;
      }
      else{
        if(status){
          element.checked = false;
        }
      }
    }
    for (var element in _productsFilter) {
      if(element.id == prodId){
        element.checked = status;
      }
      else{
        if(status){
          element.checked = false;
        }
      }
    }
    notifyListeners();
  }
  filtro(emri) {
    _products = [];

    for (int i = 0; i < _productsFilter.length; i++) {
      if (_productsFilter[i]
          .productName!
          .toUpperCase()
          .contains(emri.toUpperCase())) {
        _products.add(_productsFilter[i]);
      }
    }
    notifyListeners();
  }

}