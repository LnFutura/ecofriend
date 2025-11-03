const mongoose = require('mongoose');
const User = require('../models/User');
const Profile = require('../models/Profile');
require('dotenv').config();

const createAdmin = async () => {
  try {
    // Подключение к MongoDB
    const mongoUri = process.env.MONGO_URI || 'mongodb://admin:admin123@localhost:27017/ecodrug?authSource=admin';
    await mongoose.connect(mongoUri);
    
    console.log('✅ Connected to MongoDB');

    // Данные администратора
    const adminData = {
      email: 'admin@ecodrug.ru',
      username: 'admin',
      password: 'admin123',
      role: 'admin',
      isVerified: true,
    };

    // Проверка существования
    const existingAdmin = await User.findOne({ email: adminData.email });
    if (existingAdmin) {
      console.log('⚠️  Администратор уже существует');
      console.log('📧 Email:', adminData.email);
      console.log('👤 Username:', adminData.username);
      process.exit(0);
    }

    // Создание пользователя-администратора
    const admin = await User.create(adminData);
    console.log('✅ Администратор создан');

    // Создание профиля для администратора
    const profile = await Profile.create({
      user: admin._id,
      fullName: 'Администратор ЭкоДруг',
      points: 1000,
      level: 10,
    });
    console.log('✅ Профиль создан');

    // Связывание профиля с пользователем
    admin.profile = profile._id;
    await admin.save();

    console.log('\n🎉 Администратор успешно создан!');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('📧 Email:    admin@ecodrug.ru');
    console.log('👤 Username: admin');
    console.log('🔑 Password: admin123');
    console.log('👑 Role:     admin');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('\n💡 Используйте эти данные для входа в систему\n');

    process.exit(0);
  } catch (error) {
    console.error('❌ Ошибка при создании администратора:', error.message);
    process.exit(1);
  }
};

createAdmin();

