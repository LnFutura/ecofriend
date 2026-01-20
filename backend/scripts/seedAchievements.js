const mongoose = require('mongoose');
const Achievement = require('../models/Achievement');
require('dotenv').config();

const achievements = [
  // ==================== УЧЁНЫЕ СТЕПЕНИ (degrees) ====================
  {
    code: 'suslet',
    name: 'Суслент',
    description: 'За регистрацию в приложении',
    iconPath: 'assets/icons/Эко Друг/achivementscreen/звания/Суслент.png',
    type: 'degree',
    colorType: 'purple',
    autoCheck: true,
    conditionType: 'registration',
    order: 1,
    points: 10,
    rarity: 'common'
  },
  {
    code: 'barsukavr',
    name: 'Барсукавр',
    description: 'За прохождение всех основных курсов',
    iconPath: 'assets/icons/Эко Друг/achivementscreen/звания/Барсукавр.png',
    type: 'degree',
    colorType: 'purple',
    autoCheck: true,
    conditionType: 'complete_basic_courses',
    order: 2,
    points: 50,
    rarity: 'rare'
  },
  {
    code: 'morzhist',
    name: 'Моржистр',
    description: 'За прохождение всех дополнительных курсов',
    iconPath: 'assets/icons/Эко Друг/achivementscreen/звания/Моржистр.png',
    type: 'degree',
    colorType: 'red',
    autoCheck: true,
    conditionType: 'complete_additional_courses',
    order: 3,
    points: 100,
    rarity: 'epic'
  },
  {
    code: 'kandidat',
    name: 'Кандидат лосеологических наук',
    description: 'За внедрение нового курса или участие в съёмке экофильма',
    iconPath: 'assets/icons/Эко Друг/achivementscreen/звания/Кандидат лосеологических наук.png',
    type: 'degree',
    colorType: 'green',
    autoCheck: false,
    conditionType: 'manual',
    order: 4,
    points: 200,
    rarity: 'epic'
  },
  {
    code: 'doktor',
    name: 'Доктор лосеологических наук',
    description: 'За внедрение ряда курсов или участие в съёмке ряда экофильмов',
    iconPath: 'assets/icons/Эко Друг/achivementscreen/звания/Доктор лосеологических наук.png',
    type: 'degree',
    colorType: 'green',
    autoCheck: false,
    conditionType: 'manual',
    order: 5,
    points: 500,
    rarity: 'legendary'
  },

  // ==================== ПРЕМИИ (awards) ====================
  {
    code: 'rabbit',
    name: 'Премия зайца',
    description: 'За помощь в экодвижении',
    iconPath: 'assets/icons/Эко Друг/achivementscreen/звания/rabbit.png',
    type: 'award',
    colorType: null,
    autoCheck: false,
    conditionType: 'manual',
    order: 6,
    points: 100,
    rarity: 'rare'
  },
  {
    code: 'boar',
    name: 'Премия кабана',
    description: 'За значительную помощь в экодвижении',
    iconPath: 'assets/icons/Эко Друг/achivementscreen/звания/Премия кабана.png',
    type: 'award',
    colorType: null,
    autoCheck: false,
    conditionType: 'manual',
    order: 7,
    points: 200,
    rarity: 'epic'
  },
  {
    code: 'bear',
    name: 'Премия медведя',
    description: 'За выдающуюся помощь в экодвижении',
    iconPath: 'assets/icons/Эко Друг/achivementscreen/звания/Премия медведя.png',
    type: 'award',
    colorType: null,
    autoCheck: false,
    conditionType: 'manual',
    order: 8,
    points: 300,
    rarity: 'legendary'
  },
  {
    code: 'rhino',
    name: 'Носорогиевская премия',
    description: 'Особая награда (условия получения определяются)',
    iconPath: 'assets/icons/Эко Друг/achivementscreen/звания/Носорогиевская премия.png',
    type: 'award',
    colorType: null,
    autoCheck: false,
    conditionType: 'manual',
    order: 9,
    points: 1000,
    rarity: 'legendary'
  },

  // ==================== ЗВАНИЯ (titles) ====================
  // Порядок: Рыбовой -> Сурикант -> ... -> Мамонаршл
  {
    code: 'rybovoi',
    name: 'Рыбовой',
    description: 'Начальное звание, выдается при регистрации',
    iconPath: 'assets/icons/Эко Друг/achivementscreen/звания/rybovoi1.png',
    type: 'title',
    colorType: null,
    autoCheck: true,
    conditionType: 'registration',
    requiredCount: 0,
    order: 101,
    points: 5,
    rarity: 'common'
  },
  {
    code: 'syrikant',
    name: 'Сурикант',
    description: 'За прохождение одного теста',
    iconPath: 'assets/icons/Эко Друг/achivementscreen/звания/syrikant2.png',
    type: 'title',
    colorType: null,
    autoCheck: true,
    conditionType: 'complete_quiz',
    requiredCount: 1,
    order: 102,
    points: 10,
    rarity: 'common'
  },
  {
    code: 'ml_losenant',
    name: 'Младший лосенант',
    description: 'За участие в 1 экопоходе',
    iconPath: 'assets/icons/Эко Друг/achivementscreen/звания/mllosenant3.png',
    type: 'title',
    colorType: null,
    autoCheck: true,
    conditionType: 'eco_hike_participation',
    requiredCount: 1,
    order: 103,
    points: 15,
    rarity: 'common'
  },
  {
    code: 'losenant',
    name: 'Лосенант',
    description: 'За участие в 3 экопоходах',
    iconPath: 'assets/icons/Эко Друг/achivementscreen/звания/losenant4.png',
    type: 'title',
    colorType: null,
    autoCheck: true,
    conditionType: 'eco_hike_participation',
    requiredCount: 3,
    order: 104,
    points: 25,
    rarity: 'rare'
  },
  {
    code: 'st_losenant',
    name: 'Старший лосенант',
    description: 'За участие в 5 экопоходах',
    iconPath: 'assets/icons/Эко Друг/achivementscreen/звания/stlosenant5.png',
    type: 'title',
    colorType: null,
    autoCheck: true,
    conditionType: 'eco_hike_participation',
    requiredCount: 5,
    order: 105,
    points: 40,
    rarity: 'rare'
  },
  {
    code: 'kapibatan',
    name: 'Капибатан',
    description: 'За организацию 1 экопохода',
    iconPath: 'assets/icons/Эко Друг/achivementscreen/звания/kapibatan6.png',
    type: 'title',
    colorType: null,
    autoCheck: true,
    conditionType: 'eco_hike_organization',
    requiredCount: 1,
    order: 106,
    points: 50,
    rarity: 'rare'
  },
  {
    code: 'bober',
    name: 'Бобёр',
    description: 'За участие в 10 экопоходах',
    iconPath: 'assets/icons/Эко Друг/achivementscreen/звания/bober7.png',
    type: 'title',
    colorType: null,
    autoCheck: true,
    conditionType: 'eco_hike_participation',
    requiredCount: 10,
    order: 107,
    points: 60,
    rarity: 'epic'
  },
  {
    code: 'podpavlinik',
    name: 'Подпавлинник',
    description: 'За организацию 3 экопоходов',
    iconPath: 'assets/icons/Эко Друг/achivementscreen/звания/podpavlinik8.png',
    type: 'title',
    colorType: null,
    autoCheck: true,
    conditionType: 'eco_hike_organization',
    requiredCount: 3,
    order: 108,
    points: 80,
    rarity: 'epic'
  },
  {
    code: 'pavlinik',
    name: 'Павлинник',
    description: 'За организацию 5 экопоходов',
    iconPath: 'assets/icons/Эко Друг/achivementscreen/звания/pavlinik9.png',
    type: 'title',
    colorType: null,
    autoCheck: true,
    conditionType: 'eco_hike_organization',
    requiredCount: 5,
    order: 109,
    points: 100,
    rarity: 'epic'
  },
  {
    code: 'general_bober',
    name: 'Генерал Бобёр',
    description: 'За участие в 20 экопоходах',
    iconPath: 'assets/icons/Эко Друг/achivementscreen/звания/gbober10.png',
    type: 'title',
    colorType: null,
    autoCheck: true,
    conditionType: 'eco_hike_participation',
    requiredCount: 20,
    order: 110,
    points: 150,
    rarity: 'legendary'
  },
  {
    code: 'general_losenant',
    name: 'Генерал Лосенант',
    description: 'За организацию 10 экопоходов',
    iconPath: 'assets/icons/Эко Друг/achivementscreen/звания/glosenant11.png',
    type: 'title',
    colorType: null,
    autoCheck: true,
    conditionType: 'eco_hike_organization',
    requiredCount: 10,
    order: 111,
    points: 200,
    rarity: 'legendary'
  },
  {
    code: 'general_pavlinik',
    name: 'Генерал Павлинник',
    description: 'За организацию 15 экопоходов',
    iconPath: 'assets/icons/Эко Друг/achivementscreen/звания/gpavlinik12.png',
    type: 'title',
    colorType: null,
    autoCheck: true,
    conditionType: 'eco_hike_organization',
    requiredCount: 15,
    order: 112,
    points: 300,
    rarity: 'legendary'
  },
  {
    code: 'mamonarshl',
    name: 'Мамонаршл',
    description: 'Высшее звание за организацию 20+ экопоходов',
    iconPath: 'assets/icons/Эко Друг/achivementscreen/звания/mamonarshl13.png',
    type: 'title',
    colorType: null,
    autoCheck: true,
    conditionType: 'eco_hike_organization',
    requiredCount: 20,
    order: 113,
    points: 500,
    rarity: 'legendary'
  }
];

const seedAchievements = async () => {
  try {
    // Подключаемся к MongoDB
    const mongoUri = process.env.MONGO_URI || 'mongodb://admin:admin123@localhost:27017/ecodrug?authSource=admin';
    await mongoose.connect(mongoUri);
    console.log('Connected to MongoDB');

    // Удаляем существующие достижения
    await Achievement.deleteMany({});
    console.log('Cleared existing achievements');

    // Создаём новые достижения
    const created = await Achievement.insertMany(achievements);
    console.log(`Created ${created.length} achievements:`);
    created.forEach(a => console.log(`  - ${a.code}: ${a.name}`));

    console.log('\nAchievements seeded successfully!');
    process.exit(0);
  } catch (error) {
    console.error('Error seeding achievements:', error);
    process.exit(1);
  }
};

seedAchievements();
