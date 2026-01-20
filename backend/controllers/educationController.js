const Course = require('../models/Course');
const Quiz = require('../models/Quiz');
const Profile = require('../models/Profile');

// @desc    Получить все курсы
// @route   GET /api/education/courses
// @access  Public
exports.getAllCourses = async (req, res, next) => {
  try {
    const { category, level, published } = req.query;
    
    const filter = {};
    if (category) filter.category = category;
    if (level) filter.level = level;
    if (published !== undefined) filter.published = published === 'true';
    else filter.published = true; // по умолчанию только опубликованные

    const courses = await Course.find(filter)
      .populate('author', 'username')
      .sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      count: courses.length,
      data: courses
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Получить конкретный курс
// @route   GET /api/education/courses/:id
// @access  Public
exports.getCourseById = async (req, res, next) => {
  try {
    const course = await Course.findById(req.params.id)
      .populate('author', 'username')
      .populate('quiz');

    if (!course) {
      return res.status(404).json({
        success: false,
        message: 'Курс не найден'
      });
    }

    res.status(200).json({
      success: true,
      data: course
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Создать новый курс
// @route   POST /api/education/courses
// @access  Private (Org/Admin)
exports.createCourse = async (req, res, next) => {
  try {
    const courseData = {
      ...req.body,
      author: req.user.id
    };

    const course = await Course.create(courseData);

    res.status(201).json({
      success: true,
      data: course
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Обновить курс
// @route   PUT /api/education/courses/:id
// @access  Private (Author/Admin)
exports.updateCourse = async (req, res, next) => {
  try {
    let course = await Course.findById(req.params.id);

    if (!course) {
      return res.status(404).json({
        success: false,
        message: 'Курс не найден'
      });
    }

    // Проверка прав (автор или admin)
    if (course.author.toString() !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Нет прав для редактирования этого курса'
      });
    }

    course = await Course.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true
    });

    res.status(200).json({
      success: true,
      data: course
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Удалить курс
// @route   DELETE /api/education/courses/:id
// @access  Private (Author/Admin)
exports.deleteCourse = async (req, res, next) => {
  try {
    const course = await Course.findById(req.params.id);

    if (!course) {
      return res.status(404).json({
        success: false,
        message: 'Курс не найден'
      });
    }

    // Проверка прав
    if (course.author.toString() !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Нет прав для удаления этого курса'
      });
    }

    await course.deleteOne();

    res.status(200).json({
      success: true,
      message: 'Курс удален'
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Записаться на курс
// @route   POST /api/education/courses/:id/enroll
// @access  Private
exports.enrollCourse = async (req, res, next) => {
  try {
    const course = await Course.findById(req.params.id);

    if (!course) {
      return res.status(404).json({
        success: false,
        message: 'Курс не найден'
      });
    }

    const profile = await Profile.findOne({ user: req.user.id });

    if (!profile) {
      return res.status(404).json({
        success: false,
        message: 'Профиль не найден'
      });
    }

    // Проверяем, не записан ли уже
    if (profile.completedCourses.includes(course._id)) {
      return res.status(400).json({
        success: false,
        message: 'Вы уже прошли этот курс'
      });
    }

    course.enrolledCount += 1;
    await course.save();

    res.status(200).json({
      success: true,
      message: 'Вы записаны на курс!',
      data: course
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Завершить курс
// @route   POST /api/education/courses/:id/complete
// @access  Private
exports.completeCourse = async (req, res, next) => {
  try {
    const course = await Course.findById(req.params.id);

    if (!course) {
      return res.status(404).json({
        success: false,
        message: 'Курс не найден'
      });
    }

    const profile = await Profile.findOne({ user: req.user.id });

    if (!profile) {
      return res.status(404).json({
        success: false,
        message: 'Профиль не найден'
      });
    }

    // Проверяем, не завершен ли уже
    if (profile.completedCourses.includes(course._id)) {
      return res.status(400).json({
        success: false,
        message: 'Вы уже завершили этот курс'
      });
    }

    // Добавляем курс в завершенные и начисляем очки
    profile.completedCourses.push(course._id);
    profile.points += course.points;

    await profile.save();

    // Проверяем достижения за курсы
    const { checkCourseAchievements } = require('./achievementController');
    await checkCourseAchievements(req.user.id);

    res.status(200).json({
      success: true,
      message: 'Курс завершен! Поздравляем!',
      data: {
        earnedPoints: course.points,
        totalPoints: profile.points
      }
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Получить тест курса
// @route   GET /api/education/courses/:id/quiz
// @access  Private
exports.getCourseQuiz = async (req, res, next) => {
  try {
    const course = await Course.findById(req.params.id).populate('quiz');

    if (!course) {
      return res.status(404).json({
        success: false,
        message: 'Курс не найден'
      });
    }

    if (!course.quiz) {
      return res.status(404).json({
        success: false,
        message: 'У этого курса нет теста'
      });
    }

    // Не показываем правильные ответы
    const quizData = course.quiz.toObject();
    quizData.questions = quizData.questions.map(q => ({
      question: q.question,
      type: q.type,
      options: q.options,
      points: q.points
    }));

    res.status(200).json({
      success: true,
      data: quizData
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Получить тест по ID
// @route   GET /api/education/quiz/:id
// @access  Private
exports.getQuizById = async (req, res, next) => {
  try {
    const quiz = await Quiz.findById(req.params.id);

    if (!quiz) {
      return res.status(404).json({
        success: false,
        message: 'Тест не найден'
      });
    }

    // Отправляем правильные ответы (для образовательного приложения это нормально)
    const quizData = quiz.toObject();
    quizData.questions = quizData.questions.map(q => ({
      question: q.question,
      type: q.type,
      options: q.options,
      correctAnswer: q.correctAnswer, // Теперь отправляем правильный ответ
      points: q.points
    }));

    res.status(200).json({
      success: true,
      data: quizData
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Отправить ответы на тест
// @route   POST /api/education/courses/:id/quiz/submit
// @access  Private
exports.submitQuiz = async (req, res, next) => {
  try {
    const { answers } = req.body;

    if (!answers || !Array.isArray(answers)) {
      return res.status(400).json({
        success: false,
        message: 'Ответы обязательны'
      });
    }

    const course = await Course.findById(req.params.id).populate('quiz');

    if (!course || !course.quiz) {
      return res.status(404).json({
        success: false,
        message: 'Курс или тест не найден'
      });
    }

    const result = course.quiz.checkAnswers(answers);

    // Выдаём звание "Сурикант" за прохождение теста
    const { checkQuizAchievements } = require('./achievementController');
    await checkQuizAchievements(req.user.id);

    res.status(200).json({
      success: true,
      data: result
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Добавить отзыв на курс
// @route   POST /api/education/courses/:id/review
// @access  Private
exports.addCourseReview = async (req, res, next) => {
  try {
    const { rating, comment } = req.body;

    if (!rating || rating < 1 || rating > 5) {
      return res.status(400).json({
        success: false,
        message: 'Рейтинг должен быть от 1 до 5'
      });
    }

    const course = await Course.findById(req.params.id);

    if (!course) {
      return res.status(404).json({
        success: false,
        message: 'Курс не найден'
      });
    }

    // Проверяем, не оставлял ли уже отзыв
    const existingReview = course.reviews.find(
      r => r.user.toString() === req.user.id
    );

    if (existingReview) {
      existingReview.rating = rating;
      existingReview.comment = comment;
    } else {
      course.reviews.push({
        user: req.user.id,
        rating,
        comment
      });
    }

    await course.calculateAverageRating();

    res.status(200).json({
      success: true,
      message: 'Отзыв добавлен',
      data: course
    });
  } catch (error) {
    next(error);
  }
};

