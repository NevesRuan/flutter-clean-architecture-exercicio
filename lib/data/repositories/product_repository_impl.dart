import '../datasources/product_remote_datasource.dart';
import '../datasources/product_cache_datasource.dart';
import '../models/product_model.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../core/errors/failure.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remote;
  final ProductCacheDatasource cache;

  ProductRepositoryImpl(this.remote, this.cache);

  ProductModel _toModel(Product p) => ProductModel(
        id: p.id,
        title: p.title,
        price: p.price,
        image: p.image,
        description: p.description,
        category: p.category,
      );

  @override
  Future<List<Product>> getProducts() async {
    try {
      final models = await remote.getProducts();
      cache.save(models);
      return models
          .map((m) => Product(
                id: m.id,
                title: m.title,
                price: m.price,
                image: m.image,
                description: m.description,
                category: m.category,
              ))
          .toList();
    } catch (e) {
      final cached = cache.get();
      if (cached != null) {
        return cached
            .map((m) => Product(
                  id: m.id,
                  title: m.title,
                  price: m.price,
                  image: m.image,
                  description: m.description,
                  category: m.category,
                ))
            .toList();
      }
      throw Failure("Não foi possível carregar os produtos");
    }
  }

  @override
  Future<void> addProduct(Product product) async {
    try {
      await remote.addProduct(_toModel(product));
    } catch (e) {
      throw Failure("Não foi possível adicionar o produto");
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    try {
      await remote.updateProduct(_toModel(product));
    } catch (e) {
      throw Failure("Não foi possível atualizar o produto");
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    try {
      await remote.deleteProduct(id);
    } catch (e) {
      throw Failure("Não foi possível remover o produto");
    }
  }
}
