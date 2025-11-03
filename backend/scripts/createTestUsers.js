const mongoose = require('mongoose');
const User = require('../models/User');
const Profile = require('../models/Profile');
require('dotenv').config();

const testUsers = [
  {
    email: 'admin@ecodrug.ru',
    username: 'admin',
    password: 'admin123',
    role: 'admin',
    profileData: {
      fullName: 'Администратор ЭкоДруг',
      points: 1000,
      level: 10,
    },
  },
  {
    email: 'moderator@ecodrug.ru',
    username: 'moderator',
    password: 'moderator123',
    role: 'moderator',
    profileData: {
      fullName: 'Модератор Иван',
      points: 500,
      level: 5,
    },
  },
  {
    email: 'org@ecodrug.ru',
    username: 'ecoorganization',
    password: 'org123456',
    role: 'organization',
    profileData: {
      fullName: 'ЭкоОрганизация "Зелёный Мир"',
      points: 800,
      level: 7,
    },
  },
  {
    email: 'ecouser@ecodrug.ru',
    username: 'ecouser',
    password: 'user123456',
    role: 'user',
    profileData: {
      fullName: 'Тестовый Пользователь',
      points: 150,
      level: 2,
    },
  },
];

const createTestUsers = async () => {
  try {
    // Подключение к MongoDB
    const mongoUri = process.env.MONGO_URI || 'mongodb://admin:admin123@localhost:27017/ecodrug?authSource=admin';
    await mongoose.connect(mongoUri);
    
    console.log('✅ Connected to MongoDB\n');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('🎯 Создание тестовых пользователей...\n');

    let createdCount = 0;
    let existingCount = 0;

    for (const userData of testUsers) {
      const { email, username, password, role, profileData } = userData;

      // Проверка существования
      const existingUser = await User.findOne({ 
        $or: [{ email }, { username }] 
      });

      if (existingUser) {
        console.log(`⚠️  ${role.toUpperCase()}: уже существует`);
        console.log(`   📧 ${email}`);
        existingCount++;
        continue;
      }

      // Создание пользователя
      const user = await User.create({
        email,
        username,
        password,
        role,
        isVerified: true,
      });

      // Создание профиля
      const profile = await Profile.create({
        user: user._id,
        ...profileData,
      });

      // Связывание профиля с пользователем
      user.profile = profile._id;
      await user.save();

      console.log(`✅ ${role.toUpperCase()}: создан`);
      console.log(`   📧 Email: ${email}`);
      console.log(`   👤 Username: ${username}`);
      console.log(`   🔑 Password: ${password}`);
      createdCount++;
    }

    console.log('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('📊 Итоги:');
    console.log(`   ✅ Создано: ${createdCount}`);
    console.log(`   ⚠️  Уже существовало: ${existingCount}`);
    console.log(`   📝 Всего пользователей: ${testUsers.length}`);
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

    if (createdCount > 0) {
      console.log('💡 Учетные данные сохранены в файле CREDENTIALS.md\n');
    }

    process.exit(0);
  } catch (error) {
    console.error('❌ Ошибка:', error.message);
    process.exit(1);
  }
};

createTestUsers();

