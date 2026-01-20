const Achievement = require('../models/Achievement');
const Profile = require('../models/Profile');
const Course = require('../models/Course');

// @desc    Получить все достижения
// @route   GET /api/achievements
// @access  Public
exports.getAllAchievements = async (req, res, next) => {
  try {
    const { type, rarity } = req.query;
    
    const filter = {};
    if (type) filter.type = type;
    if (rarity) filter.rarity = rarity;

    const achievements = await Achievement.find(filter).sort({ order: 1 });

    res.status(200).json({
      success: true,
      count: achievements.length,
      data: achievements
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Получить конкретное достижение
// @route   GET /api/achievements/:id
// @access  Public
exports.getAchievementById = async (req, res, next) => {
  try {
    const achievement = await Achievement.findById(req.params.id);

    if (!achievement) {
      return res.status(404).json({
        success: false,
        message: 'Достижение не найдено'
      });
    }

    res.status(200).json({
      success: true,
      data: achievement
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Создать новое достижение
// @route   POST /api/achievements
// @access  Private (Admin)
exports.createAchievement = async (req, res, next) => {
  try {
    const achievement = await Achievement.create(req.body);

    res.status(201).json({
      success: true,
      data: achievement
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Обновить достижение
// @route   PUT /api/achievements/:id
// @access  Private (Admin)
exports.updateAchievement = async (req, res, next) => {
  try {
    const achievement = await Achievement.findByIdAndUpdate(
      req.params.id,
      req.body,
      {
        new: true,
        runValidators: true
      }
    );

    if (!achievement) {
      return res.status(404).json({
        success: false,
        message: 'Достижение не найдено'
      });
    }

    res.status(200).json({
      success: true,
      data: achievement
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Удалить достижение
// @route   DELETE /api/achievements/:id
// @access  Private (Admin)
exports.deleteAchievement = async (req, res, next) => {
  try {
    const achievement = await Achievement.findByIdAndDelete(req.params.id);

    if (!achievement) {
      return res.status(404).json({
        success: false,
        message: 'Достижение не найдено'
      });
    }

    res.status(200).json({
      success: true,
      message: 'Достижение удалено'
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Разблокировать достижение для пользователя (ручная выдача модератором)
// @route   POST /api/achievements/:code/grant/:userId
// @access  Private (Admin)
exports.grantAchievement = async (req, res, next) => {
  try {
    const achievement = await Achievement.findOne({ code: req.params.code });

    if (!achievement) {
      return res.status(404).json({
        success: false,
        message: 'Достижение не найдено'
      });
    }

    const profile = await Profile.findOne({ user: req.params.userId });

    if (!profile) {
      return res.status(404).json({
        success: false,
        message: 'Профиль не найден'
      });
    }

    // Проверяем, что достижение еще не получено
    const alreadyHas = profile.achievements.some(
      a => a.achievement && a.achievement.toString() === achievement._id.toString()
    );
    
    if (alreadyHas) {
      return res.status(400).json({
        success: false,
        message: 'Достижение уже получено'
      });
    }

    // Добавляем достижение и начисляем очки
    profile.achievements.push({
      achievement: achievement._id,
      unlockedAt: new Date()
    });
    profile.points += achievement.points;

    await profile.save();

    res.status(200).json({
      success: true,
      message: 'Достижение выдано!',
      data: {
        achievement,
        earnedPoints: achievement.points,
        totalPoints: profile.points
      }
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Получить достижения текущего пользователя
// @route   GET /api/achievements/my
// @access  Private
exports.getMyAchievements = async (req, res, next) => {
  try {
    const profile = await Profile.findOne({ user: req.user.id })
      .populate('achievements.achievement');

    if (!profile) {
      return res.status(404).json({
        success: false,
        message: 'Профиль не найден'
      });
    }

    // Преобразуем в удобный формат
    const userAchievements = profile.achievements.map(a => ({
      ...a.achievement.toObject(),
      unlockedAt: a.unlockedAt
    }));

    res.status(200).json({
      success: true,
      count: userAchievements.length,
      data: userAchievements
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Получить все достижения с информацией о разблокировке для текущего пользователя
// @route   GET /api/achievements/status
// @access  Private
exports.getAchievementsStatus = async (req, res, next) => {
  try {
    // Получаем все достижения
    const allAchievements = await Achievement.find().sort({ order: 1 });
    
    // Получаем достижения пользователя
    const profile = await Profile.findOne({ user: req.user.id });
    
    if (!profile) {
      return res.status(404).json({
        success: false,
        message: 'Профиль не найден'
      });
    }

    // Создаем Set для быстрой проверки
    const unlockedIds = new Set(
      profile.achievements.map(a => a.achievement.toString())
    );
    const unlockedDates = {};
    profile.achievements.forEach(a => {
      unlockedDates[a.achievement.toString()] = a.unlockedAt;
    });

    // Формируем ответ
    const achievementsWithStatus = allAchievements.map(achievement => ({
      ...achievement.toObject(),
      isUnlocked: unlockedIds.has(achievement._id.toString()),
      unlockedAt: unlockedDates[achievement._id.toString()] || null
    }));

    res.status(200).json({
      success: true,
      count: achievementsWithStatus.length,
      data: achievementsWithStatus
    });
  } catch (error) {
    next(error);
  }
};

// Вспомогательная функция для выдачи достижения пользователю
exports.grantAchievementToUser = async (userId, achievementCode) => {
  try {
    const achievement = await Achievement.findOne({ code: achievementCode });
    if (!achievement) return null;

    const profile = await Profile.findOne({ user: userId });
    if (!profile) return null;

    // Проверяем, что достижение еще не получено
    const alreadyHas = profile.achievements.some(
      a => a.achievement && a.achievement.toString() === achievement._id.toString()
    );
    
    if (alreadyHas) return null;

    // Добавляем достижение
    profile.achievements.push({
      achievement: achievement._id,
      unlockedAt: new Date()
    });
    profile.points += achievement.points;

    await profile.save();
    return achievement;
  } catch (error) {
    console.error('Error granting achievement:', error);
    return null;
  }
};

// Функция проверки и выдачи достижений за курсы
exports.checkCourseAchievements = async (userId) => {
  try {
    const profile = await Profile.findOne({ user: userId }).populate('completedCourses');
    if (!profile) return;

    // Получаем все курсы
    const allCourses = await Course.find();
    const basicCourses = allCourses.filter(c => c.type === 'basic');
    const additionalCourses = allCourses.filter(c => c.type === 'additional');

    const completedIds = new Set(profile.completedCourses.map(c => c._id.toString()));

    // Проверяем barsukavr (все основные курсы)
    const allBasicCompleted = basicCourses.every(c => completedIds.has(c._id.toString()));
    if (allBasicCompleted && basicCourses.length > 0) {
      await exports.grantAchievementToUser(userId, 'barsukavr');
    }

    // Проверяем morzhist (все дополнительные курсы)
    const allAdditionalCompleted = additionalCourses.every(c => completedIds.has(c._id.toString()));
    if (allAdditionalCompleted && additionalCourses.length > 0) {
      await exports.grantAchievementToUser(userId, 'morzhist');
    }
  } catch (error) {
    console.error('Error checking course achievements:', error);
  }
};

// Функция проверки и выдачи звания Сурикант за прохождение теста
exports.checkQuizAchievements = async (userId) => {
  try {
    // Сурикант выдается за прохождение хотя бы одного теста
    // Просто выдаем его - если уже есть, grantAchievementToUser вернет null
    await exports.grantAchievementToUser(userId, 'syrikant');
  } catch (error) {
    console.error('Error checking quiz achievements:', error);
  }
};

// Функция проверки и выдачи званий за экопоходы
exports.checkEcoHikeAchievements = async (userId, participationCount, organizationCount) => {
  try {
    // Получаем все звания за участие в экопоходах
    const participationTitles = await Achievement.find({
      type: 'title',
      conditionType: 'eco_hike_participation'
    }).sort({ requiredCount: 1 });

    // Получаем все звания за организацию экопоходов
    const organizationTitles = await Achievement.find({
      type: 'title',
      conditionType: 'eco_hike_organization'
    }).sort({ requiredCount: 1 });

    // Выдаём звания за участие
    for (const title of participationTitles) {
      if (participationCount >= title.requiredCount) {
        await exports.grantAchievementToUser(userId, title.code);
      }
    }

    // Выдаём звания за организацию
    for (const title of organizationTitles) {
      if (organizationCount >= title.requiredCount) {
        await exports.grantAchievementToUser(userId, title.code);
      }
    }
  } catch (error) {
    console.error('Error checking eco hike achievements:', error);
  }
};

// @desc    Получить все звания с информацией о разблокировке для текущего пользователя
// @route   GET /api/achievements/titles/status
// @access  Private
exports.getTitlesStatus = async (req, res, next) => {
  try {
    // Получаем все звания
    const allTitles = await Achievement.find({ type: 'title' }).sort({ order: 1 });
    
    // Получаем достижения пользователя
    const profile = await Profile.findOne({ user: req.user.id });
    
    if (!profile) {
      return res.status(404).json({
        success: false,
        message: 'Профиль не найден'
      });
    }

    // Создаем Set для быстрой проверки
    const unlockedIds = new Set(
      profile.achievements.map(a => a.achievement.toString())
    );
    const unlockedDates = {};
    profile.achievements.forEach(a => {
      unlockedDates[a.achievement.toString()] = a.unlockedAt;
    });

    // Формируем ответ
    const titlesWithStatus = allTitles.map(title => ({
      ...title.toObject(),
      isUnlocked: unlockedIds.has(title._id.toString()),
      unlockedAt: unlockedDates[title._id.toString()] || null
    }));

    res.status(200).json({
      success: true,
      count: titlesWithStatus.length,
      data: titlesWithStatus
    });
  } catch (error) {
    next(error);
  }
};

