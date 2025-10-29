const Event = require('../models/Event');
const Profile = require('../models/Profile');

// @desc    Получить все события
// @route   GET /api/events
// @access  Public
exports.getAllEvents = async (req, res, next) => {
  try {
    const { type, city, upcoming } = req.query;
    
    const filter = { status: 'approved' };
    
    if (type) filter.type = type;
    if (city) filter['location.city'] = city;
    
    // Только предстоящие события
    if (upcoming === 'true') {
      filter.date = { $gte: new Date() };
    }

    const events = await Event.find(filter)
      .populate('organizer', 'username')
      .sort({ date: 1 });

    res.status(200).json({
      success: true,
      count: events.length,
      data: events
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Получить конкретное событие
// @route   GET /api/events/:id
// @access  Public
exports.getEventById = async (req, res, next) => {
  try {
    const event = await Event.findById(req.params.id)
      .populate('organizer', 'username')
      .populate('registered', 'username');

    if (!event) {
      return res.status(404).json({
        success: false,
        message: 'Событие не найдено'
      });
    }

    res.status(200).json({
      success: true,
      data: event
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Создать событие
// @route   POST /api/events
// @access  Private (Org/Admin)
exports.createEvent = async (req, res, next) => {
  try {
    const eventData = {
      ...req.body,
      organizer: req.user.id,
      status: 'pending' // требует модерации
    };

    const event = await Event.create(eventData);

    res.status(201).json({
      success: true,
      message: 'Событие создано и отправлено на модерацию',
      data: event
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Обновить событие
// @route   PUT /api/events/:id
// @access  Private
exports.updateEvent = async (req, res, next) => {
  try {
    let event = await Event.findById(req.params.id);

    if (!event) {
      return res.status(404).json({
        success: false,
        message: 'Событие не найдено'
      });
    }

    // Проверка прав
    if (event.organizer.toString() !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Нет прав для редактирования'
      });
    }

    event = await Event.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true
    });

    res.status(200).json({
      success: true,
      data: event
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Удалить событие
// @route   DELETE /api/events/:id
// @access  Private
exports.deleteEvent = async (req, res, next) => {
  try {
    const event = await Event.findById(req.params.id);

    if (!event) {
      return res.status(404).json({
        success: false,
        message: 'Событие не найдено'
      });
    }

    // Проверка прав
    if (event.organizer.toString() !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Нет прав для удаления'
      });
    }

    await event.deleteOne();

    res.status(200).json({
      success: true,
      message: 'Событие удалено'
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Зарегистрироваться на событие
// @route   POST /api/events/:id/register
// @access  Private
exports.registerForEvent = async (req, res, next) => {
  try {
    const event = await Event.findById(req.params.id);

    if (!event) {
      return res.status(404).json({
        success: false,
        message: 'Событие не найдено'
      });
    }

    try {
      await event.registerUser(req.user.id);

      res.status(200).json({
        success: true,
        message: 'Вы зарегистрированы на событие!',
        data: {
          registeredCount: event.registered.length,
          capacity: event.capacity
        }
      });
    } catch (error) {
      return res.status(400).json({
        success: false,
        message: error.message
      });
    }
  } catch (error) {
    next(error);
  }
};

// @desc    Отменить регистрацию
// @route   DELETE /api/events/:id/register
// @access  Private
exports.unregisterFromEvent = async (req, res, next) => {
  try {
    const event = await Event.findById(req.params.id);

    if (!event) {
      return res.status(404).json({
        success: false,
        message: 'Событие не найдено'
      });
    }

    await event.unregisterUser(req.user.id);

    res.status(200).json({
      success: true,
      message: 'Регистрация отменена'
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Отметить посещение
// @route   POST /api/events/:id/attend
// @access  Private
exports.markAttendance = async (req, res, next) => {
  try {
    const event = await Event.findById(req.params.id);

    if (!event) {
      return res.status(404).json({
        success: false,
        message: 'Событие не найдено'
      });
    }

    try {
      await event.markAttendance(req.user.id);

      // Начисляем очки за посещение
      const profile = await Profile.findOne({ user: req.user.id });
      if (profile) {
        profile.points += event.points;
        profile.attendedEvents.push(event._id);
        await profile.save();
      }

      res.status(200).json({
        success: true,
        message: 'Посещение отмечено! Очки начислены.',
        data: {
          earnedPoints: event.points,
          totalPoints: profile.points
        }
      });
    } catch (error) {
      return res.status(400).json({
        success: false,
        message: error.message
      });
    }
  } catch (error) {
    next(error);
  }
};

// @desc    Получить календарь событий
// @route   GET /api/events/calendar
// @access  Public
exports.getCalendar = async (req, res, next) => {
  try {
    const { month, year } = req.query;
    
    let startDate, endDate;
    
    if (month && year) {
      startDate = new Date(year, month - 1, 1);
      endDate = new Date(year, month, 0);
    } else {
      // По умолчанию текущий месяц
      const now = new Date();
      startDate = new Date(now.getFullYear(), now.getMonth(), 1);
      endDate = new Date(now.getFullYear(), now.getMonth() + 1, 0);
    }

    const events = await Event.find({
      status: 'approved',
      date: { $gte: startDate, $lte: endDate }
    })
      .populate('organizer', 'username')
      .sort({ date: 1 });

    res.status(200).json({
      success: true,
      count: events.length,
      data: events
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Получить мои события
// @route   GET /api/events/my/all
// @access  Private
exports.getMyEvents = async (req, res, next) => {
  try {
    // События, где пользователь организатор или зарегистрирован
    const organized = await Event.find({ organizer: req.user.id });
    const registered = await Event.find({ registered: req.user.id });

    res.status(200).json({
      success: true,
      data: {
        organized,
        registered
      }
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Модерировать событие
// @route   PUT /api/events/:id/moderate
// @access  Private (Admin/Moderator)
exports.moderateEvent = async (req, res, next) => {
  try {
    const { status } = req.body;

    if (!['approved', 'cancelled'].includes(status)) {
      return res.status(400).json({
        success: false,
        message: 'Статус должен быть approved или cancelled'
      });
    }

    const event = await Event.findByIdAndUpdate(
      req.params.id,
      { status },
      { new: true }
    );

    if (!event) {
      return res.status(404).json({
        success: false,
        message: 'Событие не найдено'
      });
    }

    res.status(200).json({
      success: true,
      message: `Событие ${status === 'approved' ? 'одобрено' : 'отменено'}`,
      data: event
    });
  } catch (error) {
    next(error);
  }
};

