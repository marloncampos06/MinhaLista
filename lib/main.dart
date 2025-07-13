import 'package:flutter/material.dart';
import 'package:listdynamic/lista/lista_Screen.dart';

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
      debugShowCheckedModeBanner: false,
      title: 'Lista de Tarefas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ListaScreen(),
    );
  }
}