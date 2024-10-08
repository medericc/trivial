import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'result_screen.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final currentQuestion = gameProvider.currentQuestion;

    return Scaffold(
   appBar: AppBar(
  title: Text(
    'Tour de l\'équipe ${gameProvider.currentTeam}',
    style: TextStyle(
      fontFamily: 'Roboto',
      color: const Color.fromARGB(255, 255, 255, 255),
    ),
  ),
  backgroundColor: Colors.blue[700],
  iconTheme: IconThemeData(
    color: Colors.white, // Changer la couleur de la croix ici
  ),
),

      body: Padding(
        padding: const EdgeInsets.all(8.0), // Réduction du padding général
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bloc pour la question avec bordures arrondies
            Container(
              padding: const EdgeInsets.all(12.0), // Moins de padding
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                currentQuestion.questionText,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 2, 2, 2),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20.0), // Réduction de l'espacement

            // Progression avant la question camembert
            Text(
              'Avant camembert : ${gameProvider.correctAnswersInARow} bonnes réponses sur ${GameProvider.CAMEMBERT_REQUIRED_ANSWERS}',
              style: TextStyle(
                fontSize: 16.0, // Taille de texte réduite
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0), // Réduction de l'espacement

            // Affichage des options en boutons carrés
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Deux colonnes
                crossAxisSpacing: 8.0, // Moins d'espacement
                mainAxisSpacing: 8.0, // Moins d'espacement
                childAspectRatio: 1.2, // Ajuster le ratio pour un meilleur fit
                children: currentQuestion.options.map((option) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8.0), // Réduction du padding
                    ),
                    onPressed: () {
                      gameProvider.answerQuestion(option, context);

                      if (gameProvider.hasWon(gameProvider.currentTeam)) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ResultScreen()),
                        );
                      } else if (gameProvider.hasNextQuestion) {
                        if (gameProvider.correctAnswersInARow < GameProvider.CAMEMBERT_REQUIRED_ANSWERS) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => GameScreen()),
                          );
                        }
                      }
                    },
                    child: Text(
                      option,
                      style: TextStyle(fontSize: 16.0, color: Colors.white), // Texte un peu plus petit
                    ),
                  );
                }).toList(),
              ),
            ),
            // Réduire l'écart ici
            SizedBox(height: 5.0), // Très peu d'espacement maintenant

            // Affichage des camemberts des équipes
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0), // Ajustement du padding
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        'Équipe 1',
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Camemberts : ${gameProvider.getCamembertProgress(1)}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Équipe 2',
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Camemberts : ${gameProvider.getCamembertProgress(2)}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
