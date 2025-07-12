import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class Lista {
  String titulo;
  List<Item> itens;

  Lista(this.titulo) : itens = [];
}

class Item {
  String nome;
  bool concluido;

  Item(this.nome, {this.concluido = false});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ListaScreen(),
    );
  }
}

class ListaScreen extends StatefulWidget {
  @override
  _ListaScreenState createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  List<Lista> listas = [];

  void _criarLista() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Nova Lista", style: TextStyle(fontSize: 25, color: Colors.indigo, fontWeight: FontWeight.bold),
        ),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  listas.add(Lista(controller.text));
                });
              }
              Navigator.pop(context);
            },
            child: Text("Criar", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),),
          ),
        ],
      ),
    );
  }

  void _deletarLista(int index) {
    setState(() {
      listas.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        toolbarHeight: 70,
        title: Text('Minhas Listas', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold,
        ),
        ),
      ),
      body: ListView.builder(
        itemCount: listas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(listas[index].titulo, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red, size: 23),
              onPressed: () => _deletarLista(index),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ItensScreen(lista: listas[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _criarLista,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.playlist_add),
      ),
    );
  }
}

class ItensScreen extends StatefulWidget {
  final Lista lista;

  ItensScreen({required this.lista});

  @override
  _ItensScreenState createState() => _ItensScreenState();
}

class _ItensScreenState extends State<ItensScreen> {
  void _adicionarItem() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Novo Item"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  widget.lista.itens.add(Item(controller.text));
                });
              }
              Navigator.pop(context);
            },
            child: Text("Adicionar"),
          ),
        ],
      ),
    );
  }

  void _removerItem(int index) {
    setState(() {
      widget.lista.itens.removeAt(index);
    });
  }

  void _toggleItem(Item item) {
    setState(() {
      item.concluido = !item.concluido;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lista.titulo, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
      ),
      body: ListView.builder(
        itemCount: widget.lista.itens.length,
        itemBuilder: (context, index) {
          final item = widget.lista.itens[index];
          return ListTile(
            title: Text(
              item.nome,
              style: TextStyle(
                  decoration: item.concluido
                      ? TextDecoration.lineThrough
                      : TextDecoration.none),
            ),
            leading: Checkbox(
              value: item.concluido,
              onChanged: (_) => _toggleItem(item),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red, size: 20),
              onPressed: () => _removerItem(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarItem,
        child: Icon(Icons.add),
      ),
    );
  }
}
