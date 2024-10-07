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
        title: Text('Tour de l\'équipe ${gameProvider.currentTeam}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentQuestion.questionText,
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20.0),

            // Ajouter le compteur de bonnes réponses avant la question camembert
            Text(
              'Bonnes réponses avant une question camembert: ${gameProvider.correctAnswersInARow} / 3',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),

            // Affichage des options de réponse
            ...currentQuestion.options.map((option) {
              return ElevatedButton(
                onPressed: () {
                  gameProvider.answerQuestion(option, context);

                  if (gameProvider.hasWon(gameProvider.currentTeam)) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ResultScreen()),
                    );
                  } else if (gameProvider.hasNextQuestion) {
                    // Vérifie si on doit poser une question camembert ou continuer
                    if (gameProvider.correctAnswersInARow < GameProvider.CAMEMBERT_REQUIRED_ANSWERS) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => GameScreen()),
                      );
                    }
                    // Sinon, attendre la question camembert
                  }
                },
                child: Text(option),
              );
            }).toList(),

            SizedBox(height: 20.0),
            Text(
              'Camemberts: ${gameProvider.getCamembertProgress(1)}',
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              'Camemberts: ${gameProvider.getCamembertProgress(2)}',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
