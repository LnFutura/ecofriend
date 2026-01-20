const User = require('../models/User');
const Profile = require('../models/Profile');
const Achievement = require('../models/Achievement');
const generateToken = require('../utils/generateToken');

// @desc    Register new user
// @route   POST /api/auth/register
// @access  Public
const register = async (req, res, next) => {
  try {
    const { email, username, password, role } = req.body;

    // Check if user already exists
    const userExists = await User.findOne({
      $or: [{ email }, { username }],
    });

    if (userExists) {
      return res.status(400).json({
        message: 'User with this email or username already exists',
      });
    }

    // Create user
    const user = await User.create({
      email,
      username,
      password,
      role: role || 'user',
    });

    // Get registration achievements for new users (Суслент + Рыбовой)
    const registrationAchievements = await Achievement.find({ 
      conditionType: 'registration' 
    });

    // Create profile for user with registration achievements
    const profileData = {
      user: user._id,
    };
    
    if (registrationAchievements.length > 0) {
      profileData.achievements = registrationAchievements.map(a => ({
        achievement: a._id,
        unlockedAt: new Date()
      }));
      profileData.points = registrationAchievements.reduce((sum, a) => sum + a.points, 0);
    }

    const profile = await Profile.create(profileData);

    // Link profile to user
    user.profile = profile._id;
    await user.save();

    // Generate token
    const token = generateToken(user._id);

    res.status(201).json({
      message: 'User registered successfully',
      token,
      user: {
        id: user._id,
        email: user.email,
        username: user.username,
        role: user.role,
        profile: profile._id,
      },
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Login user
// @route   POST /api/auth/login
// @access  Public
const login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    // Check for user (include password for comparison)
    const user = await User.findOne({ email }).select('+password');

    if (!user) {
      return res.status(401).json({
        message: 'Invalid credentials',
      });
    }

    // Check password
    const isMatch = await user.matchPassword(password);

    if (!isMatch) {
      return res.status(401).json({
        message: 'Invalid credentials',
      });
    }

    // Generate token
    const token = generateToken(user._id);

    res.json({
      message: 'Login successful',
      token,
      user: {
        id: user._id,
        email: user.email,
        username: user.username,
        role: user.role,
        profile: user.profile,
      },
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Get current user
// @route   GET /api/auth/me
// @access  Private
const getMe = async (req, res, next) => {
  try {
    const user = await User.findById(req.user._id).populate('profile');

    res.json({
      user: {
        id: user._id,
        email: user.email,
        username: user.username,
        role: user.role,
        profile: user.profile,
        isVerified: user.isVerified,
        createdAt: user.createdAt,
      },
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  register,
  login,
  getMe,
};

