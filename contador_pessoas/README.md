# Contador de Pessoas

![Contador de Pessoas com Flutter](https://github.com/aandrepf/flutter-projects/blob/master/assets/contador_pessoas.png)

Um app de Flutter consiste em uma interface com 2 botões onde ao se clicar nos botões ele vai incrementando ou decrementando o número de pessoas no resturante e ao atingir um determinado numero de pessoas ele informa que está lotado e quando decrementamos ele mostra 'Pode Entrar' e quando vai para numero negativo mostra 'Mundo Invertido?!'.

Recursos Utilizados:

-Stateful e Statless
-Column e Row
-Text e TextStyle
-FontStyle e FontWay
-FlatButton
-Image
-Stack
-Padding

## Colunas e Textos

**Column** = um widget que permite colocar um conjunto de widgets de forma vertical, um sobre o outro.
**Text** = widget que trabalha com textos. Ele tem um construtor *TextStyle* que conseguimos estilizar o texto.

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center, // alinhamento vertical no centro
  children: <Widget>[
    Text(String texto, TextStyle style),  
  ] // Lista de widgets
);
```

## Botões, Linhs e Hierarquia

**FlatButton** = widget de botão que não possui um fundo.
**Row** = widget que permite colocar um conjunto de widgets de forma horizontal, um ao lado do outro.

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center, // alinhamento horizontal no centro
  children: <Widget>[
    FlatButton(
      child: Text(), // apenas um unico Widget como filho
      onPressed: () {}, // parametro que espera uma ação ao pressionar o botão
    )
  ]
);
```

## Image, Padding e Stack

**Padding** = um widget que insere seu filho dando espaçamento nas laterais.

```dart
Padding(
  padding: EdgeInsets.all(10.0) // todos os lados o padding é de 10.0
  child: FlatButton(),
);
```

Para se utilizar uma imagem no aplicativo, no arquivo *pubspec.yaml* devemos declarar qual imagem será usada na aplicação.

```dart
assets:
  - images/restaurant.jpg
```

**Stack** = Widget/Classe que permite sobrepor filhos de uma maneira simples, por exemplo, com texto e imagem, sobrepostos com um gradiente e um botão anexado na parte inferior.

```dart
Stack(
  children: <Widget>[
    Image.asset( // pega a imagem do assets definido no pubspec.yaml
      'images/restaurant.jpg',
      fit: BoxFit.cover, // a imagem cobre toda tela
      height: 1000.0, // altura
    ),
    Column(),
  ],
),
```

## Stateless e Stateful

**Stateless** = não possuem um estado interno, ou seja, são estaticos nunca mudam sua estrutura. Não tem interação.

**Stateful** = widgets que tem um estado interno, ou seja sempre podem ser alterados via alguma interação.

No *Stateful* podemos alterar alguma coisa, porém o Widget não consegue interpretar essa alteração na hora do build da interface. Para isso usamos o método **setState((){ alteração })**, onde passamos a regra que faz a alteração em alguma determinada ação e assim o build consegue modificar a tela atualizando somente a parte que foi alterada.
