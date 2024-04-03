import 'package:flutter/material.dart';

void main() => runApp(const Pills());

class Pills extends StatelessWidget {
  const Pills({super.key});

  Widget _list() {
    return Expanded(
        child: ListView.separated(
      itemCount: 5,
      itemBuilder: (BuildContext context, index) =>
          _item("Acetaminofen", "1:00 pm"),
      separatorBuilder: (context, index) {
        return Container(
          color: Colors.grey[300],
          height: 2.0,
        );
      },
    ));
  }

  Widget _item(String name, String hours) {
    return ListTile(
        leading: TextButton(
            onPressed: () {},
            child: Text(
              name,
              style: const TextStyle(fontSize: 16),
            )),
        trailing: Text(hours, style: const TextStyle(fontSize: 14)));
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
                  "Próximos medicamentos",
                  style: TextStyle(fontSize: 18),
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
            backgroundColor: const Color(0xFF019C71),
            title: const Text(
              'Medicamentos',
              style: TextStyle(fontSize: 20),
            )),
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
