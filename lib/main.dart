import 'package:flutter/material.dart';
import 'package:nunes_sports/src/models/product_model.dart';
import 'package:nunes_sports/src/pages/home_page.dart';
import 'package:nunes_sports/src/pages/product_form_page.dart';
import 'package:nunes_sports/src/services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

    //final List<Product> products = generateFictionalProducts();

    return MaterialApp(
      title: "Nunes Sports",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<List<Product>>(
          future: ApiService().getProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Se ainda estiver carregando os produtos, pode exibir um indicador de carregamento
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Se ocorrer um erro, exiba uma mensagem de erro
              return Text('Error: ${snapshot.error}');
            } else {
              // Se tudo estiver certo, passe a lista de produtos para a HomePage
              return HomePage(products: snapshot.data!);
            }
          }),
      routes: {
        '/create': (context) => ProductFormPage(),
        '/edit': (context) {
          final ProductFormArguments args = ModalRoute.of(context)!
              .settings
              .arguments as ProductFormArguments;
          return ProductFormPage(initialProduct: args.product, isEditing: true);
        },
      },
    );
  }
}
