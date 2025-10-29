const express = require('express');
const router = express.Router();
const {
  getAllEvents,
  getEventById,
  createEvent,
  updateEvent,
  deleteEvent,
  registerForEvent,
  unregisterFromEvent,
  markAttendance,
  getCalendar,
  getMyEvents,
  moderateEvent
} = require('../controllers/eventController');
const { protect, authorize } = require('../middleware/auth');

// Публичные маршруты
router.get('/', getAllEvents);
router.get('/calendar', getCalendar);
router.get('/:id', getEventById);

// Защищенные маршруты
router.post('/', protect, createEvent);
router.put('/:id', protect, updateEvent);
router.delete('/:id', protect, deleteEvent);
router.post('/:id/register', protect, registerForEvent);
router.delete('/:id/register', protect, unregisterFromEvent);
router.post('/:id/attend', protect, markAttendance);
router.get('/my/all', protect, getMyEvents);

// Модерация (админ/модератор)
router.put('/:id/moderate', protect, authorize('admin', 'moderator'), moderateEvent);

module.exports = router;

