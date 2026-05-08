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
        thumbnail: p.thumbnail,
        description: p.description,
        category: p.category,
        rating: p.rating,
        stock: p.stock,
      );

  Product _toEntity(ProductModel m) => Product(
        id: m.id,
        title: m.title,
        price: m.price,
        thumbnail: m.thumbnail,
        description: m.description,
        category: m.category,
        rating: m.rating,
        stock: m.stock,
      );

  @override
  Future<List<Product>> getProducts() async {
    try {
      final models = await remote.getProducts();
      cache.save(models);
      return models.map(_toEntity).toList();
    } catch (e) {
      final cached = cache.get();
      if (cached != null) {
        return cached.map(_toEntity).toList();
      }
      throw Failure('Não foi possível carregar os produtos');
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    try {
      final model = await remote.getProductById(id);
      return _toEntity(model);
    } catch (e) {
      throw Failure('Não foi possível carregar o produto');
    }
  }

  @override
  Future<void> addProduct(Product product) async {
    try {
      await remote.addProduct(_toModel(product));
    } catch (e) {
      throw Failure('Não foi possível adicionar o produto');
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    try {
      await remote.updateProduct(_toModel(product));
    } catch (e) {
      throw Failure('Não foi possível atualizar o produto');
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    try {
      await remote.deleteProduct(id);
    } catch (e) {
      throw Failure('Não foi possível remover o produto');
    }
  }
}
