import 'package:flutter/material.dart';
import 'package:selectorcolegios/custom_colors.dart';

class ListaOrdenada extends StatefulWidget {
  final List<Map<String, dynamic>> colegios;
  final Function(List<Map<String, dynamic>>) onListReorder;
  final Function onExportCSV;

  ListaOrdenada({
    required this.colegios,
    required this.onListReorder,
    required this.onExportCSV,
  });

  @override
  _ListaOrdenadaState createState() => _ListaOrdenadaState();
}

class _ListaOrdenadaState extends State<ListaOrdenada> {
  Color getColorForIndex(int index) {
    final colors = [
      CustomColors.pastelRed,
      CustomColors.pastelGreen,
      CustomColors.pastelBlue,
      CustomColors.pastelYellow,
      CustomColors.pastelPurple,
      CustomColors.pastelOrange,
      CustomColors.pastelPink,
      CustomColors.pastelTeal,
      CustomColors.pastelIndigo,
      CustomColors.pastelBrown,
    ];
    return colors[index ~/ 10 % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final item = widget.colegios.removeAt(oldIndex);
                widget.colegios.insert(newIndex, item);
                widget.onListReorder(widget.colegios);
              });
            },
            children: widget.colegios.map((colegio) {
              final index = widget.colegios.indexOf(colegio);
              return Card(
                key: ValueKey(colegio['nombre']),
                color: getColorForIndex(index),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    '${colegio['nombre']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            onPressed: () {
              widget.onExportCSV();
            },
            icon: Icon(Icons.file_download),
            label: Text('Exportar datos a CSV'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            ),
          ),
        ),
      ],
    );
  }
}
