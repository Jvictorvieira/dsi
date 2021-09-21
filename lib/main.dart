import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      home: RandomWords(),
    );
  }
}


class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 16);
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
                (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(context: context, tiles: tiles).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold (                     // Add from here...
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }


  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (BuildContext _context, int i) {

          if (i.isOdd) {
            return Divider();
          }
          final int index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return Dismissible(
              key: Key(_suggestions[index].asPascalCase),
              onDismissed: (direction) {
                setState(() {
                  if (_saved.contains(_suggestions[index])) {
                    _saved.remove(_suggestions[index]);
                  }
                  _suggestions.removeAt(index);
                  ;
                });
                },
              child: _buildRow(index ,_suggestions[index]));

        }
    );
  }
  void changeWordPair(index) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Change Suggestions'),
            ),
            body: TextFormField(
              initialValue: _suggestions[index].toString(),
              onFieldSubmitted: (input) {
                setState(() {
                  _suggestions[index] = WordPair(input, " ");
                });
              },

            ),
          );
        },
      ),
    );
  }
  Widget _buildRow(index, WordPair pair) {
    final alreadySaved = _saved.contains(pair);

    return Wrap(
      children: [
        ListTile(
          title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
          onTap: () {
            changeWordPair(index);
          },
        ),

        IconButton(
          onPressed: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else{
              _saved.add(pair);
            }
          });
          },
          icon: Icon(
            alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.green : null,
          ),
        ),
      ]
    );
  }
}