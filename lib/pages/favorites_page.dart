import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Le tue ${appState.favoritesWords.length} parole preferite',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final pair = favorites[index];
              return ListTile(
                leading: IconButton(
                  onPressed: () {
                    appState.removeFavorite(pair);
                    print(appState.favoritesWords);
                  },
                  icon: Icon(Icons.delete),
                ),
                title: Text(
                  pair.asLowerCase,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
