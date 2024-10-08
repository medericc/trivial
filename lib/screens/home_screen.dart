import 'package:flutter/material.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trivial Pursuit Chrétien',
          style: TextStyle(
            fontFamily: 'Roboto',
            color: const Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
            fontSize:30,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 80, 54, 20),
        toolbarHeight: 100,
      ),
      body: Stack(
        children: [
          // Image de fond subtile
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/back.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
    Column(
  children: [
    // Espacement flexible ajusté
    Expanded(
      flex: 31, // Diminue cet espace pour remonter le bouton
      child: Container(),
    ),
    
    // Bouton en bas
    Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GameScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 80, 54, 20),
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          'Démarrer le jeu',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    ),
    
    // Espacement flexible en dessous
    Expanded(
      flex: 1, // Ajoute cet espace pour ajuster la position du bouton
      child: Container(),
    ),
  ],
)

        ],
      ),
    );
  }
}
