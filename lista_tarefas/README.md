# Lista de Tarefas

![Conversor de Moedas com Flutter](https://github.com/aandrepf/flutter-projects/blob/master/assets/lista_task.png)

Se trata de um aplicativo em que podemos adicionar lista de tarefas onde podemos definir as tarefas que estam finalizadas e ordenar as mesmas entre não prontas e prontas, além de poder exluir as tarefas arrastando a mesma da esquerda pra direita e desfazer a exclusão caso tenha feito por engano. Também armazena as tarefas permanentemente mesmo fechando o app.

Um app que conta com recursos de armazenamento de JSON, ListView, SnackBar, Dismissable, ListTile, CircleAvatar, CheckBoxListTile, Desfazer, Refresh Indicator, Sort itens e etc.

Dependencia para adicionar no **pubspec.yaml** do app: path_provider: ^1.1.0;

O path_provider é um plugin usado para encontrar locais usados no sistema de arquivos e tem suporte para Android e iOS.

## Lendo e Escrevendo Dados

Como trabalharemos com uma lista de tasks os dados serão armazenados em um Array de objetos.

```js
[
  {
    "title": "Aprender Flutter",
    "ok": true
  },
  {
    "title": "Aprender Dart",
    "ok": false
  }
]
```

Com o path_provider facilmente conseguimos ter acesso aos diretórios específicos tanto no Android como no iOS para armazenar, ler e escrever com essas permissões.

```dart
// Método assincrono que retorna um arquivo data.json em um determinado path no sistema de arquivos do dispositivo
Future<File> _getFile() async {
  final Directory directory = await getApplicationDocumentsDirectory(); // local onde se pode armazenar os documentos com o path_provider
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
```

## Criando o TextField e o Botão de adicionar task

No layout criamos um *Scaffold* com uma *AppBar* e logo após no corpo criamos uma *Column* e, essa parte poderiamos usar um padding para espaçamento dos Widgets, mas o preferível foi o uso do widget *Container* com a propriedade padding definindo os espaçamentos.

**Row** = Um widget que tem seus filhos distribuidos em um Array de Widgets horizontalmente. Para que o filho se expanda para preencher o espaço disponível coloque o mesmo dentro do widget *Expanded*.

**Expanded** = Expande o child de uma *Row*, *Column* ou *Flex* para que o mesmo preencha o espaço disponível.

Colocamos dentro da Row uma TextField que está dentro de um Expanded para que ele preencha o espaço e um RaisedButton.

```dart
Column( // coluna
  children: <Widget>[
    Container( // container onde estam os conteudos
      padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0), // espaçamento
      child: Row( //lina com o campo e o botão
        children: <Widget>[
          Expanded(child: TextField()), // campo expandido para completar o espaço
          RaisedButton() // botão
        ],
      ),
    )
  ],
),
```

## Criando as Listas com ListView.builde e CheckBoxListTile

Para construir a UI da lista de tasks precisaremos usar um widget chamado *ListView.builder*, contendo uma lista de filhos do tipo *CheckBoxListTile*.

**ListView.builder** = É apropriado para criar listas finitas ou infinitas de filhos onde só são chamados os realmente visíveis. Podemos estimar a extensão máxima da rolagem da rolagem com o parametro *itemCount*.

**CheckBoxListTile** = É um *ListTile* com um checkbox. Uma caixa de seleção com uma label. Todo seu corpo é interativo, ou seja, pressionando em qualquer lugar ele marca ou não o checkbox.

```dart
Expanded( // para completar o espaço todo
  child: ListView.builder( // é uma lista que vai sendo preenchida de acordo com que vai aparecendo e os itens que não aparecem não consomem memória
    padding: EdgeInsets.only(top: 10.0),
    itemCount: _toDoList.length, // definido pelo tamanho do Array de Tasks
    itemBuilder: (context, index) {
      return CheckboxListTile(
        onChanged: (checked) { // se foi clicado o parametro checked é passado para o Array de toDo do item clicado
          setState(() {
            _toDoList[index]['ok'] = checked;
          });
        },
        title: Text(_toDoList[index]['title']), // titulo da label
        value: _toDoList[index]['ok'], // se está marcado ou não
        secondary: CircleAvatar(
          child: Icon(_toDoList[index]['ok'] ? Icons.check : Icons.error),
        ),
      );
    }
  ),
),
```

O RaisedButton cuida de adicionar o item na lista de toDo e salvar a lista no arquivo local, via onPressed passando o método abaixo.

```dart
// adiciona task na lista
void _addToDo() {
  setState(() {
    Map<String, dynamic> newToDo = Map(); // cria um Map para adicionar na lista
    newToDo['title'] = _todoController.text; // a chave 'title' recebe o valor digitado no TextField
    _todoController.text = ''; // depois de adicionado ele zera o TextField
    newToDo['ok'] = false; // ao adicionar uma toDo sempre vem desmarcada
    _toDoList.add(newToDo); // adicionad o Map na Lista
    _saveData(); // método que salva a lista que foi adicionada no arquivo data.json
  });
}
```

## Salvando as tasks permanentemente e montar a lista ao iniciar o app

Quando marcamos o checkbox da lista também passamos o método **_saveData()** para salvar a alteração e atualizar o arquivo data.json.

E quando fecharmos o app e abrirmos denovo precisamos recuperar esses dados vindos do arquivo.

```dart
@override
void initState() { // método chamado no inicio da aplicação
  super.initState(); // preciasmos chamar o initState da super classe State
  _readData().then((data) { // lemos o arquivo e obtemos os dados
    setState(() { // atualizamos a tela com a lista atualizada
      _toDoList = json.decode(data);
    });
  });
}
```

## Criando Itens Removíveis com Dismissible

**Dismissible** = Como um padrão de UI deslizar um item para descarta-lo é muito comum. Esse widget serve justamente para isso.

```dart
Dismissible(
  key: ValueKey(myString),
  child: ListTile(title: Text(myString)),
  background: Container(color: Colors.red),
  direction: DismissDirection.startToEnd, // define a direção para onde será deslizado
  onDismissed: (direction) {
    setState(() {
      items.removeAt(i); // remover um item da Matriz que alimenta a Lista de Itens
    });
  },
  secondaryBackground: Container( // para ter multiplas direções
    color: Colors.green,
    child: Icon(Icons.check)
  )
)
```

## SnackBar e Desfazer Ação

Um **SnackBar** é um widget de mensagem leve com uma action opcional que é exibida brevemente na parte inferior da tela.

Para exibir uma snackbar, chamamos **Scaffold.of(context).showSnackBar()** passando a instancia da snackbar criada.

```dart
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
```

## Ordenando Itens

Para ordenar as tarefas das abertas seguidas das concluidas, usamos um widget **RefreshIndicator** que se trata de um refresh feito ao dar um *swipe to refresh* e mostra um icone que indica refresh e quando termina o limite do swipe ele chama um método no onRefresh.

```dart
// ordena a lista das task depois do refresh
  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1)); // depois de esperar 1 segundo  executa abaixo
    setState(() {  // atualiza a UI com as tasks ordenadas
      _toDoList.sort((a, b) { // ordena o array de tasks
        if(a['ok'] && !b['ok']) return 1;
        else if(!a['ok'] && b['ok']) return -1;
        else return 0;
      });
      _saveData(); //atualiza o arquivo data.json
    });
    return null;
  }

RefreshIndicator(
  onRefresh: _refresh, // callback _refresh
  child: ListView.builder( // é uma lista que vai sendo preenchida de acordo com que vai aparecendo e os itens que não aparecem não consomem memória
    padding: EdgeInsets.only(top: 10.0),
    itemCount: _toDoList.length,
    itemBuilder: buildItem,
  ),
),
```
