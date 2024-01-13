import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nunes_sports/src/models/product_model.dart';

class ApiService {
  final String baseUrl = 'https://65a2059842ecd7d7f0a70ff8.mockapi.io/';

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Product.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> createProduct(Product newProduct) async {
    print("entrou");
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newProduct.toJson()),
    );
    print(response.statusCode);
    if (response.statusCode == 201) {
      // Produto criado com sucesso, retorna o produto criado
      return Product.fromJson(jsonDecode(response.body));
    } else {
      // Falha ao criar o produto, lança uma exceção
      throw Exception('Failed to create product');
    }
  }

  Future<Product> updateProduct(String id, Product updatedProduct) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/${id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedProduct.toJson()),
    );

    if (response.statusCode == 200) {
      // Produto atualizado com sucesso, retorna o produto atualizado
      return Product.fromJson(jsonDecode(response.body));
    } else {
      // Falha ao atualizar o produto, lança uma exceção
      throw Exception('Failed to update product');
    }
  }

  Future<void> deleteProduct(String productId) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/products/$productId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }
}
