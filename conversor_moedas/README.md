# Conversor de Moedas

![Conversor de Moedas com Flutter](https://github.com/aandrepf/flutter-projects/blob/master/assets/conversor.png)

Um aplicativo que faz conversão de moedas que utiliza uma API da [HG Finance](https://hgbrasil.com/status/finance) de cotação para fazer as conversões necessárias através de requisições HTTP.

## Padrão JSON

Existe um site [JSON Editor Online](https://jsoneditoronline.org/) que podemos usar para ver o padrão de criação e estrutura de um JSON.

O JSON ele armazena os dados separados por virgula em formato de Maps onde consiste num formato **chave: valor**

```json
{
  "array": [1,2,3],
  "boolean": true,
  "color": "#82b92c",
  "null": null,
  "number": 123,
  "object": {"a": "b", "c": "d", "e": "f"},
  "string": "Hello World"
}
```

## API de Valores

Uma API é uma ponte para obter dados em formato JSON obtidos atraves de um serviço. Para usar a API da HG Finance temos que criar uma chave de API que identifica quem está usando a api (a39115d6);

## Mudança no Pacote HTTP

A mais recente versão do Flutter não inclui o pacote do http por padrão, devemos abrir o arquivo **pubsec.yaml** para adicionar o pacote manualmente.

## Requisitando Dados

Uma requisição assincrona não precisa ficar esperando a chegada dos dados e somente se os mesmos chegarem faz-se alguma coisa.

Para fazer requisições devemos importar algumas bibliotecas

```dart
import 'package:http/http.dart' as http; // lib HTTP
import 'dart:async'; // pacote para requisições assincronas
import 'dart:convert'; // pacote para converções como JSON

const request = 'https://api.hgbrasil.com/finance?format=JSON&key=a39115d6'; //constante da url da requisição
```

Para fazer requisições assincronas nosso método *main* deve ser async e usamos do pacote *http.dart* o **http.get** que faz uma requisição do tipo *GET* da constante com a url.

Com o response temos o corpo da requisição em formato JSON e assim convertemos o mesmo com **json.decode()** do pacote dart:convert para converter o mesmo em objeto para acessar as propriedades.

```dart
void main() async {
  // variavel do tipo http.Response que aguarda o GET da url
  http.Response response = await http.get(request);
  
  // json.decode() é um método que usamos do pacote dart:convert para converter json em OBJETO e assim acessar suas propriedades
  print(json.decode(response.body)['results']['currencies']['USD']);
}
```

## Trabalhando com Futuro

Flutter e Dart são assincronos por natureza. Com o *Future*, podemos manipular inputs e outputs sem se preocupar com threads ou deadlocks, ou seja, os dado não chegam no mesmo momento que é chamado. Enquanto ele não chega podemos implementar um **FutureBuilder** para mostrar um carregando na tela.

## Construindo um FutureBuilder

**FutureBuilder** = widget que permite determinar facilmente o estado atual de um *Future* e assim escolher o que mostrar enquanto o dado está carregando e quando está disponível

```dart
FutureBuilder(
  future: http.get('http://awesome.data/'), // configuramos um future
  builder: (context, snapshot) {
    if(snapshot.connectionState == ConnectionState.done) { // verificamos se o estado da conexao foi concluida
      if(snapshot.hasError) { // se houve algum erro
        return SomethingWentWrong();
      }
      return AwsomeData(snapshot.data); // se não houve erros retorna o dado
    } else {
      return CircularProgressIndicator(); // faz algo enquanto está carregando
    }
  }
);
```
