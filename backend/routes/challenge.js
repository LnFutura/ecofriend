const express = require('express');
const router = express.Router();
const {
  getAllChallenges,
  getChallengeById,
  createChallenge,
  joinChallenge,
  updateProgress,
  getMyChallenges,
  deactivateChallenge
} = require('../controllers/challengeController');
const { protect, authorize } = require('../middleware/auth');

// Публичные маршруты
router.get('/', getAllChallenges);
router.get('/:id', getChallengeById);

// Защищенные маршруты (требуют авторизации)
router.get('/my/all', protect, getMyChallenges);
router.post('/:id/join', protect, joinChallenge);
router.put('/:id/progress', protect, updateProgress);

// Админские маршруты
router.post('/', protect, authorize('admin', 'moderator'), createChallenge);
router.put('/:id/deactivate', protect, authorize('admin', 'moderator'), deactivateChallenge);

module.exports = router;

