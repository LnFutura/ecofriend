const mongoose = require('mongoose');

const achievementSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'Название достижения обязательно'],
    trim: true,
    maxlength: [100, 'Название не должно превышать 100 символов']
  },
  description: {
    type: String,
    required: [true, 'Описание достижения обязательно'],
    maxlength: [500, 'Описание не должно превышать 500 символов']
  },
  icon: {
    type: String,
    default: '🏆'
  },
  type: {
    type: String,
    enum: ['course', 'event', 'news', 'points', 'streak', 'special'],
    required: true
  },
  condition: {
    type: {
      type: String,
      required: true,
      // Например: 'complete_courses', 'earn_points', 'attend_events', 'daily_streak'
    },
    value: {
      type: Number,
      required: true,
      min: 1
    }
  },
  points: {
    type: Number,
    default: 0,
    min: 0
  },
  rarity: {
    type: String,
    enum: ['common', 'rare', 'epic', 'legendary'],
    default: 'common'
  }
}, {
  timestamps: true
});

// Индексы для быстрого поиска
achievementSchema.index({ type: 1 });
achievementSchema.index({ rarity: 1 });

// Виртуальное поле для получения пользователей, получивших это достижение
achievementSchema.virtual('holders', {
  ref: 'Profile',
  localField: '_id',
  foreignField: 'achievements'
});

module.exports = mongoose.model('Achievement', achievementSchema);

