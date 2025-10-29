const mongoose = require('mongoose');

const organizationSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    unique: true
  },
  name: {
    type: String,
    required: [true, 'Название организации обязательно'],
    trim: true
  },
  type: {
    type: String,
    enum: ['ngo', 'company', 'government', 'educational', 'other'],
    required: true
  },
  description: {
    type: String,
    maxlength: [1000, 'Описание не должно превышать 1000 символов']
  },
  website: String,
  email: {
    type: String,
    lowercase: true
  },
  phone: String,
  address: String,
  logo: String,
  documents: [String], // URLs документов для верификации
  verified: {
    type: Boolean,
    default: false
  },
  verifiedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User' // admin кто верифицировал
  },
  verificationDate: Date,
  socialLinks: {
    facebook: String,
    instagram: String,
    vk: String,
    telegram: String,
    twitter: String
  }
}, {
  timestamps: true
});

// Индексы
organizationSchema.index({ user: 1 });
organizationSchema.index({ verified: 1 });
organizationSchema.index({ type: 1 });

// Метод для верификации
organizationSchema.methods.verify = function(adminId) {
  this.verified = true;
  this.verifiedBy = adminId;
  this.verificationDate = new Date();
  return this.save();
};

module.exports = mongoose.model('Organization', organizationSchema);

