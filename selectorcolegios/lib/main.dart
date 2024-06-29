import 'package:flutter/material.dart';
import 'package:selectorcolegios/pages/pagina_principal.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Selector de Colegios',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PaginaPrincipal(),
    );
  }
}
