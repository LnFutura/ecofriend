const express = require('express');
const router = express.Router();
const {
  getAllAchievements,
  getAchievementById,
  createAchievement,
  updateAchievement,
  deleteAchievement,
  grantAchievement,
  getMyAchievements,
  getAchievementsStatus,
  getTitlesStatus
} = require('../controllers/achievementController');
const { protect, authorize } = require('../middleware/auth');

// Публичные маршруты
router.get('/', getAllAchievements);

// Защищенные маршруты (требуют авторизации)
router.get('/my', protect, getMyAchievements);
router.get('/status', protect, getAchievementsStatus);
router.get('/titles/status', protect, getTitlesStatus);

// Админские маршруты
router.post('/', protect, authorize('admin', 'moderator'), createAchievement);
router.put('/:id', protect, authorize('admin', 'moderator'), updateAchievement);
router.delete('/:id', protect, authorize('admin'), deleteAchievement);
router.post('/:code/grant/:userId', protect, authorize('admin', 'moderator'), grantAchievement);

// Публичный маршрут по ID (должен быть последним из-за :id)
router.get('/:id', getAchievementById);

module.exports = router;

