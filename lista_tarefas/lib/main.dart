import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _toDoList = [];
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  final _todoController = TextEditingController();

  @override
  void initState() {
    super.initState(); // chamados o initState da super classe State
    _readData().then((data) {
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  // adiciona task na lista
  void _addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo['title'] = _todoController.text;
      _todoController.text = '';
      newToDo['ok'] = false;
      _toDoList.add(newToDo);
      _saveData();
    });
  }

  // ordena a lista das task depois do refresh
  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {  
      _toDoList.sort((a, b) {
        if(a['ok'] && !b['ok']) return 1;
        else if(!a['ok'] && b['ok']) return -1;
        else return 0;
      });

      _saveData();
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
        backgroundColor: Colors.blueAccent[700],
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                  controller: _todoController,
                  decoration: InputDecoration(
                    labelText: 'Nova Tarefa',
                    labelStyle: TextStyle(color: Colors.blueAccent[700]),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent[700]),
                      ),
                    ),
                  ),
                ),
                RaisedButton(
                  color: Colors.blueAccent[700],
                  child: Text('Add'),
                  textColor: Colors.white,
                  onPressed: _addToDo,
                )
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder( // é uma lista que vai sendo preenchida de acordo com que vai aparecendo e os itens que não aparecem não consomem memória
                padding: EdgeInsets.only(top: 10.0),
                itemCount: _toDoList.length,
                itemBuilder: buildItem,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Método que retorna os items da lista
  Widget buildItem(context, index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white,
          ), 
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        onChanged: (checked) {
          setState(() {
            _toDoList[index]['ok'] = checked;
            _saveData();
          });
        },
        title: Text(_toDoList[index]['title']),
        value: _toDoList[index]['ok'],
        secondary: CircleAvatar(
          child: Icon(_toDoList[index]['ok'] ? Icons.check : Icons.error),
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_toDoList[index]); // cria uma cópia do item de acordo com o index
          _lastRemovedPos = index; // index do item
          _toDoList.removeAt(index); // remove da lista pelo index

          _saveData();

          // cria uma snackbar com uma mensagem de removido e uma ação de 'Desfazer'
          final snack = SnackBar(
            content: Text('Tarefa \"${_lastRemoved['title']}\" removida!'),
            action: SnackBarAction(
              label: 'Desfazer', 
              onPressed: (){
                setState(() {
                  _toDoList.insert(_lastRemovedPos, _lastRemoved);
                  _saveData();
                });
              },
            ),
            duration: Duration(seconds: 2),
          );

          Scaffold.of(context).removeCurrentSnackBar(); // remove a snackbar atual
          Scaffold.of(context).showSnackBar(snack); // mosta a snackbar criada
        });
      },
    );
  }

  // Método assincrono que retorna um arquivo data.json
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory(); // local onde se pode armazenar os documentos com o path_provider
    
    return File('${directory.path}/data.json'); //caminho do diretorio onde contem o data.json e o mesmo é aberto com o File();
  }

  // Método assincrono que salva as informações da toDoList no arquivo json
  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    
    return file.writeAsString(data); // escrever no arquivo a lista de tasks
  }

  // Método assincrono que lé as informações contidas no arquivo
  Future<String> _readData() async {
    try{
      final file = await _getFile();
      return file.readAsString();
    }catch(e) {
      return null;
    }
  }
}
