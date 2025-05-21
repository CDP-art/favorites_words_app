import 'package:flutter/material.dart';
import 'generator_page.dart';
import 'favorites_page.dart';

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
