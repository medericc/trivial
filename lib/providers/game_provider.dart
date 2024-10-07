import 'dart:math';
import 'package:flutter/material.dart';
import '../models/question.dart';
import './questions.dart';
class GameProvider with ChangeNotifier {

  int _currentQuestionIndex = 0;
  int _scoreEquipe1 = 0;
  int _scoreEquipe2 = 0;
  int get scoreEquipe1 => _scoreEquipe1;
  int get scoreEquipe2 => _scoreEquipe2;
  int _currentTeam = 1; // 1 = Équipe 1, 2 = Équipe 2
  int _correctAnswersInARow = 0;
  int get correctAnswersInARow => _correctAnswersInARow;
  Map<int, Set<String>> _camembertEquipe1 = {1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}};
  Map<int, Set<String>> _camembertEquipe2 = {1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}};
  static const int CAMEMBERT_REQUIRED_ANSWERS = 3;
  static const int MAX_CAMEMBERTS = 6;

  final Random _random = Random();

  bool get hasNextQuestion => _currentQuestionIndex < questions.length;
 int get currentTeam => _currentTeam;
  Question get currentQuestion => questions[_currentQuestionIndex];
  int getCamembertProgress(int team) {
    return team == 1 ? _camembertEquipe1[team]!.length : _camembertEquipe2[team]!.length;
  }

  bool hasWon(int team) {
    return getCamembertProgress(team) >= MAX_CAMEMBERTS;
  }

  Question getRandomQuestion() {
    List<Question> availableQuestions = questions.where((question) {
      Set<String> camembertCategories = _currentTeam == 1
          ? _camembertEquipe1[_currentTeam]!
          : _camembertEquipe2[_currentTeam]!;
      return !camembertCategories.contains(question.category);
    }).toList();

    if (availableQuestions.isEmpty) {
      resetGame();
      return questions[0];
    }
    return availableQuestions[_random.nextInt(availableQuestions.length)];
  }

void answerQuestion(String answer, BuildContext context) {
  bool isCorrect = currentQuestion.correctAnswer == answer;

  if (isCorrect) {
    _correctAnswersInARow++;

    // Si on atteint 3 bonnes réponses consécutives, on doit poser une question camembert
    if (_correctAnswersInARow >= CAMEMBERT_REQUIRED_ANSWERS) {
      // Ne réinitialise PAS ici le compteur à 0
      chooseCamembertCategory(context); // Afficher la question camembert
      return; // On ne passe pas à la question suivante pour l'instant
    }
  } else {
    _switchTeam(); // Si la réponse est fausse, on change d'équipe
    _correctAnswersInARow = 0; // Réinitialiser le compteur si la réponse est fausse
  }

  // Passer à la question suivante uniquement si on n'a pas atteint le camembert
  if (_currentQuestionIndex < questions.length - 1) {
   _currentQuestionIndex++;
  } else {
    print('Toutes les questions ont été répondues.');
    resetGame();
  }

  notifyListeners();
}




void chooseCamembertCategory(BuildContext context) {
  List<String> availableCategories = questions.map((q) => q.category).toSet().toList();
  Set<String> camembertCategories = _currentTeam == 1
      ? _camembertEquipe1[_currentTeam]!
      : _camembertEquipe2[_currentTeam]!;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Choisissez une catégorie pour le camembert"),
        content: SingleChildScrollView(
          child: Column(
            children: availableCategories.map((category) {
              return ListTile(
                title: Text(category),
                enabled: !camembertCategories.contains(category), // Désactiver si déjà gagné
                onTap: camembertCategories.contains(category)
                    ? null // Ne rien faire si désactivé
                    : () {
                        _askCamembertQuestion(category, context); // Poser la question
                      },
              );
            }).toList(),
          ),
        ),
      );
    },
  );
}


void _askCamembertQuestion(String category, BuildContext context) {
  List<Question> categoryQuestions = questions.where((q) => q.category == category).toList();

  if (categoryQuestions.isNotEmpty) {
    Question camembertQuestion = categoryQuestions[_random.nextInt(categoryQuestions.length)];

    // Afficher la question dans une nouvelle modal
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Question de $category"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(camembertQuestion.questionText),
              SizedBox(height: 20.0),
              ...camembertQuestion.options.map((option) {
                return ElevatedButton(
                  onPressed: () {
                    bool isCorrect = option == camembertQuestion.correctAnswer;

                    if (isCorrect) {
                      _addCamembertToCurrentTeam(); // Ajouter le camembert
                      Navigator.pop(context); // Fermer la modal après bonne réponse
                      Navigator.pop(context); // Fermer la modal de choix des catégories
                    } else {
                      _correctAnswersInARow = 0; // Réinitialiser le compteur à 0 après mauvaise réponse
                      _switchTeam(); // Passer à l'autre équipe
                      Navigator.pop(context); // Fermer la modal après mauvaise réponse
                      Navigator.pop(context); // Fermer la modal de choix des catégories
                    }
                  },
                  child: Text(option),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}


void _addCamembertToCurrentTeam() {
  String currentCategory = currentQuestion.category;

  if (_currentTeam == 1) {
    _camembertEquipe1[_currentTeam]!.add(currentCategory);
  } else {
    _camembertEquipe2[_currentTeam]!.add(currentCategory);
  }

  _switchTeam(); // Passer à l'équipe suivante
  _correctAnswersInARow = 0; // Réinitialiser le compteur après la question camembert
  notifyListeners();
}



  void _switchTeam() {
    _currentTeam = _currentTeam == 1 ? 2 : 1;
  }

  void resetGame() {
    _currentQuestionIndex = 0;
    _scoreEquipe1 = 0;
    _scoreEquipe2 = 0;
    _currentTeam = 1;
    _correctAnswersInARow = 0;
    _camembertEquipe1.clear();
    _camembertEquipe2.clear();
    notifyListeners();
  }
}
