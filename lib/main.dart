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
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 34, 222, 255)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

// Variabile per memorizzare le parole preferite
  // Inizializza la lista di parole preferite
  var favoritesWords = <WordPair>[];
// Aggiungi una parola alla lista delle parole preferite
  void toggleFavorite() {
    // Controlla se la parola corrente è già nelle parole preferite
    // Se la parola è già nelle preferite, rimuovila
    if (favoritesWords.contains(current)) {
      favoritesWords.remove(current);
      // Altrimenti, aggiungila alla lista delle parole preferite
    } else {
      favoritesWords.add(current);
    }
    notifyListeners();
  }

  // Rimuovi una parola dalla lista delle parole preferite
  void removeFavorite(WordPair pair) {
    if (favoritesWords.contains(pair)) {
      favoritesWords.remove(pair);
      notifyListeners();
    }
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

var selectedIndex = 0;

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
      case 1:
        page = FavoritesPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              // SafeArea è una zona sicura che sere per evitare il notch (o qualsiasi altro elemento UI) del dispositivo
              child: NavigationRail(
                extended: constraints.maxWidth >=
                    600, // Estendi la NavigationRail se la larghezza massima è maggiore di 600
                // I 600 pixel non sono pixel fissi, ma sono una misura relativa (38px sono circa un cm e 98px circa un pollice)
                // che si adatta a qualsiasi dispositivo
                // e si adatta a qualsiasi dimensione dello schermo (dal più piccolo al più grande, dal più vecchio al più recente).
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                ],
                // Imposta l'indice selezionato per evidenziare l'elemento selezionato
                selectedIndex: selectedIndex,
                // Cambia l'indice selezionato quando l'elemento viene cliccato
                onDestinationSelected: (value) {
                  // Cambia lo stato dell'indice selezionato
                  // e ricostruisci il widget
                  // per riflettere il cambiamento
                  // di stato
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favoritesWords.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                  // Stampa la lista delle parole preferite nella console
                  print(appState.favoritesWords);
                },
                icon: Icon(icon),
                label: Text('Mi piace'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Successiva'),
              ),
            ],
          ),
        ],
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
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}

// pagina dei preferiti
class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final favorites = appState.favoritesWords;

    if (favorites.isEmpty) {
      return Center(
        child: Text('Nessuna parola preferita'),
      );
    }

    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final pair = favorites[index];
        return ListTile(
          leading: IconButton(
            onPressed: () {
              appState.removeFavorite(pair);
              // Stampa la lista delle parole preferite nella console
              print(appState.favoritesWords);
            },
            icon: Icon(Icons.delete),
          ),
          title: Text(pair.asLowerCase),
        );
      },
    );
  }
}
