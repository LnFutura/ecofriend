const Achievement = require('../models/Achievement');
const Profile = require('../models/Profile');

// @desc    Получить все достижения
// @route   GET /api/achievements
// @access  Public
exports.getAllAchievements = async (req, res, next) => {
  try {
    const { type, rarity } = req.query;
    
    const filter = {};
    if (type) filter.type = type;
    if (rarity) filter.rarity = rarity;

    const achievements = await Achievement.find(filter).sort({ rarity: -1, points: -1 });

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

// @desc    Разблокировать достижение для пользователя
// @route   POST /api/achievements/:id/unlock
// @access  Private
exports.unlockAchievement = async (req, res, next) => {
  try {
    const achievement = await Achievement.findById(req.params.id);

    if (!achievement) {
      return res.status(404).json({
        success: false,
        message: 'Достижение не найдено'
      });
    }

    const profile = await Profile.findOne({ user: req.user.id });

    if (!profile) {
      return res.status(404).json({
        success: false,
        message: 'Профиль не найден'
      });
    }

    // Проверяем, что достижение еще не получено
    if (profile.achievements.includes(achievement._id)) {
      return res.status(400).json({
        success: false,
        message: 'Достижение уже получено'
      });
    }

    // Добавляем достижение и начисляем очки
    profile.achievements.push(achievement._id);
    profile.points += achievement.points;

    await profile.save();

    res.status(200).json({
      success: true,
      message: 'Достижение разблокировано!',
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
      .populate('achievements');

    if (!profile) {
      return res.status(404).json({
        success: false,
        message: 'Профиль не найден'
      });
    }

    res.status(200).json({
      success: true,
      count: profile.achievements.length,
      data: profile.achievements
    });
  } catch (error) {
    next(error);
  }
};

