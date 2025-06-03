import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  
  List<Product> _products = [];
  List<Product> get products => _products;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _error = '';
  String get error => _error;

  // Recherche actuelle
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  Future<void> fetchProducts() async {
    _setLoading(true);
    
    try {
      _products = await _productService.getProducts(search: _searchQuery);
      _error = '';
    } catch (e) {
      _error = 'Erreur lors du chargement des produits: ${e.toString()}';
    }
    
    _setLoading(false);
  }

  Future<void> searchProducts(String query) async {
    _searchQuery = query;
    await fetchProducts();
  }

  Future<bool> createProduct(Product product) async {
    _setLoading(true);
    
    try {
      final createdProduct = await _productService.createProduct(product);
      print('Product created with UUID: ${createdProduct.uuid}');
      await fetchProducts();
      _error = '';
      return true;
    } catch (e) {
      _error = 'Erreur lors de la création du produit: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProduct(Product product) async {
    _setLoading(true);
    
    try {
      await _productService.updateProduct(product);
      await fetchProducts();
      _error = '';
      return true;
    } catch (e) {
      _error = 'Erreur lors de la modification du produit: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteProduct(String uuid) async {
    _setLoading(true);
    
    try {
      print('Attempting to delete product with UUID: $uuid');
      
      
      if (uuid.isEmpty) {
        _error = 'Erreur: UUID du produit est vide';
        return false;
      }
      
      await _productService.deleteProduct(uuid);
      
      
      final countBefore = _products.length;
      _products.removeWhere((product) => product.uuid == uuid);
      final countAfter = _products.length;
      
      print('Removed product from local list: ${countBefore - countAfter} items removed');
      
      notifyListeners();
      _error = '';
      return true;
    } catch (e) {
      _error = 'Erreur lors de la suppression du produit: ${e.toString()}';
      print('Error in provider deleteProduct: $_error');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
