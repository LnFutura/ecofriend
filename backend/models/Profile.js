const mongoose = require('mongoose');

const ProfileSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      unique: true,
    },
    fullName: {
      type: String,
      trim: true,
    },
    avatar: {
      type: String, // URL or path to avatar image
    },
    bio: {
      type: String,
      maxlength: [500, 'Bio cannot exceed 500 characters'],
    },
    location: {
      city: String,
      country: String,
      coordinates: {
        type: [Number], // [longitude, latitude]
        index: '2dsphere',
      },
    },
    points: {
      type: Number,
      default: 0,
      min: [0, 'Points cannot be negative'],
    },
    level: {
      type: Number,
      default: 1,
      min: [1, 'Level cannot be less than 1'],
    },
    achievements: [
      {
        achievement: {
          type: mongoose.Schema.Types.ObjectId,
          ref: 'Achievement',
        },
        unlockedAt: {
          type: Date,
          default: Date.now,
        },
      },
    ],
    completedCourses: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Course',
      },
    ],
    attendedEvents: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Event',
      },
    ],
  },
  {
    timestamps: true,
  }
);

// Indexes for performance
ProfileSchema.index({ user: 1 });
ProfileSchema.index({ points: -1 }); // For leaderboard
ProfileSchema.index({ level: -1 });

// Method to calculate level based on points
ProfileSchema.methods.calculateLevel = function () {
  // Simple level calculation: level = floor(points / 100) + 1
  this.level = Math.floor(this.points / 100) + 1;
  return this.level;
};

// Method to add points
ProfileSchema.methods.addPoints = async function (amount) {
  this.points += amount;
  this.calculateLevel();
  await this.save();
  return this.points;
};

module.exports = mongoose.model('Profile', ProfileSchema);

