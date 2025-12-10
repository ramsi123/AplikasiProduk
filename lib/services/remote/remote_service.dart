import 'dart:convert';
import 'package:aplikasi_produk/models/product_detail.dart';
import 'package:aplikasi_produk/models/products.dart';
import 'package:http/http.dart' as http;

class RemoteService {
  Future<List<Products>> getProducts() async {
    List<Products> products = [];

    var response = await http.get(Uri.https('fakestoreapi.com', 'products'));
    var jsonData = jsonDecode(response.body);

    for (var eachProduct in jsonData) {
      products.add(Products.fromMap(eachProduct));
    }

    return products;
  }

  Future<ProductDetail> getProductDetail(int id) async {
    var response = await http.get(
      Uri.https('fakestoreapi.com', 'products/$id'),
    );
    var jsonData = jsonDecode(response.body);

    return ProductDetail.fromMap(jsonData);
  }
}
