class Question {
  final String questionText;
  final List<String> options;
  final String correctAnswer;
  final String category; // Nouveau champ pour la catégorie

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.category,
  });
}
