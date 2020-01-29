# Calculadora IMC

![Calculadora IMC com Flutter](https://github.com/aandrepf/flutter-projects/blob/master/assets/calculadora_imc.png)

um projeto desenvolvido em Flutter para estudos.

Primeiramente no main.dart, importamos o pacote do material design para dart com **package:flutter/material.dart**. Com isso no método main usamos o método do pacote runApp() que apresenta o widget criado na tela. detro do parametro passamos um **MaterialApp()** onde no parametro definimos onde será a home do app.

No caso desse app ele será um *StatefulWidget* que é um widget dinamico que pode ser alterado de acordo com eventos/interações emitidas pelo user ou quando recebe algum dado. Um *StatelessWidget* nunca muda. Icones, Botões, Textos são exemplos de stateless widgets.

```dart
void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

// Home é um StatefulWidget
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
```

## Scaffold e AppBar

**Scaffold** = Ele implementa o layout basico da estrutura visual do material design. Implementa AppBars, snack bars, bottom sheets e etc.

```dart
Scaffold(
  appBar: AppBar(), // No scaffold temos uma Appbar
  body: SingleChildScrollView(
    child: Column(
      children: <Widget>[] // Uma Lista de Widgets dentro dessa Column
    )
  ) // no corpo do Scaffold temos uma caixa de rolagem com um unico widget tipo Column
);
```

**AppBar** = Consiste em uma barra de tarefas que contem outros widgets como TabBar e FlexibleSpaceBar.

**SingleChildScrollView** = Uma caixa que contem um unico Widget que pode ser rolado, para garantir que o mesmo esteja sempre visível no eixo.

**Column** = Um widget que exibe seus filhos em uma matriz vertical.

```dart
// conteudo da AppBar
AppBar(
  title: Text('Calculadora de IMC'),
  centerTitle: true,
  backgroundColor: Color(0xFF689F38),
  actions: <Widget>[ // são itens que executam alguma ação
    IconButton( // botão de icone
      icon: Icon(Icons.refresh), // icone de refresh
      onPressed: () {}, // executa algo ao ser pressionado
    )
  ],
),
```

## TextField ,InputDecoration, Padding, Container e RaisedButton, Text

**TextField** = Campos de texto onde o usuário insere algum tipo de texto, numero e etc.

**InputDecoration** = As bordas, labels, icones e os estilos usados para decorar um campo de texto do Material Design

```dart
TextField(
  keyboardType: TextInputType.number, // tipo do campo
  decoration: InputDecoration( // estilos do campo
    labelText: 'Altura (CM)',
    labelStyle: TextStyle(color: Color(0xffffffff)),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xffffffff)),
    ),
  ),
  textAlign: TextAlign.center, // alinhamento do texto no campo
  style: TextStyle(color: Color(0xffffffff), fontSize: 20.0), // estilos geral
)
```

**Padding** = Widget que insere seu child dentro de um preenchimento.

**Container** = Funciona como uma div que envolve seu child permitindo dimensionar, posicionar, backgrounds, cores e ect.

**RaiserButton** = É um botão do Material Design do tipo *Raised Button*. Ele tem o *onPressed* e *onLongPress* que se forem definidos como **null** ele ficara desabilitado. Geralmente seu child é um *Text*.

```dart
Padding(
  padding: EdgeInsets.only(top: 30.0, bottom: 20.0), // padding somente no top e no left
  child: Container(
    child: RaisedButton(
      child: Text()
    )
  )
)
```

## Controllers

Dentro da nossa classe **_HomeState** definimos dois controllers do tipo **TextEditingController**, que é usado para um campo de texto editável onde, sempre que o user modificar o campo com esse controller definido ele atualiza o valor do mesmo e notifica seus listeners.

```dart
  TextEditingController weightController = TextEditingController(); // listener do Controller de peso
  TextEditingController heightController = TextEditingController(); // listener do Controller de altura

  // campo de texto do peso que tem seu controller definido para passar a string quando for modificada
  TextField(
    controller: weightController,
  )

  double weight = double.parse(weightController.text); // variavel que escuta e pega a string do controlador e transforma em tipo double

```

## Forms e Validações

Para fazer validação nos campos do nosso app, primeiramente no Scaffold criamos um **Form** para que possamos definir a chave unica desse formulário e dentro dele no seu child colocamos a **Column**:

```dart
Scaffold(
  appBar: AppBar(), // No scaffold temos uma Appbar
  body: SingleChildScrollView(
    child: Form( // Colocamos a coluna envolta por um formulário, para que possamos criar uma chave única que identifica o form
      key: _formKey, // chave identificadora do forumulário
      child: Column(
        children: <Widget>[] // Uma Lista de Widgets dentro dessa Column
      ),
    ),
  ) // no corpo do Scaffold temos uma caixa de rolagem com um unico widget tipo Column
);
```

Usamos uma **GlobalKey** que é uma chave unica usada em todo aplicativo para identificar elementos do tipo **FormState** que é o estado associado ao widget Form.

```dart
  GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // _formKey é a chave definida no parametro key do Widget Form.
```

Depois os TextFields viram **TextFormFields** (que são bem semelhantes), só que agora temos um parametro **validator** onde verificamos se o campo é vazio, se caso for aparece uma mensagem de erro embaixo do campo como um *hint*:

```dart
TextFormField(
  validator: (value) => value.isEmpty ? 'Insira seu peso' : null,
),
TextFormField(
  validator: (value) => value.isEmpty ? 'Insira sua altura' : null,
),
```

Ao clicar no RaisedButton, chamamos o método anonimo que irá fazer a validação do form

```dart
child: RaisedButton(
  onPressed: () {
    if (_formKey.currentState.validate()) { // verifica o estado atual do formulário validando os valores atuais dos campos, se passar ele faz o calculo
      _calculate();
    }
  }
),
```
