const mongoose = require('mongoose');

const achievementSchema = new mongoose.Schema({
  code: {
    type: String,
    required: [true, 'Код достижения обязателен'],
    unique: true,
    trim: true,
    // suslet, barsukavr, morzhist, kandidat, doktor, rabbit, boar, bear, rhino
  },
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
  iconPath: {
    type: String,
    required: true,
    // Путь к иконке на фронтенде
  },
  type: {
    type: String,
    enum: ['degree', 'award', 'title'],
    required: true
  },
  // Для degree: purple, red, green (цвет рамки)
  colorType: {
    type: String,
    enum: ['purple', 'red', 'green', null],
    default: null
  },
  // Автоматическая проверка или ручная выдача модератором
  autoCheck: {
    type: Boolean,
    default: false
  },
  // Тип условия для автоматической проверки
  conditionType: {
    type: String,
    enum: [
      'registration',                  // За регистрацию (Суслент, Рыбовой)
      'complete_basic_courses',        // За прохождение основных курсов (Барсукавр)
      'complete_additional_courses',   // За прохождение доп. курсов (Моржистр)
      'complete_quiz',                 // За прохождение одного теста (Сурикант)
      'eco_hike_participation',        // За участие в экопоходах (титулы)
      'eco_hike_organization',         // За организацию экопоходов (титулы)
      'manual',                        // Ручная выдача модератором
      null
    ],
    default: null
  },
  // Требуемое количество (для eco_hike_participation/organization)
  requiredCount: {
    type: Number,
    default: 0
  },
  // Порядок отображения
  order: {
    type: Number,
    default: 0
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
achievementSchema.index({ code: 1 });
achievementSchema.index({ type: 1 });
achievementSchema.index({ order: 1 });

module.exports = mongoose.model('Achievement', achievementSchema);

