const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const {
  getProfile,
  getMyProfile,
  updateProfile,
  addPoints,
  getLeaderboard,
} = require('../controllers/profileController');
const { protect } = require('../middleware/auth');
const validate = require('../middleware/validation');

// Validation rules
const updateProfileValidation = [
  body('fullName')
    .optional()
    .trim()
    .isLength({ max: 100 })
    .withMessage('Full name cannot exceed 100 characters'),
  body('bio')
    .optional()
    .trim()
    .isLength({ max: 500 })
    .withMessage('Bio cannot exceed 500 characters'),
  body('avatar')
    .optional()
    .isURL()
    .withMessage('Avatar must be a valid URL'),
];

const addPointsValidation = [
  body('points')
    .isInt({ min: 1 })
    .withMessage('Points must be a positive integer'),
];

// Routes
router.get('/leaderboard', getLeaderboard);
router.get('/me', protect, getMyProfile);
router.get('/:id', getProfile);
router.put('/', protect, updateProfileValidation, validate, updateProfile);
router.post('/points', protect, addPointsValidation, validate, addPoints);

module.exports = router;

