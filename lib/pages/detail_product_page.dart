import 'package:aplikasi_produk/models/product_detail.dart';
import 'package:aplikasi_produk/services/remote/remote_service.dart';
import 'package:flutter/material.dart';

class DetailProductPage extends StatefulWidget {
  static route(int id) =>
      MaterialPageRoute(builder: (context) => DetailProductPage(id: id));

  final int id;
  const DetailProductPage({super.key, required this.id});

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  // remote service
  final RemoteService _remoteService = RemoteService();

  // variables
  late Future<ProductDetail> futureProduct;

  @override
  void initState() {
    super.initState();

    // get product detail
    futureProduct = _remoteService.getProductDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail'), centerTitle: true),
      body: SafeArea(
        child: FutureBuilder(
          future: futureProduct,
          builder: (context, snapshot) {
            // loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
        
            // error
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
        
            final product = snapshot.data!;
        
            // success
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product.image,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
        
                  const SizedBox(height: 20),
        
                  // Title
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
        
                  const SizedBox(height: 5),
        
                  // Price
                  Text(
                    "\$${product.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
        
                  const SizedBox(height: 10),
        
                  // Category
                  Row(
                    children: [
                      const Icon(Icons.category_outlined, size: 18),
                      const SizedBox(width: 5),
                      Text(
                        product.category,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
        
                  const SizedBox(height: 20),
        
                  // Description
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 16, height: 1.4),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
