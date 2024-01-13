import 'package:flutter/material.dart';
import 'package:nunes_sports/src/models/product_model.dart';
import 'package:nunes_sports/src/services/api_service.dart';

class ProductFormPage extends StatefulWidget {
  final Product? initialProduct;
  final bool isEditing;

  ProductFormPage({Key? key, this.initialProduct, this.isEditing = false})
      : super(key: key);

  @override
  _ProductFormPageState createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  late TextEditingController nameController;
  late TextEditingController codeController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
        text: widget.isEditing ? widget.initialProduct?.name ?? '' : '');
    codeController = TextEditingController(
        text: widget.isEditing ? widget.initialProduct?.id ?? '' : '');
    descriptionController = TextEditingController(
        text: widget.isEditing ? widget.initialProduct?.description ?? '' : '');
    priceController = TextEditingController(
        text: widget.isEditing
            ? widget.initialProduct?.price?.toString() ?? ''
            : '');
  }

  Future<void> _createOrUpdateProduct() async {
    if (nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        priceController.text.isEmpty) {
      _showSnackBar('Impossível salvar, todos os campos são obrigatórios');
      return;
    }

    double? price;
    try {
      price = double.parse(priceController.text);
    } catch (e) {
      _showSnackBar('O campo de preço deve ser um valor numérico');
      return;
    }

    final newProduct = Product(
      name: nameController.text,
      description: descriptionController.text,
      price: double.tryParse(priceController.text) ?? 0.0,
    );

    try {
      if (widget.isEditing) {
        await apiService.updateProduct(widget.initialProduct!.id, newProduct);
      } else {
        await apiService.createProduct(newProduct);
      }
      Navigator.pop(context, true);
    } catch (error) {
      _showSnackBar('Erro ao criar/editar o produto');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Editar Produto' : 'Criar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nome do Produto'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Descrição do Produto'),
            ),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Preço do Produto'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _createOrUpdateProduct();
              },
              child: Text(widget.isEditing ? 'Salvar Edição' : 'Criar Produto'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
