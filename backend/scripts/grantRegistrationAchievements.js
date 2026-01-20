const mongoose = require('mongoose');
const Achievement = require('../models/Achievement');
const Profile = require('../models/Profile');
require('dotenv').config();

const grantRegistrationAchievements = async () => {
  try {
    // Подключаемся к MongoDB
    const mongoUri = process.env.MONGO_URI || 'mongodb://admin:admin123@localhost:27017/ecodrug?authSource=admin';
    await mongoose.connect(mongoUri);
    console.log('Connected to MongoDB');

    // Получаем все достижения за регистрацию (Суслент + Рыбовой)
    const registrationAchievements = await Achievement.find({
      conditionType: 'registration'
    });

    console.log(`Found ${registrationAchievements.length} registration achievements:`);
    registrationAchievements.forEach(a => console.log(`  - ${a.code}: ${a.name}`));

    // Получаем все профили
    const profiles = await Profile.find();
    console.log(`\nFound ${profiles.length} profiles to check`);

    let grantedCount = 0;

    for (const profile of profiles) {
      const existingAchievementIds = new Set(
        profile.achievements.map(a => a.achievement.toString())
      );

      let pointsToAdd = 0;
      const achievementsToAdd = [];

      for (const achievement of registrationAchievements) {
        if (!existingAchievementIds.has(achievement._id.toString())) {
          achievementsToAdd.push({
            achievement: achievement._id,
            unlockedAt: new Date()
          });
          pointsToAdd += achievement.points;
          console.log(`  Granting ${achievement.code} to profile ${profile._id}`);
        }
      }

      if (achievementsToAdd.length > 0) {
        profile.achievements.push(...achievementsToAdd);
        profile.points += pointsToAdd;
        await profile.save();
        grantedCount++;
      }
    }

    console.log(`\nGranted achievements to ${grantedCount} profiles`);
    console.log('Done!');
    process.exit(0);
  } catch (error) {
    console.error('Error:', error);
    process.exit(1);
  }
};

grantRegistrationAchievements();
