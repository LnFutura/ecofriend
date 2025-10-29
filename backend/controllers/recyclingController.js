const RecyclingPoint = require('../models/RecyclingPoint');

// @desc    Получить все пункты переработки
// @route   GET /api/recycling-points
// @access  Public
exports.getAllPoints = async (req, res, next) => {
  try {
    const { city, type, verified } = req.query;
    
    const filter = {};
    
    if (city) filter.city = city;
    if (type) {
      const types = type.split(',');
      filter.type = { $in: types };
    }
    if (verified !== undefined) filter.verified = verified === 'true';

    const points = await RecyclingPoint.find(filter)
      .populate('addedBy', 'username')
      .sort({ rating: -1, createdAt: -1 });

    res.status(200).json({
      success: true,
      count: points.length,
      data: points
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Получить ближайшие пункты
// @route   GET /api/recycling-points/nearby
// @access  Public
exports.getNearbyPoints = async (req, res, next) => {
  try {
    const { lat, lng, radius, type } = req.query;

    if (!lat || !lng) {
      return res.status(400).json({
        success: false,
        message: 'Координаты (lat, lng) обязательны'
      });
    }

    const latitude = parseFloat(lat);
    const longitude = parseFloat(lng);
    const maxDistance = radius ? parseInt(radius) : 5000; // по умолчанию 5 км

    const types = type ? type.split(',') : null;

    const points = await RecyclingPoint.findNearby(
      longitude,
      latitude,
      maxDistance,
      types
    ).populate('addedBy', 'username');

    res.status(200).json({
      success: true,
      count: points.length,
      data: points
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Получить конкретный пункт
// @route   GET /api/recycling-points/:id
// @access  Public
exports.getPointById = async (req, res, next) => {
  try {
    const point = await RecyclingPoint.findById(req.params.id)
      .populate('addedBy', 'username')
      .populate('reviews.user', 'username');

    if (!point) {
      return res.status(404).json({
        success: false,
        message: 'Пункт переработки не найден'
      });
    }

    res.status(200).json({
      success: true,
      data: point
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Добавить пункт переработки
// @route   POST /api/recycling-points
// @access  Private
exports.createPoint = async (req, res, next) => {
  try {
    const pointData = {
      ...req.body,
      addedBy: req.user.id,
      verified: false // требует верификации
    };

    // Проверяем, что координаты в правильном формате [longitude, latitude]
    if (!pointData.coordinates || !pointData.coordinates.coordinates || 
        pointData.coordinates.coordinates.length !== 2) {
      return res.status(400).json({
        success: false,
        message: 'Координаты должны быть в формате {coordinates: [longitude, latitude]}'
      });
    }

    const point = await RecyclingPoint.create(pointData);

    res.status(201).json({
      success: true,
      message: 'Пункт добавлен и отправлен на верификацию',
      data: point
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Обновить пункт
// @route   PUT /api/recycling-points/:id
// @access  Private
exports.updatePoint = async (req, res, next) => {
  try {
    let point = await RecyclingPoint.findById(req.params.id);

    if (!point) {
      return res.status(404).json({
        success: false,
        message: 'Пункт не найден'
      });
    }

    // Проверка прав
    if (point.addedBy && point.addedBy.toString() !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Нет прав для редактирования'
      });
    }

    point = await RecyclingPoint.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true
    });

    res.status(200).json({
      success: true,
      data: point
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Удалить пункт
// @route   DELETE /api/recycling-points/:id
// @access  Private (Admin)
exports.deletePoint = async (req, res, next) => {
  try {
    const point = await RecyclingPoint.findById(req.params.id);

    if (!point) {
      return res.status(404).json({
        success: false,
        message: 'Пункт не найден'
      });
    }

    await point.deleteOne();

    res.status(200).json({
      success: true,
      message: 'Пункт удален'
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Добавить отзыв
// @route   POST /api/recycling-points/:id/review
// @access  Private
exports.addReview = async (req, res, next) => {
  try {
    const { rating, comment } = req.body;

    if (!rating || rating < 1 || rating > 5) {
      return res.status(400).json({
        success: false,
        message: 'Рейтинг должен быть от 1 до 5'
      });
    }

    const point = await RecyclingPoint.findById(req.params.id);

    if (!point) {
      return res.status(404).json({
        success: false,
        message: 'Пункт не найден'
      });
    }

    await point.addReview(req.user.id, rating, comment);

    const updatedPoint = await RecyclingPoint.findById(req.params.id)
      .populate('reviews.user', 'username');

    res.status(200).json({
      success: true,
      message: 'Отзыв добавлен',
      data: updatedPoint
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Верифицировать пункт
// @route   PUT /api/recycling-points/:id/verify
// @access  Private (Admin/Moderator)
exports.verifyPoint = async (req, res, next) => {
  try {
    const point = await RecyclingPoint.findByIdAndUpdate(
      req.params.id,
      { verified: true },
      { new: true }
    );

    if (!point) {
      return res.status(404).json({
        success: false,
        message: 'Пункт не найден'
      });
    }

    res.status(200).json({
      success: true,
      message: 'Пункт верифицирован',
      data: point
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Получить типы отходов
// @route   GET /api/recycling-points/types
// @access  Public
exports.getWasteTypes = async (req, res, next) => {
  try {
    const types = [
      { value: 'plastic', label: 'Пластик', icon: '♻️' },
      { value: 'glass', label: 'Стекло', icon: '🍾' },
      { value: 'paper', label: 'Бумага', icon: '📄' },
      { value: 'metal', label: 'Металл', icon: '🔩' },
      { value: 'electronics', label: 'Электроника', icon: '💻' },
      { value: 'batteries', label: 'Батарейки', icon: '🔋' },
      { value: 'clothes', label: 'Одежда', icon: '👕' },
      { value: 'hazardous', label: 'Опасные отходы', icon: '⚠️' },
      { value: 'organic', label: 'Органика', icon: '🍂' }
    ];

    res.status(200).json({
      success: true,
      data: types
    });
  } catch (error) {
    next(error);
  }
};

