class Quiz {
  final String id;
  final String title;
  final String courseId;
  final List<Question> questions;
  final int passingScore;
  final int pointsReward;

  Quiz({
    required this.id,
    required this.title,
    required this.courseId,
    required this.questions,
    required this.passingScore,
    required this.pointsReward,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      courseId: json['course'] ?? '',
      questions: (json['questions'] as List<dynamic>?)
              ?.map((q) => Question.fromJson(q))
              .toList() ??
          [],
      passingScore: json['passingScore'] ?? 70,
      pointsReward: json['pointsReward'] ?? 50,
    );
  }
}

class Question {
  final String question;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'] ?? '',
    );
  }
}

