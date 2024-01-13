import 'package:flutter/material.dart';
import 'package:nunes_sports/src/models/product_model.dart';
import 'package:nunes_sports/src/services/api_service.dart';

class HomePage extends StatefulWidget {
  final ApiService apiService = ApiService();
  final List<Product> products;

  HomePage({Key? key, required this.products}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nunes Sports - Produtos'),
      ),
      body: ListView.builder(
        itemCount: widget.products.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(16.0),
            elevation: 4.0,
            child: ListTile(
              title: Row(
                children: [
                  Icon(Icons.label, color: Colors.blue),
                  SizedBox(width: 8.0),
                  Text(widget.products[index].name),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.turned_in_rounded, color: Colors.blue),
                      SizedBox(width: 4.0),
                      Text('ID: ${widget.products[index].id}'),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset('lib/src/assets/real_icon.png'),
                      SizedBox(width: 4.0),
                      Text(widget.products[index].price.toString()),
                    ],
                  ),
                  Text(widget.products[index].description),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        '/edit',
                        arguments: ProductFormArguments(
                          product: widget.products[index],
                        ),
                      );

                      if (result == true) {
                        _loadProducts();
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _showDeleteConfirmationDialog(widget.products[index]);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            '/create',
          );
          if (result == true) {
            _loadProducts();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _loadProducts() async {
    final products = await widget.apiService.getProducts();
    setState(() {
      widget.products.clear();
      widget.products.addAll(products);
    });
  }

  void _showDeleteConfirmationDialog(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar exclusão'),
          content: Text('Você tem certeza que deseja excluir este produto?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await widget.apiService.deleteProduct(product.id);

                setState(() {
                  widget.products.remove(product);
                });

                Navigator.of(context).pop();
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }
}

class ProductFormArguments {
  final Product product;

  ProductFormArguments({required this.product});
}
