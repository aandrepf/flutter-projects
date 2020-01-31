# Buscador de Gifs

![Conversor de Moedas com Flutter](https://github.com/aandrepf/flutter-projects/blob/master/assets/buscador_gifs.png)

Um app que busca gifs e assim é possível compartilhar eles com os amigos e também olhar o mesmo em tamanho real. Será consumido via API do site Giphy e iremos trabalhar com Navigators, GridView, ImageNetwork, Gesture Detector, Share, FadIn Image, Plugins, Progress Indicator e etc.

Para desenvolver o app precisamos das versões recomendadas das seguintes dependencias no *pubspec.yaml*.

```dart
  share: ^0.6.1+1
  transparent_image: ^1.0.0
  http: ^0.12.0+2
```

## Api Giphy

Os gifs virao do site [Giphy](https://giphy.com/). Para isso precisaremos de uma API que está disponível no site [Giphy Developers](https://developers.giphy.com/docs/sdk) e clicaremos em **Create an App** onde pedirá um acesso e você criara sua chave publica de API para uso. Abaixo listamos as urls que serão utilizadas no app para como exemplo.

- [**Trending**](https://api.giphy.com/v1/gifs/trending?api_key=QdA14qvspA8iBn0SHtNJpl9NmSR1aPCr&limit=20&rating=G)
- [**Search](https://api.giphy.com/v1/gifs/search?api_key=QdA14qvspA8iBn0SHtNJpl9NmSR1aPCr&q=dogs&limit=25&offset=75&rating=G&lang=en)

## Layout

Na AppBar queremos que tenhamos uma imagem com o logo do Giphy Developer e para isso pegamos a url do gif do site e aplicamos no *title* do widget via:

**Images.network(src)** = exibe uma imagem da internet via a sua url passada no construtor.

## Criando o Indicador de Progresso

Como sabemos que a requisição dos Gifs é assincrona e retorna um *Future*, ela não tem o retorno instantaneamente e para isso, precisamos criar um indicador mostrando que está sendo carregado. Utilizaremos o widget *FutureBuilder* dentro de um Expanded para preencher todo espaço.

Dentro do FutureBuilder definimos o future recebendo a function que faz a requisição para a Api e o builder com um método anonimo que verifica o status do snapshot e faz enquanto está em wating.

```dart
Expanded(
  child: FutureBuilder(
    future: _getGifs(), // método que faz a requisição assincrona para a API do Giphy
    builder: (context, snapshot) {
      switch(snapshot.connectionState) {
        case ConnectionState.waiting : // state de aguardando
          return Container(
            width: 200.0,
            height: 200.0,
            alignment: Alignment.center,
            child: CircularProgressIndicator( // widget que mostra um spinner circular
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // na cor branca
              strokeWidth: 5.0,
            ),
          );
        default:
          if(snapshot.hasError) {
            return Container();
          } else {
            return _createGifTable(context, snapshot); // monta o grid de Gifs
          }
      }
    },
  ),
),
```

## Grid de Gifs

Para fazer o grid de gifs usaremos o widget com named construcotr *GridView.builder()* que monta um esquema de grids com alguns parametros para montagem.

```dart
Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
  return GridView.builder(
    padding: EdgeInsets.all(10.0),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( // cria o layout com numero fizxo de blocos no eixo transversal. Se vertical cria o layout com numero fixo de colunas, se horizontal cria com numero fixo de linhas
      crossAxisCount: 2, //quantos itens
      crossAxisSpacing: 10.0, // espaçamento horizontal
      mainAxisSpacing: 10.0 // espaçamento vertical
    ), // mostra como que os itens serão organizados
    itemCount: snapshot.data['data'].length,
    itemBuilder: (context, index) {
      if(_search == null || index < snapshot.data['data'].length) { // se não está pesquisando ou o item não for o ultimo
          return GestureDetector(
            child: Image.network(
              snapshot.data['data'][index]['images']['fixed_height']['url'],
              height: 300.0,
              fit: BoxFit.cover,
            ),
          );
      } else {
        // retorna os itens com um botão de carregar mais no final da lista
        return Container(
          child: GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.add, color: Colors.white,size: 70.0),
                Text('Carregar mais...', style: TextStyle(color: Colors.white, fontSize: 22.0),),
              ],
            ),
            onTap: () { // sempre que pressionar o botão ele carregará mais 19 gifs direrentes
              setState(() {
                _offset += 19;
              });
            },
          ),
        );
      }
    } ,
  );
}
```

## Criando e trocando de tela

Para criar uma tela onde ao tocar no gif ele abra uma tela nova com o gif somente, criamos um *StatlessWidget*. que irá receber no seu construtor os dados do gif selecionado.

Para navegar até a tela nova:

```dart
// Widget do Gif
GestureDetector(
  child: Image.network(
    snapshot.data['data'][index]['images']['fixed_height']['url'], // caminho do gif
    height: 300.0,
    fit: BoxFit.cover,
  ),
  onTap: () { // ao clicar no gif
    Navigator.push( // para fazer a navegação
      context, // contexto do gif
      MaterialPageRoute(builder: (context) => GifPage(snapshot.data['data'][index])), // importamos a StatlessWidget e passamos no construtor os dados do gif selecionado pelo seu index
    );
  },
);
```

## Compartilhando Gifs

Para compartilhar um gif, usaremos o plugin do flutter **share** e importar nas paginas para que cada uma faça a sua maneira.

```dart
// HOMEPAGE ao segurar no icone
onLongPress: () { // propriedade do GestureDetector
  Share.share(snapshot.data['data'][index]['images']['fixed_height']['url']); // do plugin de share
},

// GIFPAGE clicando no icone de share
actions: <Widget>[ //actions da AppBar
  IconButton(
    icon: Icon(Icons.share), // icone de share
    onPressed: () {
      Share.share(_gifData['images']['fixed_height']['url']); // do plugin de share
    },
  )
],
```