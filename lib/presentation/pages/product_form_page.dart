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
  late final TextEditingController _image;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _title = TextEditingController(text: p?.title ?? '');
    _price = TextEditingController(text: p?.price.toString() ?? '');
    _description = TextEditingController(text: p?.description ?? '');
    _category = TextEditingController(text: p?.category ?? '');
    _image = TextEditingController(text: p?.image ?? '');
  }

  @override
  void dispose() {
    _title.dispose();
    _price.dispose();
    _description.dispose();
    _category.dispose();
    _image.dispose();
    super.dispose();
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
      image: _image.text,
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
                validator: (v) => v!.isEmpty ? 'Campo obrigatorio' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _price,
                decoration: const InputDecoration(labelText: 'Preco'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Campo obrigatorio' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _description,
                decoration: const InputDecoration(labelText: 'Descricao'),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'Campo obrigatorio' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _category,
                decoration: const InputDecoration(labelText: 'Categoria'),
                validator: (v) => v!.isEmpty ? 'Campo obrigatorio' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _image,
                decoration: const InputDecoration(labelText: 'Imagem (URL)'),
                validator: (v) => v!.isEmpty ? 'Campo obrigatorio' : null,
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
