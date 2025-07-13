import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../main.dart';

class ListaScreen extends StatefulWidget {
  @override
  _ListaScreenState createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  List<Lista> listas = [];

  void _criarLista() {
    TextEditingController controller = TextEditingController();
    String? erro;

    showDialog(
      context: context,
      builder: (_) =>
          StatefulBuilder(
            builder: (context, setStateModal) {
              return AlertDialog(
                title: const Text(
                  "Nova Lista",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    errorText: erro,
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text(
                      "Criar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    onPressed: () {
                      final texto = controller.text.trim();
                      if (texto.isEmpty) {
                        setStateModal(() =>
                        erro = 'Digite um nome para a lista');
                        return;
                      }
                      setState(() => listas.add(Lista(texto)));
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
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
        title: Text('Listas', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold,
        ),
        ),
      ),
      body: ListView.builder(
        itemCount: listas.length,
        itemBuilder: (context, index) {
          final lista = listas[index];

          return Slidable(
            key: ValueKey(lista.titulo),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              dismissible: DismissiblePane(
                onDismissed: () => _deletarLista(index),
              ),
              children: [
                SlidableAction(
                  onPressed: (_) => _deletarLista(index),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Apagar',
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                lista.titulo,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ItensScreen(lista: lista),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _criarLista,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
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
        title: Text("Novo Item", style: TextStyle(fontSize: 25, color: Colors.indigo, fontWeight: FontWeight.bold),
        ),
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
            child: Text("Adicionar", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
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
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
