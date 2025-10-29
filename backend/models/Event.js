const mongoose = require('mongoose');

const eventSchema = new mongoose.Schema({
  title: {
    type: String,
    required: [true, 'Название события обязательно'],
    trim: true,
    maxlength: [200, 'Название не должно превышать 200 символов']
  },
  description: {
    type: String,
    required: [true, 'Описание события обязательно'],
    maxlength: [1000, 'Описание не должно превышать 1000 символов']
  },
  type: {
    type: String,
    enum: ['cleanup', 'workshop', 'conference', 'webinar', 'tree_planting', 'other'],
    required: true
  },
  organizer: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  date: {
    type: Date,
    required: [true, 'Дата события обязательна']
  },
  endDate: {
    type: Date
  },
  location: {
    address: String,
    city: String,
    country: {
      type: String,
      default: 'Россия'
    },
    coordinates: {
      type: [Number], // [longitude, latitude]
      index: '2dsphere'
    }
  },
  isOnline: {
    type: Boolean,
    default: false
  },
  onlineLink: String,
  capacity: {
    type: Number, // максимальное количество участников
    min: 1
  },
  registered: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  }],
  attendees: [{ // кто действительно посетил
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  }],
  thumbnail: String,
  tags: [String],
  status: {
    type: String,
    enum: ['draft', 'pending', 'approved', 'cancelled'],
    default: 'pending'
  },
  points: {
    type: Number, // награда за участие
    default: 100,
    min: 0
  }
}, {
  timestamps: true
});

// Индексы
eventSchema.index({ date: 1, status: 1 });
eventSchema.index({ organizer: 1 });
eventSchema.index({ type: 1, status: 1 });
eventSchema.index({ 'location.coordinates': '2dsphere' });

// Виртуальное поле для количества зарегистрированных
eventSchema.virtual('registeredCount').get(function() {
  return this.registered.length;
});

// Виртуальное поле для проверки заполненности
eventSchema.virtual('isFull').get(function() {
  if (!this.capacity) return false;
  return this.registered.length >= this.capacity;
});

// Виртуальное поле для проверки прошло ли событие
eventSchema.virtual('isPast').get(function() {
  return new Date() > (this.endDate || this.date);
});

// Метод для регистрации на событие
eventSchema.methods.registerUser = function(userId) {
  // Проверяем, не зарегистрирован ли уже
  if (this.registered.includes(userId)) {
    throw new Error('Вы уже зарегистрированы на это событие');
  }

  // Проверяем вместимость
  if (this.capacity && this.registered.length >= this.capacity) {
    throw new Error('Событие заполнено');
  }

  // Проверяем, не прошло ли событие
  if (this.isPast) {
    throw new Error('Событие уже прошло');
  }

  this.registered.push(userId);
  return this.save();
};

// Метод для отмены регистрации
eventSchema.methods.unregisterUser = function(userId) {
  const index = this.registered.indexOf(userId);
  if (index > -1) {
    this.registered.splice(index, 1);
  }
  return this.save();
};

// Метод для отметки посещения
eventSchema.methods.markAttendance = function(userId) {
  if (!this.registered.includes(userId)) {
    throw new Error('Пользователь не зарегистрирован на событие');
  }

  if (!this.attendees.includes(userId)) {
    this.attendees.push(userId);
  }
  return this.save();
};

module.exports = mongoose.model('Event', eventSchema);

