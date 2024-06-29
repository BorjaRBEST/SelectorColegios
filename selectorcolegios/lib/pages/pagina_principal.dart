import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:selectorcolegios/widget/drawer_latearl.dart';
import 'package:selectorcolegios/widget/iconos_personalizados.dart';
import 'package:selectorcolegios/widget/lista_ordenada.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PaginaPrincipal extends StatefulWidget {
  @override
  _PaginaPrincipalState createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  List<Map<String, dynamic>> colegios = [];
  List<Map<String, dynamic>> todosLosCentros = [];
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  final String apiKey = 'Aquí va mi API Key de Google Maps';

  @override
  void initState() {
    super.initState();
    loadColegios();
  }

  Future<void> loadColegios() async {
    final String response =
        await rootBundle.loadString('assets/data/colegios.json');
    final data = await json.decode(response);
    setState(() {
      todosLosCentros = List<Map<String, dynamic>>.from(data['colegios']);
    });
  }

  Future<void> loadMarkers() async {
    Set<Marker> loadedMarkers = {};

    for (int i = 0; i < colegios.length; i++) {
      var colegio = colegios[i];
      final coordinates = await getCoordinatesFromName(colegio['nombre']);
      if (coordinates != null) {
        final customIcon = await IconosPersonalizados.getCustomMarker(i);

        loadedMarkers.add(Marker(
          markerId: MarkerId(colegio['nombre']),
          position: coordinates,
          icon: customIcon,
          infoWindow: InfoWindow(
            title: '${i + 1}: ${colegio['nombre']}',
          ),
        ));
      }
    }

    setState(() {
      markers = loadedMarkers;
    });
  }

  Future<void> loadGoogleMarkers() async {
    Set<Marker> loadedMarkers = {};

    for (int i = 0; i < colegios.length; i++) {
      var colegio = colegios[i];
      final coordinates = await getCoordinatesFromName(colegio['nombre']);
      if (coordinates != null) {
        loadedMarkers.add(Marker(
          markerId: MarkerId(colegio['nombre']),
          position: coordinates,
          infoWindow: InfoWindow(
            title: '${i + 1}: ${colegio['nombre']}',
          ),
        ));
      }
    }

    setState(() {
      markers = loadedMarkers;
    });
  }

  Future<LatLng?> getCoordinatesFromName(String name) async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(name)}&key=$apiKey'));
    if (response.statusCode == 200) {
      final data = await json.decode(response.body);
      if (data['status'] == 'OK') {
        final location = data['results'][0]['geometry']['location'];
        return LatLng(location['lat'], location['lng']);
      }
    }
    return null;
  }

  void updateMarkers(List<Map<String, dynamic>> updatedColegios) {
    setState(() {
      colegios = updatedColegios;
      loadMarkers();
    });
  }

  void mostrarListaColegios() {
    setState(() {
      colegios = todosLosCentros;
      loadMarkers();
    });
  }

  Future<void> exportToCSV() async {
    String csvData = 'Nombre,Latitud,Longitud\n';
    for (var colegio in colegios) {
      csvData +=
          '${colegio['nombre']},${colegio['coordenadas'][0]},${colegio['coordenadas'][1]}\n';
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/colegios.csv';
      final file = File(path);
      await file.writeAsString(csvData);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('CSV Exportado'),
            content: Text('CSV guardado en: $path'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar el CSV: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa de Colegios'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: DrawerLateral(
        onMostrarListaColegios: mostrarListaColegios,
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(37.379191, -5.950732),
                zoom: 12,
              ),
              markers: markers,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
          ),
          colegios.isNotEmpty
              ? Expanded(
                  flex: 1,
                  child: ListaOrdenada(
                    colegios: colegios,
                    onListReorder: updateMarkers,
                    onExportCSV: exportToCSV,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
