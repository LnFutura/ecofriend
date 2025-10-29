const Challenge = require('../models/Challenge');
const Profile = require('../models/Profile');

// @desc    Получить все активные челленджи
// @route   GET /api/challenges
// @access  Public
exports.getAllChallenges = async (req, res, next) => {
  try {
    const { type, active } = req.query;
    
    const filter = {};
    if (type) filter.type = type;
    if (active !== undefined) filter.active = active === 'true';

    const challenges = await Challenge.find(filter)
      .populate('reward.achievement')
      .sort({ startDate: -1 });

    // Фильтруем только активные по датам
    const now = new Date();
    const activeChallenges = challenges.filter(c => {
      return c.active && c.startDate <= now && c.endDate >= now;
    });

    res.status(200).json({
      success: true,
      count: activeChallenges.length,
      data: activeChallenges
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Получить конкретный челлендж
// @route   GET /api/challenges/:id
// @access  Public
exports.getChallengeById = async (req, res, next) => {
  try {
    const challenge = await Challenge.findById(req.params.id)
      .populate('reward.achievement')
      .populate('participants.user', 'username');

    if (!challenge) {
      return res.status(404).json({
        success: false,
        message: 'Челлендж не найден'
      });
    }

    res.status(200).json({
      success: true,
      data: challenge
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Создать новый челлендж
// @route   POST /api/challenges
// @access  Private (Admin)
exports.createChallenge = async (req, res, next) => {
  try {
    const challenge = await Challenge.create(req.body);

    res.status(201).json({
      success: true,
      data: challenge
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Присоединиться к челленджу
// @route   POST /api/challenges/:id/join
// @access  Private
exports.joinChallenge = async (req, res, next) => {
  try {
    const challenge = await Challenge.findById(req.params.id);

    if (!challenge) {
      return res.status(404).json({
        success: false,
        message: 'Челлендж не найден'
      });
    }

    if (!challenge.isActive()) {
      return res.status(400).json({
        success: false,
        message: 'Челлендж не активен'
      });
    }

    // Проверяем, что пользователь еще не участвует
    const alreadyJoined = challenge.participants.some(
      p => p.user.toString() === req.user.id
    );

    if (alreadyJoined) {
      return res.status(400).json({
        success: false,
        message: 'Вы уже участвуете в этом челлендже'
      });
    }

    await challenge.addParticipant(req.user.id);

    res.status(200).json({
      success: true,
      message: 'Вы присоединились к челленджу!',
      data: challenge
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Обновить прогресс в челлендже
// @route   PUT /api/challenges/:id/progress
// @access  Private
exports.updateProgress = async (req, res, next) => {
  try {
    const { progress } = req.body;

    if (progress === undefined || progress < 0) {
      return res.status(400).json({
        success: false,
        message: 'Некорректное значение прогресса'
      });
    }

    const challenge = await Challenge.findById(req.params.id);

    if (!challenge) {
      return res.status(404).json({
        success: false,
        message: 'Челлендж не найден'
      });
    }

    // Проверяем участие
    const participant = challenge.participants.find(
      p => p.user.toString() === req.user.id
    );

    if (!participant) {
      return res.status(400).json({
        success: false,
        message: 'Вы не участвуете в этом челлендже'
      });
    }

    await challenge.updateProgress(req.user.id, progress);

    // Если челлендж завершен, начисляем награду
    if (participant.completed) {
      const profile = await Profile.findOne({ user: req.user.id });
      if (profile && challenge.reward.points) {
        profile.points += challenge.reward.points;
        await profile.save();
      }
    }

    res.status(200).json({
      success: true,
      message: participant.completed ? 'Челлендж завершен! Поздравляем!' : 'Прогресс обновлен',
      data: {
        progress: participant.progress,
        target: challenge.goal.target,
        completed: participant.completed,
        reward: participant.completed ? challenge.reward : null
      }
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Получить мои челленджи
// @route   GET /api/challenges/my
// @access  Private
exports.getMyChallenges = async (req, res, next) => {
  try {
    const challenges = await Challenge.find({
      'participants.user': req.user.id
    }).populate('reward.achievement');

    // Получаем данные участия
    const myChallenges = challenges.map(challenge => {
      const participant = challenge.participants.find(
        p => p.user.toString() === req.user.id
      );
      
      return {
        ...challenge.toObject(),
        myProgress: participant.progress,
        myCompleted: participant.completed,
        myCompletedAt: participant.completedAt
      };
    });

    res.status(200).json({
      success: true,
      count: myChallenges.length,
      data: myChallenges
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Деактивировать челлендж
// @route   PUT /api/challenges/:id/deactivate
// @access  Private (Admin)
exports.deactivateChallenge = async (req, res, next) => {
  try {
    const challenge = await Challenge.findByIdAndUpdate(
      req.params.id,
      { active: false },
      { new: true }
    );

    if (!challenge) {
      return res.status(404).json({
        success: false,
        message: 'Челлендж не найден'
      });
    }

    res.status(200).json({
      success: true,
      message: 'Челлендж деактивирован',
      data: challenge
    });
  } catch (error) {
    next(error);
  }
};

