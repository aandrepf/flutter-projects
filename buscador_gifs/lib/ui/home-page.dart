import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:buscador_gifs/ui/gif-page.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;

  // Faz a requisição para trazer os Gifs
  Future<Map> _getGifs() async {
    http.Response response;

    if(_search == null || _search.isEmpty) {
      // requisita somente os melhoes caso ja tenha sido feito um search
      response = await http.get('https://api.giphy.com/v1/gifs/trending?api_key=QdA14qvspA8iBn0SHtNJpl9NmSR1aPCr&limit=20&rating=G');
    } else {
      // faz o search se não foi feito antes
      response = await http.get('https://api.giphy.com/v1/gifs/search?api_key=QdA14qvspA8iBn0SHtNJpl9NmSR1aPCr&q=$_search&limit=19&offset=$_offset&rating=G&lang=en');
    }

    return json.decode(response.body);
  }

  //implementa o initState
  @override void initState() {
    super.initState();

    _getGifs().then((map){
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network('https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif'), //pegou uma imagem da internet
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Pesquise aqui',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch(snapshot.connectionState) {
                  case ConnectionState.waiting :
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if(snapshot.hasError) {
                      return Container();
                    } else {
                      return _createGifTable(context, snapshot);
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getCount(List data) {
    if(_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, //quantos itens
        crossAxisSpacing: 10.0, // espaçamento horizontal
        mainAxisSpacing: 10.0 // espaçamento vertical
      ), // mostra como que os itens serão organizados
      itemCount: _getCount(snapshot.data['data']),
      itemBuilder: (context, index) {
        if(_search == null || index < snapshot.data['data'].length) { // se não está pesquisando ou o item não for o ultimo
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data['data'][index]['images']['fixed_height']['url'],
              height: 300.0,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => GifPage(snapshot.data['data'][index])),);
            },
            onLongPress: () {
              Share.share(snapshot.data['data'][index]['images']['fixed_height']['url']);
            },
          );
        } else {
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, color: Colors.white,size: 70.0),
                  Text('Carregar mais...', style: TextStyle(color: Colors.white, fontSize: 22.0),),
                ],
              ),
              onTap: () {
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
}
