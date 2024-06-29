import 'package:flutter/material.dart';

class DrawerLateral extends StatelessWidget {
  final Function onMostrarListaColegios;

  DrawerLateral({
    required this.onMostrarListaColegios,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Opciones',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Mostrar lista de colegios seleccionados'),
            onTap: () {
              Navigator.pop(context);
              onMostrarListaColegios();
            },
          ),
        ],
      ),
    );
  }
}
