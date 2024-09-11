import 'dart:math';
import 'package:flutter/material.dart';
import '../models/question.dart';

class GameProvider with ChangeNotifier {
  List<Question> _questions = [
    // Géographie
    Question(
      questionText: "Quelle est la capitale de la France ?",
      options: ["Paris", "Lyon", "Marseille", "Bordeaux"],
      correctAnswer: "Paris",
      category: "Géographie",
    ),
    Question(
      questionText: "Quel pays a la plus grande superficie ?",
      options: ["Russie", "Canada", "Chine", "États-Unis"],
      correctAnswer: "Russie",
      category: "Géographie",
    ),
    Question(
      questionText: "Quelle est la plus haute montagne du monde ?",
      options: ["Everest", "K2", "Kangchenjunga", "Makalu"],
      correctAnswer: "Everest",
      category: "Géographie",
    ),
    // Littérature
    Question(
      questionText: "Qui a écrit 'Les Misérables' ?",
      options: ["Victor Hugo", "Émile Zola", "Albert Camus", "Voltaire"],
      correctAnswer: "Victor Hugo",
      category: "Littérature",
    ),
    Question(
      questionText: "Quel est le titre du premier livre de Harry Potter ?",
      options: [
        "Harry Potter et la Chambre des Secrets",
        "Harry Potter à l'école des sorciers",
        "Harry Potter et le Prisonnier d'Azkaban",
        "Harry Potter et la Coupe de Feu"
      ],
      correctAnswer: "Harry Potter à l'école des sorciers",
      category: "Littérature",
    ),
    // Histoire
    Question(
      questionText: "En quelle année a eu lieu la Révolution française ?",
      options: ["1789", "1792", "1776", "1804"],
      correctAnswer: "1789",
      category: "Histoire",
    ),
    Question(
      questionText: "Qui était le premier empereur romain ?",
      options: ["Jules César", "Auguste", "Néron", "Tibère"],
      correctAnswer: "Auguste",
      category: "Histoire",
    ),
    // Science
    Question(
      questionText: "Quelle est la formule chimique de l'eau ?",
      options: ["H2O", "CO2", "O2", "N2"],
      correctAnswer: "H2O",
      category: "Science",
    ),
    Question(
      questionText: "Quelle planète est la plus proche du Soleil ?",
      options: ["Mercure", "Vénus", "Terre", "Mars"],
      correctAnswer: "Mercure",
      category: "Science",
    ),
    // Sport
    Question(
      questionText: "Dans quel sport peut-on marquer un touchdown ?",
      options: ["Football américain", "Basketball", "Rugby", "Baseball"],
      correctAnswer: "Football américain",
      category: "Sport",
    ),
    Question(
      questionText: "Combien de joueurs composent une équipe de football ?",
      options: ["11", "12", "9", "10"],
      correctAnswer: "11",
      category: "Sport",
    ),
    // Art
    Question(
      questionText: "Qui a peint la Joconde ?",
      options: ["Léonard de Vinci", "Pablo Picasso", "Vincent Van Gogh", "Monet"],
      correctAnswer: "Léonard de Vinci",
      category: "Art",
    ),
    Question(
      questionText: "Quel artiste est associé au cubisme ?",
      options: ["Pablo Picasso", "Salvador Dalí", "Paul Cézanne", "Andy Warhol"],
      correctAnswer: "Pablo Picasso",
      category: "Art",
    ),
  ];

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

  bool get hasNextQuestion => _currentQuestionIndex < _questions.length;
  int get currentTeam => _currentTeam;
  Question get currentQuestion => _questions[_currentQuestionIndex];

  int getCamembertProgress(int team) {
    return team == 1 ? _camembertEquipe1[team]!.length : _camembertEquipe2[team]!.length;
  }

  bool hasWon(int team) {
    return getCamembertProgress(team) >= MAX_CAMEMBERTS;
  }

  Question getRandomQuestion() {
    List<Question> availableQuestions = _questions.where((question) {
      Set<String> camembertCategories = _currentTeam == 1
          ? _camembertEquipe1[_currentTeam]!
          : _camembertEquipe2[_currentTeam]!;
      return !camembertCategories.contains(question.category);
    }).toList();

    if (availableQuestions.isEmpty) {
      resetGame();
      return _questions[0];
    }

    return availableQuestions[_random.nextInt(availableQuestions.length)];
  }

void answerQuestion(String answer, BuildContext context) {
  bool isCorrect = currentQuestion.correctAnswer == answer;

  if (isCorrect) {
    _correctAnswersInARow++;

    // Si on atteint 3 bonnes réponses consécutives, on pose une question camembert
    if (_correctAnswersInARow >= CAMEMBERT_REQUIRED_ANSWERS) {
      _correctAnswersInARow = 0; // Réinitialiser à zéro
      chooseCamembertCategory(context); // Afficher la question camembert
      return;
    }
  } else {
    _switchTeam();
    _correctAnswersInARow = 0; // Réinitialiser le compteur si la réponse est fausse
  }

  // Passer à la question suivante
  if (_currentQuestionIndex < _questions.length - 1) {
    _currentQuestionIndex++;
  } else {
    print('Toutes les questions ont été répondues.');
    resetGame();
  }

  notifyListeners();
}



  void chooseCamembertCategory(BuildContext context) {
    List<String> availableCategories = _questions.map((q) => q.category).toSet().toList();
    Set<String> camembertCategories = _currentTeam == 1
        ? _camembertEquipe1[_currentTeam]!
        : _camembertEquipe2[_currentTeam]!;

    availableCategories.removeWhere((category) => camembertCategories.contains(category));

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
                  onTap: () {
                    _askCamembertQuestion(category);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _askCamembertQuestion(String category) {
    List<Question> categoryQuestions = _questions.where((q) => q.category == category).toList();
    if (categoryQuestions.isNotEmpty) {
      _currentQuestionIndex = _questions.indexOf(categoryQuestions[_random.nextInt(categoryQuestions.length)]);
      notifyListeners();
    }
  }

  void _addCamembertToCurrentTeam() {
    String currentCategory = currentQuestion.category;
    if (_currentTeam == 1) {
      _camembertEquipe1[_currentTeam]!.add(currentCategory);
    } else {
      _camembertEquipe2[_currentTeam]!.add(currentCategory);
    }

    _switchTeam();
    _correctAnswersInARow = 0;
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
