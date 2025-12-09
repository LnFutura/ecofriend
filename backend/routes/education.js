const express = require('express');
const router = express.Router();
const {
  getAllCourses,
  getCourseById,
  createCourse,
  updateCourse,
  deleteCourse,
  enrollCourse,
  completeCourse,
  getCourseQuiz,
  getQuizById,
  submitQuiz,
  addCourseReview
} = require('../controllers/educationController');
const { protect, authorize } = require('../middleware/auth');

// Публичные маршруты
router.get('/courses', getAllCourses);
router.get('/courses/:id', getCourseById);

// Защищенные маршруты
router.post('/courses/:id/enroll', protect, enrollCourse);
router.post('/courses/:id/complete', protect, completeCourse);
router.get('/courses/:id/quiz', protect, getCourseQuiz);
router.get('/quiz/:id', protect, getQuizById);
router.post('/courses/:id/quiz/submit', protect, submitQuiz);
router.post('/courses/:id/review', protect, addCourseReview);

// Маршруты для организаций и админов
router.post('/courses', protect, authorize('organization', 'admin'), createCourse);
router.put('/courses/:id', protect, updateCourse);
router.delete('/courses/:id', protect, deleteCourse);

module.exports = router;

