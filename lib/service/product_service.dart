import 'dart:convert';

import 'package:api_test/model/product.dart';
import 'package:http/http.dart' as http;

//https://app.quicktype.io/?l=dart

class ProductService {
  Future<Product?> getProducts() async {
    var url = Uri.parse('https://reqres.in/api/products');
    var response = await http.get(url);
    var products = Product.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      return products;
    }
    return null;
  }
}