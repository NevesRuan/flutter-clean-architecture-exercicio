import 'package:flutter/foundation.dart';
import '../../domain/repositories/product_repository.dart';
import 'product state.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductRepository repository;

  ProductState _state = const ProductState();
  ProductState get state => _state;

  ProductViewModel(this.repository);

  Future<void> loadProducts() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();
    try {
      final products = await repository.getProducts();
      _state = _state.copyWith(isLoading: false, products: products);
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
    }
    notifyListeners();
  }

  void toggleFavorite(int index) {
    _state.products[index].favorite = !_state.products[index].favorite;
    notifyListeners();
  }
}
