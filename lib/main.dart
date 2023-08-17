import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'English word generator',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[];
  
  void getNext(){
    current = WordPair.random();
    notifyListeners();
  }

  void toogleFavorite(){
    if (favorites.contains(current)) {
      favorites.remove(current);
    }else{
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData heartIcon;
    if (appState.favorites.contains(pair)) {
      heartIcon = Icons.favorite;
    }else{
      heartIcon = Icons.favorite_border;
    }

    return Scaffold(
      body: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(pair: pair),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: (){
                    appState.getNext();
                  },
                  child: Text("Next")
                ),
                SizedBox(width: 20),
                //like button
                ElevatedButton.icon(
                  onPressed: (){
                    appState.toogleFavorite();
                    print("lista de favoritos: ${appState.favorites}");//degub
                  }, 
                  label: Text("Like"),
                  icon: Icon(heartIcon),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context); //Obtiene el tema del widget padre
    
    //Obtiene el estilo del widget padre, cambia el tamaño y le agrega color. El color igual se obtiene del widget padre
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          pair.asPascalCase,
          semanticsLabel: "${pair.first} ${pair.second}", 
          style: style,
          ),
      ),
    );
  }
}