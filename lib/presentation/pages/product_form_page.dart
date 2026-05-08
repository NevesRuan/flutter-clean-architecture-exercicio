import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';
import '../viewmodels/product_viewmodel.dart';

class ProductFormPage extends StatefulWidget {
  final Product? product;
  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _price;
  late final TextEditingController _description;
  late final TextEditingController _category;
  late final TextEditingController _thumbnail;
  late final TextEditingController _rating;
  late final TextEditingController _stock;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _title = TextEditingController(text: p?.title ?? '');
    _price = TextEditingController(text: p?.price.toString() ?? '');
    _description = TextEditingController(text: p?.description ?? '');
    _category = TextEditingController(text: p?.category ?? '');
    _thumbnail = TextEditingController(text: p?.thumbnail ?? '');
    _rating = TextEditingController(text: p?.rating.toString() ?? '0');
    _stock = TextEditingController(text: p?.stock.toString() ?? '0');
  }

  @override
  void dispose() {
    _title.dispose();
    _price.dispose();
    _description.dispose();
    _category.dispose();
    _thumbnail.dispose();
    _rating.dispose();
    _stock.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? v) =>
      (v == null || v.isEmpty) ? 'Campo obrigatorio' : null;

  String? _doubleValidator(String? v) {
    if (v == null || v.isEmpty) return 'Campo obrigatorio';
    if (double.tryParse(v) == null) return 'Valor numérico inválido';
    return null;
  }

  String? _intValidator(String? v) {
    if (v == null || v.isEmpty) return 'Campo obrigatorio';
    if (int.tryParse(v) == null) return 'Valor inteiro inválido';
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final vm = context.read<ProductViewModel>();
    final product = Product(
      id: widget.product?.id ?? 0,
      title: _title.text,
      price: double.parse(_price.text),
      description: _description.text,
      category: _category.text,
      thumbnail: _thumbnail.text,
      rating: double.parse(_rating.text),
      stock: int.parse(_stock.text),
    );
    if (widget.product == null) {
      await vm.addProduct(product);
    } else {
      await vm.updateProduct(product);
    }
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Produto' : 'Novo Produto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'Titulo'),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _price,
                decoration: const InputDecoration(labelText: 'Preco'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: _doubleValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _description,
                decoration: const InputDecoration(labelText: 'Descricao'),
                maxLines: 3,
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _category,
                decoration: const InputDecoration(labelText: 'Categoria'),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _thumbnail,
                decoration: const InputDecoration(labelText: 'Thumbnail (URL)'),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _rating,
                decoration: const InputDecoration(labelText: 'Rating (0-5)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: _doubleValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _stock,
                decoration: const InputDecoration(labelText: 'Estoque'),
                keyboardType: TextInputType.number,
                validator: _intValidator,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
