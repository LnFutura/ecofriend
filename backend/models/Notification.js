const mongoose = require('mongoose');

const notificationSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  type: {
    type: String,
    enum: ['event', 'challenge', 'achievement', 'news', 'system', 'moderation'],
    required: true
  },
  title: {
    type: String,
    required: [true, 'Заголовок уведомления обязателен'],
    maxlength: [100, 'Заголовок не должен превышать 100 символов']
  },
  message: {
    type: String,
    required: [true, 'Текст уведомления обязателен'],
    maxlength: [500, 'Текст не должен превышать 500 символов']
  },
  link: String, // ссылка на связанный контент
  relatedModel: String, // название модели (Event, Course, News и т.д.)
  relatedId: mongoose.Schema.Types.ObjectId, // ID связанного объекта
  read: {
    type: Boolean,
    default: false
  }
}, {
  timestamps: true
});

// Индексы
notificationSchema.index({ user: 1, read: 1, createdAt: -1 });
notificationSchema.index({ createdAt: -1 });

// Метод для отметки как прочитанного
notificationSchema.methods.markAsRead = function() {
  this.read = true;
  return this.save();
};

// Статический метод для создания уведомления
notificationSchema.statics.createNotification = async function(data) {
  return await this.create(data);
};

// Статический метод для массовой отправки
notificationSchema.statics.sendToMultipleUsers = async function(userIds, notificationData) {
  const notifications = userIds.map(userId => ({
    user: userId,
    ...notificationData
  }));
  return await this.insertMany(notifications);
};

module.exports = mongoose.model('Notification', notificationSchema);

