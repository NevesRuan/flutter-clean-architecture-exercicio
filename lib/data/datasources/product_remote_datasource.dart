import 'package:dio/dio.dart';
import '../models/product_model.dart';

class ProductRemoteDatasource {
  static const _baseUrl = 'https://dummyjson.com/products';

  final Dio client;

  ProductRemoteDatasource(this.client);

  Future<List<ProductModel>> getProducts() async {
    final response = await client.get(_baseUrl);
    final data = response.data as Map<String, dynamic>;
    final List products = data['products'] as List? ?? [];
    return products
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<ProductModel> getProductById(int id) async {
    final response = await client.get('$_baseUrl/$id');
    return ProductModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<ProductModel> addProduct(ProductModel product) async {
    final response = await client.post(
      '$_baseUrl/add',
      data: product.toJson(),
    );
    return ProductModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await client.put(
      '$_baseUrl/${product.id}',
      data: product.toJson(),
    );
    return ProductModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteProduct(int id) async {
    await client.delete('$_baseUrl/$id');
  }
}
