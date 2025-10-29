const News = require('../models/News');

// @desc    Получить все новости
// @route   GET /api/news
// @access  Public
exports.getAllNews = async (req, res, next) => {
  try {
    const { category, tag } = req.query;
    
    const filter = { status: 'approved' }; // только одобренные
    
    if (category) filter.category = category;
    if (tag) filter.tags = tag;

    const news = await News.find(filter)
      .populate('author', 'username')
      .sort({ publishedAt: -1 })
      .limit(50);

    res.status(200).json({
      success: true,
      count: news.length,
      data: news
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Получить конкретную новость
// @route   GET /api/news/:id
// @access  Public
exports.getNewsById = async (req, res, next) => {
  try {
    const news = await News.findById(req.params.id)
      .populate('author', 'username')
      .populate('comments.user', 'username');

    if (!news) {
      return res.status(404).json({
        success: false,
        message: 'Новость не найдена'
      });
    }

    // Увеличиваем просмотры
    await news.incrementViews();

    res.status(200).json({
      success: true,
      data: news
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Создать новость
// @route   POST /api/news
// @access  Private
exports.createNews = async (req, res, next) => {
  try {
    const newsData = {
      ...req.body,
      author: req.user.id,
      status: 'pending' // требует модерации
    };

    const news = await News.create(newsData);

    res.status(201).json({
      success: true,
      message: 'Новость создана и отправлена на модерацию',
      data: news
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Обновить новость
// @route   PUT /api/news/:id
// @access  Private
exports.updateNews = async (req, res, next) => {
  try {
    let news = await News.findById(req.params.id);

    if (!news) {
      return res.status(404).json({
        success: false,
        message: 'Новость не найдена'
      });
    }

    // Проверка прав
    if (news.author.toString() !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Нет прав для редактирования'
      });
    }

    // При обновлении статус возвращается в pending
    const updateData = {
      ...req.body,
      status: 'pending'
    };

    news = await News.findByIdAndUpdate(req.params.id, updateData, {
      new: true,
      runValidators: true
    });

    res.status(200).json({
      success: true,
      message: 'Новость обновлена и отправлена на модерацию',
      data: news
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Удалить новость
// @route   DELETE /api/news/:id
// @access  Private
exports.deleteNews = async (req, res, next) => {
  try {
    const news = await News.findById(req.params.id);

    if (!news) {
      return res.status(404).json({
        success: false,
        message: 'Новость не найдена'
      });
    }

    // Проверка прав
    if (news.author.toString() !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Нет прав для удаления'
      });
    }

    await news.deleteOne();

    res.status(200).json({
      success: true,
      message: 'Новость удалена'
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Лайкнуть/убрать лайк
// @route   POST /api/news/:id/like
// @access  Private
exports.toggleLike = async (req, res, next) => {
  try {
    const news = await News.findById(req.params.id);

    if (!news) {
      return res.status(404).json({
        success: false,
        message: 'Новость не найдена'
      });
    }

    await news.toggleLike(req.user.id);

    res.status(200).json({
      success: true,
      message: 'Лайк обновлен',
      data: {
        likes: news.likes.length,
        isLiked: news.likes.includes(req.user.id)
      }
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Добавить комментарий
// @route   POST /api/news/:id/comment
// @access  Private
exports.addComment = async (req, res, next) => {
  try {
    const { text } = req.body;

    if (!text || text.trim().length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Текст комментария обязателен'
      });
    }

    const news = await News.findById(req.params.id);

    if (!news) {
      return res.status(404).json({
        success: false,
        message: 'Новость не найдена'
      });
    }

    await news.addComment(req.user.id, text);

    const updatedNews = await News.findById(req.params.id)
      .populate('comments.user', 'username');

    res.status(200).json({
      success: true,
      message: 'Комментарий добавлен',
      data: updatedNews.comments
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Получить новости на модерации
// @route   GET /api/news/moderation/pending
// @access  Private (Admin/Moderator)
exports.getPendingNews = async (req, res, next) => {
  try {
    const news = await News.find({ status: 'pending' })
      .populate('author', 'username email')
      .sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      count: news.length,
      data: news
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Модерировать новость
// @route   PUT /api/news/:id/moderate
// @access  Private (Admin/Moderator)
exports.moderateNews = async (req, res, next) => {
  try {
    const { status, moderationNote } = req.body;

    if (!['approved', 'rejected'].includes(status)) {
      return res.status(400).json({
        success: false,
        message: 'Статус должен быть approved или rejected'
      });
    }

    const news = await News.findById(req.params.id);

    if (!news) {
      return res.status(404).json({
        success: false,
        message: 'Новость не найдена'
      });
    }

    news.status = status;
    news.moderator = req.user.id;
    news.moderationNote = moderationNote;
    
    if (status === 'approved' && !news.publishedAt) {
      news.publishedAt = new Date();
    }

    await news.save();

    res.status(200).json({
      success: true,
      message: `Новость ${status === 'approved' ? 'одобрена' : 'отклонена'}`,
      data: news
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Получить мои новости
// @route   GET /api/news/my/all
// @access  Private
exports.getMyNews = async (req, res, next) => {
  try {
    const news = await News.find({ author: req.user.id })
      .sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      count: news.length,
      data: news
    });
  } catch (error) {
    next(error);
  }
};

