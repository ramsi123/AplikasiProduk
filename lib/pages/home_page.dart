import 'package:aplikasi_produk/models/products.dart';
import 'package:aplikasi_produk/pages/detail_product_page.dart';
import 'package:aplikasi_produk/pages/login_page.dart';
import 'package:aplikasi_produk/services/remote/remote_service.dart';
import 'package:aplikasi_produk/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => HomePage());
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // remote service
  final RemoteService _remoteService = RemoteService();

  // variables
  List<Products> allProducts = [];
  List<Products> filteredProducts = [];
  String selectedCategory = 'all';
  late Future<void> _productsFuture;

  // get products
  Future<void> getProducts() async {
    allProducts = await _remoteService.getProducts();
    filteredProducts = [...allProducts]; // default: show all
  }

  // filter products
  void filterProducts(String category) {
    setState(() {
      selectedCategory = category;

      if (category == 'all') {
        filteredProducts = [...allProducts];
      } else {
        filteredProducts = allProducts
            .where((p) => p.category.toLowerCase() == category.toLowerCase())
            .toList();
      }
    });
  }

  // logout
  void logout() async {
    // save to shared preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    if (!mounted) return;

    // show snackbar
    showSnackbar(context, 'Logout berhasil');

    // navigate to login page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    _productsFuture = getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list),
            onSelected: filterProducts,
            itemBuilder: (context) => [
              PopupMenuItem(value: 'all', child: Text('All')),
              PopupMenuItem(value: 'electronics', child: Text('Electronics')),
              PopupMenuItem(value: 'jewelery', child: Text('Jewelery')),
              PopupMenuItem(
                value: "men's clothing",
                child: Text("Men's Clothing"),
              ),
              PopupMenuItem(
                value: "women's clothing",
                child: Text("Women's Clothing"),
              ),
            ],
          ),
          IconButton(onPressed: logout, icon: Icon(Icons.exit_to_app_outlined)),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _productsFuture,
          builder: (context, snapshot) {
            // loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            // error
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            // no data
            if (filteredProducts.isEmpty) {
              return Center(child: Text('No products found'));
            }

            // success
            return buildProductList();
          },
        ),
      ),
    );
  }

  Widget buildProductList() {
    return ListView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final item = filteredProducts[index];

        return ListTile(
          onTap: () {
            Navigator.push(context, DetailProductPage.route(item.id));
          },
          leading: Image.network(
            item.image,
            width: 50,
            height: 50,
            fit: BoxFit.fill,
          ),
          title: Text(item.title),
          subtitle: Text('\$${item.price}'),
        );
      },
    );
  }
}
