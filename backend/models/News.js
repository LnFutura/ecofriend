const mongoose = require('mongoose');

const newsSchema = new mongoose.Schema({
  title: {
    type: String,
    required: [true, 'Заголовок новости обязателен'],
    trim: true,
    maxlength: [200, 'Заголовок не должен превышать 200 символов']
  },
  content: {
    type: String,
    required: [true, 'Содержание новости обязательно']
  },
  excerpt: {
    type: String,
    maxlength: [300, 'Краткое описание не должно превышать 300 символов']
  },
  thumbnail: {
    type: String
  },
  category: {
    type: String,
    enum: ['news', 'article', 'guide', 'event_report', 'research'],
    default: 'news'
  },
  tags: [String],
  author: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  status: {
    type: String,
    enum: ['draft', 'pending', 'approved', 'rejected'],
    default: 'pending'
  },
  moderator: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  moderationNote: String,
  publishedAt: Date,
  views: {
    type: Number,
    default: 0,
    min: 0
  },
  likes: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  }],
  comments: [{
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true
    },
    text: {
      type: String,
      required: true,
      maxlength: [500, 'Комментарий не должен превышать 500 символов']
    },
    createdAt: {
      type: Date,
      default: Date.now
    }
  }]
}, {
  timestamps: true
});

// Индексы
newsSchema.index({ status: 1, publishedAt: -1 });
newsSchema.index({ author: 1, status: 1 });
newsSchema.index({ category: 1, status: 1 });
newsSchema.index({ tags: 1 });

// Автоматически устанавливаем publishedAt при одобрении
newsSchema.pre('save', function(next) {
  if (this.isModified('status') && this.status === 'approved' && !this.publishedAt) {
    this.publishedAt = new Date();
  }
  next();
});

// Метод для лайка
newsSchema.methods.toggleLike = function(userId) {
  const index = this.likes.indexOf(userId);
  if (index === -1) {
    this.likes.push(userId);
  } else {
    this.likes.splice(index, 1);
  }
  return this.save();
};

// Метод для добавления комментария
newsSchema.methods.addComment = function(userId, text) {
  this.comments.push({ user: userId, text });
  return this.save();
};

// Метод для увеличения просмотров
newsSchema.methods.incrementViews = function() {
  this.views += 1;
  return this.save();
};

module.exports = mongoose.model('News', newsSchema);

