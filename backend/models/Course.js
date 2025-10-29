const mongoose = require('mongoose');

const courseSchema = new mongoose.Schema({
  title: {
    type: String,
    required: [true, 'Название курса обязательно'],
    trim: true,
    maxlength: [200, 'Название не должно превышать 200 символов']
  },
  description: {
    type: String,
    required: [true, 'Описание курса обязательно'],
    maxlength: [1000, 'Описание не должно превышать 1000 символов']
  },
  content: {
    type: String,
    required: true
  },
  category: {
    type: String,
    enum: ['recycling', 'energy', 'water', 'biodiversity', 'climate', 'general'],
    default: 'general'
  },
  level: {
    type: String,
    enum: ['beginner', 'intermediate', 'advanced'],
    default: 'beginner'
  },
  duration: {
    type: Number, // в минутах
    default: 30,
    min: 1
  },
  points: {
    type: Number, // награда за прохождение
    default: 50,
    min: 0
  },
  thumbnail: {
    type: String
  },
  author: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  modules: [{
    title: {
      type: String,
      required: true
    },
    content: {
      type: String,
      required: true
    },
    order: {
      type: Number,
      required: true
    },
    videoUrl: String,
    resources: [String] // URLs дополнительных материалов
  }],
  quiz: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Quiz'
  },
  published: {
    type: Boolean,
    default: false
  },
  enrolledCount: {
    type: Number,
    default: 0,
    min: 0
  },
  rating: {
    type: Number,
    default: 0,
    min: 0,
    max: 5
  },
  reviews: [{
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    rating: {
      type: Number,
      min: 1,
      max: 5
    },
    comment: String,
    createdAt: {
      type: Date,
      default: Date.now
    }
  }]
}, {
  timestamps: true
});

// Индексы
courseSchema.index({ category: 1, level: 1 });
courseSchema.index({ published: 1, createdAt: -1 });
courseSchema.index({ author: 1 });

// Сортировка модулей по порядку
courseSchema.pre('save', function(next) {
  if (this.modules && this.modules.length > 0) {
    this.modules.sort((a, b) => a.order - b.order);
  }
  next();
});

// Пересчет среднего рейтинга
courseSchema.methods.calculateAverageRating = function() {
  if (this.reviews.length === 0) {
    this.rating = 0;
  } else {
    const sum = this.reviews.reduce((acc, review) => acc + review.rating, 0);
    this.rating = (sum / this.reviews.length).toFixed(1);
  }
  return this.save();
};

module.exports = mongoose.model('Course', courseSchema);

