import 'package:flutter/material.dart';

void main() => runApp(const Food());

class Food extends StatelessWidget {
  const Food({super.key});

  Widget _list() {
    return Expanded(
        child: ListView.separated(
      itemCount: 10,
      itemBuilder: (BuildContext context, index) =>
          _item("Desayuno", "9:00 am", "Chocolate pan y huevos"),
      separatorBuilder: (context, index) {
        return Container(
          color: Colors.grey[300],
          height: 2.0,
        );
      },
    ));
  }

  Widget _item(String name, String hours, String description) {
    return ListTile(
        title: Text(name),
        subtitle: Text(
          description,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
        trailing: Text(hours, style: const TextStyle(fontSize: 14)));
  }

  Widget _alergias() {
    return Expanded(
        child: ListView.separated(
      itemCount: 10,
      itemBuilder: (BuildContext context, index) => _itemAlergias("Maní",
          "Llama al 911 o al número local de emergencias si tú o alguien más presentan mareos intensos, mucha dificultad para respirar o pérdida del conocimiento."),
      separatorBuilder: (context, index) {
        return Container(
          color: Colors.grey[300],
          height: 2.0,
        );
      },
    ));
  }

  Widget _itemAlergias(String name, String description) {
    return ListTile(
        title: Text(name),
        subtitle: Text(
          description,
          style: const TextStyle(
            fontSize: 14,
          ),
        ));
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
                  "¿Qué ha comido hoy?",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            _list(),
            const SizedBox(
              height: 25,
            ),
            Align(
              alignment:
                  Alignment.centerLeft, // Alinea el widget a la izquierda
              child: Title(
                color: Colors.black,
                child: const Text(
                  "Alergías",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            _alergias(),
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
            backgroundColor: const Color(0xFF019C71),
            title: const Text('Alimentos', style: TextStyle(fontSize: 20))),
        body: _body(),
        bottomNavigationBar: BottomAppBar(
          color: const Color(0xFF019C71),
          height: 75,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/');
                },
                child: const Text(
                  "Atrás",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
