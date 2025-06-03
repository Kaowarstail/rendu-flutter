import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  final String baseUrl = 'https://eemi-39b84a24258a.herokuapp.com/products';

  Future<List<Product>> getProducts({String? search}) async {
    final url = search != null && search.isNotEmpty
        ? '$baseUrl?search=$search'
        : baseUrl;
        
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body) as Map<String, dynamic>;
      
      final List<dynamic> productsJson = decodedData['rows'] as List<dynamic>;
      
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return Product.fromJson(responseData);
    } else {
      throw Exception('Failed to create product');
    }
  }

  Future<Product> updateProduct(Product product) async {
    if (product.uuid.isEmpty) {
      throw Exception('UUID cannot be empty for update');
    }
    
    final response = await http.put(
      Uri.parse('$baseUrl/${product.uuid}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return Product.fromJson(responseData);
    } else {
      throw Exception('Failed to update product: ${response.statusCode}');
    }
  }

  Future<void> deleteProduct(String uuid) async {
    if (uuid.isEmpty) {
      throw Exception('UUID cannot be empty for deletion');
    }
    
    final deleteUrl = '$baseUrl/$uuid';
    print('DELETE request to: $deleteUrl');
    
    try {
      final response = await http.delete(
        Uri.parse(deleteUrl),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('DELETE response status: ${response.statusCode}');
      print('DELETE response body: ${response.body}');

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Failed to delete product: Status ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting product: $e');
      rethrow;
    }
  }
}
