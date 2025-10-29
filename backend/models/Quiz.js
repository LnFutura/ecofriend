const mongoose = require('mongoose');

const quizSchema = new mongoose.Schema({
  course: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Course',
    required: true
  },
  questions: [{
    question: {
      type: String,
      required: true
    },
    type: {
      type: String,
      enum: ['multiple_choice', 'true_false', 'text'],
      default: 'multiple_choice'
    },
    options: [String], // для multiple_choice
    correctAnswer: {
      type: mongoose.Schema.Types.Mixed, // может быть String или Number (индекс)
      required: true
    },
    explanation: String, // объяснение правильного ответа
    points: {
      type: Number,
      default: 10,
      min: 1
    }
  }],
  passingScore: {
    type: Number, // процент
    default: 70,
    min: 0,
    max: 100
  },
  timeLimit: {
    type: Number, // время в минутах (опционально)
    min: 1
  }
}, {
  timestamps: true
});

// Индекс
quizSchema.index({ course: 1 });

// Метод для подсчета максимального количества баллов
quizSchema.methods.getMaxScore = function() {
  return this.questions.reduce((sum, q) => sum + q.points, 0);
};

// Метод для проверки ответов
quizSchema.methods.checkAnswers = function(userAnswers) {
  let score = 0;
  const results = [];

  this.questions.forEach((question, index) => {
    const userAnswer = userAnswers[index];
    let isCorrect = false;

    if (question.type === 'multiple_choice') {
      isCorrect = userAnswer === question.correctAnswer || 
                  userAnswer === question.options[question.correctAnswer];
    } else if (question.type === 'true_false') {
      isCorrect = userAnswer.toString().toLowerCase() === question.correctAnswer.toString().toLowerCase();
    } else if (question.type === 'text') {
      isCorrect = userAnswer.toLowerCase().trim() === question.correctAnswer.toLowerCase().trim();
    }

    if (isCorrect) {
      score += question.points;
    }

    results.push({
      questionIndex: index,
      question: question.question,
      userAnswer,
      correctAnswer: question.correctAnswer,
      isCorrect,
      points: isCorrect ? question.points : 0,
      explanation: question.explanation
    });
  });

  const maxScore = this.getMaxScore();
  const percentage = (score / maxScore) * 100;
  const passed = percentage >= this.passingScore;

  return {
    score,
    maxScore,
    percentage: percentage.toFixed(1),
    passed,
    results
  };
};

module.exports = mongoose.model('Quiz', quizSchema);

