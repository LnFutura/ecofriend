require('dotenv').config();
const mongoose = require('mongoose');
const Course = require('../models/Course');
const Quiz = require('../models/Quiz');
const User = require('../models/User');

const MONGO_URI = process.env.MONGO_URI || 'mongodb://localhost:27017/ecodrug';

const basicCourses = [
  {
    title: 'Зачем сортировать мусор?',
    description: 'Обучение заботе о природе',
    category: 'recycling',
    level: 'beginner',
    duration: 15,
    points: 50,
    published: true,
    content: `Допустим, вы решили разделять отходы и сдавать их на переработку. Ура! Добро пожаловать в клуб.

Но с чего начать, как не сойти с ума, как не запутаться и не разочароваться?

1. Решите, что именно вы будете сдавать.

Не нужно пытаться избавиться от всех отходов одним махом, выучить все существующие маркировки за 24 часа и запомнить попутку приёма в вашем районе с ближайшей субботы. Если вы только начинаете, имеет смысл потренироваться на ограниченном списке сырья, отладить процесс и выработать привычку.

2. Выберите пункт приёма или компанию по вывозу.

3. Узнайте требования к сдаваемому вторсырью.

4. Организуйте хранение дома.

5. Начните действовать!`,
  },
  {
    title: 'Свалки',
    description: 'И прочие беды современного мира',
    category: 'general',
    level: 'beginner',
    duration: 20,
    points: 75,
    published: true,
    content: `Несанкционированные свалки — настоящая проблема современных городов. Они загрязняют почву, воду и воздух, создавая опасность для здоровья людей и окружающей среды.

Почему образуются свалки?
1. Недостаток контейнеров для раздельного сбора
2. Низкая экологическая грамотность населения
3. Отсутствие пунктов переработки в шаговой доступности

Что делать?
- Сортировать мусор дома
- Сдавать вторсырье в специальные пункты
- Сообщать о незаконных свалках в местные органы власти
- Участвовать в субботниках по уборке территории

Каждый может внести свой вклад в сохранение чистоты нашей планеты!`,
  },
  {
    title: 'Пластик: враг или друг?',
    description: 'Разбираемся в типах пластика',
    category: 'recycling',
    level: 'intermediate',
    duration: 25,
    points: 100,
    published: true,
    content: `Пластик окружает нас повсюду, но не весь пластик одинаково полезен и безопасен.

Типы пластика:
1. PET (1) - бутылки для воды и напитков
2. HDPE (2) - канистры, крышки
3. PVC (3) - трубы, окна (сложно перерабатывается!)
4. LDPE (4) - пакеты, пленка
5. PP (5) - контейнеры для еды
6. PS (6) - одноразовая посуда (избегайте!)
7. OTHER (7) - смешанный пластик

Что можно сдать на переработку?
✅ PET (1) - бутылки
✅ HDPE (2) - канистры
✅ LDPE (4) - чистые пакеты
✅ PP (5) - контейнеры

Что лучше избегать?
❌ PVC (3) - выделяет токсины
❌ PS (6) - почти не перерабатывается

Совет: проверяйте маркировку на упаковке перед покупкой!`,
  },
];

const additionalCourses = [
  {
    title: 'Компостирование дома',
    description: 'Особенности борьбы за экологию',
    category: 'general',
    level: 'intermediate',
    duration: 30,
    points: 80,
    published: true,
    content: `Компостирование — отличный способ переработать органические отходы и получить удобрение для растений.

Что можно компостировать?
✅ Овощные и фруктовые очистки
✅ Яичную скорлупу
✅ Чайные пакетики и кофейную гущу
✅ Бумагу и картон (без печати)
✅ Скошенную траву и листья

Что нельзя?
❌ Мясо и рыбу
❌ Молочные продукты
❌ Жиры и масла
❌ Кости

Как начать?
1. Выберите компостер (можно сделать самому)
2. Создайте слои: сухое + влажное
3. Периодически перемешивайте
4. Через 2-3 месяца компост готов!`,
  },
  {
    title: 'Zero Waste образ жизни',
    description: 'Минимизация отходов в быту',
    category: 'general',
    level: 'advanced',
    duration: 35,
    points: 120,
    published: true,
    content: `Zero Waste — философия жизни без отходов. Полностью отказаться от мусора сложно, но можно значительно его сократить.

5 принципов Zero Waste:
1. REFUSE (Отказаться) - от одноразовых вещей
2. REDUCE (Сократить) - покупай меньше
3. REUSE (Переиспользовать) - ремонтируй и дари новую жизнь
4. RECYCLE (Перерабатывать) - сортируй отходы
5. ROT (Компостировать) - органические отходы

Простые шаги:
- Используй многоразовые сумки и бутылки
- Покупай товары без упаковки
- Носи с собой контейнер для еды
- Покупай б/у вещи
- Делись и обменивайся с друзьями

Начни с малого, и постепенно это станет привычкой!`,
  },
];

const quizzes = [
  {
    title: 'Тест: Основы сортировки мусора',
    questions: [
      {
        question: 'Что вы будете сдавать?',
        options: ['Друзей', 'Врагов', 'Мусор', 'Мусорова'],
        correctAnswer: 'Мусор',
        explanation: 'Мы сортируем и сдаем мусор на переработку!',
      },
      {
        question: 'Как нужно подготавливать вторсырье?',
        options: ['Правильно', 'Неправильно'],
        correctAnswer: 'Правильно',
        explanation: 'Вторсырье нужно очищать и подготавливать правильно.',
      },
      {
        question: 'Какой пластик лучше всего перерабатывается?',
        options: ['PET (1)', 'PVC (3)', 'PS (6)', 'Любой'],
        correctAnswer: 'PET (1)',
        explanation: 'PET пластик (маркировка 1) легко перерабатывается.',
      },
      {
        question: 'Можно ли сдавать грязные бутылки?',
        options: ['Да', 'Нет', 'Не важно'],
        correctAnswer: 'Нет',
        explanation: 'Вторсырье должно быть чистым перед сдачей.',
      },
      {
        question: 'Что делать со стеклянными бутылками?',
        options: ['Выбросить', 'Сдать на переработку', 'Оставить дома', 'Закопать'],
        correctAnswer: 'Сдать на переработку',
        explanation: 'Стекло перерабатывается бесконечное количество раз!',
      },
    ],
    passingScore: 60,
    status: 'active',
  },
  {
    title: 'Тест: Свалки и их влияние',
    questions: [
      {
        question: 'Что загрязняют свалки?',
        options: ['Только почву', 'Почву, воду и воздух', 'Ничего', 'Только воздух'],
        correctAnswer: 'Почву, воду и воздух',
        explanation: 'Свалки загрязняют все компоненты окружающей среды.',
      },
      {
        question: 'Как бороться со свалками?',
        options: ['Сортировать мусор', 'Игнорировать', 'Создавать новые', 'Жаловаться'],
        correctAnswer: 'Сортировать мусор',
        explanation: 'Сортировка мусора — первый шаг к чистоте.',
      },
      {
        question: 'Можно ли участвовать в субботниках?',
        options: ['Да', 'Нет'],
        correctAnswer: 'Да',
        explanation: 'Субботники — отличный способ помочь природе!',
      },
    ],
    passingScore: 60,
    status: 'active',
  },
];

async function seedCourses() {
  try {
    await mongoose.connect(MONGO_URI);
    console.log('✅ Connected to MongoDB');

    // Получаем первого админа или создаем тестового
    let admin = await User.findOne({ role: 'admin' });
    if (!admin) {
      admin = await User.findOne();
    }
    if (!admin) {
      console.log('❌ No users found. Please create an admin user first.');
      process.exit(1);
    }
    console.log(`✅ Using author: ${admin.email}`);

    // Очищаем старые данные
    await Course.deleteMany({ category: { $in: ['recycling', 'general'] } });
    await Quiz.deleteMany({});
    console.log('🗑️  Cleared old courses and quizzes');

    // Добавляем author ко всем курсам
    const allCourses = [...basicCourses, ...additionalCourses].map(course => ({
      ...course,
      author: admin._id,
    }));

    // Создаем курсы БЕЗ квизов
    const createdCourses = await Course.insertMany(allCourses);
    console.log(`✅ Created ${createdCourses.length} courses`);

    // Создаем квизы с привязкой к курсам
    const quiz1 = {
      ...quizzes[0],
      course: createdCourses[0]._id, // "Зачем сортировать мусор?"
    };
    const quiz2 = {
      ...quizzes[1],
      course: createdCourses[1]._id, // "Свалки"
    };

    const createdQuizzes = await Quiz.insertMany([quiz1, quiz2]);
    console.log(`✅ Created ${createdQuizzes.length} quizzes`);

    // Обновляем курсы, добавляя ссылки на квизы
    await Course.findByIdAndUpdate(createdCourses[0]._id, { quiz: createdQuizzes[0]._id });
    await Course.findByIdAndUpdate(createdCourses[1]._id, { quiz: createdQuizzes[1]._id });
    console.log('✅ Linked quizzes to courses');

    console.log('\n📋 Created courses:');
    const finalCourses = await Course.find({ category: { $in: ['recycling', 'general'] } }).populate('quiz');
    finalCourses.forEach((course, index) => {
      console.log(`${index + 1}. ${course.title} (${course.category})`);
      if (course.quiz) {
        console.log(`   ✓ Has quiz with ${course.quiz.questions.length} questions`);
      }
    });

    console.log('\n🎉 Seeding completed successfully!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Error seeding courses:', error);
    process.exit(1);
  }
}

seedCourses();

