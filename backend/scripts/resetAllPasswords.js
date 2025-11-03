const mongoose = require('mongoose');
const User = require('../models/User');
require('dotenv').config();

const users = [
  { email: 'admin@ecodrug.ru', password: 'admin123', role: 'admin' },
  { email: 'moderator@ecodrug.ru', password: 'moderator123', role: 'moderator' },
  { email: 'org@ecodrug.ru', password: 'org123456', role: 'organization' },
  { email: 'ecouser@ecodrug.ru', password: 'user123456', role: 'user' },
];

const resetAllPasswords = async () => {
  try {
    const mongoUri = process.env.MONGO_URI || 'mongodb://admin:admin123@localhost:27017/ecodrug?authSource=admin';
    await mongoose.connect(mongoUri);
    
    console.log('✅ Connected to MongoDB\n');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('🔄 Сброс паролей для всех тестовых пользователей\n');

    for (const userData of users) {
      const user = await User.findOne({ email: userData.email });
      
      if (!user) {
        console.log(`❌ ${userData.role.toUpperCase()}: не найден (${userData.email})`);
        continue;
      }

      user.password = userData.password;
      user.isVerified = true;
      await user.save();

      console.log(`✅ ${userData.role.toUpperCase()}: пароль обновлен`);
      console.log(`   📧 ${userData.email}`);
      console.log(`   🔑 ${userData.password}`);
    }

    console.log('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('🎉 Все пароли успешно сброшены!');
    console.log('💡 Данные для входа в файле CREDENTIALS.md\n');

    process.exit(0);
  } catch (error) {
    console.error('❌ Ошибка:', error.message);
    process.exit(1);
  }
};

resetAllPasswords();

