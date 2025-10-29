const mongoose = require('mongoose');

const recyclingPointSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'Название пункта обязательно'],
    trim: true
  },
  type: [{
    type: String,
    enum: ['plastic', 'glass', 'paper', 'metal', 'electronics', 'batteries', 'clothes', 'hazardous', 'organic'],
    required: true
  }],
  address: {
    type: String,
    required: [true, 'Адрес обязателен']
  },
  city: {
    type: String,
    required: [true, 'Город обязателен']
  },
  country: {
    type: String,
    default: 'Россия'
  },
  coordinates: {
    type: {
      type: String,
      enum: ['Point'],
      default: 'Point'
    },
    coordinates: {
      type: [Number], // [longitude, latitude]
      required: [true, 'Координаты обязательны']
    }
  },
  workingHours: String,
  phone: String,
  website: String,
  description: String,
  photos: [String], // URLs фотографий
  addedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  verified: {
    type: Boolean,
    default: false
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
      ref: 'User',
      required: true
    },
    rating: {
      type: Number,
      required: true,
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

// Geo-индекс для поиска по координатам
recyclingPointSchema.index({ coordinates: '2dsphere' });
recyclingPointSchema.index({ city: 1 });
recyclingPointSchema.index({ type: 1 });
recyclingPointSchema.index({ verified: 1 });

// Виртуальное поле для количества отзывов
recyclingPointSchema.virtual('reviewCount').get(function() {
  return this.reviews.length;
});

// Метод для пересчета среднего рейтинга
recyclingPointSchema.methods.calculateAverageRating = function() {
  if (this.reviews.length === 0) {
    this.rating = 0;
  } else {
    const sum = this.reviews.reduce((acc, review) => acc + review.rating, 0);
    this.rating = (sum / this.reviews.length).toFixed(1);
  }
  return this.save();
};

// Метод для добавления отзыва
recyclingPointSchema.methods.addReview = function(userId, rating, comment) {
  // Проверяем, не оставлял ли пользователь уже отзыв
  const existingReview = this.reviews.find(r => r.user.toString() === userId.toString());
  
  if (existingReview) {
    // Обновляем существующий отзыв
    existingReview.rating = rating;
    existingReview.comment = comment;
  } else {
    // Добавляем новый отзыв
    this.reviews.push({ user: userId, rating, comment });
  }
  
  return this.calculateAverageRating();
};

// Статический метод для поиска ближайших пунктов
recyclingPointSchema.statics.findNearby = function(longitude, latitude, maxDistance = 5000, type = null) {
  const query = {
    coordinates: {
      $near: {
        $geometry: {
          type: 'Point',
          coordinates: [longitude, latitude]
        },
        $maxDistance: maxDistance // в метрах
      }
    },
    verified: true
  };

  if (type) {
    query.type = { $in: Array.isArray(type) ? type : [type] };
  }

  return this.find(query);
};

module.exports = mongoose.model('RecyclingPoint', recyclingPointSchema);

