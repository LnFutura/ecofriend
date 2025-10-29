const express = require('express');
const router = express.Router();
const {
  getAllNews,
  getNewsById,
  createNews,
  updateNews,
  deleteNews,
  toggleLike,
  addComment,
  getPendingNews,
  moderateNews,
  getMyNews
} = require('../controllers/newsController');
const { protect, authorize } = require('../middleware/auth');

// Публичные маршруты
router.get('/', getAllNews);
router.get('/:id', getNewsById);

// Защищенные маршруты
router.post('/', protect, createNews);
router.put('/:id', protect, updateNews);
router.delete('/:id', protect, deleteNews);
router.post('/:id/like', protect, toggleLike);
router.post('/:id/comment', protect, addComment);
router.get('/my/all', protect, getMyNews);

// Модерация (админ/модератор)
router.get('/moderation/pending', protect, authorize('admin', 'moderator'), getPendingNews);
router.put('/:id/moderate', protect, authorize('admin', 'moderator'), moderateNews);

module.exports = router;

