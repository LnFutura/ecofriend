const Profile = require('../models/Profile');
const User = require('../models/User');
const path = require('path');
const fs = require('fs');

// @desc    Get profile by user ID
// @route   GET /api/profile/:id
// @access  Public
const getProfile = async (req, res, next) => {
  try {
    const profile = await Profile.findOne({ user: req.params.id })
      .populate('user', 'username email role')
      .populate('achievements')
      .populate('completedCourses', 'title')
      .populate('attendedEvents', 'title date');

    if (!profile) {
      return res.status(404).json({ message: 'Profile not found' });
    }

    res.json({ profile });
  } catch (error) {
    next(error);
  }
};

// @desc    Get current user's profile
// @route   GET /api/profile/me
// @access  Private
const getMyProfile = async (req, res, next) => {
  try {
    const profile = await Profile.findOne({ user: req.user._id })
      .populate('user', 'username email role')
      .populate('achievements')
      .populate('completedCourses', 'title')
      .populate('attendedEvents', 'title date');

    if (!profile) {
      return res.status(404).json({ message: 'Profile not found' });
    }

    res.json({ profile });
  } catch (error) {
    next(error);
  }
};

// @desc    Update profile
// @route   PUT /api/profile
// @access  Private
const updateProfile = async (req, res, next) => {
  try {
    const { fullName, bio, avatar, location } = req.body;

    const profile = await Profile.findOne({ user: req.user._id });

    if (!profile) {
      return res.status(404).json({ message: 'Profile not found' });
    }

    // Update fields
    if (fullName !== undefined) profile.fullName = fullName;
    if (bio !== undefined) profile.bio = bio;
    if (avatar !== undefined) profile.avatar = avatar;
    if (location !== undefined) {
      profile.location = {
        city: location.city,
        country: location.country,
        coordinates: location.coordinates,
      };
    }

    await profile.save();

    res.json({
      message: 'Profile updated successfully',
      profile,
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Add points to profile
// @route   POST /api/profile/points
// @access  Private (or Admin)
const addPoints = async (req, res, next) => {
  try {
    const { points } = req.body;

    if (!points || points <= 0) {
      return res.status(400).json({ message: 'Invalid points amount' });
    }

    const profile = await Profile.findOne({ user: req.user._id });

    if (!profile) {
      return res.status(404).json({ message: 'Profile not found' });
    }

    await profile.addPoints(points);

    res.json({
      message: 'Points added successfully',
      points: profile.points,
      level: profile.level,
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Get leaderboard
// @route   GET /api/profile/leaderboard
// @access  Public
const getLeaderboard = async (req, res, next) => {
  try {
    const limit = parseInt(req.query.limit) || 50;
    const page = parseInt(req.query.page) || 1;
    const skip = (page - 1) * limit;

    const profiles = await Profile.find()
      .sort({ points: -1, level: -1 })
      .limit(limit)
      .skip(skip)
      .populate('user', 'username avatar')
      .select('fullName avatar points level user');

    const total = await Profile.countDocuments();

    res.json({
      leaderboard: profiles,
      pagination: {
        total,
        page,
        pages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Upload avatar
// @route   POST /api/profile/avatar
// @access  Private
const uploadAvatar = async (req, res, next) => {
  try {
    if (!req.file) {
      return res.status(400).json({ message: 'No file uploaded' });
    }

    const profile = await Profile.findOne({ user: req.user._id });
    if (!profile) {
      return res.status(404).json({ message: 'Profile not found' });
    }

    // Удалить старый аватар если есть
    if (profile.avatar && profile.avatar.startsWith('/uploads/')) {
      const oldPath = path.join(__dirname, '..', profile.avatar);
      if (fs.existsSync(oldPath)) {
        fs.unlinkSync(oldPath);
      }
    }

    // Сохранить путь к новому аватару
    profile.avatar = `/uploads/avatars/${req.file.filename}`;
    await profile.save();

    res.json({
      success: true,
      message: 'Avatar uploaded successfully',
      avatar: profile.avatar
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Delete avatar
// @route   DELETE /api/profile/avatar
// @access  Private
const deleteAvatar = async (req, res, next) => {
  try {
    const profile = await Profile.findOne({ user: req.user._id });
    if (!profile) {
      return res.status(404).json({ message: 'Profile not found' });
    }

    // Удалить файл
    if (profile.avatar && profile.avatar.startsWith('/uploads/')) {
      const filePath = path.join(__dirname, '..', profile.avatar);
      if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);
      }
    }

    profile.avatar = null;
    await profile.save();

    res.json({
      success: true,
      message: 'Avatar deleted successfully'
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getProfile,
  getMyProfile,
  updateProfile,
  addPoints,
  getLeaderboard,
  uploadAvatar,
  deleteAvatar,
};

