
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consulta de Medicamentos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MedicamentosScreen(),
    );
  }
}

class MedicamentosScreen extends StatefulWidget {
  @override
  _MedicamentosScreenState createState() => _MedicamentosScreenState();
}

class _MedicamentosScreenState extends State<MedicamentosScreen> {
  TextEditingController _controller = TextEditingController();
  String _result = '';

  Future<void> _consultarMedicamento(String nombreMedicamento) async {
    try {
      final response = await http.get(
          Uri.parse('https://www.datos.gov.co/resource/sdmr-tfmf.json'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        bool medicamentoEncontrado = false;
        for (var medicamento in data) {
          if (medicamento['nombre_comercial_'] == nombreMedicamento.toUpperCase()) {
            setState(() {
              _result = 'El medicamento está disponible.';
            });
            medicamentoEncontrado = true;
            break;
          }
        }
        if (!medicamentoEncontrado) {
          setState(() {
            _result = 'El medicamento no se encuentra en la base de datos.';
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        _result = 'Error al conectar con la API';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta de Medicamentos'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nombre del Medicamento',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                String nombreMedicamento = _controller.text.trim();
                if (nombreMedicamento.isNotEmpty) {
                  _consultarMedicamento(nombreMedicamento);
                } else {
                  setState(() {
                    _result = 'Por favor ingrese un nombre de medicamento.';
                  });
                }
              },
              child: Text('Consultar'),
            ),
            SizedBox(height: 20.0),
            Text(
              _result,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
