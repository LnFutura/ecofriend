const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../../models/User');
const Profile = require('../../models/Profile');
const { register, login, getMe } = require('../../controllers/authController');

// Mock models
jest.mock('../../models/User');
jest.mock('../../models/Profile');
jest.mock('bcryptjs');
jest.mock('jsonwebtoken');

describe('AuthController - Unit Tests', () => {
  let req, res;

  beforeEach(() => {
    req = {
      body: {},
      user: {},
    };
    res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn().mockReturnThis(),
    };
    jest.clearAllMocks();
  });

  describe('register', () => {
    it('should register a new user successfully', async () => {
      req.body = {
        email: 'test@example.com',
        username: 'testuser',
        password: 'password123',
      };

      User.findOne.mockResolvedValue(null);
      bcrypt.genSalt.mockResolvedValue('salt');
      bcrypt.hash.mockResolvedValue('hashedPassword');
      
      const mockUser = {
        _id: 'user123',
        email: 'test@example.com',
        username: 'testuser',
        save: jest.fn().mockResolvedValue(true),
      };
      User.mockImplementation(() => mockUser);

      const mockProfile = {
        save: jest.fn().mockResolvedValue(true),
      };
      Profile.mockImplementation(() => mockProfile);

      jwt.sign.mockReturnValue('mock_jwt_token');

      await register(req, res);

      expect(User.findOne).toHaveBeenCalledWith({
        $or: [{ email: 'test@example.com' }, { username: 'testuser' }],
      });
      expect(bcrypt.hash).toHaveBeenCalledWith('password123', expect.any(String));
      expect(mockUser.save).toHaveBeenCalled();
      expect(mockProfile.save).toHaveBeenCalled();
      expect(res.status).toHaveBeenCalledWith(201);
      expect(res.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: true,
          token: 'mock_jwt_token',
        })
      );
    });

    it('should return 400 if user already exists', async () => {
      req.body = {
        email: 'existing@example.com',
        username: 'existinguser',
        password: 'password123',
      };

      User.findOne.mockResolvedValue({ email: 'existing@example.com' });

      await register(req, res);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: false,
          message: expect.stringContaining('уже существует'),
        })
      );
    });

    it('should return 400 if required fields are missing', async () => {
      req.body = {
        email: 'test@example.com',
        // missing username and password
      };

      await register(req, res);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: false,
        })
      );
    });
  });

  describe('login', () => {
    it('should login user with valid credentials', async () => {
      req.body = {
        email: 'test@example.com',
        password: 'password123',
      };

      const mockUser = {
        _id: 'user123',
        email: 'test@example.com',
        username: 'testuser',
        password: 'hashedPassword',
      };

      User.findOne.mockResolvedValue(mockUser);
      bcrypt.compare.mockResolvedValue(true);
      jwt.sign.mockReturnValue('mock_jwt_token');

      await login(req, res);

      expect(User.findOne).toHaveBeenCalledWith({ email: 'test@example.com' });
      expect(bcrypt.compare).toHaveBeenCalledWith('password123', 'hashedPassword');
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: true,
          token: 'mock_jwt_token',
        })
      );
    });

    it('should return 401 for invalid credentials', async () => {
      req.body = {
        email: 'test@example.com',
        password: 'wrongpassword',
      };

      const mockUser = {
        password: 'hashedPassword',
      };

      User.findOne.mockResolvedValue(mockUser);
      bcrypt.compare.mockResolvedValue(false);

      await login(req, res);

      expect(res.status).toHaveBeenCalledWith(401);
      expect(res.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: false,
          message: expect.stringContaining('Неверные учетные данные'),
        })
      );
    });

    it('should return 401 if user not found', async () => {
      req.body = {
        email: 'nonexistent@example.com',
        password: 'password123',
      };

      User.findOne.mockResolvedValue(null);

      await login(req, res);

      expect(res.status).toHaveBeenCalledWith(401);
    });
  });

  describe('getMe', () => {
    it('should return current user profile', async () => {
      req.user = { id: 'user123' };

      const mockUser = {
        _id: 'user123',
        email: 'test@example.com',
        username: 'testuser',
        select: jest.fn().mockReturnThis(),
      };

      User.findById.mockReturnValue(mockUser);

      await getMe(req, res);

      expect(User.findById).toHaveBeenCalledWith('user123');
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(
        expect.objectContaining({
          success: true,
          data: mockUser,
        })
      );
    });

    it('should return 404 if user not found', async () => {
      req.user = { id: 'nonexistent' };

      User.findById.mockReturnValue({
        select: jest.fn().mockResolvedValue(null),
      });

      await getMe(req, res);

      expect(res.status).toHaveBeenCalledWith(404);
    });
  });
});

