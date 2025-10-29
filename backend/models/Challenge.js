const mongoose = require('mongoose');

const challengeSchema = new mongoose.Schema({
  title: {
    type: String,
    required: [true, 'Название челленджа обязательно'],
    trim: true,
    maxlength: [200, 'Название не должно превышать 200 символов']
  },
  description: {
    type: String,
    required: [true, 'Описание челленджа обязательно'],
    maxlength: [1000, 'Описание не должно превышать 1000 символов']
  },
  type: {
    type: String,
    enum: ['daily', 'weekly', 'monthly', 'special'],
    required: true
  },
  startDate: {
    type: Date,
    required: true
  },
  endDate: {
    type: Date,
    required: true
  },
  goal: {
    type: {
      type: String,
      required: true,
      // Например: 'complete_courses', 'attend_events', 'earn_points', 'add_recycling_points'
    },
    target: {
      type: Number,
      required: true,
      min: 1
    }
  },
  reward: {
    points: {
      type: Number,
      default: 0,
      min: 0
    },
    achievement: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Achievement'
    }
  },
  participants: [{
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true
    },
    progress: {
      type: Number,
      default: 0,
      min: 0
    },
    completed: {
      type: Boolean,
      default: false
    },
    completedAt: Date
  }],
  active: {
    type: Boolean,
    default: true
  }
}, {
  timestamps: true
});

// Индексы
challengeSchema.index({ type: 1, active: 1 });
challengeSchema.index({ startDate: 1, endDate: 1 });
challengeSchema.index({ 'participants.user': 1 });

// Метод для проверки активности челленджа
challengeSchema.methods.isActive = function() {
  const now = new Date();
  return this.active && this.startDate <= now && this.endDate >= now;
};

// Метод для добавления участника
challengeSchema.methods.addParticipant = function(userId) {
  const exists = this.participants.some(p => p.user.toString() === userId.toString());
  if (!exists) {
    this.participants.push({ user: userId, progress: 0, completed: false });
  }
  return this.save();
};

// Метод для обновления прогресса
challengeSchema.methods.updateProgress = function(userId, progress) {
  const participant = this.participants.find(p => p.user.toString() === userId.toString());
  if (participant) {
    participant.progress = progress;
    if (progress >= this.goal.target && !participant.completed) {
      participant.completed = true;
      participant.completedAt = new Date();
    }
  }
  return this.save();
};

module.exports = mongoose.model('Challenge', challengeSchema);

