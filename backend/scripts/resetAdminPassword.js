const mongoose = require('mongoose');
const User = require('../models/User');
require('dotenv').config();

const resetAdminPassword = async () => {
  try {
    // Подключение к MongoDB
    const mongoUri = process.env.MONGO_URI || 'mongodb://admin:admin123@localhost:27017/ecodrug?authSource=admin';
    await mongoose.connect(mongoUri);
    
    console.log('✅ Connected to MongoDB');

    // Найти администратора
    const admin = await User.findOne({ email: 'admin@ecodrug.ru' });
    
    if (!admin) {
      console.log('❌ Администратор не найден');
      process.exit(1);
    }

    // Установить новый пароль
    admin.password = 'admin123';
    admin.isVerified = true;
    await admin.save();

    console.log('\n🎉 Пароль администратора успешно сброшен!');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('📧 Email:    admin@ecodrug.ru');
    console.log('👤 Username: admin');
    console.log('🔑 Password: admin123');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

    process.exit(0);
  } catch (error) {
    console.error('❌ Ошибка:', error.message);
    process.exit(1);
  }
};

resetAdminPassword();

