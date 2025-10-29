const express = require('express');
const router = express.Router();
const {
  getAllPoints,
  getNearbyPoints,
  getPointById,
  createPoint,
  updatePoint,
  deletePoint,
  addReview,
  verifyPoint,
  getWasteTypes
} = require('../controllers/recyclingController');
const { protect, authorize } = require('../middleware/auth');

// Публичные маршруты
router.get('/', getAllPoints);
router.get('/nearby', getNearbyPoints);
router.get('/types', getWasteTypes);
router.get('/:id', getPointById);

// Защищенные маршруты
router.post('/', protect, createPoint);
router.put('/:id', protect, updatePoint);
router.post('/:id/review', protect, addReview);

// Админские маршруты
router.delete('/:id', protect, authorize('admin', 'moderator'), deletePoint);
router.put('/:id/verify', protect, authorize('admin', 'moderator'), verifyPoint);

module.exports = router;

