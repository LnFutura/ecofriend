const express = require('express');
const router = express.Router();
const {
  getAllAchievements,
  getAchievementById,
  createAchievement,
  updateAchievement,
  deleteAchievement,
  unlockAchievement,
  getMyAchievements
} = require('../controllers/achievementController');
const { protect, authorize } = require('../middleware/auth');

// Публичные маршруты
router.get('/', getAllAchievements);
router.get('/:id', getAchievementById);

// Защищенные маршруты (требуют авторизации)
router.get('/my/all', protect, getMyAchievements);
router.post('/:id/unlock', protect, unlockAchievement);

// Админские маршруты
router.post('/', protect, authorize('admin', 'moderator'), createAchievement);
router.put('/:id', protect, authorize('admin', 'moderator'), updateAchievement);
router.delete('/:id', protect, authorize('admin'), deleteAchievement);

module.exports = router;

