import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(const Pills());

class Pills extends StatelessWidget {
  const Pills({super.key});

  Widget _list() {
    return Expanded(
        child: ListView.separated(
      itemCount: 5,
      itemBuilder: (BuildContext context, index) => _item("Acetaminofen"),
      separatorBuilder: (context, index) {
        return Container(
          color: Colors.grey[300],
          height: 2.0,
        );
      },
    ));
  }

  Widget _item(String name) {
    return ListTile(leading: TextButton(onPressed: () {}, child: Text(name)));
  }

  Widget _body() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Alinea los elementos a la izquierda
          children: [
            Align(
              alignment:
                  Alignment.centerLeft, // Alinea el widget a la izquierda
              child: Title(
                color: Colors.black,
                child: const Text(
                  "Medicamentos Obligatorios",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            _list(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Medicamentos'),
        ),
        body: _body(),
      ),
    );
  }
}
