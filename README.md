# Flutter Projects

Repositório contendo estudos e projetos com Flutter

## Introdução ao Flutter

É um SDK que permite criar apps modernos e de alta performance tanto para Android como iOS, desenvolvida pelo Google e totalmente open-source e possuem grande suporte para as principais IDEs de mercado.

Flutter é orientado a Design, criando a parte de interface e depois criar a regra de negócio em cima dessa interface.

Tudo no Flutter é *Widget*, ou seja, Textos, Cards, Listas e etc. Tudo é um widget.

É otimizado para performance, ou seja, compila o código para rodar nativamente no dispositivo.

## Instalação do Flutter/Dart

[Tutorial Oficial de Instalação](https://flutter.dev/docs/get-started/install)

Para criar um projeto via linha de comando usamos **flutter create --org br.com.nome nome-do-projeto**.

## Pogramação em Dart

[Dart](https://dart.dev/guides) é uma linguagem de programação orientada a objeto usada no Flutter e pode ser usada tando do lado do cliente como no lado do servidor.

### Variaveis

Para declarar uma variável, devemos definir o tipo dela e o nome da variável

```dart
    String nome = 'Minha Lojinha';
    int bananas = 5;
    double preco = 10.5;
    bool aindaTem = true;

    String info; // valor é null

    //var també é aceito
    var teste = 1; // não tipado como int

    // dynamic funciona como um any em Typescript
    dynamic teste2 = 'Nome' // pode assumir qualquer valor

    //concatenação
    print('O nome da lojinha é: ' + nome);
    print('A $nome tem $bananas bananas');
```

### Operadores Lógicos

```dart
// Comparadores
// ------------
// maior: > || maior ou igual a: >=
// menor: < || menor ou igual a: <=
// igual: ==
// diferente: !=

// Operador OR
// --------------
// true || true -> true
// true || false -> true
// false || false -> false

// Operador AND
// ------------
// true && true -> true
// true && false -> false
// false && false -> false

// Operador NOT
// ------------
// !true -> false
// !false -> true
```

Temos o operador **??** que no caso de o valor de uma variavel for diferente de *null* ela vai atribuir o proprio valor dela, caso contrario pode ser definido um valor para quando for null.

```dart
    String nome2; // null

    String info = nome2 ?? 'Não informado'; // ?? nome é diferene de null?

    print(info) // mostra 'Não informado';
```

### Loops

O loop **for** geralmente é usado para quando temos um numero fixo de repetições.

```dart
  for(int i = 100; i >= 10; i -= 5) {
    print(i);
  }
```

O loop **wile** é usado para quantidades indefinidas, pois enquanto a condição for válida ele continuará executando. O **do{}while** ele trabalha parecido com  o while, porém ele executa pelo menos uma vez, mesmo que a condição seja invalida.

```dart
  int j = 0;
  while(j < 10) {
      print(j);
      j++;
  }

  int k = 0;
  do {
      print(k);
      k++
  } while(k < 10); // executa o bloco enquanto k é menor que 10
```

### Functions

Os parametros em funções devem sempre conter um nome e o seu tipo especificado.

Funções do tipo **void** não retornam nenhum valor.

Tamos as **arrow functions** onde com a *=>* indica que ele retorna alguma coisa.

No caso de funções com parametros opcionais os mesmos devem ser definidos entre *{}* e ao passar algum valor que não seja o default o nome do parametro deve ser indicado e seu valor no formado *chave: valor*

```dart
double res; // escopo global - pode ser acessado por qualquer um

void main() {
  calcSoma(10.0, 20.0);
  double resMult = calcMult(10.0, 15.0); // escopo local - somente pode ser acessado dentro de main

  print(resMult);
  print(areaCirculo(5.0));

  criarBotao('BotaoSair', btnCriado, cor: 'preto', largura: 20.0); // temos que identificar o valor do parametro e seu valor quando não forem obrigatorios

  criarBotao('BotãoSair', (){
    print('Botão Criado por function anonima!!!');
  });
}

void calcSoma(double a, double b) {
  double res = a + b;
  print(res);
}

double calcMult(double a, double b) {
  double res = a * b;
  return res; // retora um double tipado na função
}

// método reduzido que retorna um double (arrow funcitons)
double areaCirculo(double raio) => 3.14 * raio * raio;

void btnCriado() {
    print('Botão Criado!!!');
}

// os paramtros entre chaves são opcionais (não precisam ser declarados) e tem valor null por padrão
void criarBotao(String texto, Function criadoBtn, {String cor, double largura}) {
  print(texto);
  print(cor ?? 'preto'); // se null, cor default é preto
  print(largura ?? 20.0); // se null, largura default é 20.0
  criadoBtn();
}
```

### Coleções (Listas)

Listas funcionam como arrays de alguma coisa.

```dart
  class Pessoa {
  String nome;
  int idade;
  
  Pessoa(this.nome, this.idade);
}

void main() {
  List<String> nomes = ['Daniel', 'Mari', 'Thiago'];

  print(nomes[0]);
  nomes.add('Marcos'); // adiciona na lista o nome Marcos na ultima posição
  print(nomes); // com o override de toString retorna a lista
  
  print(nomes.length); // retorna o tamanho da lista
  
  nomes.removeAt(2); // remove o item da lista no indice 2
  print(nomes);
  
  nomes.insert(1, 'Tiago'); // insere no indice 1 o nome Tiago
  print(nomes);

  print(nomes.contains('Daniel')); // verifica se existe esse nome
  
  List<Pessoa> pessoas = List(); //lista vazia
  
  pessoas.add(Pessoa('Marcelo', 30));
  pessoas.add(Pessoa('Joao', 20));
  
  // funciona como um forEach de objetos
  for(Pessoa p in pessoas) {
    print(p.nome);
  }
}
```

### Mapas

Um mapa é formado basicamente por uma **chave, valor** , funcionando como uma tabela.

```dart
class InfosPessoa {
  int idade;
  InfosPessoa(this.idade);
}

void main() {
  Map<int, String> ddds = Map();
  ddds[11]  = 'São Paulo';
  ddds[19]  = 'Campinas';
  ddds[13]  = 'Santos';
  print(ddds); // mostra o objeto
  print(ddds.keys); // mostra as chaves
  print(ddds.values); // mostra os valores
  
  Map<String, dynamic> pessoa = Map();
  pessoa['nome']   = 'Enzo';
  pessoa['idade']  = 10;
  pessoa['altura'] = 1.84;
  
  Map<String, InfosPessoa> pessoas = Map();
  pessoas['Joao']    = InfosPessoa(30);
  pessoas['Marcelo'] = InfosPessoa(20);
}
```

## Orientação a Objetos em Dart

### Classes

Uma *classe* é um modelo de um Objeto, ou seja, um molde de algum Objeto. Já os *atributos* são informações que nossa classe/objeto vai armazenar e *métodos* funções da classe/objeto que executam alguma ação.

```dart
// class/objeto Pessoa
class Pessoa {

  // atributos
  String nome;
  int idade;
  double altura;

  // métodos
  void dormir() {
    print('$nome está dormindo.');
  }

  void aniver() {
    idade++;
  }
}

void main() {
  Pessoa pessoa1 = Pessoa();
  pessoa1.nome = 'André Figueiredo';
  pessoa1.idade = 30;
  pessoa1.altura = 1.80;
  
  // Objetos diferentes com a mesma classe
  Pessoa pessoa2 = Pessoa();
  pessoa2.nome = 'Tiago';
  pessoa2.idade = 20;
  pessoa2.altura = 1.90;
  
  print(pessoa1.nome);
  
  print(pessoa1.idade);
  pessoa1.aniver();
  print(pessoa1.idade);

  pessoa2.dormir();
}
```

### Construtores

São métodos usados para construir o Objeto. São instanciados dentro da própria classe. Temos também os *named constructors* onde ele tem um nome especifico e tem alguns parametros diferentes.

```dart
/* construtor convencional
  Pessoa(String nome, int idade, double altura) {
    this.nome = nome;
    this.idade = idade;
    this.altura = altura;
} */

// construtor Dart
  Pessoa(this.nome, this.idade, this.altura);
  
  // Dart named constructor
  Pessoa.nascer(this.nome, this.altura){
    idade = 0;
    print('$nome nasceu!');
    dormir();
  }
```

### Getter e Setters

Por questão de segurança algumas propriedades não podem ser alteradas pura e simplesmente após a sua definição por quem está utilizando ela, para isso devemos torná-la **privada** e por convenção colocamos o *underline* na frente do nome da propriedade e assim ele só pode ser acessado de dentro do próprio objeto.

Em resumo servem para proteção de dados. Devem ser utilizado somente se realmente for necessário.

```dart
int _idade;
int _altura;

// getter
int get idade => _idade;
double get altura => _altura;

// setter
set altura(double altura) {
  if(altura > 0.0 && altura < 3.0) {
    _altura = altura;
  }
}

```

### Herança

Em Dart podemos criar varias classes onde elas podem conter atributos e métodos muito semelhantes. Para resolver essa repetição de código, podemos criar uma classe com esses atributos e métodos em comum e fazer com que as outras classes *herdem* esses atributos e métodos semelhantes via expressão **extends**. Assim cada classe pode ter seus próprios atributos e métodos e ainda herdar de uma classe maior os seus semelhantes.

Quando precisamos passar os atributos da super classe usamos no construtor da classe que extende o **super** que é o construtor da super classe.

Vale lembrar que em Dart as classes só podem herdar de uma única classe maior.

```dart
// classe master
class Animal {
  String nome;
  double peso;

  // construtor
  Animal(this.nome, this.peso);

  void comer() {
    print('$nome comeu');
  }
  
  void fazerSom() {
    print('$nome fez algum som');
  }
}

class Cachorro extends Animal {
  int fofura;

  // construtor
  Cachorro(String nome, double peso, this.fofura) : super(nome, peso); // super é a representação do contrutor Animal da super classe

  void brincar() {
    fofura += 100;
    print('$nome aumentou a fofura para $fofura');
  }
}

class Gato extends Animal {
  // construtor
  Gato(String nome, double peso) : super(nome, peso); // super é a representação do contrutor Animal da super classe
  
  bool estaAmigavel() {
    return true;
  }
}

void main() {
  Cachorro cao = Cachorro('Dog', 10.0, 100);
  cao.fazerSom();
  cao.comer();
  cao.brincar();
  
  Gato cat = Gato('Cat', 5.0);
  cat.fazerSom();
  cat.comer();
  print('Está amigavel? ${cat.estaAmigavel()}');
}

```

### Reescrita de Métodos

Como herdamos atributos e métodos de uma superclasse podemos reescrever métodos substituindo a ação que o mesmo faz utilizando o **@override**.

As classe por padrão herdam de forma oculta da classe *Object* e nessa classe, temos um método **toString** em que retorna uma string informando que a classe é uma instancia, mas com a reescrita, podemos usar como um debbugador de objetos bastando dar um print da variavel que instancia a classe.

```dart
class Cachorro extends Animal {
  int fofura;
  
  Cachorro(String nome, double peso, this.fofura) : super(nome, peso);
  
  void brincar() {
    fofura+= 10;
    print('Fofura do $nome aumentou para $fofura');
  }
  
  @override
  void fazerSom() {
    print('$nome latiu!');
  }
  
  // serve como um debbuger
  @override
  String toString() => 'Cachorro | Nome: $nome, Peso: $peso, Fofura: $fofura';
}

void main() {
  Cachorro cao = Cachorro('Dog', 10.0, 100);
  cao.fazerSom(); // retorna -> Dog latiu!
  cao.comer();
  cao.brincar();
  print(cao); // retorna -> Cachorro | Nome: Dog, Peso: 10, Fofura: 110
}
```

### Modificadores Static, Final e Const

**static** = ao declarar um atributo como static, ele passa a ser uma variável da classe e não mais do objeto e assim, não precisamos instanciar a mesma podendo chamar direto essa variavel.

```dart
class Valores {
  static int vezesClicado;
}

void main(){
  Valores.vezesClicado = 2;
}
```

**const** = a partir do momento que uma variável passa a ser tipo const ela não pode ser mais alterada em nenhum momento, e seu valor sempre sera substituido pelo valor iniciado no momento de compilação;

**final** = depois que um valor foi atribuido a uma variavel essa não pode mais mudar. Ela é uma variável em tempo de execução.

### Classes Abstratas

Uma classe abstrata ela não pode ser instanciada, mas pode ser herdada por outras classes. Para essa definição usamos **abstract**. As classes abstratas podem ter métodos tambem que não fazem nada, mas que se existirem, as classes que herdam delas tem que **obrigatóriamente** dar um override nesse método.

```dart
// classe não pode ser instanciada, mas pode ser uma super classe podendo ser herdados seus atributos e métodos
abstract class Animal {
  void fazerSom(); // quem herdade dessa classe tera que fazer um override desse método
}
```

## Flutter

Uma breve iniciação a [Widgets](https://flutter.dev/docs/development/ui/widgets) e [Material Design](https://flutter.dev/docs/development/ui/widgets/material) em Flutter.

### Widgets

São componentes que podem ser usados no layout, podendo ter vários widgets em uma mesma tela. E também podemos construir arvores de widgets. Também podemos ter widgets de margin, padding, alinhamento, tables, listViews (listas).

### Material Design

É uma metodologia/regra de design criada pela Google para ser fluida e de simples compreensão. Podemos acessar a documentação [clicando aqui](https://material.io).
